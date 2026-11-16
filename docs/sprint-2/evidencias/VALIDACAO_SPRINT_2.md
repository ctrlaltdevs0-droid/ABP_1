# Validação técnica — Sprint 2

**Data da verificação:** 06/11/2026
**Branch:** `main`
**Commit local/remoto:** `1643267` — `fix: corrigir continuidade na tela de certificacao`

## Resultado automatizado

Executado em `backend`:

```bash
npm test
```

Resultado:

```text
tests 28
pass 25
fail 0
skipped 3
duration ~9,3 s
```

Os três testes ignorados são cenários PostgreSQL condicionais que exigem
Docker/PostgreSQL disponível. O resultado não deve ser descrito como 28 testes
executados com sucesso.

## Cobertura observada

| Frente | Evidência automatizada |
|---|---|
| API e autorização | Filtros preservados, erros internos ocultos e proprietário obtido pelo JWT |
| Continuidade web | offline, fechamento, `keepalive` e descarte de resposta atrasada |
| Sessão da prova | sessão e questão exatas, métodos e IDs inválidos rejeitados |
| Compatibilidade | chamadas legadas não contornam a nova sessão |
| Conteúdo | 12 materiais, 48 questões, quatro alternativas e SQL atualizado |
| Imagens | imagem e texto alternativo em cada questão |
| Estudos | progresso persistido, idempotente e isolado por candidato |
| Logout e senha | revogação persistente e invalidação após troca de senha |
| Histórico | somente tentativas próprias; escolhida, correta e data no detalhe |
| Segurança | prova em andamento não revela gabarito; erros SQL não vazam |

## Banco e dados versionados

Todas as mudanças estruturais e de carga do banco estão concentradas em:

- `backend/database/schema.sql`;
- `backend/database/seed.sql`.

A carga automatizada valida 12 temas, 48 questões e quatro alternativas por
questão. O estado do Supabase remoto não foi alterado nem revalidado nesta
auditoria de documentação; antes da apresentação, confirmar que o schema atual
está aplicado e que as 48 questões continuam ativas e aprovadas.

## Situação das issues

Em 06/11/2026, todas as issues do milestone Sprint 2 estavam fechadas, exceto:

- [#48 — PB-027 Informar resposta correta](https://github.com/ctrlaltdevs0-droid/ABP_1/issues/48), 3 SP;
- responsáveis: `isabella0andreotti`, `AlvesRogiel` e `JulioCesarP95`.

## Limitações e validações manuais necessárias

- executar os três cenários PostgreSQL em ambiente com Docker;
- confirmar schema e carga no Supabase utilizado na apresentação;
- verificar as 48 questões ativas no ambiente real;
- demonstrar o fluxo completo em navegador e dispositivo móvel;
- registrar revisão por outro integrante e aceite do PO;
- concluir e validar a issue #48.

## Reproduzir a verificação

```bash
git checkout main
git pull --ff-only
cd backend
npm ci
npm test
```

Para a validação completa do banco, usar o fluxo documentado no repositório com
Docker e uma base efêmera. Não executar testes destrutivos no Supabase real.
