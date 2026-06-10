#!/usr/bin/env bash
# Deploy the current GHCR image to Railway via GraphQL API.
set -euo pipefail

: "${RAILWAY_TOKEN:?RAILWAY_TOKEN is required}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"
: "${RAILWAY_SERVICE_ID:?RAILWAY_SERVICE_ID is required}"
: "${RAILWAY_PROJECT_ID:?RAILWAY_PROJECT_ID is required}"
: "${RAILWAY_ENVIRONMENT_ID:?RAILWAY_ENVIRONMENT_ID is required}"

graphql() {
  local query="$1"
  curl -sS -H "Authorization: Bearer ${RAILWAY_TOKEN}" \
    -H "Content-Type: application/json" \
    -X POST https://backboard.railway.app/graphql/v2 \
    -d "{\"query\":${query}}"
}

echo "[INFO] Updating Railway service ${RAILWAY_SERVICE:-unknown} -> ${IMAGE_TAG}"

UPDATE_QUERY="\"mutation { serviceInstanceUpdate(serviceId: \\\"${RAILWAY_SERVICE_ID}\\\", environmentId: \\\"${RAILWAY_ENVIRONMENT_ID}\\\", input: {source: {image: \\\"${IMAGE_TAG}\\\"}}) }\""
RESULT=$(graphql "$UPDATE_QUERY")
echo "$RESULT" | jq -e '.data.serviceInstanceUpdate' >/dev/null

DEPLOY_QUERY="\"mutation { serviceInstanceDeploy(serviceId: \\\"${RAILWAY_SERVICE_ID}\\\", environmentId: \\\"${RAILWAY_ENVIRONMENT_ID}\\\") }\""
RESULT=$(graphql "$DEPLOY_QUERY")
echo "$RESULT" | jq -e '.data.serviceInstanceDeploy' >/dev/null

echo "[INFO] Deploy triggered for ${RAILWAY_SERVICE:-unknown}"
