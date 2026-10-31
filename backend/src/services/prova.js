
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

    // Mantém apenas questões com 4 alternativas
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
      respondida: false
    });
  }

  // Verifica se o aluno já possui uma prova em andamento
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

  // 4. Cria a tentativa no banco
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

  // 5. Salva as 12 questões sorteadas
  const vinculos = selecionadas.map(item => ({
    ...item,
    tentativas_idtentativas: tentativa.idtentativas
  }));

  const { error: erroVinculo } = await db
    .from("tentativas_questoes")
    .insert(vinculos);

  if (erroVinculo) {
    // Tenta remover a tentativa incompleta
    const { error: erroLimpeza } = await db
      .from("tentativas")
      .delete()
      .eq("idtentativas", tentativa.idtentativas);

    if (erroLimpeza) {
      console.error("Falha ao limpar tentativa:", erroLimpeza);
    }

    throw new ErroHttp(
      500,
      "Não foi possível salvar as questões da prova."
    );
  }
  // 6. Retorna os dados para o frontend
  return {
    tentativa_id: tentativa.idtentativas,
    status: tentativa.status,
    total_questoes: selecionadas.length,
    mensagem: "Prova iniciada com sucesso."
  };
}
