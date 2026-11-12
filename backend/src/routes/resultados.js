import { responder, falhaBanco } from '../utils/http.js';

// Consulta o resultado persistido pela RPC finalizar_prova, sem recalcular a nota.
export async function resultadosRoutes(req, res, pathname, db) {
  const match = pathname.match(/^\/api\/tentativas\/([1-9]\d*)\/resultado\/?$/);
  if (!match) return false;
  if (req.method !== 'GET') return responder(res, 405, { erro: 'Método HTTP não permitido.' }, { Allow: 'GET' });

  const tentativaId = Number(match[1]);
  if (!Number.isSafeInteger(tentativaId)) return responder(res, 400, { erro: 'Tentativa inválida.' });

  const { data: tentativa, error } = await db.from('tentativas')
    .select('idtentativas,status,acertos,percentual,aprovado,finalizado_em')
    .eq('idtentativas', tentativaId).eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
  if (error) return falhaBanco(res, error);
  if (!tentativa) return responder(res, 404, { erro: 'Tentativa não encontrada.' });
  if (tentativa.status !== 'FINALIZADA') return responder(res, 409, { erro: 'A prova ainda não foi finalizada.' });

  const { data: certificado, error: erroCertificado } = await db.from('certificados')
    .select('idcertificados,codigo_validacao,emitido_em,ativo,revogado_em')
    .eq('tentativas_idtentativas', tentativaId)
    .eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
  if (erroCertificado) return falhaBanco(res, erroCertificado);

  return responder(res, 200, {
    tentativa_id: tentativa.idtentativas,
    status: tentativa.status,
    total_questoes: 12,
    acertos: tentativa.acertos,
    erros: 12 - tentativa.acertos,
    percentual: Number(tentativa.percentual),
    aprovado: tentativa.aprovado,
    finalizado_em: tentativa.finalizado_em,
    certificado: certificado ? {
      idcertificados: certificado.idcertificados,
      codigo_validacao: certificado.codigo_validacao,
      emitido_em: certificado.emitido_em,
      ativo: certificado.ativo && !certificado.revogado_em,
      download: `/api/certificados/${certificado.idcertificados}/download`,
    } : null,
  }, { 'Cache-Control': 'no-store' });
}
