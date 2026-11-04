# Arquitetura e banco de dados

O Express serve o frontend e valida o JWT proprio da aplicacao. O cliente em
`backend/src/config/supabase.js` le `backend/.env` e acessa a Data API do
Supabase indicado por `SUPABASE_URL`. A chave secreta fica somente no backend.

## Fontes do banco

Todas as alteracoes estruturais, funcoes e permissoes ficam em
`backend/database/schema.sql`; a carga fica em `backend/database/seed.sql`.
Nao existem migrations separadas. Aplicar primeiro o schema e depois o seed,
quando a carga for desejada, no SQL Editor do projeto correto. O schema e
reaplicavel nos estados testados, preserva dados e adapta tabelas legadas.
O seed preserva edicoes de conteudos com codigo ja registrado; questoes novas
entram como rascunhos. Revisao editorial e publicacao sao etapas separadas.

O banco inclui usuarios, temas, conteudos, questoes, alternativas, tentativas,
tentativas_questoes, respostas, certificados, progresso_estudos,
respostas_estudos, sessoes_revogadas e limites_autenticacao. Acesso pelo backend
usa service_role; RLS bloqueia o acesso direto dos papeis de cliente.

## Execucao atual

Configurar `backend/.env`, executar `npm ci` e `npm start` na pasta backend.
O servidor nao aplica SQL automaticamente. A aplicacao continua usando o
Supabase remoto. Em 04/11/2026, o schema consolidado foi aplicado ao projeto
`lmohayvlvwzxlslornwp` depois da criacao de um dump de restauracao.

As rotas de tentativas chamam as funcoes transacionais do schema para iniciar,
entregar questoes, registrar respostas e finalizar a prova. O usuario e sempre
derivado do JWT validado pelo backend.

## Docker — etapa posterior

O Compose existente oferece database, migrate, rest, gateway e app. O runner
`infra/migrate.sh` agora executa apenas schema.sql e seed.sql, sem varrer uma
pasta de migrations e sem recusar evolucoes desses arquivos por checksum antigo.
Metadados app_private de volumes antigos permanecem intocados e nao sao mais
usados. O bootstrap de papeis/conexao em infra e exclusivo do ambiente local;
no Supabase esses papeis ja existem. Docker nao foi executado nesta alteracao.

Para futura execucao local, seguir os comandos de Compose no README principal.
Nao remover volumes para atualizar a estrutura.
