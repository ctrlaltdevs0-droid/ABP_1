import { lerJson, responder } from "../utils/http.js";

// Função simples usada para embaralhar uma lista.
function embaralhar(lista) {
  return [...lista].sort(() => Math.random() - 0.5);
}

export async function tentativasRoutes(req, res, pathname, supabase) {

  // Verifica qual rota de tentativa está sendo usada.
  const iniciar =
    pathname === "/api/tentativas" ||
    pathname === "/api/tentativas/";

  const tentativaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/?$/);

  const proximaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/proxima-questao\/?$/);

  const respostaMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/respostas\/?$/);

  const finalizarMatch =
    pathname.match(/^\/api\/tentativas\/([^/]+)\/finalizar\/?$/);

  // POST /api/tentativas
  // Cria uma nova tentativa de prova.
  if (req.method === "POST" && iniciar) {
    try {
      const body = await lerJson(req);

      // Verifica se foi informado o usuário.
      if (!body.usuarios_idusuarios) {
        return responder(res, 400, {
          erro: "usuarios_idusuarios é obrigatório.",
        });
      }

      // Cria a tentativa no banco.
      const { data: tentativa, error: erroTentativa } = await supabase
        .from("tentativas")
        .insert({
          usuarios_idusuarios: body.usuarios_idusuarios,
          iniciada_em: new Date().toISOString(),
          status: "EM_ANDAMENTO",
        })
        .select()
        .single();

      if (erroTentativa) {
        return responder(res, 400, {
          erro: erroTentativa.message,
        });
      }

      // Busca todos os temas.
      const { data: temas, error: erroTemas } = await supabase
        .from("temas")
        .select("idtemas");

      if (erroTemas) {
        return responder(res, 500, {
          erro: erroTemas.message,
        });
      }

      const selecionadas = [];

      // Para cada tema, busca uma questão.
      for (const tema of temas ?? []) {
        const { data: questoes, error: erroQuestoes } = await supabase
          .from("questoes")
          .select("idquestoes")
          .eq("temas_idtemas", tema.idtemas);

        if (erroQuestoes) {
          return responder(res, 500, {
            erro: erroQuestoes.message,
          });
        }

        // Se o tema não tiver questões, passa para o próximo.
        if (!questoes?.length) continue;

        // Escolhe uma questão aleatória.
        const questao = embaralhar(questoes)[0];

        selecionadas.push({
          tentativas_idtentativas: tentativa.idtentativas,
          questoes_idquestoes: questao.idquestoes,
          respondida: false,
        });
      }

      // Salva no banco as questões escolhidas para essa prova.
      if (selecionadas.length) {
        const { error: erroVinculo } = await supabase
          .from("tentativa_questoes")
          .insert(selecionadas);

        if (erroVinculo) {
          return responder(res, 500, {
            erro: erroVinculo.message,
          });
        }
      }

      // Retorna os dados da tentativa criada.
      return responder(res, 201, {
        tentativa,
        total_questoes: selecionadas.length,
      });
    } catch (erro) {
      return responder(res, 400, {
        erro: erro.message,
      });
    }
  }

  // GET /api/tentativas/:id
  // Busca os dados de uma tentativa.
  if (req.method === "GET" && tentativaMatch) {
    const tentativaId = tentativaMatch[1];

    const { data, error } = await supabase
      .from("tentativas")
      .select("*")
      .eq("idtentativas", tentativaId)
      .single();

    if (error) {
      return responder(res, 404, {
        erro: "Tentativa não encontrada.",
      });
    }

    return responder(res, 200, data);
  }

  // GET /api/tentativas/:id/proxima-questao
  // Busca a próxima questão ainda não respondida.
  if (req.method === "GET" && proximaMatch) {
    const tentativaId = proximaMatch[1];

    const { data: vinculo, error } = await supabase
      .from("tentativa_questoes")
      .select("questoes_idquestoes")
      .eq("tentativas_idtentativas", tentativaId)
      .eq("respondida", false)
      .limit(1)
      .maybeSingle();

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
      .select("*")
      .eq("idquestoes", vinculo.questoes_idquestoes)
      .single();

    if (erroQuestao) {
      return responder(res, 500, {
        erro: erroQuestao.message,
      });
    }

    // Busca as alternativas.
    // O campo "correta" não é enviado para o frontend.
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

      // Busca a alternativa escolhida.
      const { data: alternativa, error: erroAlternativa } = await supabase
        .from("alternativas")
        .select("idalternativas, correta")
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

      // Salva a resposta no banco.
      const { data: resposta, error: erroResposta } = await supabase
        .from("respostas")
        .insert({
          tentativas_idtentativas: tentativaId,
          questoes_idquestoes: body.questoes_idquestoes,
          alternativas_idalternativas: body.alternativas_idalternativas,
          correta,
          respondida_em: new Date().toISOString(),
        })
        .select()
        .single();

      if (erroResposta) {
        return responder(res, 400, {
          erro: erroResposta.message,
        });
      }

      // Marca a questão como respondida.
      const { error: erroAtualizacao } = await supabase
        .from("tentativa_questoes")
        .update({
          respondida: true,
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
        id: resposta.idrespostas ?? null,
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

    // Busca a tentativa.
    const { data: tentativa, error: erroTentativa } = await supabase
      .from("tentativas")
      .select("*")
      .eq("idtentativas", tentativaId)
      .single();

    if (erroTentativa) {
      return responder(res, 404, {
        erro: "Tentativa não encontrada.",
      });
    }

    // Busca todas as respostas da tentativa.
    const { data: respostas, error: erroRespostas } = await supabase
      .from("respostas")
      .select("correta")
      .eq("tentativas_idtentativas", tentativaId);

    if (erroRespostas) {
      return responder(res, 500, {
        erro: erroRespostas.message,
      });
    }

    // Calcula quantidade de respostas e acertos.
    const total = respostas?.length ?? 0;

    const acertos = (respostas ?? []).filter(
      (resposta) => resposta.correta === true
    ).length;

    // Calcula a porcentagem final.
    const percentual = total
      ? Number(((acertos / total) * 100).toFixed(2))
      : 0;

    // O usuário é aprovado com 65% ou mais.
    const aprovado = percentual >= 65;

    // Atualiza a tentativa como finalizada.
    const { data: finalizada, error: erroFinalizar } = await supabase
      .from("tentativas")
      .update({
        finalizada_em: new Date().toISOString(),
        status: "FINALIZADA",
        score: acertos,
        percentual,
        aprovado,
      })
      .eq("idtentativas", tentativaId)
      .select()
      .single();

    if (erroFinalizar) {
      return responder(res, 500, {
        erro: erroFinalizar.message,
      });
    }

    let certificado = null;

    // Se foi aprovado, cria um certificado.
    if (aprovado) {
      const codigoValidacao = crypto.randomUUID();

      const { data, error } = await supabase
        .from("certificados")
        .insert({
          usuarios_idusuarios: tentativa.usuarios_idusuarios,
          idcertificados: Date.now(),
          emitido_em: new Date().toISOString(),
          score: acertos,
          percentual,
          ativo: true,
          revogado_em: null,
          codigo_validacao: codigoValidacao,
        })
        .select()
        .single();

      if (!error) {
        certificado = data;
      }
    }

    // Retorna o resultado final da prova.
    return responder(res, 200, {
      tentativa: finalizada,
      resultado: {
        total,
        acertos,
        percentual,
        aprovado,
      },
      certificado,
    });
  }

  return false;
}
