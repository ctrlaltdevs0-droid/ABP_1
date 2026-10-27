# Arquitetura real e execução reproduzível

## Caminho das requisições

O navegador recebe HTML/CSS/JavaScript do Express e chama `/api` na mesma origem.
Express valida o JWT próprio da aplicação, verifica revogação de sessão e
aplica autorização. O cliente `@supabase/supabase-js` acessa a Data API por HTTP;
não usa conexão SQL direta nem Supabase Auth.

Dois ambientes são suportados:

| Ambiente | Destino do cliente Supabase | Banco |
|---|---|---|
| Node local + `.env` | Projeto Supabase configurado por `SUPABASE_URL` | PostgreSQL do Supabase remoto; migrações explícitas no SQL Editor |
| Compose completo local | Gateway interno `/rest/v1` → PostgREST | PostgreSQL local em volume separado |

O Compose local reproduz a parte utilizada do Supabase (Data API e PostgreSQL).
Não instala Studio, Auth, Storage ou Realtime, que não são utilizados no fluxo.
Não transforma o JWT do candidato em uma sessão do Supabase Auth.

## Serviços do Compose

| Serviço | Responsabilidade | Rede/estado |
|---|---|---|
| database | PostgreSQL 17.11; cria papéis locais | Sem porta publicada; volume `local_data` |
| migrate | Schema, migrações e cargas, na ordem | Executa após banco saudável e deve terminar com código 0 |
| rest | PostgREST, conexão como `authenticator` | Somente rede interna; assume `service_role` mediante JWT de serviço |
| gateway | Compatibiliza prefixo `/rest/v1/` usado pelo cliente | Somente rede interna |
| app | Express e arquivos do frontend | Única porta publicada, vinculada a `127.0.0.1` |

A aplicação executa com usuário `node`. Banco e gateway não ficam acessíveis
diretamente pelo navegador. O JWT de serviço é assinado por um segredo distinto
do JWT dos candidatos; ambos são gerados localmente. `service_role` ignora RLS,
logo a autorização do Express continua obrigatória. As tabelas têm RLS ativa e
não concedem acesso direto a `anon`/`authenticated`.

## Modelo relacional efetivamente utilizado

Fonte: `backend/database/schema.sql` e migrações posteriores; os diagramas
originais da equipe ficam preservados em `docs/geral/Diagramas`.

| Tabela | Chave e relacionamentos principais |
|---|---|
| usuarios | `idusuarios`; CPF único; nome, e-mail e hash de senha |
| temas | `idtemas`; nome único, ordem e ativo |
| conteudos | `idconteudo` → tema; texto, publicação e recurso complementar |
| questoes | `idquestoes` → tema; enunciado, imagem e status editorial |
| alternativas | `idalternativas` → questão; letra única por questão e gabarito |
| tentativas | `idtentativas` → usuário; estado, datas e resultado |
| tentativas_questoes | Chave composta tentativa/questão; indicador de resposta |
| respostas | `idrespostas`; uma resposta por tentativa/questão; vínculo e alternativa |
| certificados | `idcertificados` → usuário/tentativa; código de validação único |
| progresso_estudos | Chave composta usuário/tema; data de conclusão |
| sessoes_revogadas | SHA-256 do token como chave; validade e data de revogação |

O `app_private.schema_migrations` é metadado de implantação local e não é
exposto pelo PostgREST. O modelo atual da tentativa ainda não contém o prazo
por questão exigido pelo motor definitivo; essa lacuna permanece registrada
na revisão de segurança, sem alterar retroativamente os diagramas originais.

## Ambiente completo novo

Requer Docker Compose v2 e Node para gerar os segredos locais:

```bash
node scripts/preparar-compose.mjs
docker compose --env-file .env.compose up --build -d
docker compose --env-file .env.compose ps -a
```

Abra `http://localhost:3000/home.html`. Para outra porta, defina `APP_PORT` no
`.env.compose`. O arquivo é ignorado pelo Git, criado com modo 0600 e nunca
sobrescrito automaticamente. Não reutilizar essas credenciais em produção.
A chave local de serviço tem validade de um ano; sua renovação deve preservar
os demais segredos e ser coordenada com a configuração de PostgREST.

O Compose NÃO lê nem sobrescreve `backend/.env`. O banco antigo
`abp_supabase_db` e seu volume permanecem separados. A API executada com
`npm start` continua lendo o `.env` existente e usando o Supabase configurado.

## Provisionamento e migrações

`infra/00-roles.sh` cria os papéis necessários no banco vazio. Em seguida,
`infra/migrate.sh` executa:

1. `backend/database/schema.sql`;
2. todos os arquivos de `supabase/migrations`, por ordem de nome;
3. `backend/database/seed.sql`;
4. `backend/database/seed-estudos.sql`;
5. `backend/database/validar-estudos.sql`.

Cada etapa é registrada em `app_private.schema_migrations`, com checksum e data.
Uma transação por etapa inclui a aplicação e seu registro; um advisory lock
serializa execuções. Uma repetição pula arquivos já aplicados e recusa arquivos
históricos alterados. Adicionar novos arquivos de migração em vez de editar
arquivos já aplicados; atualizações futuras de carga exigem nova etapa versionada.
Esse controle é local ao Compose e não substitui o histórico da CLI Supabase.

Para aplicar novas migrações em um volume local existente:

```bash
docker compose --env-file .env.compose stop app rest gateway
docker compose --env-file .env.compose run --rm migrate
docker compose --env-file .env.compose up --build -d
```

Não aplicar o schema sobre banco legado. Adoção de volume antigo exige comparar
o schema, realizar backup e registrar a baseline antes de usar este runner.
`docker compose down` preserva os dados; `down -v` apaga volumes e não faz parte
do procedimento normal.

## Supabase remoto

Para execução fora do Compose, `backend/.env` continua necessário. Aplicar
somente migrações ainda não presentes no projeto remoto, incluindo
`20261026225026_logout_revocation_and_api_grants.sql`, além das cargas indicadas
no README do backend. Não executar o schema inteiro sobre tabelas existentes.
A revogação exige a nova tabela; se ela estiver indisponível, rotas privadas
respondem 503 em vez de aceitar uma sessão cuja revogação não pode ser verificada.

## Sessão e logout

`POST /api/login/sair` recebe o mesmo Bearer JWT das rotas privadas e grava
apenas seu SHA-256 em `sessoes_revogadas`, com validade e horário da revogação.
Cada requisição privada consulta esse registro. O token antigo recebe 401;
novo login emite JWT com `jti` único e mantém o progresso do candidato.
O frontend só remove a sessão após confirmação do servidor, ou se ela já foi
recusada com 401. Falhas de rede mantêm a opção de tentar sair novamente.
Registros de revogação expirados podem ser removidos por manutenção periódica;
não removê-los antes de `expira_em`.

## Verificações

```bash
cd backend
npm ci
npm test
cd ..
node scripts/validar-container.mjs
```

O teste integrado cria contas de validação no ambiente indicado por
`TEST_BASE_URL` (padrão `http://127.0.0.1:3000`). Executar em banco de teste.
Ele verifica cadastro/login, perfil, conteúdos dos 12 temas, progresso,
isolamento, revogação e novo login. O serviço `migrate` verifica ainda 48 questões,
192 alternativas e um gabarito por questão.

As questões continuam rascunhos até revisão editorial. A certificação completa
não é declarada pronta. Antes de implantação pública, resolver os P0 registrados
na revisão de segurança, configurar TLS e limitação de tentativas de autenticação.
