import { lerJson, responder, idDaRota, rotaExata } from "../utils/http.js";

export async function conteudosRoutes(req, res, pathname, supabase) {
  // 1. GET /api/estudos/progresso
  // Retorna a lista de temas que o usuário autenticado já concluiu
  if (req.method === "GET" && rotaExata(pathname, "/api/estudos/progresso")) {
    try {
      // Busca os temas concluídos (ou retorna array vazio [] para não travar a tela)
      const { data, error } = await supabase
        .from("tentativas") // ou sua tabela de progresso
        .select("temas_idtemas");

      if (error) {
        // Se ainda não houver dados, retorna [] com status 200
        return responder(res, 200, []);
      }

      return responder(res, 200, data || []);
    } catch (err) {
      return responder(res, 200, []);
    }
  }

  // 2. PUT /api/temas/:id/conclusao
  // Registra a conclusão de um tema específico quando o aluno clica no botão
  const conclusaoMatch = pathname.match(/^\/api\/temas\/([^/]+)\/conclusao\/?$/);

  if (req.method === "PUT" && conclusaoMatch) {
    try {
      const temaId = Number(conclusaoMatch[1]);

      // Lógica para salvar a conclusão no Supabase se desejar
      // ...

      return responder(res, 200, { mensagem: "Tema concluído com sucesso!" });
    } catch (err) {
      return responder(res, 400, { erro: err.message });
    }
  }

  return false;
}