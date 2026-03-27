# Day 3 — Shell Scripting Deep Dive (Hinglish Notes)

---

## 1. Variables

Variable = ek labelled dabba jisme value rakhte ho.

```sh
# Plain value store karna
NAME="Priyanshu"
AGE=21

# Command ka output store karna
TODAY=$(date +%Y-%m-%d)
DISK=$(df -h / | awk 'NR==2 {print $5}')
```

### `=" "` vs `$()`
```
NAME="Priyanshu"       →  plain text hai — seedha store karo
TODAY=$(date)          →  pehle command chali, output store hua
```

### `" "` vs `' '`
```sh
echo "$NAME is learning DevOps"   →  Priyanshu is learning DevOps
echo '$NAME is learning DevOps'   →  $NAME is learning DevOps
```
```
" "  =  variables expand hote hain  ($NAME → value)
' '  =  literally jo likha woh print hota hai
```

### Case Sensitive!
```sh
name="abc"
NAME="xyz"
# dono alag variables hain — ek doosre ko overwrite nahi karte
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

### File Checks
```sh
[ -f /etc/passwd ]   # file exist karta hai?
[ -d /tmp ]          # directory hai?
[ -z "$VAR" ]        # variable empty hai?
[ -n "$VAR" ]        # variable non-empty hai?
```

### `%` sign hatana zaroori kyun?
```sh
DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
# "52%" → 52
# -ge sirf numbers compare karta hai — "52%" number nahi hai!
```

---

## 3. For Loop

```sh
SERVERS="web1 web2 db1"
for server in $SERVERS; do
    echo "Checking: $server"
done
```

### If-Else + For Loop combine
```sh
for server in $SERVERS; do
    if [ "$server" = "db1" ]; then
        echo "Database server!"
    else
        echo "Web server!"
    fi
done
```

### `> ` prompt kya hota hai?
```
for server in $SERVERS; do
>    echo "..."       ← terminal bol raha hai "aage likho"
> done                   command abhi complete nahi hui
```

---

## 4. Functions

```sh
# Basic function
log() {
    echo "[$(date +%H:%M:%S)] $1"
}

log "Script started"    # → [02:20:11] Script started
```

### `$1` aur `$2` — Arguments
```sh
log() {
    local LEVEL=$1    # pehla argument
    local MSG=$2      # doosra argument
    echo "[$(date '+%H:%M:%S')] [$LEVEL] $MSG"
}

log "INFO"  "Script started"   # $1=INFO  $2=Script started
log "ERROR" "Disk full"        # $1=ERROR $2=Disk full
log "OK"    "Backup done"      # $1=OK    $2=Backup done
```

### `local` kyun?
```sh
# local ke saath — safe
log() {
    local LEVEL=$1    # sirf function ke andar
}
echo $LEVEL           # blank — bahar nahi gaya ✅

# local ke bina — dangerous
log() {
    LEVEL=$1          # global ho gaya — leak!
}
echo $LEVEL           # "INFO" print hoga ❌
```

---

## 5. Script 1 — backup.sh

```sh
#!/bin/sh
SOURCE=${1:-"$HOME/devops/notes"}    # default value
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

### Important concepts:
```
${1:-"default"}     →  $1 nahi diya toh default use karo
! -d "$SOURCE"      →  directory nahi mili toh error do
exit 1              →  script band karo (error code 1)
tar -czf            →  compress karke file banao
tar -tzf            →  andar dekho bina extract kiye
dirname /a/b/c      →  /a/b  (parent folder)
basename /a/b/c     →  c     (folder ka naam)
```

### Test karna:
```sh
chmod +x ~/devops/scripts/backup.sh
~/devops/scripts/backup.sh                    # default folder
~/devops/scripts/backup.sh ~/devops/scripts   # custom folder
tar -tzf ~/devops/backups/backup_*.tar.gz     # andar dekho
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

### Pipe chain samajh:
```
df -h                         →  saara disk info
| tail -n +2                  →  header line skip karo
| awk '{print $5"@"$6}'       →  Use% @ MountPoint
| cut -d'@' -f1               →  @ se pehle wala (Usage)
| tr -d '%'                   →  % sign hatao
```

### `tee -a` kya karta hai:
```
tee     →  screen pe bhi print karo + file mein bhi save karo
-a      →  append karo (overwrite mat karo)
```

### `>>` vs `>`:
```
>>  =  append   →  purana rakho, naya add karo
 >  =  overwrite →  purana delete, naya likho
```

### Temporarily threshold change:
```sh
THRESHOLD=40 ~/devops/scripts/disk_alert.sh
# sirf iss ek run ke liye — file nahi badli
```

### Alpine BusyBox bug — important!
```
while read line (pipe mein) → subshell banta hai Alpine mein
                              variables bahar leak nahi hote
for loop use karo           → same shell mein chalta hai ✅
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

### `find` command:
```sh
find ~/devops/logs -name "*.log"           # dhundho
find ~/devops/logs -name "*.log" -mtime +7 # 7 din purani
find ~/devops/logs -name "*.log" -mtime +7 -delete  # dhundho + delete

-mtime +7  →  7 din se purani
-mtime -7  →  7 din se nayi
-mtime  7  →  exactly 7 din purani

*  →  wildcard — kuch bhi match karo
*.log  →  koi bhi .log file
```

---

## Quick Reference

```
Variables:
  NAME="val"          →  plain text store
  VAR=$(command)      →  command output store
  ${1:-"default"}     →  argument nahi mila toh default
  " "                 →  variables expand hote hain
  ' '                 →  literally print hota hai

If-Else:
  -ge -gt -le -lt -eq -ne   →  numbers
  = !=                       →  strings
  ! -d "$DIR"                →  directory nahi hai
  ! -f "$FILE"               →  file nahi hai

Functions:
  $1 $2 $3   →  arguments
  local      →  variable andar hi rahega

Useful commands:
  tr -d '%'           →  % sign hatao
  awk '{print $5}'    →  5th column nikalo
  tail -n +2          →  pehli line skip karo
  wc -l               →  lines count karo
  tee -a file         →  screen + file dono mein
  cut -d'@' -f1       →  delimiter se split karo
  du -sh file         →  file size dekho
  dirname /a/b/c      →  /a/b
  basename /a/b/c     →  c
```
