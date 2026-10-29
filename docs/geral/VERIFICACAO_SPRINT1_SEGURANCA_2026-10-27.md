# Verificação da Sprint 1 e segurança do projeto

Data: 27/10/2026. Base revisada: commit `2b6a8c7`, branch `develop`.
Revisão de código, dependências npm, frontend, SQL, provisionamento, imagens
declaradas e execução local. Esta revisão não altera regras de negócio.

## Revalidação na pasta correta do projeto

Projeto confirmado: `/home/juliogregorio/Documents/ABP_1`, branch `develop`,
commit `2b6a8c7`. Nesta repetição, `npm test` e `npm audit --json` foram executados
nessa pasta: **9 testes aprovados** e **zero vulnerabilidades npm conhecidas**.
Os arquivos rastreados de backend, frontend, infraestrutura, migrações, scripts e
Compose foram comparados por conteúdo com a revisão anterior: nenhuma diferença.
A busca por padrões de segredos nos arquivos rastreados também não teve achados.

As consultas locais foram repetidas: 11/11 tabelas com RLS; anon/authenticated
sem SELECT em usuarios; 48 questões inativas/RASCUNHO. A prova controlada de
sessão e entrega de rascunhos foi repetida no ambiente local de validação da porta
3300, cuja imagem não foi reconstruída nesta repetição. Os testes da pasta correta
usam o código dessa pasta; as observações do contêiner descrevem o ambiente local
já existente. Não foi acessado o Supabase remoto.

Os achados S01–S06 abaixo permanecem abertos. Nenhuma correção de aplicação foi
feita nesta auditoria. Este relatório é um arquivo novo local, ainda sem commit.

## Resultado da Sprint 1

A fonte foi conferida diretamente na foto `docs/sprint-1/evidencias/devolutiva-equipe.jpeg`.
As implementações técnicas estão presentes, mas não há evidência para declarar
todos os pedidos aceitos ou a Sprint encerrada.

| Pedido | Verificação atual | Pendência |
|---|---|---|
| 12 temas, conteúdo, 48 questões, navegação e progresso | Banco local: 12 temas, 12 materiais, 48 questões e 192 alternativas. Suíte e integração verificam conclusão idempotente, isolamento e recuperação após novo login. | Todas as 48 questões estão inativas e em RASCUNHO; revisão editorial permanece aberta. |
| Home mobile e links | Código contém breakpoints, menu com `aria-expanded`, destinos para estudos/perfil/GitHub e seções locais. Comparação e capturas de 320/390/768/1440px estão registradas na entrega anterior. | Não foi repetido o teste visual no navegador nesta revisão. Não foi inspecionado o Figma remoto; a comparação existente usa os documentos locais. |
| Arquitetura e execução em contêineres | PostgreSQL, PostgREST, gateway e aplicação locais em execução; aplicação, gateway e banco saudáveis. Banco registra sete etapas de schema/migrações/cargas. Integração real aprovada. | Não foi repetida uma instalação em volume vazio, reinício de serviços ou teste de checksum nesta revisão. |
| Documentos/autorias, Review, retrospectiva, DoD e logout | Documentos e referências existem. Logout revoga o token no servidor e o token antigo recebe 401 no teste integrado. | Review e retrospectiva têm roteiro, mas data/participantes/aceites continuam pendentes. Revisão por integrante, aceite do PO e evidências de autoria/material não foram concluídos. DER/modelo lógico independentes não foram encontrados pela documentação da entrega. |

## Verificações executadas

- `cd backend && npm test`: **9 aprovados, zero falhas**. A primeira execução no
  sandbox falhou no teste HTTP; a repetição com acesso às portas locais passou.
- `cd backend && npm audit --json`: **zero vulnerabilidades conhecidas**,
  incluindo todas as dependências npm declaradas. Resultado consultado nesta data.
- `TEST_BASE_URL=http://127.0.0.1:3300 node scripts/validar-container.mjs`:
  aprovado com API e banco reais; cadastro, login, perfil, conteúdo dos 12 temas,
  conclusão repetida, isolamento, logout e novo login preservando progresso.
