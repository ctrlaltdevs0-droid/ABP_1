import { lerJson, responder, tratarErro } from '../utils/http.js';
import { executarOperacao } from '../services/provas.js';

export async function tentativasRoutes(req, res, pathname, db) {
  const iniciar = /^\/api\/tentativas\/?$/.test(pathname);
  const rota = pathname.match(/^\/api\/tentativas\/([1-9]\d*)(?:\/(proxima-questao|respostas|finalizar))?\/?$/);
  if (!iniciar && !rota) return false;
  try {
    if (iniciar && req.method === 'POST') {
      // O dono sempre vem da autenticação, inclusive para administradores.
      const data = await executarOperacao(db, 'iniciar_prova', { p_usuario: req.usuario.id });
      return responder(res, 201, data);
    }
    if (!rota) return responder(res, 405, {});
    const id = Number(rota[1]);
    if (!Number.isSafeInteger(id) || id > 2147483647) return responder(res, 400, { erro: 'Tentativa inválida.' });
    const params = { p_usuario: req.usuario.id, p_tentativa: id };
    if (!rota[2] && req.method === 'GET') {
      const { data, error } = await db.from('tentativas').select('*')
        .eq('idtentativas', id).eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
      if (error) throw error;
      return responder(res, data ? 200 : 404, data ?? { erro: 'Tentativa não encontrada.' });
    }
    if (rota[2] === 'proxima-questao' && req.method === 'GET')
      return responder(res, 200, await executarOperacao(db, 'proxima_questao_segura', params));
    if (rota[2] === 'respostas' && req.method === 'POST') {
      const body = await lerJson(req);
      if (![body.questoes_idquestoes, body.alternativas_idalternativas].every(n => Number.isSafeInteger(n) && n > 0 && n <= 2147483647))
        return responder(res, 400, { erro: 'Questão e alternativa devem ser IDs válidos.' });
      return responder(res, 201, await executarOperacao(db, 'responder_prova', {
        ...params, p_questao: body.questoes_idquestoes, p_alternativa: body.alternativas_idalternativas,
      }));
    }
    if (rota[2] === 'finalizar' && req.method === 'POST')
      return responder(res, 200, await executarOperacao(db, 'finalizar_prova', params));
    return responder(res, 405, { erro: 'Método HTTP não permitido.' });
  } catch (error) { return tratarErro(res, error); }
}
