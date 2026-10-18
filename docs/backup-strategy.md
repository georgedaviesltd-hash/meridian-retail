# Meridian Retail PostgreSQL Backup & Recovery Strategy

## Overview
This document outlines the database backup and recovery procedures for the Meridian Retail Group PostgreSQL database.

## Automated Backup Procedure (`scripts/backup_db.sh`)
- Uses `docker exec` to run `pg_dump` on the `meridian-postgres` container.
- Generates a timestamped SQL dump in the `./backups/` directory.
- Can be scheduled as a daily cron job on the EC2 host.

## Database Restore Procedure (`scripts/restore_db.sh`)
- Accepts a SQL backup file as an argument.
- Streams the SQL commands directly into `psql` running inside the `meridian-postgres` container using `docker exec -i`.
- Restores database schema and seed data to prove disaster recovery capability.

## Verification
1. Run `./scripts/backup_db.sh` to generate a backup file.
2. Modify or drop a test table/row in PostgreSQL.
3. Run `./scripts/restore_db.sh ./backups/<backup_file>.sql` to recover lost data.
4. Verify that data is restored.
