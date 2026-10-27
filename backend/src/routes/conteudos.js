import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";

export async function conteudosRoutes(req, res, pathname, supabase) {
  const base = "/api/conteudos";
  const id = idDaRota(pathname, base);

  // Verifica se a URL é algo como:
  // /api/temas/1/conteudos
  const temaMatch = pathname.match(/^\/api\/temas\/([^/]+)\/conteudos\/?$/);

  // GET /api/temas/:id/conteudos
  // Lista os conteúdos ligados a um tema.
  if (req.method === "GET" && temaMatch) {
    const temaId = temaMatch[1];

    const { data, error } = await supabase
      .from("conteudos")
      .select("idconteudo,temas_idtemas,titulo,descricao,recurso_url")
      .eq("status", true)
      .eq("temas_idtemas", temaId)
      .order("idconteudo", { ascending: true });

    if (error) return responder(res, 500, { erro: error.message });

    return responder(res, 200, data);
  }

  // GET /api/conteudos
  // Lista todos os conteúdos cadastrados.
  if (req.method === "GET" && rotaExata(pathname, base)) {
    const { data, error } = await supabase
      .from("conteudos")
      .select("idconteudo,temas_idtemas,titulo,descricao,recurso_url")
      .eq("status", true)
      .order("idconteudo", { ascending: true });

    if (error) return responder(res, 500, { erro: error.message });

    return responder(res, 200, data);
  }

  // GET /api/conteudos/:id
  // Busca um conteúdo pelo ID.
  if (req.method === "GET" && id) {
    const { data, error } = await supabase
      .from("conteudos")
      .select("idconteudo,temas_idtemas,titulo,descricao,recurso_url")
      .eq("status", true)
      .eq("idconteudo", id)
      .single();

    if (error) {
      return responder(res, 404, { erro: "Conteúdo não encontrado." });
    }

    return responder(res, 200, data);
  }

  // POST /api/conteudos
  // Cadastra um novo conteúdo.
  if (req.method === "POST" && rotaExata(pathname, base)) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("conteudos")
        .insert(body)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 201, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // PUT ou PATCH /api/conteudos/:id
  // Atualiza um conteúdo já existente.
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("conteudos")
        .update(body)
        .eq("idconteudo", id)
        .select()
        .single();

      if (error) return responder(res, 400, { erro: error.message });

      return responder(res, 200, data);
    } catch (erro) {
      return responder(res, 400, { erro: erro.message });
    }
  }

  // DELETE /api/conteudos/:id
  // Exclui um conteúdo pelo ID.
  if (req.method === "DELETE" && id) {
    const { error } = await supabase
      .from("conteudos")
      .delete()
      .eq("idconteudo", id);

    if (error) return responder(res, 400, { erro: error.message });

    return responder(res, 204, {});
  }

  return false;
}
