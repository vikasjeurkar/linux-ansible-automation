#!/usr/bin/env bash
# backup.sh - create a timestamped tar.gz backup and delete old ones.
# Usage: BACKUP_SRC="/etc /home" BACKUP_DEST=/var/backups/automation ./backup.sh
set -euo pipefail

BACKUP_SRC="${BACKUP_SRC:-/etc /home}"
BACKUP_DEST="${BACKUP_DEST:-/var/backups/automation}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP="$(date +%F_%H-%M-%S)"
ARCHIVE="${BACKUP_DEST}/backup_$(hostname)_${TIMESTAMP}.tar.gz"

log() { echo "$(date '+%F %T') [backup] $*"; }

mkdir -p "$BACKUP_DEST"
log "Starting backup of: ${BACKUP_SRC}"

# shellcheck disable=SC2086
tar -czf "$ARCHIVE" --ignore-failed-read $BACKUP_SRC 2>/dev/null || [ $? -eq 1 ]
log "Backup created: ${ARCHIVE} ($(du -h "$ARCHIVE" | cut -f1))"

# Remove backups older than retention period
DELETED=$(find "$BACKUP_DEST" -name 'backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete | wc -l)
log "Removed ${DELETED} backup(s) older than ${RETENTION_DAYS} days"
