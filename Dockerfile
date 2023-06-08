FROM node:18.16.0 AS builder
WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci
COPY . .
RUN npm run build

FROM gcr.io/distroless/nodejs18-debian11:nonroot AS runner
WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

ENV NODE_ENV production
EXPOSE 3000
ENV PORT 3000
CMD ["server.js"]

