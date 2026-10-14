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
Abra `src/login.html` com Live Server, usando `frontend/src` como raiz. O backend atual disponibiliza apenas a API e não serve estes arquivos estáticos.

Os formulários usam `/api/login/cadastro` e `/api/login/entrar` no backend local
em `http://localhost:3000`. Execute a API antes de testar. Para outro ambiente,
configure `API_BASE_URL` em `src/assets/js/auth.js` com o endereço do backend.
