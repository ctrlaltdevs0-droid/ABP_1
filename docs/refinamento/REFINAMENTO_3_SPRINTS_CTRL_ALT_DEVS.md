<div align="center">

# 🟢 CTRL ALT DEVS

## REFINAMENTO DO PRODUCT BACKLOG — 3 SPRINTS

**PORTAL DE CERTIFICAÇÃO EM METODOLOGIAS ÁGEIS**

![Identidade](https://img.shields.io/badge/IDENTIDADE-CTRL_ALT_DEVS-39FF70?style=for-the-badge&labelColor=101414)
![Escopo](https://img.shields.io/badge/ESCOPO-71_PBIs-F5F7F6?style=for-the-badge&labelColor=101414)
![Estimativa](https://img.shields.io/badge/ESTIMATIVA-294_SP-39FF70?style=for-the-badge&labelColor=101414)

`BUILD` **›** `FIX` **›** `REPEAT`

</div>

---

> **Base do refinamento:** `BACKLOG_PORTAL_CERTIFICACAO_CTRL_ALT_DEVS.md`  
> **Período do projeto:** 28/09/2026 a 26/11/2026  
> **Observação:** as estimativas são iniciais. A equipe deverá confirmar capacidade e velocidade no planejamento de cada Sprint.

## Sumário

1. [Estratégia de entrega](#1-estratégia-de-entrega)
2. [Definition of Ready](#2-definition-of-ready)
3. [Sprint 1 — Fundação e acesso](#3-sprint-1--fundação-e-acesso)
4. [Sprint 2 — Motor da certificação](#4-sprint-2--motor-da-certificação)
5. [Sprint 3 — Certificação e entrega](#5-sprint-3--certificação-e-entrega)
6. [Dependências entre as Sprints](#6-dependências-entre-as-sprints)
7. [Plano de testes](#7-plano-de-testes)
8. [Riscos e respostas](#8-riscos-e-respostas)
9. [Definition of Done](#9-definition-of-done)
10. [Rastreabilidade final](#10-rastreabilidade-final)

---

## 1. Estratégia de entrega

| Sprint | Período | Meta | PBIs | SP previstos |
|---|---|---|---:|---:|
| **Sprint 1** | 28/09 a 22/10 | Disponibilizar a fundação, o acesso e a área inicial de estudos | 25 | 91 |
| **Sprint 2** | 23/10 a 05/11 | Entregar o fluxo completo da prova, com persistência e resultado | 28 | 114 |
| **Sprint 3** | 06/11 a 25/11 | Emitir e validar certificados, proteger e estabilizar o produto | 18 | 89 |
| **Total** | — | MVP completo | **71** | **294** |

### Interpretação da estimativa

- Os pontos representam **complexidade relativa**, não horas.
- Os totais não são compromisso definitivo sem velocidade histórica.
- A Sprint 2 tem menor duração e maior volume; por isso é o principal risco do plano.
- Se a capacidade for insuficiente, a equipe deve dividir PBIs grandes em fatias verticais menores sem remover requisitos obrigatórios do MVP.
- Questões, imagens e material de estudo devem ser produzidos paralelamente ao desenvolvimento.

---

## 2. Definition of Ready

Um PBI estará pronto para entrar na Sprint quando:

- [ ] possuir descrição clara de valor;
- [ ] possuir critérios de aceite verificáveis;
- [ ] ter dependências identificadas;
- [ ] ter protótipo ou regra visual definida, quando necessário;
- [ ] possuir estimativa em Story Points;
- [ ] ser pequeno o bastante para terminar dentro da Sprint;
- [ ] não depender de decisão de negócio pendente;
- [ ] ter dados ou conteúdo de teste disponíveis;
- [ ] ter responsável ou dupla responsável definida.

---

## 3. Sprint 1 — Fundação e acesso

### Informações da Sprint

| Campo | Definição |
|---|---|
| **Período** | 28/09/2026 a 22/10/2026 |
| **Objetivo** | Construir a base técnica e permitir que o candidato se cadastre, entre no portal e acesse os conteúdos dos 12 temas |
| **Resultado demonstrável** | Aplicação iniciada por Docker Compose; cadastro, login, logout, página inicial e área de estudos funcionando |
| **PBIs** | PB-001 a PB-018, PB-053, PB-056, PB-065, PB-066 e PB-069 a PB-071 |
| **Estimativa** | 91 SP |

### 3.1 Escopo selecionado

| Grupo | PBIs | Entrega | SP |
|---|---|---|---:|
| Fundação | PB-001 a PB-006 | Temas definidos, projeto estruturado, banco, modelo e containers | 20 |
| Autenticação | PB-007 a PB-012 | Cadastro, CPF único, login, sessão segura e logout | 15 |
| Portal e estudos | PB-013 a PB-018 | Home, navegação, conteúdos por tema e progresso inicial | 18 |
| Conteúdo | PB-053 e PB-056 | Base das 48 questões e materiais dos 12 temas | 26 |
| Documentação e gestão | PB-065, PB-066 e PB-069 a PB-071 | DER, instalação, Git, DoD e backlog ativo | 12 |
| **Total** | **25 PBIs** | — | **91** |

### 3.2 Refinamento — Fundação e arquitetura

**PBIs:** PB-001 a PB-006, PB-065, PB-066, PB-069, PB-070 e PB-071.

**Critérios de aceite detalhados**

- Os 12 temas oficiais estão aprovados e possuem identificador, nome, descrição e ordem.
- O repositório contém separação clara entre frontend, backend e infraestrutura.
- O PostgreSQL inicia sem intervenção manual e aceita a conexão do backend.
- O modelo contempla candidato, tema, conteúdo, questão, alternativa, tentativa, questão da tentativa, resposta e certificado.
- As chaves estrangeiras impedem registros órfãos.
- O comando documentado do Docker Compose inicia todos os serviços necessários.
- O DER corresponde às tabelas implementadas.
- O README permite que outra pessoa instale o projeto do zero.
- O quadro contém as colunas Product Backlog, Ready, Sprint Backlog, Em Desenvolvimento, Em Teste, Em Validação e Done.

**Tarefas técnicas sugeridas**

- [ ] Criar repositório e estratégia de branches.
- [ ] Definir estrutura de pastas do frontend e backend.
- [ ] Criar arquivo de variáveis de ambiente de exemplo, sem segredos.
- [ ] Criar serviço PostgreSQL e volume persistente no Docker Compose.
- [ ] Criar migrations iniciais.
- [ ] Implementar restrições, índices e relacionamentos do banco.
- [ ] Criar carga inicial dos 12 temas.
- [ ] Elaborar e versionar o DER.
- [ ] Criar README de instalação e execução.
- [ ] Configurar `.gitignore`.
- [ ] Registrar Definition of Done e convenção de commits.

### 3.3 Refinamento — Cadastro e autenticação

**PBIs:** PB-007 a PB-012.

**História consolidada**

> Como candidato, quero criar minha conta e entrar com CPF e senha para acessar meus estudos e minha certificação com segurança.

**Critérios de aceite detalhados**

- Cadastro exige CPF, nome completo, e-mail e senha.
- CPF é normalizado e validado antes da gravação.
- CPF duplicado retorna mensagem clara e não cria novo usuário.
- E-mail inválido e senha fora da política são rejeitados.
- Senha é armazenada apenas como hash seguro.
- Login aceita exclusivamente CPF e senha.
- Credenciais inválidas não informam qual campo está incorreto.
- Rotas privadas rejeitam usuários sem sessão válida.
- Logout invalida a sessão e redireciona para a página pública.

**Tarefas técnicas sugeridas**

- [ ] Criar migration e entidade `candidatos`.
- [ ] Criar índice único para CPF normalizado.
- [ ] Implementar serviço de hash e verificação de senha.
- [ ] Criar endpoint de cadastro.
- [ ] Criar endpoint de login e mecanismo de sessão/token.
- [ ] Criar endpoint de logout.
- [ ] Criar middleware de autenticação.
- [ ] Criar telas de cadastro e login.
- [ ] Implementar mensagens de validação acessíveis.
- [ ] Criar testes de cadastro duplicado, login inválido e rota protegida.

### 3.4 Refinamento — Portal e área de estudos

**PBIs:** PB-013 a PB-018.

**História consolidada**

> Como candidato, quero conhecer as regras e estudar os temas oficiais para me preparar antes de iniciar a certificação.

**Critérios de aceite detalhados**

- A página inicial apresenta objetivo, formato, tempo por questão, regra de aprovação e interrupções.
- O candidato identifica claramente as ações Estudar, Iniciar e Continuar certificação.
- A área de estudos lista exatamente os mesmos 12 temas usados pela prova.
- Cada tema possui página com texto e suporte a imagem ou recurso complementar.
- O sistema registra e apresenta progresso de leitura por tema.
- As telas são navegáveis por teclado e se adaptam a celular e desktop.

**Tarefas técnicas sugeridas**

- [ ] Criar layout principal e navegação.
- [ ] Criar página inicial pública.
- [ ] Criar listagem dos temas.
- [ ] Criar página de conteúdo do tema.
- [ ] Criar endpoint para listar temas e conteúdos.
- [ ] Criar endpoint para registrar progresso de estudo.
- [ ] Implementar indicador de concluído/pendente.
- [ ] Criar estados de carregamento, vazio e erro.
- [ ] Validar responsividade das telas da Sprint.

### 3.5 Refinamento — Conteúdo inicial

**PBIs:** PB-053 e PB-056.

**Critérios de aceite detalhados**

- Existem quatro questões para cada um dos 12 temas.
- Cada questão possui enunciado, quatro alternativas e indicação interna da correta.
- Existe material didático para todos os 12 temas.
- O conteúdo usa linguagem coerente com o nível esperado dos candidatos.
- Conteúdos e questões passam por uma primeira revisão técnica e textual.

**Estratégia de execução**

- Dividir os 12 temas entre integrantes da equipe.
- Usar uma ficha padrão para questão e material didático.
- Realizar revisão cruzada: ninguém aprova sozinho o próprio conteúdo.
- Manter um controle de `rascunho → revisão → aprovado`.

### 3.6 Cenários de validação da Sprint 1

```gherkin
Cenário: cadastrar candidato válido
  Dado que o CPF ainda não está cadastrado
  Quando o candidato informar CPF, nome, e-mail e senha válidos
  Então a conta deve ser criada
  E a senha não deve ser armazenada em texto puro

Cenário: impedir CPF duplicado
  Dado que já existe um candidato com o CPF informado
  Quando um novo cadastro usar o mesmo CPF
  Então o sistema deve recusar o cadastro
  E deve exibir uma mensagem clara

Cenário: acessar conteúdo de estudo
  Dado que o candidato está autenticado
  Quando acessar a área de estudos
  Então deve visualizar os 12 temas oficiais
  E deve conseguir abrir o conteúdo de cada tema
```

### 3.7 Critério de sucesso da Sprint 1

- Uma pessoa sem ambiente previamente configurado consegue iniciar o sistema pelas instruções.
- Um candidato consegue se cadastrar, autenticar, sair e entrar novamente.
- Os 12 temas aparecem na área de estudos.
- O esqueleto das 48 questões e os conteúdos dos 12 temas estão registrados.

---

## 4. Sprint 2 — Motor da certificação

### Informações da Sprint

| Campo | Definição |
|---|---|
| **Período** | 23/10/2026 a 05/11/2026 |
| **Objetivo** | Entregar a prova completa, segura e retomável, com uma questão por tema e cálculo correto do resultado |
| **Resultado demonstrável** | Candidato realiza os 12 temas, sofre timeout ou interrupção sem fraude, retoma a prova e consulta o resultado e o histórico |
| **PBIs** | PB-019 a PB-045 e PB-054 |
| **Estimativa** | 114 SP |

> ⚠️ **Alerta de capacidade:** esta Sprint tem apenas 14 dias e concentra o núcleo mais complexo. No Planning, a equipe deve quebrar os PBIs em tarefas paralelizáveis e validar a capacidade diária.

### 4.1 Escopo selecionado

| Grupo | PBIs | Entrega | SP |
|---|---|---|---:|
| Montagem da prova | PB-019 a PB-024 | Tentativa e sorteio de uma questão por tema | 21 |
| Execução da questão | PB-025 a PB-030 | Timer, resposta, correção, timeout e avanço | 26 |
| Persistência e retomada | PB-031 a PB-036 | Interrupção segura, retomada e bloqueio antifraude | 31 |
| Resultado e histórico | PB-037 a PB-045 | Nota, aprovação, registros e consulta do histórico | 23 |
| Imagens | PB-054 | Imagem associada às 48 questões | 13 |
| **Total** | **28 PBIs** | — | **114** |

### 4.2 Refinamento — Criação da tentativa e sorteio

**PBIs:** PB-019 a PB-024.

**História consolidada**

> Como candidato autenticado, quero iniciar uma tentativa com uma questão sorteada de cada tema para realizar uma avaliação variada e equilibrada.

**Critérios de aceite detalhados**

- Uma tentativa pertence a um único candidato.
- Uma tentativa seleciona exatamente 12 questões, uma para cada tema oficial.
- A questão é sorteada entre as quatro questões ativas do tema.
- O sorteio é persistido antes de a primeira questão ser exibida.
- Recarregar a página não troca a questão sorteada.
- Cada questão exibe enunciado, imagem e alternativas A, B, C e D.
- A API nunca envia ao frontend a identificação da alternativa correta antes da resposta.
- A base impede zero ou mais de uma alternativa correta por questão.

**Tarefas técnicas sugeridas**

- [ ] Criar entidades `tentativas`, `tentativa_questoes` e `respostas`.
- [ ] Criar estados da tentativa: não iniciada, em andamento, interrompida, concluída.
- [ ] Implementar serviço transacional de criação da tentativa.
- [ ] Implementar sorteio por tema no backend.
- [ ] Persistir ordem e questões sorteadas.
- [ ] Criar endpoint para iniciar ou recuperar tentativa ativa.
- [ ] Criar tela de instruções antes do início.
- [ ] Criar tela da questão com imagem e alternativas.
- [ ] Testar unicidade de tema e estabilidade do sorteio.

### 4.3 Refinamento — Cronômetro e resposta

**PBIs:** PB-025 a PB-030.

**História consolidada**

> Como candidato, quero responder cada questão dentro de 150 segundos e receber o retorno correto para avançar de forma controlada.

**Critérios de aceite detalhados**

- O backend registra o instante de início e calcula a expiração da questão.
- O frontend mostra contagem regressiva sincronizada com o prazo do servidor.
- Uma resposta recebida após o prazo é recusada e registrada como timeout.
- Somente a primeira resposta válida é aceita.
- Após responder ou expirar, a questão fica bloqueada.
- A alternativa correta é mostrada somente após o encerramento.
- O candidato escolhe continuar ou interromper entre duas questões.
- A resposta correta não é determinada nem alterada pelo JavaScript do navegador.

**Tarefas técnicas sugeridas**

- [ ] Criar endpoint para iniciar a questão atual.
- [ ] Registrar `iniciada_em`, `expira_em`, `respondida_em` e status.
- [ ] Criar endpoint idempotente para enviar resposta.
- [ ] Validar prazo e estado no backend.
- [ ] Implementar cronômetro visual.
- [ ] Implementar bloqueio da interface após envio ou timeout.
- [ ] Implementar retorno pós-resposta sem revelar outras questões.
- [ ] Criar modal Continuar agora / Continuar depois.
- [ ] Testar duplo clique e reenvio da mesma requisição.

### 4.4 Refinamento — Interrupção, retomada e antifraude

**PBIs:** PB-031 a PB-036.

**Critérios de aceite detalhados**

- A interrupção voluntária só acontece entre questões.
- Ao retomar, o sistema seleciona o próximo tema pendente.
- Uma questão iniciada e abandonada é encerrada e marcada como incorreta.
- Fechar ou atualizar o navegador não reinicia o cronômetro.
- Uma resposta encerrada não pode ser modificada.
- O backend resolve inconsistências de estado sem confiar no estado local do navegador.
- Requisições repetidas produzem resultado idempotente.

**Tarefas técnicas sugeridas**

- [ ] Criar máquina de estados da questão da tentativa.
- [ ] Criar rotina para encerrar questões expiradas.
- [ ] Validar expiração a cada leitura e escrita relevante.
- [ ] Implementar retomada pelo próximo tema pendente.
- [ ] Impedir edição de respostas persistidas.
- [ ] Implementar tratamento de perda de conexão no frontend.
- [ ] Criar testes de atualização, fechamento, atraso e requisição duplicada.

### 4.5 Refinamento — Resultado e histórico

**PBIs:** PB-037 a PB-045.

**História consolidada**

> Como candidato, quero conhecer meu desempenho e consultar minhas tentativas para acompanhar meu resultado com transparência.

**Critérios de aceite detalhados**

- O resultado é calculado apenas após os 12 temas serem encerrados.
- Acertos e percentual são calculados no backend.
- Aprovado significa `percentual >= 65`.
- O histórico registra tema, questão sorteada, resposta escolhida, resposta correta, status e data/hora.
- Timeout e interrupção aparecem como respostas incorretas sem alternativa escolhida.
- Um candidato acessa somente o próprio histórico.
- A listagem mostra data, acertos, percentual e situação.
- O detalhe apresenta as 12 questões da tentativa.

**Tarefas técnicas sugeridas**

- [ ] Implementar serviço de conclusão da tentativa.
- [ ] Calcular acertos e percentual no backend.
- [ ] Persistir resultado final e situação.
- [ ] Criar endpoint de listagem do histórico.
- [ ] Criar endpoint de detalhe da tentativa.
- [ ] Criar página de resultado.
- [ ] Criar página de histórico.
- [ ] Aplicar autorização por proprietário do recurso.
- [ ] Testar resultados limítrofes, incluindo 7 e 8 acertos.

### 4.6 Refinamento — Imagens das questões

**PBI:** PB-054.

**Critérios de aceite detalhados**

- Todas as 48 questões possuem uma imagem válida e coerente.
- Imagens usam formato otimizado para web e texto alternativo.
- Falha de imagem tem tratamento visual sem quebrar a questão.
- A licença ou autoria de cada imagem está documentada.

### 4.7 Cenários de validação da Sprint 2

```gherkin
Cenário: manter a questão após atualizar a página
  Dado que uma questão foi sorteada e iniciada
  Quando o candidato atualizar a página
  Então a mesma questão deve permanecer
  E o cronômetro deve continuar a partir do prazo do servidor

Cenário: encerrar por timeout
  Dado que a questão está em andamento
  Quando os 150 segundos terminarem sem resposta válida
  Então a questão deve ser encerrada como incorreta
  E não deve aceitar resposta posterior

Cenário: retomar certificação interrompida
  Dado que o candidato encerrou a sessão entre duas questões
  Quando retornar à certificação
  Então deve continuar no próximo tema pendente

Cenário: aprovar com percentual mínimo
  Dado que todos os 12 temas foram encerrados
  E o percentual calculado é maior ou igual a 65%
  Quando o resultado for consolidado
  Então a tentativa deve ser marcada como aprovada
```

### 4.8 Critério de sucesso da Sprint 2

- O candidato completa uma tentativa de 12 temas.
- Sorteio, timer, resposta e correção são controlados pelo backend.
- Atualização, fechamento e perda de conexão não liberam nova resposta.
- A prova pode ser retomada corretamente.
- Resultado e histórico conferem com as respostas persistidas.

---

## 5. Sprint 3 — Certificação e entrega

### Informações da Sprint

| Campo | Definição |
|---|---|
| **Período** | 06/11/2026 a 25/11/2026 |
| **Objetivo** | Concluir o valor do produto com certificado verificável, segurança, qualidade, documentação e preparação da apresentação |
| **Resultado demonstrável** | Candidato aprovado baixa o certificado; qualquer pessoa valida o documento pelo QR Code; fluxo completo está testado e documentado |
| **PBIs** | PB-046 a PB-052, PB-055, PB-057 a PB-064, PB-067 e PB-068 |
| **Estimativa** | 89 SP |

### 5.1 Escopo selecionado

| Grupo | PBIs | Entrega | SP |
|---|---|---|---:|
| Certificado e QR Code | PB-046 a PB-052 | Emissão, identificador, QR Code e validação pública | 26 |
| Revisão de conteúdo | PB-055 e PB-057 | Alternativas revisadas e coerência validada | 16 |
| Segurança, UX e qualidade | PB-058 a PB-064 | Responsividade, proteção, desempenho e testes | 39 |
| Documentação final | PB-067 e PB-068 | API e funcionalidades documentadas | 8 |
| **Total** | **18 PBIs** | — | **89** |

### 5.2 Refinamento — Certificado, QR Code e validação

**PBIs:** PB-046 a PB-052.

**História consolidada**

> Como candidato aprovado, quero receber um certificado verificável para comprovar publicamente minha aprovação.

**Critérios de aceite detalhados**

- Apenas tentativas aprovadas geram certificado.
- Cada tentativa aprovada gera no máximo um certificado ativo.
- O certificado contém nome, CPF, e-mail, data/hora de emissão, nota e percentual.
- O CPF deve ter exibição mascarada na validação pública.
- O certificado possui identificador único não sequencial e difícil de adivinhar.
- O QR Code leva diretamente à página pública de validação.
- A página informa claramente certificado válido, inválido ou revogado.
- A validação pública não expõe dados além do necessário.
- Reabrir a página do resultado não gera certificados duplicados.

**Tarefas técnicas sugeridas**

- [ ] Criar entidade e migration de certificados.
- [ ] Definir identificador público único.
- [ ] Criar serviço idempotente de emissão.
- [ ] Criar layout do certificado.
- [ ] Gerar arquivo para visualização e download.
- [ ] Gerar QR Code com URL pública.
- [ ] Criar endpoint público de validação.
- [ ] Criar página pública de autenticidade.
- [ ] Mascarar CPF e revisar exposição de dados.
- [ ] Testar documento válido, inexistente e revogado.

### 5.3 Refinamento — Revisão final de conteúdo

**PBIs:** PB-055 e PB-057.

**Critérios de aceite detalhados**

- Todas as questões possuem quatro alternativas claras e apenas uma correta.
- Não há alternativas duplicadas, ambíguas ou obviamente discrepantes.
- Cada questão pode ser respondida com base no material do respectivo tema.
- Revisão técnica e ortográfica possui registro de responsável.
- Nenhuma questão usa imagem sem relação com o enunciado.

**Tarefas sugeridas**

- [ ] Executar revisão cruzada das 48 questões.
- [ ] Conferir gabarito diretamente no banco ou carga inicial.
- [ ] Revisar ortografia e padronização.
- [ ] Validar coerência com os 12 conteúdos.
- [ ] Fazer teste piloto com pessoas que não escreveram as questões.

### 5.4 Refinamento — Segurança e LGPD

**PBIs:** PB-060 a PB-062.

**Critérios de aceite detalhados**

- Senhas, tokens e segredos não aparecem em logs ou no repositório.
- Usuários não acessam tentativas, histórico ou certificado privado de terceiros.
- O frontend não recebe o gabarito antes de encerrar a questão.
- Nota, percentual e aprovação são calculados exclusivamente no backend.
- Dados pessoais têm finalidade documentada e exposição minimizada.
- Entradas da API passam por validação e respostas não exibem detalhes internos.

**Tarefas técnicas sugeridas**

- [ ] Revisar autenticação e autorização de todas as rotas.
- [ ] Revisar exposição de CPF e e-mail.
- [ ] Remover segredos e dados pessoais dos logs.
- [ ] Validar payloads e limitar tamanhos.
- [ ] Testar manipulação de resposta e nota via navegador.
- [ ] Testar acesso horizontal a recursos de outro usuário.
- [ ] Documentar tratamento e finalidade dos dados pessoais.

### 5.5 Refinamento — Responsividade e desempenho

**PBIs:** PB-058 e PB-059.

**Critérios de aceite detalhados**

- Todas as telas essenciais funcionam em largura móvel e desktop.
- A questão, alternativas e cronômetro permanecem legíveis sem rolagem horizontal.
- Imagens usam dimensões e compressão adequadas.
- Estados de carregamento evitam cliques duplicados.
- Consultas mais utilizadas possuem índices e não apresentam repetição desnecessária.
- O carregamento atende ao limite definido pela equipe no ambiente de teste.

### 5.6 Refinamento — Testes e estabilização

**PBIs:** PB-063 e PB-064.

**Critérios de aceite detalhados**

- Existe teste de ponta a ponta do cadastro até a validação do certificado.
- Timeout, atualização, fechamento e perda de conexão foram testados.
- Casos de aprovação e reprovação foram validados.
- Não existem defeitos críticos ou bloqueadores abertos.
- Evidências de teste estão anexadas ou documentadas.
- O fluxo principal foi validado em desktop e dispositivo móvel.

**Tarefas técnicas sugeridas**

- [ ] Preparar massa de dados controlada.
- [ ] Criar roteiro de teste funcional.
- [ ] Automatizar testes críticos viáveis.
- [ ] Executar teste de regressão das Sprints 1 e 2.
- [ ] Realizar teste de concorrência básica em envio de resposta.
- [ ] Corrigir defeitos por severidade.
- [ ] Executar ensaio completo da apresentação.

### 5.7 Refinamento — Documentação final

**PBIs:** PB-067 e PB-068.

**Critérios de aceite detalhados**

- API documentada com método, rota, autenticação, parâmetros, resposta e erros.
- Funcionalidades descritas conforme o comportamento entregue.
- README aponta para modelo de dados, API e manual de execução.
- Limitações conhecidas são registradas.
- A documentação corresponde à versão apresentada.

### 5.8 Cenários de validação da Sprint 3

```gherkin
Cenário: emitir certificado para candidato aprovado
  Dado que a tentativa foi concluída com percentual maior ou igual a 65%
  Quando o resultado for consolidado
  Então deve existir um único certificado para a tentativa
  E o documento deve conter os dados obrigatórios

Cenário: validar certificado pelo QR Code
  Dado que o certificado é válido
  Quando uma pessoa acessar a URL contida no QR Code
  Então a página pública deve confirmar a autenticidade
  E não deve exibir dados pessoais além do necessário

Cenário: impedir manipulação da nota
  Dado que o candidato alterou dados no navegador
  Quando tentar enviar nota ou resposta adulterada
  Então o backend deve ignorar os valores manipulados
  E deve calcular o resultado com os dados persistidos
```

### 5.9 Critério de sucesso da Sprint 3

- Um candidato aprovado recebe um certificado único e verificável.
- O QR Code direciona para uma validação pública funcional.
- O fluxo completo passa nos testes de regressão e interrupção.
- Não há defeitos críticos abertos.
- Instalação, API e funcionalidades estão documentadas.
- A equipe consegue demonstrar o produto do início ao fim.

---

## 6. Dependências entre as Sprints

| Entrega predecessora | Entrega dependente | Motivo |
|---|---|---|
| PB-001 e PB-006 — Temas oficiais | PB-015, PB-020, PB-053 e PB-056 | Estudo e prova precisam usar os mesmos 12 temas |
| PB-003 a PB-005 — Banco, modelo e containers | Todo o fluxo transacional | Persistência e ambiente são fundações do sistema |
| PB-007 a PB-011 — Autenticação | PB-019, PB-040, PB-045 e PB-046 | Tentativa, histórico e certificado pertencem ao candidato |
| PB-019 a PB-024 — Tentativa e sorteio | PB-025 a PB-036 | Timer e retomada exigem questão previamente persistida |
| PB-026, PB-035 e PB-040 — Respostas persistidas | PB-037 a PB-045 | Resultado e histórico dependem de dados confiáveis |
| PB-037 a PB-039 — Resultado | PB-046 | Certificado depende da aprovação calculada |
| PB-049 — Identificador público | PB-050 a PB-052 | QR Code e página pública dependem da chave de validação |
| PB-053 e PB-054 — Questões e imagens | PB-063 | Teste completo exige a base final da certificação |

---

## 7. Plano de testes

| Nível | Foco | Execução principal |
|---|---|---|
| Unitário | CPF, percentual, expiração, sorteio e estados | Durante cada PBI |
| Integração | API, banco, autenticação e idempotência | Sprints 1 e 2 |
| Componente/UI | Formulários, timer, navegação e responsividade | Todas as Sprints |
| Segurança | Autorização, manipulação de nota e exposição de dados | Sprint 3 |
| Ponta a ponta | Cadastro até validação do certificado | Sprint 3 |
| Aceitação | Critérios funcionais e demonstração | Review de cada Sprint |

### Massa mínima de teste

- 12 temas ativos;
- 4 questões por tema;
- 4 alternativas por questão;
- 1 alternativa correta por questão;
- candidato aprovado;
- candidato reprovado;
- tentativa em andamento;
- tentativa interrompida;
- questão expirada;
- certificado válido e identificador inexistente.

---

## 8. Riscos e respostas

| Risco | Prob. | Impacto | Resposta planejada |
|---|:---:|:---:|---|
| Sprint 2 acima da capacidade | Alta | Alto | Quebrar PBIs, paralelizar backend/frontend/testes e iniciar spikes na Sprint 1 |
| Atraso na produção das 48 questões | Alta | Alto | Dividir temas, usar modelo padrão e acompanhar revisão semanalmente |
| Divergência entre material e prova | Média | Alto | Revisão cruzada e matriz tema → conteúdo → questões |
| Timer depender do navegador | Média | Crítico | Usar prazo persistido e validação obrigatória no backend |
| Resposta duplicada ou concorrente | Média | Alto | Transação, bloqueio lógico e endpoint idempotente |
| Exposição indevida de CPF | Média | Alto | Minimização, máscara e revisão das respostas públicas |
| Certificado duplicado | Baixa | Médio | Restrição única por tentativa e emissão idempotente |
| Imagens pesadas ou indisponíveis | Média | Médio | Otimização, validação de upload e fallback visual |
| Ambiente diferente entre integrantes | Média | Alto | Docker Compose e documentação testada por outro integrante |

---

## 9. Definition of Done

Um PBI só será considerado concluído quando:

- [ ] os critérios de aceite estiverem atendidos;
- [ ] frontend, backend e banco estiverem integrados, quando aplicável;
- [ ] o código tiver revisão de outro integrante;
- [ ] testes pertinentes estiverem executados e aprovados;
- [ ] o fluxo não depender de regra crítica apenas no frontend;
- [ ] a interface estiver funcional em desktop e celular;
- [ ] erros e estados de carregamento estiverem tratados;
- [ ] não houver segredo ou dado sensível no código e nos logs;
- [ ] migrations e cargas forem reproduzíveis;
- [ ] documentação afetada estiver atualizada;
- [ ] o código estiver versionado no Git;
- [ ] a entrega tiver sido demonstrada e aceita na Sprint Review.

---

## 10. Rastreabilidade final

### Distribuição dos PBIs

| Sprint | PBIs incluídos | Quantidade | SP |
|---|---|---:|---:|
| **Sprint 1** | PB-001–018, PB-053, PB-056, PB-065–066, PB-069–071 | 25 | 91 |
| **Sprint 2** | PB-019–045, PB-054 | 28 | 114 |
| **Sprint 3** | PB-046–052, PB-055, PB-057–064, PB-067–068 | 18 | 89 |
| **Total** | PB-001 a PB-071, sem duplicidade | **71** | **294** |

### Marcos de Review

| Marco | Evidência esperada |
|---|---|
| **Review 1** | Ambiente reproduzível, usuário autenticado e área de estudos navegável |
| **Review 2** | Tentativa completa com timer, retomada, resultado e histórico |
| **Review 3** | Certificado com QR Code, validação pública, testes e documentação |
| **Apresentação** | Demonstração contínua do cadastro à validação do certificado |

---

<div align="center">

### 🟢 CTRL ALT DEVS

**REFINAMENTO DAS 3 SPRINTS CONCLUÍDO**

`BUILD` **›** `FIX` **›** `REPEAT`

**Desafio 1DSM — 2026/2**

</div>
