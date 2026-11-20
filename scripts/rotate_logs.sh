#!/usr/bin/env bash
# rotate_logs.sh - archive current logs with a date suffix, delete archives past retention.
# Usage: LOG_DIR=/var/log/automation RETENTION_DAYS=14 ./rotate_logs.sh
set -euo pipefail

LOG_DIR="${LOG_DIR:-/var/log/automation}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

log() { echo "$(date '+%F %T') [log-rotate] $*"; }

[ -d "$LOG_DIR" ] || { log "ERROR: ${LOG_DIR} not found"; exit 1; }

for f in "$LOG_DIR"/*.log; do
    [ -s "$f" ] || continue
    gzip -c "$f" > "${f}.$(date +%F).gz"
    : > "$f"
    log "Rotated $(basename "$f")"
done

DELETED=$(find "$LOG_DIR" -name '*.gz' -mtime +"$RETENTION_DAYS" -print -delete | wc -l)
log "Deleted ${DELETED} archive(s) older than ${RETENTION_DAYS} days"
