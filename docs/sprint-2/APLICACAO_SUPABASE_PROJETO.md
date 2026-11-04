# Banco do projeto

Projeto configurado no backend: `lmohayvlvwzxlslornwp`.

As unicas fontes de alteracoes de banco sao:

- `backend/database/schema.sql`: estrutura completa, adaptacao do banco legado, funcoes nativas, indices e permissoes.
- `backend/database/seed.sql`: carga de temas, materiais, questoes e alternativas.

Executar `schema.sql` completo no SQL Editor do Supabase do projeto. Ele cria
objetos ausentes e compatibiliza as tabelas existentes sem apaga-las. Depois,
executar `seed.sql` se a carga de conteudo for desejada; dados sem codigo de
seed sao preservados, portanto revisar possivel sobreposicao editorial.

O schema preserva respostas e certificados legados, o limitador existente,
`respostas_estudos` e `sessao_prova`. Nao utiliza `cert_s2_*`.
Respostas legadas sem alternativa correspondente interrompem a transacao para
revisao. Certificados antigos nao recebem vinculos de tentativa inventados.

As rotas de tentativas usam as funcoes nativas instaladas pelo schema. O fluxo
transacional deriva o usuario do JWT e nao aceita a identidade enviada pelo
navegador.

Em 04/11/2026, foi criado um dump do estado anterior e o `schema.sql` foi
aplicado no projeto remoto. A estrutura resultante foi comparada com uma
aplicacao local sobre o dump: ambas produziram o mesmo hash estrutural
normalizado, com 13 tabelas, 82 colunas, 42 constraints, 36 indices, 7 funcoes
e RLS ativo nas 13 tabelas.

Docker fica para etapa posterior; seus scripts apenas foram ajustados para os
dois arquivos.
