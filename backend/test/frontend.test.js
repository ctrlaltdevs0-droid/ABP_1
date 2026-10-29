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

test('configuração pública é JavaScript válido e usa mesma origem por padrão', async () => {
  const source = await readFile(new URL('../../frontend/src/assets/js/config.js', import.meta.url), 'utf8');
  const context = vm.createContext({ window: {} });
  vm.runInContext(source, context);
  assert.equal(context.window.AGILCERT_API_BASE_URL, '');
});

test('logout chama o servidor antes de apagar a sessão e preserva token se houver falha', async () => {
  const source = await readFile(new URL('../../frontend/src/assets/js/api.js', import.meta.url), 'utf8');
  const storage = new Map([['token','teste'],['usuario','{}']]);
  const calls=[];
  let result=Response.json({erro:'Indisponível'},{status:503});
  const context=vm.createContext({
    window:{location:{protocol:'http:',origin:'http://localhost',assign:url=>calls.push(url)}},
    localStorage:{getItem:key=>storage.get(key),removeItem:key=>storage.delete(key)},AbortSignal,
    fetch:async(url,options)=>{calls.push({url,options}); return result;},
  });
  vm.runInContext(source,context);
  await assert.rejects(context.window.AgilCertAPI.logout(),/Indisponível/);
  assert.equal(storage.get('token'),'teste');
  result=new Response(null,{status:204});
  await context.window.AgilCertAPI.logout();
  assert.equal(storage.has('token'),false);
  assert.equal(storage.has('usuario'),false);
  assert.equal(calls.at(-1),'login.html');
  assert.equal(calls[0].options.headers.Authorization,'Bearer teste');
  assert.equal(calls[0].url,'http://localhost/api/login/sair');
});
