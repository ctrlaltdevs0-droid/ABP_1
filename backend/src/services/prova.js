
import { randomInt } from "node:crypto";
import { ErroHttp } from "../utils/http.js";

export async function gerarProva(db, usuarioId) {

  // 1. Busca os temas cadastrados
  const { data: temas, error: erroTemas } = await db
    .from("temas")
    .select("idtemas")
    .order("idtemas", { ascending: true });

  if (erroTemas) {
    throw new ErroHttp(500, "Erro ao buscar temas.");
  }

  if (!temas || temas.length !== 12) {
    throw new ErroHttp(
      409,
      "A prova exige exatamente 12 temas cadastrados."
    );
  }

  const idsTemas = temas.map(tema => tema.idtemas);

  // 2. Verifica se o aluno concluiu os 12 temas
  const { data: progresso, error: erroProgresso } = await db
    .from("progresso_estudos")
    .select("temas_idtemas")
    .eq("usuarios_idusuarios", usuarioId)
    .in("temas_idtemas", idsTemas);

  if (erroProgresso) {
    throw new ErroHttp(500, "Erro ao verificar progresso.");
  }

  const temasConcluidos = new Set(
    (progresso || []).map(item => item.temas_idtemas)
  );

  if (idsTemas.some(id => !temasConcluidos.has(id))) {
    throw new ErroHttp(
      403,
      "Conclua os 12 temas antes de iniciar a prova."
    );
  }

  // 3. Seleciona uma questão válida de cada tema
  const selecionadas = [];

  for (const tema of temas) {

    const { data: questoes, error: erroQuestoes } = await db
      .from("questoes")
      .select("idquestoes")
      .eq("temas_idtemas", tema.idtemas)
      .eq("status", true);

    if (erroQuestoes) {
      throw new ErroHttp(500, "Erro ao buscar questões.");
    }

    //4. Mantém apenas questões com 4 alternativas
    const validas = [];

    for (const questao of questoes || []) {

      const { data: alternativas, error } = await db
        .from("alternativas")
        .select("idalternativas, correta")
        .eq("questoes_idquestoes", questao.idquestoes);

      if (error) {
        throw new ErroHttp(500, "Erro ao buscar alternativas.");
      }

      const totalCorretas = (alternativas || [])
        .filter(a => a.correta === true).length;

      if (alternativas?.length === 4 && totalCorretas === 1) {
        validas.push(questao);
      }
    }

    if (validas.length === 0) {
      throw new ErroHttp(
        409,
        `O tema ${tema.idtemas} não possui questões válidas.`
      );
    }

    const sorteada = validas[randomInt(validas.length)];

    
selecionadas.push({
  questoes_idquestoes: sorteada.idquestoes,
  respondido_em: null
});

  }

  //5. Verifica se o aluno já possui uma prova em andamento
  const { data: tentativaAberta, error: erroConsulta } = await db
    .from("tentativas")
    .select("idtentativas")
    .eq("usuarios_idusuarios", usuarioId)
    .eq("status", "EM_ANDAMENTO")
    .limit(1)
    .maybeSingle();

  if (erroConsulta) {
    throw new ErroHttp(
      500,
      "Erro ao verificar tentativas em andamento."
    );
  }

  if (tentativaAberta) {
    throw new ErroHttp(
      409,
      "Você já possui uma prova em andamento."
    );
  }

  // 6. Cria a tentativa no banco
  const { data: tentativa, error: erroTentativa } = await db
    .from("tentativas")
    .insert({
      usuarios_idusuarios: usuarioId,
      iniciado_em: new Date().toISOString(),
      status: "EM_ANDAMENTO"
    })
    .select("idtentativas, status")
    .single();

  if (erroTentativa) {
    throw new ErroHttp(500, "Erro ao criar tentativa.");
  }

  // 7. Salva as 12 questões sorteadas
  const vinculos = selecionadas.map(item => ({
    ...item,
    tentativas_idtentativas: tentativa.idtentativas
  }));

  const { error: erroVinculo } = await db
    .from("tentativas_questoes")
    .insert(vinculos);
    console.log("DIAGNÓSTICO DA GRAVAÇÃO:", {
  quantidade: vinculos.length,
  primeiroVinculo: vinculos[0],
  erro: erroVinculo
});
    if (erroVinculo) {
  console.error("ERRO ORIGINAL DO SUPABASE:", erroVinculo);

  
}

 
if (erroVinculo) {

  console.error("ERRO ORIGINAL DO SUPABASE:", {
    code: erroVinculo.code,
    message: erroVinculo.message,
    details: erroVinculo.details,
    hint: erroVinculo.hint
  });

  //8. Tenta remover a tentativa incompleta
  const { error: erroLimpeza } = await db
    .from("tentativas")
    .delete()
    .eq("idtentativas", tentativa.idtentativas);

  if (erroLimpeza) {
    console.error(
      "Falha ao limpar tentativa:",
      erroLimpeza
    );
  }

  throw new ErroHttp(
    500,
    "Não foi possível salvar as questões da prova."
  );
}

  // 9. Retorna os dados para o frontend
  return {
    tentativa_id: tentativa.idtentativas,
    status: tentativa.status,
    total_questoes: selecionadas.length,
    mensagem: "Prova iniciada com sucesso."
  };
}
//10. Busca as questões válidas de um tema:
async function buscarQuestoesValidasDoTema(db, temaId) {
  const { data: questoes, error } = await db
    .from("questoes")
    .select("idquestoes")
    .eq("temas_idtemas", temaId)
    .eq("status", true);

  if (error) {
    throw new ErroHttp(500, "Erro ao buscar questões.");
  }

  const validas = [];

  for (const questao of questoes || []) {
    const { data: alternativas, error: erroAlt } = await db
      .from("alternativas")
      .select("idalternativas, correta")
      .eq("questoes_idquestoes", questao.idquestoes);

    if (erroAlt) {
      throw new ErroHttp(500, "Erro ao buscar alternativas.");
    }

    const totalCorretas = (alternativas || [])
      .filter(a => a.correta === true).length;

    if (alternativas?.length === 4 && totalCorretas === 1) {
      validas.push(questao);
    }
  }

  return validas;
}

