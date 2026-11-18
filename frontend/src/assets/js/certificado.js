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
        const primeiroNome = usuario.nome.trim().split(/\s+/)[0];
        el('userName').textContent = primeiroNome;
        el('dropdownUserName').textContent = usuario.nome;
        el('profileMenu').style.display = 'flex';
        el('page-title').textContent = `Seu certificado, ${primeiroNome}`;
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
      const percentual = Number(certificado.percentual).toLocaleString('pt-BR', { maximumFractionDigits: 1 });
      el('nomeAluno').textContent = certificado.usuarios?.nome || '';
      el('resumo-acertos').textContent = `${certificado.score} de 12`;
      el('resumo-percentual').textContent = `${percentual}%`;
      el('certificado-historico').hidden = Boolean(codigo);
      el('certificado-desempenho').textContent = `obteve aprovação na certificação final de metodologias ágeis, com ${certificado.score} acertos em 12 questões e aproveitamento de ${percentual}%. O mínimo para aprovação é de 65%.`;
      const emissao = new Date(certificado.emitido_em);
      el('certificado-data').textContent = `Emitido em ${emissao.toLocaleDateString('pt-BR')} às ${emissao.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}`;
      const basePublica = window.AGILCERT_PUBLIC_BASE_URL?.trim();
      const validacao = new URL('validar-certificado.html', basePublica ? `${basePublica.replace(/\/+$/, '')}/` : window.location.href);
      if (!['https:', 'http:'].includes(validacao.protocol)) throw new Error('Endereço público de validação inválido.');
      validacao.searchParams.set('codigo', certificado.codigo_validacao);
      for (const id of ['certificado-validacao', 'btn-validar', 'painel-validacao']) {
        el(id).href = validacao.href;
      }
      el('painel-codigo').textContent = certificado.codigo_validacao;
      const qr = qrcode(0, 'M');
      qr.addData(validacao.href);
      qr.make();
      el('certificado-qrcode').src = `data:image/svg+xml;charset=utf-8,${encodeURIComponent(qr.createSvgTag(4, 16))}`;
      el('certificado-codigo').textContent = `Código de validação: ${certificado.codigo_validacao}`;
      el('container-certificado').hidden = false;
      el('btn-baixar').disabled = false;
      el('btn-baixar').hidden = false;
      el('btn-validar').hidden = false;
      informar(['localhost', '127.0.0.1', '[::1]'].includes(validacao.hostname)
        ? 'Para validar seu certificado, escaneie o QR code abaixo: '
        : '');
    } catch (erro) {
      if (!codigo && !localStorage.getItem('token')) { window.location.replace('login.html'); return; }
      informar(erro.message || 'Não foi possível consultar o certificado.');
      el('certificado-acoes').hidden = false;
    }
  }
  carregar();
})();
