(() => {
  const el = id => document.getElementById(id);

  if (!localStorage.getItem('token')) {
    window.location.replace('login.html');
    return;
  }

  const api = window.AgilCertAPI;

  function informar(texto) {
    el('mensagem').textContent = texto;
  }

  function erro(error) {
    if (!localStorage.getItem('token')) {
      window.location.replace('login.html');
      return;
    }

    informar(error.message || 'Não foi possível carregar o histórico.');
  }

  function formatarData(valor) {
    return valor ? new Date(valor).toLocaleString('pt-BR') : '—';
  }

  function celula(texto, classe) {
    const td = document.createElement('td');
    td.textContent = texto;
    if (classe) td.className = classe;
    return td;
  }

  // Mostra as tentativas do candidato em uma tabela.
  function listar(tentativas) {
    el('tentativas').replaceChildren();

    for (const tentativa of tentativas) {
      const linha = document.createElement('tr');
      const finalizada = tentativa.status !== 'EM_ANDAMENTO';

      linha.append(
        celula(formatarData(tentativa.iniciado_em)),
        celula(finalizada ? `${tentativa.acertos} de 12` : '—'),
        celula(finalizada ? `${Number(tentativa.percentual).toFixed(1)}%` : '—'),
        finalizada
          ? celula(tentativa.aprovado ? 'Aprovado' : 'Reprovado', tentativa.aprovado ? 'aprovado' : 'reprovado')
          : celula('Em andamento'),
      );

      const acoes = document.createElement('td');
      if (finalizada) {
        const botao = document.createElement('button');
        botao.type = 'button';
        botao.textContent = 'Ver questões';
        botao.addEventListener('click', () => detalhar(tentativa.idtentativas));
        acoes.append(botao);
      }
      linha.append(acoes);

      el('tentativas').append(linha);
    }

    el('lista').hidden = false;
  }

  // Mostra as 12 questões de uma tentativa.
  async function detalhar(id) {
    try {
      const dados = await api.request(`historico/${id}`);
      el('questoes').replaceChildren();

      for (const questao of dados.questoes) {
        const item = document.createElement('li');

        const tema = document.createElement('strong');
        tema.textContent = questao.tema;

        const enunciado = document.createElement('p');
        enunciado.textContent = questao.enunciado;

        const respostas = document.createElement('p');
        respostas.textContent =
          `Sua resposta: ${questao.resposta_escolhida ?? 'sem resposta'} · ` +
          `Resposta correta: ${questao.resposta_correta ?? '—'} · ` +
          (questao.acertou ? 'Acertou' : 'Errou');
        respostas.className = questao.acertou ? 'aprovado' : 'reprovado';

        const data = document.createElement('p');
        data.textContent = `Respondida em: ${formatarData(questao.respondido_em)}`;

        item.append(tema, enunciado, respostas, data);
        el('questoes').append(item);
      }

      el('detalhe').hidden = false;
      el('detalhe').scrollIntoView({ behavior: 'smooth' });
    } catch (error) {
      erro(error);
    }
  }

  async function carregar() {
    try {
      const tentativas = await api.request('historico');

      if (!tentativas.length) {
        informar('Você ainda não fez nenhuma prova.');
        return;
      }

      informar('');
      listar(tentativas);
    } catch (error) {
      erro(error);
    }
  }

  // Encerra a sessão.
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
