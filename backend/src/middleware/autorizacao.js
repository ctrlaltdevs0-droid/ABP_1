import jwt from 'jsonwebtoken';

// A chave Supabase do servidor ignora RLS; a autorização acontece antes da consulta.
export async function autorizarRota(req, res, pathname, supabase) {
  if (req.method === 'GET' && /^\/api\/temas(?:\/\d+)?\/?$/.test(pathname)) return true;
  const token = req.headers.authorization?.match(/^Bearer (\S+)$/i)?.[1];
  let usuario;
  try {
    usuario = jwt.verify(token ?? '', process.env.JWT_SECRET.trim(), { algorithms: ['HS256'] });
    if (!Number.isSafeInteger(usuario.id) || usuario.id < 1) throw new Error();
  } catch {
    res.status(401).json({ erro: 'Autenticação necessária.' });
    return false;
  }
  req.usuario = usuario;
  const admins = (process.env.ADMIN_USER_IDS ?? '').split(',').map(x => x.trim());
  if (admins.includes(String(usuario.id))) return true;

  // Conteúdos de estudo são leitura para qualquer usuário autenticado.
  if (req.method === 'GET' && (/^\/api\/conteudos(?:\/\d+)?\/?$/.test(pathname) || /^\/api\/temas\/\d+\/conteudos\/?$/.test(pathname))) return true;
  const inicio = /^\/api\/tentativas\/?$/.test(pathname);
  if (inicio && req.method === 'POST') {
    req.body = { ...(req.body ?? {}), usuarios_idusuarios: usuario.id };
    return true;
  }
  const tentativa = pathname.match(/^\/api\/tentativas\/(\d+)(?:\/(?:proxima-questao|respostas|finalizar))?\/?$/);
  if (tentativa) {
    const { data, error } = await supabase.from('tentativas').select('idtentativas')
      .eq('idtentativas', tentativa[1]).eq('usuarios_idusuarios', usuario.id).maybeSingle();
    if (error) throw error;
    if (data) return true;
    res.status(404).json({ erro: 'Tentativa não encontrada.' });
    return false;
  }
  const lista = pathname.match(/^\/api\/usuarios\/(\d+)\/certificados\/?$/);
  if (req.method === 'GET' && lista && Number(lista[1]) === usuario.id) return true;
  const certificado = pathname.match(/^\/api\/certificados\/(\d+)\/?$/);
  if (req.method === 'GET' && certificado) {
    const { data, error } = await supabase.from('certificados').select('idcertificados')
      .eq('idcertificados', certificado[1]).eq('usuarios_idusuarios', usuario.id).maybeSingle();
    if (error) throw error;
    if (data) return true;
    res.status(404).json({ erro: 'Certificado não encontrado.' });
    return false;
  }
  res.status(403).json({ erro: 'Acesso negado.' });
  return false;
}
