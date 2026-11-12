import { falhaBanco, responder, tratarErro } from '../utils/http.js';
import { enviarCertificadoPdf } from '../services/pdfCertificado.js';

const idValido = s => /^[1-9]\d*$/.test(s) && Number.isSafeInteger(Number(s));

export async function certificadosRoutes(req, res, pathname, db) {
  const usuarioMatch = pathname.match(/^\/api\/usuarios\/([1-9]\d*)\/certificados\/?$/);
  const me = /^\/api\/certificados\/me\/?$/.test(pathname);
  const validar = pathname.match(/^\/api\/certificados\/validar\/([0-9a-f-]+)\/?$/i);
  const download = pathname.match(/^\/api\/certificados\/([1-9]\d*)\/download\/?$/);
  const detalhe = pathname.match(/^\/api\/certificados\/([1-9]\d*)\/?$/);
  if (!usuarioMatch && !me && !validar && !download && !detalhe) return false;
  if (req.method !== 'GET') return responder(res, 405, { erro: 'Método HTTP não permitido.' }, { Allow: 'GET' });

  // Validação pública: retorna somente informações não sensíveis.
  if (validar) {
    if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(validar[1])) {
      return responder(res, 404, { valido: false });
    }
    const { data, error } = await db.from('certificados')
      .select('codigo_validacao,emitido_em,ativo,revogado_em,percentual')
      .eq('codigo_validacao', validar[1]).maybeSingle();
    if (error) return falhaBanco(res, error);
    if (!data || !data.ativo || data.revogado_em) return responder(res, 404, { valido: false });
    return responder(res, 200, { valido: true, emitido_em: data.emitido_em, percentual: Number(data.percentual) });
  }

  const usuarioId = req.usuario.id;
  if (usuarioMatch || me) {
    if (usuarioMatch && (!idValido(usuarioMatch[1]) || Number(usuarioMatch[1]) !== usuarioId)) {
      return responder(res, 404, { erro: 'Usuário não encontrado.' });
    }
    const { data, error } = await db.from('certificados')
      .select('idcertificados,tentativas_idtentativas,codigo_validacao,score,percentual,emitido_em,ativo,revogado_em')
      .eq('usuarios_idusuarios', usuarioId).order('emitido_em', { ascending: false });
    if (error) return falhaBanco(res, error);
    return responder(res, 200, data ?? [], { 'Cache-Control': 'no-store' });
  }

  const id = Number((download ?? detalhe)[1]);
  if (!Number.isSafeInteger(id)) return responder(res, 400, { erro: 'Certificado inválido.' });
  const { data, error } = await db.from('certificados')
    .select('idcertificados,tentativas_idtentativas,codigo_validacao,score,percentual,emitido_em,ativo,revogado_em')
    .eq('idcertificados', id).eq('usuarios_idusuarios', usuarioId).maybeSingle();
  if (error) return falhaBanco(res, error);
  if (!data) return responder(res, 404, { erro: 'Certificado não encontrado.' });
  if (download) {
    if (!data.ativo || data.revogado_em) return responder(res, 409, { erro: 'Certificado revogado ou inativo.' });
    try {
      const { data: usuario, error: erroUsuario } = await db.from('usuarios')
        .select('nome').eq('idusuarios', usuarioId).maybeSingle();
      if (erroUsuario) return falhaBanco(res, erroUsuario);
      if (!usuario) return responder(res, 404, { erro: 'Usuário não encontrado.' });
      await enviarCertificadoPdf(res, data, usuario.nome);
    } catch (erro) { return tratarErro(res, erro); }
    return true;
  }
  return responder(res, 200, data, { 'Cache-Control': 'no-store' });
}
