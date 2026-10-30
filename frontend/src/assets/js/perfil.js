const iconeOlhoAberto = `
  <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="#536169" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
    <circle cx="12" cy="12" r="3"></circle>
  </svg>
`;

const iconeOlhoFechado = `
  <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="#536169" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
    <line x1="1" y1="1" x2="23" y2="23"></line>
  </svg>
`;

// Função global para alternar visibilidade nos botões de senha
window.toggleSenha = function (inputId, btn) {
  const input = document.getElementById(inputId);
  if (!input) return;

  if (input.type === 'password') {
    input.type = 'text';
    btn.innerHTML = iconeOlhoFechado;
  } else {
    input.type = 'password';
    btn.innerHTML = iconeOlhoAberto;
  }
};

// Formatação do CPF (000.000.000-00)
function formatarCPF(cpf) {
  if (!cpf) return '—';
  const limpo = String(cpf).replace(/\D/g, '');
  if (limpo.length !== 11) return cpf;
  return limpo.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\$1.\$2.\$3-\$4');
}

// Extração segura das iniciais do nome sem erros
function obterIniciais(nome) {
  if (!nome) return '—';
  const partes = String(nome).trim().split(/\s+/).filter(Boolean);
  if (partes.length === 0) return '—';
  if (partes.length === 1) return partes[0].slice(0, 2).toUpperCase();
  return (partes[0][0] + partes[partes.length - 1][0]).toUpperCase();
}

