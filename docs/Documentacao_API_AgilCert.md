# ÁGILCERT — DOCUMENTAÇÃO DA API REST

**Projeto acadêmico:** ABP_1 — Portal de Certificação em Metodologias Ágeis  
**Equipe:** CTRL ALT DEVS | FATEC Jacareí — Desenvolvimento de Software Multiplataforma  
**Versão deste documento:** 1.0 | **Data:** 22/11/2026  
**Repositório:** https://github.com/ctrlaltdevs0-droid/ABP_1  

## 1. Objetivo e visão geral

O ÁgilCert oferece estudo orientado de metodologias ágeis e Scrum, acompanhamento de progresso, quizzes de fixação, prova de certificação, histórico e certificado verificável por QR Code. A API conecta a interface HTML/CSS/JavaScript ao banco PostgreSQL, por intermédio do cliente Supabase ou de PostgREST local. O frontend não consulta tabelas diretamente.

**Arquitetura resumida:**

`Navegador (frontend) → API REST (Node.js + Express) → Supabase/PostgREST → PostgreSQL`

**Tecnologias:** Node.js 22+, Express, JavaScript, PostgreSQL 17 no Compose, Supabase JS, JWT HS256, bcrypt, Docker Compose. O backend também disponibiliza as páginas estáticas do frontend.

**Endereço local padrão:** `http://localhost:3000`  
**Prefixo das rotas:** `/api`  
**Formato:** JSON (`Content-Type: application/json`)  
**Autenticação:** `Authorization: Bearer <JWT>` nas rotas privadas.  
**Validade do token:** duas horas.  
**Acesso administrativo:** definido por `ADMIN_USER_IDS` no ambiente do backend.

## 2. Regras de negócio

| Código | Regra | Aplicação |
|---|---|---|
| RN01 | O candidato cria conta com CPF, nome, e-mail e senha. | Cadastro e autenticação |
| RN02 | O projeto possui 12 temas, 12 materiais de estudo, 48 questões e 192 alternativas na carga validada. | Catálogo educacional |
| RN03 | Cada quiz de tema contém quatro questões; são necessários pelo menos três acertos para marcar o tema como concluído. | Estudos e progresso |
| RN04 | Os 12 temas precisam estar concluídos antes de iniciar a prova. | Elegibilidade da prova |
| RN05 | A prova seleciona uma questão de cada tema, totalizando 12 questões, cada uma com quatro alternativas. | Prova de certificação |
| RN06 | Cada questão da prova tem 150 segundos, controlados pelo servidor. | Tempo e integridade |
| RN07 | Interrupção/recarregamento com questão aberta pode encerrá-la como incorreta; retomada preserva a tentativa e impede que outra sessão altere a questão. | Continuidade |
| RN08 | A aprovação requer aproveitamento de pelo menos 65%, equivalente a 8 acertos entre 12 questões. | Resultado |
| RN09 | A emissão do certificado depende de tentativa finalizada e aprovada. A emissão repetida não cria duplicata. | Certificado |
| RN10 | A validação por código UUID é pública, mas a consulta por ID e a lista de certificados pertencem ao titular ou administrador. | Segurança e validação |

Os resultados e o gabarito da prova são disponibilizados no histórico somente depois da finalização. O quiz de fixação, por outro lado, informa o acerto ao responder.

## 3. Autenticação, autorização e segurança

### 3.1 Como enviar credenciais

Após fazer login, enviar o JWT no cabeçalho das chamadas autenticadas:

```http
Authorization: Bearer SEU_TOKEN_JWT
Content-Type: application/json
```

O backend extrai o usuário do próprio token (`req.usuario.id`), verifica a assinatura HS256, a expiração, a revogação do token e a versão da sessão. Não se deve enviar nem confiar em `usuarios_idusuarios` no corpo para definir o titular.

### 3.2 Níveis de acesso

| Nível | Exemplos de rotas |
|---|---|
| Público | `GET /api`, `GET /api/teste-supabase`, `GET /api/temas`, `GET /api/temas/:id`, `POST /api/login/cadastro`, `POST /api/login/entrar`, `GET /api/certificados/validar/:codigo` |
| Autenticado | Perfil, conteúdo de estudo, progresso, quiz, prova, histórico e seus próprios certificados |
| Administrador | Criação, edição e exclusão do catálogo de temas, conteúdos, questões e alternativas; outras operações permitidas pelo middleware |

