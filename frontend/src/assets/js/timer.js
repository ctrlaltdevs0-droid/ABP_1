// 1. Variáveis de estado
let tempoRestante = 150;
let temporizador = null;

// 2. Captura do elemento do HTML
const elementoCronometro = document.getElementById('cronometro');

// 3. Função que inicia a contagem
function iniciarCronometro() {
  clearInterval(temporizador);
  tempoRestante = 150;
  atualizarTela();

  temporizador = setInterval(() => {
    tempoRestante--;
    atualizarTela();

    if (tempoRestante <= 0) {
      clearInterval(temporizador);
      tempoEsgotado();
    }
  }, 1000);
}

// 4. Função que formata e desenha o tempo na tela
function atualizarTela() {
  const minutos = Math.floor(tempoRestante / 60);
  const segundos = tempoRestante % 60;

  const minFormatado = String(minutos).padStart(2, '0');
  const segFormatado = String(segundos).padStart(2, '0');

  if (elementoCronometro) {
    elementoCronometro.textContent = `${minFormatado}:${segFormatado}`;
  }
}

// 5. Função executada ao fim dos 150s (RF11)
function tempoEsgotado() {
  alert('Tempo esgotado! A questão foi considerada incorreta.');
}