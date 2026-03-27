#!/bin/sh

THRESHOLD=80
LOG_FILE="$HOME/devops/logs/disk_alert.log"
mkdir -p "$(dirname $LOG_FILE)"

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $MSG" | tee -a "$LOG_FILE"
}

log "INFO" "=== Disk Check Started ==="

df -h | tail -n +2 | while read line; do
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $6}')

    case "$USAGE" in
        ''|*[!0-9]*) continue ;;
    esac

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        log "CRITICAL" "$MOUNT is at ${USAGE}%"
    elif [ "$USAGE" -ge 60 ]; then
        log "WARN" "$MOUNT is at ${USAGE}%"
    else
        log "OK" "$MOUNT is at ${USAGE}%"
    fi
done

log "INFO" "=== Disk Check Complete ==="
