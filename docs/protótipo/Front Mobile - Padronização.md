# ÁgilCert – Documentação de Design (PC + Mobile)

**Projeto:** ABP – Aprendizagem Baseada em Projetos | **Equipe:** Ctrl Alt Devs | **Figma:** `ABP_ctrl_alt_devs`

Plataforma web de estudo e certificação em **Metodologias Ágeis**. Jornada: **1. Estude** os 12 temas → **2. Responda** as questões → **3. Conquiste** o certificado (validado por QR Code).

> Este documento unifica as duas versões anteriores (mobile e PC). Abordagem **mobile-first**: os valores base são do mobile e o PC sobrescreve a partir de `1024px`. Valores marcados com `~` são estimativas do PDF e devem ser confirmados no Figma. Valores marcados como **(sugerido)** não vieram de nenhuma das versões e precisam de aprovação.

---

## 0. Breakpoints

| Dispositivo | Largura | Origem |
|---|---|---|
| Mobile | até `767px` | Telas do PDF mobile |
| Tablet | `768px – 1023px` | **(sugerido)** herda o mobile, com grid de temas em 3 colunas |
| PC | `≥ 1024px` | Versão desktop |

---

## 1. Cores (comum aos dois)

As duas versões divergiam em vários tokens. Abaixo está a paleta unificada; as escolhas feitas estão na seção 1.1.

| Uso | Cor | HEX | Token |
|---|---|---|---|
| Primária | Azul escuro | `#014D9F` | `--color-primary` |
| Primária (hover) | Azul | `#1D4ED8` **(sugerido)** | `--color-primary-hover` |
| Secundária | Verde | `#10B981` | `--color-secondary` |
| Terciária / interativa | Azul claro | `#2563EB` | `--color-tertiary` |
| Destaque | Laranja | `#F59E0B` | `--color-accent` |
| Texto principal | Azul-marinho | `#0F172A` | `--color-text` |
| Texto secundário | Cinza azulado | `#4F5F6C` | `--color-text-secondary` |
| Fundo | Cinza azulado claro | `#F8FAFC` | `--color-bg` |
| Fundo alternativo (Início/seções) | Cinza claro | `#EEEEEE` | `--color-bg-alt` |
| Cards | Branco | `#FFFFFF` | `--color-card` |
| Borda | Cinza | `#CBD5E1` **(sugerido)** | `--color-border` |
| Divisor | Cinza | `#D9D9D9` | `--color-divider` |
| Erro | Vermelho | `#D03321` (50% de transparência) | `--color-error` |

**Onde usar**

- **Primária:** botões, links e títulos azuis.
- **Terciária:** ícones circulares e destaques interativos; era a primária na versão PC.
- **Secundária:** barras de progresso e check de acerto.
- **Destaque:** card de taxa de acerto e nome do certificado.
- **Texto secundário:** subtítulos, labels e placeholders.
- **Erro:** ícone/estado de resposta errada e mensagens de validação.

### 1.1 Decisões de compatibilização (confirmar)

| Item | Mobile dizia | PC dizia | Adotado | Motivo |
|---|---|---|---|---|
| Primária | `#014D9F` | `#2563EB` | `#014D9F` | É o azul que aparece nos botões e títulos das telas; `#2563EB` virou terciária. |
| Texto principal | `#014D9F` | `#0F172A` | `#0F172A` | Melhor contraste para texto corrido; o azul fica para títulos e links. |
| Texto secundário | `#4F5F6C` | `#64748B` | `#4F5F6C` | Cor observada nas telas. |
| Fundo | `#EEEEEE` | `#F8FAFC` | `#F8FAFC` + `--color-bg-alt` `#EEEEEE` | Mantém os dois usos (fundo geral e Início). |
| Hover do botão | igual à base | `#1D4ED8` | `#1D4ED8` | Hover igual à base não dá feedback. |
| Foco do input | `--color-text-secondary` | `--color-primary` | `--color-primary` | Foco mais visível. |

---

## 2. Tipografia

Roboto (títulos) e Inter (textos, botões, rótulos).

