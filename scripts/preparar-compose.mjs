import { randomBytes, createHmac } from 'node:crypto';
import { writeFile } from 'node:fs/promises';
const random = () => randomBytes(32).toString('hex');
const dbSecret = random();
const encode = data => Buffer.from(JSON.stringify(data)).toString('base64url');
const payload = encode({ role: 'service_role', iss: 'abp-local', iat: Math.floor(Date.now()/1000), exp: Math.floor(Date.now()/1000) + 31536000 });
const body = `${encode({ alg: 'HS256', typ: 'JWT' })}.${payload}`;
const token = `${body}.${createHmac('sha256',dbSecret).update(body).digest('base64url')}`;
try {
  await writeFile(new URL('../.env.compose',import.meta.url), [
    '# Somente desenvolvimento local. Não versionar nem reutilizar em produção.',
    `POSTGRES_PASSWORD=${random()}`, `DB_AUTH_PASSWORD=${random()}`, `PGRST_JWT_SECRET=${dbSecret}`,
    `SUPABASE_SECRET_KEY=${token}`, `JWT_SECRET=${random()}`, 'APP_PORT=3000', 'ADMIN_USER_IDS=', '',
  ].join('\n'), { mode:0o600, flag:'wx' });
  console.log('.env.compose criado com segredos locais. Use docker compose --env-file .env.compose up --build -d.');
} catch (error) {
  if (error.code === 'EEXIST') console.log('.env.compose já existe; segredos preservados.');
  else throw error;
}
