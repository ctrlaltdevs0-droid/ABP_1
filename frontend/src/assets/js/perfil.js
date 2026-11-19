
const iconeOlhoAberto = `
  <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
    stroke="#536169" stroke-width="2" stroke-linecap="round"
    stroke-linejoin="round">
    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
    <circle cx="12" cy="12" r="3"></circle>
  </svg>
`;

const iconeOlhoFechado = `
  <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
    stroke="#536169" stroke-width="2" stroke-linecap="round"
    stroke-linejoin="round">
    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
    <line x1="1" y1="1" x2="23" y2="23"></line>
  </svg>
`;

// Alterna a visibilidade da senha.
window.toggleSenha = function (inputId, btn) {
  const input = document.getElementById(inputId);
  if (!input || !btn) return;

  if (input.type === 'password') {
    input.type = 'text';
    btn.innerHTML = iconeOlhoFechado;
  } else {
    input.type = 'password';
    btn.innerHTML = iconeOlhoAberto;
  }
};

// Formatação do CPF.
function formatarCPF(cpf) {
  if (!cpf) return '—';

  const limpo = String(cpf).replace(/\D/g, '');

  if (limpo.length !== 11) return cpf;

  return limpo.replace(
    /(\d{3})(\d{3})(\d{3})(\d{2})/,
    '$1.$2.$3-$4'
  );
}

// Extrai as iniciais do nome.
function obterIniciais(nome) {
  if (!nome) return '—';

  const partes = String(nome).trim().split(/\s+/).filter(Boolean);

  if (partes.length === 0) return '—';

  if (partes.length === 1) {
    return partes[0].slice(0, 2).toUpperCase();
  }

  return (
    partes[0][0] +
    partes[partes.length - 1][0]
  ).toUpperCase();
}

// ============================================================
// PROGRESSO DA JORNADA
// ============================================================

async function atualizarProgressoJornada() {
  const barra = document.getElementById('journey-progress');
  const preenchimento = document.getElementById('journey-fill');
  const descricao = document.getElementById('journey-description');

  const etapaEstudos = document.getElementById('milestone-studies');
  const etapaProva = document.getElementById('milestone-exam');
  const etapaCertificado = document.getElementById('milestone-certificate');

  if (!barra || !preenchimento) return;

  let progresso = 0;
  let mensagem = 'Você ainda não iniciou seus estudos.';

  try {
    // Busca os temas concluídos na API.
    const resposta = await AgilCertAPI.request('estudos/progresso');

    const temasConcluidos = Array.isArray(resposta)
      ? resposta
      : resposta.temasConcluidos || resposta.progresso || [];

    const quantidadeConcluida = temasConcluidos.length;

    // Etapa 1: estudos iniciados.
    const estudosIniciados =
      localStorage.getItem('agilcert_estudos_iniciados') === 'true' ||
      quantidadeConcluida > 0;

    if (estudosIniciados) {
      progresso = 1;
      mensagem = 'Você iniciou seus estudos. Continue avançando!';
    }

    // Etapa 2: os 12 temas foram concluídos.
    if (quantidadeConcluida >= 12) {
      progresso = 2;
      mensagem = 'Parabéns! Você concluiu os 12 temas. Agora pode fazer a prova!';
    }

    // Etapa 3: certificado gerado.
    const certificadoGerado =
      localStorage.getItem('agilcert_certificado_gerado') === 'true';

    if (certificadoGerado) {
      progresso = 3;
      mensagem = 'Parabéns! Sua prova foi concluída e seu certificado foi gerado!';
    }

  } catch (erro) {
    console.error('Erro ao carregar progresso:', erro);

    if (descricao) {
      descricao.textContent = 'Não foi possível carregar seu progresso.';
    }

    return;
  }

  const porcentagem = (progresso / 3) * 100;

  preenchimento.style.width = `${porcentagem}%`;

  barra.setAttribute('aria-valuenow', porcentagem);
  barra.setAttribute(
    'aria-valuetext',
    `${Math.round(porcentagem)}% concluído`
  );

  if (descricao) {
    descricao.textContent = mensagem;
  }

  [etapaEstudos, etapaProva, etapaCertificado].forEach((etapa, indice) => {
    if (!etapa) return;

    etapa.classList.toggle('completed', indice < progresso);
  });
}