| Tipo | Fonte | Peso | Mobile | PC |
|---|---|---|---|---|
| h1 | Roboto | Regular | 51 | 103 |
| h2 | Roboto | Regular | 36 | 64 |
| h3 | Roboto | Regular | 21 | 51 |
| h4 | Roboto | Regular | 28 **(sugerido)** | 36 |
| h5 | Roboto | Regular | 22 **(sugerido)** | 26 |
| h6 | Inter | Medium | 21 | 21 |
| subtitle 1 | Roboto | Regular | 17 | 17 |
| subtitle 2 | Inter | Medium | 14 | 15 |
| body 1 | Inter | Regular | 17 | 16 |
| body 2 | Inter | Regular | 15 | 14 |
| button | Inter | Medium | 13 | 13 |
| caption | Inter | Regular | 12 | 12 |

**Pontos a conferir**

- Na versão mobile, *subtitle 2* estava como "Bold / Medium" e *body 2* como "Roboto Bold". Adotei Inter Medium e Inter Regular, que seguem o padrão da versão PC.
- *body 1* e *body 2* ficaram maiores no mobile do que no PC. Pode ser efeito de escala do PDF; confirmar no Figma.
- Mobile não definia h4, h5 e button. Os valores de h4/h5 são sugestões; button usa o mesmo valor do PC.

---

## 3. Variáveis CSS

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Roboto:wght@400&display=swap');

:root {
  /* Cores */
  --color-primary: #014D9F;
  --color-primary-hover: #1D4ED8;   /* sugerido */
  --color-secondary: #10B981;
  --color-tertiary: #2563EB;
  --color-accent: #F59E0B;
  --color-text: #0F172A;
  --color-text-secondary: #4F5F6C;
  --color-bg: #F8FAFC;
  --color-bg-alt: #EEEEEE;
  --color-card: #FFFFFF;
  --color-border: #CBD5E1;          /* sugerido */
  --color-divider: #D9D9D9;
  --color-error: rgba(208, 51, 33, 0.5);

  /* Fontes */
  --font-heading: 'Roboto', sans-serif;
  --font-body: 'Inter', sans-serif;

  /* Tipografia (base = mobile) */
  --fs-h1: 51px;
  --fs-h2: 36px;
  --fs-h3: 21px;
  --fs-h4: 28px;   /* sugerido */
  --fs-h5: 22px;   /* sugerido */
  --fs-h6: 21px;
  --fs-subtitle-1: 17px;
  --fs-subtitle-2: 14px;
  --fs-body-1: 17px;
  --fs-body-2: 15px;
  --fs-button: 13px;
  --fs-caption: 12px;

  /* Forma (base = mobile) */
  --radius-sm: 10px;   /* ~ */
  --radius-lg: 20px;   /* ~ */
  --shadow-card: 0 4px 10px rgba(0, 0, 0, 0.12); /* ~ */
  --input-height: 40px; /* ~ */

  /* Layout */
  --page-gutter: 16px;
  --theme-grid-cols: 2;
}

/* Tablet (sugerido) */
@media (min-width: 768px) {
  :root { --theme-grid-cols: 3; --page-gutter: 32px; }
}

/* PC */
@media (min-width: 1024px) {
  :root {
    --fs-h1: 103px;
    --fs-h2: 64px;
    --fs-h3: 51px;
    --fs-h4: 36px;
    --fs-h5: 26px;
    --fs-subtitle-2: 15px;
    --fs-body-1: 16px;
    --fs-body-2: 14px;

    --radius-sm: 8px;    /* ~ */
    --radius-lg: 16px;   /* ~ */
    --input-height: 44px; /* ~ */

    --page-gutter: 64px;
    --theme-grid-cols: 4;
  }
}

body {
  font-family: var(--font-body);
  font-size: var(--fs-body-1);
  color: var(--color-text);
  background: var(--color-bg);
}

