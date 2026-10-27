import express from "express";
import {
  cadastrarUsuario,
  fazerLogin,
} from "../services/login.js";

import { autorizarRota } from '../middleware/autorizacao.js';
import { revogarToken } from '../services/sessoes.js';

const rotas = express.Router();
rotas.post('/sair', async (req, res, next) => {
  try {
    const { default: db } = await import('../../database/config.js');
    if (!(await autorizarRota(req, res, '/api/login/sair', db))) return;
    await revogarToken(db, req.token, req.usuario.exp);
    res.status(204).end();
  } catch (error) { next(error); }
});

// ROTA DE CADASTRO (POST /api/login/cadastro)
rotas.post("/cadastro", async (req, res) => {
  try {
    const { cpf, nome, email, senha } = req.body ?? {};

    // Validação de campos obrigatórios
    if (!cpf || !nome || !email || !senha) {
      return res.status(400).json({
        erro: "Preencha CPF, nome, e-mail e senha.",
      });
    }

    // Limpa pontuações do CPF (deixa apenas números)
    const cpfLimpo = String(cpf).replace(/\D/g, "");

    if (!/^\d{11}$/.test(cpfLimpo)) {
      return res.status(400).json({
        erro: "CPF deve conter 11 números.",
      });
    }

    if (typeof nome !== "string" || !nome.trim() || nome.trim().length > 50) {
      return res.status(400).json({
        erro: "Informe um nome válido.",
      });
    }

    if (typeof email !== "string" || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
      return res.status(400).json({ erro: "Informe um e-mail válido." });
    }

    if (typeof senha !== "string" || senha.length < 8 || Buffer.byteLength(senha, 'utf8') > 72) {
      return res.status(400).json({
        erro: "A senha deve ter pelo menos 8 caracteres e no máximo 72 bytes.",
      });
    }

    // Executa o cadastro passando o email
    const usuario = await cadastrarUsuario(
      cpfLimpo,
      nome.trim(),
      email.trim().toLowerCase(),
      senha
    );

    return res.status(201).json({
      mensagem: "Usuário cadastrado com sucesso!",
      usuario,
    });
  } catch (erro) {
    if (erro.message === "CPF já cadastrado.") {
      return res.status(409).json({ erro: erro.message });
    }

    console.error("Erro na rota de cadastro:", erro);

    return res.status(500).json({
      erro: "Erro interno ao cadastrar usuário.",
    });
  }
});

// ROTA DE LOGIN (POST /api/login/entrar)
rotas.post("/entrar", async (req, res) => {
  try {
    const { cpf, senha } = req.body ?? {};

    if (!cpf || !senha) {
      return res.status(400).json({
        erro: "Informe CPF e senha.",
      });
    }

    const cpfLimpo = String(cpf).replace(/\D/g, "");

    if (!/^\d{11}$/.test(cpfLimpo)) {
      return res.status(400).json({
        erro: "CPF deve conter 11 números.",
      });
    }

    if (typeof senha !== "string" || Buffer.byteLength(senha, 'utf8') > 72) {
      return res.status(400).json({
        erro: "Senha inválida.",
      });
    }

    // Executa o login e gera o token
    const resultado = await fazerLogin(cpfLimpo, senha);

    return res.status(200).json({
      mensagem: "Login realizado com sucesso!",
      ...resultado,
    });
  } catch (erro) {
    if (erro.message === "CPF ou senha inválidos.") {
      return res.status(401).json({ erro: erro.message });
    }

    console.error("Erro na rota de login:", erro);

    return res.status(500).json({
      erro: "Erro interno ao realizar login.",
    });
  }
});

export default rotas;