// ==========================================
// GERENCIAMENTO DO PERFIL
// ==========================================
document.addEventListener('DOMContentLoaded', async () => {
  // Mapeamento dos elementos do HTML
  const profileName = document.getElementById('profile-name');
  const profileAvatar = document.getElementById('profile-avatar');
  const profileFullname = document.getElementById('profile-fullname');
  const profileEmail = document.getElementById('profile-email');
  const profileCpf = document.getElementById('profile-cpf');
  const profileStatus = document.getElementById('profile-status');

  const profileForm = document.getElementById('profile-form');
  const saveProfileBtn = document.getElementById('save-profile');

  const passwordForm = document.getElementById('password-form');
  const currentPasswordInput = document.getElementById('current-password');
  const newPasswordInput = document.getElementById('new-password');
  const confirmPasswordInput = document.getElementById('confirm-password');
  const passwordStatus = document.getElementById('password-status');
  const savePasswordBtn = document.getElementById('save-password');

  const logoutBtn = document.getElementById('logout-button');

  let usuarioOriginal = null;

  // Redireciona para o login caso não exista token de sessão
  const token = localStorage.getItem('token');
  if (!token) {
    window.location.href = 'login.html';
    return;
  }

  // Preenche todos os campos na tela
  function preencherCampos(usuario) {
    if (!usuario) return;
    usuarioOriginal = usuario;

    // Preenche Nome, E-mail e CPF
    if (profileFullname) profileFullname.value = usuario.nome || '';
    if (profileEmail) profileEmail.value = usuario.email || '';
    if (profileCpf) profileCpf.textContent = formatarCPF(usuario.cpf);

    // Preenche Título e Avatar
    if (profileName) profileName.textContent = usuario.nome || 'Minha conta';
    if (profileAvatar) profileAvatar.textContent = obterIniciais(usuario.nome);
  }

  // 1. Carrega o cache salvo no localStorage instantaneamente
  const usuarioSalvo = localStorage.getItem('usuario');
  if (usuarioSalvo) {
    try {
      const u = JSON.parse(usuarioSalvo);
      preencherCampos(u.usuario || u);
    } catch (e) {
      console.error('Erro ao ler cache do usuário:', e);
    }
  }

  // 2. Busca os dados atualizados do banco via API (GET /api/usuarios/me)
  try {
    const res = await AgilCertAPI.request('usuarios/me');
    const usuarioAtualizado = res.usuario || res;

    preencherCampos(usuarioAtualizado);
    localStorage.setItem('usuario', JSON.stringify(usuarioAtualizado));
    if (profileStatus) profileStatus.textContent = '';
  } catch (err) {
    console.error('Erro ao buscar perfil na API:', err);
    if (!usuarioOriginal && profileStatus) {
      profileStatus.textContent = 'Erro ao carregar dados do usuário.';
      profileStatus.style.color = '#e74c3c';
    }
  }

  // Habilita o botão "Salvar alterações" se Nome ou E-mail forem modificados
  function checarMudancas() {
    if (!usuarioOriginal) return;
    const nomeMudou = profileFullname.value.trim() !== (usuarioOriginal.nome || '');
    const emailMudou = profileEmail.value.trim().toLowerCase() !== (usuarioOriginal.email || '');

    if (saveProfileBtn) {
      saveProfileBtn.disabled = !(nomeMudou || emailMudou);
    }
  }

  profileFullname?.addEventListener('input', checarMudancas);
  profileEmail?.addEventListener('input', checarMudancas);

  // 3. Salvar alterações de Nome e E-mail (PATCH /api/usuarios/me)
  profileForm?.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (profileStatus) profileStatus.textContent = '';

    try {
      if (saveProfileBtn) saveProfileBtn.disabled = true;

      // Envia APENAS nome e email para cumprir as regras estritas do backend
      const res = await AgilCertAPI.request('usuarios/me', {
        method: 'PATCH',
        body: {
          nome: profileFullname.value.trim(),
          email: profileEmail.value.trim()
        }
      });

      const usuarioAtualizado = res.usuario || res;
      preencherCampos(usuarioAtualizado);
      localStorage.setItem('usuario', JSON.stringify(usuarioAtualizado));

      if (profileStatus) {
        profileStatus.textContent = 'Perfil atualizado com sucesso!';
        profileStatus.style.color = '#2ecc71';
      }
    } catch (err) {
      if (profileStatus) {
        profileStatus.textContent = err.message || 'Erro ao salvar alterações.';
        profileStatus.style.color = '#e74c3c';
      }
      if (saveProfileBtn) saveProfileBtn.disabled = false;
    }
  });

  // Habilita "Alterar senha" apenas se a nova senha tiver 8+ caracteres e coincidir
  function checarValidacaoSenha() {
    const atual = currentPasswordInput?.value || '';
    const nova = newPasswordInput?.value || '';
    const confirma = confirmPasswordInput?.value || '';

    if (savePasswordBtn) {
      savePasswordBtn.disabled = !(atual && nova.length >= 8 && nova === confirma);
    }
  }

  currentPasswordInput?.addEventListener('input', checarValidacaoSenha);
  newPasswordInput?.addEventListener('input', checarValidacaoSenha);
  confirmPasswordInput?.addEventListener('input', checarValidacaoSenha);

  // 4. Alterar Senha (PATCH /api/usuarios/me/senha)
  passwordForm?.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (passwordStatus) passwordStatus.textContent = '';

    if (newPasswordInput.value !== confirmPasswordInput.value) {
      if (passwordStatus) {
        passwordStatus.textContent = 'A nova senha e a confirmação não coincidem.';
        passwordStatus.style.color = '#e74c3c';
      }
      return;
    }

    try {
      if (savePasswordBtn) savePasswordBtn.disabled = true;

      await AgilCertAPI.request('usuarios/me/senha', {
        method: 'PATCH',
        body: {
          senhaAtual: currentPasswordInput.value,
          novaSenha: newPasswordInput.value
        }
      });

      if (passwordStatus) {
        passwordStatus.textContent = 'Senha alterada. Entre novamente com a nova senha.';
        passwordStatus.style.color = '#2ecc71';
      }

      passwordForm.reset();
      localStorage.removeItem('token');
      localStorage.removeItem('usuario');
      window.location.assign('login.html');
      if (savePasswordBtn) savePasswordBtn.disabled = true;
    } catch (err) {
      if (passwordStatus) {
        passwordStatus.textContent = err.message || 'Erro ao alterar senha.';
        passwordStatus.style.color = '#e74c3c';
      }
      if (savePasswordBtn) savePasswordBtn.disabled = false;
    }
  });

  // 5. Botão de Logout
  logoutBtn?.addEventListener('click', async () => {
    logoutBtn.disabled = true;
    try { await AgilCertAPI.logout(); }
    catch (error) {
      if (profileStatus) profileStatus.textContent = error.message;
      logoutBtn.disabled = false;
    }
  });
});
