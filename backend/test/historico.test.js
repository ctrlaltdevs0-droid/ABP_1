import assert from 'node:assert/strict';
import { test } from 'node:test';
import { historicoRoutes } from '../src/routes/historico.js';

function response() {
  return { writeHead(code) { this.statusCode = code; }, end(body) { this.body = JSON.parse(body); } };
}

// Banco falso com duas tentativas: a 1 é do usuário 1 e a 2 é do usuário 2.
function database() {
  const tentativas = [
    { idtentativas: 1, usuarios_idusuarios: 1, status: 'FINALIZADA', acertos: 8, percentual: 66.67, aprovado: true },
    { idtentativas: 2, usuarios_idusuarios: 2, status: 'EM_ANDAMENTO', acertos: 0, percentual: 0, aprovado: false },
  ];
  const questoes = [
    { tentativas_idtentativas: 1, ordem: 1, respondida: true, acertou: false, resposta_escolhida: 'B', resposta_correta: 'A',
      respondido_em: '2026-11-01T10:00:00Z', questoes: { enunciado: 'Pergunta 1', temas: { nome: 'Kanban' } } },
  ];
  return {
    from(tabela) {
      const filtros = {};
      const consulta = {
        select() { return consulta; },
        order() { return consulta; },
        eq(campo, valor) { filtros[campo] = valor; return consulta; },
        maybeSingle() { return consulta.then(({ data }) => ({ data: data[0] ?? null, error: null })); },
        then(ok) {
          const linhas = tabela === 'tentativas' ? tentativas : questoes;
          const data = linhas.filter(linha => Object.entries(filtros).every(([c, v]) => linha[c] === v));
          return Promise.resolve({ data, error: null }).then(ok);
        },
      };
      return consulta;
    },
  };
}

async function get(usuario, caminho) {
  const res = response();
  await historicoRoutes({ method: 'GET', usuario: { id: usuario } }, res, caminho, database());
  return res;
}

test('histórico lista somente as tentativas do próprio candidato', async () => {
  const res = await get(1, '/api/historico');
  assert.equal(res.statusCode, 200);
  assert.deepEqual(res.body.map(t => t.idtentativas), [1]);
});

test('detalhe mostra resposta escolhida, correta e data', async () => {
  const res = await get(1, '/api/historico/1');
  assert.equal(res.statusCode, 200);
  assert.deepEqual(res.body.questoes[0], {
    ordem: 1, tema: 'Kanban', enunciado: 'Pergunta 1', resposta_escolhida: 'B',
    resposta_correta: 'A', acertou: false, respondido_em: '2026-11-01T10:00:00Z',
  });
});

test('candidato não vê tentativa de outra pessoa nem gabarito de prova em andamento', async () => {
  assert.equal((await get(1, '/api/historico/2')).statusCode, 404);
  assert.equal((await get(2, '/api/historico/2')).statusCode, 409);
});
