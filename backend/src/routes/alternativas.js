import { falhaBanco, tratarErro, lerJson, responder, idDaRota } from "../utils/http.js";

export async function alternativasRoutes(req, res, pathname, supabase) {
  const base = "/api/alternativas";
  const id = idDaRota(pathname, base);

  // Verifica se estamos acessando as alternativas de uma questão.
  const questaoMatch = pathname.match(
    /^\/api\/questoes\/([^/]+)\/alternativas\/?$/
  );

  // GET /api/questoes/:id/alternativas
  // Lista as alternativas da questão informada.
  if (req.method === "GET" && questaoMatch) {
    const questaoId = questaoMatch[1];

    const { data, error } = await supabase
      .from("alternativas")
      .select("*")
      .eq("questoes_idquestoes", questaoId)
      .order("letra", { ascending: true });

    if (error) return falhaBanco(res, error);

    return responder(res, 200, data);
  }

  // POST /api/questoes/:id/alternativas
  // Cadastra uma nova alternativa para a questão.
  if (req.method === "POST" && questaoMatch) {
    try {
      const questaoId = questaoMatch[1];
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("alternativas")
        .insert({
          ...body,
          questoes_idquestoes: questaoId,
        })
        .select()
        .single();

      if (error) return falhaBanco(res, error);

      return responder(res, 201, data);
    } catch (erro) {
      return tratarErro(res, erro);
    }
  }

  // PUT ou PATCH /api/alternativas/:id
  // Atualiza uma alternativa.
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);

      const { data, error } = await supabase
        .from("alternativas")
        .update(body)
        .eq("idalternativas", id)
        .select()
        .single();

      if (error) return falhaBanco(res, error);

      return responder(res, 200, data);
    } catch (erro) {
      return tratarErro(res, erro);
    }
  }

  // DELETE /api/alternativas/:id
  // Exclui uma alternativa.
  if (req.method === "DELETE" && id) {
    const { error } = await supabase
      .from("alternativas")
      .delete()
      .eq("idalternativas", id);

    if (error) return falhaBanco(res, error);

    return responder(res, 204, {});
  }

  return false;
}
