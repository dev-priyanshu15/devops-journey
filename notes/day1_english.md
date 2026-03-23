# 📅 Day 1 — Linux Basics + Shell Scripting
> **Date:** March 2026 | **Topic:** Linux Filesystem, Permissions, Vi Editor, Shell Scripts

---

## 🧠 Big Picture — What is Linux?

Linux is an operating system just like Windows — but it runs **90% of the internet.**  
Google, Amazon, Netflix, Facebook — all their servers run on Linux.

**Terminal** = talking to the OS by typing instead of clicking.  
**WSL** = a Linux room inside Windows — you get the best of both worlds.

---

## 1️⃣ Linux Filesystem

Windows path:
```
C:\Users\Priyanshu\Documents\file.txt
```

Linux path:
```
/root/devops/notes/day1.txt
```

### Directory Tree:
```
/                    ← root (top level, parent of everything)
├── root/            ← home of root user (we are here)
│   └── devops/      ← our workspace
│       ├── scripts/ ← shell scripts
│       ├── docker/  ← docker files (coming soon)
│       ├── k8s/     ← kubernetes (coming soon)
│       └── notes/   ← notes
├── etc/             ← system configuration files
├── var/             ← logs, databases
├── home/            ← home for normal users
└── bin/             ← programs and commands live here
```

### Important Shortcuts:
```
~    = shortcut for your home directory (/root for root user)
.    = current directory
..   = parent directory (one level up)
```

---

## 2️⃣ Basic Commands

### Navigation:
```bash
whoami        # who am I? → root
pwd           # where am I? → /root (Print Working Directory)
ls            # what is here?
ls -la        # detailed list (including hidden files)
cd /etc       # go to /etc folder
cd ~          # go back home
cd ..         # go one level up
```

### Files + Folders:
```bash
mkdir -p ~/devops/scripts ~/devops/notes   # create folders (-p = create parents too)
touch file.txt                              # create empty file
rm file.txt                                 # delete file
rm -rf folder/                              # delete folder (be careful!)
cp file.txt backup.txt                      # copy file
mv file.txt newname.txt                     # rename or move file
```

### Reading + Writing Files:
```bash
echo "Hello" > file.txt     # write to file (OVERWRITES existing content!)
echo "Hello" >> file.txt    # append to file (adds below, no overwrite)
cat file.txt                # read and print file content
```

> ⚠️ **Critical:** `>` = overwrite (deletes previous content!), `>>` = append (adds to existing)

---

## 3️⃣ Permissions — 100% Asked in Interviews

### The Formula:
```
r = read    = 4
w = write   = 2
x = execute = 1
- = nothing = 0
```

### How to Calculate:
```
rwx = 4+2+1 = 7   (full access)
rw- = 4+2+0 = 6   (read + write)
r-x = 4+0+1 = 5   (read + execute)
r-- = 4+0+0 = 4   (read only)
--- = 0+0+0 = 0   (no access)
```

### 3 Owners:
```
chmod 755 file.sh
       ↑↑↑
       |||
       ||└── Others: r-x (5) = read + execute
       |└─── Group:  r-x (5) = read + execute
       └──── Owner:  rwx (7) = full access
```

### Common Permissions:
| Number | Permission | When to use |
|--------|-----------|-------------|
| **777** | rwxrwxrwx | DANGEROUS — never use in production! |
| **755** | rwxr-xr-x | Scripts and folders |
| **644** | rw-r--r-- | Normal text files |
| **600** | rw------- | Private files (SSH keys!) |
| **400** | r-------- | Read-only, super private |

### Reading `ls -la` Output:
```
-rw-r--r--    1 root  root   34  Mar 19  day1.txt
↑↑↑↑↑↑↑↑↑↑
||└──────── Others permissions (r--)
|└──────── Group permissions  (r--)
└──────── Owner permissions  (rw-)
 ↑
 - = file, d = directory
```

### chmod Commands:
```bash
chmod +x script.sh          # add execute permission
chmod 755 script.sh         # set rwxr-xr-x
chmod 644 file.txt          # set rw-r--r--
chmod 600 ~/.ssh/id_rsa     # for private SSH keys
```

---

## 4️⃣ Vi Editor — The Real DevOps Editor

> Nano = beginner's editor. Vi = **available on every server, the production editor!**

