# API ÁgilCert

Requer Node.js 22 ou superior. A API utiliza exclusivamente o cliente Supabase
de `database/config.js`; não há conexão direta com PostgreSQL na aplicação.

## Configuração

1. Copie `.env.example` para `backend/.env` (ou para `.env` na raiz).
2. Preencha `SUPABASE_URL` com a URL base do seu projeto (sem `/rest/v1/`).
3. Preencha `SUPABASE_SECRET_KEY` com a chave secreta do servidor.
4. Defina `JWT_SECRET` com um segredo aleatório de pelo menos 32 caracteres.
   Gere um com `node -e "console.log(require('node:crypto').randomBytes(32).toString('hex'))"`.
5. Na pasta `backend`, execute `npm ci` e `npm start` (ou `npm run dev`).
   Todas as dependências ficam no backend; não é necessário instalar na raiz.

O carregador lê primeiro `backend/.env`, depois o `.env` da raiz para completar
valores ausentes, sem depender da pasta do terminal. Variáveis do ambiente têm
prioridade; hospedagens que as fornecem diretamente não precisam criar um `.env`.
Abra `http://localhost:3000` (ou a porta de `PORT`) para usar o frontend servido
pelo próprio backend. Apenas `frontend/src` é público; `.env` e código do
backend não são servidos.

## Rotas

Os handlers das páginas são conectados ao Express por `executarRotas`, que
recebe o caminho completo e o cliente Supabase. `lerJson` reutiliza `req.body`
quando o Express já leu o JSON; não tenta ler o mesmo stream duas vezes.
Rotas desconhecidas retornam 404 em JSON.

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

Envie `Authorization: Bearer <token>` nas rotas privadas. Temas ativos são
públicos; conteúdos de estudo exigem login. Tentativas e certificados só podem
ser acessados pelo dono (ou administrador). O usuário da nova tentativa vem do
JWT, não do corpo enviado. Para administração do catálogo e leitura de gabaritos,
configure `ADMIN_USER_IDS` com os IDs de usuários autorizados, separados por
vírgula. Sem essa configuração, nenhum usuário tem acesso administrativo.

O cadastro exige a coluna `usuarios.email`. Antes de implantar em um banco
existente, execute `supabase/migrations/20261014155615_add_usuarios_email.sql`
no SQL Editor do projeto. O script adiciona a coluna sem apagar registros ou
alterar RLS. Usuários antigos permanecem com e-mail nulo até a atualização de
seus dados; novos cadastros exigem e-mail na API. Para um banco novo, utilize
`backend/database/schema.sql`. Não execute esse schema inteiro sobre tabelas
existentes.

As rotas de tentativas e certificados também exigem
`supabase/migrations/20261014171024_align_attempt_routes.sql` depois do schema
base. A migração adiciona respostas vinculadas às questões da tentativa, impede
respostas duplicadas e cria os campos de validação do certificado. A tabela de
respostas mantém RLS ativa e acesso restrito ao backend. A migração não é
executada automaticamente ao iniciar o servidor.

## Testes

Execute `npm test`. Os testes exercitam a API via HTTP com respostas simuladas
do Supabase, incluindo cadastro, hash de senha, login, JWT, falhas e ausência
de dados pessoais no diagnóstico.
Não comprovam o estado das permissões de um banco remoto.

## PostgreSQL opcional

O serviço `database` do `compose.yaml` serve para experimentar os scripts SQL localmente.
O serviço `app` executa este backend e serve o frontend; veja as instruções de Docker Compose no README da raiz.
Defina `POSTGRES_PASSWORD` no `.env` e execute `docker compose up -d database`
na raiz. A porta no computador é `5433`; dentro do contêiner é `5432`.
A API continua usando Supabase. Os scripts de inicialização são executados
somente na criação de um volume vazio e não migram um banco existente.

## Estudos e dívida da Sprint 2

A página `/estudos.html` lista temas, abre os materiais e registra conclusão
no servidor. `GET /api/estudos/progresso` retorna as conclusões do candidato;
`PUT /api/temas/:id/conclusao` marca o tema como concluído, de forma idempotente.
Ambas exigem o JWT da aplicação. O proprietário vem exclusivamente do token;
o corpo não pode selecionar outro candidato. Conclusões repetidas preservam a
data original. Um tema inativo ou sem material publicado não pode ser concluído.

Para atualizar um banco existente, executar no SQL Editor, na ordem:

1. `supabase/migrations/20261026220734_sprint2_studies_debt.sql`;
2. `backend/database/seed.sql`;
3. `backend/database/seed-estudos.sql`;
4. `backend/database/validar-estudos.sql`.

Para banco novo, executar primeiro `backend/database/schema.sql`. A migração
usa os papéis padrão do Supabase (`anon`, `authenticated`, `service_role`).
Não executar o schema sobre tabelas existentes. A inicialização por Compose
não atualiza volumes existentes; os scripts acima devem ser aplicados explicitamente.

A carga de temas atualiza descrição e ordem sem trocar IDs ou reativar temas
desativados. As cargas de materiais e questões possuem códigos estáveis e
preservam edições existentes ao serem repetidas. Materiais já cadastrados sem
código continuam preservados: conferir sobreposição editorial antes da carga.

A fonte editável é `backend/database/content-estudos.json`. Execute
`npm run seed:gerar` no backend após editar o conteúdo e versione o SQL gerado.
Os materiais incluem links complementares. As questões possuem quatro
alternativas e um gabarito, com posições variadas; entram com `status = false`
e `status_editorial = 'RASCUNHO'`. Atenção: o sorteio atual ainda precisa filtrar
questões ativas e aprovadas; esses campos sozinhos não bloqueiam rascunhos.
Essa correção é prioritária antes de usar a certificação.
Após revisão cruzada, registrar `REVISAO`/`APROVADO` e ativar somente o conteúdo
aprovado. O índice de alternativas impede duas corretas para a mesma questão;
`validar-estudos.sql` verifica também ausência de gabarito e quantidade de opções.
O catálogo de questões e os gabaritos continuam restritos a administradores.

## Devolutiva: sessão e ambiente completo

O logout agora exige `POST /api/login/sair` com Bearer JWT e revoga o token no
banco. Aplicar `20261026225026_logout_revocation_and_api_grants.sql` no Supabase
antes de atualizar o backend. Ela também habilita RLS e restringe as tabelas da
aplicação ao papel de servidor, compatível com o JWT próprio do projeto.
Sem acesso ao registro de revogação, rotas privadas falham com 503.

Para reproduzir tudo sem Supabase remoto, seguir o Compose completo descrito em
`docs/geral/ARQUITETURA_EXECUCAO.md`. Ele substitui o experimento anterior de
PostgreSQL isolado por um ambiente que integra a Data API utilizada pelo backend.
O provisionamento ocorre em serviço próprio, não apenas no primeiro boot do volume.
