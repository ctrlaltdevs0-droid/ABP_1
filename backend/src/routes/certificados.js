import { responder } from "../utils/http.js";

export async function certificadosRoutes(req, res, pathname, supabase) {

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

    if (error) return responder(res, 500, { erro: error.message });

    return responder(res, 200, data);
  }

  // GET /api/certificados/validar/:codigo
  // Verifica se o certificado existe e ainda está ativo.
  if (req.method === "GET" && validarMatch) {
    const codigo = validarMatch[1];

    const { data, error } = await supabase
      .from("certificados")
      .select("*")
      .eq("codigo_validacao", codigo)
      .eq("ativo", true)
      .is("revogado_em", null)
      .maybeSingle();

    if (error) return responder(res, 500, { erro: error.message });

    // Se não encontrou certificado válido.
    if (!data) {
      return responder(res, 404, {
        valido: false,
        mensagem: "Certificado não encontrado ou revogado.",
      });
    }

    // Se encontrou, informa que o certificado é válido.
    return responder(res, 200, {
      valido: true,
      certificado: data,
    });
  }

  // GET /api/certificados/:id
  // Busca um certificado específico.
  if (req.method === "GET" && certificadoMatch) {
    const id = certificadoMatch[1];

    const { data, error } = await supabase
      .from("certificados")
      .select("*")
      .eq("idcertificados", id)
      .single();

    if (error) {
      return responder(res, 404, {
        erro: "Certificado não encontrado.",
      });
    }

    return responder(res, 200, data);
  }

  return false;
}
