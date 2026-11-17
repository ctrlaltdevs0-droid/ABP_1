import { falhaBanco, lerJson, responder, tratarErro } from "../utils/http.js";
import { executarOperacao } from "../services/provas.js";
import { continuidadeRoutes } from "./continuidade.js";

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

async function tentativaComSessao(supabase, usuarioId, tentativaId) {
  const { data, error } = await supabase
    .from("tentativas")
    .select("sessao_prova")
    .eq("idtentativas", tentativaId)
    .eq("usuarios_idusuarios", usuarioId)
    .maybeSingle();
  if (error) throw error;
  return data?.sessao_prova != null;
}

export async function tentativasRoutes(req, res, pathname, supabase) {
  const iniciar = /^\/api\/tentativas\/?$/.test(pathname);
  const atual = /^\/api\/tentativas\/atual\/?$/.test(pathname);
  const acaoContinuidade = /^\/api\/tentativas\/[1-9]\d*\/(pausar|retomar|interromper|presenca)\/?$/.test(pathname);
  const usaContinuidade = iniciar || atual || acaoContinuidade ||
    req.headers?.["x-sessao-prova"] !== undefined || req.body?.sessao !== undefined;

  if (usaContinuidade) {
    return continuidadeRoutes(req, res, pathname, supabase);
  }

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

  if (req.method === "GET" && /^\/api\/tentativas\/em-andamento\/?$/.test(pathname)) {
    const { data, error } = await supabase
      .from("tentativas")
      .select("idtentativas")
      .eq("usuarios_idusuarios", usuarioId)
      .in("status", ["EM_ANDAMENTO", "INTERROMPIDA"])
      .limit(1)
      .maybeSingle();
    if (error) return falhaBanco(res, error);
    return responder(res, 200, {
      em_andamento: Boolean(data),
      tentativa_id: data?.idtentativas ?? null,
    });
  }

  // O endpoint legado não troca questões nem contorna a sessão transacional.
  if (req.method === "POST" && /^\/api\/tentativas\/retomar\/?$/.test(pathname)) {
    const { data, error } = await supabase
      .from("tentativas")
      .select("idtentativas,sessao_prova")
      .eq("usuarios_idusuarios", usuarioId)
      .in("status", ["EM_ANDAMENTO", "INTERROMPIDA"])
      .limit(1)
      .maybeSingle();
    if (error) return falhaBanco(res, error);
    if (!data) return responder(res, 404, { erro: "Nenhuma prova em andamento." });
    return responder(res, 409, {
      erro: "Retome esta tentativa pela página de certificação.",
    });
  }

  if (req.method === "GET" && tentativaMatch) {
    const tentativaId = idDaTentativa(tentativaMatch[1]);
    if (!tentativaId) return responder(res, 400, { erro: "Tentativa inválida." });
    const { data, error } = await supabase
      .from("tentativas")
      .select("idtentativas,status,iniciado_em,finalizado_em")
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", usuarioId)
      .single();
    if (error || !data) return responder(res, 404, { erro: "Tentativa não encontrada." });
    return responder(res, 200, data);
  }

  if (req.method === "GET" && proximaMatch) {
    const tentativaId = idDaTentativa(proximaMatch[1]);
    if (!tentativaId) return responder(res, 400, { erro: "Tentativa inválida." });
    try {
      if (await tentativaComSessao(supabase, usuarioId, tentativaId)) {
        return responder(res, 409, { erro: "Retome esta tentativa pela página de certificação." });
      }
    } catch (erro) {
      return falhaBanco(res, erro);
    }
    return executarRpc(res, supabase, "proxima_questao_segura", {
      p_usuario: usuarioId,p_tentativa: tentativaId,
    }, 200);
  }

  if (req.method === "POST" && respostaMatch) {
    try {
      const tentativaId = idDaTentativa(respostaMatch[1]);
      const body = await lerJson(req);
      if (tentativaId && await tentativaComSessao(supabase, usuarioId, tentativaId)) {
        return responder(res, 409, { erro: "Retome esta tentativa pela página de certificação." });
      }
      if (!tentativaId || !inteiroPositivo(body.questoes_idquestoes) ||
          !inteiroPositivo(body.alternativas_idalternativas)) {
        return responder(res, 400, {
          erro: "Tentativa, questão e alternativa devem ser IDs válidos.",
        });
      }
      const dados = await executarOperacao(supabase, "responder_prova", {
        p_usuario: usuarioId,p_tentativa: tentativaId,
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
    if (!tentativaId) return responder(res, 400, { erro: "Tentativa inválida." });
    try {
      if (await tentativaComSessao(supabase, usuarioId, tentativaId)) {
        return responder(res, 409, { erro: "Retome esta tentativa pela página de certificação." });
      }
    } catch (erro) {
      return falhaBanco(res, erro);
    }
    return executarRpc(res, supabase, "finalizar_prova", {
      p_usuario: usuarioId,p_tentativa: tentativaId,
    }, 200);
  }

  return false;
}
