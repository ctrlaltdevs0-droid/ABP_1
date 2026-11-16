import { ErroHttp } from "../utils/http.js";
import { executarOperacao } from "./provas.js";

// Compatibilidade com a interface antiga. Toda escrita permanece na RPC
// transacional; o service_role não monta a prova diretamente pelas tabelas.
export async function gerarProva(db, usuarioId) {
  const { data: temas, error: erroTemas } = await db
    .from("temas")
    .select("idtemas")
    .eq("ativo", true)
    .order("ordem", { ascending: true });
  if (erroTemas) throw erroTemas;
  if (!temas || temas.length !== 12) {
    throw new ErroHttp(409, "A prova exige exatamente 12 temas ativos.");
  }

  const idsTemas = temas.map(tema => tema.idtemas);
  const { data: progresso, error: erroProgresso } = await db
    .from("progresso_estudos")
    .select("temas_idtemas")
    .eq("usuarios_idusuarios", usuarioId)
    .in("temas_idtemas", idsTemas);
  if (erroProgresso) throw erroProgresso;

  const concluidos = new Set((progresso || []).map(item => item.temas_idtemas));
  if (idsTemas.some(id => !concluidos.has(id))) {
    throw new ErroHttp(403, "Conclua os 12 temas antes de iniciar a prova.");
  }

  const { data: aberta, error: erroAberta } = await db
    .from("tentativas")
    .select("idtentativas")
    .eq("usuarios_idusuarios", usuarioId)
    .in("status", ["EM_ANDAMENTO", "INTERROMPIDA"])
    .limit(1)
    .maybeSingle();
  if (erroAberta) throw erroAberta;
  if (aberta) throw new ErroHttp(409, "Você já possui uma prova em andamento.");

  const resultado = await executarOperacao(db, "iniciar_prova", {
    p_usuario: usuarioId,
  });
  return {
    tentativa_id: resultado.tentativa.idtentativas,
    status: resultado.tentativa.status,
    total_questoes: resultado.total_questoes,
    mensagem: "Prova iniciada com sucesso.",
  };
}
