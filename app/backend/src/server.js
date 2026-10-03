import express from "express";
import temas from "./routes/temas.js";

const porta = process.env.APP_PORT;
const app = express();

app.use("/api/temas", temas);

app.listen(porta, function(){
    console.log(`Rodando em http://localhost:${porta}`);
});