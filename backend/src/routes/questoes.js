import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";
import {
  listarQuestoesPorTema,
  listarQuestoes,
  buscarQuestaoPorId,
  criarQuestao,
  atualizarQuestao,
  deletarQuestao,
} from "../services/questoes.js";

export async function questoesRoutes(req, res, pathname, supabase) {
  const base = "/api/questoes";
  const id = idDaRota(pathname, base);

  // GET /api/temas/:id/questoes
  // Busca as questões relacionadas a um tema
  const temaMatch = pathname.match(/^\/api\/temas\/([^/]+)\/questoes\/?$/);
  if (req.method === "GET" && temaMatch) {
    try {
      const temaId = Number(temaMatch[1]);
      const dados = await listarQuestoesPorTema(supabase, temaId);
      return responder(res, 200, dados);
    } catch (err) {
      return responder(res, err.status || 500, { erro: err.message });
    }
  }

  // GET /api/questoes
  // Lista todas as questões do banco
  if (req.method === "GET" && rotaExata(pathname, base)) {
    try {
      const dados = await listarQuestoes(supabase);
      return responder(res, 200, dados);
    } catch (err) {
      return responder(res, err.status || 500, { erro: err.message });
    }
  }

  // GET /api/questoes/:id
  // Busca apenas uma questão pelo ID
  if (req.method === "GET" && id) {
    try {
      const dado = await buscarQuestaoPorId(supabase, id);
      return responder(res, 200, dado);
    } catch (err) {
      return responder(res, err.status || 500, { erro: err.message });
    }
  }

  // POST /api/questoes
  // Cadastra uma nova questão
  if (req.method === "POST" && rotaExata(pathname, base)) {
    try {
      const body = await lerJson(req);
      const novo = await criarQuestao(supabase, body);
      return responder(res, 201, novo);
    } catch (err) {
      return responder(res, err.status || 400, { erro: err.message });
    }
  }

  // PUT ou PATCH /api/questoes/:id
  // Atualiza uma questão existente
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);
      const atualizado = await atualizarQuestao(supabase, id, body);
      return responder(res, 200, atualizado);
    } catch (err) {
      return responder(res, err.status || 400, { erro: err.message });
    }
  }

  // DELETE /api/questoes/:id
  // Exclui uma questão
  if (req.method === "DELETE" && id) {
    try {
      await deletarQuestao(supabase, id);
      return responder(res, 200, { mensagem: "Questão excluída com sucesso!" });
    } catch (err) {
      return responder(res, err.status || 400, { erro: err.message });
    }
  }

  return false;
}