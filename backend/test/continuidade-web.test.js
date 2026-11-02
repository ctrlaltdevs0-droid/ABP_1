import { test } from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { readFile } from 'node:fs/promises';
import { randomUUID } from 'node:crypto';

// Porta mínima do DOM para exercitar eventos de rede e respostas atrasadas.
class Element {
  hidden=true; textContent=''; children=[]; events={}; disabled=false;
  addEventListener(name,fn){this.events[name]=fn;}
  append(...children){this.children.push(...children);}
  replaceChildren(...children){this.children=children;}
  querySelectorAll(){return [];}
  focus(){}
}
const flush = () => new Promise(resolve => setImmediate(resolve));
async function pagina() {
  const elementos=new Map(); const eventos={}; const calls=[];
  const estado={tentativa:{idtentativas:42,status:'EM_ANDAMENTO'},respondidas:0,total_questoes:12,pendentes:12};
  let proxima;
  const get=id=>{if(!elementos.has(id))elementos.set(id,new Element());return elementos.get(id);};
  const navigator={onLine:true};
  const context=vm.createContext({
    document:{getElementById:get,createElement:()=>new Element(),createTextNode:text=>text},
    window:{location:{replace(){throw Error('Não deveria sair da sessão');}},
      addEventListener:(name,fn)=>{eventos[name]=fn;},
      AgilCertAPI:{async request(path,options){
        calls.push({path,options});
        if(path==='tentativas/atual')return {tentativa:null};
        if(path.endsWith('proxima-questao'))return proxima;
        return structuredClone(estado);
      }}},
    localStorage:{getItem:()=> 'token-teste'},navigator,
    crypto:{randomUUID},performance,Date,URL,location:{href:'http://localhost/certificacao.html',origin:'http://localhost'},
    setInterval(){},console,
  });
  vm.runInContext(await readFile(new URL('../../frontend/src/assets/js/certificacao.js',import.meta.url),'utf8'),context);
  await flush();
  await get('prova-iniciar').events.click();
  return {get,eventos,calls,navigator,context,setProxima(value){proxima=value;}};
}
function questao(){return {questao:{idquestoes:9,enunciado:'Questão de teste'},ordem:1,alternativas:[{idalternativas:2,letra:'A',texto:'Alternativa'}],iniciado_em:new Date().toISOString(),agora:new Date().toISOString(),expira_em:new Date(Date.now()+150000).toISOString()};}

test('web: offline bloqueia resposta; fechamento envia sessão e questão com keepalive',async()=>{
  const p=await pagina();p.setProxima(questao());await p.get('prova-proxima').events.click();
  assert.equal(p.get('prova-questao').hidden,false);
  p.eventos.pagehide();await flush();
  const fechamento=p.calls.at(-1);
  assert.equal(fechamento.options.keepalive,true);
  assert.equal(fechamento.options.body.motivo,'FECHAMENTO');
  assert.equal(fechamento.options.body.questoes_idquestoes,9);
  p.navigator.onLine=false;p.eventos.offline();await flush();
  assert.equal(p.get('prova-questao').hidden,true);
  assert.equal(p.get('prova-responder').disabled,true);
  assert.equal(p.calls.at(-1).options.body.motivo,'CONEXAO');
  p.navigator.onLine=true;p.eventos.online();
  await p.get('prova-recuperar').events.click();
  assert.equal(p.calls.at(-1).path,'tentativas/42/retomar');
  assert.notEqual(p.calls.at(-1).options.body.sessao,fechamento.options.body.sessao);
  assert.equal(p.get('prova-questao').hidden,true);
});

test('web: resposta atrasada de abertura não reativa questão após offline',async()=>{
  const p=await pagina();let resolver;
  p.setProxima(new Promise(resolve=>{resolver=resolve;}));
  const pendente=p.get('prova-proxima').events.click();
  p.navigator.onLine=false;p.eventos.offline();resolver(questao());await pendente;
  assert.equal(p.get('prova-questao').hidden,true);
  assert.equal(p.get('prova-recuperar').hidden,false);
  assert.match(p.get('prova-mensagem').textContent,/Conexão perdida/);
});
