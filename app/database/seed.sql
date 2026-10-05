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
);

ON CONFLICT (nome) DO NOTHING;

COMMIT;