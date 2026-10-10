//SALVA NO SUPABASE

import supabase from "../database/config.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

// CADASTRAR USUARIO
export async function cadastrarUsuario(cpf, nome, senha) {
  // Verifica se o CPF já existe
  const { data: existente, error: erroBusca } = await supabase
    .from("usuarios")
    .select("idusuarios")
    .eq("cpf", cpf)
    .maybeSingle();

  if (erroBusca) {
    throw new Error("Erro ao consultar usuário.");
  }

  if (existente) {
    throw new Error("CPF já cadastrado.");
  }

  // Transforma a senha em hash
  const senhaHash = await bcrypt.hash(senha, 10);

  // Salva no Supabase
  const { data, error } = await supabase
    .from("usuarios")
    .insert({
      cpf,
      nome,
      senha_hash: senhaHash,
    })
    .select("idusuarios, cpf, nome")
    .single();

  if (error) {
    throw new Error("Não foi possível cadastrar usuário.");
  }

  return data;
}

// FAZER LOGIN
export async function fazerLogin(cpf, senha) {
  // Procura o usuário pelo CPF
  const { data: usuario, error } = await supabase
    .from("usuarios")
    .select("idusuarios, cpf, nome, senha_hash")
    .eq("cpf", cpf)
    .maybeSingle();

  if (error) {
    throw new Error("Erro ao consultar usuário.");
  }

  if (!usuario) {
    throw new Error("CPF ou senha inválidos.");
  }

  // Compara a senha digitada com o hash salvo
  const senhaCorreta = await bcrypt.compare(
    senha,
    usuario.senha_hash
  );

  if (!senhaCorreta) {
    throw new Error("CPF ou senha inválidos.");
  }

  // Gera o token JWT
  const token = jwt.sign(
    {
      id: usuario.idusuarios,
      cpf: usuario.cpf,
    },
    process.env.JWT_SECRET,
    { expiresIn: "2h" }
  );

  return {
    usuario: {
      id: usuario.idusuarios,
      cpf: usuario.cpf,
      nome: usuario.nome,
    },
    token,
  };
}
