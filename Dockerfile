# Stage 1: Build & Test
FROM node:18-alpine AS builder
WORKDIR /app
COPY src/package*.json ./
RUN npm ci
COPY src/ .

# Chạy Test
RUN npm test

# Stage 2: Production Run
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY src/package*.json ./


RUN npm ci --only=production
COPY --from=builder /app ./

EXPOSE 3000
CMD ["npm", "start"]