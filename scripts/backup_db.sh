#!/bin/bash
set -e

BACKUP_DIR="\$(dirname "\$0")/../backups"
TIMESTAMP=\$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="\\({BACKUP_DIR}/meridian_db_backup_\\){TIMESTAMP}.sql"

mkdir -p "\$BACKUP_DIR"

echo "Starting PostgreSQL database backup..."
docker exec meridian-postgres pg_dump -U meridian meridian_db > "\$BACKUP_FILE"

echo "Backup created successfully: \${BACKUP_FILE}"
