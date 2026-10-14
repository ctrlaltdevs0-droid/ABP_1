import "dotenv/config";
import express from "express";
import rotas from "./routes/temas.js";
import supabase from "../database/config.js";

const app = express();
const porta = process.env.PORT || 3000;
app.use(express.json());
app.use("/api/temas", rotas);
app.get("/api", (req, res) => {
  res.json({ mensagem: "API Ctrl Alt Devs funcionando." });
});

// Verifica a conexÃ£o sem retornar registros ou informaÃ§Ãµes pessoais.
app.get("/api/teste-supabase", async (req, res) => {
  try {
    const { error } = await supabase
      .from("temas")
      .select("idtemas", { head: true })
      .limit(1);
    if (error) throw error;
    res.json({ status: "ok" });
  } catch {
    res.status(503).json({ erro: "Banco de dados indisponÃ­vel." });
  }
});

app.listen(porta, () => {
  console.log(`Servidor rodando em http://localhost:${porta}`);
});