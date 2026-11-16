import { lerJson, responder, tratarErro, ErroHttp } from '../utils/http.js';
import { executarOperacao } from '../services/provas.js';

const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const idValido = valor => Number.isSafeInteger(valor) && valor > 0;

export async function continuidadeRoutes(req, res, pathname, db) {
  const inicio = /^\/api\/tentativas\/?$/.test(pathname);
  const atual = /^\/api\/tentativas\/atual\/?$/.test(pathname);
  const match = pathname.match(/^\/api\/tentativas\/([1-9]\d*)(?:\/(proxima-questao|respostas|finalizar|pausar|retomar|interromper|presenca))?\/?$/);
  if (!inicio && !atual && !match) return false;
  try {
    if (!idValido(req.usuario?.id)) throw new ErroHttp(401);
    const acao = inicio ? 'iniciar' : atual ? 'atual' : ({
      'proxima-questao': 'proxima', respostas: 'responder', finalizar: 'finalizar',
      pausar: 'pausar', retomar: 'retomar', interromper: 'interromper', presenca: 'presenca',
    }[match[2]] || 'estado');
    const metodo = ['atual', 'estado', 'proxima'].includes(acao) ? 'GET' : 'POST';
    if (req.method !== metodo) {
      responder(res, 405, { erro: 'Método HTTP não permitido.' }, { Allow: metodo });
      return true;
    }
    const tentativa = match ? Number(match[1]) : null;
    if (match && !idValido(tentativa)) throw new ErroHttp(400, 'Tentativa inválida.');
    const body = req.method === 'POST' ? await lerJson(req) : {};
    const sessao = body.sessao ?? req.headers?.['x-sessao-prova'];
    if (acao !== 'atual' && !uuid.test(sessao ?? '')) throw new ErroHttp(400, 'Sessão da prova inválida.');
    if (acao === 'responder' && (!idValido(body.questoes_idquestoes) || !idValido(body.alternativas_idalternativas))) {
      throw new ErroHttp(400, 'Questão e alternativa devem ser IDs inteiros positivos.');
    }
    if (acao === 'interromper' && !idValido(body.questoes_idquestoes)) throw new ErroHttp(400, 'Questão inválida.');
    if (acao === 'interromper' && !['CONEXAO', 'FECHAMENTO'].includes(body.motivo)) throw new ErroHttp(400, 'Motivo inválido.');
    const resultado = await executarOperacao(db, 'operar_continuidade_prova', {
      p_usuario: req.usuario.id, p_acao: acao, p_tentativa: tentativa,
      p_sessao: sessao ?? null, p_questao: body.questoes_idquestoes ?? null,
      p_alternativa: body.alternativas_idalternativas ?? null, p_motivo: body.motivo ?? null,
    });
    responder(res, ['iniciar', 'responder'].includes(acao) ? 201 : 200, resultado, { 'Cache-Control': 'no-store' });
  } catch (error) { tratarErro(res, error); }
  return true;
}
