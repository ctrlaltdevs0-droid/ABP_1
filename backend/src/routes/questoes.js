
import {
  lerJson,
  responder,
  idDaRota,
  rotaExata
} from "../utils/http.js";

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

  // DELETE /api/temas/:id/respostas
  // Reinicia o quiz do usuário em um tema específico.
  const reiniciarRespostasMatch = pathname.match(
    /^\/api\/temas\/([1-9]\d*)\/respostas\/?$/
  );

  if (req.method === "DELETE" && reiniciarRespostasMatch) {
    try {
      const temaId = Number(reiniciarRespostasMatch[1]);
      const usuarioId = req.usuario.id;

      if (!Number.isSafeInteger(temaId)) {
        return responder(res, 400, {
          erro: "Tema inválido."
        });
      }

      // Não permite reiniciar um tema já concluído.
      const { data: progresso, error: erroProgresso } =
        await supabase
          .from("progresso_estudos")
          .select("temas_idtemas")
          .eq("usuarios_idusuarios", usuarioId)
          .eq("temas_idtemas", temaId)
          .maybeSingle();

      if (erroProgresso) throw erroProgresso;

      if (progresso) {
        return responder(res, 409, {
          erro: "Este tema já foi concluído e não pode ser reiniciado."
        });
      }

      // Busca as questões que pertencem ao tema.
      const { data: questoes, error: erroQuestoes } = await supabase
        .from("questoes")
        .select("idquestoes")
        .eq("temas_idtemas", temaId);

      if (erroQuestoes) throw erroQuestoes;

      const idsQuestoes = (questoes || []).map(
        questao => questao.idquestoes
      );

      if (idsQuestoes.length === 0) {
        return responder(res, 200, {
          mensagem: "Não há questões para reiniciar neste tema."
        });
      }

      // Consulta as respostas do aluno para essas questões.
      const { data: respostas, error: erroRespostas } =
        await supabase
          .from("respostas_estudos")
          .select(
            "questoes_idquestoes, acertou, respondido_em, idrespostas_estudos"
          )
          .eq("usuarios_idusuarios", usuarioId)
          .in("questoes_idquestoes", idsQuestoes)
          .order("respondido_em", { ascending: true })
          .order("idrespostas_estudos", { ascending: true });

      if (erroRespostas) throw erroRespostas;

      // Conta apenas a primeira resposta de cada questão,
      // seguindo a regra usada pelo progresso do aluno.
      const respostasUnicas = new Map();

      for (const resposta of respostas || []) {
        if (!respostasUnicas.has(resposta.questoes_idquestoes)) {
          respostasUnicas.set(
            resposta.questoes_idquestoes,
            resposta
          );
        }
      }

      const acertos = [...respostasUnicas.values()].filter(
        resposta => resposta.acertou === true
      ).length;

      if (acertos >= 3) {
        return responder(res, 409, {
          erro: "Você já alcançou 3 acertos. Marque o tema como concluído."
        });
      }

      // Apaga somente as respostas deste aluno neste tema.
      const { error: erroExclusao } = await supabase
        .from("respostas_estudos")
        .delete()
        .eq("usuarios_idusuarios", usuarioId)
        .in("questoes_idquestoes", idsQuestoes);

      if (erroExclusao) throw erroExclusao;

      return responder(res, 200, {
        sucesso: true,
        mensagem: "Quiz reiniciado! Você pode responder novamente."
      });
    } catch (err) {
      console.error("Erro ao reiniciar quiz:", err);

      return responder(res, err.status || 500, {
        erro: "Não foi possível reiniciar o quiz."
      });
    }
  }
  // GET /api/temas/:id/questoes
  const temaMatch = pathname.match(
    /^\/api\/temas\/([^/]+)\/questoes\/?$/
  );

  if (req.method === "GET" && temaMatch) {
    try {
      const temaId = Number(temaMatch[1]);
      const dados = await listarQuestoesPorTema(supabase, temaId);
      return responder(res, 200, dados);
    } catch (err) {
      return responder(res, err.status || 500, {
        erro: err.message
      });
    }
  }

  // GET /api/temas/:id/respostas
  // Consulta as respostas salvas do aluno autenticado naquele tema.
  const respostasTemaMatch = pathname.match(
    /^\/api\/temas\/([1-9]\d*)\/respostas\/?$/
  );

  if (req.method === "GET" && respostasTemaMatch) {
    try {
      const temaId = Number(respostasTemaMatch[1]);

      if (!Number.isSafeInteger(temaId)) {
        return responder(res, 400, {
          erro: "Tema inválido."
        });
      }

      const { data: questoes, error: erroQuestoes } = await supabase
        .from("questoes")
        .select("idquestoes")
        .eq("temas_idtemas", temaId);

      if (erroQuestoes) throw erroQuestoes;

      const idsQuestoes = (questoes || []).map(
        questao => questao.idquestoes
      );

      if (idsQuestoes.length === 0) {
        return responder(res, 200, []);
      }

      const { data: respostas, error: erroRespostas } = await supabase
        .from("respostas_estudos")
        .select(
          "idrespostas_estudos, questoes_idquestoes, alternativa_escolhida, acertou, respondido_em"
        )
        .eq("usuarios_idusuarios", req.usuario.id)
        .in("questoes_idquestoes", idsQuestoes)
        .order("respondido_em", { ascending: true })
        .order("idrespostas_estudos", { ascending: true });

      if (erroRespostas) throw erroRespostas;

      // Se houver duplicatas antigas, mantém a resposta mais antiga
      // para cada questão, sem apagar nenhum registro do banco.
      const respostasUnicas = new Map();

      for (const resposta of respostas || []) {
        if (!respostasUnicas.has(resposta.questoes_idquestoes)) {
          respostasUnicas.set(
            resposta.questoes_idquestoes,
            resposta
          );
        }
      }

      return responder(res, 200, [
        ...respostasUnicas.values()
      ]);
    } catch (err) {
      console.error("Erro ao carregar respostas de estudo:", err);

      return responder(res, 500, {
        erro: "Não foi possível carregar as respostas anteriores."
      });
    }
  }

  // POST /api/questoes/:id/responder
  // Corrige e salva uma resposta, caso o aluno ainda não tenha respondido.
  const responderMatch = pathname.match(
    /^\/api\/questoes\/([1-9]\d*)\/responder\/?$/
  );

  if (req.method === "POST" && responderMatch) {
    try {
      const questaoId = Number(responderMatch[1]);
      const body = await lerJson(req);

      const letraEscolhida = String(body.letra || "")
        .trim()
        .toUpperCase();

      if (!Number.isSafeInteger(questaoId)) {
        return responder(res, 400, {
          erro: "Questão inválida."
        });
      }

      if (!letraEscolhida || letraEscolhida.length !== 1) {
        return responder(res, 400, {
          erro: "Selecione uma alternativa válida."
        });
      }

      // Confirma que a questão existe e está disponível.
      const { data: questao, error: erroQuestao } = await supabase
        .from("questoes")
        .select("idquestoes")
        .eq("idquestoes", questaoId)
        .eq("status", true)
        .maybeSingle();

      if (erroQuestao) throw erroQuestao;

      if (!questao) {
        return responder(res, 404, {
          erro: "Questão não encontrada ou indisponível."
        });
      }

      // Consulta as alternativas diretamente no banco.
      const { data: alternativas, error: erroAlternativas } =
        await supabase
          .from("alternativas")
          .select("letra, correta")
          .eq("questoes_idquestoes", questaoId);

      if (erroAlternativas) throw erroAlternativas;

      if (!alternativas || alternativas.length === 0) {
        return responder(res, 404, {
          erro: "Esta questão não possui alternativas cadastradas."
        });
      }

      const alternativaCorreta = alternativas.find(
        alternativa => alternativa.correta === true
      );

      if (!alternativaCorreta) {
        return responder(res, 500, {
          erro: "Não há alternativa correta cadastrada para esta questão."
        });
      }

      // Verifica se o aluno já respondeu a esta questão.
      // Se houver duplicatas antigas, considera a mais antiga.
      const { data: respostaAnterior, error: erroRespostaAnterior } =
        await supabase
          .from("respostas_estudos")
          .select(
            "idrespostas_estudos, alternativa_escolhida, acertou, respondido_em"
          )
          .eq("usuarios_idusuarios", req.usuario.id)
          .eq("questoes_idquestoes", questaoId)
          .order("respondido_em", { ascending: true })
          .order("idrespostas_estudos", { ascending: true })
          .limit(1)
          .maybeSingle();

      if (erroRespostaAnterior) throw erroRespostaAnterior;

      // Se já respondeu, devolve o resultado anterior sem inserir novamente.
      if (respostaAnterior) {
        return responder(res, 200, {
          salva: true,
          jaRespondida: true,
          correta: respostaAnterior.acertou,
          letraEscolhida: respostaAnterior.alternativa_escolhida,
          letraCorreta: alternativaCorreta.letra.trim(),
          mensagem: respostaAnterior.acertou
            ? "Você já respondeu a esta questão e acertou!"
            : "Você já respondeu a esta questão e errou. Não é possível responder novamente."
        });
      }

      // Confirma se a alternativa escolhida pertence à questão.
      const escolhida = alternativas.find(
        alternativa =>
          alternativa.letra.trim().toUpperCase() === letraEscolhida
      );

      if (!escolhida) {
        return responder(res, 400, {
          erro: "A alternativa selecionada não pertence a esta questão."
        });
      }

      const acertou = escolhida.correta === true;

      // O usuário vem do token validado pelo middleware.
      // Não aceitamos o ID do aluno enviado pelo navegador.
      const { error: erroSalvamento } = await supabase
        .from("respostas_estudos")
        .insert({
          usuarios_idusuarios: req.usuario.id,
          questoes_idquestoes: questaoId,
          alternativa_escolhida: letraEscolhida,
          acertou
        });

      if (erroSalvamento) throw erroSalvamento;

      return responder(res, 200, {
        salva: true,
        jaRespondida: false,
        correta: acertou,
        letraEscolhida: letraEscolhida,
        letraCorreta: alternativaCorreta.letra.trim(),
        mensagem: acertou
          ? "Parabéns! Você acertou e sua resposta foi salva!"
          : "Resposta incorreta. Sua resposta foi salva e não pode ser alterada."
      });
    } catch (err) {
      console.error("Erro ao validar resposta de estudo:", err);

      return responder(res, err.status || 500, {
        erro: "Não foi possível validar e salvar a resposta."
      });
    }
  }

  // GET /api/questoes
  if (req.method === "GET" && rotaExata(pathname, base)) {
    try {
      const dados = await listarQuestoes(supabase);
      return responder(res, 200, dados);
    } catch (err) {
      return responder(res, err.status || 500, {
        erro: err.message
      });
    }
  }

  // GET /api/questoes/:id
  if (req.method === "GET" && id) {
    try {
      const dado = await buscarQuestaoPorId(supabase, id);
      return responder(res, 200, dado);
    } catch (err) {
      return responder(res, err.status || 500, {
        erro: err.message
      });
    }
  }

  // POST /api/questoes
  if (req.method === "POST" && rotaExata(pathname, base)) {
    try {
      const body = await lerJson(req);
      const novo = await criarQuestao(supabase, body);
      return responder(res, 201, novo);
    } catch (err) {
      return responder(res, err.status || 400, {
        erro: err.message
      });
    }
  }

  // PUT ou PATCH /api/questoes/:id
  if ((req.method === "PUT" || req.method === "PATCH") && id) {
    try {
      const body = await lerJson(req);
      const atualizado = await atualizarQuestao(supabase, id, body);
      return responder(res, 200, atualizado);
    } catch (err) {
      return responder(res, err.status || 400, {
        erro: err.message
      });
    }
  }

  // DELETE /api/questoes/:id
  if (req.method === "DELETE" && id) {
    try {
      await deletarQuestao(supabase, id);

      return responder(res, 200, {
        mensagem: "Questão excluída com sucesso."
      });
    } catch (err) {
      return responder(res, err.status || 400, {
        erro: err.message
      });
    }
  }

  return false;
}
