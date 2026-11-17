import { falhaBanco, tratarErro, responder } from "../utils/http.js";

export async function certificadosRoutes(req, res, pathname, supabase) {
  const emitir = pathname.match(/^\/api\/certificados\/tentativas\/([1-9]\d*)\/?$/);
  if (req.method === 'POST' && emitir) {
    const id = Number(emitir[1]);
    if (!Number.isSafeInteger(id)) return responder(res, 400, { erro: 'Tentativa inválida.' });
    if (!req.usuario?.id) return responder(res, 401, { erro: 'Autenticação necessária.' });
    const { data: tentativa, error: erroTentativa } = await supabase.from('tentativas')
      .select('idtentativas,usuarios_idusuarios,status,aprovado,acertos,percentual')
      .eq('idtentativas', id).eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
    if (erroTentativa) return falhaBanco(res, erroTentativa);
    if (!tentativa) return responder(res, 404, { erro: 'Tentativa não encontrada.' });
    if (tentativa.status !== 'FINALIZADA' || tentativa.aprovado !== true || Number(tentativa.percentual) < 65) {
      return responder(res, 409, { erro: 'O certificado exige uma tentativa finalizada e aprovada.' });
    }
    // A chave única da tentativa impede duplicação; conflitos nunca reativam revogados.
    const { error: erroEmissao } = await supabase.from('certificados').upsert({
      usuarios_idusuarios: req.usuario.id, tentativas_idtentativas: id,
      score: tentativa.acertos, percentual: tentativa.percentual, ativo: true,
    }, { onConflict: 'tentativas_idtentativas', ignoreDuplicates: true });
    if (erroEmissao) return falhaBanco(res, erroEmissao);
    const { data: certificado, error: erroConsulta } = await supabase.from('certificados').select('*')
      .eq('tentativas_idtentativas', id).eq('usuarios_idusuarios', req.usuario.id).maybeSingle();
    if (erroConsulta) return falhaBanco(res, erroConsulta);
    if (!certificado || !certificado.ativo || certificado.revogado_em) {
      return responder(res, 409, { erro: 'Certificado indisponível ou revogado.' });
    }
    return responder(res, 200, certificado, { 'Cache-Control': 'no-store' });
  }

  // Identifica a rota dos certificados de um usuário.
  const usuarioMatch = pathname.match(
    /^\/api\/usuarios\/([^/]+)\/certificados\/?$/
  );

  // Identifica a rota de um certificado específico.
  const certificadoMatch = pathname.match(
    /^\/api\/certificados\/([^/]+)\/?$/
  );

  // Identifica a rota usada para validar um certificado.
  const validarMatch = pathname.match(
    /^\/api\/certificados\/validar\/([^/]+)\/?$/
  );

  // GET /api/usuarios/:id/certificados
  // Lista os certificados de um usuário.
  if (req.method === "GET" && usuarioMatch) {
    const usuarioId = usuarioMatch[1];

    const { data, error } = await supabase
      .from("certificados")
      .select("*")
      .eq("usuarios_idusuarios", usuarioId)
      .order("emitido_em", { ascending: false });

    if (error) return falhaBanco(res, error);

    return responder(res, 200, data);
  }

  // GET /api/certificados/validar/:codigo
  // Verifica se o certificado existe e ainda está ativo.
  if (req.method === "GET" && validarMatch) {
    const codigo = validarMatch[1];

    const { data, error } = await supabase
      .from("certificados")
      .select("codigo_validacao,emitido_em,score,percentual,usuarios(nome)")
      .eq("codigo_validacao", codigo)
      .eq("ativo", true)
      .is("revogado_em", null)
      .maybeSingle();

    if (error) return falhaBanco(res, error);

    // Se não encontrou certificado válido.
    if (!data) {
      return responder(res, 404, {
        valido: false,
        erro: "Certificado não encontrado ou revogado.",
      });
    }

    // Se encontrou, informa que o certificado é válido.
    return responder(res, 200, {
      valido: true,
      certificado: data,
    }, { 'Cache-Control': 'no-store' });
  }

  // GET /api/certificados/:id
  // Busca um certificado específico.
  if (req.method === "GET" && certificadoMatch) {
    const id = certificadoMatch[1];

    const { data, error } = await supabase
      .from("certificados")
      .select("*,usuarios(nome)")
      .eq("idcertificados", id)
      .eq("ativo", true)
      .is("revogado_em", null)
      .maybeSingle();

    if (error) return falhaBanco(res, error);
    if (!data) {
      return responder(res, 404, {
        erro: "Certificado não encontrado.",
      });
    }

    return responder(res, 200, data, { 'Cache-Control': 'no-store' });
  }

  return false;
}
