#!/usr/bin/env bash
# Best-effort smoke test after Railway deploy.
set -euo pipefail

: "${RAILWAY_TOKEN:?RAILWAY_TOKEN is required}"
: "${RAILWAY_SERVICE:?RAILWAY_SERVICE is required}"
: "${HEALTH_PATH:?HEALTH_PATH is required}"

curl -fsSL https://railway.app/install.sh | bash
export PATH="$HOME/.railway/bin:$PATH"

cd "$(mktemp -d)"
railway link --project "${RAILWAY_PROJECT_ID}" --environment production --service "${RAILWAY_SERVICE}" >/dev/null 2>&1 || true

DOMAIN=$(railway domain 2>/dev/null || true)
if [[ -z "${DOMAIN}" ]]; then
  echo "[WARN] No public domain for ${RAILWAY_SERVICE}; skipping external smoke test."
  exit 0
fi

URL="https://${DOMAIN}${HEALTH_PATH}"
echo "[INFO] Smoke testing ${URL}"
curl -fsS "${URL}" >/dev/null
echo "[INFO] Smoke test passed."
