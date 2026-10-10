import express from "express";
import {
  cadastrarUsuario,
  fazerLogin,
} from "../services/login.js";

const rotas = express.Router();

// ROTA DE CADASTRO
rotas.post("/cadastro", async (req, res) => {
  try {
    const { cpf, nome, senha } = req.body;

    if (!cpf || !nome || !senha) {
      return res.status(400).json({
        erro: "Preencha CPF, nome e senha.",
      });
    }

    const cpfLimpo = String(cpf).replace(/\D/g, "");

    if (!/^\d{11}$/.test(cpfLimpo)) {
      return res.status(400).json({
        erro: "CPF deve conter 11 números.",
      });
    }

    if (typeof nome !== "string" || !nome.trim()) {
      return res.status(400).json({
        erro: "Informe um nome válido.",
      });
    }

    if (typeof senha !== "string" || senha.length < 8) {
      return res.status(400).json({
        erro: "A senha deve ter pelo menos 8 caracteres.",
      });
    }

    const usuario = await cadastrarUsuario(
      cpfLimpo,
      nome.trim(),
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

    console.error(erro);

    return res.status(500).json({
      erro: "Erro interno ao cadastrar usuário.",
    });
  }
});

// ROTA DE LOGIN
rotas.post("/entrar", async (req, res) => {
  try {
    const { cpf, senha } = req.body;

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

    if (typeof senha !== "string") {
      return res.status(400).json({
        erro: "Senha inválida.",
      });
    }

    const resultado = await fazerLogin(cpfLimpo, senha);

    return res.status(200).json({
      mensagem: "Login realizado com sucesso!",
      ...resultado,
    });
  } catch (erro) {
    if (erro.message === "CPF ou senha inválidos.") {
      return res.status(401).json({ erro: erro.message });
    }

    console.error(erro);

    return res.status(500).json({
      erro: "Erro interno ao realizar login.",
    });
  }
});

export default rotas;