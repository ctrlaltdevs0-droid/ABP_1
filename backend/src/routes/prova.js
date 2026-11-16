import {
  responder,
  rotaExata,
  tratarErro,
} from "../utils/http.js";

import {
  gerarProva
} from "../services/prova.js";

export async function provaRoutes(req, res, pathname, supabase) {

  const base = "/api/prova/iniciar";

  // POST /api/prova/iniciar
  if (req.method === "POST" && rotaExata(pathname, base)) {

    try {

      const usuarioId = req.usuario.id;

      const resultado = await gerarProva(
        supabase,
        usuarioId
      );

      return responder(res, 201, resultado);

    } catch (err) {

      return tratarErro(res, err);

    }
  }

  return false;
}
