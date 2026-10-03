import { Router } from "express";
import listarTemasService from "../services/temas.js";

const rotas = Router();

rotas.get("/", async function(req,res){
    const resposta = await listarTemasService();
    res.send(resposta);
});

export default rotas;