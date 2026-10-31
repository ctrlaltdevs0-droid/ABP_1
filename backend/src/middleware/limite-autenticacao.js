import { createHmac } from 'node:crypto';
import { randomUUID } from 'node:crypto';

export function limitarAutenticacao(db) {
  return async (req, res, next) => {
    const path = req.path.toLowerCase().replace(/\/$/, '');
    if (req.method !== 'POST' || !['/entrar', '/cadastro'].includes(path)) return next();
    const cadastro = path === '/cadastro';
    const cpf = String(req.body?.cpf ?? '').replace(/\D/g, '');
    const hash = valor => createHmac('sha256', process.env.JWT_SECRET.trim()).update(valor).digest('hex');
    // Express não confia em X-Forwarded-For por padrão; não confiar em cabeçalho do cliente.
    const escopo = cadastro ? 'cadastro' : 'login';
    try {
      const { data, error } = await db.rpc('limitar_autenticacao', {
        p_ip: hash(`${escopo}:ip:${req.ip}`),
        p_conta: hash(`${escopo}:conta:${/^\d{11}$/.test(cpf) ? cpf : 'invalida'}`),
        p_cadastro: cadastro,
      });
      if (error) throw error;
      if (!data || typeof data.permitido !== 'boolean') throw new Error('Resposta inválida do limitador.');
      if (!data.permitido) {
        res.set('Retry-After', String(Math.max(1, Number(data.retry_after) || 900)));
        return res.status(429).json({ erro: 'Muitas tentativas. Tente novamente mais tarde.' });
      }
      next();
    } catch (error) {
      const id = randomUUID();
      console.error('Falha no limitador de autenticação', { id, code: error.code ?? 'INTERNAL' });
      res.status(503).json({ erro: 'Autenticação temporariamente indisponível.', id });
    }
  };
}
