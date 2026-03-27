#!/bin/sh

LOG_DIR=${1:-"$HOME/devops/logs"}
DAYS=${2:-7}

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%H:%M:%S')] [$LEVEL] $MSG"
}

if [ ! -d "$LOG_DIR" ]; then
    log "ERROR" "Directory '$LOG_DIR' not found"
    exit 1
fi

log "INFO" "=== Log Cleaner Started ==="
log "INFO" "Directory: $LOG_DIR"
log "INFO" "Deleting logs older than $DAYS days"

BEFORE=$(find "$LOG_DIR" -name "*.log" | wc -l)
log "INFO" "Files before: $BEFORE"

find "$LOG_DIR" -name "*.log" -mtime +$DAYS | while read f; do
    log "DELETE" "$f"
done

find "$LOG_DIR" -name "*.log" -mtime +$DAYS -delete

AFTER=$(find "$LOG_DIR" -name "*.log" | wc -l)
log "INFO" "Files after: $AFTER"
log "INFO" "=== Cleanup Complete ==="
