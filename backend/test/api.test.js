import assert from 'node:assert/strict';
import { once } from 'node:events';
import { test } from 'node:test';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

test('API preserva filtros e não expõe dados ou erros do banco', async (t) => {
  process.env.SUPABASE_URL = 'https://teste.supabase.co';
  process.env.SUPABASE_SECRET_KEY = 'sb_secret_teste';
  process.env.PORT = '0';
  process.env.JWT_SECRET = 'segredo-apenas-para-testes-com-32-caracteres';
  process.env.ADMIN_USER_IDS = '2';
  const originalFetch = globalThis.fetch;
  const requests = [];
  let fail = false;
  let usuario;
  let provaMode = false;
  let tentativa;
  let vinculos = [];
  let respostas = [];
  let certificado;
  globalThis.fetch = async (input, options) => {
    const url = new URL(input);
    if (url.hostname !== 'teste.supabase.co') return originalFetch(input, options);
    requests.push({ url, options });
    if (fail) return new Response(JSON.stringify({ message: 'SEGREDO_INTERNO', code: '42501' }), {
      status: 403, headers: { 'Content-Type': 'application/json' },
    });
    if (url.pathname === '/rest/v1/usuarios') {
      if (options.method === 'POST') {
        usuario = { idusuarios: 1, ...JSON.parse(options.body) };
        const { senha_hash, ...publico } = usuario;
        return Response.json(publico, { status: 201 });
      }
      return Response.json(usuario ? [usuario] : []);
    }
    if (provaMode) {
      const table = url.pathname.split('/').at(-1);
      const body = options.body ? JSON.parse(options.body) : undefined;
      const single = new Headers(options.headers).get('Accept')?.includes('vnd.pgrst.object');
      const result = rows => Response.json(single ? rows[0] : rows);
      if (table === 'tentativas') {
        if (options.method === 'POST') tentativa = { idtentativas: 10, ...body };
        if (options.method === 'PATCH') tentativa = { ...tentativa, ...body };
        return result(tentativa ? [tentativa] : []);
      }
      if (table === 'questoes') return result([{ idquestoes: 5, enunciado: 'Questão' }]);
      if (table === 'alternativas') return result([{ idalternativas: 7, correta: true }]);
      if (table === 'tentativas_questoes') {
        if (options.method === 'POST') vinculos = body;
        if (options.method === 'PATCH') vinculos = vinculos.map(v => ({ ...v, ...body }));
        return result(vinculos.filter(v => !url.searchParams.has('questoes_idquestoes') || url.searchParams.get('questoes_idquestoes') === `eq.${v.questoes_idquestoes}`));
      }
      if (table === 'respostas') {
        if (options.method === 'POST') respostas.push({ idrespostas: 1, ...body });
        return result(respostas);
      }
      if (table === 'certificados') {
        if (options.method === 'POST') certificado = { idcertificados: 3, ...body };
        return result(certificado ? [certificado] : []);
      }
    }
    if (url.pathname === '/rest/v1/tentativas' && url.searchParams.get('idtentativas') === 'eq.999') return Response.json([]);
    return new Response(options.method === 'HEAD' ? null : JSON.stringify([
      { idtemas: 1, nome: 'Scrum', descricao: 'Introdução', ordem: 1 },
    ]), { status: 200, headers: { 'Content-Type': 'application/json' } });
  };
  let server;
  t.after(async () => {
    globalThis.fetch = originalFetch;
    if (server) await new Promise((resolve) => server.close(resolve));
  });
  ({ server } = await import('../src/server.js'));
  if (!server.listening) await once(server, 'listening');
  const base = `http://127.0.0.1:${server.address().port}`;

  const page = await originalFetch(base + '/');
  assert.equal(page.status, 200);
  assert.match(page.url, /\/login\.html$/);
  assert.match(await page.text(), /assets\/js\/api\.js/);
  for (const path of ['/cadastro.html', '/assets/js/config.js', '/assets/js/api.js', '/assets/js/auth.js', '/assets/css/index.css']) {
    assert.equal((await originalFetch(base + path)).status, 200, path);
  }
  assert.equal((await originalFetch(base + '/.env')).status, 404);
  assert.equal((await originalFetch(base + '/backend/.env')).status, 404);
  const preflight = await originalFetch(base + '/api/login/entrar', { method: 'OPTIONS', headers: {
    Origin: 'http://localhost:5500', 'Access-Control-Request-Method': 'POST',
    'Access-Control-Request-Headers': 'content-type,authorization',
  } });
  assert.equal(preflight.status, 204);
  assert.ok(preflight.headers.get('access-control-allow-origin'));
  assert.match(preflight.headers.get('access-control-allow-headers'), /authorization/);

  const temas = await originalFetch(`${base}/api/temas`);
  assert.equal(temas.status, 200);
  assert.equal((await temas.json())[0].nome, 'Scrum');
  assert.equal(requests[0].url.pathname, '/rest/v1/temas');
  assert.equal(requests[0].url.searchParams.get('ativo'), 'eq.true');
  assert.equal(requests[0].url.searchParams.get('order'), 'ordem.asc');
  assert.equal(requests[0].url.searchParams.get('select'), 'idtemas,nome,descricao,ordem');

  const health = await originalFetch(`${base}/api/teste-supabase`);
  assert.equal(health.status, 200);
  assert.deepEqual(await health.json(), { status: 'ok' });
  assert.equal(requests[1].options.method, 'HEAD');
  assert.equal(requests[1].url.pathname, '/rest/v1/temas');

  fail = true;
  for (const [route, message] of [
    ['/api/temas', 'Não foi possível consultar os temas.'],
    ['/api/teste-supabase', 'Banco de dados indisponível.'],
  ]) {
    const response = await originalFetch(base + route);
    assert.equal(response.status, 503);
    assert.deepEqual(await response.json(), { erro: message });
  }

  const post = (route, body) => originalFetch(base + '/api/login/' + route, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body),
  });
  const cadastro = { cpf: '12345678901', nome: 'Teste', email: 'teste@example.com', senha: 'Senha-teste-123' };
  for (const [route, body, message] of [
    ['cadastro', cadastro, 'Erro interno ao cadastrar usuário.'],
    ['entrar', cadastro, 'Erro interno ao realizar login.'],
  ]) {
    const response = await post(route, body);
    assert.equal(response.status, 500);
    assert.deepEqual(await response.json(), { erro: message });
  }
  fail = false;
  assert.equal((await post('cadastro', { ...cadastro, email: 'invalido' })).status, 400);
  assert.equal((await post('entrar', {})).status, 400);
  assert.equal((await post('entrar', cadastro)).status, 401);
  const created = await post('cadastro', cadastro);
  assert.equal(created.status, 201);
  assert.equal((await created.json()).usuario.senha_hash, undefined);
  assert.notEqual(usuario.senha_hash, cadastro.senha);
  assert.equal(await bcrypt.compare(cadastro.senha, usuario.senha_hash), true);
  assert.equal((await post('cadastro', cadastro)).status, 409);
  assert.equal((await post('entrar', { ...cadastro, senha: 'errada' })).status, 401);
  const loggedIn = await post('entrar', cadastro);
  assert.equal(loggedIn.status, 200);
  const session = await loggedIn.json();
  assert.equal(session.usuario.senha_hash, undefined);
  const claims = jwt.verify(session.token, process.env.JWT_SECRET, { algorithms: ['HS256'] });
  assert.equal(claims.id, 1);
  assert.equal(claims.exp - claims.iat, 7200);

  const admin = jwt.sign({ id: 2 }, process.env.JWT_SECRET, { expiresIn: '1h' });
  const request = (path, method = 'GET', token, body) => originalFetch(base + path, {
    method, headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    ...(body === undefined ? {} : { body: JSON.stringify(body) }),
    signal: AbortSignal.timeout(5000),
  });
  assert.equal((await request('/api/conteudos')).status, 401);
  assert.equal((await request('/api/conteudos', 'GET', session.token)).status, 200);
  assert.equal((await request('/api/temas', 'POST', session.token, { nome: 'Novo' })).status, 403);
  const createdTheme = await request('/api/temas', 'POST', admin, { nome: 'Novo' });
  assert.equal(createdTheme.status, 201);
  assert.equal(JSON.parse(requests.at(-1).options.body).nome, 'Novo');
  assert.equal((await request('/api/temas/1', 'PATCH', admin, { nome: 'Editado' })).status, 200);
  const deleted = await request('/api/temas/1', 'DELETE', admin);
  assert.equal(deleted.status, 204);
  assert.equal(await deleted.text(), '');
  assert.equal((await request('/api/questoes', 'GET', admin)).status, 200);
  assert.equal((await request('/api/questoes/1/alternativas', 'GET', admin)).status, 200);
  assert.equal((await request('/api/usuarios/1/certificados', 'GET', session.token)).status, 200);
  assert.equal((await request('/api/usuarios/2/certificados', 'GET', session.token)).status, 403);
  assert.equal((await request('/api/tentativas/999', 'GET', session.token)).status, 404);
  assert.equal((await request('/api/inexistente')).status, 404);
  const invalid = await originalFetch(base + '/api/temas', { method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${admin}` }, body: '{' });
  assert.equal(invalid.status, 400);
  assert.deepEqual(await invalid.json(), { erro: 'JSON inválido.' });

  provaMode = true;
  const started = await request('/api/tentativas', 'POST', session.token, { usuarios_idusuarios: 999 });
  assert.equal(started.status, 201);
  assert.equal((await started.json()).total_questoes, 1);
  assert.equal(tentativa.usuarios_idusuarios, 1);
  assert.ok(tentativa.iniciado_em);
  assert.equal((await request('/api/tentativas/10/finalizar', 'POST', session.token, {})).status, 409);
  assert.equal((await request('/api/tentativas/10/respostas', 'POST', session.token,
    { questoes_idquestoes: 999, alternativas_idalternativas: 7 })).status, 400);
  assert.equal((await request('/api/tentativas/10/respostas', 'POST', session.token,
    { questoes_idquestoes: 5, alternativas_idalternativas: 7 })).status, 201);
  const finished = await request('/api/tentativas/10/finalizar', 'POST', session.token, {});
  assert.equal(finished.status, 200);
  const outcome = await finished.json();
  assert.equal(outcome.tentativa.acertos, 1);
  assert.ok(outcome.tentativa.finalizado_em);
  assert.equal(outcome.certificado.score, 1);
  assert.equal(outcome.certificado.idcertificados, 3);
  const repeat = await request('/api/tentativas/10/finalizar', 'POST', session.token, {});
  assert.equal((await repeat.json()).certificado.codigo_validacao, outcome.certificado.codigo_validacao);
});
