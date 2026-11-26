# Funcionalidades e operação do ÁgilCert (PB-068)

- **Issue:** #97
- **Data:** 17/11/2026, atualizado em 18/11/2026
- **Base:** branch `main` no commit `bdef147`, com os textos de estudo da PB-057 (PR #101) e os ajustes do certificado e da validação pública de 17 e 18/11
- **Requisito do desafio:** RNF06 (instruções de instalação e descrição das funcionalidades implementadas)

Este documento explica como executar o portal, como o banco é carregado, como rodar os testes e o que cada funcionalidade faz hoje. O que ainda não está pronto aparece em [Limitações conhecidas](#limitações-conhecidas).

As funcionalidades foram conferidas no código, nos testes automatizados e, em 18/11/2026, no navegador, com o ambiente completo do Docker (seção 5). O teste completo do sistema continua sendo a PB-063 (#94).

## 1. Visão geral

| Parte | Tecnologia | Onde fica |
|---|---|---|
| Frontend | HTML, CSS e JavaScript, sem framework | `frontend/src/` |
| Backend (API) | Node.js e Express | `backend/src/` |
| Banco de dados | PostgreSQL, acessado pela Data API (Supabase ou PostgREST local) | `backend/database/` |
| Containers | Docker Compose | `compose.yaml` e `infra/` |

O backend serve as páginas do frontend e a API no mesmo endereço. O frontend nunca acessa o banco diretamente.

Outros documentos:

- **Modelo de dados:** [diagrama de classes](../geral/Diagramas/DiagramaClasse.png) e [diagrama de sequência](../geral/Diagramas/DiagramaSequencia.png).
- **API:** [README do backend](../../backend/README.md) e [contrato das rotas da prova](../sprint-2/CONTINUIDADE_CERTIFICACAO.md). A documentação completa da API é a PB-067 (#96).
- **Arquitetura:** [Arquitetura e banco de dados](../geral/ARQUITETURA_EXECUCAO.md).

## 2. Como executar

Há duas formas. A primeira não depende de nenhuma conta externa e é a indicada para a demonstração.

### 2.1 Com Docker (ambiente completo local)

**É preciso ter:** Node.js 22 ou superior e Docker Desktop aberto.

Na raiz do projeto:

```bash
node scripts/preparar-compose.mjs
docker compose --env-file .env.compose up --build -d
```

Depois, abra <http://localhost:3000>.

**No Windows:** os scripts `.sh` que rodam dentro dos containers precisam do fim de linha do Linux (LF). O arquivo `.gitattributes` da raiz garante isso em um clone novo. Em um clone feito antes dele, o serviço `database` falha com "cannot execute: required file not found"; nesse caso, apague os três arquivos e baixe-os de novo:

```bash
rm infra/00-roles.sh infra/migrate.sh scripts/validar-seguranca.sh
git checkout -- infra/00-roles.sh infra/migrate.sh scripts/validar-seguranca.sh
docker compose --env-file .env.compose down -v
docker compose --env-file .env.compose up --build -d
```

O `down -v` apaga o volume do banco **local**, necessário porque os usuários do banco só são criados na primeira inicialização.

O que cada comando faz:

1. `preparar-compose.mjs` cria o arquivo `.env.compose` com senhas e chaves aleatórias, só para a sua máquina. Se o arquivo já existir, ele é mantido. O Git ignora esse arquivo.
2. `docker compose ... up --build -d` sobe cinco serviços:

| Serviço | Função |
|---|---|
| `database` | PostgreSQL 17 com os dados em um volume |
| `migrate` | Executa `schema.sql` e depois `seed.sql`, e encerra |
| `rest` | PostgREST: a Data API que o backend usa |
| `gateway` | Nginx que expõe a Data API no caminho `/rest/v1/` |
| `app` | Backend e frontend, na porta 3000 da sua máquina |

Comandos úteis:

```bash
docker compose --env-file .env.compose ps        # ver o estado dos serviços
docker compose --env-file .env.compose logs app  # ver o log do backend
node scripts/validar-container.mjs               # conferir cadastro, login, temas e estudos pela API
docker compose --env-file .env.compose down      # parar, mantendo os dados
```

Para trocar a porta, altere `APP_PORT` em `.env.compose`. Não use `down -v` se quiser manter os dados: essa opção apaga o volume do banco.

### 2.2 Sem Docker (com um projeto Supabase)

**É preciso ter:** Node.js 22 ou superior e um projeto no Supabase.

1. No SQL Editor do Supabase, execute `backend/database/schema.sql` e depois `backend/database/seed.sql`.
2. Copie `.env.example` para `backend/.env` e preencha as variáveis da seção 3.
3. Na pasta `backend`:

```bash
npm ci
npm start
```

4. Abra <http://localhost:3000>.

O servidor não executa SQL sozinho: o passo 1 é manual.

O `npm ci` também copia a biblioteca do QR Code para `frontend/src/assets/js/vendor/qrcode.js`. Para repetir só essa cópia, use `npm run vendor:copiar`.

## 3. Variáveis de ambiente

Nenhum valor real fica no repositório. O `.env.example` traz só os nomes.

| Variável | Para que serve | Como preencher |
|---|---|---|
| `SUPABASE_URL` | Endereço da Data API | URL base do projeto, sem `/rest/v1/` |
| `SUPABASE_SECRET_KEY` | Chave de servidor para acessar o banco | Chave secreta do projeto. Fica só no backend, nunca no frontend |
| `JWT_SECRET` | Assina o token de login | Texto aleatório com 32 caracteres ou mais |
| `ADMIN_USER_IDS` | IDs dos usuários que administram temas, conteúdos e questões | Opcional. IDs separados por vírgula. Vazio: ninguém é administrador |
| `PORT` | Porta do backend | Opcional. Padrão: 3000 |

Para gerar um `JWT_SECRET`:

```bash
node -e "console.log(require('node:crypto').randomBytes(32).toString('hex'))"
```

As linhas `POSTGRES_*` do `.env.example` não são lidas pelo backend. No Docker, todas as variáveis vêm do `.env.compose`, gerado pelo script.

### Configuração pública do frontend

O arquivo `frontend/src/assets/js/config.js` é público e **não pode receber chaves ou senhas**. Ele tem duas opções:

| Opção | Para que serve | Quando preencher |
|---|---|---|
| `AGILCERT_API_BASE_URL` | Endereço da API | Só se o frontend for servido separado do backend |
| `AGILCERT_PUBLIC_BASE_URL` | Endereço do site gravado no QR Code do certificado | Para o QR Code funcionar em outro aparelho. Vazio usa o endereço atual; `localhost` só funciona no próprio computador |

## 4. Banco de dados

O projeto **não usa migrations separadas**. Tudo está em dois arquivos:

| Arquivo | Conteúdo |
|---|---|
| `backend/database/schema.sql` | Tabelas, funções da prova, permissões e ajustes para bancos antigos |
| `backend/database/seed.sql` | Os 12 temas, os 12 textos de estudo, as 48 questões e as 192 alternativas |

- A ordem é sempre `schema.sql` e depois `seed.sql`. Os dois podem ser executados de novo sem apagar dados.
- O `seed.sql` termina com uma conferência: falha se não houver 12 temas, 12 materiais, 48 questões aprovadas e quatro alternativas com uma correta em cada questão.
- **O `seed.sql` é gerado.** A fonte é `backend/scripts/data/content-estudos.json`. Depois de editar o JSON, execute na pasta `backend`:

```bash
npm run seed:gerar
```

- O seed não sobrescreve um texto de estudo que já existe no banco. No Supabase do grupo, o material está cadastrado por seção e não deve receber a carga de textos por cima; veja [Bancos que já têm os conteúdos](COERENCIA_CONTEUDOS_AVALIACOES.md#bancos-que-já-têm-os-conteúdos).
- O certificado usa as tabelas que já estão no `schema.sql`; não há passo extra de banco para ele.

## 5. Testes

| Comando | O que testa | Precisa de |
|---|---|---|
| `npm test` (na pasta `backend`) | API, autorização, sessão, estudos, prova, histórico, certificado, validação pública e carga de conteúdo, com o banco simulado | Node.js |
| `bash scripts/validar-seguranca.sh` (na raiz) | Regras da prova direto em um PostgreSQL temporário: concorrência, tempo, permissões e senha | Docker e Bash. No Git Bash do Windows, use `MSYS_NO_PATHCONV=1 bash scripts/validar-seguranca.sh`; sem isso, o Git Bash converte os caminhos Linux e o Docker recusa o comando |
| `node scripts/validar-container.mjs` (na raiz) | Cadastro, login, temas, estudos e logout no ambiente do Docker em execução | Ambiente da seção 2.1 no ar |

### Evidência de 17/11/2026, repetida em 18/11/2026

`npm test` na pasta `backend`, com Node.js 24.19.0 no Windows 11. O resultado foi o mesmo nas duas datas, a segunda já com os ajustes do certificado:

```text
tests 39
pass 36
fail 0
skipped 3
```

Os três testes ignorados são os que exigem PostgreSQL em Docker. Eles não contam como aprovados.

Dos 39 testes, 11 são do certificado e da validação pública: emissão somente para tentativa aprovada do próprio usuário, emissão repetida sem duplicar, certificado revogado não exibido e validação por código sem login.

### Evidência do ambiente Docker, 18/11/2026

Executado no Windows 11, com Docker 28.3.2, a partir da `main` no commit `202d62f` e com o `.gitattributes` desta entrega.

| Verificação | Resultado |
|---|---|
| Subida pelo Docker Compose | ✅ os cinco serviços subiram; `migrate` terminou com sucesso. Sem o `.gitattributes`, o serviço `database` falhou (seção 2.1) |
| Carga do banco | ✅ "Carga validada: 12 temas, 12 materiais, 48 questões, 192 alternativas" |
| Páginas e API | ✅ as oito páginas, a biblioteca do QR Code e `/api/temas` responderam 200 |
| `node scripts/validar-container.mjs` | ⚠️ aprovou banco, cadastro, login, perfil, 12 temas e material de cada tema; parou ao concluir um tema (409), porque o script não responde ao quiz antes, e o portal exige 3 acertos |
| Fluxo de estudos completado pela API | ✅ 6 de 6: conclusão bloqueada sem 3 acertos, quiz, conclusão única do tema, progresso, logout com token revogado e novo login com progresso salvo |
| `MSYS_NO_PATHCONV=1 bash scripts/validar-seguranca.sh` | ⚠️ continuidade aprovada; testes de banco com 2 de 3 aprovados. O terceiro para na primeira verificação, que espera as questões em rascunho, mas a carga as deixa aprovadas desde 05/11. Com essa verificação ajustada só no ambiente de teste, 3 de 3 aprovados |

**Teste no navegador** (<http://localhost:3000>), com uma conta nova:

| Passo | Resultado |
|---|---|
| Cadastro e login por CPF | ✅ |
| Prova completa com 12 questões | ✅ 8 acertos, 66,7%, aprovada |
| Continuar depois e Retomar prova | ✅ a prova pausada com 2 respostas voltou na questão 3 |
| Certificado | ✅ nome, acertos, percentual, data e hora de emissão, código e QR Code. A hora saiu 3 horas adiantada (ver limitações) |
| Baixar certificado | ✅ PDF de uma página, sem menu nem rodapé |
| Validação pública | ✅ "Certificado válido" com titular, certificação, aproveitamento e emissão; a mesma consulta pela API, sem login, respondeu "válido" |

A evidência anterior de testes está em [Validação técnica da Sprint 2](../sprint-2/evidencias/VALIDACAO_SPRINT_2.md).

## 6. Funcionalidades

### 6.1 Cadastro e login

- **Cadastro** (`cadastro.html`): CPF (11 dígitos, único), nome, e-mail e senha de 8 caracteres ou mais. A senha é guardada como hash (bcrypt), nunca em texto.
- **Login** (`login.html`): somente CPF e senha. O login vale por duas horas.
- **Sair:** encerra a sessão no servidor; o token antigo deixa de funcionar.
- **Proteção contra tentativas em excesso:** em 15 minutos, até 10 tentativas por conta e 30 por endereço no login. Acima disso, o portal pede para aguardar.

### 6.2 Página inicial

`home.html` apresenta a certificação, os objetivos e as instruções, com acesso aos estudos e à prova.

### 6.3 Estudos

Em `estudos.html`, o candidato:

1. vê os 12 temas, com busca por nome e a indicação "Concluído" ou "Pendente";
2. abre um tema e lê o texto de estudo e o link complementar;
3. responde ao **quiz de fixação** com as quatro questões do tema, cada uma com imagem. Depois de cada resposta, o portal diz se acertou;
4. conclui o tema ao atingir **3 acertos**. O quiz pode ser reiniciado.

O progresso ("X de 12") fica salvo no servidor e é sempre do usuário logado.

### 6.4 Certificação (prova)

Em `certificacao.html`:

- A prova tem **12 questões, uma de cada tema**, sorteada entre as quatro do tema.
- Cada questão tem imagem, quatro alternativas e **150 segundos**. O tempo é controlado pelo servidor.
- Se o tempo acabar, a questão é encerrada como incorreta.
- Depois de cada resposta aceita, o candidato vê se acertou e a letra correta fornecida pelo backend; então escolhe **Próxima questão** ou **Continuar depois**.
- **Continuar depois** salva o progresso. Ao voltar, **Retomar prova** segue do próximo tema ainda não respondido.
- Se a conexão cair ou a página for fechada com uma questão aberta, essa questão é encerrada como incorreta e não pode ser respondida de novo.
- Cada tema é respondido uma única vez.

### 6.5 Resultado

Ao terminar os 12 temas, **Ver resultado** mostra os acertos, o percentual e a situação. O cálculo é feito no banco, não no navegador: **aprovado com 65% ou mais**, o que equivale a 8 acertos em 12. Para quem foi aprovado, o botão **Gerar certificado** fica disponível.

### 6.6 Histórico

`historico.html` lista as provas do candidato. Em **Ver questões**, cada item mostra o tema, o enunciado, a resposta escolhida, a resposta correta e a data e a hora da resposta. O histórico completo só aparece depois que a prova é finalizada; o retorno individual já aparece após cada resposta aceita. As provas aprovadas têm o link **Ver certificado**.

### 6.7 Perfil

`perfil.html` mostra as informações pessoais, permite atualizar o e-mail e trocar a senha (senha atual, nova senha e confirmação). A troca de senha encerra todas as sessões abertas.

### 6.8 Certificado

`certificado.html` abre por **Gerar certificado**, na tela de resultado, ou por **Ver certificado**, no histórico.

- **Quem recebe:** só o dono de uma prova finalizada e aprovada. A aprovação e o titular são conferidos de novo no banco no momento da emissão.
- **O que o certificado mostra:** nome do candidato, CPF parcialmente mascarado (por exemplo, 123.***.***-01), e-mail do perfil autenticado, nota final em percentual, data e hora de emissão em Brasília, código de validação e QR Code. CPF e e-mail ficam ocultos na consulta pública. O número de acertos (de 12) aparece no resumo ao lado do certificado.
- **Baixar:** o botão **Baixar certificado** abre a impressão do navegador; escolha "Salvar como PDF".
- **Sem duplicar:** emitir de novo a mesma prova devolve o mesmo certificado.
- **Revogados:** um certificado inativo ou revogado não é exibido.

### 6.9 Validação pública

`validar-certificado.html` **não exige login**. O QR Code do certificado abre essa página já com o código preenchido; também dá para digitar o código.

- Código válido: a página confirma a autenticidade e mostra o titular, o aproveitamento e a data de emissão.
- Código inexistente ou de certificado revogado: a página informa que o certificado não foi encontrado e não mostra dado nenhum.
- Código fora do formato: a página pede um código de validação válido, sem consultar o servidor.

A consulta pública devolve apenas nome, acertos, percentual, data e código. CPF e e-mail não são expostos.

## Correções locais de 26/11/2026

- A resposta aceita pela API agora inclui a letra correta da questão encerrada e informa acerto/erro na prova. O backend só consulta esse retorno depois da validação de titular, sessão e resposta pela RPC.
- A visualização autenticada do certificado inclui o e-mail do perfil e data/hora da emissão em Brasília. A consulta pública continua sem CPF e e-mail.
- Datas legadas sem fuso são interpretadas como UTC e exibidas em `America/Sao_Paulo`, inclusive no histórico e na validação pública. Essa correção pressupõe o contrato UTC documentado do banco; não altera dados existentes.
- README reparado e documentação da API disponível. As correções locais ainda precisam ser publicadas e homologadas no ambiente de entrega.

## Limitações conhecidas

| Item | Situação | Requisito | Issue |
|---|---|---|---|
| QR Code lido em outro aparelho | Usa a origem atual do site ou o endereço definido em `AGILCERT_PUBLIC_BASE_URL`. É necessário um endereço acessível pelo celular; `localhost` não serve. Teste real ainda pendente. A configuração de rede do Docker ficou fora desta correção | RF19, RP08 | #84, #85 |
| Figuras no texto de estudo | O texto de estudo não tem figuras; as imagens aparecem nas questões | RF07 | — |
| Scripts de validação desatualizados | `validar-container.mjs` não responde ao quiz antes de concluir o tema, e a primeira verificação de `provas-db.test.js` espera as questões em rascunho. O portal está certo; os testes precisam acompanhar as regras atuais | — | #94 |
| Teste completo do sistema e teste de interrupções | Issues encerradas no GitHub, mas as evidências precisam ser reconciliadas: o comentário da #95 ainda aponta perda de conexão, fechamento e duplo clique pendentes. Testes simulados não substituem homologação integrada | — | #94, #95 |
| Documentação completa da API | Disponível em [Documentação da API](../Documentacao_API_AgilCert.md); validar exemplos no ambiente de entrega | RNF06 | #96 |

A emissão do certificado, o QR Code e a validação pública entraram na `main` pela PR #103 e foram ajustados em 17 e 18/11. As issues #80 a #86 foram fechadas em 18/11/2026.

## 7. Roteiro de demonstração

Tempo estimado: 10 a 12 minutos. Antes de começar, suba o ambiente (seção 2) e confirme que <http://localhost:3000> abre a tela de login.

| Passo | O que fazer | O que mostrar |
|---|---|---|
| 1 | Abrir a página inicial | Descrição da certificação e instruções |
| 2 | Cadastrar um candidato novo | Cadastro com CPF, nome, e-mail e senha |
| 3 | Entrar com CPF e senha | Login somente por CPF |
| 4 | Abrir **Estudos** e um tema | Texto do tema e link complementar |
| 5 | Responder ao quiz do tema | Imagem, retorno de acerto e tema concluído com 3 acertos |
| 6 | Voltar à lista de temas | Progresso "1 de 12" |
| 7 | Abrir **Certificação** e iniciar a prova | Questão com imagem e cronômetro de 150 segundos |
| 8 | Responder a duas questões e clicar em **Continuar depois** | Progresso salvo |
| 9 | Clicar em **Retomar prova** | A prova segue do próximo tema |
| 10 | Terminar e clicar em **Ver resultado** | Acertos, percentual e situação |
| 11 | Com uma conta aprovada, clicar em **Gerar certificado** | Certificado com nome, CPF mascarado, nota final, data, código e QR Code; acertos no resumo ao lado |
| 12 | Clicar em **Baixar certificado** e escolher "Salvar como PDF" | Certificado salvo pela impressão do navegador |
| 13 | Abrir o link **Consultar autenticidade** em uma janela anônima | Validação pública, sem login |
| 14 | Abrir **Histórico** e **Ver questões** | Resposta escolhida, resposta correta e data |
| 15 | Abrir o perfil e sair | Dados do candidato e encerramento da sessão |

Dicas para a apresentação:

- Tenha uma **conta de teste já aprovada** (8 acertos ou mais) para os passos 11 a 13, porque a prova feita ao vivo pode não atingir 65%.
- Para ler o QR Code com o celular, preencha `AGILCERT_PUBLIC_BASE_URL` com o endereço de rede do computador antes de abrir a página do certificado. Sem isso, use o passo 13 no próprio computador.
