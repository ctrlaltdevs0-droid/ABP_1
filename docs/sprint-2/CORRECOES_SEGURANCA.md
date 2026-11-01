# Correções S01–S06

Verificação de 29/10/2026, baseada nos achados do relatório local
`docs/geral/VERIFICACAO_SPRINT1_SEGURANCA_2026-10-27.md`.
Este documento acompanha as correções versionadas; publicação e aplicação no
banco de uso são etapas separadas.

| Achado | Correção |
|---|---|
| S01 — Prova incompleta/certificado | Criação transacional exige exatamente 12 temas ativos com quatro questões elegíveis por tema. Finalização exige 12 vínculos ordenados, 12 temas distintos e nenhuma questão pendente. Certificado e resultado são gravados juntos, com bloqueio da tentativa e emissão idempotente. |
| S02 — Prazo/sequência | Ordem, abertura e prazo persistidos por questão. Primeira abertura inicia 150 segundos no relógio do banco; reabertura não renova. Respostas exigem questão atual aberta e prazo ainda válido. Timeout persiste como erro, inclusive na disputa entre chamadas. |
| S03 — Questões não publicadas | Sorteio exige tema ativo, questão ativa/APROVADO e quatro alternativas com um gabarito. Nova entrega revalida publicação. Cargas permanecem inativas/RASCUNHO; apenas testes isolados publicam dados sintéticos. |
| S04 — Autenticação ilimitada | Contadores transacionais no PostgreSQL por IP e conta, compartilhados entre instâncias. Janela de 15 minutos: login 30/IP e 10/conta, cadastro 10/IP e 10/conta. Excesso retorna 429 com Retry-After; falha no limitador retorna 503 antes do bcrypt. Login com letras maiúsculas também é limitado. |
| S05 — Troca de senha preserva sessões | Atualização atômica do hash e incremento da versão de sessão, com comparação do hash anterior. Autorização confere a versão no banco. Dois logins anteriores e tokens legados são recusados após a troca. Frontend encerra sessão local e direciona ao login. |
| S06 — Mensagens internas | Rotas de escrita e leitura recebem mensagens estáveis, com código SQL e identificador apenas no log. Falhas possuem X-Request-ID para correlação; detalhes SQL não são devolvidos. |

## Migração e compatibilidade

Aplicar `supabase/migrations/20261030005054_security_exam_sessions.sql` depois das
migrações existentes e **antes de executar o backend atualizado**. O Compose
aplica novas etapas pelo serviço `migrate`; ver `backend/README.md`.
Não editar migrações já aplicadas ou reaplicar schema em um banco existente.

As RPCs usam SECURITY INVOKER e search_path vazio. Somente service_role pode
executá-las; anon e authenticated não recebem acesso. A nova tabela de limites
possui RLS e acesso restrito ao backend, que utiliza JWT próprio.

Tentativas legadas sem ordem persistida são recusadas e exigem uma nova prova.
O prazo é por questão e começa na primeira abertura. Reabrir após interrupção
preserva o prazo; não foi implementada detecção de fechamento de navegador ou
uma política nova para desconexão dos PB-033/PB-034.

O endereço IP vem da conexão; cabeçalho X-Forwarded-For do cliente não é aceito.
Atrás de proxy, configurar explicitamente proxies confiáveis na implantação.
Todas as chamadas de login/cadastro contam, inclusive as bem-sucedidas; chamadas
bloqueadas não prorrogam a janela. CPF e IP são representados por HMAC no banco.

## Verificação reproduzível

```sh
cd backend && npm test
# Na raiz do repositório:
bash scripts/validar-seguranca.sh
```

O segundo comando cria e remove um PostgreSQL 17 descartável, sem rede, portas
publicadas ou volumes existentes. Aplica schema, migrações, cargas e validação
de 12 temas/12 materiais/48 questões/192 alternativas antes dos testes.

**Resultado:** `npm test`: 13 aprovados, zero falhas; os três testes de banco
ficam ignorados nessa execução. `bash scripts/validar-seguranca.sh`: três
aprovados, zero falhas, em PostgreSQL real. `git diff --check`: sem erros.

Cobertura real de banco: recusa de rascunhos, tema inativo, tema com menos de
quatro questões elegíveis e questão sem gabarito; ausência de tentativa parcial;
isolamento por dono; resposta antes da abertura, fora de ordem, duplicada e
expirada; prazo preservado na reabertura; timeout persistido sem resposta aceita;
retirada de publicação; cálculo com 12 questões; recusa de tentativa legada;
rollback da criação e emissão; resposta, entrega, finalização e limite concorrentes;
limites por conta/IP, recuperação da janela e troca atômica de senha.
Os testes forçam prazo passado diretamente no banco isolado, sem esperar 150s.

O advisor de segurança do Supabase executado sobre PostgreSQL descartável
retornou **No issues found**. Isso complementa os testes e não equivale a auditoria
de produção ou aprovação editorial.

## Pendências externas preservadas

Não foi aplicada migração no Supabase remoto, nem alterado o banco local já
existente. Validação de implantação, revisão editorial, conciliação com a issue
#22, demonstração com candidatos e aceite do PO continuam necessários.


## Integração no repositório correto

Aplicado em `/home/juliogregorio/Projects/ABP_1`, branch `develop`, preservando
os quizzes e os serviços de conteúdo recentes, o módulo `src/config/supabase.js`
e a carga consolidada `database/seed.sql`. O progresso de estudos continua exigindo
três acertos; os testes foram adaptados para essa regra. Corrigida também a
regressão que liberava acesso e aceitava logout quando falhava a consulta ou a
gravação de revogação. Nessas falhas, a operação não é considerada bem-sucedida.
