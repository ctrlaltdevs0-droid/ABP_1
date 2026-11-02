import { responder } from '../utils/http.js';

export async function historicoRoutes(req, res, pathname, supabase) {
  const lista = /^\/api\/historico\/?$/.test(pathname);
  const detalhe = pathname.match(/^\/api\/historico\/([1-9]\d*)\/?$/);

  if (!lista && !detalhe) return false;

  if (req.method !== 'GET') {
    return responder(res, 405, { erro: 'Método HTTP não permitido.' });
  }

  // O ID vem do usuário autenticado pelo middleware.
  const usuarioId = req.usuario.id;

  // GET /api/historico
  // Lista as tentativas do próprio candidato.
  if (lista) {
    const { data, error } = await supabase
      .from('tentativas')
      .select('idtentativas, iniciado_em, finalizado_em, status, acertos, percentual, aprovado')
      .eq('usuarios_idusuarios', usuarioId)
      .order('iniciado_em', { ascending: false });

    if (error) {
      return responder(res, 503, { erro: 'Não foi possível consultar o histórico.' });
    }

    return responder(res, 200, data || []);
  }

  // GET /api/historico/:id
  // Mostra as questões de uma tentativa do próprio candidato.
  const tentativaId = Number(detalhe[1]);

  const { data: tentativa, error: erroTentativa } = await supabase
    .from('tentativas')
    .select('idtentativas, iniciado_em, finalizado_em, status, acertos, percentual, aprovado')
    .eq('idtentativas', tentativaId)
    .eq('usuarios_idusuarios', usuarioId)
    .maybeSingle();

  if (erroTentativa) {
    return responder(res, 503, { erro: 'Não foi possível consultar o histórico.' });
  }

  if (!tentativa) {
    return responder(res, 404, { erro: 'Tentativa não encontrada.' });
  }

  // A resposta correta só aparece depois que a prova termina.
  if (tentativa.status !== 'FINALIZADA') {
    return responder(res, 409, { erro: 'Conclua a prova para ver o histórico.' });
  }

  const { data: questoes, error: erroQuestoes } = await supabase
    .from('tentativas_questoes')
    .select('ordem, respondida, acertou, resposta_escolhida, resposta_correta, respondido_em, questoes(enunciado, temas(nome))')
    .eq('tentativas_idtentativas', tentativaId)
    .order('ordem', { ascending: true });

  if (erroQuestoes) {
    return responder(res, 503, { erro: 'Não foi possível consultar o histórico.' });
  }

  return responder(res, 200, {
    tentativa,
    questoes: (questoes || []).map(item => ({
      ordem: item.ordem,
      tema: item.questoes?.temas?.nome ?? '',
      enunciado: item.questoes?.enunciado ?? '',
      resposta_escolhida: item.resposta_escolhida,
      resposta_correta: item.resposta_correta,
      acertou: item.acertou === true,
      respondido_em: item.respondida ? item.respondido_em : null,
    })),
  });
}
