const MENSAGENS_ERRO = {
  400: "Requisição inválida.",
  401: "Autenticação necessária.",
  403: "Acesso negado.",
  404: "Recurso não encontrado.",
  405: "Método HTTP não permitido.",
  409: "Conflito com os dados existentes.",
  413: "Conteúdo enviado muito grande.",
  415: "Formato não suportado. Envie application/json.",
  422: "Dados inválidos.",
  429: "Muitas requisições. Tente novamente mais tarde.",
  500: "Erro interno do servidor.",
  503: "Serviço temporariamente indisponível.",
};

// Permite lançar um erro com status HTTP.
export class ErroHttp extends Error {
  constructor(status, mensagem) {
    super(mensagem ?? MENSAGENS_ERRO[status] ?? "Erro na requisição.");
    this.name = "ErroHttp";
    this.status = status;
  }
}

// Lê o JSON enviado pelo frontend.
// O limite padrão é de 1.000.000 de bytes.
export function lerJson(req, limite = 1_000_000) {
  return new Promise((resolve, reject) => {
    let partes = [];
    let tamanho = 0;
    let finalizado = false;

    function falhar(erro) {
      if (finalizado) return;

      finalizado = true;
      partes = [];
      reject(erro);
    }

    req.on("data", (chunk) => {
      // Após uma falha, descarta os próximos dados.
      if (finalizado) return;

      const buffer = Buffer.isBuffer(chunk)
        ? chunk
        : Buffer.from(chunk);

      tamanho += buffer.length;

      if (tamanho > limite) {
        // Preserva a conexão para permitir uma resposta 413.
        falhar(new ErroHttp(413));
        return;
      }

      partes.push(buffer);
    });

    req.on("end", () => {
      if (finalizado) return;

      if (tamanho === 0) {
        finalizado = true;
        resolve({});
        return;
      }

      const tipo = (req.headers["content-type"] ?? "")
        .split(";")[0]
        .trim()
        .toLowerCase();

      if (tipo !== "application/json") {
        falhar(new ErroHttp(415));
        return;
      }

      // Converte após juntar os buffers para preservar acentos.
      const texto = Buffer.concat(partes).toString("utf8");
      partes = [];

      try {
        const dados = JSON.parse(texto);

        finalizado = true;
        resolve(dados);
      } catch {
        falhar(new ErroHttp(400, "JSON inválido."));
      }
    });

    req.on("error", () => {
      falhar(new ErroHttp(400, "Erro ao receber os dados."));
    });

    req.on("aborted", () => {
      falhar(new ErroHttp(400, "Requisição interrompida."));
    });
  });
}

// Envia uma resposta JSON para o frontend.
export function responder(res, status, corpo, cabecalhos = {}) {
  if (res.destroyed || res.writableEnded) return;

  // Serializa antes de enviar os cabeçalhos.
  const json = JSON.stringify(corpo);

  res.writeHead(status, {
    ...cabecalhos,
    "Content-Type": "application/json; charset=utf-8",
  });

  res.end(json);
}

// Envia um erro em formato padronizado.
export function responderErro(
  res,
  status = 500,
  mensagem,
  cabecalhos = {}
) {
  return responder(
    res,
    status,
    {
      sucesso: false,
      erro: {
        status,
        mensagem:
          mensagem ??
          MENSAGENS_ERRO[status] ??
          "Erro na requisição.",
      },
    },
    cabecalhos
  );
}

// Trata os erros capturados pelo catch.
export function tratarErro(res, erro) {
  const conhecido = erro instanceof ErroHttp;

  if (!conhecido || erro.status >= 500) {
    console.error("Erro no servidor:", erro);
  }

  if (res.destroyed || res.writableEnded) return;

  // Se a resposta já começou, não é possível mudar seu status.
  if (res.headersSent) {
    res.destroy();
    return;
  }

  if (conhecido && erro.status < 500) {
    return responderErro(res, erro.status, erro.message);
  }

  // Não expõe detalhes de erros internos ao frontend.
  return responderErro(
    res,
    conhecido ? erro.status : 500
  );
}

// Extrai o ID após a rota.
// Exemplo: /api/usuarios/5 retorna "5".
export function idDaRota(pathname, prefixo) {
  const base = `${prefixo.replace(/\/+$/, "")}/`;

  if (!pathname.startsWith(base)) return null;

  const resto = pathname
    .slice(base.length)
    .replace(/\/$/, "");

  if (!resto || resto.includes("/")) return null;

  return resto;
}

// Verifica a rota com ou sem barra final.
export function rotaExata(pathname, rota) {
  const base = rota.replace(/\/+$/, "") || "/";

  return (
    pathname === base ||
    (base !== "/" && pathname === `${base}/`)
  );
}