(() => {
  const el = id => document.getElementById(id);
  const uuid = /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/i;
  let versao = 0;
  async function validar() {
    const atual = ++versao;
    const codigo = el('codigo').value.trim();
    el('validacao-dados').hidden = true;
    el('validacao-status').textContent = '';
    if (!uuid.test(codigo)) {
      el('validacao-status').textContent = 'Informe um código de validação válido.';
      return;
    }
    el('validar').disabled = true;
    el('validacao-status').textContent = 'Consultando o registro do certificado...';
    try {
      const dados = await window.AgilCertAPI.request(`certificados/validar/${encodeURIComponent(codigo)}`, { authenticated: false });
      if (atual !== versao) return;
      if (!dados.valido || !dados.certificado) throw new Error('Certificado não encontrado ou revogado.');
      const c = dados.certificado;
      el('validacao-nome').textContent = c.usuarios?.nome || 'Nome não informado';
      el('validacao-percentual').textContent = `${Number(c.percentual).toLocaleString('pt-BR')}%`;
      const utc = /(?:Z|[+-]\d{2}:?\d{2})$/i.test(c.emitido_em) ? c.emitido_em : `${c.emitido_em}Z`;
      el('validacao-data').textContent = new Date(utc).toLocaleDateString('pt-BR', { timeZone: 'America/Sao_Paulo' });
      el('validacao-dados').hidden = false;
      el('validacao-status').textContent = 'Autenticidade confirmada. Este certificado está ativo no ÁgilCert.';
    } catch (erro) {
      if (atual === versao) el('validacao-status').textContent = erro.message || 'Não foi possível consultar a autenticidade. Tente novamente.';
    } finally {
      if (atual === versao) el('validar').disabled = false;
    }
  }
  el('validacao-form').addEventListener('submit', event => { event.preventDefault(); validar(); });
  el('codigo').addEventListener('input', () => {
    versao++;
    el('validacao-dados').hidden = true;
    el('validacao-status').textContent = '';
    el('validar').disabled = false;
  });
  el('codigo').value = new URLSearchParams(window.location.search).get('codigo') || '';
  if (el('codigo').value) validar();
})();
