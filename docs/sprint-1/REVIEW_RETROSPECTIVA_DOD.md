# Review, retrospectiva e aplicação da Definition of Done

Registro técnico da aplicação da devolutiva, em 26/10/2026.
Não é ata de uma reunião realizada. Data, participantes, responsáveis e aceite
abaixo precisam ser registrados pela equipe na cerimônia correspondente.

## Sprint Review — roteiro e registro de aceite

**Data da reunião:** pendente. **Participantes/PO:** pendente.

| Demonstração | Evidência técnica disponível | Aceite do PO |
|---|---|---|
| Cadastro e login, 12 temas e materiais | Teste HTTP e teste integrado com banco local | Pendente |
| Conclusão persistida e isolada por candidato | API, banco e recuperação após novo login | Pendente |
| Home e navegação em telas estreitas | Capturas e testes de navegação | Pendente |
| Inicialização completa por Docker Compose | Serviços e provisionamento com migrações rastreadas | Pendente |
| Logout invalida token antigo | Resposta 401 em rotas privadas após revogação | Pendente |
| 48 questões e revisão de materiais | Carga e validação estrutural | Revisão editorial pendente |

**Decisões do PO, ajustes de backlog e itens não aceitos:** preencher na Review.
Não fechar PBIs com revisão/aceite pendentes somente por terem testes aprovados.

## Retrospectiva — insumos verificáveis

**Data e participantes:** pendentes.

Observações técnicas para discussão:

- O provisionamento anterior criava apenas schema e temas; não reproduzia as
  migrações necessárias à API e continuava dependente de Supabase remoto.
- Links sem destino e falta de breakpoints da home impediam uma navegação completa.
- Apagar o JWT do navegador permitia reutilizar cópias do token até a expiração.
- Testes simulados não bastavam para demonstrar execução integrada com banco.

Ações propostas para a equipe validar, atribuir e acompanhar:

| Ação | Evidência de conclusão | Responsável/prazo |
|---|---|---|
| Exigir migração rastreável em mudanças de banco | Banco vazio e existente passam no provisionamento | A definir |
| Revisar tela e links em 320/390/768/1440px | Capturas e navegação verificadas | A definir |
| Testar segurança de sessão no aceite | Token antigo recusado após logout | A definir |
| Revisar materiais e autoria de design | Revisor e origem identificados | A definir |

## Aplicação da DoD

| Critério | Estado desta entrega |
|---|---|
| Frontend/backend/banco integrados para estudos | Implementados; ver evidências de validação |
| Regra de logout no servidor | Implementada com revogação persistente |
| Cargas e migrações reproduzíveis | Implementadas com checksum e registro transacional |
| Dados pessoais e chaves fora do frontend | Mantido; API de dados apenas na rede interna do Compose |
| Testes apropriados e documentação | Implementados; resultados em `evidencias/VALIDACAO_DEVOLUTIVA.md` |
| Desktop/celular e navegação | Ver evidências visuais e comparação com protótipo |
| Revisão de outro integrante | Pendente |
| Revisão editorial das 48 questões e materiais | Pendente |
| Aceite do PO e evidência da cerimônia | Pendente |

Itens pendentes permanecem explicitamente abertos; não foram atribuídos nomes,
datas de reuniões, aprovações ou resultados históricos sem evidência.
