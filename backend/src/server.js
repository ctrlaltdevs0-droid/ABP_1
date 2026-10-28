import express from "express";
import { fileURLToPath } from 'node:url';
import cors from "cors";
import rotasLogin from "./routes/login.js";
import { executarRotas } from "./routes/index.js";
import { autorizarRota } from './middleware/autorizacao.js';
import supabase from "./config/supabase.js";
import { questoesRoutes } from "./routes/questoes.js";

const app = express();
const porta = process.env.PORT || 3000;
app.use(cors());
app.use(express.json());
app.use("/api/login", rotasLogin);
app.get("/api", (req, res) => {
  res.json({ mensagem: "API Ctrl Alt Devs funcionando." });
});

// Verifica a conexão sem retornar registros ou informações pessoais.
app.get("/api/teste-supabase", async (req, res) => {
  try {
    const { error } = await supabase
      .from("temas")
      .select("idtemas", { head: true })
      .limit(1);
    if (error) throw error;
    res.json({ status: "ok" });
  } catch {
    res.status(503).json({ erro: "Banco de dados indisponível." });
  }
});

// Somente os arquivos públicos do frontend são servidos.
const frontendPath = fileURLToPath(new URL('../../frontend/src/', import.meta.url));
app.get('/', (req, res) => res.redirect('/login.html'));
app.use(express.static(frontendPath, { index: false, dotfiles: 'deny' }));

app.use(async (req, res, next) => {
  try {
    const pathname = req.path;
    if (!/^\/api\/(estudos|temas|conteudos|questoes|alternativas|tentativas|certificados|usuarios)(\/|$)/.test(pathname)) return next();
    if (!(await autorizarRota(req, res, pathname, supabase))) return;
    if (await questoesRoutes(req, res, pathname, supabase)) return;
    if (!(await executarRotas(req, res, pathname, supabase))) next();
  } catch (error) { next(error); }
});
app.use((req, res) => res.status(404).json({ erro: 'Rota não encontrada.' }));
app.use((error, req, res, next) => {
  if (res.headersSent) return next(error);
  const status = error.type === 'entity.too.large' ? 413 : error.type === 'entity.parse.failed' ? 400 : 500;
  res.status(status).json({ erro: status === 400 ? 'JSON inválido.' : status === 413 ? 'Conteúdo enviado muito grande.' : 'Erro interno do servidor.' });
});

export const server = app.listen(porta, () => {
  console.log(`Servidor rodando em http://localhost:${server.address().port}`);
});