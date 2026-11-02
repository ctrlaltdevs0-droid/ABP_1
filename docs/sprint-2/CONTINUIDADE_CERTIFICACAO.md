# Continuidade da certificação — PB-030 a PB-035

Implementação de Júlio para as issues #51 a #56. Base: develop, commit bb26059.
Branch: `feature/pb-030-035-continuidade`.

## Entrega

`/certificacao.html` apresenta uma questão por vez. Após responder, o candidato
escolhe continuar ou continuar depois. A pausa só é aceita entre questões;
não abre a próxima questão e não consome seu prazo. A retomada preserva a tentativa,
as questões já sorteadas e os resultados anteriores.

Uma questão aberta é encerrada como incorreta na interrupção por conexão,
fechamento, recarga ou retomada em outra página. A nova página assume a sessão
da tentativa; a antiga não pode responder ou encerrar a questão seguinte.
O relógio de 150 segundos pertence ao banco. Presença não renova o prazo.

## Arquivos

- `frontend/src/certificacao.html`, `assets/js/certificacao.js` e `assets/css/certificacao.css`: interface.
- `backend/src/routes/tentativas.js`: preserva as rotas da develop e encaminha requisições com sessão para continuidade.
- `backend/src/routes/continuidade.js`: validação e operações RPC do novo cliente.
- `backend/src/middleware/autorizacao.js`: autorização das novas ações.
- `backend/src/services/provas.js`: mensagens públicas dos erros de domínio.
- `supabase/migrations/20261102210255_continuidade_certificacao.sql`: operações atômicas e persistência.
- `backend/test/continuidade.test.js`: contrato HTTP e tratamento de erros.
- `backend/test/continuidade-web.test.js`: eventos offline/fechamento e respostas atrasadas da interface.
- `backend/test/sql/continuidade.sql`: regressões no banco, executadas por `scripts/validar-seguranca.sh`.
- `issues/PB-030.md` a `issues/PB-035.md`: rastreabilidade por issue.

## Contrato da API

Todas as rotas exigem Bearer JWT. O dono vem de `req.usuario.id`, nunca do corpo.
Cada documento gera uma UUID; enviá-la no corpo como `sessao` para POST e no
cabeçalho `X-Sessao-Prova` para GET. O cliente incluído faz isso automaticamente.

| Método e caminho | Efeito |
|---|---|
| GET /api/tentativas/atual | Localiza tentativa em andamento/interrompida do candidato; não assume outra aba |
| POST /api/tentativas | Inicia ou recupera tentativa existente sem duplicar; exige sessão |
| GET /api/tentativas/:id | Estado e contagens, sem gabarito |
| GET /api/tentativas/:id/proxima-questao | Abre questão e fixa prazo no banco |
| POST /api/tentativas/:id/respostas | Exige IDs inteiros `questoes_idquestoes` e `alternativas_idalternativas` |
| POST /api/tentativas/:id/pausar | Pausa entre questões; retorna 409 se houver questão aberta |
| POST /api/tentativas/:id/retomar | Assume nova sessão; encerra eventual questão aberta da sessão anterior |
| POST /api/tentativas/:id/interromper | Exige questão exata e motivo `CONEXAO` ou `FECHAMENTO` |
| POST /api/tentativas/:id/presenca | Confirma presença sem estender o prazo |
| POST /api/tentativas/:id/finalizar | Calcula resultado após encerrar os 12 temas |

O endpoint de próxima questão é GET por compatibilidade com a API anterior, mas
abre estado no servidor. Não fazer prefetch; o cliente só chama por ação explícita.
As respostas usam `Cache-Control: no-store`. Clientes antigos dessas rotas
precisam enviar a sessão antes de usar a nova implementação.

## Persistência e interrupções

Todas as mutações bloqueiam a linha da tentativa (`FOR UPDATE`) e conferem dono,
sessão e estado. O início bloqueia também a linha do usuário para evitar criação
duplicada. Os registros mantêm questão, ordem, início, expiração, resposta,
encerramento e motivo. Não se altera uma migração anteriormente aplicada.

