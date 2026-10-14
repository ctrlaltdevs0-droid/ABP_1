import assert from 'node:assert/strict';
import { once } from 'node:events';
import { test } from 'node:test';

test('API preserva filtros e não expõe dados ou erros do banco', async (t) => {
  process.env.SUPABASE_URL = 'https://teste.supabase.co';
  process.env.SUPABASE_SECRET_KEY = 'sb_secret_teste';
  process.env.PORT = '0';
  const originalFetch = globalThis.fetch;
  const requests = [];
  let fail = false;
  globalThis.fetch = async (input, options) => {
    const url = new URL(input);
    if (url.hostname !== 'teste.supabase.co') return originalFetch(input, options);
    requests.push({ url, options });
    if (fail) return new Response(JSON.stringify({ message: 'SEGREDO_INTERNO', code: '42501' }), {
      status: 403, headers: { 'Content-Type': 'application/json' },
    });
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
});
