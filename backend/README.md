# API ÁgilCert

Requer Node.js 22 ou superior. A API utiliza exclusivamente o cliente Supabase
de `database/config.js`; não há conexão direta com PostgreSQL na aplicação.

## Configuração

1. Copie `.env.example` para `.env` na raiz do repositório.
2. Preencha `SUPABASE_URL` com a URL base do seu projeto (sem `/rest/v1/`).
3. Preencha `SUPABASE_SECRET_KEY` com a chave secreta do servidor.
4. Defina `JWT_SECRET` com um segredo aleatório de pelo menos 32 caracteres.
   Gere um com `node -e "console.log(require('node:crypto').randomBytes(32).toString('hex'))"`.
5. Na pasta `backend`, execute `npm ci` e `npm start` (ou `npm run dev`).
   Todas as dependências ficam no backend; não é necessário instalar na raiz.

O `.env` é carregado pela localização do módulo, sem depender da pasta do
terminal. Variáveis do ambiente têm prioridade; hospedagens que as fornecem
diretamente não precisam criar um `.env`.

## Rotas

- `GET /api`: estado do servidor.
- `GET /api/temas`: temas ativos, ordenados por `ordem`.
- `POST /api/login/cadastro`: cadastro com CPF, nome, e-mail e senha.
- `POST /api/login/entrar`: login com CPF e senha; emite JWT válido por duas horas.
- `GET /api/teste-supabase`: consulta HEAD em temas e retorna somente `status`.
  Se o banco falhar, retorna HTTP 503 sem registros ou detalhes internos.

Mantenha a RLS ativa. A chave secreta usa privilégios de servidor e ignora RLS:
ela fica somente no backend. A seleção de temas ativos é explícita na API.
Rotas de dados pessoais precisam de autenticação e autorização antes de serem
implementadas. O JWT emitido é da aplicação, não uma sessão do Supabase Auth;
ele não concede acesso direto às tabelas via RLS. Novas rotas privadas precisam
validar esse JWT no backend antes de consultar os dados do usuário.

O cadastro exige a coluna `usuarios.email`. Antes de implantar em um banco
existente, execute `supabase/migrations/20261014155615_add_usuarios_email.sql`
no SQL Editor do projeto. O script adiciona a coluna sem apagar registros ou
alterar RLS. Usuários antigos permanecem com e-mail nulo até a atualização de
seus dados; novos cadastros exigem e-mail na API. Para um banco novo, utilize
`backend/database/schema.sql`. Não execute esse schema inteiro sobre tabelas
existentes.

## Testes

Execute `npm test`. Os testes exercitam a API via HTTP com respostas simuladas
do Supabase, incluindo cadastro, hash de senha, login, JWT, falhas e ausência
de dados pessoais no diagnóstico.
Não comprovam o estado das permissões de um banco remoto.

## PostgreSQL opcional

O `compose.yaml` serve apenas para experimentar os scripts SQL localmente.
Defina `POSTGRES_PASSWORD` no `.env` e execute `docker compose up -d database`
na raiz. A porta no computador é `5433`; dentro do contêiner é `5432`.
A API continua usando Supabase. Os scripts de inicialização são executados
somente na criação de um volume vazio e não migram um banco existente.
