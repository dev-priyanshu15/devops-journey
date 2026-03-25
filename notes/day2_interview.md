# 🎯 Day 2 — Interview Questions & Answers
> **Topic:** Processes, Networking, curl, DNS, Ports, Cron

---

## Q1: What is a Process and what is PID?

**Answer:**
A process is any running program in Linux. Every process gets a unique **PID (Process ID)** — like an Aadhaar number.

```
Program runs   →  Process created  →  PID assigned
Work finishes  →  Process exits    →  PID freed
```

**Real world:** Chrome, VS Code, your shell — all are separate processes with unique PIDs.

---

## Q2: What is the difference between kill -15 and kill -9?

**Answer:**
```
kill -15  =  SIGTERM — graceful stop
             Process saves data and exits cleanly
             Output: "Terminated"
             SAFE ✅

kill -9   =  SIGKILL — force kill
             OS immediately frees memory
             No chance to save data — could corrupt!
             Output: "Killed"
             UNSAFE ⚠️
```

**Golden Rule:** Always try -15 first. Use -9 only as last resort.

**Real world:** Database process hung → kill -15 → database saves data safely → exits. If -15 doesn't work → kill -9 → data could be corrupted!

---

## Q3: What does ps aux show?

**Answer:**

`ps aux` shows all running processes with details.

```
PID   →  Process ID
PPID  →  Parent Process ID (who created this process)
USER  →  who is running it
TIME  →  CPU time consumed
STAT  →  S=Sleeping, R=Running, Z=Zombie
%CPU  →  CPU usage
COMMAND → which program
```

**Filter processes:**
```bash
ps aux | grep node        # show only node processes
ps aux | grep sh | grep -v grep  # remove grep itself
```

---

## Q4: What is PPID? What is PID 1?

**Answer:**

**PPID** = Parent Process ID — which process created this one.

All processes form a tree — **PID 1 (init) is the parent of everything!**

```
PID 1 (init — parent of all)
  └── PID 16 (vscode server)
        └── PID 20 (node)
              └── PID 91 (node worker)
```

---

## Q5: What does the & operator do?

**Answer:**

`&` runs a process in the **background** — terminal stays free!

```bash
sleep 200 &   # runs in background
              # terminal is immediately available
```

Without `&` → terminal is blocked until command finishes.

---

## Q6: What is the difference between TCP and UDP?

**Answer:**
```
TCP  =  Reliable, guaranteed delivery
        Slower — confirms every packet received
        Use: websites, APIs, databases, SSH

UDP  =  Fast, no delivery guarantee
        Fire and forget — no confirmation
        Use: video calls, gaming, DNS, streaming
```

**Analogy:**
```
TCP = Registered courier (signature required)
UDP = Regular post (no confirmation)
```

---

## Q7: What is DNS and how does it work?

**Answer:**

DNS = Domain Name System = internet's Google Maps.  
Converts human-readable names to IP addresses.

```
google.com  →  DNS  →  172.217.27.174
```

**Full DNS flow:**
```
Type google.com
      ↓
Check local cache
      ↓
Ask local DNS server (port 53)
      ↓
Ask ISP DNS
      ↓
Ask Root DNS
      ↓
Google DNS → 172.217.27.174
      ↓
Browser connects!
```
All in milliseconds! 🤯

---

## Q8: What do HTTP status codes mean?

**Answer:**
```
200  =  OK — everything is fine ✅
301  =  Moved Permanently — redirect
302  =  Moved Temporarily — redirect
400  =  Bad Request — client sent wrong data
401  =  Unauthorized — login required
403  =  Forbidden — no permission
404  =  Not Found — page doesn't exist
500  =  Internal Server Error — server's fault
502  =  Bad Gateway — upstream server error
503  =  Service Unavailable — server is down
```

---

## Q9: What is the difference between port 80 and 443?

**Answer:**
```
Port 80   =  HTTP  — unencrypted (anyone can read)
Port 443  =  HTTPS — encrypted (SSL/TLS)
```

