import supabase from "../config/supabase.js";

export default async function listarTemas() {
  const { data, error } = await supabase
    .from("temas")
    .select("idtemas,nome,descricao,ordem")
    .eq("ativo", true)
    .order("ordem");
  if (error) throw error;
  return data;
}