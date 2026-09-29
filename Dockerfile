FROM node:24-alpine AS deps

WORKDIR /app

COPY src/package*.json ./

RUN npm ci --omit=dev

FROM node:24-alpine AS runner

WORKDIR /app

COPY --from=deps --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node src/package*.json ./
COPY --chown=node:node src/index.js ./
COPY --chown=node:node src/routes/ ./routes/
COPY --chown=node:node src/server/ ./server/

USER node

EXPOSE 3000

CMD ["node", "index.js"]
