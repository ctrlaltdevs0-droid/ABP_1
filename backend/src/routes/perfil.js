import { consultarPerfil, atualizarPerfil, alterarSenha } from './usuarios.js';
import { lerJson, responder, tratarErro } from '../utils/http.js';
export async function perfilRoutes(req, res, pathname, db) {
  if (!/^\/api\/usuarios\/me(?:\/senha)?\/?$/.test(pathname)) return false;
  try {
    if (req.method === 'GET' && /^\/api\/usuarios\/me\/?$/.test(pathname))
      return responder(res, 200, await consultarPerfil(db, req.usuario.id));
    if (req.method === 'PATCH') {
      const body = await lerJson(req);
      if (/\/senha\/?$/.test(pathname)) {
        await alterarSenha(db, req.usuario.id, body);
        return responder(res, 204, {});
      }
      return responder(res, 200, await atualizarPerfil(db, req.usuario.id, body));
    }
    return responder(res, 405, { erro: 'Método HTTP não permitido.' });
  } catch (error) { return tratarErro(res, error); }
}
