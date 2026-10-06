<div align="center">

# 🟢 CTRL ALT DEVS

## PRODUCT BACKLOG — PORTAL DE CERTIFICAÇÃO EM METODOLOGIAS ÁGEIS

**BUILD `>` FIX `>` REPEAT**

![Identidade](https://img.shields.io/badge/IDENTIDADE-CTRL_ALT_DEVS-39FF70?style=for-the-badge&labelColor=101414)
![Projeto](https://img.shields.io/badge/PROJETO-DESAFIO_1DSM_2026--2-F5F7F6?style=for-the-badge&labelColor=101414)
![Status](https://img.shields.io/badge/STATUS-PRODUCT_BACKLOG-39FF70?style=for-the-badge&labelColor=101414)

</div>

---

> **Documento de planejamento**  
> Backlog elaborado a partir dos requisitos do **Desafio 1DSM — 2026/2**. As prioridades e estimativas em Story Points são propostas iniciais e devem ser refinadas pela equipe.

## Sumário

1. [Visão do produto](#1-visão-do-produto)
2. [Decisões e pontos de atenção](#2-decisões-e-pontos-de-atenção)
3. [Legenda](#3-legenda)
4. [Product Backlog](#4-product-backlog)
5. [Priorização do MVP](#5-priorização-do-mvp)
6. [Planejamento das Sprints](#6-planejamento-das-sprints)
7. [Definition of Done](#7-definition-of-done)
8. [Fluxo do quadro](#8-fluxo-do-quadro)
9. [Rastreabilidade](#9-rastreabilidade)

---

## 1. Visão do produto

Desenvolver um **Portal de Certificação em Metodologias Ágeis** com área de estudos, autenticação de candidatos, certificação cronometrada, histórico, emissão de certificado e validação pública por QR Code.

### Fluxo principal

`Cadastro → Login → Estudo → Certificação → Resultado → Histórico → Certificado → Validação`

### Regras centrais

- A certificação terá **12 temas oficiais**.
- Cada tema terá **4 questões cadastradas**, totalizando ao menos **48 questões**.
- Será sorteada **1 questão por tema**, totalizando **12 questões por tentativa**.
- Cada questão terá **150 segundos**, uma imagem e quatro alternativas.
- Cada questão terá somente **uma alternativa correta**.
- Interrupções encerram a questão atual, que não poderá ser respondida novamente.
- A prova poderá ser retomada no próximo tema ainda não respondido.
- A aprovação exige resultado **maior ou igual a 65%**.
- A nota e as respostas devem ser processadas e validadas no backend.

---

## 2. Decisões e pontos de atenção

### 🟢 Definição dos temas

O documento exige exatamente **12 temas**, mas apresenta **16 temas sugeridos**. A equipe deve selecionar e documentar os 12 temas oficiais antes de concluir a base de questões e o material de estudo.

### 🟢 Persistência da certificação

O backend deve ser a fonte de verdade para início, expiração, resposta e encerramento de cada questão. O cronômetro não pode depender apenas do navegador.

### 🟢 Regra de aprovação

Com 12 questões, 8 acertos equivalem a 66,67%. Ainda assim, a implementação deve usar a regra de negócio `percentual >= 65`, evitando vincular a aprovação a uma quantidade fixa de acertos.

### 🟢 Produção de conteúdo

As 48 questões, imagens e materiais didáticos representam um volume significativo. A produção deve começar na Sprint 1 e continuar paralelamente ao desenvolvimento.

---

## 3. Legenda

### Prioridade

| Código | Significado | Uso |
|---|---|---|
| 🟢 **P0** | Crítica | Obrigatório para o MVP e para o fluxo principal |
| ⚪ **P1** | Alta | Importante, mas pode entrar após o núcleo funcional |
| ⚫ **P2** | Evolução | Melhoria futura, caso seja identificada no refinamento |

### Story Points

Estimativa relativa de esforço utilizando a sequência: `1, 2, 3, 5, 8, 13`.

---

## 4. Product Backlog

### ÉPICO 01 — Estrutura e arquitetura

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-001 | Definir os 12 temas oficiais | Exatamente 12 temas selecionados e documentados | RF05 / RP07 | 🟢 P0 | 2 |
| PB-002 | Criar estrutura inicial do projeto | Frontend, backend e banco organizados para desenvolvimento | RP01–03 | 🟢 P0 | 3 |
| PB-003 | Configurar PostgreSQL | Banco funcionando e acessível pelo backend | RP02 | 🟢 P0 | 3 |
| PB-004 | Criar modelo de dados | Modelar usuários, temas, questões, alternativas, respostas, certificados e histórico | RP04 | 🟢 P0 | 5 |
| PB-005 | Criar Docker Compose | Aplicação e PostgreSQL inicializam por Docker Compose | RNF07 / RP05 | 🟢 P0 | 5 |
| PB-006 | Criar carga inicial dos temas | Os 12 temas oficiais ficam cadastrados no banco | RF05 | 🟢 P0 | 2 |

### ÉPICO 02 — Cadastro e autenticação

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-007 | Criar cadastro de candidato | Solicitar CPF, nome completo, e-mail e senha | RF03 | 🟢 P0 | 3 |
| PB-008 | Garantir CPF único | Impedir cadastro de usuários com CPF duplicado | RF03 | 🟢 P0 | 2 |
| PB-009 | Criar login | Autenticação realizada exclusivamente com CPF e senha | RF04 | 🟢 P0 | 3 |
| PB-010 | Proteger senha do candidato | Senha armazenada por hash, nunca em texto puro | RNF03 | 🟢 P0 | 3 |
| PB-011 | Criar sessão autenticada | Usuário permanece identificado durante a navegação | RF04 | 🟢 P0 | 3 |
| PB-012 | Implementar logout | Encerrar sessão sem expor dados do candidato | RF04 / RNF03 | ⚪ P1 | 1 |

### ÉPICO 03 — Portal e área de estudos

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-013 | Criar página inicial | Exibir descrição, objetivos e instruções da certificação | RF01 | 🟢 P0 | 3 |
| PB-014 | Criar ações de início | Permitir iniciar a certificação ou retornar posteriormente | RF02 | 🟢 P0 | 2 |
| PB-015 | Criar área de estudos | Exibir conteúdo organizado pelos 12 temas | RF07 | 🟢 P0 | 5 |
| PB-016 | Criar página de estudo do tema | Apresentar texto, imagens e recursos relacionados | RF07 | ⚪ P1 | 3 |
| PB-017 | Relacionar estudo e certificação | Temas de estudo correspondem aos temas da prova | RP07 | 🟢 P0 | 2 |
| PB-018 | Criar indicador visual de progresso | Exibir temas concluídos e pendentes | RF21 | ⚪ P1 | 3 |

### ÉPICO 04 — Motor da certificação

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-019 | Criar tentativa de certificação | Nova tentativa vinculada ao candidato | RF05 / RF20 | 🟢 P0 | 5 |
| PB-020 | Selecionar uma questão por tema | Exibir exatamente uma questão de cada um dos 12 temas | RF05 | 🟢 P0 | 5 |
| PB-021 | Sortear questão | Selecionar aleatoriamente 1 entre as 4 questões do tema | RF06 | 🟢 P0 | 5 |
| PB-022 | Exibir imagem da questão | Toda questão possui e mostra uma imagem associada | RF08 / RP06 | 🟢 P0 | 2 |
| PB-023 | Exibir quatro alternativas | Apresentar alternativas A, B, C e D | RF08 | 🟢 P0 | 2 |
| PB-024 | Permitir somente uma alternativa correta | Base registra exatamente uma opção correta | RF08 | 🟢 P0 | 2 |
| PB-025 | Criar cronômetro | Contagem regressiva visível iniciando em 150 segundos | RF10 | 🟢 P0 | 5 |
| PB-026 | Registrar resposta | Resposta escolhida é salva no servidor | RF20 | 🟢 P0 | 5 |
| PB-027 | Informar resposta correta | Após responder, mostrar a alternativa correta | RF09 | 🟢 P0 | 3 |
| PB-028 | Encerrar questão por timeout | Após 150 segundos, registrar questão como incorreta | RF11 | 🟢 P0 | 5 |
| PB-029 | Bloquear nova resposta | Tema encerrado não pode ser respondido novamente | RF14 / RF15 | 🟢 P0 | 5 |
| PB-030 | Perguntar se deseja continuar | Após cada questão, permitir avançar ou encerrar a sessão | RF12 | 🟢 P0 | 3 |

### ÉPICO 05 — Pausa, retomada e persistência

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-031 | Interromper certificação | Candidato pode encerrar a sessão entre os temas | RF12–13 | 🟢 P0 | 3 |
| PB-032 | Retomar certificação | Continuar pelo próximo tema não respondido | RF13 | 🟢 P0 | 5 |
| PB-033 | Tratar perda de conexão | Questão iniciada é considerada encerrada | RF14 | 🟢 P0 | 8 |
| PB-034 | Tratar fechamento do navegador | Questão em andamento não pode ser retomada | RF14 | 🟢 P0 | 5 |
| PB-035 | Persistir estado da questão | Backend registra início, expiração, resposta e encerramento | RF14 / RF20 | 🟢 P0 | 5 |
| PB-036 | Evitar fraude por atualização | Recarregar a página não libera questão encerrada | RF14–15 | 🟢 P0 | 5 |

### ÉPICO 06 — Resultado e histórico

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-037 | Calcular quantidade de acertos | Resultado calculado após os 12 temas | RF16 | 🟢 P0 | 3 |
| PB-038 | Calcular percentual | Desempenho convertido em percentual | RF16–17 | 🟢 P0 | 2 |
| PB-039 | Aplicar nota mínima de 65% | Aprovar somente quando percentual for maior ou igual a 65% | RF17 | 🟢 P0 | 2 |
| PB-040 | Criar histórico da tentativa | Armazenar todas as certificações realizadas | RF20 | 🟢 P0 | 5 |
| PB-041 | Registrar questão sorteada | Histórico identifica a questão apresentada | RF20 | 🟢 P0 | 2 |
| PB-042 | Registrar resposta escolhida | Histórico mostra a alternativa selecionada | RF20 | 🟢 P0 | 2 |
| PB-043 | Registrar resposta correta | Histórico mantém a alternativa correta | RF20 | 🟢 P0 | 2 |
| PB-044 | Registrar data e hora | Cada resposta recebe data e horário | RF20 | 🟢 P0 | 2 |
| PB-045 | Exibir histórico ao candidato | Candidato consulta suas tentativas | RF20 | ⚪ P1 | 3 |

### ÉPICO 07 — Certificado e QR Code

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-046 | Gerar certificado aprovado | Certificado criado automaticamente quando nota for ≥ 65% | RF17 | 🟢 P0 | 5 |
| PB-047 | Inserir dados do candidato | Certificado contém nome, CPF e e-mail | RF18 | 🟢 P0 | 3 |
| PB-048 | Inserir dados da certificação | Exibir emissão, nota final e percentual | RF18 | 🟢 P0 | 2 |
| PB-049 | Gerar identificador do certificado | Cada certificado possui identificador único | RF19 / RP08 | 🟢 P0 | 3 |
| PB-050 | Gerar QR Code | QR Code associado ao certificado | RF18 | 🟢 P0 | 5 |
| PB-051 | Criar página pública de validação | QR Code direciona para validação de autenticidade | RF19 / RP08 | 🟢 P0 | 5 |
| PB-052 | Validar certificado | Página informa se o certificado é válido | RF19 | 🟢 P0 | 3 |

### ÉPICO 08 — Base de questões e conteúdo

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-053 | Produzir 48 questões | Criar exatamente 4 questões para cada um dos 12 temas | RF06 / RP06 | 🟢 P0 | 13 |
| PB-054 | Produzir imagens das questões | As 48 questões possuem imagem associada | RF08 / RP06 | 🟢 P0 | 13 |
| PB-055 | Revisar alternativas | Todas possuem A–D e apenas uma resposta correta | RF08 | 🟢 P0 | 8 |
| PB-056 | Produzir material de estudos | Criar conteúdo para cada um dos 12 temas | RF07 | 🟢 P0 | 13 |
| PB-057 | Revisar coerência entre conteúdo e questões | Questões são relacionadas ao conteúdo estudado | RP07 / RNF08 | 🟢 P0 | 8 |

### ÉPICO 09 — Segurança, experiência e qualidade

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-058 | Tornar interface responsiva | Portal utilizável em desktop e dispositivos móveis | RNF01 | 🟢 P0 | 5 |
| PB-059 | Garantir desempenho adequado | Páginas e questões carregam sem atrasos inadequados | RNF02 | ⚪ P1 | 3 |
| PB-060 | Adequar dados à LGPD | Dados pessoais protegidos no armazenamento e uso | RNF03 | 🟢 P0 | 5 |
| PB-061 | Calcular nota no backend | Alteração no JavaScript não pode manipular a nota | RNF04 | 🟢 P0 | 5 |
| PB-062 | Validar respostas no backend | Frontend não decide sozinho se a resposta está correta | RNF04 | 🟢 P0 | 5 |
| PB-063 | Testar fluxo completo | Cadastro até certificado funciona de ponta a ponta | RNF04 / RP09 | 🟢 P0 | 8 |
| PB-064 | Testar interrupções | Validar timeout, atualização e perda de conexão | RF11–15 | 🟢 P0 | 8 |

### ÉPICO 10 — Documentação e gestão do projeto

| ID | Backlog Item | Critério de aceite resumido | Origem | Pri. | SP |
|---|---|---|---|:---:|---:|
| PB-065 | Documentar modelo de dados | DER com entidades e relacionamentos disponível | RNF06 | 🟢 P0 | 3 |
| PB-066 | Criar instruções de instalação | Documentar execução por Docker Compose | RNF06–07 | 🟢 P0 | 3 |
| PB-067 | Documentar API | Endpoints, parâmetros e retornos documentados | RNF06 | ⚪ P1 | 5 |
| PB-068 | Documentar funcionalidades | Funcionalidades implementadas descritas | RNF06 | ⚪ P1 | 3 |
| PB-069 | Configurar Git | Versionamento utilizado durante todo o desenvolvimento | RNF05 | 🟢 P0 | 2 |
| PB-070 | Definir Definition of Done | Critério de pronto adotado nas Sprints | RNF05 | 🟢 P0 | 2 |
| PB-071 | Manter Product Backlog | Itens priorizados e refinados durante o projeto | RNF05 | 🟢 P0 | 2 |

---

## 5. Priorização do MVP

O MVP deve contemplar integralmente o seguinte caminho:

> **Cadastro → Login → Estudo → Início da certificação → Questão → Timer → Resposta → Pausa/retomada → 12 temas → Nota → Histórico → Certificado → QR Code → Validação**

Todos os itens marcados como **🟢 P0** sustentam esse fluxo ou representam requisitos obrigatórios de infraestrutura, segurança, conteúdo e documentação.

---

## 6. Planejamento das Sprints

| Sprint | Período | Objetivo sugerido |
|---|---|---|
| **Sprint 1** | 28/09 a 22/10 | Arquitetura, Docker, PostgreSQL, modelo de dados, cadastro/login, página inicial, área de estudos e motor inicial |
| **Sprint 2** | 23/10 a 05/11 | Questões, sorteio, timer, respostas, interrupção, retomada, progresso, histórico e cálculo da nota |
| **Sprint 3** | 06/11 a 25/11 | Certificado, QR Code, validação pública, segurança, responsividade, testes, documentação e refinamentos |
| **Apresentação** | 26/11 | Entrega final e demonstração do produto |

### Atividade paralela durante as três Sprints

- Produção e revisão das 48 questões.
- Produção e revisão das 48 imagens.
- Produção dos materiais dos 12 temas.
- Validação de coerência entre conteúdo e avaliação.

---

## 7. Definition of Done

Um item poderá ser movido para **Done** quando:

- [ ] A funcionalidade estiver implementada e integrada ao backend e banco, quando aplicável.
- [ ] Todos os critérios de aceite estiverem atendidos.
- [ ] O código estiver versionado no Git.
- [ ] O fluxo principal estiver testado.
- [ ] A interface funcionar em desktop e dispositivo móvel.
- [ ] Nenhuma regra crítica depender exclusivamente do frontend.
- [ ] A documentação estiver atualizada quando houver impacto em API, banco ou instalação.
- [ ] O item tiver sido revisado e validado pela equipe.
- [ ] Não houver erro crítico conhecido relacionado ao item.

---

## 8. Fluxo do quadro

| Coluna | Finalidade |
|---|---|
| **Product Backlog** | Itens identificados e ainda não preparados |
| **Ready** | Itens refinados, estimados e prontos para seleção |
| **Sprint Backlog** | Itens assumidos pela equipe na Sprint atual |
| **Em Desenvolvimento** | Implementação em andamento |
| **Em Teste** | Validação técnica e funcional |
| **Em Validação** | Revisão da equipe e do responsável pelo produto |
| **Done** | Item atende à Definition of Done |

---

## 9. Rastreabilidade

O backlog contém **71 PBIs**, distribuídos em **10 épicos**, com rastreabilidade inicial para:

- **RF01 a RF21** — Requisitos funcionais;
- **RNF01 a RNF08** — Requisitos não funcionais;
- **RP01 a RP09** — Restrições e requisitos do projeto.

### Resumo por épico

| Épico | Intervalo | Quantidade |
|---|---:|---:|
| Estrutura e arquitetura | PB-001 a PB-006 | 6 |
| Cadastro e autenticação | PB-007 a PB-012 | 6 |
| Portal e área de estudos | PB-013 a PB-018 | 6 |
| Motor da certificação | PB-019 a PB-030 | 12 |
| Pausa, retomada e persistência | PB-031 a PB-036 | 6 |
| Resultado e histórico | PB-037 a PB-045 | 9 |
| Certificado e QR Code | PB-046 a PB-052 | 7 |
| Base de questões e conteúdo | PB-053 a PB-057 | 5 |
| Segurança, experiência e qualidade | PB-058 a PB-064 | 7 |
| Documentação e gestão | PB-065 a PB-071 | 7 |
| **Total** | **PB-001 a PB-071** | **71** |

---

<div align="center">

### 🟢 CTRL ALT DEVS

`BUILD` **›** `FIX` **›** `REPEAT`

**Desafio 1DSM — 2026/2**

</div>
