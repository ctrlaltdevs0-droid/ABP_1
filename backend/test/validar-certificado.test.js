import { test } from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { readFile } from 'node:fs/promises';
const codigo = '11111111-1111-4111-8111-111111111111';
async function pagina(request, search = `?codigo=${codigo}`) {
  const elementos = new Map();
  const el = id => {
    if (!elementos.has(id)) elementos.set(id, {hidden:true, events:{}, addEventListener(name, fn) {this.events[name]=fn;}});
    return elementos.get(id);
  };
  vm.runInNewContext(await readFile(new URL('../../frontend/src/assets/js/validar-certificado.js', import.meta.url),'utf8'), {
    document:{getElementById:el}, URLSearchParams,
    window:{location:{search},AgilCertAPI:{request}},
  });
  await new Promise(resolve => setImmediate(resolve));
  return el;
}
test('QR abre validação HTML sem login e exibe dados confirmados pela API', async () => {
  const el = await pagina(async (path, options) => {
    assert.equal(path,`certificados/validar/${codigo}`);
    assert.equal(options.authenticated,false);
    return {valido:true,certificado:{usuarios:{nome:'Julio'},percentual:83.33,emitido_em:'2026-11-17T16:00:00'}};
  });
  assert.equal(el('validacao-dados').hidden,false);
  assert.equal(el('validacao-nome').textContent,'Julio');
  assert.match(el('validacao-status').textContent,/Autenticidade confirmada/);
});
test('revogação, erro de rede e código inválido não confirmam autenticidade', async () => {
  for (const message of ['Certificado não encontrado ou revogado.', 'Não foi possível conectar à API.']) {
    const el = await pagina(async () => {throw Error(message);});
    assert.equal(el('validacao-dados').hidden,true);
    assert.equal(el('validacao-status').textContent,message);
  }
  const el = await pagina(async () => {assert.fail('Não deve consultar código inválido');}, '?codigo=invalido');
  assert.equal(el('validacao-dados').hidden,true);
  assert.match(el('validacao-status').textContent,/código de validação válido/);
});
test('alterar código invalida resposta atrasada da consulta anterior', async () => {
  let resolver;
  const el = await pagina(() => new Promise(resolve => {resolver=resolve;}));
  el('codigo').events.input();
  resolver({valido:true,certificado:{usuarios:{nome:'Antigo'}}});
  await new Promise(resolve => setImmediate(resolve));
  assert.equal(el('validacao-dados').hidden,true);
  assert.equal(el('validacao-status').textContent,'');
});