// 11. Recupera a tentativa em andamento e troca a pergunta pendente
export async function retomarProva(db, usuarioId) {

  const { data: tentativa, error: erroTentativa } = await db
    .from("tentativas")
    .select("idtentativas, status")
    .eq("usuarios_idusuarios", usuarioId)
    .eq("status", "EM_ANDAMENTO")
    .order("iniciado_em", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (erroTentativa) {
    throw new ErroHttp(500, "Erro ao consultar a tentativa.");
  }

  if (!tentativa) {
    throw new ErroHttp(404, "Nenhuma prova em andamento.");
  }

  const { data: vinculos, error: erroVinculos } = await db
    .from("tentativas_questoes")
    .select("questoes_idquestoes, respondido_em")
    .eq("tentativas_idtentativas", tentativa.idtentativas);

  if (erroVinculos) {
    throw new ErroHttp(500, "Erro ao consultar as questões.");
  }

  const total = vinculos?.length ?? 0;
  const pendentes = (vinculos || []).filter(v => v.respondido_em === null);

  // Se todas foram respondidas, não há o que trocar.
  if (pendentes.length === 0) {
    return {
      tentativa_id: tentativa.idtentativas,
      status: tentativa.status,
      total_questoes: total,
      respondidas: total,
      pendentes: 0,
      mensagem: "Todas as questões já foram respondidas."
    };
  }

  const atual = pendentes[0];

  // 12.Descobre o tema da pergunta pendente.
  const { data: questaoAtual, error: erroQuestao } = await db
    .from("questoes")
    .select("temas_idtemas")
    .eq("idquestoes", atual.questoes_idquestoes)
    .single();

  if (erroQuestao) {
    throw new ErroHttp(500, "Erro ao consultar o tema da questão.");
  }

  // Sorteia outra pergunta do mesmo tema (pode repetir).
  const validas = await buscarQuestoesValidasDoTema(
    db,
    questaoAtual.temas_idtemas
  );

  if (validas.length === 0) {
    throw new ErroHttp(
      409,
      `O tema ${questaoAtual.temas_idtemas} não possui questões válidas.`
    );
  }

  const nova = validas[randomInt(validas.length)];

  // Troca somente a pergunta pendente.
  if (nova.idquestoes !== atual.questoes_idquestoes) {
    const { data: trocada, error: erroTroca } = await db
      .from("tentativas_questoes")
      .update({ questoes_idquestoes: nova.idquestoes })
      .eq("tentativas_idtentativas", tentativa.idtentativas)
      .eq("questoes_idquestoes", atual.questoes_idquestoes)
      .is("respondido_em", null)
      .select("questoes_idquestoes")
      .maybeSingle();

    if (erroTroca || !trocada) {
      console.error("Erro ao trocar a questão:", erroTroca);
      throw new ErroHttp(500, "Não foi possível retomar a prova.");
    }
  }

  return {
    tentativa_id: tentativa.idtentativas,
    status: tentativa.status,
    total_questoes: total,
    respondidas: total - pendentes.length,
    pendentes: pendentes.length,
    mensagem: "Prova retomada com sucesso."
  };
}