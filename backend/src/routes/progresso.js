import { responder } from '../utils/http.js';

export async function progressoRoutes(req, res, pathname, supabase) {
  const lista = /^\/api\/estudos\/progresso\/?$/.test(pathname);
  const tema = pathname.match(/^\/api\/temas\/([1-9]\d*)\/conclusao\/?$/);
  if (!lista && !tema) return false;
  // Nunca aceita o dono vindo do corpo, mesmo para administradores.
  const usuarioId = req.usuario.id;
  if (lista && req.method === 'GET') {
    const { data, error } = await supabase.from('progresso_estudos')
      .select('temas_idtemas,concluido_em').eq('usuarios_idusuarios', usuarioId);
    if (error) return responder(res, 503, {});
    return responder(res, 200, data);
  }
  if (tema && req.method === 'PUT') {
    const temaId = Number(tema[1]);
    if (!Number.isSafeInteger(temaId)) return responder(res, 400, { erro: 'Tema inválido.' });
    const { data: ativo, error: erroTema } = await supabase.from('temas')
      .select('idtemas').eq('idtemas', temaId).eq('ativo', true).maybeSingle();
    if (erroTema) return responder(res, 503, {});
    if (!ativo) return responder(res, 404, { erro: 'Tema não encontrado.' });
    const { data: conteudos, error: erroConteudo } = await supabase.from('conteudos')
      .select('idconteudo').eq('temas_idtemas', temaId).eq('status', true).limit(1);
    if (erroConteudo) return responder(res, 503, {});
    if (!conteudos?.length) return responder(res, 409, { erro: 'Este tema ainda não possui conteúdo disponível.' });
    const { error } = await supabase.from('progresso_estudos').upsert({
      usuarios_idusuarios: usuarioId, temas_idtemas: temaId,
    }, { onConflict: 'usuarios_idusuarios,temas_idtemas', ignoreDuplicates: true });
    if (error) return responder(res, 503, {});
    return responder(res, 200, { temas_idtemas: temaId, concluido: true });
  }
  return responder(res, 405, { erro: 'Método HTTP não permitido.' });
}
