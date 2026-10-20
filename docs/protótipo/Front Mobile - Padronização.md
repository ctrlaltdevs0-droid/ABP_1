ÁgilCert – Documentação de Design
Projeto: ABP – Aprendizagem Baseada em Projetos | Equipe: Ctrl Alt Devs | Figma: ABP_ctrl_alt_devs

Plataforma web de estudo e certificação em Metodologias Ágeis. Jornada: 1. Estude os 12 temas → 2. Responda as questões → 3. Conquiste o certificado (validado por QR Code).

Cores e fontes seguem o padrão definido pela equipe. Espaçamentos, raios e sombras são estimativas do PDF (~) e devem ser confirmados no Figma.

1. Cores
Uso	Cor	HEX	               Token
Primária	Azul	        #014D9F	--color-primary
Secundária	Verde   	    #10B981	--color-secondary
Terciaria       Azul Claro  #2563EB    --color-tertiary
Destaque	Laranja	        #F59E0B	--color-accent
Texto principal	Azul    	#014D9F	--color-text
Texto secundário	Cinza	#4F5F6C	--color-text-secondary
Fundo	Cinza azulado claro	#EEEEEE	--color-bg
Cards	   Branco           #FFFFFF    --color-card

Onde usar: primária em botões, links e títulos azuis; secundária em barras de progresso e check de acerto; destaque no card de taxa de acerto e no nome do certificado; texto secundário em subtítulos, labels e placeholders.

2. Fontes
Roboto (títulos) e Inter (textos, botões, rótulos).

Tipo	Fonte	    Peso	    Tamanho
h1	    Roboto	    Regular       51
h2	    Roboto	    Regular	      36
h3	    Roboto	    Regular	      21
h6	    Inter	    Medium	      21
subtitle 1	Roboto	Regular   	  17
subtitle 2	Bold	Medium	      14
body 1	  Inter	    Regular	      17
body 2	  Roboto    Bold	      15
caption	  Inter	    Regular	      12

3. Variáveis CSS
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Roboto:wght@400&display=swap');

:root {
  --color-primary:          #014D9F;
  --color-secondary:        #10B981;
  --color-tertiary:         #2563EB ;
  --color-accent:           #F59E0B;
  --color-text:             #014D9F;
  --color-text-secondary:   #4F5F6C;
  --color-bg:               #EEEEEE;
  --color-card:             #FFFFFF;
  --color-primary-hover:    #1D4ED8; /* sugerido */
  --color-border:           #CBD5E1; /* sugerido */
 
  --font-heading: 'Roboto', sans-serif;
  --font-body: 'Inter', sans-serif;

  --radius-sm: 10px;   /* ~ */
  --radius-lg: 20px;  /* ~ */
  --shadow-card: 0 4px 10px rgba(0, 0, 0, 0.12); /* ~ */
}
body { font-family: var(--font-body); font-size: 20px; color: var(--color-text); background: var(--color-bg); }

4. Componentes
Componente	Descrição
Header público	Só o logo (Login e Cadastro).
Header da prova	Logo + cronômetro 00:00.
Header logado	Logo, menu INÍCIO · ESTUDOS · CERTIFICAÇÃO · HISTÓRICO · SOBRE NÓS, avatar com dropdown (Conta, Logout).
Botão primário	Fundo --color-primary, texto branco (estilo button), raio ~10px, sombra. Hover: --color-primary.
Input	Altura ~40px, borda 2px --color-border, raio ~10px. Foco: borda --color-text-secondary.
Card	Fundo branco, raio ~20px, sombra suave.
Card de tema	Ícone circular colorido + título "NN.Tema". Na Área de estudos tem o link "Estudar >"; no Histórico tem barra de progresso.
Barra de progresso	Trilho com borda, preenchimento --color-secondary.
Alternativa	Borda cinza, radio à esquerda + texto.
Card de estatística	Número grande + rótulo + ícone (check, X, relógio).
Busca	Placeholder "Buscar tema...".

5. Páginas
#	Página	Conteúdo principal
1	Login	Ilustração + formulário (E-mail, Senha), botão Entrar, link para Cadastro.
2	Cadastro	Nome completo, CPF (000.000.000-00), E-mail, Senha, Confirmar senha, botão Criar conta, link para Login.
3	Início	Hero com botão Começar certificação; seção Como funciona? (Estude, Responda, Conquiste); seção Sobre nós (redes sociais e contato).
4	Área de estudos	Busca + grid 2×6 com os 12 temas ("Estudar >").
5	Tema	Título, texto curto e conteúdo.
6	Certificação (prova)	Cronômetro, "Tema 02 de 12" com barra, enunciado, 4 alternativas, botões Tema anterior / Próximo tema.
7	Meu progresso	Resultado: aprovado/reprovado, pontuação, acertos, tempo, tentativa (1/3), botão Download certificado.
8	Certificado	Nome, CPF mascarado, curso, nota, data e QR Code de validação.
9	Histórico	Busca + grid dos 12 temas com barra de progresso.
10	Estatísticas	Questões resolvidas, certas, erradas, tempo médio, taxa de acerto × média da plataforma, botão Responder questões.
11	Conta (Perfil)	Avatar, nome, Minhas certificações, dados pessoais (CPF e senha mascarados), barra Processo da jornada (Estudos Iniciados → Simulado Concluído → Certificação Ágil).
Fluxo:

Login ⇄ Cadastro → Início → Estudos → Tema
                          → Certificação → Meu progresso → Certificado
                          → Histórico → Estatísticas
                          → Menu "Olá, Ana" → Conta | Logout
6. Notas para o Back-end
Entidades:

Usuário: nome_completo, cpf (único), email (único), senha (hash), avatar_url
Tema (12): ordem, titulo, texto_curto, conteudo,
Questão: tema_id, enunciado, 4 alternativas, alternativa_correta
Tentativa: usuario_id, data, pontuacao, acertos, total_questoes, tempo_gasto, numero_tentativa (máx. 3), aprovado
Progresso por tema: usuario_id, tema_id, percentual
Certificado: usuario_id, tentativa_id, data_emissao, nota_final, codigo_validacao (QR Code)
Regras vistas no design:

CPF sempre mascarado (123.***.***-45); senha nunca exibida.
Máximo de 3 tentativas.
Certificado validável por QR Code (precisa de rota pública).
7. Pendências da equipe
Nº de questões: a Home diz 12, o resultado mostra 40/50. Definir o valor oficial.
Nota mínima de aprovação não está definida.
Textos de exemplo para trocar: subtítulo repetido em Certificado e Meu progresso, "Korem ipsum", "Rua la °paz", "Cadastre - se".
Estados de erro (login inválido, CPF inválido, senhas diferentes) Figma × padrão: no PDF, o azul dos botões é mais escuro que #014D9F o texto dos botões está em 10px bold (padrão: Inter medium 13) e os textos parecem todos em Roboto (padrão: Inter em body, botão e rótulos). Conferir e ajustar o Figma.