# Coerência entre conteúdos e avaliações (PB-057)

- **Issue:** #88
- **Data da verificação:** 16/11/2026
- **Requisitos do desafio:** RP07 (coerência entre o material didático e as questões) e RNF08 (qualidade da base de questões)
- **O que foi comparado:**
  - as 48 questões em `backend/scripts/data/content-estudos.json`;
  - o material "Cursos - ABP", escrito pela equipe, que é a fonte dos textos, das questões e das imagens;
  - o texto de estudo de cada tema que o portal exibe (campo `texto` do mesmo arquivo, carregado pelo `seed.sql`).

## Como a verificação foi feita

Para cada questão, foram conferidos três pontos:

1. **Tema:** a questão pertence ao tema em que está cadastrada.
2. **Material de origem:** a resposta correta é ensinada no material "Cursos - ABP", e em qual seção.
3. **Texto do portal:** o candidato encontra essa resposta no texto de estudo do tema antes de fazer a prova.

## Resultado

- **48 de 48** questões estão no tema certo e têm a resposta ensinada no material "Cursos - ABP". Os enunciados, as alternativas e os gabaritos são iguais aos do documento.
- Os 12 temas do portal correspondem aos temas 1, 3 a 11, 14 e 15 da tabela de sugestões do desafio, e as questões cobram o conteúdo indicado para cada um.
- **Divergência encontrada:** o texto de estudo que o portal exibia era um resumo diferente do material "Cursos - ABP". Com ele, 23 questões tinham a resposta no texto do tema, 14 tinham só em parte e 11 cobravam um assunto que o texto não apresentava.
- **Depois da correção:** os 12 textos de estudo passaram a seguir o material "Cursos - ABP", e as **48 questões** têm a resposta no texto do seu tema.
- Nenhuma questão foi alterada, então o histórico das provas já feitas continua igual.

## Tabela da verificação

Legenda da coluna "Texto anterior": ✅ o texto ensinava a resposta · ⚠️ a ideia aparecia, mas o termo cobrado na questão não · ❌ o assunto não aparecia.

| Código | Assunto cobrado | Seção do material "Cursos - ABP" | Texto anterior | Texto atual |
|---|---|---|---|---|
| PB053-1-1 | Crise do Software | 1. A Crise do Software | ❌ | ✅ |
| PB053-1-2 | Modelo Cascata | 2. Desenvolvimento Tradicional × Ágil | ❌ | ✅ |
| PB053-1-3 | O que é ser ágil | 3. Agilidade não significa fazer tudo mais rápido | ✅ | ✅ |
| PB053-1-4 | Benefícios da agilidade | 4. Benefícios da Agilidade | ✅ | ✅ |
| PB053-2-1 | Scrum como framework | 1. O que é um Framework? | ✅ | ✅ |
| PB053-2-2 | Empirismo | 2. O que é Empirismo? | ⚠️ | ✅ |
| PB053-2-3 | Os três pilares | Os três pilares do Scrum | ❌ | ✅ |
| PB053-2-4 | Adaptação | 5. Adaptação | ⚠️ | ✅ |
| PB053-3-1 | Product Owner | 2. Product Owner | ✅ | ✅ |
| PB053-3-2 | Scrum Master | 3. Scrum Master | ✅ | ✅ |
| PB053-3-3 | Quem cria o Sprint Backlog | 4. Developers | ⚠️ | ✅ |
| PB053-3-4 | Interação do Scrum Team | 5. Como os três papéis trabalham juntos? | ✅ | ✅ |
| PB053-4-1 | Duração máxima da Sprint | 1. Sprint | ❌ | ✅ |
| PB053-4-2 | Sprint Planning | 2. Sprint Planning | ✅ | ✅ |
| PB053-4-3 | Daily Scrum | 3. Daily Scrum | ✅ | ✅ |
| PB053-4-4 | Review × Retrospective | 4. Sprint Review e 5. Sprint Retrospective | ✅ | ✅ |
| PB053-5-1 | Product Backlog | 1. Product Backlog | ✅ | ✅ |
| PB053-5-2 | Composição do Sprint Backlog | 3. Sprint Backlog | ⚠️ | ✅ |
| PB053-5-3 | Incremento | 5. Incremento | ⚠️ | ✅ |
| PB053-5-4 | Definition of Done | 6. Definition of Done | ⚠️ | ✅ |
| PB053-6-1 | Finalidade da User Story | 1. O que é uma User Story? | ✅ | ✅ |
| PB053-6-2 | Como... Quero... Para... | 2. Estrutura de uma User Story | ✅ | ✅ |
| PB053-6-3 | Critérios de aceitação | 3. Critérios de aceitação | ✅ | ✅ |
| PB053-6-4 | User Story bem estruturada | 2. Estrutura e 5. User Story × tarefa técnica | ✅ | ✅ |
| PB053-7-1 | Responsável pelo Product Backlog | 1. O que é a gestão do Product Backlog? | ⚠️ | ✅ |
| PB053-7-2 | Priorização | 2. Priorização do Product Backlog | ✅ | ✅ |
| PB053-7-3 | Refinamento | 3. Refinamento do Product Backlog | ✅ | ✅ |
| PB053-7-4 | Evolução do backlog | 5. Evolução do Product Backlog | ✅ | ✅ |
| PB053-8-1 | Quadro Kanban | 2. Quadro Kanban | ✅ | ✅ |
| PB053-8-2 | Significado de WIP | 4. Limites de WIP | ⚠️ | ✅ |
| PB053-8-3 | Gargalo | 5. Gargalos no fluxo | ✅ | ✅ |
| PB053-8-4 | Melhoria do fluxo | 4. Limites de WIP e 6. Melhoria do fluxo | ✅ | ✅ |
| PB053-9-1 | Planejamento ágil | 1. O que é planejamento ágil? | ✅ | ✅ |
| PB053-9-2 | Story Points | 3. Story Points | ❌ | ✅ |
| PB053-9-3 | Planning Poker | 4. Planning Poker | ❌ | ✅ |
| PB053-9-4 | Planejamento de Releases | 6. Planejamento de Releases | ❌ | ✅ |
| PB053-10-1 | Velocity | 1. Velocity | ❌ | ✅ |
| PB053-10-2 | Burndown Chart | 2. Burndown Chart | ⚠️ | ✅ |
| PB053-10-3 | Lead Time × Cycle Time | 4. Lead Time e 5. Cycle Time | ⚠️ | ✅ |
| PB053-10-4 | Uso correto das métricas | 6. Como utilizar as métricas corretamente? | ✅ | ✅ |
| PB053-11-1 | GitHub Issues | 2. GitHub Issues | ❌ | ✅ |
| PB053-11-2 | Trello | 3. Trello | ❌ | ✅ |
| PB053-11-3 | Jira, Azure Boards e GitHub Projects | 1. GitHub Projects, 4. Jira e 5. Azure Boards | ❌ | ✅ |
| PB053-11-4 | Boa prática com quadros e cards | 7. Acompanhamento do trabalho | ⚠️ | ✅ |
| PB053-12-1 | Comunicação | 1. Comunicação | ⚠️ | ✅ |
| PB053-12-2 | Colaboração | 2. Colaboração | ⚠️ | ✅ |
| PB053-12-3 | Feedback contínuo | 3. Feedback contínuo | ⚠️ | ✅ |
| PB053-12-4 | Melhoria contínua e adaptação | 4. Melhoria contínua e 6. Adaptação | ✅ | ✅ |