### 2 Modes:
```
NORMAL mode  →  for commands (default when Vi opens)
INSERT mode  →  for typing text
```

### Basic Workflow:
```
vi filename.sh    # open file

i                 # go to INSERT mode (start typing)
[do your work]
Esc               # go back to NORMAL mode

:wq               # write + quit (save and exit)
:q!               # quit without saving (discard changes)
:w                # save only, don't exit
```

### Useful Normal Mode Commands:
```
dd        # delete entire line
yy        # copy entire line (yank)
p         # paste
u         # undo
gg        # go to start of file
G         # go to end of file
/text     # search for text
```

---

## 5️⃣ Shell Script — Core Concepts

### Shebang Line:
```bash
#!/bin/bash   # run with bash (needs manual install on Alpine)
#!/bin/sh     # run with default shell (always available on Alpine)
```

### Command Substitution `$()`:
```bash
echo "User: $(whoami)"
# $(whoami) runs first → returns "root" → echo "User: root"
```

Think of it as a fill-in-the-blank:  
**"My name is ___"** → the blank gets filled with the command's output!

### Pipe Operator `|`:
```bash
free -h | awk '/^Mem:/{print $2}'
# output of free -h → passed to awk → awk filters it
```

Like a factory conveyor belt — output of one machine goes directly into the next!

### AWK — Extract Data from Tables:
```bash
df -h / | awk 'NR==2{print $4}'
# NR==2 = take 2nd line (skip header)
# $4    = take 4th column
```

```
Filesystem  Size  Used  Avail  Use%
/dev/sdb    1007G  51G  955G    6%
  $1         $2    $3    $4     $5
```

---

## 6️⃣ Scripts Written Today

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

### Script Execution Flow:
```bash
vi script.sh          # 1. write the script
chmod +x script.sh    # 2. give execute permission
./script.sh           # 3. run it
```

---

## 7️⃣ Alpine Linux — Special Notes

> You are using **Alpine Linux** — not Ubuntu! Some key differences:

```
Ubuntu/Debian    →  apt install package
Alpine           →  apk add package

#!/bin/bash      →  needs manual install on Alpine: apk add bash
#!/bin/sh        →  always available on Alpine (ash shell)

hostname -I      →  works on Ubuntu
hostname -i      →  use this on Alpine
```

---

## 8️⃣ Git — Setup and First Commit

```bash
# Configure identity
git config --global user.name "Priyanshu"
git config --global user.email "your@email.com"

# First repo setup
git init
git add .
git commit -m "feat: day 1 scripts and notes"
git branch -M main
git remote add origin https://github.com/dev-priyanshu15/devops-journey.git
git push -u origin main
```

### What Each Command Does:
```
git init          →  make this folder a git tracking zone
git add .         →  stage all files for commit
git commit -m ""  →  take a snapshot — save point!
git push          →  send local → GitHub
```

---

## ✅ Day 1 Checklist

- [x] Linux filesystem understood
- [x] Basic commands — ls, cd, mkdir, echo, cat
- [x] `>` vs `>>` difference
- [x] Permissions — rwx = 4, 2, 1
- [x] chmod — calculating numbers
- [x] Reading ls -la output
- [x] Vi editor — modes understood
- [x] Shebang line — `#!/bin/sh`
- [x] Command substitution — `$()`
- [x] Pipe operator — `|`
- [x] AWK basics — NR, $1 $2 $3
- [x] Created and ran system_info.sh
- [x] Alpine vs Ubuntu differences
- [x] Git setup + first commit

---

## 🎯 Interview Questions — Day 1

**Q: What does chmod 755 mean?**
> 7=rwx (owner has full access), 5=r-x (group can read+execute), 5=r-x (others can read+execute).

**Q: What is the difference between `>` and `>>`?**
> `>` overwrites the file — previous content is deleted. `>>` appends — adds below existing content.

**Q: What is a shebang line?**
> `#!/bin/bash` — tells the OS which program to use to run this script. `#!` is called shebang.

**Q: What permission should an SSH private key have?**
> `chmod 600` — only the owner can read and write. If permissions are too open, SSH will refuse to connect!

**Q: What is the difference between `.` and `..` in Linux?**
> `.` = current directory. `..` = parent directory (one level up).

---

> 💡 **Tomorrow — Day 2:** Processes + Networking (ps, kill, curl, netstat, cron)
