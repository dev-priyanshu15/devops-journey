#!/bin/sh

SOURCE=${1:-"$HOME/devops/notes"}
BACKUP_DIR="$HOME/devops/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date +%H:%M:%S)] [$LEVEL] $MSG"
}

if [ ! -d "$SOURCE" ]; then
    log "ERROR" "Source '$SOURCE' not found"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

log "INFO" "Starting backup of: $SOURCE"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname $SOURCE)" "$(basename $SOURCE)"

SIZE=$(du -sh "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
log "OK" "Backup done: $BACKUP_DIR/$BACKUP_NAME ($SIZE)"
