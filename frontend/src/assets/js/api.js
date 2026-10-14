(() => {
  function baseUrl() {
    const configured = window.AGILCERT_API_BASE_URL?.trim();
    if (configured) return configured.replace(/\/+$/, '');
    if (!/^https?:$/.test(window.location.protocol)) {
      throw new Error('Abra o site pelo endereço do backend, por exemplo http://localhost:3000.');
    }
    return `${window.location.origin}/api`;
  }

  async function request(path, { method = 'GET', body, authenticated = true } = {}) {
    const headers = { Accept: 'application/json' };
    if (body !== undefined) headers['Content-Type'] = 'application/json';
    if (authenticated) {
      const token = localStorage.getItem('token');
      if (token) headers.Authorization = `Bearer ${token}`;
    }
    let response;
    try {
      response = await fetch(`${baseUrl()}/${path.replace(/^\/+/, '')}`, {
        method, headers,
        ...(body === undefined ? {} : { body: JSON.stringify(body) }),
        signal: AbortSignal.timeout(15000),
      });
    } catch (error) {
      if (error.name === 'TimeoutError') throw new Error('O servidor demorou para responder. Tente novamente.');
      if (!/^https?:$/.test(window.location.protocol) && !window.AGILCERT_API_BASE_URL) throw error;
      throw new Error('Não foi possível conectar à API. Confira se o backend está rodando e o endereço configurado.');
    }
    if (response.status === 204) return null;
    if (!response.headers.get('content-type')?.includes('application/json')) {
      throw new Error('O endereço configurado não retornou JSON da API. Confira assets/js/config.js.');
    }
    const data = await response.json();
    if (!response.ok) {
      if (authenticated && response.status === 401) localStorage.removeItem('token');
      throw new Error(typeof data.erro === 'string' ? data.erro : data.erro?.mensagem || 'Não foi possível concluir a solicitação.');
    }
    return data;
  }
  window.AgilCertAPI = { request };
})();
