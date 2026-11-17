# Sprint 2 — Review, retrospectiva e Definition of Done

Registro técnico consolidado em 06/11/2026. Ele prepara a cerimônia, mas não
substitui a confirmação de participantes, decisões e aceite do PO.

## Sprint Review

**Data da cerimônia:** pendente de registro.
**Participantes e PO:** pendentes de registro.

| Demonstração | Evidência disponível | Situação técnica |
|---|---|---|
| Criar ou recuperar tentativa | API, schema e testes de autorização | Verificada |
| Selecionar uma questão por tema | Persistência do sorteio e testes de carga | Verificada |
| Exibir questão, imagem e quatro alternativas | Interface integrada e 48 imagens com texto alternativo | Verificada |
| Controlar prazo de 150 segundos | Prazo do servidor, timeout e bloqueio | Verificada |
| Registrar primeira resposta válida | Operação idempotente e proteção contra reenvio | Verificada |
| Pausar e retomar | Sessão da prova, próxima questão pendente e continuidade | Verificada |
| Tratar recarga, fechamento e perda de conexão | Testes do cliente e validação no servidor | Verificada com limitação de navegador documentada |
| Calcular acertos, percentual e situação | Backend e histórico persistido | Verificada |
| Consultar histórico próprio | Listagem e detalhe isolados por candidato | Verificada |
| Mostrar resposta correta imediatamente | Issue #48 | Pendente |

### Resultado da Sprint

O núcleo da certificação foi integrado à `main`. No encerramento oficial havia
33 SP pendentes; 30 SP foram regularizados em 06/11. A Sprint permanece com 3
SP de dívida técnica na issue #48. O aceite do PO não deve ser inferido somente
pelo fechamento das demais issues.

### Roteiro sugerido da demonstração

1. Entrar como candidato e revisar a área de estudos.
2. Iniciar a certificação e confirmar a tentativa ativa.
3. Abrir uma questão e observar o prazo de 150 segundos.
4. Responder, bloquear reenvio e escolher continuar ou pausar.
5. Retomar a tentativa sem trocar as questões sorteadas.
6. Finalizar os 12 temas e conferir acertos, percentual e aprovação.
7. Abrir o histórico e validar resposta escolhida, gabarito e data/hora.
8. Registrar como pendente o feedback imediato da resposta correta (#48).

## Retrospectiva

### O que funcionou

- Integração gradual de frontend, API, funções transacionais e schema.
- Testes cobrindo autorização, continuidade, histórico e exposição de dados.
- Consolidação das alterações de banco em `schema.sql` e `seed.sql`.
- Divisão clara das frentes de prova, continuidade, histórico e imagens.
- Regularização, na Sprint 2, dos 38 SP carregados da Sprint 1.

### O que dificultou

- Issues da Sprint 2 foram abertas apenas em 29 e 30/10, reduzindo a qualidade
  do acompanhamento diário do GitHub Projects.
- Grande volume de fechamento ocorreu nos dois últimos dias.
- A Sprint combinou 114 SP novos com 38 SP herdados da Sprint 1.
- Parte da validação PostgreSQL depende de Docker e ficou ignorada no ambiente.
- Documentos intermediários ficaram desatualizados após a integração final.

### Ações para a Sprint 3

| Ação | Evidência esperada | Responsável/prazo |
|---|---|---|
| Concluir #48 | Feedback correto após resposta, sem vazar gabarito antes do encerramento | Isabella, Rogiel e Julio |
| Atualizar o Project diariamente | Histórico confiável para burndown, sem reconstrução posterior | Equipe / durante a Sprint |
| Executar testes PostgreSQL com Docker | 28 testes executados, sem skips ou falhas | A definir |
| Registrar aceite e revisão | Participantes, decisão do PO e itens não aceitos | A definir na Review |
| Manter documentos sincronizados | README, Daily, Review e evidências coerentes com a `main` | A definir |

## Definition of Done

| Critério | Estado em 06/11 |
|---|---|
| Critérios funcionais implementados | Atendidos, exceto PB-027/#48 |
| Código integrado à `main` | Atendido — commit verificado `1643267` |
| Frontend, backend e banco integrados | Atendido no fluxo versionado |
| Testes automatizados | 25 aprovados, 0 falhas, 3 ignorados sem Docker |
| Banco reproduzível | `schema.sql` e `seed.sql` consolidados |
| Autorização e isolamento por candidato | Cobertos por testes |
| Interface desktop e responsiva | Implementada; aceite visual formal não registrado |
| Revisão por outro integrante | Evidência formal pendente |
| Aceite do PO | Pendente de registro |
| Documentação atualizada | Atualizada por este conjunto de documentos |

## Decisões a registrar na cerimônia

- aceite ou não aceite do incremento;
- tratamento da issue #48 na Sprint 3;
- responsáveis pelos testes Docker e pela revisão editorial;
- mudanças no Product Backlog;
- participantes e data efetiva da Review e da Retrospectiva.
