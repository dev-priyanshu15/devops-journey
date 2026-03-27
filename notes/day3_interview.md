# Day 3 — Shell Scripting Interview Questions

---

## Q1. `NAME="Priyanshu"` aur `NAME=$(command)` mein kya fark hai?

**Answer:**
```
NAME="Priyanshu"     →  plain text directly store karta hai
NAME=$(date)         →  pehle command chalti hai, uska output store hota hai

Rule:
  plain value hai     →  =" "  use karo
  command ka output   →  $()   use karo
```

---

## Q2. Double quotes `" "` aur single quotes `' '` mein kya fark hai?

**Answer:**
```sh
NAME="Priyanshu"

echo "$NAME is learning"   →  Priyanshu is learning  (variable expand hua)
echo '$NAME is learning'   →  $NAME is learning       (literally print hua)
```
```
" "  →  variables expand hote hain
' '  →  kuch bhi expand nahi hota — literal print
```

Real world use:
```sh
echo "Hello $USER"       # variable chahiye     → double quotes
echo 'Price is $50'      # literal $ chahiye    → single quotes
```

---

## Q3. Linux mein variables case-sensitive kyun hote hain?

**Answer:**
```sh
name="abc"
NAME="xyz"

echo $name   →  abc
echo $NAME   →  xyz
# dono alag variables hain — Linux exact match karta hai
```

Common mistake — `$name` likhna jab set `$NAME` kiya ho → blank output aata hai.

---

## Q4. Numbers aur strings compare karne ke operators alag kyun hote hain?

**Answer:**
```
Numbers:   -eq -ne -gt -lt -ge -le
Strings:   =   !=

# Kyunki:
[ "10" -gt "9" ]   →  correct  (numeric: 10 > 9)
[ "10" > "9"  ]    →  WRONG    (string: "1" < "9" alphabetically)
```

Galat operator use kiya toh wrong result ya error aata hai!

---

## Q5. `[ ! -d "$DIR" ]` mein `!` aur `-d` kya karte hain?

**Answer:**
```sh
-d "$DIR"    →  kya directory exist karti hai?
! -d "$DIR"  →  kya directory exist NAHI karti?

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"   # nahi thi toh banao
fi
```
```
-f  →  file exist karti hai?
-d  →  directory exist karti hai?
-z  →  variable empty hai?
-n  →  variable non-empty hai?
!   →  condition ko reverse karo (NOT)
```

---

## Q6. `local` keyword functions mein kyun use karte hain?

**Answer:**
```sh
# local ke bina — global leak
process() {
    STATUS="running"    # global ho gaya!
}
process
echo $STATUS    # "running" — unexpected!

# local ke saath — safe
process() {
    local STATUS="running"   # sirf function ke andar
}
process
echo $STATUS    # blank — leak nahi hua ✅
```

Production scripts mein hamesha `local` use karo — naming conflicts aur bugs avoid hote hain.

---

## Q7. `$1`, `$2`, `$#`, `$@` kya hote hain?

**Answer:**
```sh
./script.sh staging v1.2.3

$0   →  script ka naam  (./script.sh)
$1   →  pehla argument  (staging)
$2   →  doosra argument (v1.2.3)
$#   →  total arguments (2)
$@   →  saare arguments ("staging" "v1.2.3")
```

Real world use:
```sh
if [ $# -eq 0 ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
```

---

## Q8. `${1:-"default"}` ka kya matlab hai?

**Answer:**
```sh
SOURCE=${1:-"$HOME/devops/notes"}

# Agar $1 diya     →  $1 use karo
# Agar $1 nahi diya →  "$HOME/devops/notes" use karo

./backup.sh /tmp/logs   →  SOURCE = /tmp/logs
./backup.sh             →  SOURCE = /root/devops/notes
```

Yeh scripts ko flexible banata hai — arguments optional ho jaate hain.

---

## Q9. `tar` ke flags kya karte hain?

**Answer:**
```
tar -czf archive.tar.gz folder/    →  compress karke banao
tar -tzf archive.tar.gz            →  contents list karo (extract nahi)
tar -xzf archive.tar.gz            →  extract karo

-c  →  create
-x  →  extract
-t  →  list contents
-z  →  gzip compression use karo
-f  →  file ka naam specify karo

-C /path   →  is directory mein jaake kaam karo
```

---

## Q10. `dirname` aur `basename` kya karte hain?

