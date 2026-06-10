# Auth Proxy

Caddy 2 reverse proxy with `forward_auth` gating for n8n, Flowise, and Paperclip.

Public access to these services is gated through the auth-proxy subdomain.

---

# Auth Proxy

Standalone deployable service extracted from [`levinnovation/agentyx-vertical-assets`](https://github.com/levinnovation/agentyx-vertical-assets).

## Railway

| Field | Value |
|-------|-------|
| Project | `client-levinnovation-agentyx` |
| Service | `agx-demo-auth-proxy` |
| Image | `ghcr.io/levinnovation/agentyx-auth-proxy` |
| Health | `/health` |

## Deploy

Push to `main` triggers `.github/workflows/deploy.yml`:

1. Build Docker image
2. Push to GHCR (`:latest` + commit SHA)
3. Update Railway service source to GHCR image and redeploy

Manual deploy:

```bash
export RAILWAY_TOKEN=...
export IMAGE_TAG=ghcr.io/levinnovation/agentyx-auth-proxy:latest
bash scripts/railway-deploy.sh
```

## Local development

See `.env.example` if present. Build and run:

```bash
docker build -t agentyx-auth-proxy .
docker run --rm -p 8080:8080 --env-file .env agentyx-auth-proxy
```

## Monorepo origin

Previously lived at `services/auth-proxy` in `agentyx-vertical-assets`. Architectural decisions and tenant env vars are documented in the monorepo under `knowledge/` and `tenants/*/assets/deploy/railway/`.

## Required GitHub secrets

| Secret | Purpose |
|--------|---------|
| `RAILWAY_TOKEN` | Railway project token for deploy workflow |
| `GHCR_TOKEN` | Optional; falls back to `GITHUB_TOKEN` for package push |

