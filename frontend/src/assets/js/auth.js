// --- 1. Exibir mensagens de feedback ---
function showFeedback(message, type = "error") {
  const box = document.querySelector(".feedback");
  if (!box) {
    if (message) alert(message);
    return;
  }
  box.textContent = message;
  box.className = `feedback show ${type}`;
}

// --- 2. Gerenciamento do Cadastro e Login ---
document.addEventListener("DOMContentLoaded", () => {
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
          showFeedback(data.mensagem || "Conta criada com sucesso! Redirecionando...", "success");
          registerForm.reset();

          // Redireciona para o login após cadastrar
          setTimeout(() => {
            window.location.href = "login.html";
          }, 1500);

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