- Consultas somente de leitura no banco `abp_fatec_check-database-1`: contagens
  acima; **11 tabelas com RLS ativa**; nenhuma concessão de tabela para PUBLIC,
  anon ou authenticated; leitura de usuarios negada a anon e authenticated.
- Prova controlada com conta sintética: após trocar a senha, o token anterior
  recebeu **200** em `GET /api/usuarios/me`; início de prova recebeu **201** com
  12 questões apesar de todas estarem inativas/em rascunho; próxima questão
  retornou `status: false` e `status_editorial: RASCUNHO`.
- Resposta HTTP local de `/home.html`: sem CSP, X-Frame-Options,
  X-Content-Type-Options e HSTS. O teste usou HTTP local; isso não prova a
  configuração de um eventual proxy HTTPS externo.
- Busca por padrões de tokens GitHub, chaves Supabase, JWTs e chaves privadas nos
  arquivos textuais rastreados: nenhum achado. O histórico contém `.env` no commit
  `876a444231a9`, mas a versão examinada tem senha vazia e parâmetros locais.
  Isso não é evidência de vazamento de segredo. Não houve varredura completa
  de segredos em todos os blobs do histórico.

As contas, progresso e uma tentativa de auditoria sintéticos permanecem somente
no banco local de validação. A prova controlada adicional não emitiu certificado.
O teste HTTP da suíte usa banco simulado para verificar a emissão de certificado.

## Achados confirmados e ações recomendadas

Prioridades abaixo são de correção do projeto, sem pontuação CVSS atribuída.

### S01 — Alta: prova incompleta pode produzir certificado

Evidência: `backend/src/routes/tentativas.js:84` ignora tema sem questão;
`:326` usa a quantidade efetiva de vínculos como denominador.
`backend/test/api.test.js` cria uma prova com uma questão, responde e confirma
certificado. Esse teste passou e demonstra o comportamento com banco simulado.
Um candidato pode ser aprovado sem cumprir os 12 temas quando a base estiver
incompleta. A interface não oferecer prova não bloqueia chamadas diretas à API.

Correção: validar exatamente 12 temas elegíveis e a base mínima antes de criar a
tentativa; garantir os 12 vínculos e a emissão em operações transacionais;
transformar o cenário atual em teste de recusa de base incompleta.

### S02 — Alta: ausência de prazo e sequência no servidor

Evidência: `backend/src/routes/tentativas.js:215` em diante verifica status,
vínculo e alternativa, mas não prazo de 150 segundos nem questão corrente.
O campo `tentativas.expira_em` existe no schema, mas não é preenchido/validado
por esse fluxo. `proxima-questao` não persiste início/prazo por questão.

Impacto: envio de respostas fora do prazo e fora de sequência não é impedido
pelo servidor. Conclusão baseada em cronômetro de interface não resolve a falha.
Não foi feito teste com espera real de 150 segundos; achado por inspeção do fluxo.

Correção: ordem e estado por questão persistidos, prazo verificado no banco/API,
timeout registrado e transições atômicas, com testes de concorrência e limites.

### S03 — Alta: questões não publicadas entram na prova

Evidência: `backend/src/routes/tentativas.js:70` seleciona por tema sem filtrar
`status`, `status_editorial` ou atividade do tema. Confirmado com API e banco reais:
48 questões inativas/RASCUNHO; tentativa criada e uma dessas questões entregue.

Impacto: a aprovação editorial e a desativação deixam de controlar o que chega ao
candidato, comprometendo a integridade da certificação.
Correção: exigir questão ativa/APROVADO, tema ativo e quatro questões elegíveis
por tema; recusar a base atual enquanto não houver conteúdo revisado suficiente.

### S04 — Alta: autenticação sem limitação de tentativas

Evidência: `backend/src/server.js:11-13`, `routes/login.js` e `infra/gateway.conf`
não aplicam limitação ao cadastro/login. Cadastro executa bcrypt, e login de
conta existente também; não há política por conta/IP no código revisado.

Impacto: facilita tentativas automatizadas de senha e consumo de CPU por abuso
de autenticação. Não foi executado ataque de carga. Um proxy externo pode ter
controles adicionais, não verificados aqui.
Correção: limites por IP/conta, atrasos graduais e armazenamento compartilhado
quando houver múltiplas instâncias, com monitoramento e testes de recuperação.