// ============================================================
// GERENCIAMENTO DO PERFIL
// ============================================================

document.addEventListener('DOMContentLoaded', async () => {

  // Mapeamento dos elementos do HTML.
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

  // Redireciona para o login caso não exista token.
  const token = localStorage.getItem('token');

  if (!token) {
    window.location.href = 'login.html';
    return;
  }

  // Preenche os dados do usuário na tela.
  function preencherCampos(usuario) {
    if (!usuario) return;

    usuarioOriginal = usuario;

    // Nome, e-mail e CPF.
    if (profileFullname) profileFullname.value = usuario.nome || '';
    if (profileEmail) profileEmail.value = usuario.email || '';
    if (profileCpf) profileCpf.textContent = formatarCPF(usuario.cpf);

    // Título e avatar.
    if (profileName) profileName.textContent = usuario.nome || 'Minha conta';
    if (profileAvatar) profileAvatar.textContent = obterIniciais(usuario.nome);

    // E-mail exibido no menu da conta.
    const displayEmail = document.getElementById('profile-display-email');

    if (displayEmail) {
      displayEmail.textContent = usuario.email || '';
    }

    // Nome exibido no menu da conta.
    const accountName = document.getElementById('account-name-display');

    if (accountName) {
      accountName.textContent = (usuario.nome || 'Vitoria')
        .trim()
        .split(/\s+/)[0];
    }

    // Iniciais do ícone da conta.
    const accountIcon = document.querySelector('.account-icon');

    if (accountIcon) {
      let initials = accountIcon.querySelector('.account-initials');

      if (!initials) {
        initials = document.createElement('span');
        initials.className = 'account-initials';
        accountIcon.appendChild(initials);
      }

      initials.textContent = obterIniciais(usuario.nome);
    }
  }

  // 1. Carrega os dados salvos no localStorage.
  const usuarioSalvo = localStorage.getItem('usuario');

  if (usuarioSalvo) {
    try {
      const usuario = JSON.parse(usuarioSalvo);
      preencherCampos(usuario.usuario || usuario);
    } catch (erro) {
      console.error('Erro ao ler cache do usuário:', erro);
    }
  }

  // 2. Busca os dados atualizados do usuário na API.
  try {
    const resposta = await AgilCertAPI.request('usuarios/me');
    const usuarioAtualizado = resposta.usuario || resposta;

    preencherCampos(usuarioAtualizado);

    localStorage.setItem('usuario', JSON.stringify(usuarioAtualizado));

    if (profileStatus) {
      profileStatus.textContent = '';
    }

  } catch (erro) {
    console.error('Erro ao buscar perfil:', erro);

    if (!usuarioOriginal && profileStatus) {
      profileStatus.textContent = 'Erro ao carregar dados do usuário.';
      profileStatus.style.color = '#e74c3c';
    }
  }

  // Atualiza a barra de progresso ao abrir o perfil.
  await atualizarProgressoJornada();

  // 3. Verifica alterações no nome e no e-mail.
  function checarMudancas() {
    if (!usuarioOriginal || !profileFullname || !profileEmail) return;

    const nomeMudou =
      profileFullname.value.trim() !== (usuarioOriginal.nome || '');

    const emailMudou =
      profileEmail.value.trim().toLowerCase() !==
      (usuarioOriginal.email || '').toLowerCase();

    if (saveProfileBtn) {
      saveProfileBtn.disabled = !(nomeMudou || emailMudou);
    }
  }

  profileFullname?.addEventListener('input', checarMudancas);
  profileEmail?.addEventListener('input', checarMudancas);

  // 4. Salva alterações de nome e e-mail.
  profileForm?.addEventListener('submit', async (evento) => {
    evento.preventDefault();

    if (profileStatus) {
      profileStatus.textContent = '';
    }

    try {
      if (saveProfileBtn) {
        saveProfileBtn.disabled = true;
      }

      const resposta = await AgilCertAPI.request('usuarios/me', {
        method: 'PATCH',
        body: {
          nome: profileFullname.value.trim(),
          email: profileEmail.value.trim()
        }
      });

      const usuarioAtualizado = resposta.usuario || resposta;

      preencherCampos(usuarioAtualizado);

      localStorage.setItem('usuario', JSON.stringify(usuarioAtualizado));

      if (profileStatus) {
        profileStatus.textContent = 'Perfil atualizado com sucesso!';
        profileStatus.style.color = '#2ecc71';
      }

    } catch (erro) {
      if (profileStatus) {
        profileStatus.textContent =
          erro.message || 'Erro ao salvar alterações.';
        profileStatus.style.color = '#e74c3c';
      }

      if (saveProfileBtn) {
        saveProfileBtn.disabled = false;
      }
    }
  });

  // 5. Valida os campos de senha.
  function checarValidacaoSenha() {
    const atual = currentPasswordInput?.value || '';
    const nova = newPasswordInput?.value || '';
    const confirma = confirmPasswordInput?.value || '';

    if (savePasswordBtn) {
      savePasswordBtn.disabled = !(
        atual &&
        nova.length >= 8 &&
        nova === confirma
      );
    }
  }

  currentPasswordInput?.addEventListener('input', checarValidacaoSenha);
  newPasswordInput?.addEventListener('input', checarValidacaoSenha);
  confirmPasswordInput?.addEventListener('input', checarValidacaoSenha);

  // 6. Altera a senha.
  passwordForm?.addEventListener('submit', async (evento) => {
    evento.preventDefault();

    if (passwordStatus) {
      passwordStatus.textContent = '';
    }

    if (newPasswordInput.value !== confirmPasswordInput.value) {
      if (passwordStatus) {
        passwordStatus.textContent =
          'A nova senha e a confirmação não coincidem.';
        passwordStatus.style.color = '#e74c3c';
      }

      return;
    }

    try {
      if (savePasswordBtn) {
        savePasswordBtn.disabled = true;
      }

      await AgilCertAPI.request('usuarios/me/senha', {
        method: 'PATCH',
        body: {
          senhaAtual: currentPasswordInput.value,
          novaSenha: newPasswordInput.value
        }
      });

      if (passwordStatus) {
        passwordStatus.textContent =
          'Senha alterada. Entre novamente com a nova senha.';
        passwordStatus.style.color = '#2ecc71';
      }

      passwordForm.reset();

      localStorage.removeItem('token');
      localStorage.removeItem('usuario');

      window.location.assign('login.html');

    } catch (erro) {
      if (passwordStatus) {
        passwordStatus.textContent =
          erro.message || 'Erro ao alterar senha.';
        passwordStatus.style.color = '#e74c3c';
      }

      if (savePasswordBtn) {
        savePasswordBtn.disabled = false;
      }
    }
  });

  // 7. Botão de logout.
  logoutBtn?.addEventListener('click', async () => {
    logoutBtn.disabled = true;

    try {
      await AgilCertAPI.logout();

    } catch (erro) {
      if (profileStatus) {
        profileStatus.textContent = erro.message;
      }

      logoutBtn.disabled = false;
    }
  });

  // 8. Menu da conta.
  const accountContainer = document.getElementById('account-container');
  const accountToggle = document.getElementById('account-toggle');

  if (accountToggle && accountContainer) {
    accountToggle.addEventListener('click', (evento) => {
      evento.stopPropagation();

      accountContainer.classList.toggle('active');

      accountToggle.setAttribute(
        'aria-expanded',
        accountContainer.classList.contains('active')
      );
    });

    document.addEventListener('click', (evento) => {
      if (!accountContainer.contains(evento.target)) {
        accountContainer.classList.remove('active');
        accountToggle.setAttribute('aria-expanded', 'false');
      }
    });
  }

});
