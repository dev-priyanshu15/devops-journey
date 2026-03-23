# 📅 Day 1 — Linux Basics + Shell Scripting
> **Date:** March 2026 | **Topic:** Linux Filesystem, Permissions, Vi Editor, Shell Scripts

---

## 🧠 Aaj kya seekha — Big Picture

Linux = ek ghar ka blueprint. Terminal = us ghar ka remote control.  
**90% of internet Linux pe chalta hai** — Google, Amazon, Netflix, Facebook — sab!

---

## 1️⃣ Linux Filesystem — Samajh

Windows mein hota hai:
```
C:\Users\Priyanshu\Documents\file.txt
```

Linux mein hota hai:
```
/root/devops/notes/day1.txt
```

### Tree structure:
```
/                    ← root (sabka baap, top level)
├── root/            ← root user ka ghar (hum yahan hain)
│   └── devops/      ← humara workspace
│       ├── scripts/ ← shell scripts
│       ├── docker/  ← docker files (aage seekhenge)
│       ├── k8s/     ← kubernetes (aage seekhenge)
│       └── notes/   ← notes
├── etc/             ← system config files
├── var/             ← logs, databases
├── home/            ← normal users ke ghar
└── bin/             ← programs/commands yahan hote hain
```

### Important shortcuts:
```
~   = tere ghar ka shortcut (/root agar root user hai)
.   = current folder
..  = ek upar wala folder
```

---

## 2️⃣ Basic Commands

### Navigation:
```bash
whoami        # main kaun hoon? → root
pwd           # main kahan hoon? → /root
ls            # yahan kya kya hai?
ls -la        # detail mein dikhao (hidden files bhi)
cd /etc       # /etc folder mein jao
cd ~          # ghar wapas jao
cd ..         # ek upar jao
```

### Files + Folders:
```bash
mkdir -p ~/devops/scripts ~/devops/notes   # folders banao (-p = parent bhi bana)
touch file.txt                              # khali file banao
rm file.txt                                 # file delete karo
rm -rf folder/                              # folder delete karo (careful!)
cp file.txt backup.txt                      # copy karo
mv file.txt newname.txt                     # rename/move karo
```

### File padhna + likhna:
```bash
echo "Hello" > file.txt     # file mein likho (OVERWRITE karta hai!)
echo "Hello" >> file.txt    # file mein ADD karo (overwrite nahi)
cat file.txt                # file padho
```

> ⚠️ **Important:** `>` = overwrite (pehle wala delete!), `>>` = append (add karo)

---

## 3️⃣ Permissions — INTERVIEW MEIN 100% POOCHHA JAATA HAI

### Formula yaad karo:
```
r = read    = 4
w = write   = 2
x = execute = 1
- = nothing = 0
```

### Calculate kaise karte hain:
```
rwx = 4+2+1 = 7   (sab kuch)
rw- = 4+2+0 = 6   (read + write)
r-x = 4+0+1 = 5   (read + execute)
r-- = 4+0+0 = 4   (sirf read)
--- = 0+0+0 = 0   (kuch nahi)
```

### 3 owners hote hain:
```
chmod 755 file.sh
       ↑↑↑
       |||
       ||└── Others: r-x (5) = read + execute
       |└─── Group:  r-x (5) = read + execute
       └──── Owner:  rwx (7) = sab kuch
```

### Common permissions:
| Number | Permission | Kab use karein |
|--------|-----------|----------------|
| **777** | rwxrwxrwx | DANGEROUS — kabhi mat use karo production mein! |
| **755** | rwxr-xr-x | Scripts aur folders |
| **644** | rw-r--r-- | Normal text files |
| **600** | rw------- | Private files (SSH keys!) |
| **400** | r-------- | Read-only, super private |

### ls -la output padhna:
```
-rw-r--r--    1 root  root   34  Mar 19  day1.txt
↑↑↑↑↑↑↑↑↑↑
||└──────── Others permissions (r--)
|└──────── Group permissions  (r--)
└──────── Owner permissions  (rw-)
 ↑
 - = file, d = directory
```

### chmod commands:
```bash
chmod +x script.sh          # execute permission add karo
chmod 755 script.sh         # rwxr-xr-x set karo
chmod 644 file.txt          # rw-r--r-- set karo
chmod 600 ~/.ssh/id_rsa     # private key ke liye
```

---

## 4️⃣ Vi Editor — Asli DevOps Editor

> Nano = beginner ka editor. Vi = **har server pe available, production ka real editor!**

### 2 Modes samajh:
```
NORMAL mode  →  commands dete hain (default jab khulta hai)
INSERT mode  →  text likhte hain
```

### Basic workflow:
```
vi filename.sh    # file kholo

i                 # INSERT mode mein jao (likhna shuru)
[kaam karo]
Esc               # NORMAL mode mein wapas

:wq               # write + quit (save karke bahar)
:q!               # quit without save (changes discard)
:w                # sirf save karo, bahar mat jao
```

