# 📅 Day 2 — Processes + Networking
> **Date:** March 2026 | **Topic:** ps, kill, ping, curl, netstat, nslookup, df, free, cron

---

## 🧠 Big Picture

**Process** = every running program is a process — just like WhatsApp, Spotify, Chrome running separately on your phone.

**Networking** = communicating with the internet from Linux — ping, curl, DNS all come here.

---

## 1️⃣ What is a Process?

```
Program runs   →  Process created  →  PID assigned
Work finishes  →  Process exits    →  PID freed
```

**PID** = Process ID = unique identifier for every process — like an Aadhaar number!

### Process Lifecycle:
```
Run a program
      ↓
Process is created (gets a PID)
      ↓
Uses RAM + CPU
      ↓
Work done → exits automatically
OR
Kill it   → force stop
```

---

## 2️⃣ ps command — view processes

```bash
ps aux              # list all processes
ps aux | grep node  # filter only node processes
ps aux | grep sh | grep -v grep  # remove grep itself from results
```

### Column meanings:
```
PID     →  Process ID
PPID    →  Parent PID (which process created this one)
USER    →  who is running it
TIME    →  how much CPU time used
STAT    →  S=Sleeping, R=Running, Z=Zombie
VSZ     →  Virtual memory usage
%CPU    →  CPU usage percentage
COMMAND →  which program
```

### What does grep -v do?
```bash
ps aux | grep sh | grep -v grep
```
`-v` = inverse filter — exclude lines matching this pattern!

Since `grep` itself is a process, `-v grep` removes it from results.

---

## 3️⃣ top command — Live Task Manager

```bash
top   # real time process viewer (q = quit)
```

### top output:
```
Mem: 1580376K used, 14719848K free   ← RAM usage
CPU: 0% usr  99% idle                ← CPU usage
Load average: 0.06 0.12 0.09         ← last 1, 5, 15 min load
```

### Load average explained:
```
0.06 0.12 0.09
 ↑    ↑    ↑
 │    │    └── last 15 min average
 │    └─────── last 5 min average
 └──────────── last 1 min average

Near 0 = system is idle
1+     = system is busy
```

---

## 4️⃣ kill command — stop a process

### 2 signals:

```bash
kill -15 PID   # SIGTERM — graceful stop
kill -9 PID    # SIGKILL — force kill
```

### Difference:
```
kill -15  =  "Please stop when you're ready"
             Process saves data and exits cleanly — SAFE!
             Output: "Terminated"

kill -9   =  "STOP RIGHT NOW — no exceptions!"
             OS forcefully frees memory — UNSAFE!
             Output: "Killed"
```

### Real world analogy:
```
kill -15  =  Boss says "leave early today"
             You save your work, close files, then leave — safe!

kill -9   =  Power cut!
             Nothing saved — data could be corrupted!
```

### Golden Rule:
```
Always try -15 first
        ↓
If process doesn't respond
        ↓
Use -9 as last resort!
```

### Practice:
```bash
sleep 200 &          # run process in background
                     # & = run in background
ps aux | grep sleep  # find the PID
kill -15 PID         # graceful stop → "Terminated"
kill -9 PID          # force kill    → "Killed"
```

---

## 5️⃣ Networking — Core Concepts

### Internet = a city:
```
Website    =  a building
IP Address =  building's address
DNS        =  city's Google Maps (name → address)
Port       =  building's door number
curl/ping  =  your delivery person
```

---

## 6️⃣ ping — check internet connectivity

```bash
ping google.com -c 4   # send 4 packets then stop
```

### Output explained:
```
PING google.com (142.250.67.78)
                 ↑
                 DNS converted name → IP!

64 bytes from 142.250.67.78: seq=0 ttl=111 time=243ms
                               ↑         ↑      ↑
                          packet no   hops   latency
```

### What is TTL?
```
TTL = Time To Live = max routers a packet can pass through

Without TTL → a packet with wrong address would bounce forever!
TTL prevents infinite loops — packet deleted after TTL hops
```

### Latency guide:
```
0-50ms    =  excellent (same city/country)
50-150ms  =  good (international)
150-300ms =  okay (far servers)
300ms+    =  bad (very laggy)
```

### Packet loss:
```
0% packet loss   =  internet is fine ✅
10%+ packet loss =  connection issues ⚠️
100% packet loss =  no internet ❌
```

---

## 7️⃣ curl — terminal browser

```bash
curl -s URL          # silent — make API call
curl -I URL          # headers only (no body)
curl -L URL          # follow redirects
curl -o file.txt URL # save output to file
```

### What is curl?
```
Open URL in browser  →  browser sends request
curl URL in terminal →  does the exact same thing!

curl = browser without a UI!
```

### curl -s — API call:
```bash
curl -s https://api.github.com/users/dev-priyanshu15
```
Returns JSON data — this is how APIs work!

