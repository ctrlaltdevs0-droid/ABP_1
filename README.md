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


<h3>Executar com Docker Compose</h3>

Requer Docker com Compose 2.24 ou superior. Execute os comandos na raiz do repositório.

1. Se ainda não existir, copie `.env.example` para `.env`.
2. Preencha `SUPABASE_URL`, `SUPABASE_SECRET_KEY` e `JWT_SECRET` (ao menos 32 caracteres).
3. Defina `POSTGRES_PASSWORD` para o banco local. `POSTGRES_DB` e `POSTGRES_USER` têm padrão `postgres`; essas credenciais são independentes do projeto Supabase.
4. Execute:

```bash
docker compose config --quiet
docker compose up -d --build
docker compose ps
```

Abra `http://localhost:3000`. O serviço `app` serve frontend e API; `PORT` no `.env` da raiz altera a porta publicada. Dentro do contêiner, a aplicação usa a porta 3000.

A aplicação lê as variáveis de `.env` da raiz e depois de `backend/.env`, quando presentes. Valores de `backend/.env` prevalecem; mantenha as credenciais atualizadas nesse arquivo se já o utiliza. Os arquivos `.env` não são copiados para a imagem.

O serviço `database` disponibiliza PostgreSQL local em `localhost:5433`, com volume persistente, schema base e carga dos 12 temas. **A API continua conectada ao Supabase remoto**; o banco local não substitui a API HTTP do Supabase. As migrações em `supabase/migrations` devem ser aplicadas ao projeto remoto conforme o [README do backend](backend/README.md).

Para subir somente a aplicação, use `docker compose up -d --build app`. Para subir somente o banco, use `docker compose up -d database`. A validação do Compose exige `POSTGRES_PASSWORD` nos dois casos.

```bash
docker compose logs --tail=100 app database
docker compose exec database sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT count(*) FROM temas;"'
docker compose down
```

A consulta deve retornar 12 em um banco recém-inicializado. `docker compose down` mantém os dados. Schema e seed executam apenas na primeira inicialização de um volume vazio; alterações nesses arquivos e nas credenciais não atualizam automaticamente um banco existente.
