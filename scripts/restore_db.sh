#!/bin/bash
set -e

if [ -z "\$1" ]; then
    echo "Usage: \$0 <path_to_backup_sql_file>"
    exit 1
fi

BACKUP_FILE="\$1"

if [ ! -f "\$BACKUP_FILE" ]; then
    echo "Error: Backup file '\$BACKUP_FILE' not found."
    exit 1
fi

echo "Restoring database from: \${BACKUP_FILE}..."
docker exec -i meridian-postgres psql -U meridian -d meridian_db < "\$BACKUP_FILE"

echo "Database restored successfully from \${BACKUP_FILE}!"
