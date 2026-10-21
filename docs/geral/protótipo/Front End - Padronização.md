# ÁgilCert – Documentação de Design

**Projeto:** ABP – Aprendizagem Baseada em Projetos | **Equipe:** Ctrl Alt Devs | **Figma:** `ABP_ctrl_alt_devs`

Plataforma web de estudo e certificação em **Metodologias Ágeis**. Jornada: **1. Estude** os 12 temas → **2. Responda** as questões → **3. Conquiste** o certificado (validado por QR Code).

> Cores e fontes seguem o padrão definido pela equipe. Espaçamentos, raios e sombras são estimativas do PDF (`~`) e devem ser confirmados no Figma.

---

## 1. Cores

| Uso | Cor | HEX | Token |
|---|---|---|---|
| Primária | Azul | `#2563EB` | `--color-primary` |
| Secundária | Verde/teal | `#10B981` | `--color-secondary` |
| Destaque | Laranja | `#F59E0B` | `--color-accent` |
| Texto principal | Azul-marinho | `#0F172A` | `--color-text` |
| Texto secundário | Cinza | `#64748B` | `--color-text-secondary` |
| Fundo | Cinza azulado claro | `#F8FAFC` | `--color-bg` |
| Cards | Branco | `#FFFFFF` | `--color-card` |

**Complementares (sugeridos, fora da paleta, aprovar):** hover do botão `#1D4ED8`, borda `#CBD5E1`, divisor `#E2E8F0`, erro `#EF4444`.

**Onde usar:** primária em botões, links e títulos azuis; secundária em barras de progresso e check de acerto; destaque no card de taxa de acerto e no nome do certificado; texto secundário em subtítulos, labels e placeholders.

## 2. Fontes

Roboto (títulos) e Inter (textos, botões, rótulos).

| Tipo | Fonte | Peso | Tamanho |
|---|---|---|---|
| h1 | Roboto | Regular | 103 |
| h2 | Roboto | Regular | 64 |
| h3 | Roboto | Regular | 51 |
| h4 | Roboto | Regular | 36 |
| h5 | Roboto | Regular | 26 |
| h6 | Inter | Medium | 21 |
| subtitle 1 | Roboto | Regular | 17 |
| subtitle 2 | Inter | Medium | 15 |
| body 1 | Inter | Regular | 16 |
| body 2 | Inter | Regular | 14 |
| button | Inter | Medium | 13 |
| caption | Inter | Regular | 12 |

## 3. Variáveis CSS

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Roboto:wght@400&display=swap');

:root {
  --color-primary: #2563EB;
  --color-secondary: #10B981;
  --color-accent: #F59E0B;
  --color-text: #0F172A;
  --color-text-secondary: #64748B;
  --color-bg: #F8FAFC;
  --color-card: #FFFFFF;
  --color-primary-hover: #1D4ED8; /* sugerido */
  --color-border: #CBD5E1;        /* sugerido */
  --color-divider: #D9D9D9;       
  --color-error: #D03321;         /* com 50% de transparência */

  --font-heading: 'Roboto', sans-serif;
  --font-body: 'Inter', sans-serif;

  --radius-sm: 8px;   /* ~ */
  --radius-lg: 16px;  /* ~ */
  --shadow-card: 0 4px 10px rgba(0, 0, 0, 0.12); /* ~ */
}

