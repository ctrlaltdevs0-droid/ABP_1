(() => {
  const el = id => document.getElementById(id);

  if (!localStorage.getItem('token')) { 
    window.location.replace('login.html'); 
    return; 
  }

  const api = window.AgilCertAPI;
  const temaParam = new URLSearchParams(window.location.search).get('tema');
  let temas = [];
  let concluidos = new Set();
  let temaAtual;

  function informar(texto) { 
    el('mensagem').textContent = texto; 
  }

  function erro(error) {
    if (!localStorage.getItem('token')) { 
      window.location.replace('login.html'); 
      return; 
    }
    informar(error.message || 'Não foi possível carregar os estudos.');
  }

  function resumo() {
    const total = temas.filter(t => concluidos.has(t.idtemas)).length;
    el('resumo').textContent = `${total} de ${temas.length} temas concluídos`;
    el('progresso').max = temas.length || 12;
    el('progresso').value = total;
    el('progresso').textContent = `${total} de ${temas.length}`;
  }

  function listar() {
    const busca = el('busca').value.toLocaleLowerCase('pt-BR');
    const visiveis = temas.filter(t => t.nome.toLocaleLowerCase('pt-BR').includes(busca));
    el('temas').replaceChildren();

    for (const tema of visiveis) {
      const card = document.createElement('section');
      card.className = 'study-card';

      const estado = document.createElement('span');
      const feito = concluidos.has(tema.idtemas);
      estado.className = `study-state${feito ? ' done' : ''}`;
      estado.textContent = feito ? '✓ Concluído' : 'Pendente';

      const titulo = document.createElement('h2');
      titulo.textContent = `${tema.ordem}. ${tema.nome}`;

      const descricao = document.createElement('p');
      descricao.textContent = tema.descricao || '';

      const link = document.createElement('a');
      link.href = `estudos.html?tema=${encodeURIComponent(tema.idtemas)}`;
      link.textContent = feito ? 'Revisar tema →' : 'Estudar →';

      card.append(estado, titulo, descricao, link);
      el('temas').append(card);
    }

    informar(visiveis.length ? '' : 'Nenhum tema encontrado.');
  }

  async function carregar() {
    el('tentar').hidden = true;
    el('concluir').disabled = true;
    el('lista-estudos').hidden = true;
    el('conteudo').hidden = true;
    informar('Carregando estudos…');

    try {
      // 1. Carrega a lista de temas (se falhar, cai no catch geral)
      temas = await api.request('temas');

      // 2. Carrega o progresso (se falhar/503, não trava os temas)
      let progresso = [];
      try {
        progresso = await api.request('estudos/progresso');
      } catch (err) {
        console.warn('Não foi possível carregar o progresso do usuário:', err);
      }

      concluidos = new Set((progresso || []).map(p => p.temas_idtemas));
      resumo();

      if (temaParam === null) {
        el('lista-estudos').hidden = false;
        listar();
        return;
      }

      temaAtual = temas.find(t => String(t.idtemas) === temaParam);
      if (!temaAtual) throw new Error('Tema não encontrado. Volte à área de estudos.');

      const conteudos = await api.request(`temas/${temaAtual.idtemas}/conteudos`);
      el('titulo-tema').textContent = temaAtual.nome;
      el('texto-tema').replaceChildren();

      for (const item of conteudos) {
        const titulo = document.createElement('h3');
        titulo.textContent = item.titulo || temaAtual.nome;

        // Suporte para HTML (tabelas e formatações)
        const texto = document.createElement('div');
        texto.className = 'bloco-conteudo';
        texto.innerHTML = item.descricao || '';

        el('texto-tema').append(titulo, texto);

        // Suporte a URLs de imagem ou links complementares
        try {
          const url = new URL(item.recurso_url);
          if (url.protocol === 'https:') {
            if (/\.(png|jpg|jpeg|webp|gif)($|\?)/i.test(url.pathname)) {
              const img = document.createElement('img');
              img.src = url.href;
              img.alt = item.titulo || 'Imagem do conteúdo';
              img.className = 'imagem-conteudo';
              el('texto-tema').append(img);
            } else {
              const link = document.createElement('a');
              link.href = url.href;
              link.target = '_blank';
              link.rel = 'noopener noreferrer';
              link.textContent = 'Consultar recurso complementar';
              el('texto-tema').append(link);
            }
          }
        } catch { /* Recurso complementar é opcional. */ }
      }

      el('conteudo').hidden = false;
      const feito = concluidos.has(temaAtual.idtemas);
      el('concluir').textContent = feito ? 'Tema concluído ✓' : 'Marcar tema como concluído';
      el('concluir').disabled = feito || !conteudos.length;
      informar(conteudos.length ? '' : 'O material deste tema ainda não está disponível.');

    } catch (error) {
      erro(error);
      el('tentar').hidden = false;
    }
  }

  el('concluir').addEventListener('click', async () => {
    el('concluir').disabled = true;
    informar('Salvando progresso…');
    try {
      await api.request(`temas/${temaAtual.idtemas}/conclusao`, { method: 'PUT', body: {} });
      concluidos.add(temaAtual.idtemas);
      resumo();
      el('concluir').textContent = 'Tema concluído ✓';
      informar('Progresso salvo. Você pode continuar os estudos depois.');
    } catch (error) {
      erro(error);
      el('concluir').disabled = false;
    }
  });

  el('busca').addEventListener('input', listar);
  el('tentar').addEventListener('click', carregar);
  el('sair').addEventListener('click', async () => {
    el('sair').disabled = true;
    try {
      await api.logout();
    } catch (error) {
      erro(error);
      el('sair').disabled = false;
    }
  });

  carregar();
})();