<div align="center">
ABP_1
  
Grupo: CTRL ALT DEVS
</div>
Participantes: Evellyn Silva Moreira;Isabella Silva Andreotti; Júlio César Gregório Pereira; Luana Ferreira de Andrade; Miriele Freitas Vieira de Melo; Paloma Veloso da Silva; Rogiel Fernando Pereira Alves; Vitória Gabriely Ferreira da Conceição

<h3>Site do Curso de Scrum</h3>

<h3>Sobre o projeto</h3>

Este projeto consiste na criação de um site para divulgação de um curso sobre Scrum, apresentando seus principais conceitos, conteúdos e benefícios.

A proposta é desenvolver uma página simples, intuitiva e responsiva, proporcionando uma boa experiência para usuários interessados em conhecer e aprender sobre Scrum e metodologias ágeis.

<h3>Objetivo</h3>

Desenvolver um site simples, intuitivo e informativo para:

<ul> <li>Divulgar o curso de Scrum;</li> <li>Apresentar seus principais conteúdos e conceitos;</li> <li>Destacar os benefícios do curso;</li> <li>Facilitar o acesso às informações de inscrição.</li> </ul>

<h3>Público-alvo</h3>
  O projeto é direcionado principalmente para:

<ul> <li>Estudantes interessados em Scrum;</li> <li>Profissionais que desejam conhecer metodologias ágeis;</li> <li>Pessoas que buscam aprimorar seus conhecimentos em Scrum.</li> </ul>

<h3>Tecnologias utilizadas</h3>

O projeto foi desenvolvido utilizando:

<ul> <li><strong>HTML5</strong> — Estruturação da página;</li> <li><strong>CSS3</strong> — Estilização e responsividade;</li> <li><strong>JavaScript</strong> — Interatividade e funcionalidades.</li> </ul>
Resultado esperado

Criar uma página responsiva, moderna e informativa para divulgação do curso de Scrum, apresentando seus conteúdos e facilitando o acesso às informações para os interessados.

<h3>Status do projeto</h3>

Em desenvolvimento.

<h3>Documentação</h3>

A documentação está organizada por sprint, com os materiais compartilhados na pasta geral.

| Pasta | Conteúdo |
|---|---|
| [Documentação geral](docs/geral/) | Backlog do produto, refinamento das três sprints, protótipo e requisitos |
| [Sprint 1 — Fundação e acesso](docs/sprint-1/) | Planejamento, backlog e critérios de aceite da Sprint 1 |
| [Sprint 2 — Motor da certificação](docs/sprint-2/) | Espaço para os documentos e registros da Sprint 2 |
| [Sprint 3 — Certificação e entrega](docs/sprint-3/) | Espaço para os documentos e registros da Sprint 3 |

O [planejamento detalhado da Sprint 1](docs/sprint-1/SPRINT_1_GITHUB_PROJECTS_CTRL_ALT_DEVS.md) reúne os PBIs, as tarefas e a organização sugerida do GitHub Projects.



## 📺 Nosso canal no YouTube

**Ctrl Alt Devs!**

[▶️ Vídeo de apresentação | ABP-1 Sprint 1](https://youtu.be/mRPE58jU3zM?si=vkCz45VXcsh5eP7U)

[▶️ PokerPlanning Sprint 1](https://youtu.be/fKjHofrkEoY?si=1Qim3ktghWUGbOtb)


## 🎨 Protótipo no Figma

[🔗 Acessar o design do ÁgilCert — Ctrl Alt Devs](https://www.figma.com/design/SwcF0Sngo2feMs0szTAkwC/ABP_ctrl_alt_devs?node-id=6-27&t=DRw4OZrbT7jy5gQb-1)






## Executar o projeto completo localmente

```bash
node scripts/preparar-compose.mjs
docker compose --env-file .env.compose up --build -d
```

Abra `http://localhost:3000/home.html`. O ambiente local inclui banco,
provisionamento com migrações e cargas, API de dados, backend e frontend.
O `.env` do Supabase remoto e o banco local antigo não são alterados.
Veja [arquitetura e reprodução](docs/geral/ARQUITETURA_EXECUCAO.md),
[correções da devolutiva](docs/sprint-1/CORRECOES_DEVOLUTIVA.md) e
[Review, retrospectiva e DoD](docs/sprint-1/REVIEW_RETROSPECTIVA_DOD.md).
