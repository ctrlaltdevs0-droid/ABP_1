BEGIN;

INSERT INTO temas (nome, descricao, ordem, ativo)
VALUES
(
    'Fundamentos da Agilidade',
    'Introdução aos princípios, valores e conceitos fundamentais da agilidade no desenvolvimento de projetos.',
    1,
    TRUE
),
(
    'Introdução ao Scrum',
    'Apresentação do Scrum, seu funcionamento e sua aplicação no desenvolvimento de produtos e projetos.',
    2,
    TRUE
),
(
    'Papéis do Scrum',
    'Conheça as responsabilidades e características dos principais papéis envolvidos no Scrum.',
    3,
    TRUE
),
(
    'Eventos do Scrum',
    'Conheça os principais eventos do Scrum e como eles ajudam na organização e acompanhamento do trabalho.',
    4,
    TRUE
),
(
    'Artefatos do Scrum',
    'Introdução aos artefatos do Scrum e às informações utilizadas para dar transparência ao trabalho.',
    5,
    TRUE
),
(
    'User Stories',
    'Aprenda o conceito de User Stories e como utilizá-las para representar necessidades e funcionalidades do usuário.',
    6,
    TRUE
),
(
    'Gestão do Product Backlog',
    'Aprenda como organizar, priorizar e acompanhar os itens que compõem o Product Backlog.',
    7,
    TRUE
),
(
    'Kanban',
    'Introdução ao Kanban, seus princípios e sua utilização para visualizar e gerenciar o fluxo de trabalho.',
    8,
    TRUE
),
(
    'Planejamento Ágil',
    'Conheça práticas e técnicas utilizadas para planejar atividades e entregas de forma adaptativa e colaborativa.',
    9,
    TRUE
),
(
    'Métricas Ágeis',
    'Introdução às principais métricas utilizadas para acompanhar o desempenho, o fluxo e a evolução de equipes ágeis.',
    10,
    TRUE
),
(
    'Ferramentas para Equipes Ágeis',
    'Conheça ferramentas que auxiliam equipes ágeis na organização, comunicação, acompanhamento de tarefas e colaboração.',
    11,
    TRUE
),
(
    'Boas Práticas em Projetos Ágeis',
    'Conheça boas práticas que contribuem para a organização, colaboração, qualidade e melhoria contínua em projetos ágeis.',
    12,
    TRUE
)
ON CONFLICT (nome) DO UPDATE
SET descricao = EXCLUDED.descricao, ordem = EXCLUDED.ordem;

COMMIT;   

-- Carga de estudos gerada a partir de scripts/data/content-estudos.json.

BEGIN;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Fundamentos da Agilidade', 'Agilidade é aprender com entregas frequentes e adaptar o trabalho conforme as necessidades das pessoas. Um plano orienta decisões, mas deve ser revisto quando surgem evidências.

Uma equipe pode entregar primeiro uma inscrição simples, observar dificuldades reais e então melhorar o formulário. Essa sequência reduz o risco de construir funcionalidades sem utilidade. Documentar decisões e conversar com usuários ajuda a manter o aprendizado acessível.

