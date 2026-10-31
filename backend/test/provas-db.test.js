import assert from 'node:assert/strict';
import { test } from 'node:test';
import { spawn } from 'node:child_process';

const container = process.env.SECURITY_TEST_CONTAINER;
function sql(query) {
  return new Promise((resolve, reject) => {
    const child = spawn('docker', ['exec', '-i', container, 'psql', '-X', '-U', 'postgres', '-At', '-v', 'ON_ERROR_STOP=1']);
    let out = '', err = '';
    child.stdout.on('data', d => out += d);
    child.stderr.on('data', d => err += d);
    child.on('error', reject);
    child.on('close', (code, signal) => code === 0 ? resolve(out.trim()) : reject(new Error(`psql/docker code=${code} signal=${signal}: ${err || out}`)));
    child.stdin.end(query);
  });
}

test('PostgreSQL: base editorial, sequência, prazo, isolamento, rollback e certificado', { skip: !container }, async () => {
  assert.match(container, /^abp_security_test_/);
  await sql(`
BEGIN;
INSERT INTO public.usuarios(cpf,nome,email,senha_hash) VALUES ('00000000001','Teste','teste@example.com','hash');
DO $test$
DECLARE
  u INTEGER := (SELECT idusuarios FROM public.usuarios WHERE cpf='00000000001');
  id INTEGER;
  q INTEGER;
  a INTEGER;
  proxima INTEGER;
  j JSONB;
  repetida JSONB;
  prazo TIMESTAMPTZ;
  antes INTEGER;
BEGIN
  SET LOCAL ROLE service_role;
  ASSERT (public.iniciar_prova(u)->>'erro_codigo')='BASE_INSUFICIENTE', 'Rascunhos devem bloquear a prova';
  ASSERT (SELECT count(*) FROM public.tentativas)=0, 'Base inválida não pode deixar tentativa parcial';
  UPDATE public.questoes SET status=true,status_editorial='APROVADO';
  UPDATE public.temas SET ativo=false WHERE ordem=12;
  ASSERT (public.iniciar_prova(u)->>'erro_codigo')='BASE_INSUFICIENTE', 'Faltam 12 temas ativos';
  UPDATE public.temas SET ativo=true;
  UPDATE public.questoes SET status_editorial='REVISAO' WHERE idquestoes=(SELECT min(idquestoes) FROM public.questoes);
  ASSERT (public.iniciar_prova(u)->>'erro_codigo')='BASE_INSUFICIENTE', 'Exigir quatro questões por tema';
  UPDATE public.questoes SET status_editorial='APROVADO';
  UPDATE public.alternativas SET correta=false WHERE questoes_idquestoes=(SELECT min(idquestoes) FROM public.questoes);
  ASSERT (public.iniciar_prova(u)->>'erro_codigo')='BASE_INSUFICIENTE', 'Questão sem gabarito não é elegível';
  UPDATE public.alternativas SET correta=true WHERE letra='A' AND questoes_idquestoes=(SELECT min(idquestoes) FROM public.questoes);
  -- Erro no vínculo precisa desfazer também o INSERT da tentativa.
  SELECT count(*) INTO antes FROM public.tentativas;
  BEGIN
    PERFORM set_config('abp.test_failure','tentativas_questoes',true);
    PERFORM public.iniciar_prova(u);
    ASSERT false, 'Esperado erro simulado';
  EXCEPTION WHEN check_violation THEN NULL;
  END;
  ASSERT (SELECT count(*) FROM public.tentativas)=antes, 'Rollback deve ser completo';
  j := public.iniciar_prova(u);
  id := (j->'tentativa'->>'idtentativas')::INTEGER;
  ASSERT (j->>'total_questoes')::INTEGER=12;
  ASSERT (SELECT count(*) FROM public.tentativas_questoes WHERE tentativas_idtentativas=id)=12;
  ASSERT (public.proxima_questao_segura(u+999,id)->>'erro_codigo')='NAO_ENCONTRADA';
  ASSERT (public.finalizar_prova(u,id)->>'erro_codigo')='PENDENTE';
  SELECT questoes_idquestoes INTO q FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND ordem=1;
  SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta;
  ASSERT (public.responder_prova(u,id,q,a)->>'erro_codigo')='FORA_SEQUENCIA', 'Não responder antes de abrir';
  j := public.proxima_questao_segura(u,id);
  prazo := (j->>'expira_em')::TIMESTAMPTZ;
  ASSERT prazo-(j->>'iniciado_em')::TIMESTAMPTZ=INTERVAL '150 seconds';
  ASSERT NOT ((j->'alternativas'->0) ? 'correta'), 'Não expor o gabarito';
  ASSERT (public.proxima_questao_segura(u,id)->>'expira_em')::TIMESTAMPTZ=prazo, 'Recarregar não reinicia prazo';
  SELECT questoes_idquestoes INTO proxima FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND ordem=2;
  ASSERT (public.responder_prova(u,id,proxima,a)->>'erro_codigo')='FORA_SEQUENCIA';
  ASSERT (public.responder_prova(u,id,q,999999)->>'erro_codigo')='ALTERNATIVA_INVALIDA';
  ASSERT (public.responder_prova(u,id,q,a)->>'resposta_registrada')::BOOLEAN;
  ASSERT (public.responder_prova(u,id,q,a)->>'erro_codigo')='FORA_SEQUENCIA', 'Sem resposta duplicada';
  -- Expiração usa relógio do banco. Forçar prazo no passado evita esperar 150s.
  j := public.proxima_questao_segura(u,id);
  q := (j->'questao'->>'idquestoes')::INTEGER;
  SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta;
  UPDATE public.tentativas_questoes SET expira_em=clock_timestamp() WHERE tentativas_idtentativas=id AND questoes_idquestoes=q;
  ASSERT (public.responder_prova(u,id,q,a)->>'erro_codigo')='TEMPO_ESGOTADO';
  ASSERT (SELECT expirou AND respondida AND NOT acertou FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  ASSERT NOT EXISTS(SELECT 1 FROM public.respostas WHERE tentativas_idtentativas=id AND questoes_idquestoes=q);
  -- Outro timeout é consumido por GET; nunca pula uma questão ainda dentro do prazo.
  j := public.proxima_questao_segura(u,id);
  q := (j->'questao'->>'idquestoes')::INTEGER;
  UPDATE public.tentativas_questoes SET expira_em=clock_timestamp() WHERE tentativas_idtentativas=id AND questoes_idquestoes=q;
  j := public.proxima_questao_segura(u,id);
  ASSERT (j->>'ordem')::INTEGER=4;
  LOOP
    j := public.proxima_questao_segura(u,id);
    EXIT WHEN (j->>'concluida')::BOOLEAN;
    q := (j->'questao'->>'idquestoes')::INTEGER;
    SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta;
    PERFORM public.responder_prova(u,id,q,a);
  END LOOP;
  -- Uma falha na emissão reverte a finalização, permitindo repetição segura.
  BEGIN
    PERFORM set_config('abp.test_failure','certificados',true);
    PERFORM public.finalizar_prova(u,id);
    ASSERT false, 'Esperado erro no certificado';
  EXCEPTION WHEN check_violation THEN NULL;
  END;
  ASSERT (SELECT status FROM public.tentativas WHERE idtentativas=id)='EM_ANDAMENTO';
  j := public.finalizar_prova(u,id);
  ASSERT (j->'resultado'->>'acertos')::INTEGER=10;
  ASSERT (j->'resultado'->>'total')::INTEGER=12;
  ASSERT (j->'certificado'->>'idcertificados') IS NOT NULL;
  repetida := public.finalizar_prova(u,id);
  ASSERT repetida=j, 'Finalização idempotente';
  ASSERT (public.responder_prova(u,id,q,a)->>'erro_codigo')='INDISPONIVEL';
  ASSERT (SELECT count(*) FROM public.certificados WHERE tentativas_idtentativas=id)=1;
  -- Retirar publicação após seleção impede entregar a questão.
  j := public.iniciar_prova(u); id := (j->'tentativa'->>'idtentativas')::INTEGER;
  UPDATE public.questoes SET status=false WHERE idquestoes=(SELECT questoes_idquestoes FROM public.tentativas_questoes WHERE tentativas_idtentativas=id AND ordem=1);
  ASSERT (public.proxima_questao_segura(u,id)->>'erro_codigo')='CONTEUDO_INDISPONIVEL';
  -- Tentativa legada com uma questão jamais pode produzir certificado.
  INSERT INTO public.tentativas(usuarios_idusuarios) VALUES(u) RETURNING idtentativas INTO id;
  INSERT INTO public.tentativas_questoes(tentativas_idtentativas,questoes_idquestoes,respondida,acertou) VALUES(id,q,true,true);
  ASSERT (public.finalizar_prova(u,id)->>'erro_codigo')='PROVA_INVALIDA';
  ASSERT NOT EXISTS(SELECT 1 FROM public.certificados WHERE tentativas_idtentativas=id);
END;
$test$;
ROLLBACK;
` .replace('DO $test$', `CREATE FUNCTION pg_temp.falhar() RETURNS trigger LANGUAGE plpgsql AS $fn$ BEGIN IF current_setting('abp.test_failure',true)=TG_TABLE_NAME THEN RAISE EXCEPTION 'falha simulada' USING ERRCODE='23514'; END IF; RETURN NEW; END; $fn$;\nCREATE TRIGGER falha_teste BEFORE INSERT ON public.tentativas_questoes FOR EACH ROW EXECUTE FUNCTION pg_temp.falhar();\nCREATE TRIGGER falha_certificado BEFORE INSERT ON public.certificados FOR EACH ROW EXECUTE FUNCTION pg_temp.falhar();\nDO $test$`));
});

