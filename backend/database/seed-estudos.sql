-- Gerado por npm run seed:gerar; editar content-estudos.json.

BEGIN;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Fundamentos da Agilidade', 'Agilidade é aprender com entregas frequentes e adaptar o trabalho conforme as necessidades das pessoas. Um plano orienta decisões, mas deve ser revisto quando surgem evidências.

Uma equipe pode entregar primeiro uma inscrição simples, observar dificuldades reais e então melhorar o formulário. Essa sequência reduz o risco de construir funcionalidades sem utilidade. Documentar decisões e conversar com usuários ajuda a manter o aprendizado acessível.

Para praticar: escolha uma necessidade pequena, descreva o resultado esperado, entregue uma primeira solução e combine como obter feedback. Não confunda trabalhar de forma ágil com trabalhar sem qualidade ou sem planejamento.', 'https://agilemanifesto.org/iso/ptbr/manifesto.html', 'PB056-1', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Qual atitude favorece a adaptação em um projeto?', 'PB053-1-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Revisar decisões usando feedback das entregas', TRUE),
    (questao_id, 'B', 'Ignorar usuários após o início', FALSE),
    (questao_id, 'C', 'Manter todo plano mesmo sem valor', FALSE),
    (questao_id, 'D', 'Entregar apenas no último dia', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Qual é a utilidade de entregar uma parte pequena do produto?', 'PB053-1-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Dispensar testes', FALSE),
    (questao_id, 'B', 'Validar uma necessidade com menor investimento inicial', TRUE),
    (questao_id, 'C', 'Eliminar toda comunicação', FALSE),
    (questao_id, 'D', 'Garantir que nunca haverá mudanças', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Uma equipe recebe evidências de que a solução não atende ao usuário. O que fazer?', 'PB053-1-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Aumentar o escopo sem discussão', FALSE),
    (questao_id, 'B', 'Proibir novas conversas', FALSE),
    (questao_id, 'C', 'Investigar o problema e ajustar o trabalho', TRUE),
    (questao_id, 'D', 'Ocultar as evidências', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'O que caracteriza um planejamento adaptativo?', 'PB053-1-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Ausência de objetivo', FALSE),
    (questao_id, 'B', 'Prometer precisão absoluta', FALSE),
    (questao_id, 'C', 'Registrar um plano e nunca consultá-lo', FALSE),
    (questao_id, 'D', 'Atualizar o plano conforme o aprendizado', TRUE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Introdução ao Scrum', 'Scrum oferece uma estrutura para equipes enfrentarem problemas complexos. O trabalho avança em ciclos chamados Sprints, nos quais a equipe busca um objetivo e inspeciona os resultados. O uso de Scrum não garante sucesso: decisões continuam dependendo do contexto e das evidências.

Em um portal de estudos, uma Sprint pode buscar permitir a leitura de um tema completo. A equipe acompanha o trabalho, demonstra o resultado e decide o próximo passo com base no que aprendeu.

Para praticar: descreva um objetivo verificável e identifique qual pequena entrega permitiria avaliar seu avanço. Evite tratar a Sprint como uma lista de tarefas sem propósito compartilhado.', 'https://scrumguides.org/scrum-guide.html', 'PB056-2', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Em que contexto Scrum pode ajudar uma equipe?', 'PB053-2-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Trabalhos sem colaboração', FALSE),
    (questao_id, 'B', 'Problemas complexos que exigem aprendizado', TRUE),
    (questao_id, 'C', 'Somente tarefas totalmente previsíveis', FALSE),
    (questao_id, 'D', 'Apenas projetos sem usuários', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'O que é uma Sprint?', 'PB053-2-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Uma ferramenta de mensagens', FALSE),
    (questao_id, 'B', 'Um documento de contratação', FALSE),
    (questao_id, 'C', 'Um ciclo de trabalho com duração limitada', TRUE),
    (questao_id, 'D', 'Um cargo gerencial', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Qual prática ajuda uma equipe a aprender com uma entrega?', 'PB053-2-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Evitar demonstrações', FALSE),
    (questao_id, 'B', 'Esconder dificuldades', FALSE),
    (questao_id, 'C', 'Ignorar resultados', FALSE),
    (questao_id, 'D', 'Inspecionar o resultado e adaptar o próximo passo', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Como avaliar se um objetivo de Sprint foi alcançado?', 'PB053-2-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Observar o resultado verificável que foi combinado', TRUE),
    (questao_id, 'B', 'Contar apenas reuniões', FALSE),
    (questao_id, 'C', 'Comparar horas individuais', FALSE),
    (questao_id, 'D', 'Considerar qualquer tarefa iniciada como pronta', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Papéis do Scrum', 'No Scrum Team, Product Owner, Scrum Master e Developers assumem responsabilidades complementares. O Product Owner orienta o valor do produto; o Scrum Master ajuda a equipe a usar Scrum; os Developers constroem a entrega.

No portal, o Product Owner pode esclarecer a necessidade de retomar os estudos, enquanto os Developers decidem como implementar a solução. O Scrum Master ajuda a tornar impedimentos visíveis e promove melhorias na colaboração. Nenhuma dessas responsabilidades substitui o diálogo entre todos.

Para praticar: diante de uma dúvida de prioridade, converse sobre valor. Diante de uma decisão técnica, envolva quem construirá e manterá a solução. Evite concentrar toda decisão em uma única pessoa.', 'https://scrumguides.org/scrum-guide.html', 'PB056-3', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Quem responde pela maximização do valor do produto?', 'PB053-3-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Um avaliador externo', FALSE),
    (questao_id, 'B', 'O administrador da rede', FALSE),
    (questao_id, 'C', 'Product Owner', TRUE),
    (questao_id, 'D', 'Somente o cliente final', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Qual contribuição é esperada do Scrum Master?', 'PB053-3-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Distribuir toda tarefa individual obrigatoriamente', FALSE),
    (questao_id, 'B', 'Substituir o Product Owner', FALSE),
    (questao_id, 'C', 'Aprovar sozinho cada linha de código', FALSE),
    (questao_id, 'D', 'Ajudar a equipe a compreender e aplicar Scrum', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Quem organiza como construir o trabalho selecionado na Sprint?', 'PB053-3-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Developers', TRUE),
    (questao_id, 'B', 'Somente investidores', FALSE),
    (questao_id, 'C', 'Somente fornecedores', FALSE),
    (questao_id, 'D', 'Um usuário escolhido ao acaso', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Como esclarecer uma dúvida sobre prioridade de produto?', 'PB053-3-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Esperar o projeto acabar', FALSE),
    (questao_id, 'B', 'Discutir o valor esperado com o Product Owner', TRUE),
    (questao_id, 'C', 'Decidir apenas pela cor do cartão', FALSE),
    (questao_id, 'D', 'Excluir a necessidade sem conversar', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Eventos do Scrum', 'Os eventos criam momentos para alinhar intenções, acompanhar o trabalho e aprender. O planejamento inicia a Sprint; a Daily ajuda a ajustar o plano diário; a Review examina o resultado; a Retrospectiva procura melhorias na forma de trabalhar.

Uma Review pode revelar que estudantes não encontram o botão de continuar. Uma Retrospectiva pode identificar que faltou testar a navegação no celular. O primeiro aprendizado trata do produto; o segundo trata do processo da equipe.

Para praticar: termine cada conversa com uma decisão útil ou um próximo passo claro. Reuniões sem propósito não substituem colaboração durante o trabalho.', 'https://scrumguides.org/scrum-guide.html', 'PB056-4', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual evento ajuda a organizar o início da Sprint?', 'PB053-4-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Auditoria anual', FALSE),
    (questao_id, 'B', 'Cerimônia de contratação', FALSE),
    (questao_id, 'C', 'Encerramento do contrato', FALSE),
    (questao_id, 'D', 'Sprint Planning', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual é um uso adequado da Daily Scrum?', 'PB053-4-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Ajustar o plano de trabalho em direção ao objetivo', TRUE),
    (questao_id, 'B', 'Fazer uma avaliação salarial', FALSE),
    (questao_id, 'C', 'Substituir todos os testes', FALSE),
    (questao_id, 'D', 'Demonstrar o produto a todos os clientes', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual evento é adequado para discutir uma entrega com interessados?', 'PB053-4-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Auditoria fiscal', FALSE),
    (questao_id, 'B', 'Sprint Review', TRUE),
    (questao_id, 'C', 'Reunião de compras', FALSE),
    (questao_id, 'D', 'Entrevista de seleção', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Onde a equipe pode discutir como melhorar sua colaboração?', 'PB053-4-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'No contrato de licença', FALSE),
    (questao_id, 'B', 'No cadastro de usuários', FALSE),
    (questao_id, 'C', 'Sprint Retrospective', TRUE),
    (questao_id, 'D', 'Somente no lançamento final', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Artefatos do Scrum', 'Artefatos tornam o trabalho e o resultado observáveis. O Product Backlog reúne necessidades do produto; o Sprint Backlog mostra o plano da Sprint; o Incremento representa uma entrega que atende ao padrão de qualidade combinado.

No portal, uma necessidade de salvar progresso pode entrar no Product Backlog. Quando selecionada, é detalhada no plano da Sprint. Só existe uma entrega utilizável quando interface, API e armazenamento funcionam juntos.

Para praticar: mostre claramente o que ainda é intenção, o que está em execução e o que está utilizável. Marcar uma tarefa como concluída sem validar a experiência inteira cria uma impressão enganosa de avanço.', 'https://scrumguides.org/scrum-guide.html', 'PB056-5', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Onde são organizadas as necessidades do produto?', 'PB053-5-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Product Backlog', TRUE),
    (questao_id, 'B', 'Lista de presença', FALSE),
    (questao_id, 'C', 'Folha de pagamento', FALSE),
    (questao_id, 'D', 'Inventário de computadores', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'O que o Sprint Backlog ajuda a tornar visível?', 'PB053-5-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'A estrutura jurídica da empresa', FALSE),
    (questao_id, 'B', 'O plano de trabalho da Sprint', TRUE),
    (questao_id, 'C', 'A senha dos usuários', FALSE),
    (questao_id, 'D', 'O faturamento anual', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'O que deve caracterizar um Incremento?', 'PB053-5-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Qualquer código que não executa', FALSE),
    (questao_id, 'B', 'Uma promessa comercial', FALSE),
    (questao_id, 'C', 'Uma entrega utilizável conforme o padrão de qualidade', TRUE),
    (questao_id, 'D', 'Um conjunto de ideias sem implementação', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Uma tela sem integração necessária com a API representa o quê?', 'PB053-5-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Entrega automaticamente validada', FALSE),
    (questao_id, 'B', 'Prova de aprovação do usuário', FALSE),
    (questao_id, 'C', 'Dispensa de verificar persistência', FALSE),
    (questao_id, 'D', 'Trabalho ainda incompleto para o fluxo integrado', TRUE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'User Stories', 'Uma User Story descreve uma necessidade pela perspectiva de quem usa o produto. Uma forma comum é indicar pessoa, ação e benefício. O texto inicia uma conversa; critérios de aceite tornam o resultado verificável. Essa técnica pode apoiar equipes ágeis, mas não é uma obrigação do Scrum.

Exemplo: como estudante, quero marcar um tema como concluído para retomar meu percurso. Um critério de aceite é entrar novamente e ainda visualizar a conclusão. Outro é impedir que a conclusão de uma pessoa apareça para outra.

Para praticar: escreva uma história pequena e acrescente exemplos de sucesso e falha. Evite transformar cada detalhe técnico em uma história sem benefício identificável.', 'https://www.agilealliance.org/glossary/user-stories/', 'PB056-6', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual informação ajuda a explicar o valor de uma User Story?', 'PB053-6-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'O modelo do computador', FALSE),
    (questao_id, 'B', 'O benefício esperado para a pessoa usuária', TRUE),
    (questao_id, 'C', 'A cor do editor de código', FALSE),
    (questao_id, 'D', 'O número de reuniões do mês', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Para que servem critérios de aceite?', 'PB053-6-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Garantir ausência de defeitos futuros', FALSE),
    (questao_id, 'B', 'Excluir casos de erro', FALSE),
    (questao_id, 'C', 'Definir condições verificáveis para aceitar a entrega', TRUE),
    (questao_id, 'D', 'Substituir toda conversa', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual exemplo verifica a persistência do progresso?', 'PB053-6-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Fechar um cartão sem abrir a tela', FALSE),
    (questao_id, 'B', 'Contar cliques sem consultar o servidor', FALSE),
    (questao_id, 'C', 'Trocar o título da página', FALSE),
    (questao_id, 'D', 'Entrar novamente e recuperar a conclusão do tema', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual história é mais fácil de discutir com um estudante?', 'PB053-6-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Salvar um tema concluído para retomar os estudos', TRUE),
    (questao_id, 'B', 'Criar uma variável sem contexto', FALSE),
    (questao_id, 'C', 'Renomear um arquivo sem objetivo', FALSE),
    (questao_id, 'D', 'Instalar qualquer ferramenta disponível', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Gestão do Product Backlog', 'Gerir o Product Backlog é manter necessidades compreensíveis e ordenadas para apoiar decisões. Valor, risco, dependências e aprendizado podem orientar essa ordem. Refinar é esclarecer e dividir itens conforme necessário; não significa congelar todo o escopo.

Antes de oferecer uma prova aleatória, o portal precisa de temas e questões válidas. Essa dependência pode justificar priorizar a base de dados. Já um detalhe visual pode esperar se não comprometer o uso da primeira entrega.

Para praticar: escolha três necessidades e explique a ordem com critérios explícitos. Reavalie quando surgir uma dependência ou uma evidência nova. Não confunda prioridade com pressão de quem fala mais alto.', 'https://scrumguides.org/scrum-guide.html', 'PB056-7', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Qual critério pode orientar a ordem do backlog?', 'PB053-7-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Quantidade de cores no cartão', FALSE),
    (questao_id, 'B', 'Preferência sem justificativa', FALSE),
    (questao_id, 'C', 'Valor esperado e dependências', TRUE),
    (questao_id, 'D', 'Ordem alfabética obrigatória', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'O que significa refinar um item?', 'PB053-7-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Impedir mudanças para sempre', FALSE),
    (questao_id, 'B', 'Marcar tudo como pronto', FALSE),
    (questao_id, 'C', 'Excluir critérios de aceite', FALSE),
    (questao_id, 'D', 'Esclarecer e dividir o trabalho quando necessário', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Por que preparar temas antes do sorteio de questões?', 'PB053-7-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'O sorteio depende de uma base coerente de temas', TRUE),
    (questao_id, 'B', 'Para dispensar a validação das questões', FALSE),
    (questao_id, 'C', 'Para substituir o login', FALSE),
    (questao_id, 'D', 'Para reduzir o número de usuários', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Quando reavaliar a ordem do backlog?', 'PB053-7-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Apenas ao mudar o logotipo', FALSE),
    (questao_id, 'B', 'Quando novas evidências alterarem valor, risco ou dependências', TRUE),
    (questao_id, 'C', 'Somente depois de encerrar o produto', FALSE),
    (questao_id, 'D', 'Nunca após a primeira reunião', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Kanban', 'Kanban ajuda a observar e melhorar o fluxo do trabalho. Um quadro torna visíveis as etapas, enquanto políticas explícitas esclarecem como os itens avançam. Controlar o trabalho iniciado favorece a conclusão antes de assumir novas demandas.

Exemplo de quadro: A fazer → Em execução → Em validação → Concluído. Se muitos itens aguardam validação, iniciar mais trabalho pode aumentar a fila. A equipe deve investigar o bloqueio e ajudar a concluir o que já começou.

Para praticar: desenhe o fluxo real da sua equipe, identifique onde os itens se acumulam e combine uma política para limitar novas entradas. O quadro deve refletir a realidade, inclusive bloqueios.', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-8', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Qual é a utilidade de um quadro Kanban?', 'PB053-8-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Eliminar a necessidade de colaboração', FALSE),
    (questao_id, 'B', 'Garantir prazo sem dados', FALSE),
    (questao_id, 'C', 'Substituir os usuários', FALSE),
    (questao_id, 'D', 'Tornar o fluxo de trabalho visível', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'O que significa limitar trabalho em progresso?', 'PB053-8-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Controlar quantos itens estão iniciados simultaneamente', TRUE),
    (questao_id, 'B', 'Impedir qualquer entrega', FALSE),
    (questao_id, 'C', 'Limitar a quantidade total de clientes', FALSE),
    (questao_id, 'D', 'Contar apenas reuniões', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Muitos itens aguardam validação. Qual ação ajuda o fluxo?', 'PB053-8-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Marcar todos como concluídos', FALSE),
    (questao_id, 'B', 'Investigar a fila e colaborar na validação', TRUE),
    (questao_id, 'C', 'Iniciar sempre mais itens', FALSE),
    (questao_id, 'D', 'Ocultar a coluna de validação', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Por que explicitar políticas de passagem entre etapas?', 'PB053-8-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Impedir aprendizado', FALSE),
    (questao_id, 'B', 'Permitir estados sem significado', FALSE),
    (questao_id, 'C', 'Criar entendimento comum sobre como o trabalho avança', TRUE),
    (questao_id, 'D', 'Dispensar qualquer inspeção', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Planejamento Ágil', 'Planejar de forma ágil é escolher um resultado, considerar a capacidade disponível e ajustar o caminho com o aprendizado. Estimativas apoiam a conversa sobre incerteza; não são garantias. Itens menores facilitam observar resultados e corrigir decisões.

No portal, entregar primeiro a leitura e conclusão de um tema permite verificar o fluxo antes de expandir o conteúdo. Dependências de banco, autenticação e revisão devem aparecer no plano. Transportar pendências de uma Sprint não significa que toda a estimativa original ainda está por fazer.

Para praticar: identifique o esforço restante de uma pendência e uma entrega pequena que possa ser demonstrada. Registre premissas e revise o plano quando elas deixarem de valer.', 'https://www.agilealliance.org/glossary/iteration-planning/', 'PB056-9', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Qual é a função de uma estimativa?', 'PB053-9-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Apoiar decisões diante da incerteza', TRUE),
    (questao_id, 'B', 'Garantir duração exata de qualquer tarefa', FALSE),
    (questao_id, 'C', 'Substituir critérios de aceite', FALSE),
    (questao_id, 'D', 'Definir automaticamente o salário', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'O que considerar ao selecionar trabalho para um ciclo?', 'PB053-9-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Todas as solicitações sem análise', FALSE),
    (questao_id, 'B', 'Objetivo, capacidade e dependências', TRUE),
    (questao_id, 'C', 'Somente o total de ideias', FALSE),
    (questao_id, 'D', 'Apenas o maior item', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Como planejar uma pendência transportada?', 'PB053-9-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Contar novamente pontos já concluídos', FALSE),
    (questao_id, 'B', 'Esconder a pendência', FALSE),
    (questao_id, 'C', 'Verificar o que existe e estimar o esforço restante', TRUE),
    (questao_id, 'D', 'Repetir obrigatoriamente todo o trabalho', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Por que dividir uma entrega grande em partes utilizáveis?', 'PB053-9-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Eliminar toda integração', FALSE),
    (questao_id, 'B', 'Evitar validar resultados', FALSE),
    (questao_id, 'C', 'Aumentar o trabalho sem benefício', FALSE),
    (questao_id, 'D', 'Obter feedback mais cedo e ajustar o plano', TRUE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Métricas Ágeis', 'Métricas ajudam a formular perguntas sobre o trabalho. Tempo de ciclo acompanha quanto um item leva entre início e término. Vazão conta itens concluídos em um intervalo. Trabalho em progresso mostra itens iniciados ainda não finalizados.

Se a fila de validação cresce e o tempo de ciclo aumenta, a equipe pode investigar falta de capacidade nessa etapa. Uma métrica isolada não explica a causa e não deve ser usada para ranquear pessoas. Comparações exigem definições consistentes.

Para praticar: registre início e término de alguns itens, calcule sua duração e procure variações. Em um burndown, mantenha o histórico diário e registre mudanças de escopo; o estado atual dos cartões não reconstrói os dias anteriores.', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-10', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'O que o tempo de ciclo mede?', 'PB053-10-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'O total de servidores', FALSE),
    (questao_id, 'B', 'O tempo entre início e término de um item', TRUE),
    (questao_id, 'C', 'A duração do contrato do cliente', FALSE),
    (questao_id, 'D', 'O número de integrantes', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'O que a vazão representa?', 'PB053-10-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'A velocidade da conexão', FALSE),
    (questao_id, 'B', 'A quantidade de mensagens', FALSE),
    (questao_id, 'C', 'A quantidade de itens concluídos em um período', TRUE),
    (questao_id, 'D', 'O total de itens apenas planejados', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Como interpretar o crescimento do trabalho em progresso?', 'PB053-10-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Concluir automaticamente que houve mais valor', FALSE),
    (questao_id, 'B', 'Premiar quem iniciou mais tarefas', FALSE),
    (questao_id, 'C', 'Dispensar a observação do fluxo', FALSE),
    (questao_id, 'D', 'Investigar possíveis filas e dificuldade de conclusão', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'O que é necessário para um burndown histórico confiável?', 'PB053-10-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Registros diários e mudanças de escopo identificadas', TRUE),
    (questao_id, 'B', 'Somente o estado final das issues', FALSE),
    (questao_id, 'C', 'Apenas uma estimativa inicial', FALSE),
    (questao_id, 'D', 'Uma curva ideal sem dados reais', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Ferramentas para Equipes Ágeis', 'Ferramentas apoiam organização, comunicação e rastreabilidade. Um quadro digital organiza itens; um repositório registra alterações; uma integração contínua executa verificações. Escolha a ferramenta pelo problema que ela ajuda a resolver, e não apenas por popularidade.

No portal, um item do backlog pode referenciar uma alteração no repositório e seus testes. Isso permite entender por que a mudança existe e como foi verificada. Informações sensíveis, como senhas e chaves do servidor, não devem ser publicadas em cartões ou arquivos versionados.

Para praticar: conecte uma necessidade a uma alteração pequena e registre a evidência de validação. Mantenha instruções para que outra pessoa consiga executar o projeto.', 'https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects', 'PB056-11', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Como escolher uma ferramenta para a equipe?', 'PB053-11-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Escolher apenas pela cor da interface', FALSE),
    (questao_id, 'B', 'Evitar ouvir a equipe', FALSE),
    (questao_id, 'C', 'Avaliar qual problema de colaboração ela resolve', TRUE),
    (questao_id, 'D', 'Instalar sempre a mais popular', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual é a utilidade de ligar uma mudança a um item do backlog?', 'PB053-11-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Eliminar a necessidade de testes', FALSE),
    (questao_id, 'B', 'Garantir aprovação automática', FALSE),
    (questao_id, 'C', 'Ocultar o objetivo da alteração', FALSE),
    (questao_id, 'D', 'Permitir rastrear a necessidade e a solução', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'O que uma integração contínua pode apoiar?', 'PB053-11-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Executar verificações automáticas das alterações', TRUE),
    (questao_id, 'B', 'Substituir toda revisão de produto', FALSE),
    (questao_id, 'C', 'Decidir sozinha a prioridade comercial', FALSE),
    (questao_id, 'D', 'Dispensar controle de versão', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual dado deve ficar fora de arquivos públicos do projeto?', 'PB053-11-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Nome de uma funcionalidade', FALSE),
    (questao_id, 'B', 'Chave secreta do servidor', TRUE),
    (questao_id, 'C', 'Instrução de instalação', FALSE),
    (questao_id, 'D', 'Critério de aceite público', FALSE);
  END IF;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Boas Práticas em Projetos Ágeis', 'Boas práticas tornam o trabalho compreensível, verificável e sustentável. Entregas pequenas, revisão por outra pessoa, testes apropriados e documentação de uso reduzem retrabalho. Uma definição compartilhada de pronto evita considerar uma parte isolada como uma experiência completa.

Para salvar progresso, não basta mudar a cor de um cartão: é preciso validar autenticação, armazenamento, recuperação e isolamento entre pessoas. Também é necessário verificar leitura e navegação em telas pequenas. Falhas devem orientar a correção, sem esconder o que ainda falta.

Para praticar: escolha um fluxo e teste o caminho de sucesso, uma falha de rede e um acesso indevido. Registre o resultado e peça uma revisão. Use o aprendizado para melhorar o próximo trabalho.', 'https://www.agilealliance.org/glossary/definition-of-done/', 'PB056-12', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Para que serve uma definição compartilhada de pronto?', 'PB053-12-1', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Aprovar qualquer tarefa iniciada', FALSE),
    (questao_id, 'B', 'Eliminar a revisão', FALSE),
    (questao_id, 'C', 'Impedir novas necessidades', FALSE),
    (questao_id, 'D', 'Alinhar as condições de qualidade de uma entrega', TRUE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Qual validação é necessária ao salvar progresso de estudo?', 'PB053-12-2', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Recuperar o estado e impedir acesso entre candidatos', TRUE),
    (questao_id, 'B', 'Apenas mudar a cor local do cartão', FALSE),
    (questao_id, 'C', 'Somente contar cliques', FALSE),
    (questao_id, 'D', 'Testar apenas sem autenticação', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Qual é um benefício da revisão por outra pessoa?', 'PB053-12-3', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Eliminar a responsabilidade da equipe', FALSE),
    (questao_id, 'B', 'Encontrar problemas e compartilhar conhecimento', TRUE),
    (questao_id, 'C', 'Garantir que nunca haverá erros', FALSE),
    (questao_id, 'D', 'Substituir a execução do sistema', FALSE);
  END IF;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Como tratar uma falha encontrada na validação?', 'PB053-12-4', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Marcar como pronto sem verificar', FALSE),
    (questao_id, 'B', 'Excluir o cenário do teste', FALSE),
    (questao_id, 'C', 'Registrar o problema e corrigir com evidência', TRUE),
    (questao_id, 'D', 'Ocultar a falha para fechar o item', FALSE);
  END IF;
END $seed$;

COMMIT;