O navegador envia presença a cada 10 segundos. Após 30 segundos sem presença,
a próxima operação encerra a questão como incorreta. O evento `offline` bloqueia
a interface; `pagehide` tenta enviar interrupção com `fetch keepalive` e Bearer.
O envio no fechamento não é garantido pelos navegadores. A retomada com nova
sessão e a validação do prazo/presença no servidor cobrem saída abrupta, recarga
e eventos que não chegaram. Fechar o navegador não é detectável instantaneamente
com a rede desligada; o encerramento é persistido na próxima operação.

Callbacks antigos levam sessão e questão originais, portanto não afetam a próxima
questão. Nenhuma chave do banco ou dado do candidato é gravado na página.
As funções são SECURITY INVOKER, com execução revogada para PUBLIC/anon/authenticated
e concedida somente ao backend (`service_role`).

## Aplicação e validação

1. Revisar e aplicar a nova migração pelo processo de migrações do projeto no ambiente de teste.
2. Usar uma base editorialmente revisada: 12 temas ativos e pelo menos quatro questões aprovadas por tema.
   A implementação não aprova nem ativa conteúdo automaticamente.
3. No backend, executar `npm ci` e `npm test` (o ambiente de teste precisa de SUPABASE_URL e
   SUPABASE_SECRET_KEY fictícios; não usar credenciais de produção).
4. Com Docker disponível, executar `bash scripts/validar-seguranca.sh` para banco efêmero e cenários SQL.
5. Abrir `/certificacao.html` autenticado e verificar o fluxo descrito nos documentos por issue.

### Evidências desta implementação

- Migrações completas, seed e cenários de `backend/test/sql/continuidade.sql` executados em PostgreSQL/PGlite temporário.
- Contrato da API, isolamento de sessão, IDs e erro SQL testados com Node.
- Eventos offline e fechamento, envio com keepalive e descarte de abertura atrasada testados no cliente web.
- Navegador com API e PostgreSQL temporários: início, resposta, pausa, recarga,
  retomada da segunda questão, nova recarga e avanço à terceira sem reabrir a segunda.
- A develop original apresentou quatro falhas na suíte Node. A branch resolve as
  duas relacionadas à rota de provas. Permanecem duas preexistentes: quebra de linha
  do seed em Windows e mensagens SQL em rotas de conteúdo. Docker não estava disponível;
  os testes Docker de concorrência ficam para o ambiente de integração.
- Nenhuma migração foi aplicada no Supabase remoto e nenhuma issue foi encerrada.

Presença e bloqueio de sessão exigem teste adicional com dispositivos reais,
navegadores móveis e rede instável antes do aceite da equipe.

## Integração com a develop em 02/11/2026

O conflito de tentativas.js foi resolvido mantendo o motor da develop. As rotas
originais continuam disponíveis para tentativas legadas; o novo cliente envia
X-Sessao-Prova e usa o módulo continuidade.js. Uma tentativa com sessão não pode
ser alterada retirando esse cabeçalho: o acesso legado é bloqueado para ela.
O endereço teste-prova.html encaminha para a interface integrada.

A migração adicional 20261102220150_integra_continuidade_develop.sql mantém
a exigência de concluir os 12 temas, adota tentativas antigas completas sem
novo sorteio e congela resposta_correta para o histórico. O histórico só mostra
o gabarito em FINALIZADA; INTERROMPIDA aparece como Pausada.

Validação atual: 24 testes Node aprovados, zero falhas e 3 testes Docker não
executados (Docker indisponível). Migrações, seed, adoção de tentativa legada,
prazo, sessões, estudo prévio e gabarito histórico passaram em PostgreSQL/PGlite
temporário usando service_role nos testes funcionais. As duas falhas anteriores
foram corrigidas pela develop (seed) e pela sanitização de erros de temas e alternativas.
Nenhuma migração foi aplicada no banco remoto. Aplicar ambas as novas migrações
pelo processo de migrações do projeto antes da validação no ambiente de uso.