### Useful Normal mode commands:
```
dd        # poori line delete karo
yy        # poori line copy karo (yank)
p         # paste karo
u         # undo
gg        # file ke start pe jao
G         # file ke end pe jao
/text     # text search karo
```

---

## 5️⃣ Shell Script — Concepts

### Shebang line:
```bash
#!/bin/bash   # bash se run karo (Alpine mein install karna padta hai)
#!/bin/sh     # default shell se run karo (Alpine mein hamesha available)
```

### Command Substitution `$()`:
```bash
echo "User: $(whoami)"
# $(whoami) pehle run hoga → "root" aayega → echo "User: root"
```

Analogy: Sentence mein blank fill karna —
"Mera naam ___ hai" → blank mein command ka result!

### Pipe `|`:
```bash
free -h | awk '/^Mem:/{print $2}'
# free -h ka output → awk ko milta hai → awk filter karta hai
```

Analogy: Factory mein conveyor belt — ek machine ka output doosri machine ko!

### AWK — table se data nikalo:
```bash
df -h / | awk 'NR==2{print $4}'
# NR==2 = 2nd line lo (header skip)
# $4    = 4th column lo
```

```
Filesystem  Size  Used  Avail  Use%
/dev/sdb    1007G  51G  955G    6%
  $1         $2    $3    $4     $5
```

---

## 6️⃣ Aaj ke Scripts

### system_info.sh:
```bash
#!/bin/bash
echo "=== System Info ==="
echo "User: $(whoami)"
echo "CPU: $(nproc) cores"
echo "RAM: $(free -h | awk '/^Mem:/{print $2}')"
echo "Disk: $(df -h / | awk 'NR==2{print $4}') free"
echo "IP: $(hostname -i)"
```

### my_info.sh:
```bash
#!/bin/sh
echo "=== My Info ==="
echo "Date: $(date)"
echo "Uptime: $(uptime)"
echo "Kernel: $(uname -r)"
```

### Script run karne ka flow:
```bash
vi script.sh          # 1. likho
chmod +x script.sh    # 2. execute permission do
./script.sh           # 3. run karo
```

---

## 7️⃣ Alpine Linux — Special Notes

> Tu **Alpine Linux** use kar raha hai — Ubuntu nahi! Kuch differences hain:

```
Ubuntu/Debian    →  apt install package
Alpine           →  apk add package

#!/bin/bash      →  Alpine mein manually install: apk add bash
#!/bin/sh        →  Alpine mein hamesha available (ash shell)

hostname -I      →  Ubuntu mein kaam karta hai
hostname -i      →  Alpine mein yeh use karo
```

---

## 8️⃣ Git — Setup aur Pehla Commit

```bash
# Config
git config --global user.name "Priyanshu"
git config --global user.email "your@email.com"

# Pehla repo setup
git init
git add .
git commit -m "feat: day 1 scripts"
git branch -M main
git remote add origin https://github.com/dev-priyanshu15/devops-journey.git
git push -u origin main
```

### Har command ka matlab:
```
git init          →  folder ko git tracking zone banao
git add .         →  sab files commit ke liye stage karo
git commit -m ""  →  snapshot lo — save point!
git push          →  local → GitHub pe bhejo
```

---

## ✅ Day 1 Checklist

- [x] Linux filesystem samjha
- [x] Basic commands — ls, cd, mkdir, echo, cat
- [x] `>` vs `>>` difference
- [x] Permissions — rwx = 4,2,1
- [x] chmod — numbers calculate karna
- [x] ls -la output padhna
- [x] Vi editor — modes samjha
- [x] Shebang line — `#!/bin/sh`
- [x] Command substitution — `$()`
- [x] Pipe operator — `|`
- [x] AWK basics — NR, $1 $2 $3
- [x] system_info.sh banaya aur run kiya
- [x] Alpine vs Ubuntu difference samjha
- [x] Git setup + pehla commit

---

## 🎯 Interview Questions — Day 1

**Q: chmod 755 ka matlab kya hai?**
> 7=rwx (owner), 5=r-x (group), 5=r-x (others). Owner sab kuch kar sakta hai, baaki read+execute kar sakte hain.

**Q: `>` aur `>>` mein kya difference hai?**
> `>` overwrite karta hai — pehle ka content delete. `>>` append karta hai — add karta hai neeche.

**Q: Shebang line kya hoti hai?**
> `#!/bin/bash` — OS ko batati hai ki yeh script kis program se run karo. `#!` = shebang.

**Q: SSH private key pe kaunsa permission lagaate hain?**
> `chmod 600` — sirf owner padh+likh sakta hai. Agar zyada open hogi toh SSH connect nahi karega!

---

> 💡 **Kal — Day 2:** Processes + Networking (ps, kill, curl, netstat, cron)
