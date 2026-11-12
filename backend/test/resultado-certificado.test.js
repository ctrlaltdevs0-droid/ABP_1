import test from 'node:test';
import assert from 'node:assert/strict';
import { resultadosRoutes } from '../src/routes/resultados.js';
import { certificadosRoutes } from '../src/routes/certificados.js';

function resposta() {
  return {
    writableEnded: false,
    writeHead(status, headers) { this.status = status; this.headers = headers; },
    end(body) { this.body = body ? JSON.parse(body) : null; this.writableEnded = true; },
  };
}
function dbFake(tabelas = {}) {
  const chamadas = [];
  return {
    chamadas,
    from(tabela) {
      const filtros = [];
      const query = {
        select() { return this; },
        eq(nome, valor) { filtros.push([nome, valor]); return this; },
        is(nome, valor) { filtros.push([nome, valor]); return this; },
        order() { return Promise.resolve({ data: this.filtrar(), error: null }); },
        filtrar() {
          return (tabelas[tabela] || []).filter(item => filtros.every(([nome, valor]) => item[nome] === valor));
        },
        maybeSingle() {
          chamadas.push({ tabela, filtros: [...filtros] });
          return Promise.resolve({ data: this.filtrar()[0] ?? null, error: null });
        },
      };
      return query;
    },
  };
}
const req = (id = 1) => ({ method: 'GET', usuario: { id } });

test('resultado aprovado é calculado do banco, não do cliente', async () => {
  const db = dbFake({
    tentativas: [{ idtentativas: 8, usuarios_idusuarios: 1, status: 'FINALIZADA', acertos: 8, percentual: 66.67, aprovado: true, finalizado_em: '2026-11-11' }],
    certificados: [{ idcertificados: 2, tentativas_idtentativas: 8, usuarios_idusuarios: 1, codigo_validacao: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', ativo: true, revogado_em: null }],
  });
  const res = resposta();
  await resultadosRoutes(req(), res, '/api/tentativas/8/resultado', db);
  assert.equal(res.status, 200);
  assert.equal(res.body.aprovado, true);
  assert.equal(res.body.erros, 4);
  assert.equal(res.body.certificado.idcertificados, 2);
  assert.ok(db.chamadas.every(x => x.filtros.some(([k,v]) => k === 'usuarios_idusuarios' && v === 1)));
});

test('7 de 12 reprovado e sem certificado', async () => {
  const db = dbFake({ tentativas: [{ idtentativas: 9, usuarios_idusuarios: 1, status: 'FINALIZADA', acertos: 7, percentual: 58.33, aprovado: false }] });
  const res = resposta();
  await resultadosRoutes(req(), res, '/api/tentativas/9/resultado', db);
  assert.equal(res.status, 200);
  assert.equal(res.body.aprovado, false);
  assert.equal(res.body.certificado, null);
});

test('não revela tentativa pertencente a outro usuário', async () => {
  const db = dbFake({ tentativas: [{ idtentativas: 9, usuarios_idusuarios: 5, status: 'FINALIZADA' }] });
  const res = resposta();
  await resultadosRoutes(req(1), res, '/api/tentativas/9/resultado', db);
  assert.equal(res.status, 404);
});

test('não revela certificado de outro usuário', async () => {
  const db = dbFake({ certificados: [{ idcertificados: 4, usuarios_idusuarios: 5, ativo: true }] });
  const res = resposta();
  await certificadosRoutes(req(1), res, '/api/certificados/4', db);
  assert.equal(res.status, 404);
});

test('validação pública rejeita código inexistente', async () => {
  const res = resposta();
  await certificadosRoutes({ method: 'GET' }, res, '/api/certificados/validar/aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', dbFake());
  assert.equal(res.status, 404);
  assert.equal(res.body.valido, false);
});

test('validação pública oculta dados pessoais', async () => {
  const db = dbFake({ certificados: [{ codigo_validacao: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', emitido_em: '2026-11-11', percentual: 75, ativo: true, revogado_em: null, usuarios_idusuarios: 99 }] });
  const res = resposta();
  await certificadosRoutes({ method: 'GET' }, res, '/api/certificados/validar/aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', db);
  assert.equal(res.status, 200);
  assert.equal(res.body.valido, true);
  assert.equal(JSON.stringify(res.body).includes('usuarios_idusuarios'), false);
});
