import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import vm from 'node:vm';
import { test } from 'node:test';

test('cliente web usa a origem atual, configuração externa e token nas rotas privadas', async () => {
  const source = await readFile(new URL('../../frontend/src/assets/js/api.js', import.meta.url), 'utf8');
  const calls = [];
  const storage = new Map([['token', 'token-de-teste']]);
  let result = Response.json({ mensagem: 'ok' });
  const context = vm.createContext({
    window: { location: { protocol: 'http:', origin: 'http://localhost:4321' } },
    localStorage: { getItem: key => storage.get(key), removeItem: key => storage.delete(key) },
    AbortSignal,
    fetch: async (url, options) => { calls.push({ url, options }); return result.clone(); },
  });
  vm.runInContext(source, context);
  const api = context.window.AgilCertAPI;
  await api.request('login/entrar', { method: 'POST', authenticated: false, body: { cpf: '12345678901', senha: 'teste' } });
  assert.equal(calls[0].url, 'http://localhost:4321/api/login/entrar');
  assert.equal(calls[0].options.headers.Authorization, undefined);
  assert.equal(JSON.parse(calls[0].options.body).cpf, '12345678901');
  await api.request('conteudos');
  assert.equal(calls[1].options.headers.Authorization, 'Bearer token-de-teste');
  context.window.AGILCERT_API_BASE_URL = 'https://api.example.com/api/';
  await api.request('/temas');
  assert.equal(calls[2].url, 'https://api.example.com/api/temas');
  result = Response.json({ erro: 'CPF ou senha inválidos.' }, { status: 401 });
  await assert.rejects(api.request('login/entrar', { authenticated: false }), /CPF ou senha inválidos/);
  result = new Response('<html>Live Server</html>', { headers: { 'content-type': 'text/html' } });
  await assert.rejects(api.request('temas'), /não retornou JSON/);
  result = Response.json({ erro: 'Autenticação necessária.' }, { status: 401 });
  await assert.rejects(api.request('conteudos'), /Autenticação necessária/);
  assert.equal(storage.has('token'), false);
});
