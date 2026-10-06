.PHONY: dev prod test lint build backup

dev:
	docker compose up -d postgres redis
	cd backend && go run ./cmd/api

prod:
	docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build

test:
	cd backend && go test ./...

build:
	cd backend && go build ./...
	cd web && npm install && npm run build

backup:
	./scripts/backup-postgres.sh