## Divergências

1. **Texto de estudo incompleto no portal.** Os textos em `content-estudos.json` não traziam os conceitos marcados com ❌ e ⚠️ na tabela. Um candidato que estudasse só pelo portal encontraria na prova termos que não viu, como Crise do Software, Story Points, Planning Poker, Velocity, Trello e Jira.
2. **Formatação do texto de estudo.** A página de estudos insere o texto como HTML. Como o texto da carga usava apenas quebras de linha, os três parágrafos de cada tema apareciam juntos em um bloco só.
3. **Nomes dos temas no README principal.** O README listava "Papéis no Scrum", "Product Backlog", "Ferramentas Ágeis" e "Boas Práticas"; no banco e na prova os nomes são "Papéis do Scrum", "Gestão do Product Backlog", "Ferramentas para Equipes Ágeis" e "Boas Práticas em Projetos Ágeis".

## Ambiguidade

- Lidas junto com o material "Cursos - ABP", as 48 questões têm uma única alternativa correta.
- A sugestão 1 da [revisão da PB-055](REVISAO_QUESTOES.md) (questão PB053-10-2, Burndown × Burnup) deixa de ser um risco: o texto de estudo agora traz as duas definições do material. O Burndown mostra o trabalho que falta e o Burnup mostra o trabalho concluído.

## Correções realizadas

| Divergência | Correção | Arquivos |
|---|---|---|
| 1 e 2 | O campo `texto` dos 12 temas passou a trazer o conteúdo do material "Cursos - ABP", em HTML simples (títulos, parágrafos, listas e tabelas) | `backend/scripts/data/content-estudos.json` |
| 1 e 2 | Carga do banco regenerada com `npm run seed:gerar` | `backend/database/seed.sql` |
| 2 | Estilo para títulos, listas e tabelas do texto de estudo | `frontend/src/assets/css/estudos.css` |
| 3 | Nomes dos 12 temas iguais aos do banco | `README.md` |

O que **não** entrou nos textos do portal:

- **Figuras e infográficos** do material. A página de estudos aceita hoje uma imagem por tema, pelo campo `recurso_url`, que está em uso para o link complementar.
- **Quizzes** do material. As 48 questões já aparecem no quiz de fixação e na prova.
- **Gráficos de exemplo** de Burndown e Burnup, que eram imagens. A explicação dos dois gráficos foi mantida.

### Conferência depois da correção

- Para cada uma das 48 questões, foi buscado no texto do tema o termo central da resposta correta (por exemplo, "Crise do Software", "Planning Poker", "Work in Progress"). Os 48 termos foram encontrados.
- `npm test` em `backend`: 28 testes, 25 aprovados, 0 falhas e 3 ignorados (os três exigem PostgreSQL em Docker). O teste da carga confirma 12 materiais, 48 questões e o `seed.sql` igual ao gerado.

### Bancos que já têm os conteúdos

O `seed.sql` não sobrescreve um conteúdo que já existe (`ON CONFLICT (codigo_seed) DO NOTHING`). Um banco novo recebe os textos atualizados. Em um banco que já tem a carga anterior, como o Supabase do grupo ou um volume antigo do Docker, é preciso remover os 12 materiais da carga e executar o `seed.sql` de novo:

```sql
DELETE FROM conteudos WHERE codigo_seed LIKE 'PB056-%';
-- depois, executar backend/database/seed.sql
```

O comando apaga somente os 12 materiais criados pela carga. Nenhuma outra tabela referencia `conteudos`, então progresso de estudos, tentativas e histórico não são afetados. **Este passo ainda não foi executado no Supabase do grupo.**

## Histórico das provas

As questões, as alternativas e os gabaritos não foram alterados. As correções tratam apenas do texto de estudo, que não faz parte do registro das tentativas, então o histórico das provas já realizadas fica preservado.
