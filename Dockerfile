# Build the Vue assets first so the frontend Go launcher can embed them.
FROM node:22-alpine AS frontend-assets
WORKDIR /src/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

FROM golang:1.26-alpine AS backend-builder
WORKDIR /src/backend
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/ ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/qq-pet-server ./cmd/server

FROM golang:1.26-alpine AS frontend-builder
WORKDIR /src/frontend
COPY frontend/go.mod ./
COPY frontend/main.go ./
COPY --from=frontend-assets /src/frontend/dist ./dist
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/qq-pet-frontend .

FROM alpine:3.22 AS backend
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=backend-builder /out/qq-pet-server /app/qq-pet-server
RUN mkdir -p /app/data
EXPOSE 2345
ENTRYPOINT ["/app/qq-pet-server"]

FROM alpine:3.22 AS frontend
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=frontend-builder /out/qq-pet-frontend /app/qq-pet-frontend
EXPOSE 5173
ENTRYPOINT ["/app/qq-pet-frontend"]
