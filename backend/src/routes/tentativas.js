import { falhaBanco, lerJson, responder, tratarErro } from "../utils/http.js";
import { executarOperacao } from "../services/provas.js";

function inteiroPositivo(valor) {
  return Number.isSafeInteger(valor) && valor > 0;
}

function idDaTentativa(valor) {
  if (!/^[1-9]\d*$/.test(valor)) return null;
  const id = Number(valor);
  return inteiroPositivo(id) ? id : null;
}

async function executarRpc(res, supabase, nome, parametros, status) {
  try {
    const dados = await executarOperacao(supabase, nome, parametros);
    return responder(res, status, dados);
  } catch (erro) {
    return tratarErro(res, erro);
  }
}

export async function tentativasRoutes(req, res, pathname, supabase) {
  const iniciar = /^\/api\/tentativas\/?$/.test(pathname);
  const tentativaMatch = pathname.match(/^\/api\/tentativas\/([^/]+)\/?$/);
  const proximaMatch = pathname.match(
    /^\/api\/tentativas\/([^/]+)\/proxima-questao\/?$/
  );
  const respostaMatch = pathname.match(
    /^\/api\/tentativas\/([^/]+)\/respostas\/?$/
  );
  const finalizarMatch = pathname.match(
    /^\/api\/tentativas\/([^/]+)\/finalizar\/?$/
  );

  const usuarioId = req.usuario?.id;

  // O usuário sempre vem do JWT validado; IDs enviados no corpo são ignorados.
  if (req.method === "POST" && iniciar) {
    if (!inteiroPositivo(usuarioId)) {
      return responder(res, 401, { erro: "Autenticação necessária." });
    }

    return executarRpc(
      res,
      supabase,
      "iniciar_prova",
      { p_usuario: usuarioId },
      201
    );
  }

  // Consulta simples da tentativa; as operações da prova usam somente as RPCs.
  if (req.method === "GET" && tentativaMatch) {
    const tentativaId = idDaTentativa(tentativaMatch[1]);
    if (!tentativaId) {
      return responder(res, 400, { erro: "Tentativa inválida." });
    }

    const { data, error } = await supabase
      .from("tentativas")
      .select("*")
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", usuarioId)
      .maybeSingle();

    if (error) return falhaBanco(res, error);
    if (!data) {
      return responder(res, 404, { erro: "Tentativa não encontrada." });
    }

    return responder(res, 200, data);
  }

  if (req.method === "GET" && proximaMatch) {
    const tentativaId = idDaTentativa(proximaMatch[1]);
    if (!tentativaId) {
      return responder(res, 400, { erro: "Tentativa inválida." });
    }

    return executarRpc(
      res,
      supabase,
      "proxima_questao_segura",
      { p_usuario: usuarioId, p_tentativa: tentativaId },
      200
    );
  }

  if (req.method === "POST" && respostaMatch) {
    try {
      const tentativaId = idDaTentativa(respostaMatch[1]);
      const body = await lerJson(req);

      if (
        !tentativaId ||
        !inteiroPositivo(body.questoes_idquestoes) ||
        !inteiroPositivo(body.alternativas_idalternativas)
      ) {
        return responder(res, 400, {
          erro: "Tentativa, questão e alternativa devem ser IDs válidos.",
        });
      }

      const dados = await executarOperacao(supabase, "responder_prova", {
        p_usuario: usuarioId,
        p_tentativa: tentativaId,
        p_questao: body.questoes_idquestoes,
        p_alternativa: body.alternativas_idalternativas,
      });

      return responder(res, 201, dados);
    } catch (erro) {
      return tratarErro(res, erro);
    }
  }

  if (req.method === "POST" && finalizarMatch) {
    const tentativaId = idDaTentativa(finalizarMatch[1]);
    if (!tentativaId) {
      return responder(res, 400, { erro: "Tentativa inválida." });
    }

    return executarRpc(
      res,
      supabase,
      "finalizar_prova",
      { p_usuario: usuarioId, p_tentativa: tentativaId },
      200
    );
  }

  return false;
}
