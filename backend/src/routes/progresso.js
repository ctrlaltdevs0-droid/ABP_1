
import { responder } from '../utils/http.js';

export async function progressoRoutes(req, res, pathname, supabase) {
  const lista = /^\/api\/estudos\/progresso\/?$/.test(pathname);

  const tema = pathname.match(
    /^\/api\/temas\/([1-9]\d*)\/conclusao\/?$/
  );

  if (!lista && !tema) return false;

  // O ID vem do usuário autenticado pelo middleware.
  const usuarioId = req.usuario.id;

  // GET /api/estudos/progresso
  if (lista && req.method === 'GET') {
    const { data, error } = await supabase
      .from('progresso_estudos')
      .select('temas_idtemas,concluido_em')
      .eq('usuarios_idusuarios', usuarioId);

    if (error) {
      console.error('Erro ao consultar progresso:', error);

      return responder(res, 503, {
        erro: 'Não foi possível consultar o progresso.'
      });
    }

    return responder(res, 200, data || []);
  }

  // PUT /api/temas/:id/conclusao
  if (tema && req.method === 'PUT') {
    try {
      const temaId = Number(tema[1]);

      if (!Number.isSafeInteger(temaId)) {
        return responder(res, 400, {
          erro: 'Tema inválido.'
        });
      }

      // 1. Verifica se o tema existe e está ativo.
      const { data: temaAtivo, error: erroTema } = await supabase
        .from('temas')
        .select('idtemas')
        .eq('idtemas', temaId)
        .eq('ativo', true)
        .maybeSingle();

      if (erroTema) throw erroTema;

      if (!temaAtivo) {
        return responder(res, 404, {
          erro: 'Tema não encontrado.'
        });
      }

      // 2. Verifica se o usuário já concluiu esse tema.
      const { data: progressoExistente, error: erroProgresso } =
        await supabase
          .from('progresso_estudos')
          .select('temas_idtemas')
          .eq('usuarios_idusuarios', usuarioId)
          .eq('temas_idtemas', temaId)
          .maybeSingle();

      if (erroProgresso) throw erroProgresso;

      if (progressoExistente) {
        return responder(res, 200, {
          temas_idtemas: temaId,
          concluido: true,
          mensagem: 'Este tema já está concluído.'
        });
      }

      // 3. Busca as questões ativas pertencentes ao tema.
      const { data: questoes, error: erroQuestoes } = await supabase
        .from('questoes')
        .select('idquestoes')
        .eq('temas_idtemas', temaId)
        .eq('status', true);

      if (erroQuestoes) throw erroQuestoes;

      const idsQuestoes = (questoes || []).map(
        questao => questao.idquestoes
      );

      if (idsQuestoes.length < 3) {
        return responder(res, 409, {
          erro: 'Este tema precisa ter pelo menos 3 questões ativas para permitir a conclusão.',
          acertos: 0,
          necessarios: 3
        });
      }

      // 4. Busca as respostas desse usuário para as questões do tema.
      const { data: respostas, error: erroRespostas } = await supabase
        .from('respostas_estudos')
        .select(
          'idrespostas_estudos,questoes_idquestoes,acertou,respondido_em'
        )
        .eq('usuarios_idusuarios', usuarioId)
        .in('questoes_idquestoes', idsQuestoes)
        .order('respondido_em', { ascending: true })
        .order('idrespostas_estudos', { ascending: true });

      if (erroRespostas) throw erroRespostas;

      // 5. Considera somente a primeira resposta de cada questão.
      // Isso evita contar registros duplicados antigos.
      const respostasUnicas = new Map();

      for (const resposta of respostas || []) {
        if (!respostasUnicas.has(resposta.questoes_idquestoes)) {
          respostasUnicas.set(
            resposta.questoes_idquestoes,
            resposta
          );
        }
      }

      // 6. Conta quantas questões foram respondidas corretamente.
      const acertos = [...respostasUnicas.values()].filter(
        resposta => resposta.acertou === true
      ).length;

      // 7. Impede a conclusão se houver menos de 3 acertos.
      if (acertos < 3) {
        return responder(res, 409, {
          erro: `Você precisa acertar pelo menos 3 questões para concluir este tema. Você tem ${acertos} acerto(s).`,
          acertos,
          necessarios: 3,
          faltam: 3 - acertos
        });
      }

      // 8. Registra a conclusão no banco.
      const { error: erroSalvar } = await supabase
        .from('progresso_estudos')
        .upsert(
          {
            usuarios_idusuarios: usuarioId,
            temas_idtemas: temaId
          },
          {
            onConflict: 'usuarios_idusuarios,temas_idtemas',
            ignoreDuplicates: true
          }
        );

      if (erroSalvar) throw erroSalvar;

      return responder(res, 200, {
        temas_idtemas: temaId,
        concluido: true,
        acertos,
        mensagem: 'Tema concluído com sucesso!'
      });
    } catch (error) {
      console.error('Erro ao concluir tema:', error);

      return responder(res, 503, {
        erro: 'Não foi possível registrar a conclusão do tema.'
      });
    }
  }

  return responder(res, 405, {
    erro: 'Método HTTP não permitido.'
  });
}