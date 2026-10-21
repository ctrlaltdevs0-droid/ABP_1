# 🟢 CTRL ALT DEVS — SPRINT 1

## Fundação e Acesso

**Projeto:** Portal de Certificação em Metodologias Ágeis  
**Sprint:** Sprint 1  
**Período:** 28/09/2026 a 22/10/2026  
**Meta:** Construir a base técnica e permitir que o candidato se cadastre, entre no portal e acesse os conteúdos dos 12 temas.  
**Estimativa total:** 91 SP  
**Quantidade de PBIs:** 25

---

# 1. Configuração sugerida do GitHub Projects

## Campos do Project

Criar os seguintes campos no GitHub Projects:

| Campo | Tipo | Valores sugeridos |
|---|---|---|
| Status | Single select | Product Backlog, Ready, Sprint Backlog, Em Desenvolvimento, Em Teste, Em Validação, Done |
| Sprint | Iteration | Sprint 1 |
| Prioridade | Single select | Alta, Média, Baixa |
| Story Points | Number | Fibonacci |
| Frente | Single select | Estilização, Frontend, Backend, Conteúdo, Documentação |
| Responsável | Assignee | Integrante da equipe |
| Tipo | Single select | PBI, Task, Bug, Spike |
| Dependência | Text | PBI ou tarefa predecessora |

---

# 2. Sprint Goal

> Construir a fundação técnica da aplicação e permitir que o candidato realize cadastro, autenticação, logout e acesso à área inicial de estudos com os 12 temas.

## Resultado esperado para a Sprint Review

- aplicação inicializada por Docker Compose;
- PostgreSQL funcionando;
- backend conectado ao banco;
- cadastro funcionando;
- login funcionando;
- logout funcionando;
- rotas protegidas;
- página inicial disponível;
- área de estudos com 12 temas;
- conteúdo inicial disponível;
- progresso de leitura registrado;
- DER atualizado;
- README funcional;
- base das 48 questões estruturada.

---

# 3. Sprint Backlog

## Fundação

### PB-001 — Definir os 12 temas oficiais

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Conteúdo  
**Status inicial:** Ready

### Critérios de aceite

- [ ] Existem exatamente 12 temas.
- [ ] Cada tema possui identificador.
- [ ] Cada tema possui nome.
- [ ] Cada tema possui descrição.
- [ ] Cada tema possui ordem definida.
- [ ] Os temas foram aprovados pela equipe.

### Tasks

- [ ] Levantar os 12 temas oficiais.
- [ ] Definir nome e descrição.
- [ ] Definir ordem de apresentação.
- [ ] Registrar os temas no banco.
- [ ] Validar os temas com a equipe.

---

### PB-002 — Estruturar o projeto

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Backend / Frontend  
**Status inicial:** Ready

### Critérios de aceite

- [ ] O projeto possui separação entre frontend, backend e infraestrutura.
- [ ] A estrutura está versionada no GitHub.
- [ ] Arquivos temporários e dependências não são versionados.

### Tasks

- [ ] Criar pasta `frontend`.
- [ ] Criar pasta `backend`.
- [ ] Criar estrutura de infraestrutura.
- [ ] Criar `.gitignore`.
- [ ] Criar `.env.example`.
- [ ] Padronizar organização inicial do repositório.

---

### PB-003 — Configurar PostgreSQL

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Backend  
**Status inicial:** Ready

### Critérios de aceite

- [ ] PostgreSQL inicia corretamente.
- [ ] Banco possui volume persistente.
- [ ] Backend consegue acessar o banco.
- [ ] Credenciais reais não estão no Git.

### Tasks

- [ ] Configurar PostgreSQL.
- [ ] Configurar banco da aplicação.
- [ ] Configurar usuário e senha por variável de ambiente.
- [ ] Criar volume persistente.
- [ ] Testar conexão.
- [ ] Validar acesso pelo pgAdmin.

---

