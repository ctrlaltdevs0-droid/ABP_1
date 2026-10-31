import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";
import listarTemas from "../services/temas.js"; // 👈 Import sem chaves (export default)

export async function temasRoutes(req, res, pathname, supabase) {
  const base = "/api/temas";
  const id = idDaRota(pathname, base);

  // 1. GET /api/temas - Lista todos os temas ativos
  if (req.method === "GET" && rotaExata(pathname, base)) {
    try {
      const dados = await listarTemas(); // 👈 Chama sem argumentos (já usa o supabase interno do service)
      return responder(res, 200, dados);
    } catch (err) {
      return responder(res, 503, { erro: 'Não foi possível consultar os temas.' });
    }
  }

  // 2. GET /api/temas/:id - Busca tema por ID
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

  // 3. POST /api/temas
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

  // 4. PUT ou PATCH /api/temas/:id
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

  // 5. DELETE /api/temas/:id
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