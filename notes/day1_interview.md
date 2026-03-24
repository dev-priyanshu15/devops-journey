# 🎯 Day 1 — Interview Questions & Answers
> **Topic:** Linux Basics, Permissions, Shell Scripting

---

## Q1: What does chmod 644 mean?

**Answer:**
```
6 = rw-  → Owner  : read + write
4 = r--  → Group  : read only
4 = r--  → Others : read only
```
Owner can read and write. Group and Others can only read.

**Real world use:** Normal text files, config files.

---

## Q2: What is the difference between `>` and `>>`?

**Answer:**
```
>   = overwrite  → deletes previous content, writes new
>>  = append     → adds below existing content, nothing deleted
```

**Example:**
```bash
echo "line 1" > file.txt   # file has only "line 1"
echo "line 2" >> file.txt  # file now has "line 1" and "line 2"
```

**Real world use:** Server logs always use `>>` — history should never be deleted!

---

## Q3: What does `$(nproc)` do?

**Answer:**

`$()` is called **Command Substitution** — it runs the command inside and puts the output in its place.

```bash
echo "CPU cores: $(nproc)"
# nproc runs first → returns 16
# echo "CPU cores: 16" runs
```

Think of it as a fill-in-the-blank — the blank gets filled with the command's output.

---

## Q4: How do you save and exit in Vi editor?

**Answer:**
```
1. Press i        → go to INSERT mode, write your script
2. Press Esc      → go back to NORMAL mode
3. Type :wq       → write (save) + quit (exit)
4. Press Enter
```

**Other Vi commands:**
```
:q!   → quit without saving
:w    → save only, don't exit
```

---

## Q5: What does the pipe operator `|` do?

**Answer:**

Pipe takes the output of one command and passes it as input to the next command.

**Best analogy — Deck of Cards:**
```
Full deck of cards  =  complete output of first command
        |
        | (pipe)
        |
Ace of Spade only   =  filtered output from second command
```

**Real example:**
```bash
ps aux | grep node
# ps aux    = full list of ALL processes (full deck)
# |         = pass that list to grep
# grep node = filter only "node" processes (ace of spade)
```

```bash
free -h | awk '/^Mem:/{print $2}'
# free -h   = full RAM info table
# |         = pass to awk
# awk       = extract only total RAM value
```

---

## Q6: What does chmod 755 mean?

**Answer:**
```
7 = rwx  → Owner  : read + write + execute
5 = r-x  → Group  : read + execute
5 = r-x  → Others : read + execute
```

**Real world use:** Shell scripts and folders — everyone can run it, only owner can edit.

---

## Q7: What permission should SSH private key have and why?

**Answer:**
```bash
chmod 600 ~/.ssh/id_rsa
```

```
6 = rw-  → Owner  : read + write
0 = ---  → Group  : nothing
0 = ---  → Others : nothing
```

**Why?** If permissions are too open (like 644 or 777), SSH will refuse to connect and give this error:
```
WARNING: UNPROTECTED PRIVATE KEY FILE!
Permissions are too open
```

---

## Q8: What is a Shebang line?

**Answer:**

`#!/bin/sh` — the first line of every shell script. It tells the OS which program to use to run this script.

```bash
#!/bin/bash        → run with bash
#!/bin/sh          → run with default shell
#!/usr/bin/python3 → run with Python
```

**Important:** On Alpine Linux, always use `#!/bin/sh` because bash is not installed by default!

---

## Q9: What is the difference between `.` and `..` in Linux?

**Answer:**
```
.   = current directory (where you are right now)
..  = parent directory (one level up)
```

```bash
cd .    # stay in same folder
cd ..   # go one level up
cd ../.. # go two levels up
```

---

## Q10: What does `ls -la` show?

**Answer:**

`ls -la` shows detailed list of all files including hidden files.

```
-rw-r--r--  1  root  root  34  Mar 19  day1.txt
↑↑↑↑↑↑↑↑↑↑  ↑   ↑     ↑    ↑    ↑        ↑
│└─────────  │   │     │    │    │         └── filename
│            │   │     │    │    └──────────── date modified  
│            │   │     │    └───────────────── file size
│            │   │     └────────────────────── group owner
│            │   └──────────────────────────── user owner
│            └──────────────────────────────── number of links
└───────────────────────────────────────────── permissions
```

**First character:**
```
-  = file
d  = directory
l  = symbolic link
```

---

## Q11: What is AWK and when do you use it?

**Answer:**

AWK is a text processing tool — it extracts specific columns from table-like output.

```bash
df -h / | awk 'NR==2{print $4}'
```

```
NR==2    = take line number 2 (skip header line 1)
$4       = take 4th column

Filesystem  Size  Used  Avail  Use%
/dev/sdb    1007G  51G  955G    6%
  $1         $2    $3    $4     $5
```

---

## Q12: What is the difference between Alpine Linux and Ubuntu?

**Answer:**

| Feature | Ubuntu | Alpine |
|---------|--------|--------|
| Size | ~2GB | ~5MB |
| Package manager | apt | apk |
| Default shell | bash | ash |
| Use case | Development, desktop | Docker containers, servers |
| Shebang | #!/bin/bash | #!/bin/sh |

**Why Alpine in DevOps?** Docker containers use Alpine because small size = faster deployment!

---

## 🔢 Permission Calculator — Quick Reference

| Number | Binary | Permission |
|--------|--------|-----------|
| 7 | 111 | rwx |
| 6 | 110 | rw- |
| 5 | 101 | r-x |
| 4 | 100 | r-- |
| 3 | 011 | -wx |
| 2 | 010 | -w- |
| 1 | 001 | --x |
| 0 | 000 | --- |

**Formula:** r=4, w=2, x=1 → add them up!

---

> 💡 **Tomorrow — Day 2 Interview Questions:** Processes (ps, kill), Networking (curl, ping, netstat), Cron jobs