Para praticar: escolha uma necessidade pequena, descreva o resultado esperado, entregue uma primeira solução e combine como obter feedback. Não confunda trabalhar de forma ágil com trabalhar sem qualidade ou sem planejamento.', 'https://agilemanifesto.org/iso/ptbr/manifesto.html', 'PB056-1', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-1-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade')
      AND enunciado = 'Qual situação esteve associada à chamada Crise do Software?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Qual situação esteve associada à chamada Crise do Software?', '/assets/img/questoes/PB053-1-1.png', 'Ilustração: Crise de Software', 'PB053-1-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Os computadores deixaram de utilizar softwares.', FALSE),
    (questao_id, 'B', 'Projetos apresentavam atrasos, custos elevados e dificuldades para atender às necessidades dos usuários.', TRUE),
    (questao_id, 'C', 'Todos os softwares começaram a ser desenvolvidos utilizando métodos ágeis.', FALSE),
    (questao_id, 'D', 'Os sistemas se tornaram simples demais.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-1-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade')
      AND enunciado = 'Qual é uma característica comum do Modelo Cascata?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Qual é uma característica comum do Modelo Cascata?', '/assets/img/questoes/PB053-1-2.png', 'Ilustração: Gráficos representativos', 'PB053-1-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'O desenvolvimento ocorre em ciclos curtos e contínuos.', FALSE),
    (questao_id, 'B', 'Não existe planejamento.', FALSE),
    (questao_id, 'C', 'O projeto segue etapas sequenciais previamente definidas.', TRUE),
    (questao_id, 'D', 'O produto precisa ser entregue diariamente.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-1-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade')
      AND enunciado = 'O que significa ser ágil no desenvolvimento de software?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'O que significa ser ágil no desenvolvimento de software?', '/assets/img/questoes/PB053-1-3.png', 'Ilustração: Trabalho em Equipe', 'PB053-1-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Desenvolver o máximo de funcionalidades possível, independentemente da necessidade do usuário.', FALSE),
    (questao_id, 'B', 'Trabalhar sem planejamento para entregar mais rápido.', FALSE),
    (questao_id, 'C', 'Evitar qualquer mudança depois que o projeto começar.', FALSE),
    (questao_id, 'D', 'Trabalhar de maneira adaptável, colaborativa e com entregas e feedbacks frequentes.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-1-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade')
      AND enunciado = 'Qual dos seguintes é um benefício das abordagens ágeis?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Qual dos seguintes é um benefício das abordagens ágeis?', '/assets/img/questoes/PB053-1-4.png', 'Ilustração: Fatores de Sucesso', 'PB053-1-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Identificar problemas e mudanças mais cedo por meio de entregas e feedbacks frequentes.', TRUE),
    (questao_id, 'B', 'Eliminar completamente os testes de software.', FALSE),
    (questao_id, 'C', 'Garantir que os requisitos nunca sejam alterados.', FALSE),
    (questao_id, 'D', 'Desenvolver todo o sistema antes de receber qualquer feedback.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Introdução ao Scrum', 'Scrum oferece uma estrutura para equipes enfrentarem problemas complexos. O trabalho avança em ciclos chamados Sprints, nos quais a equipe busca um objetivo e inspeciona os resultados. O uso de Scrum não garante sucesso: decisões continuam dependendo do contexto e das evidências.

Em um portal de estudos, uma Sprint pode buscar permitir a leitura de um tema completo. A equipe acompanha o trabalho, demonstra o resultado e decide o próximo passo com base no que aprendeu.

Para praticar: descreva um objetivo verificável e identifique qual pequena entrega permitiria avaliar seu avanço. Evite tratar a Sprint como uma lista de tarefas sem propósito compartilhado.', 'https://scrumguides.org/scrum-guide.html', 'PB056-2', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-2-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum')
      AND enunciado = 'Por que o Scrum é considerado um framework?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Por que o Scrum é considerado um framework?', '/assets/img/questoes/PB053-2-1.png', 'Ilustração: Frameworks', 'PB053-2-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Porque determina exatamente como cada tarefa deve ser executada.', FALSE),
    (questao_id, 'B', 'Porque fornece uma estrutura de trabalho, permitindo que as equipes utilizem práticas adequadas à sua realidade.', TRUE),
    (questao_id, 'C', 'Porque é uma linguagem utilizada para desenvolver sistemas.', FALSE),
    (questao_id, 'D', 'Porque elimina a necessidade de planejamento.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-2-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum')
      AND enunciado = 'O que significa empirismo no contexto do Scrum?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'O que significa empirismo no contexto do Scrum?', '/assets/img/questoes/PB053-2-2.png', 'Ilustração: Planejamento', 'PB053-2-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Tomar decisões somente com base no planejamento inicial.', FALSE),
    (questao_id, 'B', 'Evitar mudanças durante o desenvolvimento.', FALSE),
    (questao_id, 'C', 'Adquirir conhecimento por meio da experiência e tomar decisões com base no que é observado.', TRUE),
    (questao_id, 'D', 'Desenvolver todo o produto antes de analisar os resultados.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-2-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum')
      AND enunciado = 'Quais são os três pilares do empirismo no Scrum?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Quais são os três pilares do empirismo no Scrum?', '/assets/img/questoes/PB053-2-3.png', 'Ilustração: Pilares de planejamento', 'PB053-2-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Planejamento, desenvolvimento e entrega.', FALSE),
    (questao_id, 'B', 'Velocidade, produtividade e qualidade.', FALSE),
    (questao_id, 'C', 'Comunicação, documentação e planejamento.', FALSE),
    (questao_id, 'D', 'Transparência, inspeção e adaptação.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-2-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum')
      AND enunciado = 'Uma equipe percebeu, durante a inspeção, que uma funcionalidade não está funcionando como esperado e decidiu modificar a solução. Qual pilar está sendo aplicado ao realizar essa mudança?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Uma equipe percebeu, durante a inspeção, que uma funcionalidade não está funcionando como esperado e decidiu modificar a solução. Qual pilar está sendo aplicado ao realizar essa mudança?', '/assets/img/questoes/PB053-2-4.png', 'Ilustração: Mudança', 'PB053-2-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Adaptação.', TRUE),
    (questao_id, 'B', 'Transparência.', FALSE),
    (questao_id, 'C', 'Planejamento.', FALSE),
    (questao_id, 'D', 'Documentação.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Papéis do Scrum', 'No Scrum Team, Product Owner, Scrum Master e Developers assumem responsabilidades complementares. O Product Owner orienta o valor do produto; o Scrum Master ajuda a equipe a usar Scrum; os Developers constroem a entrega.

No portal, o Product Owner pode esclarecer a necessidade de retomar os estudos, enquanto os Developers decidem como implementar a solução. O Scrum Master ajuda a tornar impedimentos visíveis e promove melhorias na colaboração. Nenhuma dessas responsabilidades substitui o diálogo entre todos.

Para praticar: diante de uma dúvida de prioridade, converse sobre valor. Diante de uma decisão técnica, envolva quem construirá e manterá a solução. Evite concentrar toda decisão em uma única pessoa.', 'https://scrumguides.org/scrum-guide.html', 'PB056-3', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-3-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum')
      AND enunciado = 'Qual é a principal responsabilidade do Product Owner?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Qual é a principal responsabilidade do Product Owner?', '/assets/img/questoes/PB053-3-1.png', 'Ilustração: Product Owner', 'PB053-3-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Desenvolver sozinho todas as funcionalidades do sistema.', FALSE),
    (questao_id, 'B', 'Maximizar o valor do produto e gerenciar o Product Backlog.', TRUE),
    (questao_id, 'C', 'Controlar os horários de todos os colaboradores.', FALSE),
    (questao_id, 'D', 'Realizar exclusivamente os testes do software.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-3-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum')
      AND enunciado = 'Qual é uma das responsabilidades do Scrum Master?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Qual é uma das responsabilidades do Scrum Master?', '/assets/img/questoes/PB053-3-2.png', 'Ilustração: Suporte', 'PB053-3-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Definir sozinho todas as funcionalidades do produto.', FALSE),
    (questao_id, 'B', 'Substituir os Developers durante a programação.', FALSE),
    (questao_id, 'C', 'Ajudar a equipe a aplicar o Scrum e superar impedimentos.', TRUE),
    (questao_id, 'D', 'Aprovar obrigatoriamente todas as linhas de código.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-3-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum')
      AND enunciado = 'Quem é responsável por criar o Sprint Backlog e organizar o trabalho necessário para a Sprint?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Quem é responsável por criar o Sprint Backlog e organizar o trabalho necessário para a Sprint?', '/assets/img/questoes/PB053-3-3.png', 'Ilustração: Developers', 'PB053-3-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Os Developers.', TRUE),
    (questao_id, 'B', 'Apenas o Product Owner.', FALSE),
    (questao_id, 'C', 'Os clientes.', FALSE),
    (questao_id, 'D', 'Apenas o Scrum Master.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-3-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum')
      AND enunciado = 'Como deve funcionar a interação entre os integrantes do Scrum Team?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Como deve funcionar a interação entre os integrantes do Scrum Team?', '/assets/img/questoes/PB053-3-4.png', 'Ilustração: Team', 'PB053-3-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Cada integrante trabalha isoladamente.', FALSE),
    (questao_id, 'B', 'O Scrum Master toma todas as decisões técnicas.', FALSE),
    (questao_id, 'C', 'O Product Owner desenvolve todas as funcionalidades.', FALSE),
    (questao_id, 'D', 'Todos colaboram, respeitando suas responsabilidades e buscando o mesmo objetivo.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Eventos do Scrum', 'Os eventos criam momentos para alinhar intenções, acompanhar o trabalho e aprender. O planejamento inicia a Sprint; a Daily ajuda a ajustar o plano diário; a Review examina o resultado; a Retrospectiva procura melhorias na forma de trabalhar.

Uma Review pode revelar que estudantes não encontram o botão de continuar. Uma Retrospectiva pode identificar que faltou testar a navegação no celular. O primeiro aprendizado trata do produto; o segundo trata do processo da equipe.

Para praticar: termine cada conversa com uma decisão útil ou um próximo passo claro. Reuniões sem propósito não substituem colaboração durante o trabalho.', 'https://scrumguides.org/scrum-guide.html', 'PB056-4', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-4-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum')
      AND enunciado = 'Qual é a duração máxima de uma Sprint?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual é a duração máxima de uma Sprint?', '/assets/img/questoes/PB053-4-1.png', 'Ilustração: Calendário de Eventos', 'PB053-4-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Uma semana.', FALSE),
    (questao_id, 'B', 'Três meses.', FALSE),
    (questao_id, 'C', 'Um mês.', TRUE),
    (questao_id, 'D', 'Um ano.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-4-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum')
      AND enunciado = 'Qual é o principal objetivo do Sprint Planning?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual é o principal objetivo do Sprint Planning?', '/assets/img/questoes/PB053-4-2.png', 'Ilustração: Lista de Tarefas', 'PB053-4-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Planejar o trabalho que será realizado durante a Sprint.', TRUE),
    (questao_id, 'B', 'Avaliar exclusivamente o desempenho individual dos colaboradores.', FALSE),
    (questao_id, 'C', 'Apresentar o produto final ao cliente.', FALSE),
    (questao_id, 'D', 'Encerrar o projeto.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-4-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum')
      AND enunciado = 'Para que serve a Daily Scrum?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Para que serve a Daily Scrum?', '/assets/img/questoes/PB053-4-3.png', 'Ilustração: Reunião remota', 'PB053-4-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Aprovar todas as funcionalidades do sistema.', FALSE),
    (questao_id, 'B', 'Substituir o Sprint Planning.', FALSE),
    (questao_id, 'C', 'Definir o orçamento anual do projeto.', FALSE),
    (questao_id, 'D', 'Inspecionar o progresso em direção ao Sprint Goal e adaptar o planejamento.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-4-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum')
      AND enunciado = 'Qual é a diferença entre Sprint Review e Sprint Retrospective?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Qual é a diferença entre Sprint Review e Sprint Retrospective?', '/assets/img/questoes/PB053-4-4.png', 'Ilustração: Revisão de projeto', 'PB053-4-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Ambas possuem exatamente a mesma finalidade.', FALSE),
    (questao_id, 'B', 'A Review analisa o resultado do produto, enquanto a Retrospective busca melhorar a forma de trabalhar.', TRUE),
    (questao_id, 'C', 'A Review é realizada diariamente e a Retrospective ocorre antes do planejamento.', FALSE),
    (questao_id, 'D', 'A Retrospective serve exclusivamente para apresentar funcionalidades aos clientes.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Artefatos do Scrum', 'Artefatos tornam o trabalho e o resultado observáveis. O Product Backlog reúne necessidades do produto; o Sprint Backlog mostra o plano da Sprint; o Incremento representa uma entrega que atende ao padrão de qualidade combinado.

No portal, uma necessidade de salvar progresso pode entrar no Product Backlog. Quando selecionada, é detalhada no plano da Sprint. Só existe uma entrega utilizável quando interface, API e armazenamento funcionam juntos.

Para praticar: mostre claramente o que ainda é intenção, o que está em execução e o que está utilizável. Marcar uma tarefa como concluída sem validar a experiência inteira cria uma impressão enganosa de avanço.', 'https://scrumguides.org/scrum-guide.html', 'PB056-5', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-5-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum')
      AND enunciado = 'Qual é a finalidade do Product Backlog?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Qual é a finalidade do Product Backlog?', '/assets/img/questoes/PB053-5-1.png', 'Ilustração: Backlog', 'PB053-5-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Registrar exclusivamente as tarefas já concluídas.', FALSE),
    (questao_id, 'B', 'Substituir todas as reuniões da equipe.', FALSE),
    (questao_id, 'C', 'Organizar uma lista ordenada das necessidades de melhoria do produto.', TRUE),
    (questao_id, 'D', 'Armazenar somente os erros encontrados no sistema.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-5-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum')
      AND enunciado = 'O que compõe o Sprint Backlog?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'O que compõe o Sprint Backlog?', '/assets/img/questoes/PB053-5-2.png', 'Ilustração: Lista de tarefas', 'PB053-5-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Sprint Goal, itens selecionados do Product Backlog e plano de trabalho.', TRUE),
    (questao_id, 'B', 'Apenas o nome dos Developers.', FALSE),
    (questao_id, 'C', 'Somente o orçamento do projeto.', FALSE),
    (questao_id, 'D', 'Exclusivamente os resultados das Sprints anteriores.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-5-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum')
      AND enunciado = 'O que representa o Incremento no Scrum?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'O que representa o Incremento no Scrum?', '/assets/img/questoes/PB053-5-3.png', 'Ilustração: Progresso', 'PB053-5-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Uma lista de ideias que ainda não foram analisadas.', FALSE),
    (questao_id, 'B', 'Uma reunião realizada antes do desenvolvimento.', FALSE),
    (questao_id, 'C', 'Um documento de planejamento financeiro.', FALSE),
    (questao_id, 'D', 'Um resultado utilizável do produto que atende à Definition of Done.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-5-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum')
      AND enunciado = 'Qual é a finalidade da Definition of Done?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Qual é a finalidade da Definition of Done?', '/assets/img/questoes/PB053-5-4.png', 'Ilustração: Lista de tarefas', 'PB053-5-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Determinar quem será o Product Owner.', FALSE),
    (questao_id, 'B', 'Estabelecer um entendimento comum sobre os critérios de qualidade para considerar um Incremento concluído.', TRUE),
    (questao_id, 'C', 'Definir a duração de todas as Sprints.', FALSE),
    (questao_id, 'D', 'Organizar exclusivamente as prioridades do Product Backlog.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'User Stories', 'Uma User Story descreve uma necessidade pela perspectiva de quem usa o produto. Uma forma comum é indicar pessoa, ação e benefício. O texto inicia uma conversa; critérios de aceite tornam o resultado verificável. Essa técnica pode apoiar equipes ágeis, mas não é uma obrigação do Scrum.

Exemplo: como estudante, quero marcar um tema como concluído para retomar meu percurso. Um critério de aceite é entrar novamente e ainda visualizar a conclusão. Outro é impedir que a conclusão de uma pessoa apareça para outra.

Para praticar: escreva uma história pequena e acrescente exemplos de sucesso e falha. Evite transformar cada detalhe técnico em uma história sem benefício identificável.', 'https://www.agilealliance.org/glossary/user-stories/', 'PB056-6', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-6-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'User Stories')
      AND enunciado = 'Qual é a principal finalidade de uma User Story?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual é a principal finalidade de uma User Story?', '/assets/img/questoes/PB053-6-1.png', 'Ilustração: Usuário', 'PB053-6-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Descrever uma necessidade sob a perspectiva do usuário.', TRUE),
    (questao_id, 'B', 'Substituir todos os testes do sistema.', FALSE),
    (questao_id, 'C', 'Registrar exclusivamente o código-fonte.', FALSE),
    (questao_id, 'D', 'Definir o salário dos integrantes da equipe.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-6-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'User Stories')
      AND enunciado = 'Qual alternativa apresenta a estrutura mais utilizada de uma User Story?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual alternativa apresenta a estrutura mais utilizada de uma User Story?', '/assets/img/questoes/PB053-6-2.png', 'Ilustração: Estruturando notas e ideias', 'PB053-6-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Quando... Onde... Quanto...', FALSE),
    (questao_id, 'B', 'Problema... Código... Entrega...', FALSE),
    (questao_id, 'C', 'Como... Quero... Para...', TRUE),
    (questao_id, 'D', 'Início... Meio... Fim...', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-6-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'User Stories')
      AND enunciado = 'Para que servem os critérios de aceitação?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Para que servem os critérios de aceitação?', '/assets/img/questoes/PB053-6-3.png', 'Ilustração: Critérios de aceitação', 'PB053-6-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Determinar a duração obrigatória de uma Sprint.', FALSE),
    (questao_id, 'B', 'Definir condições que permitem verificar se a história atende ao comportamento esperado.', TRUE),
    (questao_id, 'C', 'Substituir o Product Owner.', FALSE),
    (questao_id, 'D', 'Escolher a linguagem de programação.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-6-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'User Stories')
      AND enunciado = 'Qual alternativa apresenta uma User Story bem estruturada?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'Qual alternativa apresenta uma User Story bem estruturada?', '/assets/img/questoes/PB053-6-4.png', 'Ilustração: User experience', 'PB053-6-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Criar tabela no banco de dados.', FALSE),
    (questao_id, 'B', 'Corrigir arquivos do sistema.', FALSE),
    (questao_id, 'C', 'Desenvolver três botões azuis.', FALSE),
    (questao_id, 'D', 'Como cliente, quero acompanhar meus pedidos, para saber quando serão entregues.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Gestão do Product Backlog', 'Gerir o Product Backlog é manter necessidades compreensíveis e ordenadas para apoiar decisões. Valor, risco, dependências e aprendizado podem orientar essa ordem. Refinar é esclarecer e dividir itens conforme necessário; não significa congelar todo o escopo.

Antes de oferecer uma prova aleatória, o portal precisa de temas e questões válidas. Essa dependência pode justificar priorizar a base de dados. Já um detalhe visual pode esperar se não comprometer o uso da primeira entrega.

Para praticar: escolha três necessidades e explique a ordem com critérios explícitos. Reavalie quando surgir uma dependência ou uma evidência nova. Não confunda prioridade com pressão de quem fala mais alto.', 'https://scrumguides.org/scrum-guide.html', 'PB056-7', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-7-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog')
      AND enunciado = 'Quem é responsável pela gestão do Product Backlog no Scrum?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Quem é responsável pela gestão do Product Backlog no Scrum?', '/assets/img/questoes/PB053-7-1.png', 'Ilustração: Gestão do backlog', 'PB053-7-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Exclusivamente os clientes.', FALSE),
    (questao_id, 'B', 'O Scrum Master.', FALSE),
    (questao_id, 'C', 'Apenas os Developers.', FALSE),
    (questao_id, 'D', 'O Product Owner.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-7-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog')
      AND enunciado = 'O que significa priorizar os itens do Product Backlog?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'O que significa priorizar os itens do Product Backlog?', '/assets/img/questoes/PB053-7-2.png', 'Ilustração: Prioridades', 'PB053-7-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Desenvolver todos os itens simultaneamente.', FALSE),
    (questao_id, 'B', 'Avaliar a importância dos itens e definir sua ordem.', TRUE),
    (questao_id, 'C', 'Remover todas as funcionalidades complexas.', FALSE),
    (questao_id, 'D', 'Organizar as atividades somente por ordem alfabética.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-7-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog')
      AND enunciado = 'Qual é a finalidade do refinamento do Product Backlog?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Qual é a finalidade do refinamento do Product Backlog?', '/assets/img/questoes/PB053-7-3.png', 'Ilustração: Review', 'PB053-7-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Detalhar e melhorar a compreensão dos itens para facilitar o trabalho futuro.', TRUE),
    (questao_id, 'B', 'Encerrar automaticamente a Sprint.', FALSE),
    (questao_id, 'C', 'Substituir os testes do sistema.', FALSE),
    (questao_id, 'D', 'Impedir que novas necessidades sejam adicionadas.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-7-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog')
      AND enunciado = 'Por que o Product Backlog deve evoluir durante o projeto?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Por que o Product Backlog deve evoluir durante o projeto?', '/assets/img/questoes/PB053-7-4.png', 'Ilustração: Crescimento', 'PB053-7-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Porque todos os itens precisam ser alterados diariamente.', FALSE),
    (questao_id, 'B', 'Porque o planejamento inicial deve ser ignorado.', FALSE),
    (questao_id, 'C', 'Porque novas necessidades e informações podem surgir ao longo do desenvolvimento.', TRUE),
    (questao_id, 'D', 'Porque não é permitido concluir os itens existentes.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Kanban', 'Kanban ajuda a observar e melhorar o fluxo do trabalho. Um quadro torna visíveis as etapas, enquanto políticas explícitas esclarecem como os itens avançam. Controlar o trabalho iniciado favorece a conclusão antes de assumir novas demandas.

Exemplo de quadro: A fazer → Em execução → Em validação → Concluído. Se muitos itens aguardam validação, iniciar mais trabalho pode aumentar a fila. A equipe deve investigar o bloqueio e ajudar a concluir o que já começou.

Para praticar: desenhe o fluxo real da sua equipe, identifique onde os itens se acumulam e combine uma política para limitar novas entradas. O quadro deve refletir a realidade, inclusive bloqueios.', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-8', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-8-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Kanban')
      AND enunciado = 'Qual é a principal finalidade de um quadro Kanban?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Qual é a principal finalidade de um quadro Kanban?', '/assets/img/questoes/PB053-8-1.png', 'Ilustração: Quadro Kanban', 'PB053-8-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Substituir todas as ferramentas de programação.', FALSE),
    (questao_id, 'B', 'Visualizar as atividades e seu andamento no fluxo de trabalho.', TRUE),
    (questao_id, 'C', 'Definir os salários da equipe.', FALSE),
    (questao_id, 'D', 'Registrar somente as tarefas concluídas.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-8-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Kanban')
      AND enunciado = 'O que significa WIP?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'O que significa WIP?', '/assets/img/questoes/PB053-8-2.png', 'Ilustração: Produtividade', 'PB053-8-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Work in Progress, ou trabalho em andamento.', TRUE),
    (questao_id, 'B', 'Work in Planning, ou trabalho em planejamento.', FALSE),
    (questao_id, 'C', 'Weekly Information Process.', FALSE),
    (questao_id, 'D', 'Workflow Internal Program.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-8-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Kanban')
      AND enunciado = 'O que pode indicar um gargalo em um quadro Kanban?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'O que pode indicar um gargalo em um quadro Kanban?', '/assets/img/questoes/PB053-8-3.png', 'Ilustração: Gargalo, problema, obstáculo', 'PB053-8-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Todas as atividades estão concluídas.', FALSE),
    (questao_id, 'B', 'A equipe possui poucas solicitações.', FALSE),
    (questao_id, 'C', 'Os cards mudam normalmente entre as etapas.', FALSE),
    (questao_id, 'D', 'Muitas atividades ficam acumuladas em uma determinada etapa.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-8-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Kanban')
      AND enunciado = 'Qual prática ajuda a melhorar o fluxo de trabalho no Kanban?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Qual prática ajuda a melhorar o fluxo de trabalho no Kanban?', '/assets/img/questoes/PB053-8-4.png', 'Ilustração: Fluxo de trabalho', 'PB053-8-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Iniciar o máximo possível de atividades ao mesmo tempo.', FALSE),
    (questao_id, 'B', 'Ignorar tarefas que estão bloqueadas.', FALSE),
    (questao_id, 'C', 'Limitar o trabalho em andamento e analisar os gargalos.', TRUE),
    (questao_id, 'D', 'Evitar acompanhar o tempo de execução.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Planejamento Ágil', 'Planejar de forma ágil é escolher um resultado, considerar a capacidade disponível e ajustar o caminho com o aprendizado. Estimativas apoiam a conversa sobre incerteza; não são garantias. Itens menores facilitam observar resultados e corrigir decisões.

No portal, entregar primeiro a leitura e conclusão de um tema permite verificar o fluxo antes de expandir o conteúdo. Dependências de banco, autenticação e revisão devem aparecer no plano. Transportar pendências de uma Sprint não significa que toda a estimativa original ainda está por fazer.

Para praticar: identifique o esforço restante de uma pendência e uma entrega pequena que possa ser demonstrada. Registre premissas e revise o plano quando elas deixarem de valer.', 'https://www.agilealliance.org/glossary/iteration-planning/', 'PB056-9', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-9-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil')
      AND enunciado = 'Qual é uma característica do planejamento ágil?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Qual é uma característica do planejamento ágil?', '/assets/img/questoes/PB053-9-1.png', 'Ilustração: Planejamento', 'PB053-9-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Definir todo o projeto sem permitir alterações.', FALSE),
    (questao_id, 'B', 'Eliminar a necessidade de estimativas.', FALSE),
    (questao_id, 'C', 'Planejar continuamente e adaptar decisões conforme novas informações.', TRUE),
    (questao_id, 'D', 'Realizar planejamento somente após concluir o produto.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-9-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil')
      AND enunciado = 'O que os Story Points representam?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'O que os Story Points representam?', '/assets/img/questoes/PB053-9-2.png', 'Ilustração: Story points', 'PB053-9-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Uma estimativa relativa de esforço, complexidade e incerteza.', TRUE),
    (questao_id, 'B', 'A quantidade exata de horas de uma atividade.', FALSE),
    (questao_id, 'C', 'O número de colaboradores da equipe.', FALSE),
    (questao_id, 'D', 'O valor financeiro de uma funcionalidade.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-9-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil')
      AND enunciado = 'Qual é a finalidade do Planning Poker?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Qual é a finalidade do Planning Poker?', '/assets/img/questoes/PB053-9-3.png', 'Ilustração: Cards', 'PB053-9-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Escolher o Product Owner.', FALSE),
    (questao_id, 'B', 'Definir os salários da equipe.', FALSE),
    (questao_id, 'C', 'Substituir todos os testes do sistema.', FALSE),
    (questao_id, 'D', 'Estimar atividades de forma colaborativa, discutindo diferentes percepções.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-9-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil')
      AND enunciado = 'O que é considerado no planejamento de Releases?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'O que é considerado no planejamento de Releases?', '/assets/img/questoes/PB053-9-4.png', 'Ilustração: Planejamento', 'PB053-9-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Apenas a quantidade de reuniões realizadas.', FALSE),
    (questao_id, 'B', 'Quais funcionalidades poderão ser disponibilizadas em determinadas versões ou períodos.', TRUE),
    (questao_id, 'C', 'Somente os erros encontrados no código.', FALSE),
    (questao_id, 'D', 'Exclusivamente a distribuição de tarefas diárias.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Métricas Ágeis', 'Métricas ajudam a formular perguntas sobre o trabalho. Tempo de ciclo acompanha quanto um item leva entre início e término. Vazão conta itens concluídos em um intervalo. Trabalho em progresso mostra itens iniciados ainda não finalizados.

Se a fila de validação cresce e o tempo de ciclo aumenta, a equipe pode investigar falta de capacidade nessa etapa. Uma métrica isolada não explica a causa e não deve ser usada para ranquear pessoas. Comparações exigem definições consistentes.

Para praticar: registre início e término de alguns itens, calcule sua duração e procure variações. Em um burndown, mantenha o histórico diário e registre mudanças de escopo; o estado atual dos cartões não reconstrói os dias anteriores.', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-10', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-10-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis')
      AND enunciado = 'O que a Velocity normalmente representa?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'O que a Velocity normalmente representa?', '/assets/img/questoes/PB053-10-1.png', 'Ilustração: Velocidade', 'PB053-10-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'O tempo necessário para abrir o sistema.', FALSE),
    (questao_id, 'B', 'A quantidade de trabalho concluído por uma equipe em uma Sprint.', TRUE),
    (questao_id, 'C', 'A quantidade de colaboradores contratados.', FALSE),
    (questao_id, 'D', 'O número de reuniões realizadas no projeto.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-10-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis')
      AND enunciado = 'Qual gráfico mostra a quantidade de trabalho restante ao longo do tempo?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Qual gráfico mostra a quantidade de trabalho restante ao longo do tempo?', '/assets/img/questoes/PB053-10-2.png', 'Ilustração: Chart', 'PB053-10-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Burnup Chart.', FALSE),
    (questao_id, 'B', 'Gráfico de organograma.', FALSE),
    (questao_id, 'C', 'Gráfico financeiro.', FALSE),
    (questao_id, 'D', 'Burndown Chart.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-10-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis')
      AND enunciado = 'Qual é uma diferença importante entre Lead Time e Cycle Time?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Qual é uma diferença importante entre Lead Time e Cycle Time?', '/assets/img/questoes/PB053-10-3.png', 'Ilustração: Lead time', 'PB053-10-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Lead Time pode incluir o período de espera antes do início do trabalho, enquanto Cycle Time mede a partir do início efetivo.', TRUE),
    (questao_id, 'B', 'Ambos representam obrigatoriamente a mesma duração.', FALSE),
    (questao_id, 'C', 'Cycle Time mede somente o tempo de reuniões.', FALSE),
    (questao_id, 'D', 'Lead Time representa a quantidade de Story Points.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-10-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis')
      AND enunciado = 'Qual é a forma mais adequada de utilizar métricas ágeis?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Qual é a forma mais adequada de utilizar métricas ágeis?', '/assets/img/questoes/PB053-10-4.png', 'Ilustração: Dashboard', 'PB053-10-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Comparar individualmente os funcionários sem considerar o contexto.', FALSE),
    (questao_id, 'B', 'Aumentar os números independentemente da qualidade.', FALSE),
    (questao_id, 'C', 'Analisar tendências e dificuldades para apoiar decisões e melhorias.', TRUE),
    (questao_id, 'D', 'Substituir completamente a comunicação entre os integrantes.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Ferramentas para Equipes Ágeis', 'Ferramentas apoiam organização, comunicação e rastreabilidade. Um quadro digital organiza itens; um repositório registra alterações; uma integração contínua executa verificações. Escolha a ferramenta pelo problema que ela ajuda a resolver, e não apenas por popularidade.

No portal, um item do backlog pode referenciar uma alteração no repositório e seus testes. Isso permite entender por que a mudança existe e como foi verificada. Informações sensíveis, como senhas e chaves do servidor, não devem ser publicadas em cartões ou arquivos versionados.

Para praticar: conecte uma necessidade a uma alteração pequena e registre a evidência de validação. Mantenha instruções para que outra pessoa consiga executar o projeto.', 'https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects', 'PB056-11', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-11-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis')
      AND enunciado = 'Qual é a finalidade principal do GitHub Issues?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual é a finalidade principal do GitHub Issues?', '/assets/img/questoes/PB053-11-1.png', 'Ilustração: Problemas', 'PB053-11-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Criar exclusivamente apresentações.', FALSE),
    (questao_id, 'B', 'Substituir todas as linguagens de programação.', FALSE),
    (questao_id, 'C', 'Registrar e acompanhar tarefas, bugs e solicitações.', TRUE),
    (questao_id, 'D', 'Realizar somente reuniões virtuais.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-11-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis')
      AND enunciado = 'Qual ferramenta é conhecida pela organização visual utilizando quadros, listas e cartões?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual ferramenta é conhecida pela organização visual utilizando quadros, listas e cartões?', '/assets/img/questoes/PB053-11-2.png', 'Ilustração: Quadro', 'PB053-11-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Trello.', TRUE),
    (questao_id, 'B', 'Compilador Java.', FALSE),
    (questao_id, 'C', 'Editor de imagens.', FALSE),
    (questao_id, 'D', 'Sistema operacional.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-11-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis')
      AND enunciado = 'Qual alternativa apresenta ferramentas que podem apoiar o planejamento e o acompanhamento de equipes ágeis?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual alternativa apresenta ferramentas que podem apoiar o planejamento e o acompanhamento de equipes ágeis?', '/assets/img/questoes/PB053-11-3.png', 'Ilustração: Ferramentas ágeis', 'PB053-11-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Apenas navegadores de internet.', FALSE),
    (questao_id, 'B', 'Somente editores de texto.', FALSE),
    (questao_id, 'C', 'Exclusivamente sistemas de e-mail.', FALSE),
    (questao_id, 'D', 'Jira, Azure Boards e GitHub Projects.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-11-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis')
      AND enunciado = 'Qual é uma boa prática ao utilizar quadros e cards?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Qual é uma boa prática ao utilizar quadros e cards?', '/assets/img/questoes/PB053-11-4.png', 'Ilustração: Progresso', 'PB053-11-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Deixar todas as tarefas permanentemente como "Em andamento".', FALSE),
    (questao_id, 'B', 'Manter as informações atualizadas e representar o andamento real das atividades.', TRUE),
    (questao_id, 'C', 'Evitar registrar dificuldades.', FALSE),
    (questao_id, 'D', 'Criar atividades sem descrições ou informações necessárias.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Boas Práticas em Projetos Ágeis', 'Boas práticas tornam o trabalho compreensível, verificável e sustentável. Entregas pequenas, revisão por outra pessoa, testes apropriados e documentação de uso reduzem retrabalho. Uma definição compartilhada de pronto evita considerar uma parte isolada como uma experiência completa.

Para salvar progresso, não basta mudar a cor de um cartão: é preciso validar autenticação, armazenamento, recuperação e isolamento entre pessoas. Também é necessário verificar leitura e navegação em telas pequenas. Falhas devem orientar a correção, sem esconder o que ainda falta.

Para praticar: escolha um fluxo e teste o caminho de sucesso, uma falha de rede e um acesso indevido. Registre o resultado e peça uma revisão. Use o aprendizado para melhorar o próximo trabalho.', 'https://www.agilealliance.org/glossary/definition-of-done/', 'PB056-12', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-12-1'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis')
      AND enunciado = 'Por que a comunicação é importante em projetos ágeis?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Por que a comunicação é importante em projetos ágeis?', '/assets/img/questoes/PB053-12-1.png', 'Ilustração: Conversa', 'PB053-12-1', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Porque elimina a necessidade de planejamento.', FALSE),
    (questao_id, 'B', 'Porque permite que apenas uma pessoa conheça o andamento do projeto.', FALSE),
    (questao_id, 'C', 'Porque impede qualquer alteração nas atividades.', FALSE),
    (questao_id, 'D', 'Porque ajuda a compartilhar informações, alinhar objetivos e identificar dificuldades.', TRUE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-12-2'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis')
      AND enunciado = 'Qual situação representa a colaboração em uma equipe ágil?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Qual situação representa a colaboração em uma equipe ágil?', '/assets/img/questoes/PB053-12-2.png', 'Ilustração: Colaboração', 'PB053-12-2', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Um integrante identifica um problema e decide ocultá-lo.', FALSE),
    (questao_id, 'B', 'Integrantes compartilham conhecimentos e ajudam a resolver uma dificuldade técnica.', TRUE),
    (questao_id, 'C', 'Cada pessoa trabalha isoladamente, sem compartilhar informações.', FALSE),
    (questao_id, 'D', 'A equipe evita discutir soluções diferentes.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-12-3'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis')
      AND enunciado = 'Qual é a principal finalidade do feedback contínuo?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Qual é a principal finalidade do feedback contínuo?', '/assets/img/questoes/PB053-12-3.png', 'Ilustração: Planejamento', 'PB053-12-3', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Identificar oportunidades de melhoria a partir das informações recebidas.', TRUE),
    (questao_id, 'B', 'Impedir que usuários participem do desenvolvimento.', FALSE),
    (questao_id, 'C', 'Substituir todas as atividades de planejamento.', FALSE),
    (questao_id, 'D', 'Garantir que o produto nunca precise de alterações.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  UPDATE questoes
  SET codigo_seed = 'PB053-12-4'
  WHERE idquestoes = (
    SELECT idquestoes FROM questoes
    WHERE codigo_seed IS NULL
      AND temas_idtemas = (SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis')
      AND enunciado = 'Uma equipe identifica que seu processo está causando atrasos e decide modificar a forma de trabalhar. Quais boas práticas estão sendo aplicadas?'
    ORDER BY idquestoes
    LIMIT 1
  );
  INSERT INTO questoes (temas_idtemas, enunciado, imagem_url, imagem_alt, codigo_seed, status, status_editorial)
  VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Uma equipe identifica que seu processo está causando atrasos e decide modificar a forma de trabalhar. Quais boas práticas estão sendo aplicadas?', '/assets/img/questoes/PB053-12-4.png', 'Ilustração: Melhoria Contínua', 'PB053-12-4', TRUE, 'APROVADO')
  ON CONFLICT (codigo_seed) DO UPDATE SET
    imagem_url = EXCLUDED.imagem_url,
    imagem_alt = EXCLUDED.imagem_alt,
    status = TRUE,
    status_editorial = 'APROVADO'
  RETURNING idquestoes INTO questao_id;
  INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    (questao_id, 'A', 'Falta de planejamento e isolamento.', FALSE),
    (questao_id, 'B', 'Resistência à mudança e ausência de comunicação.', FALSE),
    (questao_id, 'C', 'Melhoria contínua e adaptação.', TRUE),
    (questao_id, 'D', 'Eliminação da colaboração e do feedback.', FALSE)
  ON CONFLICT (questoes_idquestoes, letra) DO NOTHING;
END $seed$;

COMMIT;

DO $validacao$
BEGIN
  IF (SELECT count(*) FROM temas WHERE ativo) <> 12 THEN
    RAISE EXCEPTION 'Esperados exatamente 12 temas ativos';
  END IF;
  IF (SELECT count(*) FROM conteudos WHERE codigo_seed LIKE 'PB056-%') <> 12 THEN
    RAISE EXCEPTION 'Esperados 12 materiais';
  END IF;
  IF (SELECT count(*) FROM questoes WHERE codigo_seed LIKE 'PB053-%') <> 48 THEN
    RAISE EXCEPTION 'Esperadas 48 questões';
  END IF;
  IF (SELECT count(*) FROM questoes
      WHERE codigo_seed LIKE 'PB053-%' AND status AND status_editorial = 'APROVADO') <> 48 THEN
    RAISE EXCEPTION 'As 48 questões devem permanecer ativas e aprovadas';
  END IF;
  IF EXISTS (
    SELECT t.idtemas FROM temas t LEFT JOIN questoes q
      ON q.temas_idtemas = t.idtemas AND q.codigo_seed LIKE 'PB053-%'
    WHERE t.ativo GROUP BY t.idtemas HAVING count(q.idquestoes) <> 4
  ) THEN RAISE EXCEPTION 'Cada tema deve ter quatro questões da carga'; END IF;
  IF EXISTS (
    SELECT q.idquestoes FROM questoes q LEFT JOIN alternativas a ON a.questoes_idquestoes = q.idquestoes
    WHERE q.codigo_seed LIKE 'PB053-%' GROUP BY q.idquestoes
    HAVING count(a.idalternativas) <> 4 OR count(*) FILTER (WHERE a.correta) <> 1
  ) THEN RAISE EXCEPTION 'Cada questão deve ter quatro alternativas e uma correta'; END IF;
  IF EXISTS (
    SELECT 1 FROM questoes WHERE codigo_seed LIKE 'PB053-%' AND (imagem_url IS NULL OR imagem_alt IS NULL)
  ) THEN RAISE EXCEPTION 'Cada questão deve ter imagem e texto alternativo'; END IF;
END $validacao$;
SELECT 'Carga validada: 12 temas, 12 materiais, 48 questões, 192 alternativas' AS resultado;
