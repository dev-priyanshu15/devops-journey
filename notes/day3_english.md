# Day 3 — Shell Scripting Deep Dive (English Notes)

---

## 1. Variables

A variable is a named container that stores a value.

```sh
# Store a plain value
NAME="Priyanshu"
AGE=21

# Store the output of a command
TODAY=$(date +%Y-%m-%d)
DISK=$(df -h / | awk 'NR==2 {print $5}')
```

### `=" "` vs `$()`
```
NAME="Priyanshu"       →  plain text — store directly
TODAY=$(date)          →  command runs first, output is stored
```

Rule: If it is a plain value, use `=" "`. If it is a command whose output you want, use `$()`.

### `" "` vs `' '`
```sh
echo "$NAME is learning DevOps"   →  Priyanshu is learning DevOps
echo '$NAME is learning DevOps'   →  $NAME is learning DevOps
```
```
" "  =  variables are expanded  ($NAME → actual value)
' '  =  everything is printed literally (no expansion)
```

### Variables are case-sensitive
```sh
name="abc"
NAME="xyz"
# These are two completely different variables
```

---

## 2. If-Else

```sh
DISK=85

if [ "$DISK" -ge 80 ]; then
    echo "CRITICAL: Disk almost full!"
elif [ "$DISK" -ge 60 ]; then
    echo "WARNING: Disk filling up"
else
    echo "OK: Disk usage is $DISK%"
fi
```

### Comparison Operators
```
Numbers:          Strings:
-eq  →  ==        =   →  equal
-ne  →  !=        !=  →  not equal
-gt  →  >
-lt  →  <
-ge  →  >=
-le  →  <=
```

### File / Directory Checks
```sh
[ -f /etc/passwd ]   # does file exist?
[ -d /tmp ]          # is it a directory?
[ -z "$VAR" ]        # is variable empty?
[ -n "$VAR" ]        # is variable non-empty?
[ ! -d "$DIR" ]      # does directory NOT exist?
```

### Why remove `%` before comparing?
```sh
DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
# "52%" → 52
# -ge only works with numbers — "52%" is not a number!
```

---

## 3. For Loop

```sh
SERVERS="web1 web2 db1"
for server in $SERVERS; do
    echo "Checking: $server"
done
```

### Combining If-Else with For Loop
```sh
for server in $SERVERS; do
    if [ "$server" = "db1" ]; then
        echo "Database server!"
    else
        echo "Web server!"
    fi
done
```

### What is the `>` prompt?
```
for server in $SERVERS; do
>    echo "..."       ← terminal says "keep typing, command not complete yet"
> done
```
The command only runs after `done` is typed.

---

## 4. Functions

```sh
# Basic function
log() {
    echo "[$(date +%H:%M:%S)] $1"
}

log "Script started"    # → [02:20:11] Script started
```

### `$1` and `$2` — Arguments
```sh
log() {
    local LEVEL=$1    # first argument
    local MSG=$2      # second argument
    echo "[$(date '+%H:%M:%S')] [$LEVEL] $MSG"
}

log "INFO"  "Script started"   # $1=INFO  $2=Script started
log "ERROR" "Disk full"        # $1=ERROR $2=Disk full
log "OK"    "Backup done"      # $1=OK    $2=Backup done
```

### Why use `local`?
```sh
# With local — safe
log() {
    local LEVEL=$1    # only exists inside the function
}
echo $LEVEL           # blank — did not leak outside ✅

# Without local — dangerous
log() {
    LEVEL=$1          # becomes a global variable — leaks!
}
echo $LEVEL           # prints "INFO" — unintended side effect ❌
```

---

## 5. Script 1 — backup.sh

```sh
#!/bin/sh
SOURCE=${1:-"$HOME/devops/notes"}
BACKUP_DIR="$HOME/devops/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%H:%M:%S')] [$LEVEL] $MSG"
}

if [ ! -d "$SOURCE" ]; then
    log "ERROR" "Source not found"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname $SOURCE)" "$(basename $SOURCE)"
SIZE=$(du -sh "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
log "OK" "Backup done: $BACKUP_NAME ($SIZE)"
```

