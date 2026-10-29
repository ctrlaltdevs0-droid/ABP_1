# Evidências técnicas da devolutiva

Data da execução: 26/10/2026. Projeto: ABP_1.

## Testes automatizados

`npm test` no backend: **9 testes aprovados**, sem falhas.
Incluem HTTP da API, controle de dono, cargas de conteúdo, token revogado,
novo login com token distinto, comportamento em falha do banco e logout do cliente.

## Navegador

Chrome headless com respostas simuladas da API: home, menu móvel, destinos das
âncoras, lista de 12 temas, busca, leitura, conclusão, recarga e chamada de logout.
Verificados **320, 390, 768 e 1440 pixels**, sem rolagem horizontal na home e
na listagem de estudos. Não há `href="#"` na home, e as âncoras locais têm destino.

Capturas: [home 320](home-320.png), [home 390](home-390.png),
[home 768](home-768.png), [home 1440](home-1440.png),
[estudos 320](estudos-320.png), [estudos 390](estudos-390.png),
[estudos 768](estudos-768.png), [estudos 1440](estudos-1440.png).

As capturas mostram desktop e celular; a persistência real é verificada
separadamente pelo teste integrado do Compose.

## Contêineres

Projeto Compose de validação: `abp_fatec_check`, porta local 3300 e volume
independente do banco anterior. Validado com PostgreSQL 17.11, PostgREST 13.0.7,
nginx 1.28 e a aplicação construída pelo Dockerfile existente.

Resultados observados:

- `database`, `gateway` e `app` saudáveis; `rest` em execução; `migrate` finalizado
  com código **0**.
- **7 etapas** registradas em `app_private.schema_migrations` (schema, quatro
  migrações e duas cargas).
- **12 temas, 12 materiais, 48 questões, 192 alternativas**, com quatro opções e
  um gabarito por questão.
- Nova execução do provisionamento mantém os dados e as contagens.
- Alterar um schema histórico em uma montagem temporária é recusado com código
  **3**; o banco permanece sem alteração desse arquivo.
- Todas as **11 tabelas públicas com RLS ativa**; nenhuma com leitura direta por
  `anon`. A API de dados sem credencial recebe **401**.
- Após reiniciar PostgreSQL e aplicação, o token revogado continua recebendo
  **401**, e a sessão nova recupera o progresso persistido.
- `scripts/validar-container.mjs` aprovado com API e PostgreSQL reais: cadastro,
  login, perfil, materiais dos 12 temas, conclusão repetida sem duplicação,
  isolamento entre candidatos, token antigo recusado e progresso após novo login.

## Navegador com API e banco reais

Chrome a 390px, sem simular endpoints: cadastro de conta de validação, login
pelo formulário, home, estudos, conclusão, logout e recusa do JWT antigo.
Novo login recupera **1 de 12 temas concluídos**. Perfil integrado abre e encerra
a sessão pelo logout real. Nenhum erro de JavaScript observado.

[Captura de estudos com persistência real](estudos-integrado-390.png).

As contas são sintéticas e permanecem no volume local de validação. Não foram
usadas contas ou dados do banco remoto.