### 3.3 Limitação de requisições de autenticação

O projeto limita tentativas de login a **30 requisições por IP** e **10 por conta** a cada 15 minutos; cadastro, a **10 por IP** e **10 por conta** na mesma janela. Ao exceder o limite, pode responder **429 Too Many Requests** com `Retry-After`. Logout revoga o token, e a troca de senha invalida sessões anteriores.

## 4. Catálogo de endpoints

**Legenda:** `P` = público; `U` = usuário autenticado; `A` = administrador. Um `:id` indica parâmetro numérico de caminho, salvo indicação diferente.

### 4.1 Diagnóstico e sessão

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api` | P | Verificar funcionamento do servidor |
| GET | `/api/teste-supabase` | P | Verificar disponibilidade da conexão com dados |
| POST | `/api/login/cadastro` | P | Cadastrar candidato |
| POST | `/api/login/entrar` | P | Autenticar CPF e senha e emitir token |
| POST | `/api/login/sair` | U | Revogar token atual; sucesso `204` |

### 4.2 Usuários e perfil

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api/usuarios/me` | U | Consultar próprio perfil |
| PATCH | `/api/usuarios/me` | U | Alterar nome e/ou e-mail |
| PATCH | `/api/usuarios/me/senha` | U | Trocar senha e invalidar sessões anteriores |

### 4.3 Temas, conteúdos e progresso

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api/temas` | P | Listar temas ativos, ordenados |
| GET | `/api/temas/:id` | P | Consultar tema ativo |
| POST | `/api/temas` | A | Criar tema |
| PUT / PATCH | `/api/temas/:id` | A | Atualizar tema |
| DELETE | `/api/temas/:id` | A | Remover tema |
| GET | `/api/temas/:id/conteudos` | U | Listar conteúdos publicados de um tema |
| GET | `/api/conteudos` | U | Listar conteúdos publicados |
| GET | `/api/conteudos/:id` | U | Consultar conteúdo publicado |
| POST | `/api/conteudos` | A | Criar conteúdo |
| PUT | `/api/conteudos/:id` | A | Atualizar conteúdo |
| DELETE | `/api/conteudos/:id` | A | Excluir conteúdo |
| GET | `/api/estudos/progresso` | U | Obter temas concluídos pelo usuário |
| PUT | `/api/temas/:id/conclusao` | U | Concluir tema após três acertos |

### 4.4 Questões, alternativas e quiz de fixação

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api/temas/:id/questoes` | U | Consultar questões publicadas do tema, sem gabarito |
| GET | `/api/temas/:id/respostas` | U | Listar respostas de fixação já registradas |
| DELETE | `/api/temas/:id/respostas` | U | Reiniciar quiz ainda não concluído |
| POST | `/api/questoes/:id/responder` | U | Enviar letra escolhida e registrar acerto/erro |
| GET | `/api/questoes` | U | Listar questões |
| GET | `/api/questoes/:id` | U | Consultar questão |
| POST | `/api/questoes` | A | Criar questão |
| PUT / PATCH | `/api/questoes/:id` | A | Atualizar questão |
| DELETE | `/api/questoes/:id` | A | Excluir questão |
| GET | `/api/questoes/:id/alternativas` | A | Consultar alternativas, inclusive informações editoriais |
| POST | `/api/questoes/:id/alternativas` | A | Criar alternativa |
| PUT / PATCH | `/api/alternativas/:id` | A | Atualizar alternativa |
| DELETE | `/api/alternativas/:id` | A | Excluir alternativa |

