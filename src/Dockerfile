##build stage##
FROM node:20-alpine as build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm test
RUN npm prune --omit=dev


##run stage##
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/index.js ./index.js
COPY --from=build --chown=node:node /app/server ./server
COPY --from=build --chown=node:node /app/routes ./routes
USER node
EXPOSE 3000
ENTRYPOINT ["node", "index.js"]
