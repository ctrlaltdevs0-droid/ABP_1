import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import vm from 'node:vm';
import { createRequire } from 'node:module';
const qrcode = createRequire(import.meta.url)('../../frontend/src/assets/js/vendor/qrcode.js');
import { certificadosRoutes } from '../src/routes/certificados.js';
import { autorizarRota } from '../src/middleware/autorizacao.js';

const codigo = '11111111-1111-4111-8111-111111111111';
function response() {
  return { writeHead(status, headers) { this.statusCode = status; this.headers = headers; },
    end(body) { this.body = JSON.parse(body); },
    status(status) { this.statusCode = status; return this; }, json(body) { this.body = body; } };
}
test('validação é pública somente por código; consulta por ID exige login', async () => {
  const db = { from() { throw Error('Não deveria consultar banco'); } };
  assert.equal(await autorizarRota({method:'GET',headers:{}}, response(), `/api/certificados/validar/${codigo}`, db), true);
  const res = response();
  assert.equal(await autorizarRota({method:'GET',headers:{}}, res, '/api/certificados/1', db), false);
  assert.equal(res.statusCode, 401);
});
test('consulta filtra certificados revogados e validação seleciona somente dados públicos', async () => {
  const calls = [];
  const q = { select(fields) { calls.push(['select', fields]); return q; },
    eq(...args) { calls.push(args); return q; }, is(...args) { calls.push(args); return q; },
    async maybeSingle() { return { data: null }; } };
  const db = { from() { return q; } };
  for (const path of [`/api/certificados/validar/${codigo}`, '/api/certificados/1']) {
    const res = response();
    await certificadosRoutes({method:'GET'}, res, path, db);
    assert.equal(res.statusCode, 404);
    assert.ok(calls.some(x => x[0] === 'ativo' && x[1] === true));
    assert.ok(calls.some(x => x[0] === 'revogado_em' && x[1] === null));
  }
  assert.equal(calls[0][1], 'codigo_validacao,emitido_em,score,percentual,usuarios(nome)');
});

async function pagina(search, request, token = 'token') {
  const elementos = new Map();
  const el = id => {
    if (!elementos.has(id)) elementos.set(id, { hidden:false, disabled:false, style:{}, events:{},
      addEventListener(name, fn) { this.events[name] = fn; }, classList:{toggle(){}}, setAttribute(){} });
    return elementos.get(id);
  };
  let prints = 0;
  vm.runInNewContext(await readFile(new URL('../../frontend/src/assets/js/certificado.js', import.meta.url), 'utf8'), {
    document:{getElementById:el,querySelector:el}, URL, URLSearchParams, qrcode,
    localStorage:{getItem:()=>token},
    window:{location:{search,href:`https://agilcert.test/certificado.html${search}`, replace(){}},
      AgilCertAPI:{request}, print(){prints++;}},
  });
  await new Promise(resolve => setImmediate(resolve));
  return {el, prints:()=>prints};
}
const certificado = { idcertificados:3, usuarios:{nome:'Pessoa <Teste>'}, codigo_validacao:codigo, emitido_em:'2026-11-17T12:00:00', percentual:75 };

test('certificado: emissão UTC vira data e hora de Brasília; e-mail é privado', async () => {
  for (const emitido_em of ['2026-11-18T01:30:00', '2026-11-18T01:30:00Z', '2026-11-17T22:30:00-03:00']) {
    const p = await pagina('?id=3', async path => path === 'usuarios/me'
      ? {id:7,nome:'Pessoa',email:'pessoa@example.com'} : {...certificado,emitido_em});
    assert.match(p.el('certificado-data').textContent, /17\/11\/2026.*22:30:00/);
    assert.equal(p.el('certificado-email').textContent, 'E-mail: pessoa@example.com');
  }
  const publico = await pagina(`?codigo=${codigo}`, async () => ({certificado}), null);
  assert.equal(publico.el('certificado-email').hidden, true);
  assert.equal(publico.el('certificado-cpf').hidden, true);
});
test('página carrega certificado do histórico e habilita PDF somente após consulta válida', async () => {
  const paths = [];
  const p = await pagina('?tentativa=42', async path => {
    paths.push(path);
    if(path === 'usuarios/me') return {id:7,nome:'Pessoa'};
    if(path === 'usuarios/7/certificados') return [{idcertificados:3,tentativas_idtentativas:42,ativo:true}];
    return certificado;
  });
  assert.deepEqual(paths,['usuarios/me','usuarios/7/certificados','certificados/3']);
  assert.equal(p.el('nomeAluno').textContent,'Pessoa <Teste>');
  assert.equal(p.el('btn-baixar').disabled,false);
  assert.equal(p.el('container-certificado').hidden,false);
  assert.match(p.el('certificado-qrcode').src, /^data:image\/svg\+xml/);
  assert.equal(p.el('certificado-validacao').href, `https://agilcert.test/validar-certificado.html?codigo=${codigo}`);
  p.el('btn-baixar').events.click();
  assert.equal(p.prints(),1);
});
test('validação pública funciona sem token e falhas não exibem certificado', async () => {
  const p = await pagina(`?codigo=${codigo}`, async (path, options) => {
    assert.equal(options.authenticated,false);
    return {valido:true,certificado};
  }, null);
  assert.equal(p.el('page-title').textContent,'Certificado válido');
  const erro = await pagina(`?codigo=${codigo}`, async () => {throw Error('Certificado revogado.');}, null);
  assert.equal(erro.el('container-certificado').hidden,true);
  assert.equal(erro.el('btn-baixar').disabled,true);
  assert.equal(erro.el('certificado-mensagem').textContent,'Certificado revogado.');
});

