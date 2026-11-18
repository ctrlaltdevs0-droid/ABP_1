(() => {
  const el = id => document.getElementById(id);
  const parametros = new URLSearchParams(window.location.search);
  const codigo = parametros.get('codigo');
  const api = window.AgilCertAPI;
  const informar = texto => { el('certificado-mensagem').textContent = texto; };
  el('btn-baixar').disabled = true;
  el('btn-baixar').hidden = true;
  el('container-certificado').hidden = true;
  el('btn-baixar').addEventListener('click', () => window.print());
  el('sair').addEventListener('click', async () => {
    try { await api.logout(); } catch (erro) { informar(erro.message); }
  });
  el('profileTrigger').addEventListener('click', () => {
    const aberto = el('profileMenu').classList.toggle('open');
    el('profileTrigger').setAttribute('aria-expanded', String(aberto));
  });
  document.querySelector('.nav-toggle').addEventListener('click', event => {
    const aberto = event.currentTarget.getAttribute('aria-expanded') !== 'true';
    event.currentTarget.setAttribute('aria-expanded', String(aberto));
    el('main-nav').classList.toggle('open', aberto);
  });
  async function carregar() {
    informar('Consultando certificado...');
    try {
      let certificado;
      let cpfMascarado = '';
      if (codigo) {
        if (!/^[a-f0-9-]{36}$/i.test(codigo)) throw new Error('Código de validação inválido.');
        const dados = await api.request(`certificados/validar/${encodeURIComponent(codigo)}`, { authenticated: false });
        certificado = dados.certificado;
        el('page-title').textContent = 'Certificado válido';
        el('authButtons').style.display = 'flex';
      } else {
        if (!localStorage.getItem('token')) { window.location.replace('login.html'); return; }
        const perfil = await api.request('usuarios/me');
        const usuario = perfil.usuario || perfil;
        const cpf = String(usuario.cpf || '').replace(/\D/g, '');
        if (cpf.length === 11) cpfMascarado = `${cpf.slice(0, 3)}.***.***-${cpf.slice(-2)}`;
        el('userName').textContent = usuario.nome;
        el('dropdownUserName').textContent = usuario.nome;
        el('profileMenu').style.display = 'flex';
        let id = parametros.get('id');
        const tentativa = parametros.get('tentativa');
        if (parametros.has('id') && !/^[1-9]\d*$/.test(id || '')) throw new Error('Identificador do certificado inválido.');
        if (!id && parametros.has('tentativa') && !/^[1-9]\d*$/.test(tentativa || '')) throw new Error('Identificador da tentativa inválido.');
        if (!id) {
          const lista = await api.request(`usuarios/${usuario.id}/certificados`);
          // A API ordena por emissão decrescente. Sem parâmetros, abre o mais recente válido.
          const disponivel = lista.find(item => item.ativo === true && !item.revogado_em &&
            (!tentativa || String(item.tentativas_idtentativas) === tentativa));
          id = disponivel?.idcertificados;
          if (!id && tentativa) {
            const emitido = await api.request(`certificados/tentativas/${tentativa}`, { method: 'POST', body: {} });
            id = emitido.idcertificados;
          }
          if (!id) throw new Error(tentativa
            ? 'Esta tentativa não possui um certificado ativo. Consulte o resultado no histórico.'
            : 'Você ainda não possui um certificado ativo. Conclua a certificação com aprovação para emitir o seu.');
        }
        if (!/^[1-9]\d*$/.test(String(id || ''))) throw new Error('Certificado não encontrado. Acesse pelo resultado da prova ou pelo histórico.');
        certificado = await api.request(`certificados/${id}`);
      }
      el('nomeAluno').textContent = certificado.usuarios?.nome || '';
      el('certificado-aluno').textContent = certificado.usuarios?.nome || '';
      el('nomeAluno').classList.toggle('nome-extenso', (certificado.usuarios?.nome || '').length > 40);
      el('certificado-cpf').textContent = cpfMascarado ? `CPF: ${cpfMascarado}` : '';
      el('certificado-cpf').hidden = !cpfMascarado;
      el('certificado-percentual').textContent = `${Number(certificado.percentual).toLocaleString('pt-BR')}%`;
      el('certificado-data').textContent = new Date(certificado.emitido_em).toLocaleDateString('pt-BR');
      const basePublica = window.AGILCERT_PUBLIC_BASE_URL?.trim();
      const validacao = new URL('validar-certificado.html', basePublica ? `${basePublica.replace(/\/+$/, '')}/` : window.location.href);
      if (!['https:', 'http:'].includes(validacao.protocol)) throw new Error('Endereço público de validação inválido.');
      validacao.searchParams.set('codigo', certificado.codigo_validacao);
      el('certificado-validacao').href = validacao.href;
      el('certificado-validacao').textContent = 'Valide esse certificado através do QR Code';
      const qr = qrcode(0, 'M');
      qr.addData(validacao.href);
      qr.make();
      el('certificado-qrcode').src = `data:image/svg+xml;charset=utf-8,${encodeURIComponent(qr.createSvgTag(4, 16))}`;
      el('certificado-codigo').textContent = `Código: ${certificado.codigo_validacao}`;
      el('container-certificado').hidden = false;
      el('btn-baixar').disabled = false;
      el('btn-baixar').hidden = false;
      informar('Certificado validado. A autenticidade pode ser consultada pelo QR Code. Para baixar, escolha “Salvar como PDF” na janela de impressão.' +
        (['localhost', '127.0.0.1', '[::1]'].includes(validacao.hostname) ? ' Para leitura pelo celular, configure o endereço público do site em assets/js/config.js.' : ''));
    } catch (erro) {
      if (!codigo && !localStorage.getItem('token')) { window.location.replace('login.html'); return; }
      informar(erro.message || 'Não foi possível consultar o certificado.');
      el('certificado-acoes').hidden = false;
    }
  }
  carregar();
})();
