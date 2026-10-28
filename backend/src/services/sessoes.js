import { createHash } from 'node:crypto';

export function hashToken(token) {
  return createHash('sha256').update(token).digest('hex');
}

export async function tokenRevogado(db, token) {
  try {
    const { data, error } = await db
      .from('sessoes_revogadas')
      .select('token_hash')
      .eq('token_hash', hashToken(token))
      .maybeSingle();

    if (error) {
      console.warn('Aviso: Tabela sessoes_revogadas não encontrada ou indisponível.');
      return false; // Permite o acesso se a tabela não existir
    }

    return Boolean(data);
  } catch (err) {
    return false;
  }
}

export async function revogarToken(db, token, expira) {
  try {
    const { error } = await db.from('sessoes_revogadas').upsert({
      token_hash: hashToken(token),
      expira_em: new Date(expira * 1000).toISOString(),
    }, { onConflict: 'token_hash', ignoreDuplicates: true });

    if (error) console.warn('Aviso: Não foi possível registrar revogação.');
  } catch (err) {
    // Trata falha na revogação silenciosamente
  }
}