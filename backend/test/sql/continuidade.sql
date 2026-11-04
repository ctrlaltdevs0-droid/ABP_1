BEGIN;
SET LOCAL ROLE service_role;
UPDATE public.questoes SET status=true,status_editorial='APROVADO';
DO $teste$
DECLARE
  u INTEGER; outro INTEGER; id INTEGER; q INTEGER; a INTEGER; j JSONB; prazo TIMESTAMPTZ; gabarito CHAR(1);
  s1 UUID := '11111111-1111-4111-8111-111111111111';
  s2 UUID := '22222222-2222-4222-8222-222222222222';
BEGIN
  INSERT INTO public.usuarios(cpf,nome,email,senha_hash) VALUES('00000000991','Continuidade','continuidade@example.com','teste') RETURNING idusuarios INTO u;
  INSERT INTO public.usuarios(cpf,nome,email,senha_hash) VALUES('00000000992','Outro','outro@example.com','teste') RETURNING idusuarios INTO outro;
  ASSERT (public.operar_continuidade_prova(u,'iniciar',NULL,s1)->>'erro_codigo')='ESTUDOS_PENDENTES';
  INSERT INTO public.progresso_estudos(usuarios_idusuarios,temas_idtemas) SELECT u,idtemas FROM public.temas WHERE ativo;
  j := public.operar_continuidade_prova(u,'iniciar',NULL,s1);
  id := (j->'tentativa'->>'idtentativas')::INTEGER;
  ASSERT id IS NOT NULL, j::TEXT;
  ASSERT (j->>'total_questoes')::INTEGER=12;
  ASSERT (public.operar_continuidade_prova(u,'iniciar',NULL,s1)->'tentativa'->>'idtentativas')::INTEGER=id;
  ASSERT (public.operar_continuidade_prova(outro,'retomar',id,s2)->>'erro_codigo')='NAO_ENCONTRADA';
  ASSERT NOT (public.operar_continuidade_prova(outro,'atual') ? 'total_questoes');

  j := public.operar_continuidade_prova(u,'proxima',id,s1);
  q := (j->'questao'->>'idquestoes')::INTEGER;
  prazo := (j->>'expira_em')::TIMESTAMPTZ;
  ASSERT q IS NOT NULL;
  ASSERT (j->>'expira_em')::TIMESTAMPTZ - (j->>'iniciado_em')::TIMESTAMPTZ = INTERVAL '150 seconds';
  ASSERT (public.operar_continuidade_prova(u,'pausar',id,s1)->>'erro_codigo')='QUESTAO_ABERTA';
  PERFORM public.operar_continuidade_prova(u,'presenca',id,s1);
  ASSERT (SELECT expira_em FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q)=prazo;

  -- Recarga/segunda aba encerra a questão aberta e invalida a aba antiga.
  PERFORM public.operar_continuidade_prova(u,'retomar',id,s2);
  ASSERT (SELECT respondida AND NOT acertou AND motivo_encerramento='RETOMADA' FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  ASSERT (public.operar_continuidade_prova(u,'interromper',id,s1,q,NULL,'FECHAMENTO')->>'erro_codigo')='SESSAO_INVALIDA';
  j := public.operar_continuidade_prova(u,'proxima',id,s2);
  ASSERT (j->>'ordem')::INTEGER=2;
  -- Evento atrasado da questão anterior não pode encerrar a atual.
  ASSERT (public.operar_continuidade_prova(u,'interromper',id,s2,q,NULL,'FECHAMENTO')->>'erro_codigo')='ACAO_INVALIDA';
  q := (j->'questao'->>'idquestoes')::INTEGER;
  PERFORM public.operar_continuidade_prova(u,'interromper',id,s2,q,NULL,'FECHAMENTO');
  PERFORM public.operar_continuidade_prova(u,'interromper',id,s2,q,NULL,'FECHAMENTO');
  ASSERT (public.operar_continuidade_prova(u,'estado',id,s2)->>'respondidas')::INTEGER=2;
  ASSERT (public.operar_continuidade_prova(u,'proxima',id,s2)->>'erro_codigo')='INDISPONIVEL';
  PERFORM public.operar_continuidade_prova(u,'retomar',id,s2);

  -- Queda sem evento de saída: presença expirada bloqueia a resposta.
  j := public.operar_continuidade_prova(u,'proxima',id,s2);
  q := (j->'questao'->>'idquestoes')::INTEGER;
  SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta;
  UPDATE public.tentativas SET ultimo_contato_em=clock_timestamp()-INTERVAL '31 seconds' WHERE idtentativas=id;
  ASSERT (public.operar_continuidade_prova(u,'responder',id,s2,q,a)->>'erro_codigo')='TEMPO_ESGOTADO';
  ASSERT NOT EXISTS(SELECT 1 FROM public.respostas WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  ASSERT (SELECT motivo_encerramento='CONEXAO' FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  PERFORM public.operar_continuidade_prova(u,'retomar',id,s2);

  -- Pausa entre questões não abre nem consome a próxima.
  PERFORM public.operar_continuidade_prova(u,'pausar',id,s2);
  ASSERT (public.operar_continuidade_prova(u,'estado',id,s2)->'tentativa'->>'status')='INTERROMPIDA';
  PERFORM public.operar_continuidade_prova(u,'retomar',id,s2);
  ASSERT (public.operar_continuidade_prova(u,'estado',id,s2)->>'respondidas')::INTEGER=3;

  j := public.operar_continuidade_prova(u,'proxima',id,s2);
  q := (j->'questao'->>'idquestoes')::INTEGER;
  UPDATE public.tentativas_questoes SET expira_em=clock_timestamp()-INTERVAL '1 second' WHERE tentativas_idtentativas=id AND questoes_idquestoes=q;
  PERFORM public.operar_continuidade_prova(u,'estado',id,s2);
  ASSERT (SELECT respondida AND expirou AND NOT acertou FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  ASSERT (public.operar_continuidade_prova(u,'finalizar',id,s2)->>'erro_codigo')='PENDENTE';

  LOOP
    j := public.operar_continuidade_prova(u,'proxima',id,s2);
    EXIT WHEN (j->>'concluida')::BOOLEAN;
    q := (j->'questao'->>'idquestoes')::INTEGER;
    SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta;
    ASSERT (public.operar_continuidade_prova(u,'responder',id,s2,q,a)->>'resposta_registrada')::BOOLEAN;
    ASSERT (public.operar_continuidade_prova(u,'responder',id,s2,q,a)->>'erro_codigo')='FORA_SEQUENCIA';
  END LOOP;
  j := public.operar_continuidade_prova(u,'finalizar',id,s2);
  ASSERT (j->'resultado'->>'acertos')::INTEGER=8, j::TEXT;
  ASSERT (j->'resultado'->>'aprovado')::BOOLEAN;
  ASSERT NOT EXISTS(SELECT 1 FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND resposta_correta IS NULL);
  ASSERT (public.operar_continuidade_prova(u,'finalizar',id,s2)->'resultado')=j->'resultado';
  ASSERT (SELECT count(*) FROM public.certificados WHERE tentativas_idtentativas=id)=1;
  -- Edição posterior do gabarito não altera a resposta correta histórica.
  SELECT questoes_idquestoes INTO q FROM public.tentativas_questoes WHERE tentativas_idtentativas=id ORDER BY ordem LIMIT 1;
  SELECT resposta_correta INTO gabarito FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q;
  UPDATE public.alternativas SET correta=false WHERE questoes_idquestoes=q;
  UPDATE public.alternativas SET correta=true WHERE idalternativas=(SELECT min(idalternativas) FROM public.alternativas WHERE questoes_idquestoes=q AND letra<>gabarito);
  ASSERT (SELECT resposta_correta=gabarito FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  ASSERT NOT has_function_privilege('anon','public.operar_continuidade_prova(integer,text,integer,uuid,integer,integer,text)','EXECUTE');
  ASSERT NOT has_function_privilege('authenticated','public.resumo_continuidade_prova(integer,integer)','EXECUTE');
END;
$teste$;
ROLLBACK;
