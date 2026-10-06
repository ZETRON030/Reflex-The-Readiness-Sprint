# Reflex production runbook

## Architecture
Rider writes are local-first. Mutations are durable in WatermelonDB and are sent in batches to `/api/v1/sync`. The API applies each event in a database transaction and uses the client UUID as an idempotency key. PostgreSQL is the source of truth; SSE drives operations UI updates.

## First deployment
1. Create `.env.production` from `.env.production.example`.
2. Generate unique 32+ byte random values for `POSTGRES_PASSWORD`, `AUTH_SECRET`, and `BOOTSTRAP_TOKEN`.
3. Provision DNS for the deployment hostname.
4. Place a trusted certificate/key in `deploy/certs/`.
5. Run `docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build`.
6. Provision credentials once through `/api/v1/auth/bootstrap` using the bootstrap header. Do this only over TLS, then rotate the bootstrap token and redeploy.
7. Remove any development data and confirm `APP_ENV=production`.

## Operational requirements
- PostgreSQL backups must be copied off-host; use the included dump script plus your cloud backup policy.
- Monitor API readiness, PostgreSQL disk usage, database connection saturation, Redis memory, HTTP 5xx, sync rejection rate, and SSE disconnects.
- Rotate `AUTH_SECRET` only with an explicit session invalidation plan because existing bearer tokens will become invalid.
- Store proof media on a durable encrypted volume or replace the local media adapter with your approved object-storage adapter before multi-region deployment.
- Do not expose PostgreSQL or Redis ports publicly.
- Run the mobile app as a native development/production build; Vision Camera is not an Expo Go-only feature.

## Acceptance gates
- Offline pickup produces one event after repeated reconnects.
- Offline delivery produces one event after repeated reconnects.
- Duplicate client UUID produces no second event.
- Stale previous status is rejected.
- Incorrect pickup/delivery code is rejected.
- Terminal states cannot transition.
- Unauthorized roles cannot assign or mutate another rider's delivery.
- Proof capture remains retryable after network loss.
- SSE updates operations dashboard.
- Low-memory Android test passes with long feeds and camera inputs.