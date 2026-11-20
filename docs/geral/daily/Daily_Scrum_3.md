# Daily Scrum — Sprint 3 — Projeto ÁgilCert

**Equipe:** CTRL ALT DEVS  
**Projeto:** Portal de Certificação em Metodologias Ágeis  
**Instituição:** FATEC Jacareí  
**Período previsto:** 06/11/2026 a 25/11/2026  

---

## Objetivo da Sprint

Emitir e validar certificados com QR Code, revisar a qualidade das questões e a coerência dos conteúdos, validar segurança, responsividade e desempenho, e concluir a documentação e a estabilização do produto para a entrega final.

## Objetivo do registro

Apresentar o acompanhamento coletivo da Sprint 3, com base na documentação e no código do projeto, respondendo:

1. O que foi realizado?
2. Quais são as próximas atividades?
3. Quais dificuldades ou impedimentos foram identificados?

Este documento consolida o andamento da sprint, sem atribuições individuais e sem representar atas de reuniões diárias.

---

## O que foi realizado?

### 1. Emissão de certificados após aprovação

Foi concluído o fluxo de emissão de certificados para candidatos aprovados na avaliação, com acesso direto pela tela de resultado e pelo histórico de tentativas.

A emissão valida no banco a aprovação e a titularidade da tentativa, garantindo um identificador único, impedindo a duplicação de registros em acessos repetidos e bloqueando a exibição de certificados revogados ou inativos.

### 2. Validação pública e QR Code

O certificado passou a exibir os dados do candidato com CPF parcialmente mascarado, aproveitamento, data de emissão, código de validação, opção de download em PDF e QR Code gerado localmente.

A página pública de validação permite consultar a autenticidade do documento sem necessidade de login, apresentando apenas os dados mínimos de comprovação e tratando códigos inválidos ou revogados sem expor informações sensíveis.

### 3. Revisão das questões, imagens e coerência dos conteúdos

Foram concluídas a revisão completa das 48 questões e de suas imagens e a verificação de coerência entre os materiais de estudo e as avaliações, cobrindo:

- A conferência de estrutura, gabarito único e ortografia das 48 questões.
- A verificação das 48 imagens e de seus direitos de uso.
- O alinhamento dos 12 textos de estudo ao material oficial do portal.
- A padronização dos nomes dos temas e a preservação do histórico das provas já realizadas.

### 4. Responsividade, interface e otimização de desempenho

As páginas essenciais do portal receberam ajustes de padronização visual, navegação e responsividade para uso em computador e dispositivos móveis, além da atualização dos diagramas do projeto.

Também foi realizada a revisão de desempenho, com otimização das principais imagens da interface, prevenção de cliques duplicados no login e no cadastro e verificação dos tempos de resposta da API.

### 5. Segurança, proteção de dados e testes do sistema

Foram validadas as regras de proteção de dados pessoais, a minimização de informações na consulta pública e a garantia de que a validação das respostas e o cálculo da nota ocorram exclusivamente no servidor.

Os testes automatizados foram ampliados para cobrir emissão de certificado e validação pública, e o fluxo completo do sistema, incluindo interrupção, retomada e execução em ambiente containerizado, foi validado de ponta a ponta.

### 6. Documentação final da API e operação

Foram concluídas a documentação da API e a documentação de funcionalidades e operação, reunindo instruções de instalação, configuração do ambiente, execução de testes e roteiro completo de demonstração do produto.

---

## Quais são as próximas atividades?

1. **Realizar a Sprint Review e a apresentação final**, demonstrando o fluxo completo do portal, do cadastro do candidato à validação pública do certificado.

2. **Conduzir a Sprint Retrospective final**, consolidando os aprendizados e os resultados obtidos ao longo das três sprints.

3. **Formalizar o encerramento da entrega**, confirmando o cumprimento da Definition of Done e o aceite final do produto.

---

## Quais dificuldades ou impedimentos foram identificados?

### Integração paralela entre frentes

O desenvolvimento simultâneo de certificado, validação pública, ajustes de interface, desempenho e documentação gerou conflitos de integração no repositório.

Esses conflitos foram resolvidos com revisões conjuntas para preservar o layout, as dependências do projeto e as regras de autenticidade.

### Alinhamento entre os textos de estudo e a base de questões

Durante a verificação de coerência, foram identificadas divergências entre o resumo inicial da carga de estudos e os conceitos cobrados em parte das questões.

Os textos dos 12 temas foram atualizados para refletir o material completo, garantindo coerência integral sem alterar as questões nem o histórico das provas.

### Compatibilidade do ambiente Docker no Windows

Diferenças de quebra de linha em scripts de inicialização dificultaram a subida dos containers em máquinas Windows.

O problema foi corrigido com padronização dos arquivos no repositório e inclusão de orientações claras no manual de operação.

### Peso das imagens e envios duplicados no frontend

As medições iniciais apontaram imagens acima do tamanho necessário para exibição e possibilidade de envio duplicado nos formulários de acesso.

As imagens foram otimizadas sem perda visual relevante e os botões de envio passaram a ser bloqueados durante o carregamento.

### Leitura do QR Code em dispositivos externos

A validação via QR Code em outro aparelho depende da configuração do endereço público ou de rede da aplicação, uma vez que o acesso local funciona apenas na máquina em execução.

Esse comportamento foi documentado no manual de operação e considerado no preparo da demonstração final, sem impedimentos bloqueadores em aberto para a entrega.

---

## Situação da Sprint

A Sprint 3 foi concluída com todas as entregas previstas integradas e validadas, incluindo emissão de certificado em PDF, QR Code, validação pública, revisão de conteúdos e questões, otimização de desempenho, testes e documentação final.

Com o fechamento desta última sprint, o escopo completo do portal ÁgilCert encontra-se finalizado, estável e documentado.

A equipe segue pronta para a Sprint Review, a demonstração de ponta a ponta e o encerramento do projeto.

---

**Equipe CTRL ALT DEVS — Projeto ÁgilCert**
