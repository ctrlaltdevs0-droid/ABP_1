import assert from 'node:assert/strict';
import { test } from 'node:test';
import { hashToken, revogarToken, tokenRevogado } from '../src/services/sessoes.js';
import { autorizarRota } from '../src/middleware/autorizacao.js';
import jwt from 'jsonwebtoken';

test('revogação armazena somente hash, sobrevive a outra leitura e é idempotente', async () => {
  const rows = new Map();
  const db = { from(table) {
    assert.equal(table, 'sessoes_revogadas');
    return { async upsert(row, options) {
      assert.equal(options.ignoreDuplicates, true);
      if (!rows.has(row.token_hash)) rows.set(row.token_hash, row);
      return { error: null };
    }, select() { return { eq(k,v) { return { maybeSingle: async () => ({ data: rows.get(v) ?? null }) }; } }; } };
  } };
  const token = 'jwt-de-teste';
  assert.equal(await tokenRevogado(db, token), false);
  await revogarToken(db, token, 2000000000);
  await revogarToken(db, token, 2000000000);
  assert.equal(await tokenRevogado(db, token), true);
  assert.equal(rows.size, 1);
  assert.equal(rows.get(hashToken(token)).token_hash.length, 64);
  assert.doesNotMatch(JSON.stringify([...rows.values()]), /jwt-de-teste/);
});

test('sessão falha de forma fechada se armazenamento estiver indisponível', async () => {
  process.env.JWT_SECRET = 'segredo-de-teste-com-pelo-menos-32-caracteres';
  const token = jwt.sign({ id: 1 }, process.env.JWT_SECRET, { expiresIn: '1h' });
  const db = { from() { return { select() { return { eq() { return { maybeSingle: async () => ({ error: { message: 'interno' } }) }; } }; } }; } };
  const res = { status(code) { this.code=code; return this; }, json(body) { this.body=body; } };
  assert.equal(await autorizarRota({ method:'GET',headers:{ authorization:`Bearer ${token}` } }, res, '/api/estudos/progresso', db), false);
  assert.equal(res.code, 503);
  assert.doesNotMatch(JSON.stringify(res.body), /interno/);
});