body { font-family: var(--font-body); font-size: 16px; color: var(--color-text); background: var(--color-bg); }
```

---

## 4. Componentes

| Componente | Descrição |
|---|---|
| **Header público** | Só o logo (Login e Cadastro). |
| **Header da prova** | Logo + cronômetro `00:00`. |
| **Header logado** | Logo, menu `INÍCIO · ESTUDOS · CERTIFICAÇÃO · HISTÓRICO · SOBRE NÓS`, avatar + "Olá, Ana" com dropdown (**Conta**, **Logout**). |
| **Botão primário** | Fundo `--color-primary`, texto branco (estilo *button*), raio ~8px, sombra. Hover: `--color-primary-hover`. |
| **Input** | Altura ~44px, borda 2px `--color-border`, raio ~10px. Foco: borda `--color-primary`. |
| **Card** | Fundo branco, raio ~16px, sombra suave. |
| **Card de tema** | Ícone circular colorido + título "NN.Tema". Na Área de estudos tem o link "Estudar >"; no Histórico tem barra de progresso. |
| **Barra de progresso** | Trilho com borda, preenchimento `--color-secondary`. |
| **Alternativa** | Borda cinza, radio à esquerda + texto. |
| **Card de estatística** | Número grande + rótulo + ícone (check, X, relógio). |
| **Busca** | Placeholder "Buscar tema...". |

---

## 5. Páginas

| # | Página | Conteúdo principal |
|---|---|---|
| 1 | **Login** | Ilustração + formulário (E-mail, Senha), botão **Entrar**, link para Cadastro. |
| 2 | **Cadastro** | Nome completo, CPF (`000.000.000-00`), E-mail, Senha, Confirmar senha, botão **Criar conta**, link para Login. |
| 3 | **Início** | Hero com botão **Começar certificação**; seção **Como funciona?** (Estude, Responda, Conquiste); seção **Sobre nós** (redes sociais e contato). |
| 4 | **Área de estudos** | Busca + grid 4×3 com os 12 temas ("Estudar >"). |
| 5 | **Tema** | Título, texto curto, conteúdo e imagem. |
| 6 | **Certificação (prova)** | Cronômetro, "Tema 02 de 12" com barra, enunciado (com imagem), 4 alternativas, botões **Tema anterior** / **Próximo tema**. |
| 7 | **Meu progresso** | Resultado: aprovado/reprovado, pontuação, acertos, tempo, tentativa (1/3), botão **Download certificado**. |
| 8 | **Certificado** | Nome, CPF mascarado, curso, nota, data e QR Code de validação. |
| 9 | **Histórico** | Busca + grid dos 12 temas com barra de progresso. |
| 10 | **Estatísticas** | Questões resolvidas, certas, erradas, tempo médio, taxa de acerto × média da plataforma, botão **Responder questões**. |
| 11 | **Conta (Perfil)** | Avatar, nome, **Minhas certificações**, dados pessoais (CPF e senha mascarados), barra **Processo da jornada** (Estudos Iniciados → Simulado Concluído → Certificação Ágil). |

**Fluxo:**
```
Login ⇄ Cadastro → Início → Estudos → Tema
                          → Certificação → Meu progresso → Certificado
                          → Histórico → Estatísticas
                          → Menu "Olá, Ana" → Conta | Logout
```

---

## 6. Notas para o Back-end

**Entidades:**
- **Usuário:** nome_completo, cpf (único), email (único), senha (hash), avatar_url
- **Tema (12):** ordem, titulo, texto_curto, conteudo, imagem_url
- **Questão:** tema_id, enunciado, imagem_url (opcional), 4 alternativas, alternativa_correta
- **Tentativa:** usuario_id, data, pontuacao, acertos, total_questoes, tempo_gasto, numero_tentativa (máx. 3), aprovado
- **Progresso por tema:** usuario_id, tema_id, percentual
- **Certificado:** usuario_id, tentativa_id, data_emissao, nota_final, codigo_validacao (QR Code)

**Regras vistas no design:**
- CPF sempre mascarado (`123.***.***-45`); senha nunca exibida.
- Máximo de 3 tentativas.
- Certificado validável por QR Code (precisa de rota pública).

---

## 7. Pendências da equipe

1. **Nº de questões:** a Home diz 12, o resultado mostra `40/50`. Definir o valor oficial.
2. **Nota mínima de aprovação** não está definida.
3. **Textos de exemplo para trocar:** subtítulo repetido em *Certificado* e *Meu progresso*, "Korem ipsum", "Rua la °paz", "Cadastre - se".
4. **Estados de erro** (login inválido, CPF inválido, senhas diferentes) e **versão mobile** não estão no design.
5. **Figma × padrão:** no PDF, o azul dos botões é mais escuro que `#2563EB`, o texto dos botões está em 10px bold (padrão: Inter medium 13) e os textos parecem todos em Roboto (padrão: Inter em body, botão e rótulos). Conferir e ajustar o Figma.
