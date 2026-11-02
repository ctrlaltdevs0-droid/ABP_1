(() => {
  const el = id => document.getElementById(`prova-${id}`);
  const api = window.AgilCertAPI;
  if (!localStorage.getItem('token')) { window.location.replace('login.html'); return; }
  let sessao = crypto.randomUUID();
  let tentativa = null;
  let resumo = null;
  let questao = null;
  let prazo = 0;
  let ocupada = false;
  let bloqueada = false;
  let geracao = 0;
  let encerrada = false;
  const mensagem = texto => { el('mensagem').textContent = texto; };
  const botao = (nome, mostrar) => { el(nome).hidden = !mostrar; };
  function renderizar() {
    const ativa = Boolean(questao) && !bloqueada;
    el('questao').hidden = !ativa;
    el('alternativas').disabled = ocupada || bloqueada;
    el('responder').disabled = ocupada || bloqueada;
    el('progresso').textContent = resumo?.tentativa ? `${resumo.respondidas} de ${resumo.total_questoes} questões encerradas` : '';
    botao('iniciar', !tentativa && !encerrada && !bloqueada);
    botao('retomar', Boolean(tentativa) && resumo?.tentativa?.status === 'INTERROMPIDA' && !bloqueada && !encerrada);
    botao('proxima', Boolean(tentativa) && !ativa && resumo?.tentativa?.status === 'EM_ANDAMENTO' && resumo?.pendentes > 0 && !bloqueada && !encerrada);
    botao('pausar', Boolean(tentativa) && !ativa && resumo?.tentativa?.status === 'EM_ANDAMENTO' && resumo?.pendentes > 0 && !bloqueada && !encerrada);
    botao('finalizar', Boolean(tentativa) && resumo?.pendentes === 0 && !ativa && !bloqueada && !encerrada);
    botao('recuperar', bloqueada);
    for (const b of el('acoes').querySelectorAll('button')) b.disabled = ocupada || !navigator.onLine;
  }
  async function chamar(acao, body = {}, opcoes = {}) {
    const leitura = ['estado', 'proxima-questao', 'atual'].includes(acao);
    const path = acao === 'iniciar' ? 'tentativas' : acao === 'atual' ? 'tentativas/atual' : `tentativas/${tentativa}${acao === 'estado' ? '' : `/${acao}`}`;
    return api.request(path, {
      method: leitura ? 'GET' : 'POST', headers: { 'X-Sessao-Prova': sessao },
      ...(leitura ? {} : { body: { ...body, sessao } }), ...opcoes,
    });
  }
  function aplicar(dados) {
    resumo = dados;
    tentativa = dados.tentativa?.idtentativas ?? tentativa;
    renderizar();
  }
  function marcarInterrupcao(motivo) {
    if (!questao || !tentativa) return null;
    return { sessao, questoes_idquestoes: questao.idquestoes, motivo };
  }
  async function executar(acao) {
    if (ocupada) return;
    ocupada = true;
    const versao = geracao;
    renderizar();
    try { await acao(versao); }
    catch (error) {
      if (!localStorage.getItem('token')) { window.location.replace('login.html'); return; }
      bloqueada = true;
      mensagem(`${error.message} Verifique a conexão para continuar com o estado salvo no servidor.`);
    } finally { ocupada = false; renderizar(); }
  }
  async function retomar() {
    // Uma nova sessão invalida requisições atrasadas da página anterior.
    sessao = crypto.randomUUID();
    const dados = await chamar('retomar');
    questao = null;
    bloqueada = false;
    aplicar(dados);
    mensagem('Certificação retomada. Continue pelo próximo tema não respondido.');
  }
  el('iniciar').addEventListener('click', () => executar(async versao => {
    const dados = await chamar('iniciar');
    if (versao !== geracao) return;
    aplicar(dados);
    mensagem('Tudo pronto. O prazo começa quando você abrir a próxima questão.');
  }));
  el('retomar').addEventListener('click', () => executar(retomar));
  el('recuperar').addEventListener('click', () => executar(async () => {
    if (!tentativa) {
      const dados = await chamar('atual');
      aplicar(dados);
      bloqueada = false;
      if (!tentativa) { mensagem('Conexão recuperada. Você pode iniciar a certificação.'); return; }
    }
    await retomar();
  }));
  el('proxima').addEventListener('click', () => executar(async versao => {
    const dados = await chamar('proxima-questao');
    if (versao !== geracao) return;
    if (dados.concluida) { aplicar(await chamar('estado')); return; }
    questao = dados.questao;
    prazo = performance.now() + Math.max(0, Date.parse(dados.expira_em) - Date.parse(dados.agora));
    el('enunciado').textContent = `${dados.ordem}. ${questao.enunciado}`;
    const img = el('imagem');
    img.hidden = true;
    if (questao.imagem_url) {
      const url = new URL(questao.imagem_url, location.href);
      if (url.protocol === 'https:' || url.origin === location.origin) {
        img.src = url.href; img.hidden = false;
        img.onerror = () => { img.hidden = true; };
      }
    }
    const fieldset = el('alternativas');
    fieldset.replaceChildren();
    const legenda = document.createElement('legend'); legenda.textContent = 'Escolha uma alternativa'; fieldset.append(legenda);
    for (const alt of dados.alternativas) {
      const label = document.createElement('label');
      const input = document.createElement('input');
      input.type = 'radio'; input.name = 'alternativa'; input.value = alt.idalternativas; input.required = true;
      label.append(input, document.createTextNode(`${alt.letra}) ${alt.texto}`)); fieldset.append(label);
    }
    mensagem('Escolha uma alternativa e confirme sua resposta.');
    renderizar();
    el('enunciado').tabIndex = -1; el('enunciado').focus();
    atualizarTempo();
  }));
  el('form').addEventListener('submit', event => {
    event.preventDefault();
    if (!questao || bloqueada) return;
    const alternativa = el('alternativas').querySelector('input:checked');
    if (!alternativa) return;
    executar(async versao => {
      await chamar('respostas', { questoes_idquestoes: questao.idquestoes, alternativas_idalternativas: Number(alternativa.value) });
      if (versao !== geracao) return;
      questao = null;
      aplicar(await chamar('estado'));
      mensagem('Resposta salva. Deseja continuar agora ou depois?');
    });
  });
  el('pausar').addEventListener('click', () => executar(async () => {
    aplicar(await chamar('pausar'));
    mensagem('Progresso salvo. Você pode sair e retomar a certificação depois.');
  }));
  el('finalizar').addEventListener('click', () => executar(async () => {
    const dados = await chamar('finalizar');
    encerrada = true;
    el('resultado').hidden = false;
    el('nota').textContent = `${dados.resultado.acertos} de ${dados.resultado.total} acertos (${dados.resultado.percentual}%). ${dados.resultado.aprovado ? 'Aprovado!' : 'Nota mínima não atingida.'}`;
    mensagem('Certificação finalizada.');
  }));
  function atualizarTempo() {
    if (!questao || bloqueada) return;
    const restante = Math.max(0, Math.ceil((prazo - performance.now()) / 1000));
    el('tempo').textContent = `Tempo restante: ${Math.floor(restante / 60)}:${String(restante % 60).padStart(2, '0')}`;
    if (!restante && !ocupada) executar(async () => {
      const dados = await chamar('estado');
      aplicar(dados);
      if (dados.questao_aberta) {
        prazo = performance.now() + Math.max(0, Date.parse(dados.questao_aberta.expira_em) - Date.parse(dados.agora));
      } else {
        questao = null;
        mensagem('Tempo esgotado. A questão foi encerrada como incorreta. Deseja continuar?');
      }
    });
  }
  setInterval(atualizarTempo, 250);
  setInterval(() => {
    if (!questao || ocupada || bloqueada || !navigator.onLine) return;
    executar(async versao => {
      const dados = await chamar('presenca');
      if (versao !== geracao) return;
      aplicar(dados);
      if (dados.tentativa.status !== 'EM_ANDAMENTO' || !dados.questao_aberta) {
        questao = null;
        mensagem('A questão foi encerrada. Retome ou continue pelo próximo tema.');
      }
    });
  }, 10000);
  window.addEventListener('offline', () => {
    geracao++;
    const evento = marcarInterrupcao('CONEXAO');
    bloqueada = true;
    mensagem('Conexão perdida. A questão aberta será encerrada. Reconecte para retomar pelo próximo tema.');
    renderizar();
    if (evento) chamar('interromper', evento, { keepalive: true }).catch(() => {});
  });
  window.addEventListener('online', () => {
    mensagem('Conexão disponível. Clique em verificar conexão e retomar.'); renderizar();
  });
  window.addEventListener('pagehide', () => {
    const evento = marcarInterrupcao('FECHAMENTO');
    if (evento) chamar('interromper', evento, { keepalive: true }).catch(() => {});
  });
  window.addEventListener('pageshow', event => { if (event.persisted) window.location.reload(); });
  executar(async () => {
    const dados = await chamar('atual');
    aplicar(dados);
    if (dados.tentativa) {
      // Não abre questão nem inicia cronômetro até o candidato escolher continuar.
      resumo.tentativa.status = 'INTERROMPIDA';
      mensagem('Encontramos sua tentativa. Retome para continuar pelo próximo tema.');
    } else mensagem('Quando estiver pronto, inicie sua certificação.');
  });
})();
