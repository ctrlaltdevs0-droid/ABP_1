// SALVA E CONSULTA NO SUPABASE
import supabase from "../../database/config.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

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
    console.error("Erro ao verificar CPF no Supabase:", erroBusca);
    // Exibe o erro real vindo do Supabase
    throw new Error(`Supabase erro: ${erroBusca.message || JSON.stringify(erroBusca)}`);
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
    console.error("Erro ao inserir usuário no Supabase:", error);
    throw new Error(`Supabase erro no cadastro: ${error.message || JSON.stringify(error)}`);
  }

  return data;
}

// FAZER LOGIN
export async function fazerLogin(cpf, senha) {
  // 1. Busca o usuário pelo CPF
  const { data: usuario, error } = await supabase
    .from("usuarios")
    .select("idusuarios, cpf, nome, senha_hash")
    .eq("cpf", cpf)
    .maybeSingle();

  if (error) {
    console.error("Erro ao buscar usuário no Supabase:", error);
    throw new Error(`Supabase erro no login: ${error.message || JSON.stringify(error)}`);
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
      id: usuario.idusuarios,
      cpf: usuario.cpf,
    },
    jwtSecret,
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
