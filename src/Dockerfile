FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

FROM alpine:3.19

RUN addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node && \
    apk add --no-cache nodejs

ENV NODE_ENV=production
WORKDIR /app

COPY --from=deps --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node index.js ./
COPY --chown=node:node routes ./routes
COPY --chown=node:node server ./server

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1:3000/ || exit 1

CMD ["node", "index.js"]