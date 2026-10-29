import assert from 'node:assert/strict';
import { randomInt } from 'node:crypto';
const base = process.env.TEST_BASE_URL || 'http://127.0.0.1:3000';
async function request(path, { token, method = 'GET', body, status = 200 } = {}) {
  const response = await fetch(`${base}/api/${path}`, {
    method, headers: { 'Content-Type':'application/json', ...(token ? {Authorization:`Bearer ${token}`} : {}) },
    ...(body === undefined ? {} : {body:JSON.stringify(body)}), signal:AbortSignal.timeout(15000),
  });
  assert.equal(response.status, status, `${method} ${path}`);
  return response.status===204 ? null : response.json();
}
async function conta() {
  const cpf=String(randomInt(10000000000,99999999999));
  const body={cpf,nome:'Validação local',email:`validacao-${cpf}@example.com`,senha:'Senha-local-de-validacao-123'};
  await request('login/cadastro',{method:'POST',body,status:201});
  const login=await request('login/entrar',{method:'POST',body});
  return {body,...login};
}
await request('teste-supabase');
const {body, token}=await conta();
assert.ok(token);
const perfil=await request('usuarios/me',{token});
assert.equal(perfil.cpf,body.cpf);
const temas=await request('temas');
assert.equal(temas.length,12);
for(const tema of temas) {
  const materiais=await request(`temas/${tema.idtemas}/conteudos`,{token});
  assert.ok(materiais.length>0);
  assert.ok(materiais[0].descricao.length>400);
}
const temaId=temas[0].idtemas;
await request(`temas/${temaId}/conclusao`,{token,method:'PUT',body:{usuarios_idusuarios:999999}});
await request(`temas/${temaId}/conclusao`,{token,method:'PUT',body:{}});
assert.equal((await request('estudos/progresso',{token})).length,1);
await request('login/sair',{token,method:'POST',body:{},status:204});
await request('estudos/progresso',{token,status:401});
await request('usuarios/me',{token,status:401});
const nova=await request('login/entrar',{method:'POST',body});
assert.notEqual(nova.token,token);
assert.equal((await request('estudos/progresso',{token:nova.token})).length,1);
const outra=await conta();
assert.equal((await request('estudos/progresso',{token:outra.token})).length,0);
console.log('OK: cadastro, login, perfil, 12 temas/conteúdos, progresso idempotente, isolamento, logout revogado e novo login com progresso persistido.');
console.log('As contas de validação permanecem apenas no banco ao qual TEST_BASE_URL aponta.');
