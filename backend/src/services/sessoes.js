
import { createHash } from 'node:crypto';

export function hashToken(token) {
  return createHash('sha256').update(token).digest('hex');
}

export async function tokenRevogado(db, token) {
  const { data, error } = await db
    .from('sessoes_revogadas')
    .select('token_hash')
    .eq('token_hash', hashToken(token))
    .maybeSingle();

  if (error) {
    throw new Error('Não foi possível verificar a sessão.');
  }

  return Boolean(data);
}

export async function revogarToken(db, token, expira) {
  if (!Number.isSafeInteger(expira) || expira <= 0) {
    throw new Error('Expiração do token inválida.');
  }

  const { error } = await db
    .from('sessoes_revogadas')
    .upsert({
      token_hash: hashToken(token),
      expira_em: new Date(expira * 1000).toISOString(),
    }, {
      onConflict: 'token_hash',
      ignoreDuplicates: true,
    });

  if (error) {
    throw new Error('Não foi possível encerrar a sessão.');
  }
}
