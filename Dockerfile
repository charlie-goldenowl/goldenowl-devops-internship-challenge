FROM node:14-alpine

WORKDIR /app

COPY src/package*.json ./

RUN npm install

COPY src ./

EXPOSE 3001

CMD ["npm","start"]
