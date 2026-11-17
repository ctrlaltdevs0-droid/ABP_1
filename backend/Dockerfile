FROM node:22-bookworm-slim

WORKDIR /app/backend
COPY backend/package.json backend/package-lock.json ./
COPY backend/scripts/copiar-vendor.mjs ./scripts/copiar-vendor.mjs
RUN npm ci --omit=dev && npm cache clean --force

COPY --chown=node:node backend/src ./src
COPY --chown=node:node frontend/src /app/frontend/src
RUN npm run vendor:copiar

ENV NODE_ENV=production PORT=3000
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]
