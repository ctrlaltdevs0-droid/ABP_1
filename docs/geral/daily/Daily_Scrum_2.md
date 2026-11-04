# Daily Scrum — Sprint 2 — Projeto ÁgilCert

**Equipe:** CTRL ALT DEVS  
**Projeto:** Portal de Certificação em Metodologias Ágeis  
**Instituição:** FATEC Jacareí  
**Período previsto:** 23/10/2026 a 05/11/2026  

---

## Objetivo da Sprint

Desenvolver o motor da certificação, incluindo criação da tentativa, seleção das questões, controle de tempo, registro das respostas, persistência, retomada e cálculo do resultado.

## Objetivo do registro

Apresentar o acompanhamento coletivo da Sprint 2, com base na documentação e no código do projeto, respondendo:

1. O que foi realizado?
2. Quais são as próximas atividades?
3. Quais dificuldades ou impedimentos foram identificados?

Este documento consolida o andamento da sprint, sem atribuições individuais e sem representar atas de reuniões diárias.

---

## O que foi realizado?

### 1. Continuidade da área de estudos

A equipe deu continuidade às pendências relacionadas aos 12 temas, aos materiais didáticos e à base de 48 questões.

O código inclui quizzes por tema, apresentação de feedback e recuperação das respostas do candidato. A conclusão de um tema exige três acertos, com verificação também no backend.

Esses exercícios pertencem à área de estudos e são diferentes da prova de certificação.

### 2. Estruturação das tentativas de certificação

Foram desenvolvidas rotas para criação e consulta de tentativas, apresentação da próxima questão, registro de respostas e finalização da avaliação.

A autorização associa a tentativa ao candidato autenticado e verifica o proprietário no acesso aos registros existentes.

### 3. Preparação das regras da prova

Foram adicionadas funções de banco para controlar:

- A composição da prova com 12 temas.
- A seleção de questões elegíveis.
- A sequência das questões.
- O prazo de 150 segundos por questão.
- O registro das respostas.
- A finalização e o cálculo do resultado.

Essas funções estão presentes nas migrações, mas sua integração às rotas da prova permanece pendente na versão analisada.

### 4. Melhorias na autenticação e nas sessões

O código inclui limitação de chamadas de login e cadastro, revogação da sessão no logout e invalidação das sessões anteriores após a troca de senha.

Essas funcionalidades dependem da aplicação das migrações correspondentes no ambiente utilizado.

### 5. Revisão do tratamento de erros

Foram documentadas e implementadas melhorias para padronizar respostas de erro e reduzir a exposição de informações internas.

Ainda é necessário conferir a aplicação dessas melhorias em todas as rotas utilizadas pelo fluxo de certificação.

### 6. Preparação de testes e validações

A documentação registra testes automatizados e verificações com PostgreSQL em ambiente isolado.

Esses resultados são históricos e precisam ser reconciliados com o código recebido, pois foram encontradas diferenças entre as correções descritas e as rotas atuais.

---

## Quais são as próximas atividades?

1. **Integrar as funções seguras às rotas da prova**, garantindo que a aplicação utilize os controles transacionais preparados no banco.

2. **Validar a composição obrigatória da avaliação**, impedindo a criação ou finalização de provas incompletas.

3. **Concluir o controle de tempo e sequência**, verificando respostas antecipadas, atrasadas, duplicadas ou fora de ordem.

4. **Finalizar interrupção e retomada**, conforme as regras de encerramento da questão e continuidade no próximo tema pendente.

5. **Completar a estrutura de persistência dos quizzes**, incluindo a criação versionada da tabela utilizada para armazenar as respostas de estudo.

6. **Revisar e aprovar conteúdos, questões e imagens**, garantindo coerência com os 12 temas e com os requisitos do desafio.

7. **Implementar e integrar as telas da certificação**, incluindo instruções, avaliação, resultado e histórico.

8. **Executar os testes da versão integrada**, com frontend, backend e banco no ambiente utilizado pela equipe.

9. **Registrar revisão e aceite**, mantendo abertas as entregas que ainda dependem de validação.

---

## Quais dificuldades ou impedimentos foram identificados?

### Integração das regras de segurança

Embora existam funções transacionais e registros de correção, as rotas de tentativas incluídas na versão analisada ainda utilizam consultas diretas.

Isso impede considerar os controles de integridade e tempo como totalmente integrados.

### Possibilidade de prova incompleta

A lógica atual de criação pode ignorar temas sem questões, enquanto a finalização utiliza a quantidade de questões vinculadas à tentativa.

É necessário garantir que a avaliação contemple obrigatoriamente os 12 temas antes da conclusão.

### Persistência dos exercícios

O código dos quizzes utiliza a tabela `respostas_estudos`, mas sua criação não foi localizada no schema ou nas migrações incluídas no projeto.

Essa dependência precisa ser resolvida para permitir a reprodução completa do ambiente.

### Revisão e publicação das questões

As questões da carga permanecem inativas e em rascunho, aguardando revisão editorial.

Também é necessário garantir que o fluxo da prova selecione somente questões aprovadas e disponíveis.

### Interrupção e retomada

O comportamento diante de fechamento do navegador e perda de conexão ainda exige implementação e validação conforme os requisitos.

### Interface e validação da entrega

Existem protótipos para o fluxo da certificação, mas as telas completas de prova, resultado e histórico não foram encontradas entre os HTMLs incluídos.

Também permanecem pendentes a validação no ambiente de uso e o aceite da equipe.

---

## Situação da Sprint

A Sprint 2 apresenta avanços na área de estudos, na autenticação e na preparação do motor da certificação.

O foco de continuidade é integrar as regras da prova, completar as interfaces e validar o fluxo com dados revisados e persistência reproduzível.

A entrega completa da sprint permanece pendente de integração, testes e aceite.

---

**Equipe CTRL ALT DEVS — Projeto ÁgilCert**