test('PostgreSQL: limites compartilhados, recuperação, senha e permissões', { skip: !container }, async () => {
  await sql(`BEGIN;
DO $test$
DECLARE j JSONB; i INTEGER; u INTEGER;
BEGIN
  ASSERT NOT has_function_privilege('anon','public.iniciar_prova(integer)','EXECUTE');
  ASSERT NOT has_function_privilege('authenticated','public.finalizar_prova(integer,integer)','EXECUTE');
  ASSERT NOT EXISTS(SELECT 1 FROM pg_proc WHERE proname IN ('iniciar_prova','finalizar_prova','responder_prova','limitar_autenticacao','alterar_senha_segura') AND prosecdef);
  ASSERT NOT has_table_privilege('anon','public.limites_autenticacao','SELECT');
  SET LOCAL ROLE service_role;
  FOR i IN 1..10 LOOP
    ASSERT (public.limitar_autenticacao(repeat('a',64),repeat('b',64),false)->>'permitido')::BOOLEAN;
  END LOOP;
  j := public.limitar_autenticacao(repeat('a',64),repeat('b',64),false);
  ASSERT NOT (j->>'permitido')::BOOLEAN;
  ASSERT (j->>'retry_after')::INTEGER BETWEEN 1 AND 900;
  -- Conta bloqueada também em outro IP.
  ASSERT NOT (public.limitar_autenticacao(repeat('c',64),repeat('b',64),false)->>'permitido')::BOOLEAN;
  UPDATE public.limites_autenticacao SET inicio=clock_timestamp()-INTERVAL '16 minutes';
  ASSERT (public.limitar_autenticacao(repeat('a',64),repeat('b',64),false)->>'permitido')::BOOLEAN;
  FOR i IN 1..31 LOOP j := public.limitar_autenticacao(repeat('d',64),md5(i::TEXT)||md5(i::TEXT),false); END LOOP;
  ASSERT NOT (j->>'permitido')::BOOLEAN, 'IP deve bloquear mesmo alternando contas';
  FOR i IN 1..11 LOOP j := public.limitar_autenticacao(repeat('e',64),repeat('f',64),true); END LOOP;
  ASSERT NOT (j->>'permitido')::BOOLEAN, 'Cadastro também limitado';
  INSERT INTO public.usuarios(cpf,nome,email,senha_hash) VALUES('00000000002','Teste','teste2@example.com','antigo') RETURNING idusuarios INTO u;
  ASSERT public.alterar_senha_segura(u,'antigo','novo');
  ASSERT NOT public.alterar_senha_segura(u,'antigo','outro'), 'CAS evita sobrescrita concorrente';
  ASSERT (SELECT versao_sessao FROM public.usuarios WHERE idusuarios=u)=1;
  ASSERT (SELECT senha_hash FROM public.usuarios WHERE idusuarios=u)='novo';
END;
$test$;
ROLLBACK;`);
});

