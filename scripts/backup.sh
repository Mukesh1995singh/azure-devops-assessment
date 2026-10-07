#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="devops-assessment-postgres"
DATABASE_NAME="booking_db"
DATABASE_USER="booking_user"

BACKUP_DIR="$(dirname "$0")/../backups"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
BACKUP_FILE="${BACKUP_DIR}/booking_db_${TIMESTAMP}.dump"

mkdir -p "$BACKUP_DIR"

if ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q "true"; then
    echo "Error: PostgreSQL container '$CONTAINER_NAME' is not running."
    exit 1
fi

echo "Starting PostgreSQL backup..."

docker exec "$CONTAINER_NAME" \
    pg_dump \
    -U "$DATABASE_USER" \
    -d "$DATABASE_NAME" \
    -Fc \
    > "$BACKUP_FILE"

echo "Backup completed successfully."
echo "Backup file: $BACKUP_FILE"