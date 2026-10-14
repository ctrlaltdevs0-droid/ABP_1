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
  const originalFetch = globalThis.fetch;
  const requests = [];
  let fail = false;
  let usuario;
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
});
