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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Fundamentos da Agilidade'), 'Fundamentos da Agilidade', '<h4>Introdução</h4>
<p>O desenvolvimento de software mudou bastante ao longo dos anos. No início, muitos projetos eram conduzidos de forma rígida e sequencial: primeiro tudo era planejado, depois desenvolvido e, somente nas etapas finais, o cliente conseguia visualizar o resultado.</p>
<p>Com o crescimento e a complexidade dos sistemas, percebeu-se que essa forma de trabalho nem sempre conseguia acompanhar mudanças de requisitos, novas necessidades dos clientes e problemas descobertos durante o desenvolvimento.</p>
<p>É nesse cenário que surgem as <strong>abordagens ágeis</strong>, que buscam tornar o desenvolvimento mais <strong>flexível, colaborativo e adaptável</strong>.</p>
<h4>1. A Crise do Software</h4>
<p>A chamada <strong>Crise do Software</strong> começou a ser discutida principalmente a partir das décadas de 1960 e 1970, quando os sistemas começaram a se tornar maiores e mais complexos.</p>
<p>As empresas perceberam que desenvolver software não era apenas escrever código. Muitos projetos apresentavam problemas como:</p>
<ul>
<li>atrasos frequentes;</li>
<li>custos maiores do que o planejado;</li>
<li>dificuldade para corrigir erros;</li>
<li>softwares difíceis de manter;</li>
<li>problemas de comunicação entre clientes e desenvolvedores;</li>
<li>sistemas que, quando finalmente eram entregues, já não atendiam completamente às necessidades do usuário.</li>
</ul>
<p>Imagine, por exemplo, que uma empresa peça o desenvolvimento de um sistema e defina todos os requisitos no início do projeto. O desenvolvimento leva dois anos. Durante esse período, as necessidades da empresa mudam, mas o projeto continua seguindo exatamente o planejamento original.</p>
<p>Ao final, a equipe pode entregar <strong>exatamente aquilo que foi solicitado dois anos atrás</strong>, mas não aquilo que a empresa <strong>precisa atualmente</strong>.</p>
<p>A Crise do Software contribuiu para o desenvolvimento da <strong>Engenharia de Software</strong>, trazendo métodos, processos e boas práticas para tornar a criação de sistemas mais organizada e previsível.</p>
<h4>2. Desenvolvimento Tradicional × Desenvolvimento Ágil</h4>
<p>Uma das principais diferenças entre essas abordagens está na maneira como o projeto é planejado, desenvolvido e entregue.</p>
<p>Um exemplo clássico de desenvolvimento tradicional é o <strong>Modelo Cascata (Waterfall)</strong>. Nele, o projeto passa por etapas sequenciais, como:</p>
<p><strong>Requisitos → Planejamento → Desenvolvimento → Testes → Entrega</strong></p>
<p>Normalmente, uma etapa é concluída antes que a próxima comece.</p>
<p>Isso pode funcionar bem em projetos nos quais os requisitos são muito claros e dificilmente sofrerão alterações. Porém, mudanças durante o desenvolvimento podem ser mais difíceis e caras.</p>
<p><strong>E como funciona no Ágil?</strong></p>
<p>No desenvolvimento ágil, o projeto é dividido em <strong>pequenos ciclos de trabalho</strong>.</p>
<p>Em vez de esperar meses para entregar todo o sistema, a equipe desenvolve pequenas partes funcionais, recebe feedback e utiliza essas informações para melhorar as próximas entregas.</p>
<p>O processo se parece mais com:</p>
<p><strong>Planejar → Desenvolver → Testar → Entregar → Receber feedback → Melhorar → Repetir</strong></p>
<p>Por isso, mudanças não são necessariamente vistas como um problema. Elas podem fazer parte da evolução natural do produto.</p>
<p><strong>Comparando</strong></p>
<table>
<thead><tr><th>Tradicional / Cascata</th><th>Ágil</th></tr></thead>
<tbody>
<tr><td>Planejamento concentrado no início</td><td>Planejamento contínuo</td></tr>
<tr><td>Etapas sequenciais</td><td>Ciclos curtos e repetitivos</td></tr>
<tr><td>Mudanças podem ser mais difíceis</td><td>Mudanças são esperadas e avaliadas</td></tr>
<tr><td>Entrega tende a acontecer em grandes etapas</td><td>Entregas menores e frequentes</td></tr>
<tr><td>Feedback pode ocorrer mais tarde</td><td>Feedback frequente</td></tr>
<tr><td>Maior foco em seguir o planejamento inicial</td><td>Maior foco em gerar valor e se adaptar</td></tr>
</tbody>
</table>
<h4>3. Agilidade não significa fazer tudo mais rápido</h4>
<p>Esse é um ponto importante.</p>
<p>Ser ágil <strong>não significa simplesmente desenvolver software rapidamente ou trabalhar sem planejamento</strong>.</p>
<p>A agilidade está relacionada principalmente à capacidade de <strong>responder a mudanças, trabalhar de maneira colaborativa, entregar valor continuamente e aprender com o feedback</strong>.</p>
<p>Uma equipe pode trabalhar muito rápido e ainda assim não ser ágil.</p>
<p>Por exemplo, imagine que uma equipe passe três meses desenvolvendo rapidamente uma funcionalidade que ninguém utiliza. Houve velocidade, mas pouco valor.</p>
<p>Uma equipe ágil procura descobrir isso mais cedo, apresentando partes menores da solução e obtendo feedback antes de investir muito tempo.</p>
<h4>4. Benefícios da Agilidade</h4>
<p>Quando aplicada corretamente, a abordagem ágil pode trazer diversos benefícios.</p>
<ul>
<li><strong>Adaptação às mudanças:</strong> se uma necessidade do cliente mudar durante o projeto, a equipe consegue reavaliar prioridades e adaptar as próximas entregas.</li>
<li><strong>Feedback mais rápido:</strong> como pequenas partes do produto são apresentadas ao longo do desenvolvimento, problemas e oportunidades podem ser identificados mais cedo.</li>
<li><strong>Entregas frequentes:</strong> em vez de esperar todo o projeto terminar para gerar valor, funcionalidades podem ser disponibilizadas progressivamente.</li>
<li><strong>Maior colaboração:</strong> desenvolvedores, clientes e demais envolvidos mantêm uma comunicação mais frequente.</li>
<li><strong>Redução de riscos:</strong> entregas menores ajudam a identificar problemas técnicos ou de negócio antes que eles afetem todo o projeto.</li>
<li><strong>Melhoria contínua:</strong> a equipe analisa constantemente o que funcionou, o que não funcionou e o que pode ser melhorado no próximo ciclo.</li>
</ul>
<p><strong>Um exemplo prático</strong></p>
<p>Imagine o desenvolvimento de um aplicativo de delivery.</p>
<p>No modelo tradicional, a equipe poderia planejar todo o aplicativo, desenvolver todas as funcionalidades, realizar os testes e somente depois apresentar o produto completo.</p>
<p>Em uma abordagem ágil, a equipe poderia começar com:</p>
<ul>
<li><strong>1ª entrega:</strong> cadastro e login</li>
<li><strong>2ª entrega:</strong> visualização dos restaurantes</li>
<li><strong>3ª entrega:</strong> carrinho de compras</li>
<li><strong>4ª entrega:</strong> pagamento</li>
<li><strong>5ª entrega:</strong> acompanhamento do pedido</li>
</ul>
<p>Após cada entrega, usuários e responsáveis pelo produto podem avaliar o resultado e fornecer feedback.</p>
<p>Se os usuários demonstrarem que determinada funcionalidade é mais importante do que outra, a equipe poderá <strong>reavaliar as prioridades das próximas entregas</strong>.</p>
<h4>Para lembrar</h4>
<p>A essência da agilidade não está em simplesmente fazer mais coisas em menos tempo. Está em <strong>entregar valor de forma contínua, aprender com feedbacks e conseguir se adaptar às mudanças</strong>.</p>
<p>A transição do desenvolvimento tradicional para abordagens ágeis representa também uma mudança de pensamento: em vez de tentar prever absolutamente tudo desde o início, o projeto pode evoluir conforme a equipe aprende mais sobre o produto e sobre as necessidades dos usuários.</p>', 'https://agilemanifesto.org/iso/ptbr/manifesto.html', 'PB056-1', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Introdução ao Scrum'), 'Introdução ao Scrum', '<h4>Introdução</h4>
<p>No desenvolvimento de produtos e projetos, nem sempre é possível saber desde o início exatamente como será o resultado final. As necessidades dos clientes podem mudar, novos problemas podem surgir e a equipe pode descobrir maneiras melhores de realizar o trabalho ao longo do caminho.</p>
<p>O <strong>Scrum</strong> foi criado para ajudar equipes a trabalharem justamente em ambientes como esses, nos quais existe <strong>complexidade, necessidade de adaptação e aprendizado constante</strong>.</p>
<p>O Scrum é um <strong>framework leve</strong> que ajuda pessoas, equipes e organizações a gerar valor por meio de soluções adaptativas para problemas complexos.</p>
<p>Em vez de tentar planejar todos os detalhes do projeto desde o início, o Scrum trabalha com <strong>ciclos curtos</strong>, permitindo que a equipe desenvolva, analise os resultados, aprenda e faça ajustes continuamente.</p>
<h4>1. O que é um Framework?</h4>
<p>Para entender o Scrum, primeiro precisamos entender o significado de <strong>framework</strong>.</p>
<p>Um framework pode ser entendido como uma <strong>estrutura de trabalho</strong>. Ele estabelece elementos fundamentais que orientam a equipe, mas não determina detalhadamente tudo o que deve ser feito.</p>
<p>Isso significa que o Scrum <strong>não é uma receita pronta</strong> ou um manual com instruções para cada situação.</p>
<p>Ele estabelece uma estrutura formada por elementos como:</p>
<ul>
<li>responsabilidades;</li>
<li>eventos;</li>
<li>artefatos;</li>
<li>regras que conectam esses elementos.</li>
</ul>
<p>Dentro dessa estrutura, cada equipe pode utilizar técnicas e práticas adequadas à sua realidade.</p>
<p><strong>Exemplo prático</strong></p>
<p>Imagine uma equipe desenvolvendo um aplicativo para uma loja.</p>
<p>O Scrum não vai determinar qual linguagem de programação deve ser utilizada, qual ferramenta os desenvolvedores devem escolher ou exatamente como cada tela deve ser construída.</p>
<p>Ele fornece uma estrutura para que a equipe consiga <strong>organizar o trabalho, estabelecer objetivos, acompanhar os resultados e melhorar continuamente</strong>.</p>
<p>Por isso, é importante entender:</p>
<p><strong>Scrum não determina exatamente como realizar o trabalho. Ele cria uma estrutura para organizar e melhorar a forma como o trabalho acontece.</strong></p>
<h4>2. O que é Empirismo?</h4>
<p>O Scrum é baseado no <strong>empirismo</strong>.</p>
<p>Apesar de parecer uma palavra complicada, o conceito é relativamente simples: o empirismo considera que o <strong>conhecimento vem da experiência e da observação do que realmente acontece</strong>.</p>
<p>Em outras palavras, em vez de tentar prever tudo antecipadamente, a equipe toma decisões com base nos resultados que observa durante o desenvolvimento.</p>
<p>O processo funciona aproximadamente assim:</p>
<p><strong>Fazer → Observar → Aprender → Ajustar → Fazer novamente</strong></p>
<p>Isso é especialmente importante em projetos complexos, porque nem sempre conseguimos prever todos os problemas, necessidades ou mudanças antes de começar.</p>
<p><strong>Exemplo prático</strong></p>
<p>Imagine que uma equipe esteja desenvolvendo um novo sistema de cadastro de funcionários.</p>
<p>Inicialmente, acredita-se que determinado formulário será fácil de utilizar. A equipe desenvolve uma primeira versão e apresenta aos usuários.</p>
<p>Ao testarem o sistema, os usuários relatam que algumas perguntas são confusas.</p>
<p>Em vez de continuar desenvolvendo o restante do sistema ignorando essa informação, a equipe utiliza o feedback recebido para <strong>aprender e melhorar a solução</strong>.</p>
<p>Isso é um exemplo de empirismo: tomar decisões a partir daquilo que foi observado na prática.</p>
<h4>Os três pilares do Scrum</h4>
<p>O empirismo dentro do Scrum é sustentado por <strong>três pilares fundamentais</strong>:</p>
<p><strong>Transparência → Inspeção → Adaptação</strong></p>
<p>Esses três conceitos trabalham juntos. Para conseguir identificar problemas, primeiro precisamos enxergar claramente o que está acontecendo. Depois, precisamos analisar essas informações e, quando necessário, realizar mudanças.</p>
<h4>3. Transparência</h4>
<p>A <strong>transparência</strong> significa que o trabalho e as informações importantes devem estar claros e compreensíveis para as pessoas envolvidas.</p>
<p>Todos precisam ter uma visão adequada sobre o andamento do trabalho, os objetivos, as prioridades e os resultados.</p>
<p>Quando não existe transparência, decisões podem ser tomadas com base em informações incorretas ou incompletas.</p>
<p><strong>Exemplo prático</strong></p>
<p>Imagine que uma equipe tenha dez tarefas para concluir durante determinado período.</p>
<p>Se algumas tarefas estiverem atrasadas, mas essa informação não estiver visível para o restante da equipe, todos podem continuar acreditando que o projeto está seguindo normalmente.</p>
<p>Com transparência, a situação fica visível e pode ser discutida.</p>
<p><strong>Transparência = tornar o trabalho e as informações importantes visíveis e compreensíveis.</strong></p>
<h4>4. Inspeção</h4>
<p>Depois que as informações estão disponíveis, é necessário <strong>analisá-las</strong>.</p>
<p>É aí que entra a <strong>inspeção</strong>.</p>
<p>No Scrum, o trabalho e o progresso em direção aos objetivos são inspecionados frequentemente para identificar possíveis problemas, desvios ou oportunidades de melhoria.</p>
<p>Inspecionar não significa procurar culpados. O objetivo é entender <strong>como o trabalho está evoluindo e se alguma mudança é necessária</strong>.</p>
<p><strong>Exemplo prático</strong></p>
<p>A equipe planejou desenvolver cinco funcionalidades durante um ciclo de trabalho.</p>
<p>Durante o acompanhamento, percebe que apenas duas foram concluídas e que uma determinada dificuldade técnica está atrasando as demais.</p>
<p>A equipe identificou o problema por meio da <strong>inspeção</strong>.</p>
<p><strong>Inspeção = analisar o trabalho e os resultados para entender o que está acontecendo.</strong></p>
<h4>5. Adaptação</h4>
<p>Depois de tornar as informações transparentes e realizar a inspeção, pode ser necessário mudar alguma coisa.</p>
<p>Essa mudança é chamada de <strong>adaptação</strong>.</p>
<p>Quando a equipe percebe que determinado processo, planejamento ou solução não está funcionando como esperado, deve realizar ajustes para melhorar o resultado.</p>
<p>O importante é não identificar um problema e simplesmente continuar fazendo tudo da mesma maneira.</p>
<p><strong>Exemplo prático</strong></p>
<p>Voltando ao exemplo anterior, a equipe descobriu que uma dificuldade técnica está atrasando várias funcionalidades.</p>
<p>Depois de analisar a situação, decide reorganizar algumas atividades e priorizar a solução desse problema antes de continuar.</p>
<p>Nesse caso, ocorreu uma <strong>adaptação</strong>.</p>
<p>Podemos visualizar os três pilares juntos:</p>
<ul>
<li><strong>Transparência:</strong> conseguimos enxergar o problema.</li>
<li><strong>Inspeção:</strong> analisamos o problema.</li>
<li><strong>Adaptação:</strong> fazemos os ajustes necessários.</li>
</ul>
<h4>6. Como isso funciona no Scrum?</h4>
<p>O Scrum organiza o trabalho em ciclos chamados <strong>Sprints</strong>.</p>
<p>Uma Sprint possui duração fixa de <strong>um mês ou menos</strong> e funciona como um ciclo no qual a equipe trabalha para alcançar um objetivo e criar algo de valor.</p>
<p>De maneira simplificada, podemos imaginar o funcionamento assim:</p>
<p><strong>Planejar → Desenvolver → Acompanhar → Avaliar → Melhorar → Novo ciclo</strong></p>
<p>Durante esse processo, a equipe utiliza constantemente os princípios que acabamos de estudar.</p>
<p>Ela torna o trabalho <strong>transparente</strong>, realiza <strong>inspeções</strong> frequentes e faz <strong>adaptações</strong> quando necessário.</p>
<p>Por isso, o Scrum não depende de tentar acertar tudo na primeira tentativa. Ele cria oportunidades frequentes para que a equipe <strong>aprenda e evolua</strong>.</p>
<p><strong>Exemplo completo</strong></p>
<p>Imagine que uma equipe esteja desenvolvendo um aplicativo de compras.</p>
<p>Durante uma Sprint, o objetivo é desenvolver o carrinho de compras.</p>
<p>A equipe trabalha na funcionalidade e mantém o progresso visível para todos. Isso representa a <strong>transparência</strong>.</p>
<p>Durante o ciclo, percebe que adicionar muitos produtos deixa o carrinho lento. A equipe analisa o comportamento e identifica o problema. Isso representa a <strong>inspeção</strong>.</p>
<p>Com base nessa descoberta, os desenvolvedores alteram a solução técnica para melhorar o desempenho. Isso representa a <strong>adaptação</strong>.</p>
<p>A experiência obtida ajuda a equipe a tomar decisões melhores nos próximos ciclos.</p>
<p>Esse processo representa o <strong>empirismo na prática</strong>.</p>
<h4>Para lembrar</h4>
<p>O <strong>Scrum é um framework</strong>, e não uma receita rígida de como desenvolver um produto.</p>
<p>Ele é baseado no <strong>empirismo</strong>, ou seja, na ideia de que aprendemos por meio da experiência, da observação e dos resultados obtidos durante o trabalho.</p>
<p>Seus três pilares são:</p>
<ul>
<li><strong>Transparência:</strong> deixar informações e trabalho importantes claros e compreensíveis.</li>
<li><strong>Inspeção:</strong> observar e analisar frequentemente o progresso e os resultados.</li>
<li><strong>Adaptação:</strong> realizar mudanças quando a inspeção indicar que ajustes são necessários.</li>
</ul>
<p>Quando esses conceitos trabalham juntos, a equipe consegue <strong>aprender continuamente, identificar problemas mais cedo e se adaptar às mudanças</strong>.</p>', 'https://scrumguides.org/scrum-guide.html', 'PB056-2', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Papéis do Scrum'), 'Papéis do Scrum', '<h4>Introdução</h4>
<p>No desenvolvimento de um software, várias pessoas precisam trabalhar juntas para que o produto seja entregue com qualidade e atenda às necessidades dos usuários.</p>
<p>Para organizar esse trabalho, o Scrum define três responsabilidades principais: Product Owner, Scrum Master e Developers.</p>
<p>Cada uma possui uma função específica, mas todas trabalham em conjunto para alcançar o mesmo objetivo: desenvolver um produto que gere valor.</p>
<p>É importante entender que o Scrum não funciona como uma hierarquia tradicional, na qual uma pessoa simplesmente dá ordens e as outras executam. Ele valoriza a colaboração, a autonomia e a responsabilidade compartilhada.</p>
<h4>1. O que é o Scrum Team?</h4>
<p>O Scrum Team é a equipe responsável por desenvolver e melhorar um produto utilizando o Scrum.</p>
<p>Ele é formado por:</p>
<ul>
<li>Product Owner;</li>
<li>Scrum Master;</li>
<li>Developers.</li>
</ul>
<p>Essas pessoas possuem responsabilidades diferentes, mas trabalham como uma única equipe.</p>
<p>O Scrum Team é multifuncional, ou seja, reúne as habilidades necessárias para desenvolver o produto. Também é autogerenciável, pois seus integrantes decidem internamente como organizar e executar o trabalho.</p>
<p><strong>Exemplo prático</strong></p>
<p>Imagine que uma empresa deseja desenvolver um sistema de cadastro de funcionários.</p>
<p>O Product Owner identifica quais funcionalidades são mais importantes. Os Developers desenvolvem e testam o sistema. O Scrum Master ajuda a equipe a utilizar o Scrum corretamente e a resolver dificuldades relacionadas à sua forma de trabalhar.</p>
<p>Todos colaboram para entregar um sistema funcional.</p>
<h4>2. Product Owner — Responsável pelo valor do produto</h4>
<p>O Product Owner, também conhecido como PO, é responsável por maximizar o valor gerado pelo produto.</p>
<p>Ele precisa compreender as necessidades dos usuários, os objetivos do negócio e as prioridades do desenvolvimento.</p>
<p>Suas principais responsabilidades são:</p>
<ul>
<li>Definir e comunicar o Product Goal, que representa o objetivo de longo prazo do produto.</li>
<li>Criar e comunicar claramente os itens do Product Backlog.</li>
<li>Organizar os itens do Product Backlog conforme as prioridades.</li>
<li>Garantir que o Product Backlog esteja transparente, visível e compreensível.</li>
</ul>
<p>O Product Owner pode delegar atividades relacionadas ao backlog, mas continua responsável por sua gestão.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está desenvolvendo um aplicativo de compras.</p>
<p>Existem três funcionalidades solicitadas:</p>
<ol>
<li>Cadastro de clientes.</li>
<li>Pagamento por cartão.</li>
<li>Alteração da cor dos botões.</li>
</ol>
<p>O Product Owner analisa o valor de cada funcionalidade e pode decidir priorizar o cadastro e o pagamento, pois são essenciais para que os clientes consigam comprar.</p>
<p>Isso não significa que as cores não sejam importantes, mas que outras funcionalidades podem gerar mais valor naquele momento.</p>
<h4>3. Scrum Master — Responsável pela efetividade do Scrum</h4>
<p>O Scrum Master é responsável por estabelecer o Scrum conforme suas regras e princípios, ajudando a equipe e a organização a compreenderem e aplicarem o framework.</p>
<p>Ele também trabalha para melhorar a efetividade do Scrum Team.</p>
<p>Suas atividades incluem:</p>
<ul>
<li>Orientar a equipe sobre o Scrum.</li>
<li>Ajudar na remoção de impedimentos que prejudicam o progresso.</li>
<li>Apoiar a melhoria contínua.</li>
<li>Ajudar a equipe a desenvolver autonomia.</li>
<li>Garantir que os eventos do Scrum sejam produtivos e respeitem seus limites de tempo.</li>
</ul>
<p>O Scrum Master não é necessariamente o chefe dos Developers.</p>
<p>Seu papel não é distribuir ordens ou controlar individualmente cada atividade, mas ajudar a equipe a trabalhar melhor.</p>
<p><strong>Exemplo prático</strong></p>
<p>Durante o desenvolvimento de um sistema, a equipe percebe que depende frequentemente de autorizações de outro departamento.</p>
<p>Essas autorizações demoram vários dias e prejudicam as entregas.</p>
<p>O Scrum Master pode ajudar a identificar a causa dessa dificuldade e facilitar a comunicação entre os departamentos para reduzir o impedimento.</p>
<h4>4. Developers — Responsáveis pelo desenvolvimento do produto</h4>
<p>Os Developers são os profissionais responsáveis por criar um Incremento utilizável do produto a cada Sprint.</p>
<p>Apesar do nome, essa responsabilidade não se limita a programadores.</p>
<p>Dependendo do produto, a equipe pode incluir profissionais de desenvolvimento, testes, design, análise e outras especialidades.</p>
<p>Entre suas responsabilidades estão:</p>
<ul>
<li>Criar o plano de trabalho da Sprint, chamado Sprint Backlog.</li>
<li>Manter a qualidade conforme a Definition of Done.</li>
<li>Adaptar diariamente o planejamento para alcançar o Sprint Goal.</li>
<li>Responsabilizar-se mutuamente pelo trabalho realizado.</li>
</ul>
<p><strong>Exemplo prático</strong></p>
<p>Em um projeto de aplicativo, os Developers podem trabalhar na criação das telas, na programação das funcionalidades, na integração com o banco de dados e nos testes.</p>
<p>A equipe organiza como realizará essas atividades e acompanha o progresso durante a Sprint.</p>
<h4>5. Como os três papéis trabalham juntos?</h4>
<p>Embora tenham responsabilidades diferentes, Product Owner, Scrum Master e Developers precisam manter uma comunicação constante.</p>
<p>Imagine o desenvolvimento de um sistema de agendamento.</p>
<p>O Product Owner identifica que os usuários precisam cancelar agendamentos.</p>
<p>Os Developers analisam como implementar a funcionalidade, discutem os detalhes e desenvolvem a solução.</p>
<p>O Scrum Master ajuda a equipe a manter uma boa colaboração e a superar dificuldades relacionadas ao processo de trabalho.</p>
<p>Quando a funcionalidade está pronta, o resultado pode ser apresentado aos interessados para receber feedback.</p>
<p>Essa interação permite que o produto evolua de acordo com as necessidades reais dos usuários.</p>
<h4>Para lembrar</h4>
<p>O Scrum Team é formado por três responsabilidades principais.</p>
<ul>
<li><strong>Product Owner:</strong> maximiza o valor do produto e responde pela gestão do Product Backlog.</li>
<li><strong>Scrum Master:</strong> ajuda a equipe e a organização a compreenderem o Scrum e a melhorarem sua efetividade.</li>
<li><strong>Developers:</strong> planejam e realizam o trabalho necessário para criar Incrementos utilizáveis.</li>
</ul>
<p>Nenhuma dessas responsabilidades funciona de maneira isolada. A colaboração entre todos é fundamental.</p>', 'https://scrumguides.org/scrum-guide.html', 'PB056-3', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Eventos do Scrum'), 'Eventos do Scrum', '<h4>Introdução</h4>
<p>Durante o desenvolvimento de um produto, é necessário planejar as atividades, acompanhar o progresso, avaliar os resultados e identificar melhorias.</p>
<p>O Scrum organiza esses momentos por meio de eventos.</p>
<p>Os eventos criam oportunidades regulares para a equipe inspecionar o trabalho e realizar adaptações quando necessário.</p>
<p>Os cinco eventos do Scrum são:</p>
<ul>
<li>Sprint;</li>
<li>Sprint Planning;</li>
<li>Daily Scrum;</li>
<li>Sprint Review;</li>
<li>Sprint Retrospective.</li>
</ul>
<p>Cada evento possui uma finalidade específica.</p>
<h4>1. Sprint — O ciclo de trabalho</h4>
<p>A Sprint é o evento central do Scrum.</p>
<p>Ela representa um período de trabalho com duração fixa de até um mês, durante o qual a equipe busca alcançar um objetivo e produzir um Incremento de valor.</p>
<p>Uma nova Sprint começa imediatamente após o término da anterior.</p>
<p>Durante a Sprint, o Scrum Team desenvolve o produto, acompanha o progresso e realiza os ajustes necessários.</p>
<p>O Sprint Goal deve ser preservado, e mudanças que coloquem esse objetivo em risco devem ser evitadas.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está desenvolvendo um sistema de vendas.</p>
<p>Na primeira Sprint, o objetivo é permitir o cadastro de clientes.</p>
<p>Na segunda Sprint, o objetivo pode ser desenvolver o cadastro de produtos.</p>
<p>Na terceira Sprint, a equipe pode trabalhar na criação de pedidos.</p>
<p>Dessa maneira, o sistema evolui gradualmente.</p>
<h4>2. Sprint Planning — Planejamento da Sprint</h4>
<p>O Sprint Planning é o evento que inicia o planejamento do trabalho de uma Sprint.</p>
<p>Durante esse encontro, a equipe discute três questões principais:</p>
<ul>
<li><strong>Por que esta Sprint é valiosa?</strong> O Product Owner apresenta como o produto pode aumentar seu valor, e o Scrum Team define o Sprint Goal.</li>
<li><strong>O que pode ser realizado nesta Sprint?</strong> Os Developers, em conversa com o Product Owner, selecionam os itens do Product Backlog que acreditam conseguir concluir.</li>
<li><strong>Como o trabalho será realizado?</strong> Os Developers planejam as atividades necessárias para transformar os itens selecionados em um Incremento.</li>
</ul>
<p>O resultado é o Sprint Backlog.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe possui duas semanas para desenvolver uma funcionalidade de login.</p>
<p>No Sprint Planning, define que o objetivo será permitir que usuários cadastrados acessem o sistema com segurança.</p>
<p>Os Developers discutem as atividades necessárias, como criar a tela, validar as credenciais e testar o funcionamento.</p>
<h4>3. Daily Scrum — Acompanhamento diário</h4>
<p>A Daily Scrum é um evento de 15 minutos realizado em cada dia útil da Sprint pelos Developers.</p>
<p>Seu objetivo é inspecionar o progresso em direção ao Sprint Goal e adaptar o Sprint Backlog conforme necessário.</p>
<p>Durante o encontro, a equipe pode discutir o andamento das atividades, identificar dificuldades e reorganizar o trabalho.</p>
<p>Não é obrigatório responder às tradicionais três perguntas sobre ontem, hoje e impedimentos. A equipe pode escolher a estrutura mais útil, desde que mantenha o foco no Sprint Goal.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está desenvolvendo uma tela de cadastro.</p>
<p>Durante a Daily Scrum, um Developer informa que encontrou uma dificuldade na integração com o banco de dados.</p>
<p>Os demais analisam a situação e combinam uma forma de ajudar.</p>
<p>Assim, o problema pode ser resolvido antes que prejudique toda a Sprint.</p>
<h4>4. Sprint Review — Avaliação do resultado</h4>
<p>A Sprint Review acontece perto do final da Sprint.</p>
<p>Seu objetivo é inspecionar o resultado do trabalho realizado e discutir possíveis adaptações futuras.</p>
<p>Nesse evento, o Scrum Team e os stakeholders, ou seja, as pessoas interessadas no produto, analisam os resultados e conversam sobre os próximos passos.</p>
<p>A Sprint Review não deve ser entendida apenas como uma apresentação ou reunião de aprovação.</p>
<p>Ela é uma oportunidade de colaboração e aprendizado.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe desenvolveu uma funcionalidade de emissão de relatórios.</p>
<p>Durante a Sprint Review, os usuários percebem que seria interessante adicionar um filtro por período.</p>
<p>O Product Owner considera esse feedback e pode ajustar o Product Backlog.</p>
<h4>5. Sprint Retrospective — Melhoria da equipe</h4>
<p>A Sprint Retrospective é o evento que encerra a Sprint.</p>
<p>Seu objetivo é planejar maneiras de aumentar a qualidade e a efetividade da equipe.</p>
<p>Durante esse encontro, o Scrum Team analisa aspectos como:</p>
<ul>
<li>Comunicação;</li>
<li>Colaboração;</li>
<li>Processos;</li>
<li>Ferramentas;</li>
<li>Qualidade;</li>
<li>Dificuldades encontradas.</li>
</ul>
<p>A equipe identifica o que funcionou bem, o que precisa melhorar e quais mudanças podem ser aplicadas.</p>
<p><strong>Exemplo prático</strong></p>
<p>Durante uma Sprint, os Developers perceberam que várias tarefas demoraram porque os requisitos não estavam suficientemente claros.</p>
<p>Na retrospectiva, a equipe decide melhorar o refinamento das atividades antes das próximas Sprints.</p>
<h4>6. Como os eventos se conectam?</h4>
<p>Podemos visualizar o funcionamento de uma Sprint da seguinte maneira:</p>
<p><strong>Sprint Planning → Desenvolvimento e Daily Scrum → Sprint Review → Sprint Retrospective → Próxima Sprint</strong></p>
<p>A Sprint envolve todos esses eventos.</p>
<p>Cada um contribui para o planejamento, acompanhamento, avaliação ou melhoria do trabalho.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Sprint:</strong> ciclo de trabalho de até um mês.</li>
<li><strong>Sprint Planning:</strong> define o objetivo e planeja o trabalho da Sprint.</li>
<li><strong>Daily Scrum:</strong> acompanha diariamente o progresso em direção ao objetivo.</li>
<li><strong>Sprint Review:</strong> inspeciona o resultado do produto e discute adaptações.</li>
<li><strong>Sprint Retrospective:</strong> identifica melhorias na forma de trabalhar.</li>
</ul>', 'https://scrumguides.org/scrum-guide.html', 'PB056-4', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Artefatos do Scrum'), 'Artefatos do Scrum', '<h4>Introdução</h4>
<p>Para desenvolver um produto de maneira organizada, uma equipe precisa saber o que deve ser feito, quais atividades estão em andamento e quais resultados foram concluídos.</p>
<p>No Scrum, essas informações são organizadas por meio de artefatos.</p>
<p>Os três artefatos oficiais são:</p>
<ul>
<li>Product Backlog;</li>
<li>Sprint Backlog;</li>
<li>Incremento.</li>
</ul>
<p>Cada artefato possui um compromisso associado, que ajuda a manter o foco e a transparência:</p>
<ul>
<li>Product Goal;</li>
<li>Sprint Goal;</li>
<li>Definition of Done.</li>
</ul>
<p>Esses elementos trabalham juntos para orientar o desenvolvimento.</p>
<h4>1. Product Backlog — Lista de necessidades do produto</h4>
<p>O Product Backlog é uma lista ordenada e em constante evolução de tudo aquilo que é necessário para melhorar o produto.</p>
<p>Ele pode incluir funcionalidades, correções, melhorias e outras necessidades.</p>
<p>O Product Owner é responsável pela gestão do Product Backlog.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está criando um aplicativo de delivery.</p>
<p>O Product Backlog pode conter:</p>
<ol>
<li>Cadastro de usuários.</li>
<li>Pesquisa de restaurantes.</li>
<li>Carrinho de compras.</li>
<li>Pagamento online.</li>
<li>Rastreamento de pedidos.</li>
</ol>
<p>Esses itens podem mudar de posição ou ser detalhados conforme a equipe aprende mais sobre o produto.</p>
<h4>2. Product Goal — Objetivo do produto</h4>
<p>O Product Goal é o compromisso associado ao Product Backlog.</p>
<p>Ele representa um objetivo de longo prazo que orienta o trabalho do Scrum Team.</p>
<p>Enquanto o Product Backlog apresenta o que pode ser necessário desenvolver, o Product Goal explica qual objetivo maior a equipe busca alcançar.</p>
<p><strong>Exemplo prático</strong></p>
<p>Product Goal: criar uma plataforma que permita aos clientes realizar pedidos de comida de forma simples e segura.</p>
<p>As funcionalidades do Product Backlog devem contribuir para alcançar esse objetivo.</p>
<h4>3. Sprint Backlog — Plano de trabalho da Sprint</h4>
<p>O Sprint Backlog é formado por três elementos:</p>
<ul>
<li>Sprint Goal;</li>
<li>Itens do Product Backlog selecionados para a Sprint;</li>
<li>Plano de trabalho necessário para entregar esses itens.</li>
</ul>
<p>Ele é criado e atualizado pelos Developers.</p>
<p>O Sprint Backlog pode ser ajustado durante a Sprint, conforme a equipe aprende mais sobre o trabalho.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe selecionou o desenvolvimento do login para a Sprint.</p>
<p>Seu Sprint Backlog pode conter atividades como criar a tela de acesso, implementar a autenticação e realizar testes.</p>
<h4>4. Sprint Goal — Objetivo da Sprint</h4>
<p>O Sprint Goal é o compromisso associado ao Sprint Backlog.</p>
<p>Ele representa o objetivo único que a equipe pretende alcançar durante a Sprint.</p>
<p>O Sprint Goal oferece foco e permite flexibilidade sobre o trabalho necessário para atingi-lo.</p>
<p><strong>Exemplo prático</strong></p>
<p>Sprint Goal: permitir que usuários cadastrados consigam entrar no sistema com segurança.</p>
<p>Mesmo que algumas atividades técnicas precisem mudar, a equipe continua trabalhando para alcançar esse objetivo.</p>
<h4>5. Incremento — Resultado utilizável</h4>
<p>O Incremento é uma parte concreta e utilizável do produto que representa um avanço em direção ao Product Goal.</p>
<p>Cada Incremento precisa atender à Definition of Done.</p>
<p>Um produto pode receber mais de um Incremento durante a mesma Sprint.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe desenvolveu uma funcionalidade de cadastro que funciona corretamente, passou pelos testes necessários e atende aos critérios de qualidade definidos.</p>
<p>Essa funcionalidade pode fazer parte de um Incremento.</p>
<p>Não basta que o código tenha sido escrito. O trabalho precisa atender aos critérios estabelecidos para ser considerado concluído.</p>
<h4>6. Definition of Done — Definição de pronto</h4>
<p>A Definition of Done, também chamada de DoD, é uma descrição formal do estado que um Incremento precisa atingir para atender às medidas de qualidade exigidas pelo produto.</p>
<p>Ela estabelece um entendimento comum sobre o que significa um trabalho estar realmente concluído.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe pode definir que uma funcionalidade estará pronta quando:</p>
<ul>
<li>O código estiver implementado.</li>
<li>Os testes necessários tiverem sido realizados.</li>
<li>Não existirem erros críticos conhecidos.</li>
<li>A funcionalidade estiver integrada ao produto.</li>
<li>Os padrões de qualidade aplicáveis forem atendidos.</li>
</ul>
<p>Esses são exemplos de critérios que uma equipe pode adotar, e não uma lista obrigatória estabelecida pelo Scrum.</p>
<h4>7. Como os artefatos se relacionam?</h4>
<p>O Product Backlog reúne as necessidades do produto e está associado ao Product Goal.</p>
<p>O Sprint Backlog apresenta o plano da Sprint e está associado ao Sprint Goal.</p>
<p>O Incremento representa o resultado utilizável e precisa atender à Definition of Done.</p>
<p>Esses elementos permitem acompanhar o que precisa ser feito, o que está sendo desenvolvido e o que foi realmente concluído.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Product Backlog:</strong> lista ordenada do que é necessário para melhorar o produto.</li>
<li><strong>Product Goal:</strong> objetivo de longo prazo do produto.</li>
<li><strong>Sprint Backlog:</strong> objetivo, itens selecionados e plano de trabalho da Sprint.</li>
<li><strong>Sprint Goal:</strong> objetivo que orienta a Sprint.</li>
<li><strong>Incremento:</strong> resultado utilizável que acrescenta valor ao produto.</li>
<li><strong>Definition of Done:</strong> critérios de qualidade que determinam quando um Incremento está concluído.</li>
</ul>', 'https://scrumguides.org/scrum-guide.html', 'PB056-5', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'User Stories'), 'User Stories', '<h4>Introdução</h4>
<p>Durante o desenvolvimento de um sistema, é necessário compreender o que os usuários realmente precisam.</p>
<p>Nem sempre uma solicitação técnica consegue explicar claramente o problema que precisa ser resolvido.</p>
<p>As User Stories, ou histórias de usuário, ajudam a descrever necessidades de maneira simples, considerando quem utilizará a funcionalidade e qual benefício ela deverá oferecer.</p>
<p>Elas são muito utilizadas em equipes ágeis, embora não sejam uma exigência obrigatória do Scrum.</p>
<h4>1. O que é uma User Story?</h4>
<p>Uma User Story é uma descrição curta de uma necessidade ou funcionalidade sob a perspectiva de quem utilizará o produto.</p>
<p>Seu objetivo é facilitar a compreensão e estimular conversas entre os envolvidos.</p>
<p>Em vez de descrever apenas uma tarefa técnica, a User Story procura mostrar qual necessidade deverá ser atendida.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma descrição puramente técnica poderia ser:</p>
<p>"Desenvolver uma tela com campos de e-mail e senha."</p>
<p>Uma User Story poderia ser:</p>
<p>"Como usuário cadastrado, quero acessar minha conta utilizando e-mail e senha, para consultar minhas informações com segurança."</p>
<p>A segunda descrição ajuda a compreender quem precisa da funcionalidade, o que deseja fazer e por quê.</p>
<h4>2. Estrutura de uma User Story</h4>
<p>Um modelo bastante utilizado é:</p>
<p><strong>Como [tipo de usuário], quero [funcionalidade ou necessidade], para [benefício ou objetivo].</strong></p>
<p>Essa estrutura possui três partes.</p>
<ul>
<li><strong>Como...</strong> Identifica quem possui a necessidade. Pode ser um cliente, administrador, funcionário ou outro perfil de usuário.</li>
<li><strong>Quero...</strong> Descreve o que essa pessoa deseja realizar.</li>
<li><strong>Para...</strong> Explica o motivo ou benefício esperado.</li>
</ul>
<p><strong>Exemplo prático</strong></p>
<p>"Como funcionário, quero consultar meus comprovantes de pagamento, para acessar minhas informações sem precisar solicitar ao RH."</p>
<p>Nesse exemplo:</p>
<ul>
<li>Como: funcionário.</li>
<li>Quero: consultar meus comprovantes de pagamento.</li>
<li>Para: acessar as informações sem depender de uma solicitação ao RH.</li>
</ul>
<h4>3. Critérios de aceitação</h4>
<p>Os critérios de aceitação são condições que ajudam a determinar se uma User Story atende ao comportamento esperado.</p>
<p>Eles tornam os requisitos mais claros e permitem que a equipe verifique se a funcionalidade foi implementada corretamente.</p>
<p><strong>Exemplo prático</strong></p>
<p>User Story:</p>
<p>"Como usuário, quero recuperar minha senha, para conseguir acessar minha conta caso a esqueça."</p>
<p>Possíveis critérios de aceitação:</p>
<ol>
<li>O usuário deve conseguir solicitar a recuperação informando seu e-mail.</li>
<li>O sistema deve apresentar uma mensagem de confirmação da solicitação.</li>
<li>O usuário deve receber instruções para redefinir a senha, quando aplicável.</li>
<li>A nova senha deve atender aos requisitos de segurança definidos.</li>
</ol>
<p>Os critérios de aceitação são específicos da história e não substituem a Definition of Done do produto.</p>
<h4>4. Como escrever boas User Stories?</h4>
<p>Uma boa User Story precisa ser compreensível e permitir que a equipe converse sobre a necessidade.</p>
<p>Ela deve apresentar valor para o usuário e ser suficientemente pequena para facilitar o planejamento e a entrega.</p>
<p>Uma técnica conhecida para avaliar histórias é o modelo INVEST:</p>
<ul>
<li><strong>Independent:</strong> independente, sempre que possível.</li>
<li><strong>Negotiable:</strong> negociável, permitindo discussão.</li>
<li><strong>Valuable:</strong> valiosa para o usuário ou negócio.</li>
<li><strong>Estimable:</strong> possível de estimar.</li>
<li><strong>Small:</strong> pequena o suficiente para ser trabalhada.</li>
<li><strong>Testable:</strong> verificável por meio de testes ou critérios objetivos.</li>
</ul>
<p>Essas características ajudam a melhorar a qualidade das histórias.</p>
<h4>5. Diferença entre User Story e tarefa técnica</h4>
<p>Uma User Story descreve uma necessidade ou resultado esperado.</p>
<p>Uma tarefa técnica representa uma atividade necessária para implementar a solução.</p>
<p><strong>Exemplo prático</strong></p>
<p>User Story:</p>
<p>"Como cliente, quero visualizar meu histórico de pedidos, para acompanhar minhas compras anteriores."</p>
<p>Possíveis tarefas técnicas:</p>
<ul>
<li>Criar a interface de histórico.</li>
<li>Desenvolver a consulta ao banco de dados.</li>
<li>Implementar a API.</li>
<li>Realizar testes.</li>
</ul>
<p>As tarefas contribuem para a entrega da User Story.</p>
<h4>6. Exemplo completo</h4>
<p>Imagine que uma equipe esteja desenvolvendo um sistema de agendamento de consultas.</p>
<p>User Story:</p>
<p>"Como paciente, quero cancelar uma consulta agendada, para liberar o horário quando não puder comparecer."</p>
<p>Critérios de aceitação:</p>
<ol>
<li>O paciente deve conseguir visualizar suas consultas futuras.</li>
<li>O sistema deve permitir cancelar consultas dentro das regras estabelecidas.</li>
<li>Antes do cancelamento, o sistema deve solicitar confirmação.</li>
<li>Após o cancelamento, a consulta deve aparecer com o status atualizado.</li>
</ol>
<p>Essa estrutura ajuda os Developers a compreenderem o comportamento esperado e facilita a validação da funcionalidade.</p>
<h4>Para lembrar</h4>
<p>User Stories descrevem necessidades do ponto de vista do usuário.</p>
<p>A estrutura mais comum é:</p>
<p><strong>Como... Quero... Para...</strong></p>
<p>Os critérios de aceitação definem condições verificáveis para a história.</p>
<p>Uma boa User Story facilita a comunicação, o planejamento e a compreensão do valor da funcionalidade.</p>', 'https://www.agilealliance.org/glossary/user-stories/', 'PB056-6', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Gestão do Product Backlog'), 'Gestão do Product Backlog', '<h4>Introdução</h4>
<p>Durante o desenvolvimento de um produto, novas necessidades surgem constantemente.</p>
<p>Clientes podem solicitar funcionalidades, usuários podem identificar problemas e a equipe pode descobrir oportunidades de melhoria.</p>
<p>Para organizar essas necessidades, muitas equipes utilizam o Product Backlog.</p>
<p>Entretanto, não basta criar uma lista de atividades.</p>
<p>É necessário organizar, priorizar, detalhar e atualizar os itens para que o produto evolua de maneira adequada.</p>
<p>Esse trabalho é conhecido como gestão do Product Backlog.</p>
<h4>1. O que é a gestão do Product Backlog?</h4>
<p>A gestão do Product Backlog envolve manter uma lista ordenada, clara e atualizada das necessidades do produto.</p>
<p>O Product Owner é responsável por essa gestão, embora possa contar com a colaboração de outras pessoas.</p>
<p>O Product Backlog não é um documento fixo.</p>
<p>Ele evolui conforme surgem novas informações sobre o produto, os usuários e o mercado.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está desenvolvendo um sistema de recursos humanos.</p>
<p>Inicialmente, o backlog possui funcionalidades de cadastro de funcionários e controle de férias.</p>
<p>Durante o desenvolvimento, os usuários identificam a necessidade de anexar documentos.</p>
<p>Essa nova necessidade pode ser adicionada e avaliada conforme sua importância.</p>
<h4>2. Priorização do Product Backlog</h4>
<p>Priorizar significa analisar quais itens devem receber atenção primeiro.</p>
<p>Nem todas as funcionalidades possuem o mesmo valor ou a mesma urgência.</p>
<p>Alguns fatores que podem ajudar na priorização são:</p>
<ul>
<li>Valor para o usuário.</li>
<li>Impacto no negócio.</li>
<li>Urgência.</li>
<li>Riscos.</li>
<li>Dependências.</li>
<li>Esforço necessário.</li>
</ul>
<p>A equipe pode utilizar técnicas específicas de priorização, mas o Scrum não exige uma técnica única.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma loja virtual precisa implementar três melhorias:</p>
<ol>
<li>Corrigir uma falha que impede pagamentos.</li>
<li>Criar um filtro por categoria.</li>
<li>Alterar a cor do menu.</li>
</ol>
<p>A correção do pagamento provavelmente terá maior prioridade, pois o problema impede que os clientes concluam compras.</p>
<h4>3. Refinamento do Product Backlog</h4>
<p>O refinamento é uma atividade contínua de detalhamento e melhoria dos itens do Product Backlog.</p>
<p>Durante o refinamento, os itens podem ser:</p>
<ul>
<li>Divididos em partes menores.</li>
<li>Descritos com mais clareza.</li>
<li>Estimados.</li>
<li>Reorganizados.</li>
<li>Complementados com novas informações.</li>
</ul>
<p>O refinamento não é um evento formal obrigatório do Scrum.</p>
<p><strong>Exemplo prático</strong></p>
<p>Um item do backlog possui a descrição:</p>
<p>"Criar sistema de relatórios."</p>
<p>Essa descrição é muito ampla.</p>
<p>Durante o refinamento, a equipe pode dividir a necessidade em itens menores:</p>
<ul>
<li>Relatório de vendas por período.</li>
<li>Relatório de clientes.</li>
<li>Exportação de relatórios.</li>
<li>Filtro por vendedor.</li>
</ul>
<p>Assim, o trabalho se torna mais compreensível e fácil de planejar.</p>
<h4>4. Organização do Backlog</h4>
<p>Um Product Backlog bem organizado permite que todos compreendam quais necessidades existem e qual é a ordem atual dos itens.</p>
<p>Cada item pode conter informações como:</p>
<ul>
<li>Título.</li>
<li>Descrição.</li>
<li>Critérios de aceitação.</li>
<li>Estimativa.</li>
<li>Prioridade ou posição no backlog.</li>
<li>Dependências relevantes.</li>
</ul>
<p>Esses campos são exemplos de organização e não exigências obrigatórias do Scrum.</p>
<p>Ferramentas digitais podem facilitar esse acompanhamento.</p>
<h4>5. Evolução do Product Backlog</h4>
<p>O Product Backlog muda ao longo do desenvolvimento.</p>
<p>Alguns itens podem ser adicionados, modificados, removidos ou reorganizados.</p>
<p>Isso acontece porque a equipe aprende continuamente sobre o produto.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma empresa desenvolve um aplicativo de agendamentos.</p>
<p>Inicialmente, acredita que o recurso mais importante é permitir que clientes escolham horários.</p>
<p>Após receber feedback, descobre que muitos usuários também precisam remarcar consultas.</p>
<p>O Product Owner pode reavaliar as prioridades e posicionar essa nova funcionalidade entre os próximos itens a serem desenvolvidos.</p>
<h4>6. Como a gestão do backlog contribui para o projeto?</h4>
<p>Uma boa gestão do Product Backlog ajuda a equipe a concentrar seus esforços nas necessidades mais relevantes.</p>
<p>Também reduz dúvidas, facilita o planejamento e melhora a comunicação.</p>
<p>Por outro lado, um backlog desorganizado pode gerar retrabalho, desenvolvimento de funcionalidades pouco úteis e dificuldades para definir prioridades.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Priorização:</strong> avaliar quais itens são mais importantes.</li>
<li><strong>Refinamento:</strong> detalhar, dividir e esclarecer os itens.</li>
<li><strong>Organização:</strong> manter o backlog compreensível e ordenado.</li>
<li><strong>Evolução:</strong> atualizar o backlog conforme surgem novas informações.</li>
</ul>
<p>O Product Backlog é dinâmico e deve acompanhar as necessidades do produto.</p>', 'https://scrumguides.org/scrum-guide.html', 'PB056-7', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Kanban'), 'Kanban', '<h4>Introdução</h4>
<p>Em muitos projetos, várias atividades acontecem ao mesmo tempo.</p>
<p>Sem uma organização adequada, pode ser difícil identificar quais tarefas estão em andamento, quais foram concluídas e onde existem atrasos.</p>
<p>O Kanban é uma abordagem de gestão do trabalho que ajuda as equipes a visualizar atividades, controlar o trabalho em andamento e melhorar o fluxo de entrega.</p>
<p>Ele pode ser utilizado em desenvolvimento de software, atendimento, suporte técnico e diversas outras áreas.</p>
<h4>1. O que é Kanban?</h4>
<p>Kanban é uma abordagem que utiliza a visualização do trabalho e a gestão do fluxo para melhorar a maneira como as atividades são realizadas.</p>
<p>Uma de suas características é ajudar a equipe a compreender como o trabalho passa pelas diferentes etapas até ser concluído.</p>
<p>Diferentemente do Scrum, o Kanban não exige que o trabalho seja organizado em Sprints.</p>
<h4>2. Quadro Kanban</h4>
<p>O quadro Kanban é uma ferramenta visual que representa as etapas de um fluxo de trabalho.</p>
<p><strong>Um exemplo simples é:</strong></p>
<table>
<thead><tr><th>A fazer</th><th>Em andamento</th><th>Concluído</th></tr></thead>
<tbody>
<tr><td>Criar tela de login</td><td>Desenvolver cadastro</td><td>Corrigir menu</td></tr>
<tr><td>Testar pagamento</td><td></td><td>Atualizar formulário</td></tr>
</tbody>
</table>
<p>Cada atividade pode ser representada por um card.</p>
<p>Conforme o trabalho avança, o card muda de coluna.</p>
<p>O quadro pode possuir mais etapas, dependendo do processo da equipe.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe de suporte técnico utiliza as colunas:</p>
<p><strong>Solicitado → Em análise → Em execução → Em validação → Concluído</strong></p>
<p>Dessa forma, todos conseguem visualizar o andamento dos atendimentos.</p>
<h4>3. Fluxo contínuo</h4>
<p>No Kanban, o trabalho pode avançar continuamente pelo processo.</p>
<p>Isso significa que uma nova atividade não precisa esperar o início de uma Sprint para ser considerada.</p>
<p>O objetivo é permitir que o trabalho flua de maneira estável e previsível.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe recebe solicitações de correção de sistemas.</p>
<p>Quando existe capacidade disponível, uma nova solicitação pode entrar em execução.</p>
<p>Após ser concluída, outra atividade pode ser iniciada.</p>
<h4>4. Limites de WIP</h4>
<p>WIP significa Work in Progress, ou trabalho em andamento.</p>
<p>Os limites de WIP estabelecem uma quantidade máxima de atividades que podem estar em determinada etapa do processo.</p>
<p>Seu objetivo é evitar que a equipe comece muitas atividades ao mesmo tempo.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe define um limite de três atividades na coluna "Em andamento".</p>
<p>Se já existirem três cards nessa coluna, a equipe deve procurar concluir ou desbloquear trabalhos antes de iniciar outros.</p>
<p>Isso ajuda a manter o foco e reduzir o acúmulo de tarefas.</p>
<h4>5. Gargalos no fluxo</h4>
<p>Um gargalo acontece quando uma etapa do processo limita o avanço das atividades.</p>
<p>Isso pode causar filas, atrasos e acúmulo de trabalho.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe possui as seguintes etapas:</p>
<p><strong>Desenvolvimento → Testes → Publicação</strong></p>
<p>Os Developers concluem rapidamente as funcionalidades, mas existe pouca capacidade para realizar os testes.</p>
<p>Como resultado, vários cards ficam acumulados na coluna "Testes".</p>
<p>Esse acúmulo indica um possível gargalo.</p>
<p>A equipe pode analisar o problema e buscar melhorias, como redistribuir esforços ou automatizar testes adequados.</p>
<h4>6. Melhoria do fluxo</h4>
<p>O Kanban incentiva a observação e a melhoria contínua do processo.</p>
<p>A equipe pode analisar:</p>
<ul>
<li>Onde as atividades ficam paradas.</li>
<li>Quanto tempo levam para ser concluídas.</li>
<li>Quais etapas possuem acúmulo de trabalho.</li>
<li>Quantas atividades estão em andamento.</li>
<li>Quais mudanças podem melhorar a entrega.</li>
</ul>
<p>O objetivo não é simplesmente fazer mais tarefas, mas melhorar a previsibilidade e a capacidade de entregar valor.</p>
<h4>7. Exemplo completo</h4>
<p>Imagine uma equipe responsável pela manutenção de um sistema.</p>
<p>Seu quadro possui as colunas:</p>
<p><strong>A fazer → Desenvolvimento → Testes → Concluído</strong></p>
<p>O limite de WIP da coluna Desenvolvimento é três.</p>
<p>Durante a semana, os integrantes percebem que muitas tarefas estão aguardando testes.</p>
<p>Em vez de iniciar mais atividades, decidem concentrar esforços na conclusão das tarefas existentes.</p>
<p>Com isso, o fluxo melhora e o acúmulo começa a diminuir.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Kanban:</strong> abordagem para visualizar e melhorar o fluxo de trabalho.</li>
<li><strong>Quadro Kanban:</strong> representa visualmente as etapas das atividades.</li>
<li><strong>Fluxo contínuo:</strong> permite que o trabalho avance conforme a capacidade disponível.</li>
<li><strong>WIP:</strong> quantidade de trabalho em andamento.</li>
<li><strong>Gargalo:</strong> etapa que limita o avanço do trabalho.</li>
<li><strong>Melhoria do fluxo:</strong> análise e adaptação do processo para tornar as entregas mais eficientes e previsíveis.</li>
</ul>', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-8', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Planejamento Ágil'), 'Planejamento Ágil', '<h4>Introdução</h4>
<p>Uma das características das abordagens ágeis é a capacidade de adaptar o planejamento conforme surgem novas informações.</p>
<p>Isso não significa trabalhar sem planejamento.</p>
<p>Pelo contrário, o planejamento ágil ajuda a equipe a definir objetivos, compreender as atividades e organizar entregas de maneira realista.</p>
<p>Entre as práticas utilizadas estão Sprint Planning, Story Points, Planning Poker e planejamento de Sprints e Releases.</p>
<h4>1. O que é planejamento ágil?</h4>
<p>Planejamento ágil é uma forma de organizar o trabalho considerando que mudanças e aprendizados podem acontecer durante o desenvolvimento.</p>
<p>Em vez de tentar prever todos os detalhes do projeto antecipadamente, a equipe planeja em diferentes níveis e atualiza suas decisões conforme necessário.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma empresa deseja criar um sistema de atendimento.</p>
<p>Inicialmente, planeja desenvolver cadastro de clientes, abertura de chamados e relatórios.</p>
<p>Após a primeira entrega, os usuários identificam que o acompanhamento dos chamados é mais importante do que os relatórios.</p>
<p>A equipe pode reavaliar o planejamento das próximas entregas.</p>
<h4>2. Sprint Planning</h4>
<p>O Sprint Planning é o evento de planejamento de uma Sprint no Scrum.</p>
<p>Nele, a equipe define por que a Sprint será valiosa, quais itens poderão ser realizados e como o trabalho será desenvolvido.</p>
<p>O planejamento considera a capacidade da equipe, o trabalho disponível e os resultados anteriores.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe trabalha com Sprints de duas semanas.</p>
<p>Durante o Sprint Planning, seleciona itens relacionados à recuperação de senha.</p>
<p>Os Developers analisam o trabalho e organizam as atividades necessárias para atingir o objetivo da Sprint.</p>
<h4>3. Story Points</h4>
<p>Story Points são uma unidade relativa de estimativa utilizada por algumas equipes ágeis.</p>
<p>Eles ajudam a comparar o esforço de diferentes atividades, considerando fatores como:</p>
<ul>
<li>Complexidade.</li>
<li>Quantidade de trabalho.</li>
<li>Incerteza.</li>
<li>Riscos.</li>
</ul>
<p>Story Points não representam diretamente horas ou dias.</p>
<p>Uma equipe pode utilizar uma sequência como:</p>
<p><strong>1, 2, 3, 5, 8, 13.</strong></p>
<p>Essa sequência é comum, mas não obrigatória.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe estima três funcionalidades:</p>
<table>
<thead><tr><th>Funcionalidade</th><th>Estimativa</th></tr></thead>
<tbody>
<tr><td>Alterar texto de uma tela</td><td>1 ponto</td></tr>
<tr><td>Criar formulário simples</td><td>3 pontos</td></tr>
<tr><td>Integrar sistema de pagamento</td><td>8 pontos</td></tr>
</tbody>
</table>
<p>Esses valores são exemplos e dependem da referência utilizada pela própria equipe.</p>
<h4>4. Planning Poker</h4>
<p>Planning Poker é uma técnica colaborativa de estimativa.</p>
<p>Cada participante escolhe uma carta com o valor que acredita representar o esforço de uma atividade.</p>
<p>As cartas são reveladas simultaneamente para evitar que a opinião de uma pessoa influencie imediatamente as demais.</p>
<p>Quando existem estimativas diferentes, a equipe conversa sobre os motivos e pode realizar uma nova rodada.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe precisa estimar uma funcionalidade de login.</p>
<p>Três Developers apresentam os valores:</p>
<p><strong>3, 5 e 8 pontos.</strong></p>
<p>A pessoa que escolheu 8 explica que existe uma integração externa ainda desconhecida.</p>
<p>Após a conversa, todos compreendem melhor a dificuldade e podem chegar a uma estimativa compartilhada.</p>
<p>O objetivo não é simplesmente obter a média dos valores, mas construir entendimento.</p>
<h4>5. Planejamento de Sprint</h4>
<p>O planejamento de Sprint organiza o trabalho necessário para alcançar um objetivo em um ciclo curto.</p>
<p>Para isso, a equipe considera:</p>
<ul>
<li>Prioridades do produto.</li>
<li>Capacidade disponível.</li>
<li>Complexidade dos itens.</li>
<li>Dependências.</li>
<li>Objetivo da Sprint.</li>
</ul>
<p>Um planejamento adequado evita assumir mais trabalho do que a equipe acredita conseguir realizar.</p>
<p>Mesmo assim, estimativas não são garantias absolutas.</p>
<h4>6. Planejamento de Releases</h4>
<p>Uma Release representa uma versão ou disponibilização do produto.</p>
<p>O planejamento de Releases ajuda a organizar quais funcionalidades poderão ser disponibilizadas e em quais períodos.</p>
<p>Diferentemente da Sprint, a Release não precisa acontecer somente no final de um ciclo.</p>
<p>No Scrum, um Incremento pode ser disponibilizado antes do encerramento da Sprint.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe desenvolve um aplicativo.</p>
<p>Seu planejamento inicial prevê:</p>
<ul>
<li><strong>Release 1:</strong> cadastro e login.</li>
<li><strong>Release 2:</strong> catálogo de produtos.</li>
<li><strong>Release 3:</strong> carrinho e pagamento.</li>
</ul>
<p>Esse planejamento pode ser ajustado conforme o desenvolvimento e o feedback dos usuários.</p>
<h4>7. A importância de revisar o planejamento</h4>
<p>Planejamentos ágeis devem ser acompanhados e atualizados.</p>
<p>Quando surgem dificuldades técnicas, novas necessidades ou mudanças de prioridade, a equipe precisa avaliar seus próximos passos.</p>
<p>A adaptação ajuda a evitar que o projeto continue seguindo decisões que já não fazem sentido.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Planejamento ágil:</strong> planejamento contínuo e adaptável.</li>
<li><strong>Sprint Planning:</strong> evento para planejar a Sprint.</li>
<li><strong>Story Points:</strong> estimativa relativa de esforço, complexidade e incerteza.</li>
<li><strong>Planning Poker:</strong> técnica colaborativa de estimativa.</li>
<li><strong>Planejamento de Sprint:</strong> organização do trabalho de um ciclo.</li>
<li><strong>Planejamento de Releases:</strong> previsão das funcionalidades que poderão ser disponibilizadas em versões do produto.</li>
</ul>', 'https://www.agilealliance.org/glossary/iteration-planning/', 'PB056-9', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Métricas Ágeis'), 'Métricas Ágeis', '<h4>Introdução</h4>
<p>Durante o desenvolvimento de um produto, é importante acompanhar o andamento das atividades e compreender se o trabalho está evoluindo conforme o esperado.</p>
<p>As métricas ágeis ajudam a equipe a observar resultados, identificar dificuldades e tomar decisões com base em informações.</p>
<p>Entretanto, uma métrica não deve ser utilizada isoladamente para julgar a produtividade de uma pessoa.</p>
<p>Seu principal valor está em apoiar o aprendizado e a melhoria do processo.</p>
<p>Entre as métricas mais conhecidas estão Velocity, Burndown Chart, Burnup Chart, Lead Time e Cycle Time.</p>
<h4>1. Velocity — Velocidade da equipe</h4>
<p>Velocity é uma medida utilizada por algumas equipes que trabalham com Sprints.</p>
<p>Ela representa a quantidade de trabalho concluída em uma Sprint, frequentemente medida em Story Points.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe concluiu:</p>
<ul>
<li>Sprint 1: 20 pontos.</li>
<li>Sprint 2: 25 pontos.</li>
<li>Sprint 3: 21 pontos.</li>
</ul>
<p>A média dessas três Sprints é de 22 pontos.</p>
<p>Esse histórico pode ajudar a equipe a planejar o trabalho futuro.</p>
<p>Entretanto, a Velocity não deve ser utilizada para comparar diretamente equipes diferentes, pois cada equipe pode estimar o trabalho de maneira própria.</p>
<h4>2. Burndown Chart</h4>
<p>O Burndown Chart é um gráfico que mostra quanto trabalho ainda falta para ser concluído ao longo do tempo.</p>
<p>Normalmente, o eixo horizontal representa o tempo, enquanto o vertical representa a quantidade de trabalho restante.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma Sprint começa com 20 pontos de trabalho.</p>
<p>Conforme as atividades são concluídas, a quantidade de trabalho restante diminui.</p>
<p>Se a linha permanecer sem alterações por vários dias, a equipe pode investigar se existem bloqueios ou dificuldades.</p>
<h4>3. Burnup Chart</h4>
<p>O Burnup Chart mostra quanto trabalho já foi concluído ao longo do tempo.</p>
<p>Ele também pode apresentar uma linha com o escopo total previsto.</p>
<p>Isso permite visualizar o progresso e perceber mudanças na quantidade total de trabalho.</p>
<p><strong>Exemplo prático</strong></p>
<p>Em um projeto, o escopo aumentou de 30 para 35 pontos durante o desenvolvimento.</p>
<p>O Burnup permite observar tanto o trabalho realizado quanto essa mudança.</p>
<h4>4. Lead Time</h4>
<p>Lead Time é o tempo decorrido desde um ponto inicial definido para uma solicitação até sua entrega.</p>
<p>Em muitos fluxos, ele é medido desde o recebimento da solicitação até a conclusão.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma solicitação foi registrada na segunda-feira e entregue na sexta-feira.</p>
<p>Considerando dias corridos e os instantes correspondentes, o Lead Time pode ser de quatro dias.</p>
<p>O importante é que a equipe utilize critérios consistentes para definir o início e o fim da medição.</p>
<h4>5. Cycle Time</h4>
<p>Cycle Time é o tempo decorrido entre o início efetivo do trabalho em uma atividade e sua conclusão.</p>
<p>Ele ajuda a compreender quanto tempo uma atividade leva depois que começa a ser executada.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma solicitação foi registrada na segunda-feira.</p>
<p>A equipe começou a trabalhar nela na quarta-feira e concluiu na sexta-feira.</p>
<p>Nesse caso, utilizando os mesmos instantes de referência:</p>
<ul>
<li>Lead Time: 4 dias.</li>
<li>Cycle Time: 2 dias.</li>
</ul>
<p>A diferença acontece porque a solicitação aguardou antes de entrar em execução.</p>
<h4>6. Como utilizar as métricas corretamente?</h4>
<p>As métricas devem ajudar a equipe a fazer perguntas importantes.</p>
<p><strong>Por exemplo:</strong></p>
<ul>
<li>Por que determinadas tarefas demoram mais?</li>
<li>Existe alguma etapa acumulando trabalho?</li>
<li>A quantidade de trabalho concluído está estável?</li>
<li>O escopo está aumentando?</li>
</ul>
<p>A equipe precisa analisar o contexto antes de tomar decisões.</p>
<p>Uma Velocity maior, por exemplo, não significa automaticamente que o produto possui mais qualidade ou gera mais valor.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Velocity:</strong> quantidade de trabalho concluído por Sprint, frequentemente em Story Points.</li>
<li><strong>Burndown Chart:</strong> mostra o trabalho restante.</li>
<li><strong>Burnup Chart:</strong> mostra o trabalho concluído e pode apresentar o escopo total.</li>
<li><strong>Lead Time:</strong> tempo desde a solicitação até a entrega, conforme os pontos definidos.</li>
<li><strong>Cycle Time:</strong> tempo desde o início efetivo do trabalho até sua conclusão.</li>
</ul>
<p>As métricas devem apoiar decisões e melhorias, não apenas gerar números.</p>', 'https://kanbanguides.org/the-kanban-guide/2025.5/', 'PB056-10', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Ferramentas para Equipes Ágeis'), 'Ferramentas para Equipes Ágeis', '<h4>Introdução</h4>
<p>Equipes ágeis precisam organizar atividades, acompanhar o progresso e manter uma comunicação clara.</p>
<p>Para facilitar esse trabalho, existem ferramentas digitais que permitem registrar tarefas, visualizar quadros e acompanhar entregas.</p>
<p>Entre as ferramentas utilizadas estão GitHub Projects, Trello, Jira, Azure Boards e GitHub Issues.</p>
<p>Essas ferramentas possuem características diferentes, mas podem apoiar práticas semelhantes de organização e acompanhamento.</p>
<p>É importante lembrar que utilizar uma ferramenta não significa automaticamente trabalhar de maneira ágil.</p>
<p>A agilidade depende principalmente da forma como a equipe colabora, aprende e se adapta.</p>
<h4>1. GitHub Projects</h4>
<p>O GitHub Projects é uma ferramenta de planejamento e acompanhamento de trabalho integrada ao GitHub.</p>
<p>Ela permite organizar itens utilizando visualizações como quadros e tabelas.</p>
<p>A equipe pode acompanhar atividades, utilizar campos personalizados e relacionar o planejamento ao desenvolvimento.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está criando um site.</p>
<p>No GitHub Projects, organiza as atividades:</p>
<ul>
<li>Criar página inicial.</li>
<li>Desenvolver formulário de contato.</li>
<li>Corrigir erro de login.</li>
<li>Testar versão mobile.</li>
</ul>
<p>Os itens podem ser acompanhados conforme avançam pelo fluxo de trabalho.</p>
<h4>2. GitHub Issues</h4>
<p>GitHub Issues é um recurso utilizado para registrar e acompanhar tarefas, problemas, melhorias e solicitações dentro de repositórios do GitHub.</p>
<p>Uma Issue pode conter título, descrição, comentários e outros recursos de organização.</p>
<p><strong>Exemplo prático</strong></p>
<p>Um usuário identifica que o botão "Salvar" não funciona.</p>
<p>A equipe cria uma Issue com a descrição do problema, os passos para reproduzi-lo e o comportamento esperado.</p>
<p>O registro permite acompanhar a correção e manter o histórico da discussão.</p>
<p>GitHub Issues e GitHub Projects podem trabalhar juntos.</p>
<p>As Issues registram atividades e problemas, enquanto o Projects pode ajudar a organizá-los em uma visão mais ampla.</p>
<h4>3. Trello</h4>
<p>O Trello é uma ferramenta visual de organização do trabalho.</p>
<p>Ele utiliza quadros, listas e cartões.</p>
<p>Cada cartão pode representar uma atividade.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe utiliza um quadro com três listas:</p>
<p><strong>A fazer → Em andamento → Concluído</strong></p>
<p>Quando alguém começa uma tarefa, move o cartão para "Em andamento".</p>
<p>Após finalizar, move para "Concluído".</p>
<p>O Trello também permite adicionar descrições, responsáveis, datas e checklists.</p>
<h4>4. Jira</h4>
<p>O Jira é uma ferramenta de gestão de trabalho muito utilizada por equipes de desenvolvimento de software.</p>
<p>Ela oferece recursos para acompanhar tarefas, bugs, histórias de usuário, Sprints e fluxos de trabalho.</p>
<p>Também permite criar quadros e acompanhar relatórios.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe Scrum utiliza o Jira para organizar seu Product Backlog.</p>
<p>Durante o Sprint Planning, seleciona as histórias que pretende desenvolver.</p>
<p>Ao longo da Sprint, acompanha as atividades no quadro e utiliza os relatórios disponíveis para analisar o progresso.</p>
<h4>5. Azure Boards</h4>
<p>O Azure Boards faz parte do conjunto Azure DevOps.</p>
<p>Ele oferece recursos para planejar, organizar e acompanhar o desenvolvimento de produtos.</p>
<p>Entre seus recursos estão itens de trabalho, backlogs, quadros e planejamento de Sprints.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe registra funcionalidades e bugs no Azure Boards.</p>
<p>Os itens são organizados por prioridade e acompanhados durante o desenvolvimento.</p>
<p>A ferramenta ajuda a manter visibilidade sobre o trabalho planejado e realizado.</p>
<h4>6. Quadros e cards</h4>
<p>Independentemente da ferramenta escolhida, dois elementos aparecem com frequência: quadros e cards.</p>
<ul>
<li><strong>Quadros:</strong> representam visualmente o fluxo de trabalho e ajudam a equipe a acompanhar as atividades.</li>
<li><strong>Cards:</strong> representam tarefas, histórias de usuário, problemas ou outras unidades de trabalho.</li>
</ul>
<p>Um card pode conter informações como:</p>
<ul>
<li>Título.</li>
<li>Descrição.</li>
<li>Responsável.</li>
<li>Prioridade.</li>
<li>Prazo, quando aplicável.</li>
<li>Critérios de aceitação.</li>
<li>Comentários.</li>
<li>Status.</li>
</ul>
<p><strong>Exemplo prático</strong></p>
<ul>
<li><strong>Card:</strong> "Implementar recuperação de senha".</li>
<li><strong>Descrição:</strong> permitir que usuários solicitem a redefinição da senha.</li>
<li><strong>Status:</strong> Em desenvolvimento.</li>
<li><strong>Responsável:</strong> Developer designado.</li>
<li><strong>Critérios de aceitação:</strong> apresentar confirmação da solicitação e permitir a redefinição conforme as regras de segurança.</li>
</ul>
<h4>7. Acompanhamento do trabalho</h4>
<p>As ferramentas permitem que a equipe acompanhe as atividades e identifique possíveis dificuldades.</p>
<p>Entretanto, os dados precisam estar atualizados.</p>
<p>Um quadro desatualizado pode transmitir uma visão incorreta do projeto.</p>
<p>Por isso, é importante registrar o andamento real do trabalho e manter as informações compreensíveis.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>GitHub Projects:</strong> organização e acompanhamento de projetos integrados ao GitHub.</li>
<li><strong>GitHub Issues:</strong> registro de tarefas, bugs e solicitações.</li>
<li><strong>Trello:</strong> organização visual com quadros, listas e cartões.</li>
<li><strong>Jira:</strong> gestão de atividades, backlogs e Sprints.</li>
<li><strong>Azure Boards:</strong> planejamento e acompanhamento de trabalho no Azure DevOps.</li>
</ul>
<p>As ferramentas apoiam a organização, mas não substituem a colaboração e as boas práticas ágeis.</p>', 'https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects', 'PB056-11', TRUE)
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
VALUES ((SELECT idtemas FROM temas WHERE nome = 'Boas Práticas em Projetos Ágeis'), 'Boas Práticas em Projetos Ágeis', '<h4>Introdução</h4>
<p>Utilizar Scrum, Kanban ou ferramentas de gerenciamento não garante, por si só, que um projeto será bem-sucedido.</p>
<p>A maneira como as pessoas trabalham juntas possui grande influência nos resultados.</p>
<p>Projetos ágeis valorizam a comunicação, a colaboração, o feedback contínuo, a melhoria contínua, a transparência e a adaptação.</p>
<p>Essas práticas ajudam a equipe a identificar dificuldades, aprender com a experiência e entregar produtos que atendam às necessidades dos usuários.</p>
<h4>1. Comunicação</h4>
<p>A comunicação é essencial para que todos compreendam os objetivos, as prioridades e o andamento do trabalho.</p>
<p>Quando as informações não são compartilhadas adequadamente, podem surgir dúvidas, erros e retrabalho.</p>
<p>Uma boa comunicação deve ser clara, objetiva e respeitosa.</p>
<p><strong>Exemplo prático</strong></p>
<p>Um Developer identifica que uma funcionalidade não poderá ser concluída conforme o planejamento.</p>
<p>Em vez de esperar até o final da Sprint, comunica a dificuldade à equipe.</p>
<p>Assim, todos podem avaliar alternativas e reorganizar o trabalho.</p>
<h4>2. Colaboração</h4>
<p>Colaborar significa trabalhar em conjunto para alcançar objetivos compartilhados.</p>
<p>Em equipes ágeis, as pessoas devem contribuir com seus conhecimentos e ajudar umas às outras quando necessário.</p>
<p>Isso não significa que todos precisam executar as mesmas atividades, mas que existe responsabilidade compartilhada pelo resultado.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe está desenvolvendo uma funcionalidade de pagamento.</p>
<p>O Developer responsável pela integração encontra uma dificuldade.</p>
<p>Outro integrante, que possui experiência com a tecnologia utilizada, ajuda a analisar o problema.</p>
<p>Essa colaboração pode reduzir atrasos e melhorar a qualidade da solução.</p>
<h4>3. Feedback contínuo</h4>
<p>Feedback é uma informação recebida sobre um resultado, comportamento ou processo.</p>
<p>Em projetos ágeis, o feedback ajuda a identificar o que funciona bem e o que precisa ser melhorado.</p>
<p>Ele pode vir de clientes, usuários, integrantes da equipe ou outras pessoas envolvidas.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe desenvolve uma nova tela de cadastro.</p>
<p>Após apresentar a funcionalidade, os usuários informam que alguns campos estão confusos.</p>
<p>A equipe utiliza essas informações para melhorar a experiência.</p>
<p>Receber feedback cedo pode evitar que problemas sejam descobertos apenas depois de grandes investimentos no desenvolvimento.</p>
<h4>4. Melhoria contínua</h4>
<p>A melhoria contínua é a prática de analisar frequentemente a forma de trabalhar e buscar ajustes que possam produzir resultados melhores.</p>
<p>Ela não exige mudanças grandes ou complexas.</p>
<p>Pequenas melhorias podem gerar benefícios importantes ao longo do tempo.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe percebe que muitas tarefas precisam ser refeitas porque os requisitos não estão claros.</p>
<p>Após analisar o problema, decide incluir critérios de aceitação mais objetivos antes de iniciar determinadas funcionalidades.</p>
<p>Nas entregas seguintes, observa se essa mudança reduziu o retrabalho.</p>
<h4>5. Transparência</h4>
<p>Transparência significa manter as informações importantes visíveis e compreensíveis para as pessoas envolvidas.</p>
<p>Isso inclui objetivos, prioridades, progresso e dificuldades.</p>
<p>A transparência ajuda a equipe a tomar decisões com base na situação real do projeto.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma equipe utiliza um quadro de atividades.</p>
<p>Algumas tarefas estão atrasadas.</p>
<p>Em vez de manter essas informações ocultas, os responsáveis atualizam o quadro e comunicam os impedimentos.</p>
<p>Assim, a equipe consegue analisar o problema e buscar soluções.</p>
<h4>6. Adaptação</h4>
<p>Adaptação é a capacidade de realizar mudanças quando novas informações mostram que o planejamento ou a solução precisam ser ajustados.</p>
<p>Essa prática é especialmente importante em projetos complexos, nos quais nem todas as necessidades são conhecidas desde o início.</p>
<p><strong>Exemplo prático</strong></p>
<p>Uma empresa desenvolve um sistema de agendamentos.</p>
<p>Inicialmente, a equipe acredita que a funcionalidade mais importante será permitir agendamentos pelo computador.</p>
<p>Após testar o produto, descobre que a maioria dos usuários acessa o sistema pelo celular.</p>
<p>Com base nessa informação, a equipe pode adaptar suas prioridades e melhorar a experiência em dispositivos móveis.</p>
<h4>7. Como essas boas práticas trabalham juntas?</h4>
<p>Imagine que uma equipe esteja desenvolvendo um sistema de controle de estoque.</p>
<p>Durante os testes, os usuários informam que a consulta de produtos está lenta.</p>
<p>A equipe compartilha essa informação, demonstrando comunicação e transparência.</p>
<p>Os Developers trabalham juntos para investigar a causa, praticando colaboração.</p>
<p>O feedback dos usuários ajuda a compreender o impacto do problema.</p>
<p>A equipe modifica a solução, aplicando adaptação.</p>
<p>Depois, analisa o que pode ser melhorado no processo para evitar situações semelhantes, praticando melhoria contínua.</p>
<p>Esse exemplo demonstra como as boas práticas se complementam.</p>
<h4>8. O que pode prejudicar uma equipe ágil?</h4>
<p>Alguns comportamentos podem dificultar o desenvolvimento:</p>
<ul>
<li>Falta de comunicação.</li>
<li>Prioridades pouco claras.</li>
<li>Excesso de atividades simultâneas.</li>
<li>Resistência ao feedback.</li>
<li>Falta de colaboração.</li>
<li>Problemas ocultados.</li>
<li>Ausência de acompanhamento e melhoria.</li>
</ul>
<p>Reconhecer essas dificuldades é o primeiro passo para buscar soluções.</p>
<p>O objetivo das boas práticas não é eliminar completamente os problemas, mas permitir que a equipe consiga identificá-los e lidar com eles de maneira mais eficaz.</p>
<h4>Para lembrar</h4>
<ul>
<li><strong>Comunicação:</strong> compartilhar informações de forma clara e respeitosa.</li>
<li><strong>Colaboração:</strong> trabalhar em conjunto para alcançar objetivos.</li>
<li><strong>Feedback contínuo:</strong> receber e utilizar informações para melhorar o produto e o trabalho.</li>
<li><strong>Melhoria contínua:</strong> analisar resultados e aperfeiçoar processos.</li>
<li><strong>Transparência:</strong> manter informações importantes visíveis e compreensíveis.</li>
<li><strong>Adaptação:</strong> realizar mudanças quando necessário.</li>
</ul>
<p>Essas práticas ajudam as equipes a desenvolver produtos com mais qualidade, organização e capacidade de resposta às mudanças.</p>', 'https://www.agilealliance.org/glossary/definition-of-done/', 'PB056-12', TRUE)
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