test('acesso direto abre o certificado ativo mais recente do usuário', async () => {
  const paths = [];
  const p = await pagina('', async path => {
    paths.push(path);
    if (path === 'usuarios/me') return {id:7,nome:'Pessoa'};
    if (path === 'usuarios/7/certificados') return [
      {idcertificados:5,ativo:true,revogado_em:'2026-11-17'},
      {idcertificados:4,ativo:false},
      {idcertificados:3,ativo:true},
      {idcertificados:2,ativo:true},
    ];
    return certificado;
  });
  assert.equal(paths.at(-1),'certificados/3');
  assert.equal(p.el('container-certificado').hidden,false);
  assert.equal(p.el('btn-baixar').hidden,false);
});

test('sem certificado oferece próximos passos e oculta PDF; tentativa específica não abre outro certificado', async () => {
  for (const search of ['', '?tentativa=42']) {
    const paths = [];
    const p = await pagina(search, async path => {
      paths.push(path);
      if (path === 'usuarios/me') return {id:7,nome:'Pessoa'};
      if (path.startsWith('certificados/tentativas/')) throw Error('Esta tentativa não possui um certificado ativo.');
      return search ? [{idcertificados:3,tentativas_idtentativas:99,ativo:true}] : [];
    });
    assert.equal(paths.length,search ? 3 : 2);
    assert.equal(p.el('btn-baixar').hidden,true);
    assert.equal(p.el('container-certificado').hidden,true);
    assert.equal(p.el('certificado-acoes').hidden,false);
    assert.match(p.el('certificado-mensagem').textContent, /certificado ativo/);
  }
});

test('emissão usa aprovação e titular do banco, é idempotente e não reativa revogados', async () => {
  const tentativa = {idtentativas:37,usuarios_idusuarios:7,status:'FINALIZADA',aprovado:true,acertos:10,percentual:83.33};
  const emitido = {idcertificados:1,ativo:true};
  let registro = tentativa, certificadoAtual = emitido, inserts = 0;
  const filtros = [];
  const db = {from(table) {
    const q = {select(){return q;},eq(key,value){filtros.push([table,key,value]);return q;},
      async maybeSingle(){return {data:table==='tentativas'?registro:certificadoAtual};},
      async upsert(data,options){
        inserts++;
        assert.equal(data.usuarios_idusuarios,7);
        assert.equal(data.score,10);
        assert.deepEqual(options,{onConflict:'tentativas_idtentativas',ignoreDuplicates:true});
        return {error:null};
      }};
    return q;
  }};
  const req = {method:'POST',usuario:{id:7},body:{score:12,usuarios_idusuarios:99}};
  for (let i=0;i<2;i++) {
    const res = response();
    await certificadosRoutes(req,res,'/api/certificados/tentativas/37',db);
    assert.equal(res.statusCode,200);
    assert.equal(res.body.idcertificados,1);
  }
  assert.ok(filtros.some(([table,key,value])=>table==='tentativas'&&key==='usuarios_idusuarios'&&value===7));
  certificadoAtual={...emitido,ativo:false,revogado_em:'2026-11-17'};
  const revogado=response();await certificadosRoutes(req,revogado,'/api/certificados/tentativas/37',db);
  assert.equal(revogado.statusCode,409);
  const antes=inserts;
  for (const invalida of [null,{...tentativa,aprovado:false},{...tentativa,status:'EM_ANDAMENTO'}]) {
    registro=invalida;
    const res=response();await certificadosRoutes(req,res,'/api/certificados/tentativas/37',db);
    assert.equal(res.statusCode,invalida?409:404);
  }
  assert.equal(inserts,antes);
});

test('identificador malformado não seleciona outro certificado', async () => {
  for (const search of ['?id=abc', '?tentativa=abc', '?id=']) {
    const paths = [];
    const p = await pagina(search, async path => {paths.push(path); return {id:7,nome:'Pessoa'};});
    assert.deepEqual(paths,['usuarios/me']);
    assert.equal(p.el('btn-baixar').hidden,true);
    assert.match(p.el('certificado-mensagem').textContent,/inválido/);
  }
});
