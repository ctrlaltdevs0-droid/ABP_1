# Sprint 2 — planejamento, backlog e estado final

**Projeto:** Portal ÁgilCert
**Equipe:** CTRL ALT DEVS
**Período:** 23/10/2026 a 05/11/2026
**Meta:** entregar uma prova completa, segura e retomável, com uma questão por
tema, prazo de 150 segundos controlado pelo servidor, resultado e histórico.
**Escopo:** 28 PBIs e 114 Story Points.

Este documento consolida o refinamento, as issues do milestone Sprint 2 e a
situação observada no GitHub em 06/11/2026.

## Sprint Goal e resultado demonstrável

O candidato inicia uma tentativa com 12 temas, responde uma questão por tema,
pode pausar e retomar sem reiniciar o prazo, conclui a prova e consulta resultado
e histórico. Atualização, fechamento e perda de conexão não podem liberar nova
resposta nem trocar a questão sorteada.

## Escopo planejado

| Grupo | PBIs | SP |
|---|---|---:|
| Montagem da prova | PB-019 a PB-024 | 21 |
| Execução da questão | PB-025 a PB-030 | 26 |
| Persistência e retomada | PB-031 a PB-036 | 31 |
| Resultado e histórico | PB-037 a PB-045 | 23 |
| Imagens | PB-054 | 13 |
| **Total** | **28 PBIs** | **114** |

## Backlog e responsáveis

| PBI | Issue | SP | Responsáveis registrados | Estado em 06/11 |
|---|---:|---:|---|---|
| PB-019 | #40 | 5 | isabella0andreotti, AlvesRogiel | Concluída |
| PB-020 | #41 | 5 | AlvesRogiel | Concluída |
| PB-021 | #42 | 5 | JulioCesarP95, AlvesRogiel | Concluída |
| PB-022 | #43 | 2 | palomavelosodasilva-collab, melomiriele | Concluída |
| PB-023 | #44 | 2 | isabella0andreotti, vitoria-gabriely, Evellyn3103, AlvesRogiel | Concluída |
| PB-024 | #45 | 2 | isabella0andreotti, AlvesRogiel | Concluída |
| PB-025 | #46 | 5 | isabella0andreotti, vitoria-gabriely, Evellyn3103 | Concluída em 06/11 |
| PB-026 | #47 | 5 | isabella0andreotti, AlvesRogiel | Concluída em 06/11 |
| PB-027 | #48 | 3 | isabella0andreotti, AlvesRogiel, JulioCesarP95 | **Aberta — dívida técnica** |
| PB-028 | #49 | 5 | isabella0andreotti, AlvesRogiel | Concluída em 06/11 |
| PB-029 | #50 | 5 | isabella0andreotti, AlvesRogiel | Concluída em 06/11 |
| PB-030 | #51 | 3 | JulioCesarP95 | Concluída |
| PB-031 | #52 | 3 | JulioCesarP95 | Concluída |
| PB-032 | #53 | 5 | JulioCesarP95 | Concluída |
| PB-033 | #54 | 8 | JulioCesarP95 | Concluída |
| PB-034 | #55 | 5 | JulioCesarP95 | Concluída |
| PB-035 | #56 | 5 | JulioCesarP95 | Concluída |
| PB-036 | #57 | 5 | JulioCesarP95 | Concluída em 06/11 |
| PB-037 | #58 | 3 | JulioCesarP95 | Concluída em 06/11 |
| PB-038 | #59 | 2 | JulioCesarP95, isabella0andreotti, vitoria-gabriely, AlvesRogiel | Concluída em 06/11 |
| PB-039 | #60 | 2 | JulioCesarP95, AlvesRogiel | Concluída |
| PB-040 | #61 | 5 | JulioCesarP95, isabella0andreotti, palomavelosodasilva-collab, AlvesRogiel | Concluída |
| PB-041 | #62 | 2 | isabella0andreotti, AlvesRogiel, melomiriele | Concluída |
| PB-042 | #63 | 2 | melomiriele | Concluída |
| PB-043 | #64 | 2 | melomiriele | Concluída |
| PB-044 | #65 | 2 | melomiriele | Concluída |
| PB-045 | #66 | 3 | melomiriele | Concluída |
| PB-054 | #67 | 13 | melomiriele | Concluída |

## Resultado do período

Em 05/11, 20 PBIs estavam fechados e 8 continuavam abertos, totalizando 33 SP.
Em 06/11, sete desses itens, equivalentes a 30 SP, foram concluídos. Permaneceu
aberta apenas a #48, com 3 SP.

A Sprint também absorveu 38 SP de dívida da Sprint 1: PB-006, PB-016, PB-017,
PB-018, PB-053 e PB-056. Esse trabalho não altera retroativamente a estimativa
original de 114 SP.

## Critérios técnicos verificados

- tentativa pertencente ao candidato autenticado;
- 12 temas e uma questão persistida por tema;
- quatro alternativas e somente uma correta;
- prazo de 150 segundos controlado no servidor;
- primeira resposta válida e bloqueio de reenvio;
- timeout, pausa, retomada, recarga e perda de conexão;
- cálculo de acertos, percentual e aprovação mínima de 65%;
- histórico isolado por candidato e detalhe das respostas;
- 48 questões com imagem e texto alternativo;
- schema e carga consolidados em `backend/database/schema.sql` e `seed.sql`.

## Pendências legítimas

- #48: mostrar a alternativa correta imediatamente após encerrar a questão;
- executar os três testes PostgreSQL condicionais em ambiente com Docker;
- registrar revisão formal por integrante e aceite do PO na cerimônia;
- validar novamente o ambiente Supabase usado na apresentação, sem assumir que
  o estado remoto permaneceu inalterado.

## Referências

- [Refinamento das três sprints](../geral/refinamento/REFINAMENTO_3_SPRINTS_CTRL_ALT_DEVS.md)
- [Review, retrospectiva e DoD](REVIEW_RETROSPECTIVA_DOD.md)
- [Validação técnica](evidencias/VALIDACAO_SPRINT_2.md)
- [Burndown](BURNDOWN.md)