### 4.5 Prova e continuidade

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api/tentativas/atual` | U | Encontrar tentativa atual do candidato |
| POST | `/api/tentativas` | U | Iniciar ou recuperar uma tentativa sem duplicá-la |
| GET | `/api/tentativas/:id` | U | Consultar estado da tentativa |
| GET | `/api/tentativas/:id/proxima-questao` | U | Abrir a questão seguinte com prazo no servidor |
| POST | `/api/tentativas/:id/respostas` | U | Registrar a alternativa selecionada |
| POST | `/api/tentativas/:id/pausar` | U | Pausar entre questões |
| POST | `/api/tentativas/:id/retomar` | U | Assumir/retomar a tentativa em nova sessão |
| POST | `/api/tentativas/:id/interromper` | U | Registrar interrupção de questão aberta |
| POST | `/api/tentativas/:id/presenca` | U | Informar presença sem estender o tempo |
| POST | `/api/tentativas/:id/finalizar` | U | Finalizar prova e calcular resultado |

**Sessão da prova:** o frontend gera um UUID por página de certificação e o envia no campo JSON `sessao` das requisições `POST` e no cabeçalho `X-Sessao-Prova` das requisições `GET`, exceto `GET /api/tentativas/atual`. O endpoint `POST /api/tentativas` e as ações de continuidade exigem um UUID válido. A rota `proxima-questao` abre a questão no servidor e não deve ser chamada antecipadamente.

### 4.6 Histórico e certificados

| Método | Rota | Acesso | Finalidade |
|---|---|---|---|
| GET | `/api/historico` | U | Listar tentativas do próprio candidato |
| GET | `/api/historico/:id` | U | Consultar respostas e gabarito de prova finalizada |
| POST | `/api/certificados/tentativas/:id` | U | Emitir/recuperar certificado de tentativa aprovada |
| GET | `/api/usuarios/:id/certificados` | U do próprio `:id`, ou A | Listar certificados do usuário |
| GET | `/api/certificados/:id` | U titular, ou A | Consultar certificado válido pelo ID interno |
| GET | `/api/certificados/validar/:codigo` | P | Validar certificado pelo UUID público |

## 5. Contratos e exemplos das principais operações

Os exemplos de requisição e resposta utilizam dados fictícios. As respostas podem conter campos adicionais conforme o objeto retornado pelo banco de dados.

### 5.1 Cadastro — `POST /api/login/cadastro`

**Sem JWT.** CPF com 11 dígitos (a API remove pontuação), nome de até 50 caracteres, e-mail válido, senha com no mínimo oito caracteres e no máximo 72 bytes.

```http
POST /api/login/cadastro HTTP/1.1
Content-Type: application/json

{
  "cpf": "12345678909",
  "nome": "Pessoa de Exemplo",
  "email": "exemplo@dominio.test",
  "senha": "SenhaExemplo123!"
}
```

**Sucesso — `201 Created`:**

```json
{
  "mensagem": "Usuário cadastrado com sucesso!",
  "usuario": {
    "idusuarios": 11,
    "cpf": "12345678909",
    "nome": "Pessoa de Exemplo",
    "email": "exemplo@dominio.test"
  }
}
```

Erros: `400` (campo inválido), `409` (CPF já cadastrado), `429` (limite), `500` (erro interno). A API valida o formato/tamanho do CPF; **não consulta a base da Receita Federal**.

### 5.2 Login — `POST /api/login/entrar`

```http
POST /api/login/entrar HTTP/1.1
Content-Type: application/json

{ "cpf": "12345678909", "senha": "SenhaExemplo123!" }
```

**Sucesso — `200 OK`:**

```json
{
  "mensagem": "Login realizado com sucesso!",
  "usuario": { "id": 11, "cpf": "12345678909", "nome": "Pessoa de Exemplo" },
  "token": "<JWT_ASSINADO_PELO_BACKEND>"
}
```

Erros: `400` (requisição inválida), `401` (CPF ou senha inválidos), `429` (limite) e `500`.

### 5.3 Logout — `POST /api/login/sair`

```http
POST /api/login/sair HTTP/1.1
Authorization: Bearer <JWT>
```

**Sucesso:** `204 No Content` (sem corpo). Depois disso, o mesmo JWT não pode acessar rotas privadas.

### 5.4 Consultar temas — `GET /api/temas`

**Público.** Responde `200 OK` com array de temas ativos ordenado por `ordem`:

```json
[
  { "idtemas": 1, "nome": "Fundamentos da Agilidade", "descricao": "...", "ordem": 1 },
  { "idtemas": 2, "nome": "Introdução ao Scrum", "descricao": "...", "ordem": 2 }
]
```

`GET /api/temas/:id` devolve um tema ativo, ou `404` se não localizado.

### 5.5 Consultar conteúdos — `GET /api/temas/:id/conteudos`

**Exige JWT.** Lista materiais publicados associados ao tema. Campos retornados pelo serviço: `idconteudo`, `temas_idtemas`, `titulo`, `descricao`, `status`, `recurso_url`.

```json
[
  {
    "idconteudo": 1,
    "temas_idtemas": 1,
    "titulo": "Fundamentos da Agilidade",
    "descricao": "Texto de estudo do tema...",
    "status": true,
    "recurso_url": "https://exemplo.org/material"
  }
]
```

### 5.6 Questões de fixação — `GET /api/temas/:id/questoes`

**Exige JWT.** Devolve questões ativas do tema com suas alternativas (`letra` e `texto`). Não inclui `correta` no resultado do serviço usado por esta rota.

```json
[
  {
    "idquestoes": 21,
    "temas_idtemas": 1,
    "enunciado": "Questão ilustrativa sobre agilidade?",
    "imagem_url": "https://exemplo.org/imagem.png",
    "imagem_alt": "Descrição alternativa da imagem",
    "status": true,
    "alternativas": [
      { "letra": "A", "texto": "Alternativa A" },
      { "letra": "B", "texto": "Alternativa B" },
      { "letra": "C", "texto": "Alternativa C" },
      { "letra": "D", "texto": "Alternativa D" }
    ]
  }
]
```

### 5.7 Responder ao quiz — `POST /api/questoes/:id/responder`

**Exige JWT.** O corpo recebe a **letra** selecionada, e não o ID numérico da alternativa.

```http
POST /api/questoes/21/responder HTTP/1.1
Authorization: Bearer <JWT>
Content-Type: application/json