### Key Concepts
```
${1:-"default"}     →  if $1 not provided, use default value
! -d "$SOURCE"      →  if directory does not exist, throw error
exit 1              →  stop the script (exit code 1 = error)
tar -czf            →  create a compressed archive
tar -tzf            →  list contents without extracting
dirname /a/b/c      →  /a/b  (parent directory)
basename /a/b/c     →  c     (last component of path)
```

### Testing
```sh
chmod +x ~/devops/scripts/backup.sh
~/devops/scripts/backup.sh                    # backup default folder
~/devops/scripts/backup.sh ~/devops/scripts   # backup custom folder
tar -tzf ~/devops/backups/backup_*.tar.gz     # inspect contents
```

---

## 6. Script 2 — disk_alert.sh

```sh
#!/bin/sh
THRESHOLD=80
LOG_FILE="$HOME/devops/logs/disk_alert.log"
mkdir -p "$HOME/devops/logs"

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $MSG" | tee -a "$LOG_FILE"
}

log "INFO" "=== Disk Check Started ==="

for line in $(df -h | tail -n +2 | awk '{print $5"@"$6}'); do
    USAGE=$(echo "$line" | cut -d'@' -f1 | tr -d '%')
    MOUNT=$(echo "$line" | cut -d'@' -f2)

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
```

### Pipe Chain Breakdown
```
df -h                         →  full disk info
| tail -n +2                  →  skip the header line
| awk '{print $5"@"$6}'       →  Use%@MountPoint
| cut -d'@' -f1               →  everything before @ (Usage)
| tr -d '%'                   →  remove % sign
```

### `tee -a` explained
```
tee     →  print to screen AND save to file simultaneously
-a      →  append mode (do not overwrite existing content)
```

### `>>` vs `>`
```
>>  =  append   →  keep old content, add new at the end
 >  =  overwrite →  delete old content, write fresh
```

### Override threshold temporarily
```sh
THRESHOLD=40 ~/devops/scripts/disk_alert.sh
# only overrides for this one run — file is unchanged
```

### Alpine BusyBox issue — important!
```
pipe | while read line  →  creates a subshell in Alpine
                           variables set inside do not persist outside
for loop                →  runs in the same shell — works correctly ✅
```

---

## 7. Script 3 — log_cleaner.sh

```sh
#!/bin/sh
LOG_DIR=${1:-"$HOME/devops/logs"}
DAYS=${2:-7}

log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%H:%M:%S')] [$LEVEL] $MSG"
}

if [ ! -d "$LOG_DIR" ]; then
    log "ERROR" "Directory not found"
    exit 1
fi

BEFORE=$(find "$LOG_DIR" -name "*.log" | wc -l)
log "INFO" "Files before: $BEFORE"

find "$LOG_DIR" -name "*.log" -mtime +$DAYS | while read f; do
    log "DELETE" "$f"
done

find "$LOG_DIR" -name "*.log" -mtime +$DAYS -delete

AFTER=$(find "$LOG_DIR" -name "*.log" | wc -l)
log "INFO" "Files after: $AFTER"
```

### `find` command
```sh
find ~/devops/logs -name "*.log"              # find all .log files
find ~/devops/logs -name "*.log" -mtime +7    # older than 7 days
find ~/devops/logs -name "*.log" -mtime +7 -delete  # find and delete

-mtime +7  →  older than 7 days
-mtime -7  →  newer than 7 days
-mtime  7  →  exactly 7 days old

*      →  wildcard — matches anything
*.log  →  any file ending in .log
```

---

## Quick Reference

```
Variables:
  NAME="val"          →  store plain text
  VAR=$(command)      →  store command output
  ${1:-"default"}     →  use default if argument not provided
  " "                 →  variables are expanded
  ' '                 →  printed literally

If-Else:
  -ge -gt -le -lt -eq -ne   →  numeric comparisons
  = !=                       →  string comparisons
  ! -d "$DIR"                →  directory does not exist
  ! -f "$FILE"               →  file does not exist

Functions:
  $1 $2 $3   →  positional arguments
  local      →  keeps variable scoped to the function

Useful commands:
  tr -d '%'           →  remove % character
  awk '{print $5}'    →  extract 5th column
  tail -n +2          →  skip first line
  wc -l               →  count lines
  tee -a file         →  output to both screen and file
  cut -d'@' -f1       →  split by delimiter, get first field
  du -sh file         →  human-readable file size
  dirname /a/b/c      →  /a/b
  basename /a/b/c     →  c
```
