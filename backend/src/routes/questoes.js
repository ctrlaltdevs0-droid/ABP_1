import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";

export async function questoesRoutes(req, res, pathname, supabase) {
  const base = "/api/questoes";
  const id = idDaRota(pathname, base);

  // Verifica se a rota possui um tema.
  // Exemplo: /api/temas/2/questoes
  const temaMatch = pathname.match(/^\/api\/temas\/([^/]+)\/questoes\/?$/);

  // GET /api/temas/:id/questoes
  // Busca as questões relacionadas a um tema.
  if (req.method === "GET" && temaMatch) {
    const temaId = temaMatch[1];

    const { data, error } = await supabase
      .from("questoes")
      .select("*")
      .eq("temas_idtemas", temaId);

    if (error) return responder(res, 500, { erro: error.message });

    return responder(res, 200, data);
  }

  // GET /api/questoes
  // Lista todas as questões do banco.
  if (req.method === "GET" && rotaExata(pathname, base)) {
    const { data, error } = await supabase
      .from("questoes")
      .select("*");

    if (error) return responder(res, 500, { erro: error.message });

    return responder(res, 200, data);
  }

  // GET /api/questoes/:id
  // Busca apenas uma questão pelo ID.
  if (req.method === "GET" && id) {
    const { data, error } = await supabase
      .from("questoes")
      .select("*")
      .eq("idquestoes", id)
      .single();

    if (error) {
      return responder(res, 404, { erro: "Questão não encontrada." });
    }

    return responder(res, 200, data);
  }

  // POST /api/questoes
  // Cadastra uma nova questão.
  if (req.method === "POST" && rotaExata(pathname, base)) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("questoes")
        .insert(body)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 201, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // PUT ou PATCH /api/questoes/:id
  // Atualiza uma questão existente.
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("questoes")
        .update(body)
        .eq("idquestoes", id)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 200, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // DELETE /api/questoes/:id
  // Exclui uma questão.
  if (req.method === "DELETE" && id) {
    const { error } = await supabase
      .from("questoes")
      .delete()
      .eq("idquestoes", id);

    if (error) return responder(res, 400, { erro: error.message });

    return responder(res, 204, {});
  }

  return false;
}