{ "letra": "B" }
```

**Sucesso — `200 OK`:**

```json
{
  "salva": true,
  "jaRespondida": false,
  "correta": true,
  "letraEscolhida": "B",
  "letraCorreta": "B",
  "mensagem": "Parabéns! Você acertou e sua resposta foi salva!"
}
```

A primeira resposta fica registrada. Se houver resposta anterior, o endpoint retorna `jaRespondida: true` com o resultado já gravado; não muda a alternativa. `GET /api/temas/:id/respostas` recupera respostas e `DELETE /api/temas/:id/respostas` reinicia o quiz somente quando o tema ainda não foi concluído e não atingiu os três acertos.

### 5.8 Progresso — `GET /api/estudos/progresso` e `PUT /api/temas/:id/conclusao`

O primeiro retorna um array com os campos `temas_idtemas` e `concluido_em` do próprio usuário. O segundo não exige corpo com usuário e só permite concluir o tema após três respostas corretas distintas.

```http
PUT /api/temas/1/conclusao HTTP/1.1
Authorization: Bearer <JWT>
```

**Sucesso — `200 OK`:**

```json
{
  "temas_idtemas": 1,
  "concluido": true,
  "acertos": 3,
  "mensagem": "Tema concluído com sucesso!"
}
```

Se faltarem acertos: `409 Conflict`, com `acertos`, `necessarios: 3` e `faltam`. Se já concluído, responde `200` sem criar nova conclusão.

### 5.9 Iniciar prova — `POST /api/tentativas`

**Exige JWT e UUID de sessão.** O candidato precisa ter concluído os 12 temas. O início com sessão é idempotente quanto à tentativa: não gera uma nova prova ao recuperar uma tentativa atual.

```http
POST /api/tentativas HTTP/1.1
Authorization: Bearer <JWT>
Content-Type: application/json

{ "sessao": "ad6e1d84-2f6f-4688-9f76-4712e30fdc9d" }
```

**Sucesso:** `201 Created`. A API retorna o objeto da operação transacional de continuidade, contendo o estado e a identificação da tentativa.

Possíveis erros: `400` (UUID inválido), `401` (não autenticado), `403` (estudos pendentes), `409` (base insuficiente, tentativa incompatível), `503` (falha de infraestrutura).

### 5.10 Abrir questão — `GET /api/tentativas/:id/proxima-questao`

```http
GET /api/tentativas/33/proxima-questao HTTP/1.1
Authorization: Bearer <JWT>
X-Sessao-Prova: ad6e1d84-2f6f-4688-9f76-4712e30fdc9d
```

**Sucesso:** `200 OK` com os dados da operação de prova, sem revelar gabarito. A chamada define/recupera o estado da questão e seu prazo. **Não realizar pré-busca automática (prefetch)** desta URL.

### 5.11 Registrar resposta da prova — `POST /api/tentativas/:id/respostas`

Neste fluxo, diferentemente do quiz de estudo, são enviados IDs inteiros positivos da questão e da alternativa, além da sessão UUID.

```http
POST /api/tentativas/33/respostas HTTP/1.1
Authorization: Bearer <JWT>
Content-Type: application/json

