import { consultarPerfil, atualizarPerfil, alterarSenha } from '../services/usuarios.js';
import { lerJson, responder, tratarErro, ErroHttp } from '../utils/http.js';

export async function usuariosRoutes(req, res, pathname, db) {
  if (!/^\/api\/usuarios\/me(?:\/senha)?\/?$/.test(pathname)) return false;
  try {
    if (!Number.isSafeInteger(req.usuario?.id) || req.usuario.id < 1) throw new ErroHttp(401);
    res.setHeader('Cache-Control', 'no-store');
    const senha = /\/senha\/?$/.test(pathname);
    if (!senha && req.method === 'GET') return responder(res, 200, { usuario: await consultarPerfil(db, req.usuario.id) });
    if (req.method === 'PATCH') {
      const body = await lerJson(req);
      if (senha) {
        await alterarSenha(db, req.usuario.id, body);
        return responder(res, 200, { mensagem: 'Senha alterada com sucesso.' });
      }
      return responder(res, 200, { usuario: await atualizarPerfil(db, req.usuario.id, body) });
    }
    return responder(res, 405, { erro: 'Método não permitido.' }, { Allow: senha ? 'PATCH' : 'GET, PATCH' });
  } catch (erro) { tratarErro(res, erro); }
}