**Why HTTPS?** Data is encrypted — passwords, credit cards can't be intercepted!

---

## Q10: What are some important port numbers?

**Answer:**
```
22    =  SSH (remote login)
53    =  DNS
80    =  HTTP
443   =  HTTPS
3000  =  Node.js (default)
3306  =  MySQL
5432  =  PostgreSQL
6379  =  Redis
8080  =  Alternative HTTP
27017 =  MongoDB
```

---

## Q11: What does netstat -tulpn show?

**Answer:**

Shows all open/listening ports on the system.

```
-t  =  TCP connections
-u  =  UDP connections
-l  =  listening ports only
-p  =  show program name
-n  =  show numbers (not hostnames)
```

**Real world use:**
```bash
netstat -tulpn | grep 3000   # is port 3000 in use?
netstat -tulpn | grep 5432   # is postgres running?
```

---

## Q12: What is the difference between 127.0.0.1 and 0.0.0.0?

**Answer:**
```
127.0.0.1  =  localhost only
              accessible only from THIS machine
              safe — no outside access

0.0.0.0    =  all interfaces
              accessible from outside too
              use carefully in production!
```

**Example:**
```
app listening on 127.0.0.1:3000 → only you can access it
app listening on 0.0.0.0:3000   → anyone on network can access
```

---

## Q13: What is curl and what are its important flags?

**Answer:**

curl = command line browser. Makes HTTP requests from terminal.

```bash
curl -s URL          # silent (no progress bar)
curl -I URL          # headers only
curl -L URL          # follow redirects (301, 302)
curl -o file URL     # save output to file
curl -X POST URL     # POST request
curl -w "%{http_code}" # print status code
```

**-L flag is important:**
```
Without -L → stops at 301 redirect
With -L    → follows redirect to final destination
```

---

## Q14: What is /dev/null?

**Answer:**

`/dev/null` = Linux's black hole / dustbin.

```
Anything redirected here → permanently discarded
Takes no disk space
Always empty
```

**Use cases:**
```bash
command > /dev/null      # discard output
command 2> /dev/null     # discard errors
command > /dev/null 2>&1 # discard both output and errors
```

---

## Q15: What is a cron job?

**Answer:**

Cron = Linux's task scheduler. Runs commands automatically on a schedule.

**Format:**
```
minute  hour  day  month  weekday  command
  *       *    *     *       *     /path/to/script.sh
```

**Common examples:**
```
*/30 * * * *   =  every 30 minutes
0 * * * *      =  every hour
0 2 * * *      =  every day at 2 AM
0 9 * * 1      =  every Monday at 9 AM
```

**Commands:**
```bash
crontab -e   # edit
crontab -l   # list
crontab -r   # remove all (careful!)
```

---

## Q16: What is load average in top?

**Answer:**

Load average = how much work the system has — shown for last 1, 5, and 15 minutes.

```
Load average: 0.06  0.12  0.09
               ↑     ↑     ↑
             1 min  5 min  15 min
```

```
Near 0          =  system is idle
Equal to CPU count = fully loaded
Above CPU count =  overloaded!
```

---

## Q17: What is IPv4 vs IPv6?

**Answer:**
```
IPv4  =  172.217.27.174
         4 numbers (0-255)
         ~4 billion addresses
         Problem: running out!

IPv6  =  2404:6800:4002:827::200e
         8 groups of hex
         ~340 undecillion addresses
         Future of internet
```

---

## Q18: What is TTL in ping?

**Answer:**

TTL = Time To Live = maximum number of routers (hops) a packet can pass through.

```
ping google.com → ttl=111
```

Prevents infinite loops — if a packet has wrong destination, it gets deleted after TTL hops instead of bouncing forever!

Each router decrements TTL by 1. When TTL = 0 → packet deleted.

---

> 💡 **Tomorrow — Day 3 Interview Questions:** Variables, if-else, loops, functions, backup script, disk alert