.theme-grid {
  display: grid;
  grid-template-columns: repeat(var(--theme-grid-cols), 1fr);
  gap: 16px;
}
```

> Os espaçamentos laterais (`--page-gutter`) e o breakpoint de tablet não vieram do Figma; são sugestões.

---

## 4. Componentes

| Componente | Descrição (comum) | Mobile | PC |
|---|---|---|---|
| **Header público** | Só o logo (Login e Cadastro). | Logo à esquerda. | Igual. |
| **Header da prova** | Logo + cronômetro `00:00`. | Cronômetro abaixo do logo, à direita. | Logo e cronômetro na mesma linha **(sugerido)**. |
| **Header logado** | Logo, menu e avatar com dropdown (**Conta**, **Logout**). | Menu em linha com 4 itens: `INÍCIO · ESTUDOS · CERTIFICAÇÃO · HISTÓRICO`. Avatar só com ícone. | Menu com 5 itens: os 4 acima + `SOBRE NÓS`. Avatar + "Olá, Ana". |
| **Botão primário** | Fundo `--color-primary`, texto branco (*button*), sombra. Hover: `--color-primary-hover`. | Raio ~10px. | Raio ~8px. |
| **Input** | Borda 2px `--color-border`. Foco: borda `--color-primary`. | Altura ~40px, raio ~10px. | Altura ~44px, raio ~10px. |
| **Card** | Fundo branco, sombra suave. | Raio ~20px. | Raio ~16px. |
| **Card de tema** | Ícone circular colorido + título "NN.Tema". Na Área de estudos tem o link "Estudar >"; no Histórico tem barra de progresso. | Grid de 2 colunas. | Grid de 4 colunas. |
| **Barra de progresso** | Trilho com borda, preenchimento `--color-secondary`. | Igual. | Igual. |
| **Alternativa** | Borda cinza, radio à esquerda + texto. | Largura total. | Largura total, com limite máximo de largura **(sugerido)**. |
| **Card de estatística** | Número grande + rótulo + ícone (check, X, relógio). | Itens em 2 colunas. | Igual ou mais colunas **(sugerido)**. |
| **Busca** | Placeholder "Buscar tema...". | Largura total. | Largura total do grid. |

---

## 5. Páginas

| # | Página | Conteúdo principal | Diferenças mobile × PC |
|---|---|---|---|
| 1 | **Login** | Ilustração + formulário (E-mail, Senha), botão **Entrar**, link para Cadastro. | Mobile: ilustração abaixo do formulário. PC: **(sugerido)** ilustração ao lado. |
| 2 | **Cadastro** | Nome completo, CPF (`000.000.000-00`), E-mail, Senha, Confirmar senha, botão **Criar conta**, link para Login. | Idem Login. |
| 3 | **Início** | Hero com botão **Começar certificação**; seção **Como funciona?** (Estude, Responda, Conquiste); seção **Sobre nós** (redes sociais e contato). | Mobile: **Sobre nós** fica no rodapé (não há item no menu). PC: item `SOBRE NÓS` no menu. |
| 4 | **Área de estudos** | Busca + 12 temas ("Estudar >"). | Grid 2×6 no mobile, 4×3 no PC. |
| 5 | **Tema** | Título, texto curto, conteúdo e imagem. | Imagem após o conteúdo no mobile; layout em colunas no PC **(sugerido)**. |
| 6 | **Certificação (prova)** | Cronômetro, "Tema 02 de 12" com barra, enunciado (com imagem), 4 alternativas, botões **Tema anterior** / **Próximo tema**. | Botões lado a lado nos dois. A imagem do enunciado aparece acima das alternativas no mobile. |
| 7 | **Meu progresso** | Resultado: aprovado/reprovado, pontuação, acertos, tempo, tentativa (1/3), botão **Download certificado**. | Card centralizado nos dois. |
| 8 | **Certificado** | Nome, CPF mascarado, curso, nota, data e QR Code de validação. | O certificado escala proporcionalmente à largura. |
| 9 | **Histórico** | Busca + 12 temas com barra de progresso. | Grid 2×6 no mobile, 4×3 no PC. |
| 10 | **Estatísticas** | Questões resolvidas, certas, erradas, tempo médio, taxa de acerto × média da plataforma, botão **Responder questões**. Link "< Histórico de resultados" e botão "Veja mais estatísticas" (vistos na tela mobile). | Lista de acertos/erros em 2 colunas no mobile. |
| 11 | **Conta (Perfil)** | Avatar, nome, **Minhas certificações**, dados pessoais (CPF e senha mascarados), barra **Progresso da jornada** (Estudos Iniciados → Simulado Concluído → Certificação Ágil). | Cards de dados em coluna única no mobile; 2 colunas no PC **(sugerido)**. |

### Fluxo

```
Login ⇄ Cadastro → Início → Estudos → Tema
                          → Certificação → Meu progresso → Certificado
                          → Histórico → Estatísticas
                          → Menu "Olá, Ana" → Conta | Logout