### PB-004 — Criar modelo inicial do banco

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 5  
**Frente:** Backend  
**Status inicial:** Ready  
**Dependência:** PB-003

### Entidades mínimas

- candidato;
- tema;
- conteúdo;
- questão;
- alternativa;
- tentativa;
- questão da tentativa;
- resposta;
- certificado.

### Critérios de aceite

- [ ] Todas as entidades principais estão modeladas.
- [ ] Existem PKs.
- [ ] Existem FKs.
- [ ] Registros órfãos são impedidos.
- [ ] Constraints essenciais estão configuradas.
- [ ] Índices necessários foram definidos.

### Tasks

- [ ] Criar tabelas.
- [ ] Criar chaves primárias.
- [ ] Criar chaves estrangeiras.
- [ ] Criar constraints.
- [ ] Criar índices.
- [ ] Validar relacionamentos.

---

### PB-005 — Configurar Docker Compose

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Backend  
**Status inicial:** Ready

### Critérios de aceite

- [ ] Todos os serviços necessários iniciam por Docker Compose.
- [ ] Banco utiliza volume persistente.
- [ ] Variáveis de ambiente são utilizadas.
- [ ] Outro integrante consegue iniciar o ambiente.

### Tasks

- [ ] Criar `docker-compose.yml`.
- [ ] Criar Dockerfile do backend.
- [ ] Criar Dockerfile do frontend.
- [ ] Adicionar PostgreSQL.
- [ ] Configurar rede entre os serviços.
- [ ] Testar `docker compose up`.

---

### PB-006 — Criar carga inicial dos temas

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Backend  
**Status inicial:** Ready  
**Dependência:** PB-001, PB-004

### Critérios de aceite

- [ ] Os 12 temas são inseridos automaticamente ou por script reproduzível.
- [ ] Não há duplicidade na carga.
- [ ] A ordem dos temas é preservada.

### Tasks

- [ ] Criar script de seed.
- [ ] Inserir os 12 temas.
- [ ] Validar execução repetida.
- [ ] Documentar a carga.

---

# 4. Cadastro e autenticação

### PB-007 — Criar cadastro de candidato

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Frontend / Backend  
**Status inicial:** Ready  
**Dependência:** PB-004

### Critérios de aceite

- [ ] Cadastro exige CPF.
- [ ] Cadastro exige nome completo.
- [ ] Cadastro exige e-mail.
- [ ] Cadastro exige senha.
- [ ] Dados válidos criam uma conta.

### Tasks

- [ ] Criar formulário de cadastro.
- [ ] Criar endpoint de cadastro.
- [ ] Persistir candidato.
- [ ] Tratar erros de validação.
- [ ] Testar cadastro válido.

---

### PB-008 — Validar e normalizar CPF

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 2  
**Frente:** Backend  
**Status inicial:** Ready  
**Dependência:** PB-007

### Critérios de aceite

- [ ] CPF é normalizado antes da gravação.
- [ ] CPF inválido é rejeitado.
- [ ] CPF duplicado não cria novo usuário.
- [ ] Mensagem de duplicidade é clara.

### Tasks

- [ ] Remover máscara do CPF.
- [ ] Implementar validação.
- [ ] Criar índice único.
- [ ] Testar CPF inválido.
- [ ] Testar CPF duplicado.

---

### PB-009 — Proteger senha

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 2  
**Frente:** Backend  
**Status inicial:** Ready

### Critérios de aceite

- [ ] Senha nunca é gravada em texto puro.
- [ ] Senha é armazenada como hash seguro.
- [ ] Política mínima de senha é aplicada.

### Tasks

- [ ] Definir política de senha.
- [ ] Implementar hash.
- [ ] Implementar verificação.
- [ ] Criar testes.

---

### PB-010 — Implementar login

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Frontend / Backend  
**Status inicial:** Ready  
**Dependência:** PB-007, PB-009

### Critérios de aceite