**Answer:**
```sh
dirname  /root/devops/notes   →  /root/devops   (parent folder)
basename /root/devops/notes   →  notes          (last part)

# backup.sh mein use:
tar -czf backup.tar.gz \
    -C "$(dirname $SOURCE)" \   # parent mein jaao
    "$(basename $SOURCE)"        # sirf folder compress karo
# Result: relative path se backup — extract karne pe sahi structure milta hai
```

---

## Q11. `tee -a` kya karta hai aur `>>` se kaise alag hai?

**Answer:**
```sh
echo "message" >> file.log          # sirf file mein save hoga
echo "message" | tee -a file.log    # screen pe bhi dikhega + file mein bhi

tee     →  output ko do jagah bhejta hai (screen + file)
-a      →  append mode (overwrite nahi karta)
```

Real world mein `tee` use karo jab live monitoring bhi chahiye aur logs bhi!

---

## Q12. `df -h` ka output parse kaise karte hain?

**Answer:**
```sh
df -h | tail -n +2 | awk '{print $5"@"$6}'

tail -n +2          →  header line skip karo
awk '{print $5}'    →  5th column nikalo (Use%)
awk '{print $5,$6}' →  5th aur 6th column nikalo
tr -d '%'           →  % sign hatao (numeric comparison ke liye)
cut -d'@' -f1       →  @ se split karo, pehla part lo
```

---

## Q13. Alpine mein `while read line` pipe ke saath kyun kaam nahi karta?

**Answer:**
```sh
# PROBLEM — Alpine BusyBox mein
df -h | while read line; do
    THRESHOLD=40    # subshell mein set hua
done
echo $THRESHOLD     # blank! — subshell khatam, variable gaya

# SOLUTION — for loop use karo
for line in $(df -h | awk '{print $5"@"$6}'); do
    USAGE=$(echo "$line" | cut -d'@' -f1)
done
echo $USAGE   # works! same shell mein tha ✅
```

Alpine ka BusyBox sh — pipe ke baad `while` ek subshell mein chalaata hai. Variables us subshell se bahar nahi jaate.

---

## Q14. `find` command ke important flags kya hain?

**Answer:**
```sh
find /path -name "*.log"          # naam se dhundho
find /path -name "*.log" -mtime +7  # 7 din se purani
find /path -name "*.log" -mtime -1  # 1 din se nayi
find /path -name "*.log" -delete    # dhundho + delete karo
find /path -type f                  # sirf files
find /path -type d                  # sirf directories

-mtime +7  →  strictly older than 7 days
-mtime -7  →  strictly newer than 7 days
-mtime  7  →  exactly 7 days old
```

---

## Q15. `exit 1` aur `exit 0` mein kya fark hai?

**Answer:**
```sh
exit 0   →  success — sab theek tha
exit 1   →  failure — kuch galat hua

# Check karo last command successful tha ya nahi:
$?   →  last command ka exit code

./backup.sh
echo $?   # 0 = success, 1 = failure
```

Real world mein CI/CD pipelines exit codes check karti hain — agar script `exit 1` karti hai toh pipeline rok deti hai!

---

## Q16. `case` statement kab use karte hain?

**Answer:**
```sh
case "$USAGE" in
    ''|*[!0-9]*) continue ;;   # empty ya non-numeric → skip
    *) ;;                       # baaki sab — process karo
esac
```

`case` use karo jab:
- Ek variable ke multiple possible values check karni hon
- if-elif-elif bahut lamba ho jaaye
- Pattern matching chahiye

```sh
case "$ENV" in
    prod)    echo "Production" ;;
    staging) echo "Staging" ;;
    dev)     echo "Development" ;;
    *)       echo "Unknown" ;;
esac
```

---

## Q17. Production script mein kaunsi best practices follow karte hain?

**Answer:**
```sh
#!/bin/sh
set -e              # koi bhi command fail ho → script band ho

# Config upar rakhो — easy to change
THRESHOLD=80
LOG_FILE="$HOME/devops/logs/app.log"

# Logging function — hamesha timestamp ke saath
log() {
    local LEVEL=$1
    local MSG=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $MSG" | tee -a "$LOG_FILE"
}

# Input validate karo
if [ -z "$1" ]; then
    log "ERROR" "Usage: $0 <argument>"
    exit 1
fi

# local variables functions mein
process() {
    local INPUT=$1
    # ...
}
```

Best practices:
```
1. set -e              →  fail fast — silent errors nahi
2. Config top pe       →  easy maintenance
3. log() function      →  consistent timestamps
4. Input validation    →  garbage in garbage out avoid karo
5. local variables     →  no side effects
6. exit codes          →  CI/CD ke saath kaam karta hai
```
