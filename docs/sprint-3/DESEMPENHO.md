# Revisão de desempenho (PB-059)

- **Issue:** #90
- **Data:** 18/11/2026
- **Requisito do desafio:** RNF02 (tempo de resposta adequado no carregamento das páginas e das questões)
- **Divisão:** front (peso das páginas, imagens e botões) por Miriele; back (API, servidor e banco) por Isabella

## Como a medição foi feita

- **Ambiente:** Docker local no Windows 11, com Docker 28.3.2, a partir da `main` no commit `202d62f` (como subir esse ambiente está no documento de funcionalidades e operação da PB-068, PR #104).
- **Peso da página:** soma do HTML com os arquivos locais que ele carrega (CSS, JavaScript e imagens), na primeira visita, sem cache. Em Estudos, inclui a imagem de fundo definida no CSS.
- **Tempo da API:** 20 chamadas seguidas a cada rota, com um usuário de teste; registradas a mediana e a pior.

## Limites de aceitação (proposta para o grupo)

| Item | Limite proposto |
|---|---|
| Peso de cada página na primeira visita | até 500 KB |
| Rotas da API no ambiente local | mediana até 300 ms |

**Situação:** proposta; aguarda o aceite do grupo antes da homologação.

## Front: peso das páginas

### Gargalo encontrado

As imagens eram quase todo o peso das páginas. Elas estavam muito maiores do que aparecem na tela:

| Imagem | Onde aparece | Tamanho do arquivo | Tamanho exibido |
|---|---|---|---|
| `personagens.png` | Fundo de um cartão em Estudos | 2880×1920 px | fundo de cartão |
| `ilustracao.png` | Login e Cadastro | 1437×1095 px | metade da tela |
| `jovem-estudando.png` | Início | 1330×1182 px | bloco principal |
| `logo-transparente.png` | Topo das páginas internas | 1535×1024 px | ~150 px de largura |
| `logo.png` | Login, Cadastro e Validação | 1881×836 px | até 180 px de largura |

### Melhoria realizada

As cinco imagens foram reduzidas no [Squoosh](https://squoosh.app):

1. **Largura** igual ao dobro do tamanho exibido, para continuar nítida em telas de alta resolução (300 e 400 px nos logos, 900 px nas ilustrações e 1200 px no fundo de Estudos).
2. **Paleta de 256 cores**, sem *dithering*.
3. **Formato PNG** (OxiPNG), com o mesmo nome de arquivo e a transparência preservada.

Como os nomes e o formato não mudaram, nenhum HTML ou CSS foi alterado.

| Imagem | Antes | Depois | Redução |
|---|---|---|---|
| `logo-transparente.png` | 287 KB | 8 KB | 97% |
| `logo.png` | 287 KB | 10 KB | 97% |
| `ilustracao.png` | 1.134 KB | 95 KB | 92% |
| `jovem-estudando.png` | 953 KB | 121 KB | 87% |
| `personagens.png` | 2.533 KB | 342 KB | 87% |
| **Total** | **5.193 KB** | **575 KB** | **89%** |

### Resultado por página

| Página | Antes | Depois |
|---|---|---|
| Login e Cadastro | 1.445 KB | 129 KB |
| Início | 1.272 KB | 160 KB |
| Estudos (com o fundo) | ~2.880 KB | ~413 KB |
| Certificação | 350 KB | 71 KB |
| Histórico | 332 KB | 53 KB |
| Perfil | 337 KB | 58 KB |
| Validação pública | 295 KB | 18 KB |
| Certificado | 180 KB | 180 KB (não usa essas imagens) |

Depois da melhoria, todas as páginas ficam abaixo do limite proposto de 500 KB.

### Comportamento preservado

- `npm test` na pasta `backend`: 39 testes, 36 aprovados, 0 falhas e 3 ignorados (os três exigem PostgreSQL em Docker), o mesmo resultado de antes da troca.
- Conferência no navegador, com o ambiente Docker e recarga sem cache (Ctrl+F5): Início, Login, Estudos e o logo das páginas internas, sem perda visível de qualidade.

### Botões durante o carregamento

| Tela | Situação |
|---|---|
| Prova (responder, próxima questão, continuar depois) | ✅ os botões ficam desativados enquanto a resposta é enviada |
| Quiz de fixação em Estudos | ✅ o botão "Verificar resposta" é desativado antes do envio |
| Login e Cadastro | ✅ corrigido nesta entrega. Antes, o botão continuava ativo e um clique duplo mandava dois pedidos: no cadastro, o segundo voltava com "CPF já cadastrado"; no login, os dois contavam no limite de tentativas. Agora o botão fica desativado e mostra "Aguarde..." durante o envio, e novos envios do formulário são ignorados. Se o servidor responder com erro, o botão volta ao normal |

A correção do login e do cadastro foi conferida com uma simulação de clique duplo: um único pedido no login e no cadastro, botão liberado depois de um erro e nenhum pedido quando as senhas não coincidem. A mesma simulação, aplicada à versão anterior do `auth.js`, registrou dois pedidos.

### Sugestão opcional

O `personagens.png` (342 KB) é o maior arquivo restante. Ele não tem transparência; em JPEG ficaria menor, mas isso exige mudar a extensão no `estudos.css`.

## Back: API, servidor e banco

> Seção da Isabella. Abaixo, a medição inicial feita no ambiente Docker local e os pontos encontrados para avaliação.

### Medição inicial da API (Docker local)

| Rota | Mediana | Pior caso |
|---|---|---|
| `GET /api/temas` | 8 ms | 27 ms |
| `GET /api/temas/:id/conteudos` | 23 ms | 35 ms |
| `GET /api/temas/:id/questoes` | 27 ms | 45 ms |
| `GET /api/estudos/progresso` | 38 ms | 56 ms |
| `GET /api/usuarios/me` | 32 ms | 41 ms |
| `GET /api/historico` | 30 ms | 39 ms |
| `POST /api/login/entrar` | 63 a 116 ms | — |

O login é mais lento de propósito: a conferência da senha usa bcrypt. Todas as rotas ficaram bem abaixo do limite proposto. Esta medição é local; com o Supabase, entra a latência da internet, que ainda precisa ser medida.

### Pontos para avaliar

- **Compressão:** o servidor não comprime CSS e JavaScript (sem gzip). O ganho seria pequeno, porque esses arquivos somam cerca de 60 KB por página.
- **Cache:** os arquivos estáticos vão com `Cache-Control: public, max-age=0`, então o navegador confere cada arquivo a cada visita.
- **Banco:** conferir índices das consultas mais usadas e consultas repetidas (critério do refinamento da Sprint 3).
- **Reinício do Docker:** depois que o banco recebe qualquer dado (um cadastro ou uma resposta), o `schema.sql` se recusa a rodar de novo ("Banco mudou desde a aplicação anterior"). Como o serviço `migrate` roda o schema a cada `docker compose up`, o portal deixa de subir depois de reiniciar o ambiente. Para subir só o portal com o banco já carregado: `docker compose --env-file .env.compose up -d --no-deps app`.

## Situação dos critérios da issue #90

| Critério | Situação |
|---|---|
| Medir carregamento e respostas dos fluxos essenciais em ambiente documentado | ✅ seções "Como a medição foi feita", front e back |
| Registrar gargalos e melhorias realizadas | ✅ front: imagens e envio duplicado no login e no cadastro. Back: pontos listados para avaliação |
| Definir com a equipe os limites de aceitação | ⏳ proposta registrada, aguardando o aceite do grupo |
| Verificar que as otimizações preservam comportamento e segurança | ✅ testes e conferência no navegador |
