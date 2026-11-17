# RFC 001 — Como usar branches e commits no grupo

- **Status:** Proposta (já estamos usando na Sprint 2)
- **Data:** 29/10/2026, atualizada em 02/11/2026

## O problema

Cada um estava criando branches e commits do seu jeito. Isso causou:

- muitas branches antigas no GitHub (21 das 27 já tinham sido juntadas);
- nomes diferentes para a mesma coisa (`feature/`, `feat-`, `ajuste_home`...);
- código que sumiu ao juntar branches. Na Sprint 2, as rotas de pausa da prova se perderam num merge, e foram os testes que mostraram o erro.

## O que vamos combinar

### 1. As duas branches principais

- `main`: a versão que entregamos para os professores.
- `develop`: onde juntamos o trabalho de todos durante a sprint.

Ninguém faz commit direto nelas. Tudo entra por Pull Request (PR).

### 2. Uma branch para cada tarefa

O nome segue o modelo `tipo/nome-da-tarefa`, sem acento e com hífen:

- `feature/tela-de-historico`: algo novo
- `fix/login-com-cpf`: correção de erro
- `docs/manual-de-instalacao`: só documentação

### 3. Passo a passo

```bash
git checkout develop
git pull
git checkout -b feature/nome-da-tarefa

# depois de fazer as mudanças:
git add caminho/do/arquivo
git commit -m "feat: o que você fez"
git push -u origin feature/nome-da-tarefa
```

Depois:

1. Rode `npm test` na pasta `backend` para ver se nada quebrou.
2. Abra um Pull Request para a `develop` no GitHub.
3. Peça para outra pessoa do grupo revisar.
4. Depois do merge, apague a branch.

> Dica: evite `git add .`, porque ele pode levar arquivos que não deveriam ir, como o `.env`.

### 4. Mensagem de commit

Use `tipo: o que foi feito`, curto e em português:

- `feat: adiciona página de histórico`
- `fix: corrige login com CPF`
- `docs: atualiza o README`

Cada commit faz uma coisa só.

### 5. Fim da sprint

O grupo abre um PR da `develop` para a `main` e confere tudo junto antes da apresentação.

Documentação que não mexe no código (pasta `docs/`) pode ir direto para a `main` por PR.

## Limpeza das branches

- **Podem ser apagadas:** as que já estão na `develop`. No GitHub, aparecem como "Merged" na aba **Branches**.
- **Precisam de conferência de quem criou:** `docs/daily-scrum`, `timer-prova` e `feature/docker`, porque têm commits que ainda não foram juntados.

## Como decidir

Comentem no PR desta RFC. Se o grupo concordar, o status muda para **Aceita**.
