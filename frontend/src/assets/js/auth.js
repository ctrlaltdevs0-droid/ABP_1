// --- 1. Exibir mensagens de feedback ---
function showFeedback(message, type = "error") {
  const box = document.querySelector(".feedback");
  if (!box) return;

  // Se a mensagem for vazia, esconde a caixa e limpa o conteúdo
  if (!message) {
    box.textContent = "";
    box.className = "feedback"; 
    return;
  }

  box.textContent = message;
  box.className = `feedback show ${type}`;
}

// --- 2. Gerenciamento do Cadastro e Login ---
document.addEventListener("DOMContentLoaded", () => {
  const authFormArea = document.querySelector(".auth-form-area");
  const registerForm = document.getElementById("registerForm");
  const loginForm = document.getElementById("loginForm");

  // ==========================================
  // === FLUXO DE CADASTRO                     ===
  // ==========================================
  if (registerForm) {
    registerForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      showFeedback("");

      // Pega os campos do formulário de cadastro
      const nome = document.getElementById("nome")?.value.trim() || "";
      const cpf = document.getElementById("cpf")?.value.trim() || "";
      const email = document.getElementById("cadastroEmail")?.value.trim() || "";
      const senha = document.getElementById("cadastroSenha")?.value || "";
      const confirmacao = document.getElementById("confirmarSenha")?.value || "";

      // Validação local de senhas
      if (senha !== confirmacao) {
        showFeedback("As senhas não coincidem. Verifique e tente novamente.", "error");
        return;
      }

      try {
        const data = await window.AgilCertAPI.request('login/cadastro', {
          method: "POST",
          authenticated: false,
          body: { cpf, nome, email, senha }
        });

        {
          if (authFormArea) {
          authFormArea.innerHTML = `
            <div class="auth-success-state">
              <div class="success-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
              </div>
        
              <h2 class="auth-title">Conta criada!</h2>
        
              <p class="auth-subtitle">
                Seu cadastro foi realizado com sucesso. Você será redirecionado para a tela de login.
              </p>
        
              <a href="login.html" class="btn-primary auth-button success-btn">
                Ir para o login
              </a>
            </div>
          `;
        
          setTimeout(() => {
            window.location.href = "login.html";
          }, 2000);
        }

        }
      } catch (error) {
        console.error("Erro no cadastro:", error);
        showFeedback(error.message || "Erro ao realizar cadastro.", "error");
      }
    });
  }

  // ==========================================
  // === FLUXO DE LOGIN                       ===
  // ==========================================
  if (loginForm) {
    loginForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      showFeedback("");

      // Pega apenas CPF e Senha para o login
      const cpf = document.getElementById("cpf")?.value.trim() || "";
      const senha = document.getElementById("senha")?.value || "";

      try {
        const data = await window.AgilCertAPI.request('login/entrar', {
          method: "POST",
          authenticated: false,
          body: { cpf, senha }
        });

        {
          if (!data.token) throw new Error('O servidor não retornou uma sessão válida.');
          showFeedback("Login realizado com sucesso! Redirecionando...", "success");

          if (data.token) {
            localStorage.setItem("token", data.token);
          }

          // Redireciona para home.html após o login
          setTimeout(() => {
            window.location.href = "home.html";
          }, 1200);

        }
      } catch (error) {
        console.error("Erro no login:", error);
        showFeedback(error.message || "Erro ao realizar login.", "error");
      }
    });
  }
});
