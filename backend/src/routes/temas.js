import { Router } from "express";
import listarTemas from "../service/temas.js";

const rotas = Router();
rotas.get("/", async (req, res) => {
  try {
    res.json(await listarTemas());
  } catch {
    res.status(503).json({ erro: "NÃ£o foi possÃ­vel consultar os temas." });
  }
});
export default rotas;