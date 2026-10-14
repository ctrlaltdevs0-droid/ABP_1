import { Router } from "express";
import listarTemas from "../services/temas.js";

const rotas = Router();
rotas.get("/", async (req, res) => {
  try {
    res.json(await listarTemas());
  } catch {
    res.status(503).json({ erro: "Não foi possível consultar os temas." });
  }
});
export default rotas;