### curl -I — HTTP Headers:
```bash
curl -I https://github.com
```

### Important headers:
```
HTTP/2 200              →  status code (200 = OK)
content-type: text/html →  type of data being sent
server: github.com      →  who is serving
set-cookie: ...         →  cookies being set
strict-transport-security → always use HTTPS
x-frame-options: deny   →  can't be loaded in iframe
```

### HTTP Status Codes — must memorize:
```
200  =  OK ✅
301  =  Redirect (address changed)
403  =  Forbidden (no permission)
404  =  Not Found
500  =  Server Error
```

### -L flag — follow redirects:
```
Without -L:
curl google.com → 301 (redirect detected, stops here)

With -L:
curl -L google.com → follows redirect → 200 ✅
```

---

## 8️⃣ netstat — view open ports

```bash
netstat -tulpn
```

### Flags:
```
-t  =  TCP connections
-u  =  UDP connections
-l  =  listening ports only
-p  =  show program name
-n  =  show numbers (not names)
```

### TCP vs UDP:
```
TCP  =  Registered courier
        Guaranteed delivery
        Slow but reliable
        Use: websites, APIs, databases

UDP  =  Regular post
        No guarantee
        Fast but unreliable
        Use: video calls, gaming, DNS
```

### Important ports — must know:
```
Port 22    =  SSH
Port 53    =  DNS
Port 80    =  HTTP
Port 443   =  HTTPS
Port 3000  =  Node.js apps
Port 5432  =  PostgreSQL
Port 27017 =  MongoDB
Port 6379  =  Redis
```

### Local Address explained:
```
127.0.0.1:3000  →  localhost only (not accessible from outside)
0.0.0.0:3000    →  accessible from anywhere
```

---

## 9️⃣ nslookup — DNS lookup

```bash
nslookup google.com
```

### Output:
```
Server:  10.255.255.254    ←  DNS server being used
Address: 10.255.255.254:53 ←  port 53 (DNS port)

Name:    google.com
Address: 172.217.27.174    ←  IPv4 address
Address: 2404:6800:...     ←  IPv6 address
```

### Authoritative vs Non-authoritative:
```
Authoritative     =  Google's own DNS server answering
                     "I am Google — my address is X"

Non-authoritative =  A middleman DNS answering
                     "I have Google's address cached"
```

### How DNS works — full flow:
```
You type google.com
      ↓
Check local DNS cache (visited before?)
      ↓
Ask WSL DNS server (10.255.255.254:53)
      ↓
Ask ISP DNS server
      ↓
Ask Root DNS server
      ↓
Google DNS → 172.217.27.174
      ↓
Browser connects!
```
All of this happens in milliseconds! 🤯

### IPv4 vs IPv6:
```
IPv4  =  172.217.27.174     (4 numbers, ~4 billion addresses)
IPv6  =  2404:6800:4002::   (8 groups, practically infinite)

IPv4 addresses are running out → IPv6 is the future!
```

---

## 🔟 df and free — disk + RAM

```bash
df -h && free -h
```

### && operator:
```
&&  =  AND operator
       First command succeeded? Run the second!
       First failed → second won't run!
```

Real use:
```bash
git add . && git commit -m "msg" && git push
# if any step fails → rest won't execute
```

### df -h — disk usage:
```
Filesystem   Size    Used  Available  Use%  Mounted on
/dev/sdd     1006G   557M    955G      0%   /
C:\          953G    497G    455G     52%   /mnt/host/c
```

**Warning:** `Use% 80%+` = danger zone — set up disk alerts!

### free -h — RAM:
```
              total    used     free   buff/cache  available
Mem:          15.5G   514.8M   14.9G    142.8M      14.9G
Swap:          4.0G        0    4.0G
```

### What is Swap?
```
RAM is full → OS uses Swap space
Swap = a portion of disk acting like RAM
       but MUCH slower!

RAM   =  items on your desk     (fast ⚡)
Swap  =  items in your cupboard (slow 🐢)
```

---

## 1️⃣1️⃣ Project — health_monitor.sh

### What does this script do?
```
Sends curl request to 5 websites
        ↓
Checks HTTP status code
        ↓
200 = UP ✅  |  anything else = DOWN ❌
        ↓
Saves result to log file with timestamp
```

### What is /dev/null?
```
/dev/null = Linux's dustbin / black hole
Anything sent here → disappears forever
Takes no disk space — always empty!
```

### curl flags used:
```
-L            →  follow redirects (handles 301)
-o /dev/null  →  throw response body in dustbin
-s            →  silent mode
-w "%{http_code}" →  print only status code
```

