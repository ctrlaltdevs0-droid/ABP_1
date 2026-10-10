import "dotenv/config";
import express from "express";
import rotas from "./routes/temas.js";
import supabase from "../database/config.js";
import rotasLogin from "./routes/login.js";

const app = express();
const porta = process.env.PORT || 3000;

// Permite receber JSON nas requisições.
app.use(express.json());

app.use("/api/temas", rotas);
app.use("/api/login", rotasLogin);

// Rotas da aplicação.
app.use("/api/temas", rotas);

// Rota básica para verificar se a API está funcionando.
app.get("/api", (req, res) => {
  res.json({ mensagem: "API Ctrl Alt Devs funcionando." });
});

// Rota temporária para testar a conexão com o Supabase.
app.get("/api/teste-supabase", async (req, res) => {
  try {
    const { data, error } = await supabase
      .from("usuarios")
      .select("*")
      .limit(5);

    if (error) {
      return res.status(500).json({ erro: error.message });
    }

    return res.json(data);
  } catch (erro) {
    return res.status(500).json({
      erro: "Erro ao conectar com o Supabase.",
      detalhe: erro.message,
    });
  }
});

app.listen(porta, () => {
  console.log(`Servidor rodando em http://localhost:${porta}`);
});