- [ ] Login utiliza CPF e senha.
- [ ] Credenciais válidas autenticam o candidato.
- [ ] Credenciais inválidas exibem mensagem genérica.

### Tasks

- [ ] Criar página de login.
- [ ] Criar endpoint de login.
- [ ] Buscar candidato por CPF.
- [ ] Verificar senha.
- [ ] Criar resposta de autenticação.
- [ ] Testar login válido e inválido.

---

### PB-011 — Implementar sessão e rotas protegidas

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Backend / Frontend  
**Status inicial:** Ready  
**Dependência:** PB-010

### Critérios de aceite

- [ ] Usuário autenticado mantém sessão.
- [ ] Rotas privadas rejeitam acesso não autenticado.
- [ ] O frontend restaura a sessão corretamente.

### Tasks

- [ ] Definir estratégia de sessão/token.
- [ ] Criar middleware de autenticação.
- [ ] Criar proteção de rotas.
- [ ] Restaurar sessão no frontend.
- [ ] Testar acesso sem autenticação.

---

### PB-012 — Implementar logout

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 2  
**Frente:** Frontend / Backend  
**Status inicial:** Ready  
**Dependência:** PB-011

### Critérios de aceite

- [ ] Logout invalida a sessão.
- [ ] Usuário é redirecionado para área pública.
- [ ] Reutilização de sessão inválida é rejeitada.

### Tasks

- [ ] Criar endpoint de logout.
- [ ] Criar botão de logout.
- [ ] Limpar estado de autenticação.
- [ ] Redirecionar usuário.
- [ ] Testar logout.

---

# 5. Portal e área de estudos

### PB-013 — Criar layout principal

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Estilização / Frontend  
**Status inicial:** Ready

### Tasks

- [ ] Criar identidade visual.
- [ ] Criar cabeçalho.
- [ ] Criar navegação.
- [ ] Definir componentes base.
- [ ] Implementar layout responsivo.

---

### PB-014 — Criar página inicial

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Frontend  
**Status inicial:** Ready  
**Dependência:** PB-013

### Critérios de aceite

A home apresenta:

- [ ] objetivo da certificação;
- [ ] formato;
- [ ] tempo por questão;
- [ ] regra de aprovação;
- [ ] regras de interrupção;
- [ ] ação Estudar;
- [ ] ação Iniciar certificação;
- [ ] ação Continuar certificação.

---

### PB-015 — Listar os 12 temas

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 3  
**Frente:** Frontend / Backend  
**Status inicial:** Ready  
**Dependência:** PB-001, PB-006

### Critérios de aceite

- [ ] Os 12 temas são retornados pela API.
- [ ] Os 12 temas são exibidos no frontend.
- [ ] A ordem cadastrada é respeitada.

### Tasks

- [ ] Criar endpoint de temas.
- [ ] Consumir endpoint no frontend.
- [ ] Criar cards dos temas.
- [ ] Implementar carregamento.
- [ ] Implementar estado de erro.

---

### PB-016 — Criar página de conteúdo

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Frontend / Backend  
**Status inicial:** Ready  
**Dependência:** PB-015

### Critérios de aceite

- [ ] Cada tema pode ser aberto.
- [ ] O conteúdo textual é exibido.
- [ ] Existe suporte a imagem ou recurso complementar.
- [ ] Layout funciona em desktop e mobile.

---

### PB-017 — Registrar progresso de estudo

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Backend / Frontend  
**Status inicial:** Ready  
**Dependência:** PB-011, PB-016

### Critérios de aceite

- [ ] Progresso pertence ao candidato autenticado.
- [ ] Tema pode ser marcado como concluído.
- [ ] Estado é persistido.
- [ ] Estado é recuperado após novo login.

---

### PB-018 — Exibir progresso dos temas

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Frontend  
**Status inicial:** Ready  
**Dependência:** PB-017

### Critérios de aceite

- [ ] Tema concluído possui indicação visual.
- [ ] Tema pendente possui indicação visual.
- [ ] Progresso é recuperado da API.