{
  "sessao": "ad6e1d84-2f6f-4688-9f76-4712e30fdc9d",
  "questoes_idquestoes": 21,
  "alternativas_idalternativas": 84
}
```

**Sucesso:** `201 Created`. A implementação transacional responde com o objeto retornado pelo banco. Exemplos de conflitos `409`: questão fora de sequência, prazo encerrado, sessão substituída ou conteúdo indisponível. Não é possível forçar outra resposta em uma questão já encerrada.

### 5.12 Pausar, retomar, presença e interrupção

| Operação | Exemplo de corpo JSON | Condição |
|---|---|---|
| `POST /api/tentativas/33/pausar` | `{ "sessao": "<UUID>" }` | Aceita entre questões; questão aberta gera `409` |
| `POST /api/tentativas/33/retomar` | `{ "sessao": "<NOVO_UUID>" }` | Assume nova sessão e preserva respostas anteriores |
| `POST /api/tentativas/33/presenca` | `{ "sessao": "<UUID>" }` | Confirma atividade, mas não renova o prazo |
| `POST /api/tentativas/33/interromper` | `{ "sessao": "<UUID>", "questoes_idquestoes": 21, "motivo": "CONEXAO" }` | `motivo` deve ser `CONEXAO` ou `FECHAMENTO` |

Essas rotas devolvem `200 OK` em sucesso. O navegador envia presença periodicamente. A lógica do servidor considera falta de presença e limite de 150 segundos da questão, não apenas o cronômetro visual.

### 5.13 Finalizar prova — `POST /api/tentativas/:id/finalizar`

```http
POST /api/tentativas/33/finalizar HTTP/1.1
Authorization: Bearer <JWT>
Content-Type: application/json

