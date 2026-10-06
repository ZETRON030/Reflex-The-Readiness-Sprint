# Reflex — deployable offline-first delivery platform

Reflex implements the supplied architecture for low-end Android/3G/4G: local-first rider persistence, durable mutation queues, transactional/idempotent synchronization, PostgreSQL/PostGIS, Redis, SSE, a dispatcher/retailer web portal, QR/barcode scanning, and compressed proof media.

## Components
- `backend/`: Go/Gin API and transactional domain/store layer.
- `mobile/`: React Native/Expo rider app with WatermelonDB, Vision Camera, network-aware sync and proof-media pipeline.
- `web/`: React/Vite operations portal.
- `docker-compose.prod.yml`: production container topology: TLS gateway, web, API, PostgreSQL/PostGIS, Redis and persistent media.
- `PRODUCTION.md`: deployment and acceptance runbook.

## Local development
```bash
docker compose up -d
cd backend && go run ./cmd/api
# in another shell
cd web && npm install && npm run dev
# mobile: cd mobile && npm install && npx expo start --dev-client