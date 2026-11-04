import { test } from 'node:test';
import assert from 'node:assert/strict';
import { tentativasRoutes } from '../src/routes/tentativas.js';
const sessao = '11111111-1111-4111-8111-111111111111';
const response = () => ({ writeHead(code, headers) { this.code=code; this.headers=headers; }, end(body) { this.body=JSON.parse(body); } });

test('continuidade: ações usam identidade autenticada, sessão e questão exata', async () => {
  const calls=[];
  const db={ async rpc(name, params) { calls.push({name,params}); return {data:{tentativa:{idtentativas:42,status:'INTERROMPIDA'}}}; } };
  for (const acao of ['pausar','retomar','presenca','interromper']) {
    const res=response();
    await tentativasRoutes({method:'POST',usuario:{id:7},body:{sessao,usuarios_idusuarios:999,questoes_idquestoes:12,motivo:'FECHAMENTO'}},res,`/api/tentativas/42/${acao}`,db);
    assert.equal(res.code,200);
    assert.equal(calls.at(-1).params.p_usuario,7);
    assert.equal(calls.at(-1).params.p_tentativa,42);
    assert.equal(calls.at(-1).params.p_sessao,sessao);
  }
  assert.equal(calls.at(-1).params.p_questao,12);
  assert.equal(calls.at(-1).params.p_motivo,'FECHAMENTO');
  const atual=response();
  await tentativasRoutes({method:'GET',usuario:{id:7}},atual,'/api/tentativas/atual',db);
  assert.equal(calls.at(-1).params.p_acao,'atual');
  assert.equal(atual.headers['Cache-Control'],'no-store');
});

test('continuidade: rejeita métodos, sessão, motivo e IDs inválidos antes do banco', async () => {
  const db={rpc(){throw Error('Não deveria consultar o banco');}};
  for (const [method,path,body,status] of [
    ['POST','/api/tentativas/42/retomar',{},400],
    ['GET','/api/tentativas/42/pausar',{sessao},405],
    ['POST','/api/tentativas/42/interromper',{sessao,questoes_idquestoes:2,motivo:'QUALQUER'},400],
    ['POST','/api/tentativas/42/interromper',{sessao,motivo:'CONEXAO'},400],
    ['POST','/api/tentativas/42/respostas',{sessao,questoes_idquestoes:'2',alternativas_idalternativas:3},400],
    ['GET','/api/tentativas/9007199254740992',{sessao},400],
  ]) {
    const res=response();
    await tentativasRoutes({method,body,usuario:{id:7}},res,path,db);
    assert.equal(res.code,status,`${method} ${path}`);
  }
});

test('continuidade: erro de domínio preserva 409 e erro SQL não vaza', async () => {
  for (const [result,status] of [[{data:{erro_codigo:'SESSAO_INVALIDA'}},409],[{error:{code:'42501',message:'SQL PRIVADO'}},500]]) {
    const res=response();
    await tentativasRoutes({method:'POST',usuario:{id:7},body:{sessao}},res,'/api/tentativas/42/retomar',{async rpc(){return result;}});
    assert.equal(res.code,status);
    assert.doesNotMatch(JSON.stringify(res.body),/SQL PRIVADO/);
  }
});

test('compatibilidade: chamadas legadas não contornam a sessão da nova prova', async () => {
  const db={from(){const q={select(){return q;},eq(){return q;},in(){return q;},not(){return q;},limit(){return q;},async maybeSingle(){return {data:{idtentativas:42,sessao_prova:sessao}};}};return q;}};
  for(const [method,path] of [['POST','/api/tentativas/42/respostas'],['GET','/api/tentativas/42/proxima-questao'],['POST','/api/tentativas/42/finalizar'],['POST','/api/tentativas/retomar']]){
    const res=response();
    await tentativasRoutes({method,usuario:{id:7},body:{}},res,path,db);
    assert.equal(res.code,409);
    assert.match(res.body.erro,/página de certificação/);
  }
});

test('compatibilidade: consulta de tentativa legada mantém o contrato da develop', async () => {
  const db={from(){const q={select(){return q;},eq(){return q;},async maybeSingle(){return {data:{sessao_prova:null}};},async single(){return {data:{idtentativas:42,status:'EM_ANDAMENTO'}};}};return q;}};
  const res=response();
  await tentativasRoutes({method:'GET',usuario:{id:7}},res,'/api/tentativas/42',db);
  assert.equal(res.code,200);
  assert.equal(res.body.idtentativas,42);
});
