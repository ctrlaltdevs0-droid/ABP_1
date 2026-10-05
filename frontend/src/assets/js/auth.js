function togglePassword(id, button) {
  const input = document.getElementById(id);
  const visible = input.type === "text";
  input.type = visible ? "password" : "text";
  button.textContent = visible ? "Mostrar" : "Ocultar";
}

function showFeedback(message, type = "error") {
  const box = document.querySelector(".feedback");
  if (!box) return;
  box.textContent = message;
  box.className = `feedback show ${type}`;
}

document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("form[data-auth-form]");
  if (!form) return;

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    if (form.dataset.authForm === "cadastro") {
      const senha = document.getElementById("senha").value;
      const confirmacao = document.getElementById("confirmacao").value;
      if (senha !== confirmacao) {
        showFeedback("As senhas não coincidem.");
        return;
      }
      showFeedback("Cadastro validado no frontend. Conecte este formulário à rota do backend.", "success");
      return;
    }

    showFeedback("Login validado no frontend. Conecte este formulário à rota do backend.", "success");
  });
});
