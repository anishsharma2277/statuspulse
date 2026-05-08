#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-./backups}"
CONTAINER_NAME="${POSTGRES_CONTAINER:-statuspulse-postgres}"
DB_NAME="${DB_NAME:-statuspulse}"
DB_USER="${DB_USER:-statuspulse}"
TIMESTAMP="$(date +%F_%H%M%S)"
FILE="$BACKUP_DIR/statuspulse_db_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting PostgreSQL backup..."

docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$FILE"

echo "[$(date)] Backup created: $FILE"

find "$BACKUP_DIR" -name "statuspulse_db_*.sql.gz" -type f | sort -r | tail -n +8 | xargs -r rm -f

echo "[$(date)] Rotation complete. Last 7 backups retained."
