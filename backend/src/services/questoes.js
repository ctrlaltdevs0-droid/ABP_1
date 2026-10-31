import { ErroHttp } from "../utils/http.js";


export async function listarQuestoesPorTema(db, temaId) {
  if (!Number.isInteger(Number(temaId)) || Number(temaId) < 1) {
    throw new ErroHttp(400, "ID do tema inválido.");
  }

  // 1. Busca as questões do tema
  const { data: questoes, error: erroQuestoes } = await db
    .from("questoes")
    .select("idquestoes, temas_idtemas, enunciado, imagem_url, status")
    .eq("temas_idtemas", Number(temaId))
    .eq("status", true)
    .order("idquestoes", { ascending: true });

  if (erroQuestoes) {
    console.error("Erro ao buscar questões:", erroQuestoes);
    throw new ErroHttp(500, "Erro ao buscar questões do tema.");
  }

  // Se não houver questões, retorna uma lista vazia
  if (!questoes || questoes.length === 0) {
    return [];
  }

  // 2. Pega os IDs das questões encontradas
  const idsQuestoes = questoes.map(q => q.idquestoes);

  // 3. Busca as alternativas dessas questões
  const { data: alternativas, error: erroAlternativas } = await db
    .from("alternativas")
    .select("idalternativas, questoes_idquestoes, letra, texto")
    .in("questoes_idquestoes", idsQuestoes)
    .order("letra", { ascending: true });

  if (erroAlternativas) {
    console.error("Erro ao buscar alternativas:", erroAlternativas);
    throw new ErroHttp(500, "Erro ao buscar alternativas das questões.");
  }

  // 4. Junta cada questão com suas alternativas
  return questoes.map(questao => ({
    ...questao,
    alternativas: (alternativas || [])
      .filter(a => a.questoes_idquestoes === questao.idquestoes)
      .map(a => ({
        letra: a.letra.trim(),
        texto: a.texto
      }))
  }));
}


// Lista todas as questões cadastradas no banco
export async function listarQuestoes(db) {
  const { data, error } = await db
    .from("questoes")
    .select("*")
    .order("idquestoes", { ascending: true });

  if (error) throw new ErroHttp(500, "Erro ao listar questões.");
  return data;
}

// Busca uma questão específica pelo ID
export async function buscarQuestaoPorId(db, id) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID da questão inválido.");
  }

  const { data, error } = await db
    .from("questoes")
    .select("*")
    .eq("idquestoes", id)
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao buscar questão.");
  if (!data) throw new ErroHttp(404, "Questão não encontrada.");

  return data;
}

// Cadastra uma nova questão
export async function criarQuestao(db, body) {
  const { temas_idtemas, enunciado, opcao_a, opcao_b, opcao_c, resposta_correta } = body;

  if (!temas_idtemas || !Number.isInteger(Number(temas_idtemas))) {
    throw new ErroHttp(400, "Informe um ID de tema válido.");
  }
  if (typeof enunciado !== "string" || !enunciado.trim()) {
    throw new ErroHttp(400, "O enunciado da questão é obrigatório.");
  }

  const novaQuestao = {
    temas_idtemas: Number(temas_idtemas),
    enunciado: enunciado.trim(),
    opcao_a: opcao_a ? String(opcao_a).trim() : null,
    opcao_b: opcao_b ? String(opcao_b).trim() : null,
    opcao_c: opcao_c ? String(opcao_c).trim() : null,
    resposta_correta: resposta_correta ? String(resposta_correta).trim() : null
  };

  const { data, error } = await db
    .from("questoes")
    .insert(novaQuestao)
    .select()
    .single();

  if (error) throw new ErroHttp(500, "Erro ao cadastrar questão.");
  return data;
}

// Atualiza uma questão existente
export async function atualizarQuestao(db, id, body) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID da questão inválido.");
  }

  const patch = {};

  if ("enunciado" in body) patch.enunciado = body.enunciado?.trim();
  if ("opcao_a" in body) patch.opcao_a = body.opcao_a?.trim();
  if ("opcao_b" in body) patch.opcao_b = body.opcao_b?.trim();
  if ("opcao_c" in body) patch.opcao_c = body.opcao_c?.trim();
  if ("resposta_correta" in body) patch.resposta_correta = body.resposta_correta?.trim();
  if ("temas_idtemas" in body) patch.temas_idtemas = Number(body.temas_idtemas);

  if (Object.keys(patch).length === 0) {
    throw new ErroHttp(400, "Informe ao menos um campo para atualizar.");
  }

  const { data, error } = await db
    .from("questoes")
    .update(patch)
    .eq("idquestoes", id)
    .select()
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao atualizar questão.");
  if (!data) throw new ErroHttp(404, "Questão não encontrada.");

  return data;
}

// Exclui uma questão
export async function deletarQuestao(db, id) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID da questão inválido.");
  }

  const { data, error } = await db
    .from("questoes")
    .delete()
    .eq("idquestoes", id)
    .select("idquestoes")
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao excluir questão.");
  if (!data) throw new ErroHttp(404, "Questão não encontrada para exclusão.");
}