### S05 — Média: trocar senha não encerra sessões antigas

Evidência: `backend/src/routes/usuarios.js:29-40` altera somente o hash da senha.
JWTs duram duas horas (`services/login.js:87`) e autorização verifica assinatura
e revogação individual, sem versão de sessão ou data da troca. Confirmado: um
token emitido antes da troca continuou recebendo 200 em rota privada.

Impacto: quem tiver uma cópia do token continua acessando a conta após a vítima
trocar a senha, até expiração ou logout específico desse token.
Correção: versão de sessão ou instante de revogação por usuário, invalidando
tokens anteriores à troca; definir renovação da sessão atual e testar dois logins.

### S06 — Baixa: mensagens internas do banco em respostas

Evidência: `backend/src/routes/tentativas.js:56`, `:176`, `:280`,
`backend/src/routes/certificados.js:35` e outras rotas retornam `error.message`.
O teste de erros genéricos cobre temas/health/login, não todos esses caminhos.

Impacto: erros induzidos ou falhas operacionais podem revelar estrutura e detalhes
internos do banco. Não foi demonstrado vazamento de senha/chave por essas mensagens.
Correção: mensagens externas estáveis e log interno controlado com identificador.

## Proteções existentes e melhorias de defesa

- JWT com algoritmo HS256 explícito, segredo mínimo e expiração; bcrypt;
  logout com hash do token persistido; falha na consulta de revogação nega acesso.
- Autorização por dono em tentativas, certificados, perfil e progresso;
  escrita administrativa e listagem de gabaritos restritas a administradores.
- Alternativas entregues ao candidato omitem `correta`. Estudos usam
  `textContent` e somente links HTTPS. Não foi identificado caminho direto de
  XSS nas atribuições de `innerHTML` examinadas, que usam conteúdo constante.
- Express serve somente `frontend/src`, bloqueando dotfiles. Segredos e
  dependências locais são excluídos do contexto Docker; aplicação executa como node.
- Compose atual publica somente aplicação em `127.0.0.1`; banco e Data API
  permanecem internos. A chave service_role ignora RLS: os controles da API
  continuam necessários mesmo com RLS habilitada.
- `cors()` aceita qualquer origem. Como os tokens são Bearer explícitos e não
  cookies automáticos, isso isoladamente não demonstra sequestro de conta/CSRF.
  Restringir origens na implantação e adicionar CSP, proteção contra framing e
  nosniff. HSTS deve ser definido no ponto de terminação HTTPS.
- JWT fica em localStorage: um futuro XSS pode lê-lo. Não foi demonstrado XSS;
  avaliar sessão com cookie HttpOnly/Secure e proteção CSRF conforme a arquitetura.
- Cadastro distingue CPF existente (409), e login para CPF inexistente evita
  bcrypt. Há sinal explícito/temporal de existência de conta; avaliar respostas
  uniformes e validação de identidade conforme os requisitos do produto.
- Imagens Docker usam tags sem digest; a imagem Node não fixa versão de patch.
  Fixar versões/digests e manter rotina de atualização e varredura de imagens.
  O contêiner legado `abp_supabase_db` continua usando `supabase/postgres:17.6.1.136`;
  não foi alterado nem usado para comprovar as correções do Compose novo.

## Limites e próximos passos

Não foram auditados Supabase remoto, hospedagem pública, firewall, proxy externo,
TLS externo ou políticas reais de produção. Não foi executado scanner de CVEs
das imagens Docker: Trivy/Grype não estão instalados. Tags antigas ou ausência
de digest não bastam para afirmar um CVE específico. `npm audit` cobre npm,
não vulnerabilidades de sistema operacional, regra de negócio ou exposição remota.

Ordem sugerida: S01–S04 antes de disponibilizar certificação; S05–S06 em seguida.
Manter questões em rascunho até revisão editorial. Atualizar testes para provar
recusa de base incompleta, prazo, sequência, elegibilidade e invalidação na troca
de senha. Registrar aceite da Sprint separadamente das correções técnicas.

Referências de critérios:
[OWASP Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html),
[OWASP Session Management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html) e
[OWASP Transaction Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Transaction_Authorization_Cheat_Sheet.html).
