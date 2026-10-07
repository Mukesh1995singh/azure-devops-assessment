#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="devops-assessment-postgres"
DATABASE_NAME="booking_db"
DATABASE_USER="booking_user"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <backup-file>"
    echo "Example: $0 backups/booking_db_20261007_153000.dump"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found: $BACKUP_FILE"
    exit 1
fi

if ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q "true"; then
    echo "ERROR: PostgreSQL container '$CONTAINER_NAME' is not running."
    exit 1
fi

echo "Starting database restore..."

docker exec "$CONTAINER_NAME" \
    dropdb \
    -U "$DATABASE_USER" \
    --if-exists \
    "$DATABASE_NAME"

docker exec "$CONTAINER_NAME" \
    createdb \
    -U "$DATABASE_USER" \
    "$DATABASE_NAME"

cat "$BACKUP_FILE" | docker exec -i "$CONTAINER_NAME" \
    pg_restore \
    -U "$DATABASE_USER" \
    -d "$DATABASE_NAME"

echo "Restore completed successfully."

echo "Verifying restored database..."

docker exec "$CONTAINER_NAME" \
    psql \
    -U "$DATABASE_USER" \
    -d "$DATABASE_NAME" \
    -c "SELECT COUNT(*) AS hotel_bookings_count FROM hotel_bookings;"

docker exec "$CONTAINER_NAME" \
    psql \
    -U "$DATABASE_USER" \
    -d "$DATABASE_NAME" \
    -c "SELECT COUNT(*) AS booking_events_count FROM booking_events;"

echo "Database restore verification completed."