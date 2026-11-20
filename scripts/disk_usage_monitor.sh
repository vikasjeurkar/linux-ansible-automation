#!/usr/bin/env bash
# disk_usage_monitor.sh - warn when any filesystem exceeds THRESHOLD percent.
# Usage: THRESHOLD=80 ./disk_usage_monitor.sh
set -euo pipefail

THRESHOLD="${THRESHOLD:-80}"
ALERT=0

log() { echo "$(date '+%F %T') [disk-monitor] $*"; }

while read -r fs usage mount; do
    pct="${usage%\%}"
    if [ "$pct" -ge "$THRESHOLD" ]; then
        log "ALERT: ${mount} (${fs}) is at ${pct}% (threshold ${THRESHOLD}%)"
        ALERT=1
        # Send email if a mail command is available
        if command -v mail >/dev/null 2>&1; then
            echo "Disk usage on $(hostname): ${mount} at ${pct}%" | mail -s "Disk alert: $(hostname)" root || true
        fi
    fi
done < <(df -hP -x tmpfs -x devtmpfs -x squashfs -x overlay | awk 'NR>1 {print $1, $5, $6}')

if [ "$ALERT" -eq 0 ]; then log "OK: all filesystems below ${THRESHOLD}%"; fi
exit 0
