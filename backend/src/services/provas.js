import { ErroHttp } from '../utils/http.js';

const erros = {
  BASE_INSUFICIENTE: [409, 'A prova requer 12 temas ativos, cada um com pelo menos quatro questões aprovadas e completas.'],
  NAO_ENCONTRADA: [404, 'Tentativa não encontrada.'],
  INDISPONIVEL: [409, 'Tentativa indisponível.'],
  PROVA_INVALIDA: [409, 'A prova está incompleta ou é anterior à atualização. Inicie uma nova tentativa.'],
  CONTEUDO_INDISPONIVEL: [409, 'Uma questão da prova foi retirada de publicação.'],
  FORA_SEQUENCIA: [409, 'Responda somente a questão atual, após abri-la.'],
  TEMPO_ESGOTADO: [409, 'O prazo da questão terminou. Avance para a próxima questão.'],
  ALTERNATIVA_INVALIDA: [400, 'Alternativa inválida para esta questão.'],
  PENDENTE: [409, 'Conclua todas as questões antes de finalizar.'],
};
export async function executarOperacao(db, nome, params) {
  const { data, error } = await db.rpc(nome, params);
  if (error) throw error;
  if (!data || typeof data !== 'object') throw new Error('Resposta inválida da operação no banco.');
  if (data.erro_codigo) {
    const conhecido = erros[data.erro_codigo];
    if (!conhecido) throw new Error('Erro desconhecido na operação no banco.');
    throw new ErroHttp(...conhecido);
  }
  return data;
}
