import { Router } from "express";
import listarTemas from "../service/temas.js";

const rotas = Router();

rotas.get("/", async function (req, res) {
    const result = await listarTemas();
    res.send(result);
});

export default rotas;
