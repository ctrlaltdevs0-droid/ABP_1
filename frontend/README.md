# Frontend ÁgilCert

Estrutura criada em HTML, CSS e JavaScript puro.

## Arquivos
- `src/login.html`: tela de login
- `src/cadastro.html`: tela de cadastro
- `src/home.html`: protótipo da página inicial
- `src/assets/css/main.css`: CSS global
- `src/assets/js/auth.js`: interações básicas
- `src/assets/img/`: logo e ilustração extraídas do material de padronização

## Executar
Na pasta `backend`, execute `npm start` e abra `http://localhost:3000` (ou a
porta configurada em `PORT`). O backend serve o frontend e a API no mesmo
endereço; `/` abre a tela de login.

Os formulários usam `/api/login/cadastro` e `/api/login/entrar`. O cliente em
`src/assets/js/api.js` envia JSON, interpreta erros e adiciona o token Bearer
nas chamadas privadas. Login e cadastro não enviam token antigo.

Para usar Live Server ou hospedar o frontend separado, configure
`AGILCERT_API_BASE_URL` em `src/assets/js/config.js`, por exemplo
`http://localhost:3000/api`. Em outro computador, use o endereço acessível do
backend, pois `localhost` aponta para o próprio computador. Em produção HTTPS,
use uma API HTTPS. Não abra os HTMLs diretamente com `file://`.