---

# 6. Conteúdo

### PB-053 — Estruturar as 48 questões

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 13  
**Frente:** Conteúdo / Backend  
**Status inicial:** Ready  
**Dependência:** PB-001, PB-004

### Critérios de aceite

- [ ] Existem 4 questões para cada um dos 12 temas.
- [ ] Total de 48 questões.
- [ ] Cada questão possui enunciado.
- [ ] Cada questão possui quatro alternativas.
- [ ] Existe apenas uma alternativa correta.
- [ ] Questões possuem status editorial.

### Status editorial

```text
Rascunho → Revisão → Aprovado
```

### Tasks

- [ ] Criar estrutura de armazenamento.
- [ ] Criar modelo padrão de questão.
- [ ] Dividir temas entre integrantes.
- [ ] Produzir 48 questões.
- [ ] Realizar revisão cruzada.
- [ ] Validar quantidade por tema.
- [ ] Validar alternativas.

---

### PB-056 — Produzir material dos 12 temas

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 13  
**Frente:** Conteúdo / Frontend  
**Status inicial:** Ready  
**Dependência:** PB-001

### Critérios de aceite

- [ ] Todos os 12 temas possuem conteúdo.
- [ ] Linguagem é adequada ao público.
- [ ] Conteúdo passou por revisão.
- [ ] Conteúdo possui suporte a recurso visual quando necessário.

### Tasks

- [ ] Definir modelo padrão de conteúdo.
- [ ] Dividir temas entre integrantes.
- [ ] Produzir conteúdo.
- [ ] Revisar conteúdo.
- [ ] Inserir conteúdo na aplicação.

---

# 7. Documentação e gestão

### PB-065 — Elaborar DER

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Documentação / Backend  
**Status inicial:** Ready  
**Dependência:** PB-004

### Critérios de aceite

- [ ] DER corresponde ao banco implementado.
- [ ] Entidades estão identificadas.
- [ ] Relacionamentos estão documentados.
- [ ] DER está versionado no Git.

---

### PB-066 — Criar documentação de instalação

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 3  
**Frente:** Documentação  
**Status inicial:** Ready  
**Dependência:** PB-005

### Critérios de aceite

- [ ] README explica pré-requisitos.
- [ ] README explica configuração.
- [ ] README explica Docker Compose.
- [ ] Outro integrante consegue iniciar a aplicação.

---

### PB-069 — Definir estratégia Git

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 2  
**Frente:** Documentação  
**Status inicial:** Ready

### Tasks

- [ ] Definir branch principal.
- [ ] Definir branches de desenvolvimento.
- [ ] Definir padrão de Pull Request.
- [ ] Definir convenção de commits.

Exemplo:

```text
feat: nova funcionalidade
fix: correção
docs: documentação
refactor: refatoração
test: testes
chore: manutenção
```

---

### PB-070 — Configurar GitHub Projects

**Tipo:** PBI  
**Prioridade:** Alta  
**Story Points:** 2  
**Frente:** Gestão  
**Status inicial:** Ready

### Colunas/Status

```text
Product Backlog
    ↓
Ready
    ↓
Sprint Backlog
    ↓
Em Desenvolvimento
    ↓
Em Teste
    ↓
Em Validação
    ↓
Done
```

### Tasks

- [ ] Criar Project.
- [ ] Criar campo Status.
- [ ] Criar campo Sprint.
- [ ] Criar campo Story Points.
- [ ] Criar campo Prioridade.
- [ ] Criar campo Frente.
- [ ] Adicionar PBIs da Sprint 1.
- [ ] Associar Issues.
- [ ] Configurar visualização Board.
- [ ] Configurar visualização Table.

---

### PB-071 — Definir Definition of Done

**Tipo:** PBI  
**Prioridade:** Média  
**Story Points:** 2  
**Frente:** Gestão  
**Status inicial:** Ready

Um item só pode ir para **Done** quando:

