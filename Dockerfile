# Dockerfile
# 1) Build stage
FROM oven/bun:1.2 as builder
WORKDIR /usr/src/app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun run build

# 2) Production stage
FROM nginx:stable-alpine
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
# Optional: copy a custom nginx.conf if you need rewrites, headers, etc.
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
