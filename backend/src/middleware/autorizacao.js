
import jwt from 'jsonwebtoken';
import { tokenRevogado } from '../services/sessoes.js';

// A chave Supabase do servidor ignora RLS;
// por isso, a autorização acontece antes das consultas.
export async function autorizarRota(req, res, pathname, supabase) {
  // 1. Leitura pública dos temas.
  if (
    req.method === 'GET' &&
    /^\/api\/temas(?:\/\d+)?\/?$/.test(pathname)
  ) {
    return true;
  }

  // 2. Extração e validação do token JWT.
  const token = req.headers.authorization?.match(/^Bearer (\S+)$/i)?.[1];
  let usuario;

  try {
    usuario = jwt.verify(
      token ?? '',
      process.env.JWT_SECRET.trim(),
      { algorithms: ['HS256'] }
    );

    if (
      !Number.isSafeInteger(usuario.id) ||
      usuario.id < 1 ||
      !Number.isSafeInteger(usuario.exp)
    ) {
      throw new Error();
    }
  } catch {
    res.status(401).json({
      erro: 'Autenticação necessária.'
    });
    return false;
  }

  // 3. Verifica se a sessão foi revogada.
  try {
    const revogado = await tokenRevogado(supabase, token);

    if (revogado) {
      res.status(401).json({
        erro: 'Sessão encerrada. Entre novamente.'
      });
      return false;
    }
  } catch {
    res.status(503).json({ erro: 'Não foi possível verificar a sessão.' });
    return false;
  }

  try {
    const { data, error } = await supabase.from('usuarios').select('versao_sessao')
      .eq('idusuarios', usuario.id).maybeSingle();
    if (error) throw error;
    // Tokens legados sem ver equivalem à versão inicial. A primeira troca os revoga.
    const versao = usuario.ver ?? 0;
    if (!data || !Number.isSafeInteger(versao) || versao < 0 || versao !== data.versao_sessao) {
      res.status(401).json({ erro: 'Sessão encerrada. Entre novamente.' });
      return false;
    }
  } catch {
    res.status(503).json({ erro: 'Não foi possível verificar a sessão.' });
    return false;
  }
  req.usuario = usuario;
  req.token = token;

  // 4. Rotas do usuário autenticado.
  if (req.method === 'POST' && pathname === '/api/login/sair') {
    return true;
  }

  if (/^\/api\/usuarios\/me(?:\/senha)?\/?$/.test(pathname)) {
    if (req.method === 'GET' || req.method === 'PATCH') {
      return true;
    }
  }

  if (
    req.method === 'GET' &&
    /^\/api\/estudos\/progresso\/?$/.test(pathname)
  ) {
    return true;
  }

  if (
    req.method === 'PUT' &&
    /^\/api\/temas\/[1-9]\d*\/conclusao\/?$/.test(pathname)
  ) {
    return true;
  }

  // Permite consultar as respostas do próprio aluno.
  if (
    req.method === 'GET' &&
    /^\/api\/temas\/[1-9]\d*\/respostas\/?$/.test(pathname)
  ) {
    return true;
  }

  // Permite reiniciar o quiz do próprio aluno em um tema.
  if (
    req.method === 'DELETE' &&
    /^\/api\/temas\/[1-9]\d*\/respostas\/?$/.test(pathname)
  ) {
    return true;
  }

  // Permite responder aos quizzes de estudo.
  if (
    req.method === 'POST' &&
    /^\/api\/questoes\/[1-9]\d*\/responder\/?$/.test(pathname)
  ) {
    return true;
  }

  // 5. Permissões de administrador.
  const admins = (process.env.ADMIN_USER_IDS ?? '')
    .split(',')
    .map(x => x.trim());

  if (admins.includes(String(usuario.id))) {
    return true;
  }

  // 6. Leitura de conteúdos e questões.
  const ehLeituraConteudoOuQuestao =
    req.method === 'GET' &&
    (
      /^\/api\/conteudos(?:\/\d+)?\/?$/.test(pathname) ||
      /^\/api\/questoes(?:\/\d+)?\/?$/.test(pathname) ||
      /^\/api\/temas\/\d+\/(?:conteudos|questoes)\/?$/.test(pathname)
    );

  if (ehLeituraConteudoOuQuestao) {
    return true;
  }

  // 7. Tentativas de provas.
  const inicio = /^\/api\/tentativas\/?$/.test(pathname);

  if (inicio && req.method === 'POST') {
    req.body = {
      ...(req.body ?? {}),
      usuarios_idusuarios: usuario.id
    };

    return true;
  }

  const tentativa = pathname.match(
    /^\/api\/tentativas\/(\d+)(?:\/(?:proxima-questao|respostas|finalizar))?\/?$/
  );

  if (tentativa) {
    const { data, error } = await supabase
      .from('tentativas')
      .select('idtentativas')
      .eq('idtentativas', tentativa[1])
      .eq('usuarios_idusuarios', usuario.id)
      .maybeSingle();

    if (error) throw error;

    if (data) return true;

    res.status(404).json({
      erro: 'Tentativa não encontrada.'
    });

    return false;
  }

  // 8. Certificados.
  const lista = pathname.match(
    /^\/api\/usuarios\/(\d+)\/certificados\/?$/
  );

  if (
    req.method === 'GET' &&
    lista &&
    Number(lista[1]) === usuario.id
  ) {
    return true;
  }

  const certificado = pathname.match(
    /^\/api\/certificados\/(\d+)\/?$/
  );

  if (req.method === 'GET' && certificado) {
    const { data, error } = await supabase
      .from('certificados')
      .select('idcertificados')
      .eq('idcertificados', certificado[1])
      .eq('usuarios_idusuarios', usuario.id)
      .maybeSingle();

    if (error) throw error;

    if (data) return true;

    res.status(404).json({
      erro: 'Certificado não encontrado.'
    });

    return false;
  }

  res.status(403).json({
    erro: 'Acesso negado.'
  });

  return false;
}
