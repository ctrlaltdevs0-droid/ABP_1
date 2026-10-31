
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

  let conteudosAtuais = [];
  let questoesAtuais = [];
  let respostasPorQuestao = new Map();
  let acertosTema = 0;

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
    const total = temas.filter(
      tema => concluidos.has(Number(tema.idtemas))
    ).length;

    el('resumo').textContent =
      `${total} de ${temas.length} temas concluídos`;

    el('progresso').max = temas.length || 12;
    el('progresso').value = total;
    el('progresso').textContent = `${total} de ${temas.length}`;
  }

  function listar() {
    const busca = el('busca').value.toLocaleLowerCase('pt-BR');

    const visiveis = temas.filter(
      tema => tema.nome.toLocaleLowerCase('pt-BR').includes(busca)
    );

    el('temas').replaceChildren();

    for (const tema of visiveis) {
      const card = document.createElement('section');
      card.className = 'study-card';

      const estado = document.createElement('span');
      const feito = concluidos.has(Number(tema.idtemas));

      estado.className = `study-state${feito ? ' done' : ''}`;
      estado.textContent = feito ? '✓ Concluído' : 'Pendente';

      const titulo = document.createElement('h2');
      titulo.textContent = `${tema.ordem}. ${tema.nome}`;

      const descricao = document.createElement('p');
      descricao.textContent = tema.descricao || '';

      const link = document.createElement('a');
      link.href =
        `estudos.html?tema=${encodeURIComponent(tema.idtemas)}`;

      link.textContent = feito ? 'Revisar tema →' : 'Estudar →';

      card.append(estado, titulo, descricao, link);
      el('temas').append(card);
    }

    informar(visiveis.length ? '' : 'Nenhum tema encontrado.');
  }

  // Conta os acertos das respostas carregadas do banco.
  function calcularAcertos() {
    acertosTema = [...respostasPorQuestao.values()].filter(
      resposta => resposta.acertou === true
    ).length;

    atualizarProgressoAcertos();
  }

  // Atualiza o contador e os botões do quiz.
  function atualizarProgressoAcertos() {
    const progresso = el('acertos-tema');
    const botaoConcluir = el('concluir');
    const botaoReiniciar = el('tentar-quiz');

    if (progresso) {
      progresso.textContent =
        `${acertosTema} de 3 acertos necessários para concluir o tema.`;
    }

    const feito = temaAtual &&
      concluidos.has(Number(temaAtual.idtemas));

    if (botaoConcluir) {
      botaoConcluir.textContent = feito
        ? 'Tema concluído ✓'
        : 'Marcar tema como concluído';

      botaoConcluir.disabled =
        !temaAtual ||
        feito ||
        conteudosAtuais.length === 0 ||
        acertosTema < 3;
    }

    if (botaoReiniciar) {
      const todasRespondidas =
        questoesAtuais.length > 0 &&
        questoesAtuais.every(questao =>
          respostasPorQuestao.has(Number(questao.idquestoes))
        );

      botaoReiniciar.hidden =
        !todasRespondidas ||
        acertosTema >= 3 ||
        Boolean(feito);

      if (!botaoReiniciar.disabled) {
        botaoReiniciar.textContent = 'Tentar novamente';
      }
    }
  }

  // Reinicia todas as respostas do aluno somente neste tema.
  async function reiniciarQuiz() {
    const botaoReiniciar = el('tentar-quiz');

    if (!temaAtual || !botaoReiniciar) return;

    const feito = concluidos.has(Number(temaAtual.idtemas));

    if (feito) {
      informar('Este tema já foi concluído e não pode ser reiniciado.');
      return;
    }

    if (acertosTema >= 3) {
      informar('Você já alcançou 3 acertos. Marque o tema como concluído.');
      return;
    }

    const confirmar = window.confirm(
      'Deseja tentar novamente? Todas as respostas anteriores deste tema serão apagadas.'
    );

    if (!confirmar) return;

    botaoReiniciar.disabled = true;
    informar('Reiniciando quiz…');

    try {
      const resultado = await api.request(
        `temas/${temaAtual.idtemas}/respostas`,
        {
          method: 'DELETE'
        }
      );

      informar(
        resultado.mensagem ||
        'Quiz reiniciado! Você pode responder novamente.'
      );

      // Recarrega as questões e confirma o estado atual no banco.
      await carregar();
    } catch (error) {
      erro(error);
      botaoReiniciar.disabled = false;
    }
  }

  async function carregar() {
    el('tentar').hidden = true;
    el('concluir').disabled = true;
    el('lista-estudos').hidden = true;
    el('conteudo').hidden = true;

    informar('Carregando estudos…');

    try {
      // 1. Carrega a lista de temas.
      temas = await api.request('temas');

      // 2. Carrega o progresso do aluno.
      let progresso = [];

      try {
        progresso = await api.request('estudos/progresso');
      } catch (err) {
        console.warn(
          'Não foi possível carregar o progresso do usuário:',
          err
        );
      }

      concluidos = new Set(
        (progresso || []).map(
          item => Number(item.temas_idtemas)
        )
      );

      resumo();

      // Sem tema na URL, mostra a lista de estudos.
      if (temaParam === null) {
        el('lista-estudos').hidden = false;
        listar();
        return;
      }

      temaAtual = temas.find(
        tema => String(tema.idtemas) === temaParam
      );

      if (!temaAtual) {
        throw new Error(
          'Tema não encontrado. Volte à área de estudos.'
        );
      }

      // Limpa os dados locais antes de carregar o tema.
      conteudosAtuais = [];
      questoesAtuais = [];
      respostasPorQuestao = new Map();
      acertosTema = 0;

      // 3. Carrega os conteúdos.
      conteudosAtuais = await api.request(
        `temas/${temaAtual.idtemas}/conteudos`
      );

      // 4. Carrega as questões.
      try {
        questoesAtuais = await api.request(
          `temas/${temaAtual.idtemas}/questoes`
        );
      } catch (err) {
        console.warn(
          'Não foi possível carregar as questões deste tema:',
          err
        );
      }

      // 5. Carrega as respostas anteriores.
      try {
        const respostasSalvas = await api.request(
          `temas/${temaAtual.idtemas}/respostas`
        );

        for (const resposta of respostasSalvas || []) {
          const idQuestao = Number(
            resposta.questoes_idquestoes
          );

          if (!respostasPorQuestao.has(idQuestao)) {
            respostasPorQuestao.set(idQuestao, {
              ...resposta,
              acertou: resposta.acertou === true
            });
          }
        }
      } catch (err) {
        console.warn(
          'Não foi possível carregar as respostas anteriores:',
          err
        );
      }

      calcularAcertos();

      // 6. Renderiza o conteúdo do tema.
      el('titulo-tema').textContent = temaAtual.nome;
      el('texto-tema').replaceChildren();

      for (const item of conteudosAtuais) {
        const titulo = document.createElement('h3');
        titulo.textContent = item.titulo || temaAtual.nome;

        const texto = document.createElement('div');
        texto.className = 'bloco-conteudo';
        texto.innerHTML = item.descricao || '';

        el('texto-tema').append(titulo, texto);

        try {
          const url = new URL(item.recurso_url);

          if (url.protocol === 'https:') {
            if (
              /\.(png|jpg|jpeg|webp|gif)($|\?)/i.test(url.pathname)
            ) {
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
        } catch {
          // Recurso complementar opcional.
        }
      }

      // 7. Renderiza o quiz.
      const quizContainer = el('quiz-tema');

      if (quizContainer) {
        quizContainer.replaceChildren();

        const tituloQuiz = document.createElement('h3');
        tituloQuiz.textContent = '✍️ Quiz de Fixação';

        const instrucao = document.createElement('p');
        instrucao.className = 'quiz-instrucao';
        instrucao.textContent =
          'Responda às perguntas para fixar o conteúdo. São necessários 3 acertos para concluir o tema.';

        const progressoAcertos = document.createElement('p');
        progressoAcertos.id = 'acertos-tema';
        progressoAcertos.setAttribute('role', 'status');
        progressoAcertos.setAttribute('aria-live', 'polite');

        // Botão único para reiniciar o quiz inteiro.
        const botaoReiniciar = document.createElement('button');
        botaoReiniciar.id = 'tentar-quiz';
        botaoReiniciar.type = 'button';
        botaoReiniciar.textContent = 'Tentar novamente';
        botaoReiniciar.hidden = true;

        botaoReiniciar.addEventListener('click', reiniciarQuiz);

        quizContainer.append(
          tituloQuiz,
          instrucao,
          progressoAcertos,
          botaoReiniciar
        );

        if (questoesAtuais.length > 0) {
          questoesAtuais.forEach((q, index) => {
            const div = document.createElement('div');
            div.className = 'pergunta-quiz';

            const p = document.createElement('p');
            const strong = document.createElement('strong');

            strong.textContent = `${index + 1}. ${q.enunciado}`;

            p.append(strong);
            div.append(p);

            const opcoes = q.alternativas || [];
            const radios = [];

            // Cria as alternativas.
            opcoes.forEach(op => {
              const label = document.createElement('label');
              const input = document.createElement('input');

              input.type = 'radio';
              input.name = `q_${q.idquestoes}`;
              input.value = op.letra;

              radios.push(input);

              label.append(input, ` ${op.letra}) ${op.texto}`);
              div.append(label, document.createElement('br'));
            });

            const botaoVerificar = document.createElement('button');
            botaoVerificar.type = 'button';
            botaoVerificar.textContent = 'Verificar resposta';

            const feedback = document.createElement('p');
            feedback.setAttribute('role', 'status');
            feedback.setAttribute('aria-live', 'polite');

            // 8. Restaura a resposta já salva.
            const respostaSalva = respostasPorQuestao.get(
              Number(q.idquestoes)
            );

            if (respostaSalva) {
              radios.forEach(radio => {
                radio.checked =
                  radio.value.trim().toUpperCase() ===
                  String(respostaSalva.alternativa_escolhida)
                    .trim()
                    .toUpperCase();

                radio.disabled = true;
              });

              botaoVerificar.disabled = true;

              feedback.textContent = respostaSalva.acertou
                ? `Você já respondeu: ${respostaSalva.alternativa_escolhida}. Resposta correta!`
                : `Você já respondeu: ${respostaSalva.alternativa_escolhida}. Resposta incorreta.`;

              feedback.style.color = respostaSalva.acertou
                ? 'green'
                : 'crimson';
            }

            // 9. Envia a resposta ao backend.
            botaoVerificar.addEventListener(
              'click',
              async () => {
                const selecionada = radios.find(
                  radio => radio.checked
                );

                if (!selecionada) {
                  feedback.textContent =
                    'Selecione uma alternativa primeiro.';

                  feedback.style.color = '';
                  return;
                }

                botaoVerificar.disabled = true;
                feedback.textContent =
                  'Verificando e salvando resposta…';
                feedback.style.color = '';

                try {
                  const resultado = await api.request(
                    `questoes/${q.idquestoes}/responder`,
                    {
                      method: 'POST',
                      body: {
                        letra: selecionada.value
                      }
                    }
                  );

                  const letraFinal =
                    resultado.letraEscolhida ||
                    selecionada.value;

                  // Bloqueia a questão depois de salvar.
                  radios.forEach(radio => {
                    radio.checked =
                      radio.value.trim().toUpperCase() ===
                      String(letraFinal).trim().toUpperCase();

                    radio.disabled = true;
                  });

                  feedback.textContent =
                    resultado.mensagem ||
                    (
                      resultado.correta
                        ? 'Resposta correta!'
                        : 'Resposta incorreta.'
                    );

                  if (
                    !resultado.correta &&
                    resultado.letraCorreta
                  ) {
                    feedback.textContent +=
                      ` Alternativa correta: ${resultado.letraCorreta}.`;
                  }

                  feedback.style.color = resultado.correta
                    ? 'green'
                    : 'crimson';

                  // Atualiza os dados locais com o resultado confirmado.
                  respostasPorQuestao.set(
                    Number(q.idquestoes),
                    {
                      questoes_idquestoes: Number(q.idquestoes),
                      alternativa_escolhida: letraFinal,
                      acertou: resultado.correta === true
                    }
                  );

                  calcularAcertos();
                } catch (error) {
                  feedback.textContent =
                    `${error.message} Confira se a resposta foi salva antes de tentar novamente.`;

                  feedback.style.color = 'crimson';
                  botaoVerificar.disabled = false;
                }
              }
            );

            div.append(botaoVerificar, feedback);
            quizContainer.append(div);
          });
        } else {
          const aviso = document.createElement('p');
          aviso.textContent =
            'Ainda não há questões disponíveis para este tema.';

          quizContainer.append(aviso);
        }
      }

      // 10. Exibe o conteúdo e atualiza os botões.
      el('conteudo').hidden = false;

      calcularAcertos();

      informar(
        conteudosAtuais.length
          ? ''
          : 'O material deste tema ainda não está disponível.'
      );
    } catch (error) {
      erro(error);
      el('tentar').hidden = false;
    }
  }

  // 11. Registra a conclusão do tema.
  el('concluir').addEventListener('click', async () => {
    if (!temaAtual) return;

    calcularAcertos();

    if (acertosTema < 3) {
      informar(
        `Você precisa de 3 acertos para concluir o tema. Faltam ${3 - acertosTema}.`
      );
      return;
    }

    el('concluir').disabled = true;
    informar('Verificando acertos e salvando progresso…');

    try {
      await api.request(
        `temas/${temaAtual.idtemas}/conclusao`,
        {
          method: 'PUT',
          body: {}
        }
      );

      concluidos.add(Number(temaAtual.idtemas));

      resumo();
      listar();
      atualizarProgressoAcertos();

      informar(
        'Tema concluído com sucesso! Seu progresso foi salvo.'
      );
    } catch (error) {
      erro(error);
      atualizarProgressoAcertos();
    }
  });

  // Busca temas.
  el('busca').addEventListener('input', listar);

  // Tenta carregar novamente em caso de falha.
  el('tentar').addEventListener('click', carregar);

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