---

## 6. Notas para o Back-end

**Entidades**

- **Usuário:** `nome_completo`, `cpf` (único), `email` (único), `senha` (hash), `avatar_url`
- **Tema (12):** `ordem`, `titulo`, `texto_curto`, `conteudo`, `imagem_url`
- **Questão:** `tema_id`, `enunciado`, `imagem_url` (opcional), 4 alternativas, `alternativa_correta`
- **Tentativa:** `usuario_id`, `data`, `pontuacao`, `acertos`, `total_questoes`, `tempo_gasto`, `numero_tentativa` (máx. 3), `aprovado`
- **Progresso por tema:** `usuario_id`, `tema_id`, `percentual`
- **Certificado:** `usuario_id`, `tentativa_id`, `data_emissao`, `nota_final`, `codigo_validacao` (QR Code)

**Regras vistas no design**

- CPF sempre mascarado (`123.***.***-45`); senha nunca exibida.
- Máximo de 3 tentativas.
- Certificado validável por QR Code (precisa de **rota pública**).
- As imagens de tema e de questão são servidas igualmente para mobile e PC; usar imagens responsivas (`srcset`) **(sugerido)**.

---

## 7. Pendências da equipe

### Definições de negócio

- [ ] **Nº de questões:** a Home diz 12, o resultado mostra `40/50`. Definir o valor oficial.
- [ ] **Nota mínima de aprovação** não está definida.

### Conflitos entre as versões (decidir)

- [ ] Confirmar as escolhas da seção 1.1 (primária, texto, fundo, hover, foco).
- [ ] Confirmar tamanhos de fonte, raios e altura de input por dispositivo (seções 2 e 3).
- [ ] Definir h4, h5 e button no mobile.
- [ ] Padronizar "Progresso da jornada" (telas mobile) × "Processo da jornada" (versões em texto). Adotado: **Progresso**.
- [ ] Padronizar o formato do CPF mascarado (`123******45` no Perfil × `123.***.***-45` no Certificado).
- [ ] Definir se "Analista de RH" (cargo exibido no Perfil mobile) é um campo do cadastro.

### Textos de exemplo para trocar

- [ ] Subtítulo repetido ("Explore os 12 temas e prepare-se para a certificação") em Histórico, Certificado e Meu progresso.
- [ ] "Dorem/Korem ipsum" no conteúdo do tema.
- [ ] "Rua la °paz, n°360".
- [ ] "Cadastre - se".
- [ ] Títulos dos cards todos como "01.Tema".
- [ ] "Minha Certificaçôes" (typo no botão do Perfil).
- [ ] Botão do Cadastro está escrito "Entrar"; deveria ser "Criar conta".

### Design ainda não feito

- [ ] **Estados de erro:** login inválido, CPF inválido, senhas diferentes.
- [ ] **Versão PC no PDF:** as telas fornecidas são só mobile; os valores de PC vieram do documento em texto.
- [ ] Layout de tablet.

### Figma × padrão (a conferir e ajustar)

- [ ] O azul dos botões no PDF é mais escuro que o token primário da documentação.
- [ ] Texto dos botões está em 10px bold (padrão: Inter Medium 13).
- [ ] Os textos parecem todos em Roboto (padrão: Inter em body, botão e rótulos).
- [ ] Estatísticas mostra 11 questões resolvidas, mas lista 12 itens (valores de exemplo).
