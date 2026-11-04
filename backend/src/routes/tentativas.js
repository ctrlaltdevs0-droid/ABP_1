import { lerJson, responder } from "../utils/http.js";
import { retomarProva } from "../services/prova.js";
import { continuidadeRoutes } from "./continuidade.js";

export async function tentativasRoutes(req, res, pathname, supabase) {
  // A API existente da develop permanece disponível. O novo cliente identifica
  // a sessão por documento; apenas esse fluxo usa as operações de continuidade.
  const usaContinuidade = req.headers?.['x-sessao-prova'] !== undefined || req.body?.sessao !== undefined ||
    /^\/api\/tentativas\/?$/.test(pathname) || /^\/api\/tentativas\/atual\/?$/.test(pathname) ||
    /^\/api\/tentativas\/[1-9]\d*\/(pausar|retomar|interromper|presenca)\/?$/.test(pathname);
  if (usaContinuidade) return continuidadeRoutes(req, res, pathname, supabase);
  const protegida = pathname.match(/^\/api\/tentativas\/([1-9]\d*)(?:\/|$)/);
  if (protegida) {
    const { data, error } = await supabase.from('tentativas').select('sessao_prova')
      .eq('idtentativas', protegida[1]).eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
        if (error) {
      console.error("ERRO SESSAO_PROVA:", error);
      return responder(res, 503, { erro: 'Não foi possível consultar a tentativa.' });
    }
    if (data?.sessao_prova) return responder(res, 409, { erro: 'Retome esta tentativa pela página de certificação.' });
  }
  console.log("ENTROU EM TENTATIVAS:", req.method, pathname);
  // POST /api/tentativas/retomar
  // Recupera a tentativa em andamento e troca a pergunta pendente.
  if (
    req.method === "POST" &&
    /^\/api\/tentativas\/retomar\/?$/.test(pathname)
  ) {
    try {
      const usuarioId = req.usuario?.id;

      if (!usuarioId) {
        return responder(res, 401, { erro: "Usuário não autenticado." });
      }

      const { data: emContinuidade, error: erroSessao } = await supabase.from('tentativas').select('idtentativas')
        .eq('usuarios_idusuarios', usuarioId).in('status', ['EM_ANDAMENTO', 'INTERROMPIDA'])
        .not('sessao_prova', 'is', null).limit(1).maybeSingle();
      if (erroSessao) return responder(res, 503, { erro: 'Não foi possível consultar a tentativa.' });
      if (emContinuidade) return responder(res, 409, { erro: 'Retome esta tentativa pela página de certificação.' });

      const resultado = await retomarProva(supabase, usuarioId);
      return responder(res, 200, resultado);

    } catch (erro) {
      console.error("Erro ao retomar prova:", erro);

      const status = Number(erro.status || erro.statusCode);
      const codigoHttp =
        Number.isInteger(status) && status >= 400 && status <= 599
          ? status
          : 500;

      return responder(res, codigoHttp, {
        erro: codigoHttp === 500
          ? "Não foi possível retomar a prova."
          : erro.message
      });
    }
  }

  // GET /api/tentativas/em-andamento
  if (
    req.method === "GET" &&
    /^\/api\/tentativas\/em-andamento\/?$/.test(pathname)
  ) {
    const usuarioId = req.usuario?.id;

    if (!usuarioId) {
      return responder(res, 401, { erro: "Usuário não autenticado." });
    }
    const { data: tentativa, error } = await supabase
      .from("tentativas")
      .select("idtentativas")
      .eq("usuarios_idusuarios", usuarioId)
      .eq("status", "EM_ANDAMENTO")
      .limit(1)
      .maybeSingle();

    if (error) {
      return responder(res, 500, { erro: "Erro ao verificar tentativa." });
    }

    return responder(res, 200, {
      em_andamento: !!tentativa,
      tentativa_id: tentativa?.idtentativas ?? null
    });
  }
  // Verifica qual rota de tentativa está sendo usada.

  const tentativaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/?$/);

  const proximaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/proxima-questao\/?$/);

  const respostaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/respostas\/?$/);

  const finalizarMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/finalizar\/?$/);


  // GET /api/tentativas/:id
  // Busca os dados de uma tentativa.
  if (req.method === "GET" && tentativaMatch) {
    const tentativaId = tentativaMatch[1];

    const { data, error } = await supabase
      .from("tentativas")
      .select("idtentativas, status, iniciado_em, finalizado_em")
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", req.usuario.id)
      .single();

    if (error) {
      return responder(res, 404, {
        erro: "Tentativa não encontrada.",
      });
    }

    return responder(res, 200, data);
  }

  // GET /api/tentativas/:id/proxima-questao
  if (req.method === "GET" && proximaMatch) {
    console.log("ETAPA 1: Entrou na rota de próxima questão");
    const tentativaId = proximaMatch[1];
    const { data: tentativaDoAluno, error: erroDono } = await supabase
      .from("tentativas")
      .select("idtentativas")
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", req.usuario.id)
      .eq("status", "EM_ANDAMENTO")
      .maybeSingle();

    if (erroDono) {
      return responder(res, 500, { erro: "Erro ao consultar tentativa." });
    }

    if (!tentativaDoAluno) {
      return responder(res, 404, {
        erro: "Tentativa em andamento não encontrada."
      });
    }
    const { data: vinculo, error } = await supabase
      .from("tentativas_questoes")
      .select("questoes_idquestoes")
      .eq("tentativas_idtentativas", tentativaId)
      .filter("respondido_em", "is", "null")
      .limit(1)
      .maybeSingle();
    console.log("ETAPA 2: Resultado da consulta:", {
      vinculo,
      erro: error
    });

    if (error) {
      return responder(res, 500, {
        erro: error.message,
      });
    }

    // Se não houver mais questões, a prova terminou.
    if (!vinculo) {
      return responder(res, 200, {
        concluida: true,
        mensagem: "Não há mais questões pendentes.",
      });
    }

    // Busca os dados da questão.
    const { data: questao, error: erroQuestao } = await supabase
      .from("questoes")
      .select("idquestoes, temas_idtemas, enunciado, imagem_url")
      .eq("idquestoes", vinculo.questoes_idquestoes)
      .single();

    if (erroQuestao) {
      return responder(res, 500, {
        erro: erroQuestao.message,
      });
    }

    // Busca as alternativas.
    const { data: alternativas, error: erroAlternativas } = await supabase
      .from("alternativas")
      .select("idalternativas, letra, texto")
      .eq("questoes_idquestoes", vinculo.questoes_idquestoes)
      .order("letra", { ascending: true });

    if (erroAlternativas) {
      return responder(res, 500, {
        erro: erroAlternativas.message,
      });
    }

    return responder(res, 200, {
      concluida: false,
      questao,
      alternativas,
    });
  }

  // POST /api/tentativas/:id/respostas
  // Salva a resposta escolhida pelo usuário.
  if (req.method === "POST" && respostaMatch) {
    try {
      const tentativaId = respostaMatch[1];
      const body = await lerJson(req);

      // Verifica se os dados necessários foram enviados.
      if (!body.questoes_idquestoes || !body.alternativas_idalternativas) {
        return responder(res, 400, {
          erro: "Questão e alternativa são obrigatórias.",
        });
      }

      const { data: tentativa, error: erroTentativa } = await supabase.from('tentativas')
        .select('status').eq('idtentativas', tentativaId)
        .eq('usuarios_idusuarios', req.usuario.id).single();
      if (erroTentativa || tentativa.status !== 'EM_ANDAMENTO') {
        return responder(res, 409, { erro: 'Tentativa indisponível para respostas.' });
      }
      const { data: vinculo, error: erroVinculo } = await supabase.from('tentativas_questoes')
        .select('questoes_idquestoes').eq('tentativas_idtentativas', tentativaId)
        .eq('questoes_idquestoes', body.questoes_idquestoes).maybeSingle();
      if (erroVinculo) return responder(res, 500, {});
      if (!vinculo) return responder(res, 400, { erro: 'Questão não pertence à tentativa.' });

      // Busca a alternativa escolhida.
      const { data: alternativa, error: erroAlternativa } = await supabase
        .from("alternativas")
        .select("idalternativas, letra, correta")
        .eq("idalternativas", body.alternativas_idalternativas)
        .eq("questoes_idquestoes", body.questoes_idquestoes)
        .single();

      if (erroAlternativa) {
        return responder(res, 400, {
          erro: "Alternativa inválida.",
        });
      }

      // Descobre se a resposta está correta.
      const correta =
        alternativa.correta === true ||
        alternativa.correta === "S" ||
        alternativa.correta === "1";


      // Salva a resposta na própria questão da tentativa.
      const { data: resposta, error: erroResposta } = await supabase
        .from("tentativas_questoes")
        .update({
          resposta_escolhida: alternativa.letra.trim().toUpperCase(),
          acertou: correta,
          respondido_em: new Date().toISOString()
        })
        .eq("tentativas_idtentativas", tentativaId)
        .eq("questoes_idquestoes", body.questoes_idquestoes)
        .is("respondido_em", null)
        .select("questoes_idquestoes")
        .maybeSingle();

      if (erroResposta) {
        console.error("Erro ao salvar resposta:", erroResposta);

        return responder(res, 500, {
          erro: "Não foi possível salvar a resposta."
        });
      }

      if (!resposta) {
        return responder(res, 409, {
          erro: "Questão já respondida ou indisponível."
        });
      }

      // Marca a questão como respondida e guarda a letra escolhida e a correta.
      const { error: erroAtualizacao } = await supabase
        .from("tentativas_questoes")
        .update({
          respondido_em: new Date().toISOString(),
        })
        .eq("tentativas_idtentativas", tentativaId)
        .eq("questoes_idquestoes", body.questoes_idquestoes);

      if (erroAtualizacao) {
        return responder(res, 500, {
          erro: erroAtualizacao.message,
        });
      }

      return responder(res, 201, {
        resposta_registrada: true,
        questao_id: resposta.questoes_idquestoes
      });
    } catch (erro) {
      return responder(res, 400, {
        erro: erro.message,
      });
    }
  }

  // POST /api/tentativas/:id/finalizar
  // Finaliza a prova e calcula a nota do usuário.
  if (req.method === "POST" && finalizarMatch) {
    const tentativaId = finalizarMatch[1];

    // Busca a tentativa do usuário autenticado.
    const { data: tentativa, error: erroTentativa } = await supabase
      .from("tentativas")
      .select("*")
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", req.usuario.id)
      .single();

    if (erroTentativa) {
      return responder(res, 404, {
        erro: "Tentativa não encontrada.",
      });
    }

    if (tentativa.status !== "EM_ANDAMENTO") {
      return responder(res, 409, {
        erro: "Tentativa indisponível para finalização.",
      });
    }

    // Busca as questões e as respostas da tentativa.
    const { data: vinculos, error: erroVinculos } = await supabase
      .from("tentativas_questoes")
      .select("questoes_idquestoes, resposta_escolhida, acertou, respondido_em")
      .eq("tentativas_idtentativas", tentativaId);

    if (erroVinculos) {
      console.error("Erro ao consultar respostas:", erroVinculos);
      return responder(res, 500, {
        erro: "Não foi possível consultar as respostas.",
      });
    }

    const total = vinculos?.length ?? 0;

    if (total !== 12) {
      return responder(res, 409, {
        erro: "A tentativa não possui 12 questões.",
      });
    }

    const todasRespondidas = vinculos.every(
      (item) =>
        item.respondido_em !== null &&
        item.resposta_escolhida != null &&
        item.acertou !== null
    );

    if (!todasRespondidas) {
      return responder(res, 409, {
        erro: "Responda todas as questões antes de finalizar.",
      });
    }

    const acertos = vinculos.filter((item) => item.acertou === true).length;
    const percentual = Number(((acertos / total) * 100).toFixed(2));
    const aprovado = percentual >= 65;

    // Marca a tentativa como finalizada.
    const { data: finalizada, error: erroFinalizar } = await supabase
      .from("tentativas")
      .update({
        finalizado_em: new Date().toISOString(),
        status: "FINALIZADA",
        acertos,
        percentual,
        aprovado,
      })
      .eq("idtentativas", tentativaId)
      .eq("usuarios_idusuarios", req.usuario.id)
      .select()
      .single();

    if (erroFinalizar) {
      return responder(res, 500, { erro: erroFinalizar.message });
    }

    // Só grava e retorna a nota.
    return responder(res, 200, {
      mensagem: "Prova concluída com sucesso.",
      tentativa_id: finalizada.idtentativas,
      resultado: { total, acertos, percentual, aprovado },
      certificado_disponivel: aprovado,
    });
  }
}
