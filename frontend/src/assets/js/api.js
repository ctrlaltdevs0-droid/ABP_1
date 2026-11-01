
(() => {
  // Retorna a URL base da API.
  function baseUrl() {
    const configured = window.AGILCERT_API_BASE_URL?.trim();

    // Usa a URL definida no config.js, quando existir.
    if (configured) {
      return configured.replace(/\/+$/, '');
    }

    // Impede requisições quando o HTML é aberto via file://.
    if (!/^https?:$/.test(window.location.protocol)) {
      throw new Error(
        'Abra o site pelo endereço do backend, por exemplo http://localhost:3000/api.'
      );
    }

    // Usa /api na mesma origem do frontend.
    return `${window.location.origin}/api`;
  }

  // Executa requisições HTTP para o backend.
  async function request(
    path,
    { method = 'GET', body, authenticated = true } = {}
  ) {
    const headers = {
      Accept: 'application/json',
    };

    // Define o tipo de conteúdo quando houver corpo.
    if (body !== undefined) {
      headers['Content-Type'] = 'application/json';
    }

    // Adiciona o token JWT quando necessário.
    if (authenticated) {
      const token = localStorage.getItem('token');

      if (token) {
        headers.Authorization = `Bearer ${token}`;
      }
    }

    let response;

    try {
      response = await fetch(
        `${baseUrl()}/${path.replace(/^\/+/, '')}`,
        {
          method,
          headers,
          ...(body === undefined
            ? {}
            : { body: JSON.stringify(body) }),
          signal: AbortSignal.timeout(15000),
        }
      );
    } catch (error) {
      // Tratamento de tempo limite.
      if (error.name === 'TimeoutError') {
        throw new Error(
          'O servidor demorou para responder. Tente novamente.'
        );
      }

      // Preserva erros de configuração ao abrir via file://.
      if (
        !/^https?:$/.test(window.location.protocol) &&
        !window.AGILCERT_API_BASE_URL
      ) {
        throw error;
      }

      throw new Error(
        'Não foi possível conectar à API. Confira se o backend está rodando e o endereço configurado.'
      );
    }

    // Resposta sem conteúdo.
    if (response.status === 204) {
      return null;
    }

    // Verifica se a resposta é JSON.
    if (
      !response.headers
        .get('content-type')
        ?.includes('application/json')
    ) {
      throw new Error(
        'O endereço configurado não retornou JSON da API. Confira assets/js/config.js.'
      );
    }

    const data = await response.json();

    // Tratamento dos erros retornados pelo backend.
    if (!response.ok) {
      // Remove o token quando a autenticação expirar.
      if (authenticated && response.status === 401) {
        localStorage.removeItem('token');
      }

      throw new Error(
        typeof data.erro === 'string'
          ? data.erro
          : data.erro?.mensagem ||
            'Não foi possível concluir a solicitação.'
      );
    }

    return data;
  }

  // Disponibiliza a função para outras páginas.
  async function logout() {
    if (localStorage.getItem('token')) {
      try { await request('login/sair', { method: 'POST', body: {} }); }
      catch (error) {
        if (localStorage.getItem('token')) throw error;
      }
    }
    localStorage.removeItem('token');
    localStorage.removeItem('usuario');
    window.location.assign('login.html');
  }
  window.AgilCertAPI = { request, logout };
})();