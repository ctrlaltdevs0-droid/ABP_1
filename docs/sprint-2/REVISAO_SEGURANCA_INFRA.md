# Revisão prioritária de segurança e infraestrutura

Data: 26/10/2026. Escopo: código local do ABP_1, dependências npm e PostgreSQL
local `abp_supabase_db`. O Supabase remoto e a hospedagem pública não foram auditados.

## Atualização após a devolutiva da Fatec

Foi acrescentado um ambiente Compose completo e separado, com PostgreSQL 17.11,
provisionamento rastreado, todas as tabelas da aplicação com RLS ativa e sem
leitura direta por `anon`. O banco antigo `abp_supabase_db` não foi alterado.
Também foi implementada revogação persistente de JWT no logout. Ver
[correções da devolutiva](../sprint-1/CORRECOES_DEVOLUTIVA.md) e
[evidências](../sprint-1/evidencias/VALIDACAO_DEVOLUTIVA.md).

Os achados abaixo descrevem a revisão inicial e continuam relevantes para o
banco antigo e a hospedagem remota, que não foram migrados automaticamente.
Os P0 do motor da certificação e a limitação de tentativas de login permanecem
pendentes; o ambiente completo de estudos não significa que a prova está pronta.

## Correção aplicada

**P0 — negação de serviço sem autenticação no parser HTTP.** `npm audit --omit=dev`
identificou body-parser 2.3.0 vulnerável a requisições comprimidas com bytes extras.
Atualizado para 2.4.0 no lockfile; dependência qs atualizada para 6.16.1 por compatibilidade.
Referência: https://github.com/advisories/GHSA-27r3-jxmh-p828 .
O audit após atualização retorna zero vulnerabilidades conhecidas no conjunto npm.
Isso não equivale a uma auditoria da imagem Docker ou do código de negócio.
Reinstalar dependências com `npm ci` e reconstruir a imagem para aplicar em execução.

## Correções ainda prioritárias

| Prioridade | Evidência | Impacto e ação necessária |
|---|---|---|
| P0 — integridade da certificação | `backend/src/routes/tentativas.js`: a criação pula temas sem questões; finalização usa o número de vínculos como denominador. O teste HTTP atual aprova e emite certificado com 1 questão. | Recusar base incompleta, exigir os 12 temas e criar tentativa/vínculos em transação. Atualizar o teste que hoje aceita esse comportamento. |
| P0 — tempo e sequência | A rota de resposta não consulta início/expiração da questão; verifica apenas tentativa ativa e vínculo. | Persistir início e prazo por questão; validar 150 segundos e questão corrente no servidor; impedir envio antecipado e tardio com testes concorrentes. |
| P1 — publicação editorial | O sorteio consulta questões só pelo tema, sem filtrar `status` e `status_editorial`. | Filtrar questões ativas e aprovadas e validar 4 elegíveis por tema. A carga como rascunho inativo, isoladamente, NÃO impede o sorteio atual. Corrige a afirmação anterior da implementação. |
| P1 — abuso de autenticação | `server.js` conecta login/cadastro sem limitador de requisições. | Limitar tentativas e custo de bcrypt com política por IP/conta e armazenamento adequado ao número de instâncias. CORS aberto não é autenticação nem proteção contra força bruta. |
| P1 — PostgreSQL local desatualizado | Imagem em Compose e contêiner: `supabase/postgres:17.6.1.136`; servidor PostgreSQL 17.6. | Planejar atualização com backup e teste de restauração. O changelog Supabase informa correções de segurança em 17.11. Não trocar a imagem sobre um volume existente sem validar compatibilidade e extensões. |
| P1 — migrações fora da inicialização | Compose monta somente schema e seed de temas. No banco local consultado há 8 tabelas base, sem respostas nem progresso_estudos. | Aplicar migrações por etapa de implantação rastreável; executar cargas e validação antes da demonstração. A API usa Supabase remoto: o estado local não comprova o estado remoto. |
| P2 — proteção em profundidade do banco | RLS desativada nas 8 tabelas base locais; `anon`/`authenticated` sem SELECT direto nas tabelas verificadas; schema não habilita RLS. | Habilitar RLS e revisar privilégios no ambiente real. Não há evidência de exposição pública direta no banco local inspecionado. |
| P2 — configuração web | `cors()` permite qualquer origem; Compose publica aplicação em todas as interfaces; não há TLS configurado neste repositório. | Definir origens permitidas e arquitetura de proxy/TLS de produção. A publicação 3000:3000 não comprova exposição à internet; conferir firewall e hospedagem. |

Referência da atualização de PostgreSQL:
https://supabase.com/changelog/postgres-15-19-17-11-breaking-changes .

## Proteções confirmadas no código/configuração

- bcrypt e JWT HS256 com segredo mínimo validado; respostas de login não expõem hash.
- Autorização por dono em tentativas, certificados e progresso; gabaritos restritos a administrador.
- Alternativas da próxima questão omitem `correta`.
- Dockerfile da API executa como usuário `node`.
- Porta local do PostgreSQL vinculada a `127.0.0.1:5433`, confirmada por `docker inspect`.
- `.env` ignorado pelo Git e excluído do contexto Docker; somente `.env.example` está rastreado.
- Arquivos privados não são servidos: Express publica apenas `frontend/src`.

## Limites dos testes

A suíte verifica controles existentes e a atualização de dependências. Os testes
atuais NÃO cobrem timeout, 12 temas obrigatórios nem elegibilidade editorial;
um teste chega a validar a certificação com apenas uma questão. Portanto,
"testes passaram" não significa que os P0 de certificação foram resolvidos.
Nenhuma alteração foi feita no banco real, nos contêineres em execução ou nas
regras de rede nesta revisão.
