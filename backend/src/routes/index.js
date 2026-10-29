import { perfilRoutes } from './perfil.js';
import { progressoRoutes } from "./progresso.js";
import { conteudosRoutes } from "./conteudos.js";
import { temasRoutes } from "./temas.js";
import { questoesRoutes } from "./questoes.js";
import { alternativasRoutes } from "./alternativas.js";
import { tentativasRoutes } from "./tentativas.js";
import { certificadosRoutes } from "./certificados.js";

// Lista com todas as rotas da aplicação
const rotas = [
  perfilRoutes,
  progressoRoutes,
  temasRoutes,
  conteudosRoutes,
  questoesRoutes,
  alternativasRoutes,
  tentativasRoutes,
  certificadosRoutes,
];

// Função que executa as rotas
export async function executarRotas(req, res, pathname, supabase) {
  for (const rota of rotas) {
    await rota(req, res, pathname, supabase);

    if (res.writableEnded) {
      return true;
    }
  }

  return false;
}
