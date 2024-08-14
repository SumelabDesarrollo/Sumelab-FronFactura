# Stage 1: Install dependencies for development
FROM node:19-alpine3.15 as dev-deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Stage 2: Build the Angular app
FROM node:19-alpine3.15 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Stage 3: Serve the app using a lightweight HTTP server
FROM nginx:1.23.3 as prod
EXPOSE 80
COPY --from=builder /app/dist/factura-sumelab /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
