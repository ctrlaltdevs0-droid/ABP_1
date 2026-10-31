// SALVA E CONSULTA NO SUPABASE
import supabase from "../config/supabase.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { randomUUID } from "node:crypto";

const jwtSecret = process.env.JWT_SECRET?.trim();
if (!jwtSecret || jwtSecret.length < 32 || jwtSecret === 'sua_chave_secreta_aqui') {
  throw new Error('Defina JWT_SECRET com pelo menos 32 caracteres aleatórios no ambiente do servidor.');
}

// CADASTRAR USUÁRIO
export async function cadastrarUsuario(cpf, nome, email, senha) {
  // 1. Verifica se o CPF já está cadastrado
  const { data: existente, error: erroBusca } = await supabase
    .from("usuarios")
    .select("idusuarios")
    .eq("cpf", cpf)
    .maybeSingle();

  if (erroBusca) {
    throw erroBusca;
  }

  if (existente) {
    throw new Error("CPF já cadastrado.");
  }

  // 2. Criptografa a senha com bcrypt
  const senhaHash = await bcrypt.hash(senha, 10);

  // 3. Insere o novo registro na tabela 'usuarios' incluindo o email
  const { data, error } = await supabase
    .from("usuarios")
    .insert({
      cpf,
      nome,
      email,
      senha_hash: senhaHash,
    })
    .select("idusuarios, cpf, nome, email")
    .single();

  if (error) {
    throw error;
  }

  return data;
}

// FAZER LOGIN
export async function fazerLogin(cpf, senha) {
  // 1. Busca o usuário pelo CPF
  const { data: usuario, error } = await supabase
    .from("usuarios")
    .select("idusuarios, cpf, nome, senha_hash, versao_sessao")
    .eq("cpf", cpf)
    .maybeSingle();

  if (error) {
    throw error;
  }

  if (!usuario) {
    throw new Error("CPF ou senha inválidos.");
  }

  // 2. Compara a senha informada com o hash salvo no banco
  const senhaCorreta = await bcrypt.compare(senha, usuario.senha_hash);

  if (!senhaCorreta) {
    throw new Error("CPF ou senha inválidos.");
  }

  // 3. Gera o token de autenticação JWT
  const token = jwt.sign(
    {
      jti: randomUUID(),
      id: usuario.idusuarios,
      ver: usuario.versao_sessao,
      cpf: usuario.cpf,
    },
    jwtSecret,
    { expiresIn: "2h" }
  );

  return {
    usuario: {
      jti: randomUUID(),
      id: usuario.idusuarios,
      cpf: usuario.cpf,
      nome: usuario.nome,
    },
    token,
  };
}
