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
        const response = await fetch(`${API_BASE_URL}/cadastro`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ cpf, nome, email, senha })
        });

        const data = await response.json();

        if (response.ok) {
          showFeedback(data.mensagem || "Conta criada com sucesso! Redirecionando...", "success");
          registerForm.reset();

          // Redireciona para o login após cadastrar
          setTimeout(() => {
            window.location.href = "login.html";
          }, 1500);

        } else {
          showFeedback(data.erro || data.mensagem || "Erro ao realizar cadastro.", "error");
        }
      } catch (error) {
        console.error("Erro no cadastro:", error);
        showFeedback("Erro ao conectar com o servidor. Verifique se o backend está rodando.", "error");
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
        const response = await fetch(`${API_BASE_URL}/entrar`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ cpf, senha }) // Apenas CPF e senha
        });

        const data = await response.json();

        if (response.ok) {
          showFeedback("Login realizado com sucesso! Redirecionando...", "success");

          if (data.token) {
            localStorage.setItem("token", data.token);
          }

          // Redireciona para home.html após o login
          setTimeout(() => {
            window.location.href = "home.html";
          }, 1200);

        } else {
          showFeedback(data.erro || data.mensagem || "CPF ou senha inválidos.", "error");
        }
      } catch (error) {
        console.error("Erro no login:", error);
        showFeedback("Erro ao conectar com o servidor. Verifique se o backend está rodando.", "error");
      }
    });
  }
});