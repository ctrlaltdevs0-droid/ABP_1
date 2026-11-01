import assert from 'node:assert/strict';
import { test } from 'node:test';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import { limitarAutenticacao } from '../src/middleware/limite-autenticacao.js';
import { autorizarRota } from '../src/middleware/autorizacao.js';
import { alterarSenha } from '../src/routes/usuarios.js';
import { tentativasRoutes } from '../src/routes/tentativas.js';
import { temasRoutes } from '../src/routes/temas.js';
import { conteudosRoutes } from '../src/routes/conteudos.js';
import { questoesRoutes } from '../src/routes/questoes.js';
import { alternativasRoutes } from '../src/routes/alternativas.js';
import { certificadosRoutes } from '../src/routes/certificados.js';
const secret = 'segredo-de-teste-com-pelo-menos-32-caracteres';
function response() {
  return { headers: {}, set(k,v) { this.headers[k]=v; return this; },
    writeHead(code,headers={}) { this.code=code; Object.assign(this.headers,headers); }, end(body) { this.body=body ? JSON.parse(body) : null; },
    status(code) { this.code=code; return this; }, json(body) { this.body=body; return this; } };
}
test('limite: HMAC de IP/CPF, 429, Retry-After e falha fechada', async () => {
  process.env.JWT_SECRET=secret;
  const calls=[]; let result={data:{permitido:true}};
  const db={ async rpc(name,params) { calls.push({name,params}); return result; } };
  const middleware=limitarAutenticacao(db);
  const req={method:'POST',path:'/entrar',ip:'127.0.0.1',headers:{'x-forwarded-for':'8.8.8.8'},body:{cpf:'123.456.789-01'}};
  let next=0; await middleware(req,response(),()=>next++); assert.equal(next,1);
  const first=calls[0].params;
  assert.match(first.p_ip,/^[a-f0-9]{64}$/); assert.match(first.p_conta,/^[a-f0-9]{64}$/);
  assert.doesNotMatch(JSON.stringify(first),/12345678901|127\.0\.0\.1/);
  await middleware({...req,body:{cpf:'12345678901'},headers:{'x-forwarded-for':'1.1.1.1'}},response(),()=>next++);
  assert.deepEqual(calls[1].params,first);
  result={data:{permitido:false,retry_after:42}};
  const blocked=response(); await middleware(req,blocked,()=>next++);
  assert.equal(blocked.code,429); assert.equal(blocked.headers['Retry-After'],'42'); assert.equal(next,2);
  result={error:{message:'SEGREDO_INTERNO',code:'42501'}};
  const failed=response(); await middleware(req,failed,()=>next++);
  assert.equal(failed.code,503); assert.doesNotMatch(JSON.stringify(failed.body),/SEGREDO_INTERNO/); assert.equal(next,2);
  await middleware({...req,path:'/sair'},response(),()=>next++); assert.equal(next,3);
});
test('troca de senha revoga dois logins e token legado, permitindo nova sessão', async () => {
  process.env.JWT_SECRET=secret; let version=0; let hash=await bcrypt.hash('Senha-antiga-123',4);
  const db={from(table) {return {select(){return this;},eq(){return this;},async maybeSingle(){return {data:table==='sessoes_revogadas'?null:{versao_sessao:version,senha_hash:hash}};}};},
    async rpc(name,p) {assert.equal(name,'alterar_senha_segura'); assert.equal(p.p_usuario,1); if(p.p_hash_atual!==hash)return {data:false}; hash=p.p_hash_novo;version++;return {data:true};}};
  const tokens=[1,2].map(n=>jwt.sign({id:1,ver:0,jti:String(n)},secret,{expiresIn:'1h'}));
  tokens.push(jwt.sign({id:1},secret,{expiresIn:'1h'}));
  const authorize=async token=>{const res=response();const ok=await autorizarRota({method:'GET',headers:{authorization:`Bearer ${token}`}},res,'/api/estudos/progresso',db);return {ok,res};};
  for(const token of tokens) assert.equal((await authorize(token)).ok,true);
  for (const [method,path] of [['GET','/api/temas/5/respostas'],['DELETE','/api/temas/5/respostas'],['POST','/api/questoes/5/responder']]) {
    const res=response();
    assert.equal(await autorizarRota({method,headers:{authorization:`Bearer ${tokens[0]}`}},res,path,db),true);
  }

  await assert.rejects(alterarSenha(db,1,{senhaAtual:'errada',novaSenha:'Senha-nova-123'}),/Senha atual incorreta/); assert.equal(version,0);
  await alterarSenha(db,1,{senhaAtual:'Senha-antiga-123',novaSenha:'Senha-nova-123'});
  assert.equal(await bcrypt.compare('Senha-nova-123',hash),true);
  for(const token of tokens){const {ok,res}=await authorize(token); assert.equal(ok,false);assert.equal(res.code,401);}
  assert.equal((await authorize(jwt.sign({id:1,ver:1},secret,{expiresIn:'1h'}))).ok,true);
  const failingDb={from(table){return {select(){return this;},eq(){return this;},async maybeSingle(){return table==='usuarios'?{error:{message:'SEGREDO_INTERNO'}}:{data:null};}};}};
  const unavailable=response(); assert.equal(await autorizarRota({method:'GET',headers:{authorization:`Bearer ${tokens[0]}`}},unavailable,'/api/estudos/progresso',failingDb),false); assert.equal(unavailable.code,503);
});
test('prova usa dono do JWT, valida IDs e oculta erros SQL', async () => {
  const calls=[];let result={data:{erro_codigo:'BASE_INSUFICIENTE'}};
  const db={async rpc(name,params){calls.push({name,params});return result;}};
  const req={method:'POST',usuario:{id:7},body:{usuarios_idusuarios:999}};
  const base=response();await tentativasRoutes(req,base,'/api/tentativas',db);assert.equal(base.code,409);assert.deepEqual(calls[0],{name:'iniciar_prova',params:{p_usuario:7}});
  const invalid=response();await tentativasRoutes({...req,body:{questoes_idquestoes:'1',alternativas_idalternativas:1}},invalid,'/api/tentativas/1/respostas',db); assert.equal(invalid.code,400);assert.equal(calls.length,1);
  for(const code of ['FORA_SEQUENCIA','TEMPO_ESGOTADO','PENDENTE','PROVA_INVALIDA']) {result={data:{erro_codigo:code}};const res=response();await tentativasRoutes({...req,body:{questoes_idquestoes:1,alternativas_idalternativas:2}},res,'/api/tentativas/1/respostas',db);assert.equal(res.code,409);}
  result={error:{message:'SEGREDO_INTERNO tabela senha_hash',code:'42501'}};
  for(const [method,path] of [['POST','/api/tentativas'],['GET','/api/tentativas/1/proxima-questao'],['POST','/api/tentativas/1/respostas'],['POST','/api/tentativas/1/finalizar']]) {const res=response();await tentativasRoutes({...req,method,body:{questoes_idquestoes:1,alternativas_idalternativas:2}},res,path,db);assert.equal(res.code,500);assert.doesNotMatch(JSON.stringify(res.body),/SEGREDO_INTERNO|senha_hash/);assert.ok(res.headers['X-Request-ID']);}
});
test('leituras e escritas não expõem mensagens do banco', async () => {
  for(const code of ['23505','23503','42501']) {
    const db={from(){const q={select(){return q;},insert(){return q;},update(){return q;},delete(){return q;},eq(){return q;},order(){return q;},is(){return q;},single(){return q;},maybeSingle(){return q;},then(resolve){return Promise.resolve({error:{code,message:'SEGREDO_INTERNO SQL'}}).then(resolve);}};return q;}};
    for(const [fn,path] of [[temasRoutes,'/api/temas'],[conteudosRoutes,'/api/conteudos'],[questoesRoutes,'/api/questoes'],[alternativasRoutes,'/api/questoes/1/alternativas']]) for(const method of ['GET','POST']) {const res=response();await fn({method,body:{nome:'Teste',temas_idtemas:1}},res,path,db);assert.ok(res.code>=400,`${method} ${path}`);assert.doesNotMatch(JSON.stringify(res.body),/SEGREDO_INTERNO|SQL/);}
    const res=response();await certificadosRoutes({method:'GET'},res,'/api/usuarios/1/certificados',db);assert.ok(res.code>=400);assert.doesNotMatch(JSON.stringify(res.body),/SEGREDO_INTERNO/);
  }
});
