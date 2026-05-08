#!/usr/bin/env bash

LOG_FILE="/var/log/statuspulse-monitor.log"
HEALTH_URL="${HEALTH_URL:-http://localhost/health}"
ALERT_WEBHOOK_URL="${ALERT_WEBHOOK_URL:-}"
EXPECTED_CONTAINERS=("statuspulse-app" "statuspulse-postgres" "statuspulse-redis")

log() {
  echo "[$(date '+%F %T')] $*" | sudo tee -a "$LOG_FILE" >/dev/null
}

alert() {
  log "ALERT: $*"
  if [ -n "$ALERT_WEBHOOK_URL" ]; then
    curl -fsS -X POST -H "Content-Type: application/json" \
      -d "{\"text\":\"StatusPulse alert: $*\"}" \
      "$ALERT_WEBHOOK_URL" >/dev/null 2>&1 || true
  fi
}

log "Health monitor started"

if ! curl -fsS --max-time 10 "$HEALTH_URL" | python3 -m json.tool >/dev/null 2>&1; then
  alert "Health endpoint failed or returned invalid JSON"
else
  log "Health endpoint OK"
fi

DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
if [ "$DISK_USAGE" -gt 80 ]; then
  alert "Disk usage high: ${DISK_USAGE}%"
else
  log "Disk usage OK: ${DISK_USAGE}%"
fi

MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
if [ "$MEM_USAGE" -gt 90 ]; then
  alert "Memory usage high: ${MEM_USAGE}%"
else
  log "Memory usage OK: ${MEM_USAGE}%"
fi

for container in "${EXPECTED_CONTAINERS[@]}"; do
  if docker ps --format '{{.Names}}' | grep -qx "$container"; then
    log "Container running: $container"
  else
    alert "Container not running: $container"
  fi
done

log "Health monitor finished"