{ "sessao": "ad6e1d84-2f6f-4688-9f76-4712e30fdc9d" }
```

**Sucesso:** `200 OK`. O backend executa operação no banco para consolidar os acertos, percentual e situação. Exemplo de interpretação: oito acertos em 12 representam aproximadamente 66,67% e aprovação (`>= 65%`). Se a prova estiver incompleta, a operação pode retornar `409` com mensagem para concluir as questões antes de finalizar.

### 5.14 Histórico — `GET /api/historico` e `GET /api/historico/:id`

O primeiro retorna, do próprio usuário, tentativas ordenadas por data decrescente, com os campos `idtentativas`, `iniciado_em`, `finalizado_em`, `status`, `acertos`, `percentual` e `aprovado`.

O segundo requer tentativa `FINALIZADA` e retorna estrutura semelhante à seguinte:

```json
{
  "tentativa": {
    "idtentativas": 33,
    "status": "FINALIZADA",
    "acertos": 8,
    "percentual": 66.67,
    "aprovado": true
  },
  "questoes": [
    {
      "ordem": 1,
      "tema": "Fundamentos da Agilidade",
      "enunciado": "Questão ilustrativa",
      "resposta_escolhida": "B",
      "resposta_correta": "B",
      "acertou": true,
      "respondido_em": "2026-11-18T17:30:00"
    }
  ]
}
```

O objeto `tentativa` real inclui também as datas `iniciado_em` e `finalizado_em`. Se não estiver finalizada, a consulta de detalhe responde `409`.

### 5.15 Emissão do certificado — `POST /api/certificados/tentativas/:id`

```http
POST /api/certificados/tentativas/33 HTTP/1.1
Authorization: Bearer <JWT>
```

**Sucesso — `200 OK`:** devolve o registro do certificado, com campos como `idcertificados`, `usuarios_idusuarios`, `tentativas_idtentativas`, `score`, `percentual`, `codigo_validacao`, `emitido_em`, `ativo` e `revogado_em`. Exige que a tentativa pertença ao usuário e esteja `FINALIZADA` e `aprovado: true`, com `percentual >= 65`. A emissão repetida não duplica a mesma tentativa. Um certificado revogado não pode ser reativado por essa rota.

### 5.16 Validação pública — `GET /api/certificados/validar/:codigo`

**Não exige JWT.** `:codigo` é o UUID de validação do certificado; não é seu ID numérico interno.

```http
GET /api/certificados/validar/4de3ad74-7932-43f6-a02c-83d6c3e2fe27 HTTP/1.1
```

**Sucesso — `200 OK`:**

```json
{
  "valido": true,
  "certificado": {
    "codigo_validacao": "4de3ad74-7932-43f6-a02c-83d6c3e2fe27",
    "emitido_em": "2026-11-18T17:45:00",
    "score": 8,
    "percentual": 66.67,
    "usuarios": { "nome": "Pessoa de Exemplo" }
  }
}
```

**Não encontrado/revogado — `404 Not Found`:**

```json
{ "valido": false, "erro": "Certificado não encontrado ou revogado." }
```

A validação pública não devolve CPF ou e-mail. O QR Code mostrado na página do certificado aponta para `validar-certificado.html`, que por sua vez consulta essa rota.

### 5.17 Perfil — `GET /api/usuarios/me`, `PATCH /api/usuarios/me`, `PATCH /api/usuarios/me/senha`

**Consultar:** `GET /api/usuarios/me` → objeto com `id`, `nome`, `email` e `cpf` do próprio usuário.  
**Editar:** `PATCH /api/usuarios/me` com `{ "nome": "Novo nome", "email": "novo@dominio.test" }` → `200` e dados atualizados. Só os campos `nome` e `email` são aceitos.  
**Senha:** `PATCH /api/usuarios/me/senha` com `{ "senhaAtual": "SenhaAntiga123!", "novaSenha": "SenhaNova123!" }` → `204`, sem corpo; sessões anteriores deixam de valer.

## 6. Códigos HTTP e tratamento de erros

| Código | Significado | Exemplos no projeto |
|---|---|---|
| `200 OK` | Consulta ou alteração concluída | Listagens, progresso, quiz, emissão e validação |
| `201 Created` | Recurso/operação criada | Cadastro, criação de prova/resposta e cadastros administrativos |
| `204 No Content` | Conclusão sem corpo | Logout, troca de senha e alguns `DELETE` |
| `400 Bad Request` | Corpo/ID/sessão inválido | CPF mal formatado, UUID inválido, alternativa inadequada |
| `401 Unauthorized` | Token ausente, inválido, expirado ou revogado | Rotas privadas |
| `403 Forbidden` | Usuário sem permissão ou sem pré-requisito | Administrador e estudos pendentes |
| `404 Not Found` | Recurso ausente ou não pertencente ao usuário | Tentativa ou certificado inexistente |
| `405 Method Not Allowed` | Método incompatível em rotas com verificação explícita | Continuidade e perfil |
| `409 Conflict` | Regra de negócio impede a operação | Tempo esgotado, prova incompleta, sessão inválida, quiz insuficiente |
| `413 Payload Too Large` | Requisição muito grande | Limite do JSON da aplicação |
| `429 Too Many Requests` | Limite de autenticação excedido | Login/cadastro |
| `500 Internal Server Error` | Falha interna | Erro inesperado |
| `503 Service Unavailable` | Banco/sessão indisponível | Diagnóstico, acesso a dados, verificação de revogação |

**Formato de erro comum:**

```json
{ "erro": "Mensagem resumida e adequada ao usuário." }
```

O backend evita devolver detalhes SQL ou segredos de infraestrutura. Em alguns erros internos gera cabeçalho `X-Request-ID` para correlação com o log.

## 7. Fluxo principal de integração frontend–backend

1. O usuário faz cadastro e login; o navegador guarda o token de sessão segundo a implementação do frontend.
2. O frontend consulta `GET /api/temas`, abre `GET /api/temas/:id/conteudos` e exibe materiais de estudo.
3. Para cada tema, consulta `GET /api/temas/:id/questoes`, responde às quatro questões por `POST /api/questoes/:id/responder` e conclui com `PUT /api/temas/:id/conclusao` após atingir três acertos.
4. O frontend usa `GET /api/estudos/progresso` para acompanhar os 12 temas concluídos.
5. Na certificação, gera UUID de sessão, consulta `GET /api/tentativas/atual` e executa `POST /api/tentativas` ou retoma uma tentativa já iniciada.
6. Abre a questão (`GET /api/tentativas/:id/proxima-questao`), responde (`POST /api/tentativas/:id/respostas`), envia presença e alterna entre avançar/pausar/retomar. A API controla prazo e sessão.
7. Depois das 12 questões, finaliza por `POST /api/tentativas/:id/finalizar`; a apuração é feita no banco.
8. Consulta `GET /api/historico` e `GET /api/historico/:id` para resultado e revisão.
9. Se aprovado, chama `POST /api/certificados/tentativas/:id`; a página renderiza certificado e QR Code.
10. Qualquer pessoa pode validar o certificado pela rota pública com UUID.

## 8. Estrutura de dados resumida

| Tabela | Responsabilidade | Relação principal |
|---|---|---|
| `usuarios` | Cadastro, senha hash e versão da sessão | Um usuário possui diversos progressos e tentativas |
| `temas` | Os 12 assuntos de aprendizagem | Um tema possui conteúdos e questões |
| `conteudos` | Materiais e links para estudo | Relacionada a `temas` |
| `questoes` | Enunciados e imagens de perguntas | Relacionada a `temas` |
| `alternativas` | Quatro respostas possíveis e indicação de correta | Relacionada a `questoes` |
| `respostas_estudos` | Respostas individuais do quiz por tema | Relaciona usuários e questões |
| `progresso_estudos` | Temas concluídos por candidato | Relaciona usuários e temas |
| `tentativas` | Provas, status, sessão, datas, pontuação | Relacionada a `usuarios` |
| `tentativas_questoes` | Questões sorteadas, ordem e estado | Relaciona tentativas e questões |
| `respostas` | Respostas transacionais da prova | Relaciona tentativa, questão e alternativa |
| `certificados` | Emissão, validade, código UUID e revogação | Relaciona usuário e tentativa |

As tabelas, índices, regras de integridade, permissões e funções do banco estão consolidados em `backend/database/schema.sql`; a carga de temas/materiais/questões/alternativas está em `backend/database/seed.sql`.

## 9. Execução do projeto e testes

### 9.1 Ambiente completo com Docker Compose

Na **raiz** do repositório:

```bash
node scripts/preparar-compose.mjs
docker compose --env-file .env.compose up --build -d
```

Acesso: `http://localhost:3000`. O Compose reúne `database`, `migrate`, `rest`, `gateway` e `app`. O script prepara variáveis locais aleatórias em `.env.compose` (não versionadas).