### The script:
```bash
#!/bin/sh

URLS="https://google.com https://github.com https://api.github.com https://youtube.com https://stackoverflow.com"

LOGFILE=~/devops/notes/health_$(date +%Y%m%d).log

echo "=== Health Check: $(date) ===" >> $LOGFILE

for url in $URLS; do
    CODE=$(curl -L -o /dev/null -s -w "%{http_code}" "$url")
    if [ "$CODE" -eq 200 ]; then
        echo "UP   [$CODE] $url" >> $LOGFILE
    else
        echo "DOWN [$CODE] $url" >> $LOGFILE
    fi
done

echo "Log saved: $LOGFILE"
cat $LOGFILE
```

### Script concepts used:
```
URLS="..."              →  list of websites
date +%Y%m%d            →  20260324 format (for filename)
for url in $URLS        →  repeat for each URL
CODE=$(curl ...)        →  save status code in variable
if [ "$CODE" -eq 200 ]  →  if 200 → UP, else → DOWN
-eq                     →  equal to (for numbers)
>>                      →  append to log file
```

---

## 1️⃣2️⃣ Cron — automatic scheduling

### What is Cron?
```
Cron = Linux's alarm clock + task scheduler

Like setting a phone alarm — "ring at 7 AM"
With cron — "run this script every 30 minutes"
```

### Cron format:
```
*/30  *  *  *  *  command
  ↑   ↑  ↑  ↑  ↑
  │   │  │  │  └── weekday (0=Sunday, 6=Saturday)
  │   │  │  └───── month   (1-12)
  │   │  └──────── day     (1-31)
  │   └─────────── hour    (0-23)
  └─────────────── minute  (0-59)

*/30 = every 30 minutes
*    = any value
```

### Common cron examples:
```
*/30 * * * *  =  every 30 minutes
0 * * * *     =  every hour
0 2 * * *     =  every day at 2 AM
* * * * *     =  every minute
0 9 * * 1     =  every Monday at 9 AM
```

### Commands:
```bash
crontab -e   # edit cron jobs
crontab -l   # list cron jobs
crontab -r   # remove all cron jobs (careful!)
```

### Our cron job:
```bash
*/30 * * * * /bin/sh /root/devops/scripts/health_monitor.sh
```

---

## ✅ Day 2 Checklist

- [x] Process concept understood
- [x] ps aux — viewed all processes
- [x] grep + grep -v used
- [x] top — live task manager
- [x] & operator — run in background
- [x] kill -15 — graceful stop (Terminated)
- [x] kill -9 — force kill (Killed)
- [x] ping — internet + latency check
- [x] TTL concept understood
- [x] curl -s — API call
- [x] curl -I — HTTP headers
- [x] curl -L — follow redirects
- [x] HTTP status codes memorized
- [x] netstat — open ports
- [x] TCP vs UDP difference
- [x] Important ports memorized
- [x] nslookup — DNS lookup
- [x] Full DNS flow understood
- [x] IPv4 vs IPv6
- [x] df -h — disk usage
- [x] free -h — RAM usage
- [x] && operator
- [x] /dev/null concept
- [x] health_monitor.sh built and running
- [x] for loop in script
- [x] if-else in script
- [x] Cron configured — auto runs every 30 min
- [x] Pushed to GitHub

---

## 🎯 Interview Questions — Day 2

**Q: What is the difference between kill -15 and kill -9?**
> kill -15 (SIGTERM) = graceful stop — process finishes its work then exits safely. kill -9 (SIGKILL) = force kill — OS immediately frees memory, data could be corrupted. Always try -15 first!

**Q: What is the difference between TCP and UDP?**
> TCP = reliable, guaranteed delivery, slower. Used for websites, APIs, databases. UDP = fast, no delivery guarantee. Used for video calls, gaming, DNS.

**Q: What is DNS?**
> DNS = Domain Name System = internet's Google Maps. Converts human-readable names (google.com) to IP addresses (172.217.27.174).

**Q: What do HTTP status codes 200, 301, 403, 404, 500 mean?**
> 200 = OK, 301 = Redirect, 403 = Forbidden, 404 = Not Found, 500 = Server Error.

**Q: What is the difference between port 80 and 443?**
> Port 80 = HTTP (unencrypted), Port 443 = HTTPS (encrypted/secure).

**Q: What does the && operator do in Linux?**
> Run second command only if first succeeds. If first fails, second won't execute.

**Q: What is /dev/null?**
> Linux's black hole — anything redirected here is discarded permanently. Used to suppress unwanted output.

**Q: What is a cron job?**
> A scheduled task in Linux. Uses 5-field format: minute hour day month weekday. `*/30 * * * *` = every 30 minutes.

**Q: What is the difference between 127.0.0.1 and 0.0.0.0?**
> 127.0.0.1 = localhost only (not accessible from outside). 0.0.0.0 = accessible from all network interfaces (public).

---

> 💡 **Tomorrow — Day 3:** Shell Scripting Deep Dive — variables, if-else, loops, functions + backup.sh, disk_alert.sh, log_cleaner.sh
