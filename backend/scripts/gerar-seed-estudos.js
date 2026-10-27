import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const seedTemas = `BEGIN;

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

COMMIT;   `;
const validacao = `DO $validacao$
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
END $validacao$;
SELECT 'Carga validada: 12 temas, 12 materiais, 48 questões, 192 alternativas' AS resultado;
`;

export async function gerarSeed() {
  const temas = JSON.parse(await readFile(new URL('./data/content-estudos.json', import.meta.url), 'utf8'));
  if (temas.length !== 12 || new Set(temas.map(t => t.nome)).size !== 12) throw new Error('São necessários 12 temas únicos.');
  const sql = texto => "'" + texto.replaceAll("'", "''") + "'";
  const statements = ['-- Carga de estudos gerada a partir de scripts/data/content-estudos.json.', 'BEGIN;'];
  temas.forEach((tema, index) => {
    if (!tema.texto || !/^https:\/\//.test(tema.recurso) || tema.questoes.length !== 4) throw new Error(`Tema incompleto: ${tema.nome}`);
    const temaId = `(SELECT idtemas FROM temas WHERE nome = ${sql(tema.nome)})`;
    statements.push(`INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES (${temaId}, ${sql(tema.nome)}, ${sql(tema.texto)}, ${sql(tema.recurso)}, 'PB056-${index + 1}', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;`);
    tema.questoes.forEach((questao, i) => {
      if (questao.length !== 5 || new Set(questao.slice(1)).size !== 4 || questao[0].length > 400 || questao.slice(1).some(t => !t || t.length > 200)) throw new Error(`Questão inválida: ${tema.nome}/${i + 1}`);
      const codigo = `PB053-${index + 1}-${i + 1}`;
      // Um bloco insere questão e alternativas junto; a repetição preserva edições e revisão editorial.
      statements.push(`DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES (${temaId}, ${sql(questao[0])}, '${codigo}', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    ${Array.from({ length: 4 }, (_, j) => {
      const correta = (index + i) % 4;
      const pos = (j - correta + 4) % 4;
      return `(questao_id, '${'ABCD'[j]}', ${sql(questao[pos + 1])}, ${j === correta ? 'TRUE' : 'FALSE'})`;
    }).join(',\n    ')};
  END IF;
END $seed$;`);
    });
  });
  statements.push('COMMIT;');
  return seedTemas + '\n\n' + statements.join('\n\n') + '\n\n' + validacao;
}
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await writeFile(new URL('../database/seed.sql', import.meta.url), await gerarSeed());
}
