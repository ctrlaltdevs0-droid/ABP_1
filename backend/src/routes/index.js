// Importa todos os arquivos de rotas.
import { temasRoutes } from "./temas.js";
import { conteudosRoutes } from "./conteudos.js";
import { questoesRoutes } from "./questoes.js";
import { alternativasRoutes } from "./alternativas.js";
import { tentativasRoutes } from "./tentativas.js";
import { certificadosRoutes } from "./certificados.js";

// Lista com todas as rotas da aplicação.
const rotas = [
  temasRoutes,
  conteudosRoutes,
  questoesRoutes,
  alternativasRoutes,
  tentativasRoutes,
  certificadosRoutes,
];

// Essa função tenta encontrar qual arquivo deve atender a requisição.
export async function executarRotas(req, res, pathname, supabase) {

  // Percorre todos os arquivos de rotas.
  for (const rota of rotas) {

    await rota(req, res, pathname, supabase);

    // Se alguma rota já respondeu, encerra a busca.
    if (res.writableEnded) {
      return true;
    }
  }

  // Se nenhuma rota respondeu, retorna false.
  // O server.js poderá então devolver erro 404.
  return false;
}
