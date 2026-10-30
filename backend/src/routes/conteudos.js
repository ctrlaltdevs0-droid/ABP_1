import { tratarErro, falhaBanco, lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";
import {
  listarConteudosPorTema,
  listarConteudos,
  buscarConteudoPorId,
  criarConteudo,
  atualizarConteudo,
  deletarConteudo,
} from "../services/conteudos.js";

export async function conteudosRoutes(req, res, pathname, supabase) {
  // 3. GET /api/temas/:id/conteudos
  // Chamada pelo frontend ao clicar no card do Tema
  const temaConteudosMatch = pathname.match(/^\/api\/temas\/([^/]+)\/conteudos\/?$/);
  if (req.method === "GET" && temaConteudosMatch) {
    try {
      const temaId = Number(temaConteudosMatch[1]);
      const dados = await listarConteudosPorTema(supabase, temaId);
      return responder(res, 200, dados);
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  // 4. GET /api/conteudos
  if (req.method === "GET" && rotaExata(pathname, "/api/conteudos")) {
    try {
      const dados = await listarConteudos(supabase);
      return responder(res, 200, dados);
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  // 5. GET /api/conteudos/:id
  const idConteudo = idDaRota(pathname, "/api/conteudos");
  if (req.method === "GET" && idConteudo) {
    try {
      const dado = await buscarConteudoPorId(supabase, idConteudo);
      return responder(res, 200, dado);
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  // 6. POST /api/conteudos
  if (req.method === "POST" && rotaExata(pathname, "/api/conteudos")) {
    try {
      const body = await lerJson(req);
      const novo = await criarConteudo(supabase, body);
      return responder(res, 201, novo);
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  // 7. PUT /api/conteudos/:id
  if (req.method === "PUT" && idConteudo) {
    try {
      const body = await lerJson(req);
      const atualizado = await atualizarConteudo(supabase, idConteudo, body);
      return responder(res, 200, atualizado);
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  // 8. DELETE /api/conteudos/:id
  if (req.method === "DELETE" && idConteudo) {
    try {
      await deletarConteudo(supabase, idConteudo);
      return responder(res, 200, { mensagem: "Conteúdo excluído com sucesso!" });
    } catch (err) {
      return tratarErro(res, err);
    }
  }

  return false;
}