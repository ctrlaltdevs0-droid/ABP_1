# API ÁgilCert

Requer Node.js 22 ou superior. A API utiliza exclusivamente o cliente Supabase
de `src/config/supabase.js`; não há conexão direta com PostgreSQL na aplicação.

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

## Banco de dados

Toda a estrutura, compatibilidade com tabelas existentes, funcoes e permissoes
fica em `backend/database/schema.sql`. A carga de conteudos fica em
`backend/database/seed.sql`. Nao ha migrations separadas.

No SQL Editor do Supabase configurado em `backend/.env`, executar primeiro
`schema.sql`. Executar `seed.sql` quando desejar carregar os materiais e
questoes do repositorio. Ambos suportam reaplicacao no estado validado; nao
apagam registros existentes. O servidor Node nao aplica SQL automaticamente.

## Testes

Execute `npm test`. Os testes exercitam a API via HTTP com respostas simuladas
do Supabase, incluindo cadastro, hash de senha, login, JWT, falhas e ausência
de dados pessoais no diagnóstico.
Não comprovam o estado das permissões de um banco remoto.

## Docker

Docker fica para etapa posterior. O provisionamento local foi ajustado para
ler somente `schema.sql` e `seed.sql`, sem executar Docker nesta alteracao.

## Estudos e dívida da Sprint 2

A página `/estudos.html` lista temas, abre os materiais e registra conclusão
no servidor. `GET /api/estudos/progresso` retorna as conclusões do candidato;
`PUT /api/temas/:id/conclusao` marca o tema como concluído, de forma idempotente.
Ambas exigem o JWT da aplicação. O proprietário vem exclusivamente do token;
o corpo não pode selecionar outro candidato. Conclusões repetidas preservam a
data original. Um tema inativo ou sem material publicado não pode ser concluído.

A pasta `backend/database` contém somente:

- `schema.sql`: estrutura completa, compatibilidade, funcoes e permissoes;
- `seed.sql`: temas, materiais, questões, alternativas e validação da carga.

Alteracoes de banco devem ser incorporadas somente nesses dois arquivos.
O schema usa os papeis padrao `anon`, `authenticated` e `service_role`.

A carga de temas atualiza descrição e ordem sem trocar IDs ou reativar temas
desativados. As cargas de materiais e questões possuem códigos estáveis e
preservam edições existentes ao serem repetidas. Materiais já cadastrados sem
código continuam preservados: conferir sobreposição editorial antes da carga.

A fonte editável é `backend/scripts/data/content-estudos.json`. Execute
`npm run seed:gerar` no backend após editar o conteúdo e versione o SQL gerado.
Os materiais incluem links complementares. As questões possuem quatro
alternativas e um gabarito, com posições variadas; entram com `status = false`
e `status_editorial = 'RASCUNHO'`. A prova exige 12 temas ativos, cada um com
pelo menos quatro questões ativas/APROVADO e quatro alternativas/um gabarito.
Após revisão cruzada, registrar `REVISAO`/`APROVADO` e ativar somente o conteúdo
aprovado. O índice de alternativas impede duas corretas para a mesma questão;
A validação incluída em `seed.sql` verifica também ausência de gabarito e quantidade de opções.
O catálogo de questões e os gabaritos continuam restritos a administradores.

## Devolutiva: sessão e ambiente completo

O logout agora exige `POST /api/login/sair` com Bearer JWT e revoga o token no
banco. O `schema.sql` inclui a tabela de revogacao, RLS e permissoes de
servidor compativeis com o JWT proprio do projeto.
Sem acesso ao registro de revogação, rotas privadas falham com 503.

Para reproduzir tudo sem Supabase remoto, seguir o Compose completo descrito em
`docs/geral/ARQUITETURA_EXECUCAO.md`. Ele substitui o experimento anterior de
PostgreSQL isolado por um ambiente que integra a Data API utilizada pelo backend.
O provisionamento ocorre em serviço próprio, não apenas no primeiro boot do volume.

## Segurança da prova e das sessões

Aplicar `backend/database/schema.sql` antes de iniciar o backend.
As funcoes nativas de prova estao incluidas no schema. As rotas em
`routes/tentativas.js` usam essas RPCs transacionais e sempre derivam o usuario
do JWT validado, sem aceitar a identidade enviada no corpo da requisicao.

- Tentativas legadas sem ordem persistida são recusadas; iniciar nova prova.
- Login: até 30 chamadas/IP e 10/conta por janela de 15 minutos. Cadastro:
  até 10/IP e 10/conta na mesma janela. Todas as chamadas contam, inclusive as
  bem-sucedidas. Ao exceder, a API responde 429 e `Retry-After`.
  Contadores ficam no banco e usam HMAC, sem CPF/IP em texto. Falha no limitador
  responde 503 antes de consultar senha ou executar bcrypt. O logout não é limitado.
- A API usa o endereço da conexão e não confia em `X-Forwarded-For`. Atrás de
  proxy, configurar explicitamente os proxies confiáveis antes de usar IP do
  cliente; sem isso, clientes do mesmo proxy compartilham o limite por IP.
- Troca de senha incrementa a versão de sessão atomicamente. Todas as sessões
  anteriores recebem 401; o frontend apaga a sessão atual e direciona ao login.
- Erros SQL não são enviados ao cliente. Falhas internas possuem identificador
  para correlação no log, com o código do erro, sem mensagem SQL ou credenciais.

Verificação:

```sh
cd backend && npm test
# Na raiz, requer Docker e a imagem postgres:17.11-bookworm:
bash scripts/validar-seguranca.sh
```

O segundo comando cria e remove seu próprio PostgreSQL efêmero, sem portas
publicadas, sem rede e sem acesso aos volumes do ambiente existente. Inclui
concorrência, timeout, rollback, permissões, senha e recuperação do limitador.
Os testes de banco ficam explicitamente ignorados no `npm test` comum.
