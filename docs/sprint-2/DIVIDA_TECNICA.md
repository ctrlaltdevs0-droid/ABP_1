# Dívida técnica da Sprint 1 — execução na Sprint 2

Referência: `SPRINT_2_AGILCERT_PLANEJAMENTO (1).md` em Downloads, seção 4.
Preservados os seis IDs e suas issues originais. Nenhuma issue foi criada ou fechada.

| PBI / issue | Implementação | Aceite ainda necessário |
|---|---|---|
| PB-006 / #7 | Seed dos 12 temas por nome, com ordem estável e repetição sem duplicação | Conferir os temas com o PO no ambiente utilizado |
| PB-053 / #20 | 48 questões, 4 por tema, 4 alternativas e 1 correta; status editorial e carga repetível | Revisão cruzada e aprovação editorial antes da ativação |
| PB-056 / #21 | 12 materiais com explicação, exemplo, exercício e recurso complementar | Comparar com o material da #22 e revisão por outro integrante |
| PB-016 / #17 | Página de estudos com lista, busca e leitura de material; layout responsivo e links complementares | Demonstração com candidatos e aceite visual |
| PB-017 / #18 | Conclusão persistida no banco, dono obtido pelo JWT, gravação idempotente | Aplicar migração no ambiente de uso |
| PB-018 / #19 | Estados concluído/pendente e indicador geral recuperados da API | Demonstração após novo login no ambiente de uso |

O repositório local não continha materiais de estudos além das descrições dos
temas. Os registros remotos da #22 não foram recuperados nesta execução;
conciliação editorial permanece explícita. As cargas não apagam conteúdo nem
sobrescrevem materiais já identificados pelo código da carga.
Não declarar PB-053/PB-056 como Done sem revisão e aceite da equipe.

## Validação técnica

- `npm test` no backend: API HTTP, cliente web, 12 materiais/48 questões,
  isolamento por candidato, nova leitura da conclusão, repetição, autenticação,
  tema indisponível e falha de banco.
- PostgreSQL local temporário: schema, migração e duas execuções das cargas;
  `backend/database/validar-estudos.sql` confere contagem e gabaritos.
- Navegador Chrome: lista, busca, leitura, conclusão e recarga em 1440px e 390px,
  com respostas simuladas da API; verificado sem rolagem horizontal.
- Corrigido marcador de conflito preexistente em `assets/js/config.js`; a API
  usa a mesma origem por padrão.
- A chave secreta permanece no servidor. A nova tabela usa RLS e não concede
  acesso a `anon` ou `authenticated`: o login usa JWT próprio, não Supabase Auth.

## Fontes do material

Textos e questões autorais de apoio didático; links complementares por tema:
[Manifesto Ágil](https://agilemanifesto.org/iso/ptbr/manifesto.html),
[Scrum Guide](https://scrumguides.org/scrum-guide.html),
[Kanban Guide](https://kanbanguides.org/the-kanban-guide/2025.5/),
[Agile Alliance](https://www.agilealliance.org/agile101/),
[GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects).

As questões entram como rascunho inativo. As imagens da prova (PB-054) e o
motor da certificação são escopo novo, fora dos seis débitos solicitados.

## Correções de segurança posteriores

As correções S01–S06 estão descritas em
[CORRECOES_SEGURANCA.md](CORRECOES_SEGURANCA.md), com migração e testes próprios.
Elas não substituem revisão editorial, conciliação com a issue #22, demonstração
com candidatos ou aceite do PO. Esses aceites permanecem pendentes.
