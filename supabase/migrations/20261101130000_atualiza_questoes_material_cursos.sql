-- Atualiza as 48 questões já cadastradas com o conteúdo do material "Cursos - ABP".
-- Em banco novo não altera nada: o seed.sql já insere a versão nova.
BEGIN;

UPDATE public.questoes SET enunciado = 'Qual situação esteve associada à chamada Crise do Software?' WHERE codigo_seed = 'PB053-1-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-1');
UPDATE public.alternativas SET texto = 'Os computadores deixaram de utilizar softwares.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Projetos apresentavam atrasos, custos elevados e dificuldades para atender às necessidades dos usuários.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Todos os softwares começaram a ser desenvolvidos utilizando métodos ágeis.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Os sistemas se tornaram simples demais.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é uma característica comum do Modelo Cascata?' WHERE codigo_seed = 'PB053-1-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-2');
UPDATE public.alternativas SET texto = 'O desenvolvimento ocorre em ciclos curtos e contínuos.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Não existe planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'O projeto segue etapas sequenciais previamente definidas.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'O produto precisa ser entregue diariamente.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que significa ser ágil no desenvolvimento de software?' WHERE codigo_seed = 'PB053-1-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-3');
UPDATE public.alternativas SET texto = 'Desenvolver o máximo de funcionalidades possível, independentemente da necessidade do usuário.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Trabalhar sem planejamento para entregar mais rápido.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Evitar qualquer mudança depois que o projeto começar.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Trabalhar de maneira adaptável, colaborativa e com entregas e feedbacks frequentes.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual dos seguintes é um benefício das abordagens ágeis?' WHERE codigo_seed = 'PB053-1-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-4');
UPDATE public.alternativas SET texto = 'Identificar problemas e mudanças mais cedo por meio de entregas e feedbacks frequentes.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Eliminar completamente os testes de software.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Garantir que os requisitos nunca sejam alterados.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Desenvolver todo o sistema antes de receber qualquer feedback.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-1-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Por que o Scrum é considerado um framework?' WHERE codigo_seed = 'PB053-2-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-1');
UPDATE public.alternativas SET texto = 'Porque determina exatamente como cada tarefa deve ser executada.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Porque fornece uma estrutura de trabalho, permitindo que as equipes utilizem práticas adequadas à sua realidade.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Porque é uma linguagem utilizada para desenvolver sistemas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Porque elimina a necessidade de planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que significa empirismo no contexto do Scrum?' WHERE codigo_seed = 'PB053-2-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-2');
UPDATE public.alternativas SET texto = 'Tomar decisões somente com base no planejamento inicial.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Evitar mudanças durante o desenvolvimento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Adquirir conhecimento por meio da experiência e tomar decisões com base no que é observado.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Desenvolver todo o produto antes de analisar os resultados.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Quais são os três pilares do empirismo no Scrum?' WHERE codigo_seed = 'PB053-2-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-3');
UPDATE public.alternativas SET texto = 'Planejamento, desenvolvimento e entrega.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Velocidade, produtividade e qualidade.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Comunicação, documentação e planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Transparência, inspeção e adaptação.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Uma equipe percebeu, durante a inspeção, que uma funcionalidade não está funcionando como esperado e decidiu modificar a solução. Qual pilar está sendo aplicado ao realizar essa mudança?' WHERE codigo_seed = 'PB053-2-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-4');
UPDATE public.alternativas SET texto = 'Adaptação.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Transparência.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Documentação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-2-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a principal responsabilidade do Product Owner?' WHERE codigo_seed = 'PB053-3-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-1');
UPDATE public.alternativas SET texto = 'Desenvolver sozinho todas as funcionalidades do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Maximizar o valor do produto e gerenciar o Product Backlog.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Controlar os horários de todos os colaboradores.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Realizar exclusivamente os testes do software.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é uma das responsabilidades do Scrum Master?' WHERE codigo_seed = 'PB053-3-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-2');
UPDATE public.alternativas SET texto = 'Definir sozinho todas as funcionalidades do produto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Substituir os Developers durante a programação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Ajudar a equipe a aplicar o Scrum e superar impedimentos.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Aprovar obrigatoriamente todas as linhas de código.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Quem é responsável por criar o Sprint Backlog e organizar o trabalho necessário para a Sprint?' WHERE codigo_seed = 'PB053-3-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-3');
UPDATE public.alternativas SET texto = 'Os Developers.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Apenas o Product Owner.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Os clientes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Apenas o Scrum Master.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Como deve funcionar a interação entre os integrantes do Scrum Team?' WHERE codigo_seed = 'PB053-3-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-4');
UPDATE public.alternativas SET texto = 'Cada integrante trabalha isoladamente.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'O Scrum Master toma todas as decisões técnicas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'O Product Owner desenvolve todas as funcionalidades.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Todos colaboram, respeitando suas responsabilidades e buscando o mesmo objetivo.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-3-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a duração máxima de uma Sprint?' WHERE codigo_seed = 'PB053-4-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-1');
UPDATE public.alternativas SET texto = 'Uma semana.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Três meses.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Um mês.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Um ano.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é o principal objetivo do Sprint Planning?' WHERE codigo_seed = 'PB053-4-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-2');
UPDATE public.alternativas SET texto = 'Planejar o trabalho que será realizado durante a Sprint.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Avaliar exclusivamente o desempenho individual dos colaboradores.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Apresentar o produto final ao cliente.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Encerrar o projeto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Para que serve a Daily Scrum?' WHERE codigo_seed = 'PB053-4-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-3');
UPDATE public.alternativas SET texto = 'Aprovar todas as funcionalidades do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Substituir o Sprint Planning.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Definir o orçamento anual do projeto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Inspecionar o progresso em direção ao Sprint Goal e adaptar o planejamento.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a diferença entre Sprint Review e Sprint Retrospective?' WHERE codigo_seed = 'PB053-4-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-4');
UPDATE public.alternativas SET texto = 'Ambas possuem exatamente a mesma finalidade.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'A Review analisa o resultado do produto, enquanto a Retrospective busca melhorar a forma de trabalhar.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'A Review é realizada diariamente e a Retrospective ocorre antes do planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'A Retrospective serve exclusivamente para apresentar funcionalidades aos clientes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-4-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a finalidade do Product Backlog?' WHERE codigo_seed = 'PB053-5-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-1');
UPDATE public.alternativas SET texto = 'Registrar exclusivamente as tarefas já concluídas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Substituir todas as reuniões da equipe.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Organizar uma lista ordenada das necessidades de melhoria do produto.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Armazenar somente os erros encontrados no sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que compõe o Sprint Backlog?' WHERE codigo_seed = 'PB053-5-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-2');
UPDATE public.alternativas SET texto = 'Sprint Goal, itens selecionados do Product Backlog e plano de trabalho.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Apenas o nome dos Developers.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Somente o orçamento do projeto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Exclusivamente os resultados das Sprints anteriores.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que representa o Incremento no Scrum?' WHERE codigo_seed = 'PB053-5-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-3');
UPDATE public.alternativas SET texto = 'Uma lista de ideias que ainda não foram analisadas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Uma reunião realizada antes do desenvolvimento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Um documento de planejamento financeiro.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Um resultado utilizável do produto que atende à Definition of Done.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a finalidade da Definition of Done?' WHERE codigo_seed = 'PB053-5-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-4');
UPDATE public.alternativas SET texto = 'Determinar quem será o Product Owner.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Estabelecer um entendimento comum sobre os critérios de qualidade para considerar um Incremento concluído.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Definir a duração de todas as Sprints.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Organizar exclusivamente as prioridades do Product Backlog.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-5-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a principal finalidade de uma User Story?' WHERE codigo_seed = 'PB053-6-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-1');
UPDATE public.alternativas SET texto = 'Descrever uma necessidade sob a perspectiva do usuário.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Substituir todos os testes do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Registrar exclusivamente o código-fonte.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Definir o salário dos integrantes da equipe.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual alternativa apresenta a estrutura mais utilizada de uma User Story?' WHERE codigo_seed = 'PB053-6-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-2');
UPDATE public.alternativas SET texto = 'Quando... Onde... Quanto...', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Problema... Código... Entrega...', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Como... Quero... Para...', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Início... Meio... Fim...', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Para que servem os critérios de aceitação?' WHERE codigo_seed = 'PB053-6-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-3');
UPDATE public.alternativas SET texto = 'Determinar a duração obrigatória de uma Sprint.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Definir condições que permitem verificar se a história atende ao comportamento esperado.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Substituir o Product Owner.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Escolher a linguagem de programação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual alternativa apresenta uma User Story bem estruturada?' WHERE codigo_seed = 'PB053-6-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-4');
UPDATE public.alternativas SET texto = 'Criar tabela no banco de dados.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Corrigir arquivos do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Desenvolver três botões azuis.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Como cliente, quero acompanhar meus pedidos, para saber quando serão entregues.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-6-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Quem é responsável pela gestão do Product Backlog no Scrum?' WHERE codigo_seed = 'PB053-7-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-1');
UPDATE public.alternativas SET texto = 'Exclusivamente os clientes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'O Scrum Master.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Apenas os Developers.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'O Product Owner.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que significa priorizar os itens do Product Backlog?' WHERE codigo_seed = 'PB053-7-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-2');
UPDATE public.alternativas SET texto = 'Desenvolver todos os itens simultaneamente.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Avaliar a importância dos itens e definir sua ordem.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Remover todas as funcionalidades complexas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Organizar as atividades somente por ordem alfabética.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a finalidade do refinamento do Product Backlog?' WHERE codigo_seed = 'PB053-7-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-3');
UPDATE public.alternativas SET texto = 'Detalhar e melhorar a compreensão dos itens para facilitar o trabalho futuro.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Encerrar automaticamente a Sprint.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Substituir os testes do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Impedir que novas necessidades sejam adicionadas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Por que o Product Backlog deve evoluir durante o projeto?' WHERE codigo_seed = 'PB053-7-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-4');
UPDATE public.alternativas SET texto = 'Porque todos os itens precisam ser alterados diariamente.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Porque o planejamento inicial deve ser ignorado.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Porque novas necessidades e informações podem surgir ao longo do desenvolvimento.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Porque não é permitido concluir os itens existentes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-7-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a principal finalidade de um quadro Kanban?' WHERE codigo_seed = 'PB053-8-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-1');
UPDATE public.alternativas SET texto = 'Substituir todas as ferramentas de programação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Visualizar as atividades e seu andamento no fluxo de trabalho.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Definir os salários da equipe.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Registrar somente as tarefas concluídas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que significa WIP?' WHERE codigo_seed = 'PB053-8-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-2');
UPDATE public.alternativas SET texto = 'Work in Progress, ou trabalho em andamento.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Work in Planning, ou trabalho em planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Weekly Information Process.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Workflow Internal Program.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que pode indicar um gargalo em um quadro Kanban?' WHERE codigo_seed = 'PB053-8-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-3');
UPDATE public.alternativas SET texto = 'Todas as atividades estão concluídas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'A equipe possui poucas solicitações.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Os cards mudam normalmente entre as etapas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Muitas atividades ficam acumuladas em uma determinada etapa.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual prática ajuda a melhorar o fluxo de trabalho no Kanban?' WHERE codigo_seed = 'PB053-8-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-4');
UPDATE public.alternativas SET texto = 'Iniciar o máximo possível de atividades ao mesmo tempo.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Ignorar tarefas que estão bloqueadas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Limitar o trabalho em andamento e analisar os gargalos.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Evitar acompanhar o tempo de execução.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-8-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é uma característica do planejamento ágil?' WHERE codigo_seed = 'PB053-9-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-1');
UPDATE public.alternativas SET texto = 'Definir todo o projeto sem permitir alterações.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Eliminar a necessidade de estimativas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Planejar continuamente e adaptar decisões conforme novas informações.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Realizar planejamento somente após concluir o produto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que os Story Points representam?' WHERE codigo_seed = 'PB053-9-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-2');
UPDATE public.alternativas SET texto = 'Uma estimativa relativa de esforço, complexidade e incerteza.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'A quantidade exata de horas de uma atividade.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'O número de colaboradores da equipe.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'O valor financeiro de uma funcionalidade.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a finalidade do Planning Poker?' WHERE codigo_seed = 'PB053-9-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-3');
UPDATE public.alternativas SET texto = 'Escolher o Product Owner.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Definir os salários da equipe.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Substituir todos os testes do sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Estimar atividades de forma colaborativa, discutindo diferentes percepções.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que é considerado no planejamento de Releases?' WHERE codigo_seed = 'PB053-9-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-4');
UPDATE public.alternativas SET texto = 'Apenas a quantidade de reuniões realizadas.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Quais funcionalidades poderão ser disponibilizadas em determinadas versões ou períodos.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Somente os erros encontrados no código.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Exclusivamente a distribuição de tarefas diárias.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-9-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'O que a Velocity normalmente representa?' WHERE codigo_seed = 'PB053-10-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-1');
UPDATE public.alternativas SET texto = 'O tempo necessário para abrir o sistema.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'A quantidade de trabalho concluído por uma equipe em uma Sprint.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'A quantidade de colaboradores contratados.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'O número de reuniões realizadas no projeto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual gráfico mostra a quantidade de trabalho restante ao longo do tempo?' WHERE codigo_seed = 'PB053-10-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-2');
UPDATE public.alternativas SET texto = 'Burnup Chart.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Gráfico de organograma.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Gráfico financeiro.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Burndown Chart.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é uma diferença importante entre Lead Time e Cycle Time?' WHERE codigo_seed = 'PB053-10-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-3');
UPDATE public.alternativas SET texto = 'Lead Time pode incluir o período de espera antes do início do trabalho, enquanto Cycle Time mede a partir do início efetivo.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Ambos representam obrigatoriamente a mesma duração.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Cycle Time mede somente o tempo de reuniões.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Lead Time representa a quantidade de Story Points.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a forma mais adequada de utilizar métricas ágeis?' WHERE codigo_seed = 'PB053-10-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-4');
UPDATE public.alternativas SET texto = 'Comparar individualmente os funcionários sem considerar o contexto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Aumentar os números independentemente da qualidade.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Analisar tendências e dificuldades para apoiar decisões e melhorias.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Substituir completamente a comunicação entre os integrantes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-10-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a finalidade principal do GitHub Issues?' WHERE codigo_seed = 'PB053-11-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-1');
UPDATE public.alternativas SET texto = 'Criar exclusivamente apresentações.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Substituir todas as linguagens de programação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Registrar e acompanhar tarefas, bugs e solicitações.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Realizar somente reuniões virtuais.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual ferramenta é conhecida pela organização visual utilizando quadros, listas e cartões?' WHERE codigo_seed = 'PB053-11-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-2');
UPDATE public.alternativas SET texto = 'Trello.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Compilador Java.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Editor de imagens.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Sistema operacional.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual alternativa apresenta ferramentas que podem apoiar o planejamento e o acompanhamento de equipes ágeis?' WHERE codigo_seed = 'PB053-11-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-3');
UPDATE public.alternativas SET texto = 'Apenas navegadores de internet.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Somente editores de texto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Exclusivamente sistemas de e-mail.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Jira, Azure Boards e GitHub Projects.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é uma boa prática ao utilizar quadros e cards?' WHERE codigo_seed = 'PB053-11-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-4');
UPDATE public.alternativas SET texto = 'Deixar todas as tarefas permanentemente como "Em andamento".', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Manter as informações atualizadas e representar o andamento real das atividades.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Evitar registrar dificuldades.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Criar atividades sem descrições ou informações necessárias.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-11-4') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Por que a comunicação é importante em projetos ágeis?' WHERE codigo_seed = 'PB053-12-1';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-1');
UPDATE public.alternativas SET texto = 'Porque elimina a necessidade de planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-1') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Porque permite que apenas uma pessoa conheça o andamento do projeto.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-1') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Porque impede qualquer alteração nas atividades.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-1') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Porque ajuda a compartilhar informações, alinhar objetivos e identificar dificuldades.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-1') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual situação representa a colaboração em uma equipe ágil?' WHERE codigo_seed = 'PB053-12-2';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-2');
UPDATE public.alternativas SET texto = 'Um integrante identifica um problema e decide ocultá-lo.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-2') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Integrantes compartilham conhecimentos e ajudam a resolver uma dificuldade técnica.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-2') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Cada pessoa trabalha isoladamente, sem compartilhar informações.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-2') AND letra = 'C';
UPDATE public.alternativas SET texto = 'A equipe evita discutir soluções diferentes.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-2') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Qual é a principal finalidade do feedback contínuo?' WHERE codigo_seed = 'PB053-12-3';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-3');
UPDATE public.alternativas SET texto = 'Identificar oportunidades de melhoria a partir das informações recebidas.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-3') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Impedir que usuários participem do desenvolvimento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-3') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Substituir todas as atividades de planejamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-3') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Garantir que o produto nunca precise de alterações.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-3') AND letra = 'D';

UPDATE public.questoes SET enunciado = 'Uma equipe identifica que seu processo está causando atrasos e decide modificar a forma de trabalhar. Quais boas práticas estão sendo aplicadas?' WHERE codigo_seed = 'PB053-12-4';
UPDATE public.alternativas SET correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-4');
UPDATE public.alternativas SET texto = 'Falta de planejamento e isolamento.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-4') AND letra = 'A';
UPDATE public.alternativas SET texto = 'Resistência à mudança e ausência de comunicação.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-4') AND letra = 'B';
UPDATE public.alternativas SET texto = 'Melhoria contínua e adaptação.', correta = TRUE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-4') AND letra = 'C';
UPDATE public.alternativas SET texto = 'Eliminação da colaboração e do feedback.', correta = FALSE WHERE questoes_idquestoes = (SELECT idquestoes FROM public.questoes WHERE codigo_seed = 'PB053-12-4') AND letra = 'D';
COMMIT;
