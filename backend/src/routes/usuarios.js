import bcrypt from 'bcrypt';
import { ErroHttp } from '../utils/http.js';

const campos = 'idusuarios, nome, email, cpf';
const publico = u => ({ id: u.idusuarios, nome: u.nome, email: u.email, cpf: u.cpf });
export async function consultarPerfil(db, id) {
  const { data, error } = await db.from('usuarios').select(campos).eq('idusuarios', id).maybeSingle();
  if (error) throw new ErroHttp(500);
  if (!data) throw new ErroHttp(404, 'Usuário não encontrado.');
  return publico(data);
}
export async function atualizarPerfil(db, id, body) {
  const patch = {};
  if (Object.keys(body).some(k => !['nome', 'email'].includes(k))) throw new ErroHttp(400, 'Somente nome e email podem ser alterados.');
  if ('nome' in body) {
    if (typeof body.nome !== 'string' || !body.nome.trim() || body.nome.trim().length > 50) throw new ErroHttp(400, 'Nome deve ter entre 1 e 50 caracteres.');
    patch.nome = body.nome.trim();
  }
  if ('email' in body) {
    if (typeof body.email !== 'string' || body.email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(body.email.trim())) throw new ErroHttp(400, 'Informe um email válido.');
    patch.email = body.email.trim().toLowerCase();
  }
  if (!Object.keys(patch).length) throw new ErroHttp(400, 'Informe nome ou email.');
  const { data, error } = await db.from('usuarios').update(patch).eq('idusuarios', id).select(campos).maybeSingle();
  if (error) throw new ErroHttp(error.code === '23505' ? 409 : 500);
  if (!data) throw new ErroHttp(404, 'Usuário não encontrado.');
  return publico(data);
}
export async function alterarSenha(db, id, body) {
  const { senhaAtual, novaSenha } = body;
  if (typeof senhaAtual !== 'string' || !senhaAtual || Buffer.byteLength(senhaAtual) > 72 || typeof novaSenha !== 'string' || novaSenha.length < 8 || Buffer.byteLength(novaSenha) > 72) throw new ErroHttp(400, 'Informe a senha atual e uma nova senha com pelo menos 8 caracteres e no máximo 72 bytes.');
  const { data, error } = await db.from('usuarios').select('senha_hash').eq('idusuarios', id).maybeSingle();
  if (error) throw new ErroHttp(500);
  if (!data) throw new ErroHttp(404, 'Usuário não encontrado.');
  if (!(await bcrypt.compare(senhaAtual, data.senha_hash))) throw new ErroHttp(400, 'Senha atual incorreta.');
  const hash = await bcrypt.hash(novaSenha, 10);
  const { data: alterada, error: erroTroca } = await db.rpc('alterar_senha_segura', {
    p_usuario: id, p_hash_atual: data.senha_hash, p_hash_novo: hash,
  });
  if (erroTroca) throw new ErroHttp(500);
  if (alterada !== true) throw new ErroHttp(409, 'A senha foi alterada em outra sessão. Tente novamente.');
}