- [ ] critérios de aceite atendidos;
- [ ] código integrado;
- [ ] revisão realizada por outro integrante;
- [ ] testes executados;
- [ ] frontend, backend e banco integrados quando aplicável;
- [ ] interface funcional em desktop e celular;
- [ ] erros tratados;
- [ ] nenhum segredo está versionado;
- [ ] migrations são reproduzíveis;
- [ ] documentação relacionada está atualizada;
- [ ] código está no GitHub;
- [ ] item foi validado pela equipe.

---

# 8. Dependências principais

```text
PB-001
 ├── PB-006
 ├── PB-015
 ├── PB-053
 └── PB-056

PB-003
 └── PB-004

PB-004
 ├── PB-006
 ├── PB-007
 └── PB-053

PB-007
 └── PB-010

PB-009
 └── PB-010

PB-010
 └── PB-011

PB-011
 ├── PB-012
 └── PB-017

PB-015
 └── PB-016

PB-016
 └── PB-017

PB-017
 └── PB-018
```

---

# 9. Ordem sugerida de execução

## Etapa 1 — Fundação

- PB-001
- PB-002
- PB-003
- PB-004
- PB-005
- PB-006

## Etapa 2 — Autenticação

- PB-007
- PB-008
- PB-009
- PB-010
- PB-011
- PB-012

## Etapa 3 — Portal

- PB-013
- PB-014
- PB-015
- PB-016
- PB-017
- PB-018

## Etapa 4 — Conteúdo

- PB-053
- PB-056

## Etapa 5 — Gestão e documentação

- PB-065
- PB-066
- PB-069
- PB-070
- PB-071

---

# 10. Testes mínimos da Sprint

## Cadastro válido

```gherkin
Cenário: cadastrar candidato válido
  Dado que o CPF ainda não está cadastrado
  Quando o candidato informar CPF, nome, e-mail e senha válidos
  Então a conta deve ser criada
  E a senha não deve ser armazenada em texto puro
```

## CPF duplicado

```gherkin
Cenário: impedir CPF duplicado
  Dado que já existe um candidato com o CPF informado
  Quando um novo cadastro utilizar o mesmo CPF
  Então o sistema deve recusar o cadastro
  E exibir uma mensagem clara
```

## Área de estudos

```gherkin
Cenário: acessar conteúdos de estudo
  Dado que o candidato está autenticado
  Quando acessar a área de estudos
  Então deve visualizar os 12 temas
  E conseguir acessar o conteúdo de cada tema
```

---

# 11. Critério de sucesso da Sprint

A Sprint será considerada bem-sucedida quando:

- [ ] uma pessoa consegue clonar o projeto e iniciar o ambiente seguindo o README;
- [ ] Docker Compose inicia os serviços;
- [ ] PostgreSQL funciona;
- [ ] backend conecta ao banco;
- [ ] candidato consegue se cadastrar;
- [ ] candidato consegue fazer login;
- [ ] candidato consegue fazer logout;
- [ ] rotas privadas estão protegidas;
- [ ] os 12 temas aparecem na área de estudos;
- [ ] conteúdos podem ser acessados;
- [ ] progresso pode ser registrado;
- [ ] estrutura das 48 questões está disponível;
- [ ] materiais dos 12 temas estão registrados;
- [ ] DER está atualizado;
- [ ] backlog da Sprint está atualizado no GitHub Projects.

---

# 12. Sprint Review

## Demonstração esperada

```text
git clone
   ↓
docker compose up
   ↓
Aplicação funcionando
   ↓
Cadastro
   ↓
Login
   ↓
Home
   ↓
Área de estudos
   ↓
12 temas
   ↓
Abrir conteúdo
   ↓
Registrar progresso
   ↓
Logout
```

---

<div align="center">

## 🟢 CTRL ALT DEVS

### SPRINT 1 — FUNDAÇÃO E ACESSO

`BUILD` **›** `FIX` **›** `REPEAT`

</div>
