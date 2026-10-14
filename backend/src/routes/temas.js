import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";
import listarTemas from '../services/temas.js';

export async function temasRoutes(req, res, pathname, supabase) {
  const base = "/api/temas";
  const id = idDaRota(pathname, base);

  // GET /api/temas
  // Lista todos os temas cadastrados.
  if (req.method === "GET" && rotaExata(pathname, base)) {
    try {
      return responder(res, 200, await listarTemas());
    } catch {
      res.status(503).json({ erro: 'Não foi possível consultar os temas.' });
      return;
    }
  }

  // GET /api/temas/:id
  // Busca um tema específico pelo ID.
  if (req.method === "GET" && id) {
    const { data, error } = await supabase
      .from("temas")
      .select("*")
      .eq("idtemas", id)
      .eq("ativo", true)
      .single();

    if (error) return responder(res, 404, { erro: "Tema não encontrado." });

    return responder(res, 200, data);
  }

  // POST /api/temas
  // Cadastra um novo tema.
  if (req.method === "POST" && rotaExata(pathname, base)) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("temas")
        .insert(body)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 201, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // PUT ou PATCH /api/temas/:id
  // Atualiza um tema já cadastrado.
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("temas")
        .update(body)
        .eq("idtemas", id)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 200, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // DELETE /api/temas/:id
  // Exclui um tema pelo ID.
  if (req.method === "DELETE" && id) {
    const { error } = await supabase
      .from("temas")
      .delete()
      .eq("idtemas", id);

    if (error) return responder(res, 400, { erro: error.message });

    return responder(res, 204, {});
  }

  return false;
}
