import { ErroHttp } from "../utils/http.js";

const campos = "idconteudo, temas_idtemas, titulo, descricao, status, recurso_url";

export async function listarConteudosPorTema(db, temaId) {
  if (!Number.isInteger(Number(temaId)) || Number(temaId) < 1) {
    throw new ErroHttp(400, "ID do tema inválido.");
  }

  const { data, error } = await db
    .from("conteudos")
    .select(campos) // 👈 Agora retorna recurso_url também
    .eq("status", true)
    .eq("temas_idtemas", temaId)
    .order("idconteudo", { ascending: true });

  if (error) throw new ErroHttp(500, "Erro ao buscar conteúdos do tema.");
  return data;
}

export async function listarConteudos(db) {
  const { data, error } = await db
    .from("conteudos")
    .select(campos)
    .eq("status", true)
    .order("idconteudo", { ascending: true });

  if (error) throw new ErroHttp(500, "Erro ao listar conteúdos.");
  return data;
}

export async function buscarConteudoPorId(db, id) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID do conteúdo inválido.");
  }

  const { data, error } = await db
    .from("conteudos")
    .select(campos)
    .eq("status", true)
    .eq("idconteudo", id)
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao buscar conteúdo.");
  if (!data) throw new ErroHttp(404, "Conteúdo não encontrado.");

  return data;
}

export async function criarConteudo(db, body) {
  const { temas_idtemas, titulo, descricao, recurso_url } = body;

  if (!temas_idtemas || !Number.isInteger(Number(temas_idtemas))) {
    throw new ErroHttp(400, "Informe um ID de tema válido.");
  }
  if (typeof titulo !== "string" || !titulo.trim() || titulo.trim().length > 50) {
    throw new ErroHttp(400, "O título deve ter entre 1 e 50 caracteres.");
  }
  if (typeof descricao !== "string" || !descricao.trim() ) {
    throw new ErroHttp(400, "A descrição deve ter entre 1 e 400 caracteres.");
  }

  const novoConteudo = {
    temas_idtemas: Number(temas_idtemas),
    titulo: titulo.trim(),
    descricao: descricao.trim(),
    recurso_url: recurso_url ? String(recurso_url).trim() : null, // 👈 Trata recurso_url
    status: body.status !== undefined ? Boolean(body.status) : true
  };

  const { data, error } = await db
    .from("conteudos")
    .insert(novoConteudo)
    .select(campos)
    .single();

  if (error) throw new ErroHttp(500, "Erro ao cadastrar conteúdo.");
  return data;
}

export async function atualizarConteudo(db, id, body) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID do conteúdo inválido.");
  }

  const patch = {};

  if ("titulo" in body) {
    if (typeof body.titulo !== "string" || !body.titulo.trim() || body.titulo.trim().length > 50) {
      throw new ErroHttp(400, "O título deve ter entre 1 e 50 caracteres.");
    }
    patch.titulo = body.titulo.trim();
  }

  if ("descricao" in body) {
    if (typeof body.descricao !== "string" || !body.descricao.trim() || body.descricao.trim().length > 400) {
      throw new ErroHttp(400, "A descrição deve ter entre 1 e 400 caracteres.");
    }
    patch.descricao = body.descricao.trim();
  }

  if ("recurso_url" in body) { // 👈 Permite atualizar recurso_url
    patch.recurso_url = body.recurso_url ? String(body.recurso_url).trim() : null;
  }

  if ("status" in body) {
    patch.status = Boolean(body.status);
  }

  if (Object.keys(patch).length === 0) {
    throw new ErroHttp(400, "Informe ao menos um campo para atualizar.");
  }

  const { data, error } = await db
    .from("conteudos")
    .update(patch)
    .eq("idconteudo", id)
    .select(campos)
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao atualizar conteúdo.");
  if (!data) throw new ErroHttp(404, "Conteúdo não encontrado.");

  return data;
}

export async function deletarConteudo(db, id) {
  if (!Number.isInteger(Number(id)) || Number(id) < 1) {
    throw new ErroHttp(400, "ID do conteúdo inválido.");
  }

  const { data, error } = await db
    .from("conteudos")
    .delete()
    .eq("idconteudo", id)
    .select("idconteudo")
    .maybeSingle();

  if (error) throw new ErroHttp(500, "Erro ao excluir conteúdo.");
  if (!data) throw new ErroHttp(404, "Conteúdo não encontrado para exclusão.");
}