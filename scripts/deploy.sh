#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/statuspulse"
COMPOSE_FILE="$APP_DIR/docker-compose.prod.yml"
HEALTH_URL="${HEALTH_URL:-http://localhost:8000/health}"
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/anishsharma2277/statuspulse}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
LOG_FILE="/var/log/statuspulse-deploy.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

rollback() {
  log "Health check failed. Rolling back to previous image..."
  if [ -f "$APP_DIR/.previous_image" ]; then
    PREVIOUS_IMAGE="$(cat "$APP_DIR/.previous_image")"
    echo "STATUSPULSE_IMAGE=$PREVIOUS_IMAGE" > "$APP_DIR/.image.env"
    docker compose -f "$COMPOSE_FILE" --env-file "$APP_DIR/.env" --env-file "$APP_DIR/.image.env" up -d
    log "Rollback completed to $PREVIOUS_IMAGE"
  else
    log "No previous image found. Rollback skipped."
  fi
  exit 1
}

log "Starting deployment"

mkdir -p "$APP_DIR"

CURRENT_IMAGE="$(docker inspect statuspulse-app --format='{{.Config.Image}}' 2>/dev/null || true)"

if [ -n "$CURRENT_IMAGE" ]; then
  echo "$CURRENT_IMAGE" > "$APP_DIR/.previous_image"
  log "Previous image saved: $CURRENT_IMAGE"
fi

NEW_IMAGE="$IMAGE_NAME:$IMAGE_TAG"
log "Pulling image: $NEW_IMAGE"
docker pull "$NEW_IMAGE"

echo "STATUSPULSE_IMAGE=$NEW_IMAGE" > "$APP_DIR/.image.env"

log "Starting new containers"
docker compose -f "$COMPOSE_FILE" --env-file "$APP_DIR/.env" --env-file "$APP_DIR/.image.env" up -d

log "Running health check"
for i in {1..30}; do
  if curl -fsS "$HEALTH_URL" | grep -q '"status":"healthy"'; then
    log "Deployment successful"
    exit 0
  fi
  sleep 5
done

rollback
