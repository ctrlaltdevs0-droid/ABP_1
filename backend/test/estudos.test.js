import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFile } from 'node:fs/promises';
import { gerarSeed } from '../scripts/gerar-seed-estudos.js';
import { progressoRoutes } from '../src/routes/progresso.js';
import { autorizarRota } from '../src/middleware/autorizacao.js';
import jwt from 'jsonwebtoken';

function response() {
  return { writeHead(code) { this.statusCode = code; }, end(body) { this.body = JSON.parse(body); },
    status(code) { this.statusCode = code; return this; }, json(body) { this.body = body; } };
}
function database() {
  const rows = [];
  const calls = [];
  let active = true, content = true, fail = false;
  return {
    rows, calls,
    set active(value) { active = value; }, set content(value) { content = value; }, set fail(value) { fail = value; },
    from(table) {
      const filters = {};
      let operation, payload, options;
      const result = () => {
        if (fail) return { error: { message: 'SEGREDO_INTERNO' } };
        if (table === 'sessoes_revogadas') return { data: null };
        if (table === 'temas') return { data: active ? { idtemas: 5 } : null };
        if (table === 'conteudos') return { data: content ? [{ idconteudo: 1 }] : [] };
        if (operation === 'upsert') {
          assert.equal(options.onConflict, 'usuarios_idusuarios,temas_idtemas');
          assert.equal(options.ignoreDuplicates, true);
          if (!rows.some(r => r.usuarios_idusuarios === payload.usuarios_idusuarios && r.temas_idtemas === payload.temas_idtemas)) rows.push({ ...payload, concluido_em: '2026-10-26T12:00:00Z' });
          return { error: null };
        }
        return { data: rows.filter(r => Object.entries(filters).every(([k,v]) => r[k] === v)) };
      };
      const q = { select() { return q; }, eq(k,v) { filters[k] = v; calls.push([table,k,v]); return q; },
        limit() { return q; }, maybeSingle: async () => result(),
        upsert(p,o) { operation = 'upsert'; payload = p; options = o; return q; },
        then(resolve,reject) { return Promise.resolve(result()).then(resolve,reject); } };
      return q;
    },
  };
}
test('carga contém 12 materiais, 48 questões e quatro alternativas distintas; SQL gerado está atualizado', async () => {
  const data = JSON.parse(await readFile(new URL('../database/content-estudos.json', import.meta.url)));
  assert.equal(data.length, 12);
  assert.equal(data.flatMap(t => t.questoes).length, 48);
  for (const tema of data) {
    assert.ok(tema.texto.length > 400, tema.nome);
    assert.equal(tema.questoes.length, 4);
    for (const q of tema.questoes) assert.equal(new Set(q.slice(1)).size, 4);
  }
  assert.equal(await gerarSeed(), await readFile(new URL('../database/seed-estudos.sql', import.meta.url), 'utf8'));
});
test('progresso persiste, é idempotente e pertence ao JWT, inclusive em novo acesso', async () => {
  const db = database();
  const put = async (id, body = {}) => {
    const res = response();
    await progressoRoutes({ method: 'PUT', usuario: { id }, body }, res, '/api/temas/5/conclusao', db);
    return res;
  };
  assert.equal((await put(1, { usuarios_idusuarios: 2 })).statusCode, 200);
  assert.equal((await put(1)).statusCode, 200);
  assert.equal(db.rows.length, 1);
  const get = async id => {
    const res = response();
    await progressoRoutes({ method: 'GET', usuario: { id } }, res, '/api/estudos/progresso', db);
    return res;
  };
  assert.equal((await get(1)).body.length, 1);
  assert.deepEqual((await get(2)).body, []);
  assert.equal((await put(2)).statusCode, 200);
  assert.equal(db.rows.length, 2);
  assert.equal((await get(1)).body.length, 1);
  db.active = false;
  assert.equal((await put(1)).statusCode, 404);
  db.active = true; db.content = false;
  assert.equal((await put(1)).statusCode, 409);
  db.fail = true;
  const failed = await put(1);
  assert.equal(failed.statusCode, 503);
  assert.doesNotMatch(JSON.stringify(failed.body), /SEGREDO_INTERNO/);
});
test('rotas de progresso exigem autenticação e não autorizam consultar outro candidato', async () => {
  process.env.JWT_SECRET = 'segredo-de-teste-com-pelo-menos-32-caracteres';
  const token = jwt.sign({ id: 1 }, process.env.JWT_SECRET, { expiresIn: '1h' });
  for (const [method, path] of [['GET','/api/estudos/progresso'], ['PUT','/api/temas/5/conclusao']]) {
    const res = response();
    assert.equal(await autorizarRota({ method, headers: {} }, res, path, database()), false);
    assert.equal(res.statusCode, 401);
    const req = { method, headers: { authorization: `Bearer ${token}` } };
    assert.equal(await autorizarRota(req, response(), path, database()), true);
    assert.equal(req.usuario.id, 1);
  }
  const res = response();
  assert.equal(await autorizarRota({ method: 'GET', headers: { authorization: `Bearer ${token}` } }, res, '/api/usuarios/2/progresso', database()), false);
  assert.equal(res.statusCode, 403);
});