test('PostgreSQL: concorrência serializa resposta, entrega, certificado e limite', { skip: !container }, async () => {
  const user = Number(await sql(`INSERT INTO public.usuarios(cpf,nome,email,senha_hash) VALUES('00000000003','Concorrência','conc@example.com','hash') RETURNING idusuarios;` ).then(s => s.split('\n')[0]));
  await sql('UPDATE public.questoes SET status=true,status_editorial=\'APROVADO\';');
  const started = JSON.parse(await sql(`SELECT public.iniciar_prova(${user});`));
  const id = started.tentativa.idtentativas;
  const [a, b] = await Promise.all([sql(`SELECT public.proxima_questao_segura(${user},${id});`), sql(`SELECT public.proxima_questao_segura(${user},${id});`)]);
  assert.deepEqual(JSON.parse(a), JSON.parse(b));
  const q = JSON.parse(a).questao.idquestoes;
  const alt = Number(await sql(`SELECT idalternativas FROM public.alternativas WHERE questoes_idquestoes=${q} AND correta;`));
  const responses = await Promise.all([sql(`SELECT public.responder_prova(${user},${id},${q},${alt});`), sql(`SELECT public.responder_prova(${user},${id},${q},${alt});`)]);
  assert.equal(responses.filter(s => JSON.parse(s).resposta_registrada).length, 1);
  assert.equal(responses.filter(s => JSON.parse(s).erro_codigo === 'FORA_SEQUENCIA').length, 1);
  // Completa as demais questões pelo fluxo real, sem escrever acertos artificialmente.
  await sql(`DO $$ DECLARE j JSONB; q INTEGER; a INTEGER; BEGIN LOOP j:=public.proxima_questao_segura(${user},${id}); EXIT WHEN (j->>'concluida')::BOOLEAN; q:=(j->'questao'->>'idquestoes')::INTEGER; SELECT idalternativas INTO a FROM public.alternativas WHERE questoes_idquestoes=q AND correta; PERFORM public.responder_prova(${user},${id},q,a); END LOOP; END; $$;`);
  const finishes = await Promise.all([sql(`SELECT public.finalizar_prova(${user},${id});`), sql(`SELECT public.finalizar_prova(${user},${id});`)]);
  assert.deepEqual(JSON.parse(finishes[0]), JSON.parse(finishes[1]));
  assert.equal(await sql(`SELECT count(*) FROM public.certificados WHERE tentativas_idtentativas=${id};`), '1');
  const limited = [];
  for (let batch=0;batch<6;batch++) limited.push(...await Promise.all([1,2].map(() => sql(`SELECT public.limitar_autenticacao(repeat('1',64),repeat('2',64),false);`))));
  assert.equal(limited.filter(s => JSON.parse(s).permitido).length, 10);
});
