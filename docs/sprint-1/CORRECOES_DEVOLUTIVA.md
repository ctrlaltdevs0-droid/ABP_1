# Aplicação da devolutiva da equipe — Sprint 1

Fonte preservada: [foto da devolutiva](evidencias/devolutiva-equipe.jpeg), recebida
em Downloads em 26/10/2026. Este documento distingue implementação técnica de
aceite e cerimônias da equipe.

## Rastreabilidade das quatro correções

| Pedido da devolutiva | Alteração aplicada | Evidência |
|---|---|---|
| 1. Estudo dos 12 temas, conteúdo, 48 questões, navegação e progresso | Área de estudos com lista/busca/leitura, links complementares, conclusão por candidato e recuperação após novo login; cargas repetíveis | `frontend/src/estudos.html`, `backend/src/routes/progresso.js`, `backend/database/seed-estudos.sql`, `validar-estudos.sql` |
| 2. Home no celular, destinos dos links e comparação com protótipo | Cabeçalho com menu acessível, reorganização do hero, etapas e rodapé; links de estudos/perfil/GitHub e indicação do estágio da certificação | `frontend/src/home.html`, `assets/css/home.css`; comparação abaixo |
| 3. Arquitetura real, migrações no provisionamento e execução completa em contêineres | PostgreSQL + serviço de migração + PostgREST + gateway interno + API/frontend. Banco local separado do Supabase remoto; histórico de migrações com checksum e transações | `compose.yaml`, `infra/`, [arquitetura real](../geral/ARQUITETURA_EXECUCAO.md) |
| 4. Preservar documentos/autorias, Review, retrospectiva, DoD e invalidar logout | Diagramas e Figma preservados; evidências e roteiro de aceite; token revogado pelo hash no banco e recusado pela API | `sessoes_revogadas`, `POST /api/login/sair`, `backend/test/sessoes.test.js`, [Review/retrospectiva/DoD](REVIEW_RETROSPECTIVA_DOD.md) |

## Comparação com o protótipo

Referências existentes preservadas:
[Desktop](../geral/protótipo/Front%20End%20-%20Padronização.md),
[Mobile](../geral/protótipo/Front%20Mobile%20-%20Padronização.md) e
[Figma original da equipe](https://www.figma.com/design/SwcF0Sngo2feMs0szTAkwC/ABP_ctrl_alt_devs?node-id=0-1).
A comparação foi feita com a documentação local do protótipo; não representa
inspeção visual do arquivo remoto do Figma nem aprovação de sua autoria.

| Aspecto | Referência | Implementação e diferença explícita |
|---|---|---|
| Identidade | Azul #2563EB, verde #10B981, Inter e Roboto | Paleta, logo e tipografia existentes preservados |
| Home | Hero, etapas e sobre a equipe | Mesmas seções; empilhadas no celular para evitar corte lateral |
| Navegação | Menu, perfil e logout | Menu recolhível no celular, com `aria-expanded` e foco visível; adaptação funcional em vez de comprimir cinco links na mesma linha |
| CTA da home | Começar certificação | Direciona a estudos; a seção certificação informa que a avaliação está em desenvolvimento, sem iniciar prova incompleta |
| Estudos | Busca e 12 temas, 4 colunas desktop e 2 mobile | Quatro colunas desktop; duas em telas intermediárias e uma em celulares estreitos para preservar a leitura dos títulos longos |
| Histórico | Progresso por tema | Navegação para “Meu progresso” em Estudos; histórico de certificações permanece parte do motor da prova |

## Preservação de autoria e documentos

Não substituídos nem reatribuídos: imagens do diagrama de classes e casos de uso
em `docs/geral/Diagramas`, esquema relacional em `backend/database/schema.sql`,
requisitos, backlog, diário e documentação desktop/mobile. O link do Figma no
README foi preservado. DER ou modelo lógico adicionais não foram encontrados
como arquivos independentes nesta árvore; não foram inventados como evidência.

As atribuições da foto são mantidas como fonte histórica, não como nova avaliação:
Evellyn Moreira (home/layout), Isabella Andreotti (cadastro/autenticação/integração),
Júlio César Pereira (rotas/infraestrutura), Luana Ferreira (documentação/produto),
Miriele Melo (prototipação atribuída no diário/issue), Paloma Silva
(documentação/design), Rogiel Alves (Docker/diário) e Vitória Conceição (frontend).
A foto também registra pendências de materiais e autoria verificável do Figma;
essas pendências exigem evidências da equipe e não são encerradas por este código.

## Reprodução das verificações

1. `node scripts/preparar-compose.mjs`.
2. `docker compose --env-file .env.compose up --build -d`.
3. `docker compose --env-file .env.compose ps -a` e conferir migração com saída 0.
4. `node scripts/validar-container.mjs` em ambiente local de validação, não produção.
5. `cd backend && npm ci && npm test`.
6. Abrir `/home.html` no celular, navegar a Estudos, concluir tema, sair e entrar
   novamente. Reutilizar o token antigo deve receber 401 em rota privada.

As questões permanecem rascunhos para revisão cruzada. A revisão editorial e
as pendências P0 do motor da certificação apontadas na revisão de segurança
não estão declaradas como resolvidas pela devolutiva de infraestrutura/estudos.