### 9.2 Backend usando Supabase

1. Aplicar `backend/database/schema.sql` e depois `backend/database/seed.sql` no banco de teste.
2. Preencher `backend/.env` com `SUPABASE_URL`, `SUPABASE_SECRET_KEY`, `JWT_SECRET` e, se necessário, `ADMIN_USER_IDS`.
3. Executar:

```bash
cd backend
npm ci
npm start
```

Nunca versionar `.env`, `JWT_SECRET` ou `SUPABASE_SECRET_KEY`. A chave de serviço fica apenas no backend.

### 9.3 Testes disponíveis

```bash
cd backend
npm test
```

Na raiz, com Docker e ambiente adequado:

```bash
MSYS_NO_PATHCONV=1 bash scripts/validar-seguranca.sh  # Git Bash/Windows
node scripts/validar-container.mjs               # Compose em execução
```

## 10. Referências técnicas

- Repositório geral: https://github.com/ctrlaltdevs0-droid/ABP_1
- README do backend: https://github.com/ctrlaltdevs0-droid/ABP_1/blob/main/backend/README.md
- Funcionalidades e operação (Sprint 3): https://github.com/ctrlaltdevs0-droid/ABP_1/blob/main/docs/sprint-3/FUNCIONALIDADES_E_OPERACAO.md
- Continuidade da prova (contrato): https://github.com/ctrlaltdevs0-droid/ABP_1/blob/main/docs/sprint-2/CONTINUIDADE_CERTIFICACAO.md
- Middleware de autorização: https://github.com/ctrlaltdevs0-droid/ABP_1/blob/main/backend/src/middleware/autorizacao.js
- Código das rotas: https://github.com/ctrlaltdevs0-droid/ABP_1/tree/main/backend/src/routes
- Esquema do banco: https://github.com/ctrlaltdevs0-droid/ABP_1/blob/main/backend/database/schema.sql
