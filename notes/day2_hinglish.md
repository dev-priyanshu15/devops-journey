# 📅 Day 2 — Processes + Networking
> **Date:** March 2026 | **Topic:** ps, kill, ping, curl, netstat, nslookup, df, free

---

## 🧠 Aaj kya seekha — Big Picture

**Process** = har running program ek process hai — jaise phone mein WhatsApp, Spotify, Chrome alag alag chal rahe hain.

**Networking** = Linux se internet se baat karna — ping, curl, DNS sab yahan aata hai.

---

## 1️⃣ Process kya hota hai?

```
Program run kiya   →  Process ban gaya  →  PID mila
Kaam khatam        →  Process band      →  PID free
```

**PID** = Process ID = har process ka Aadhaar number — unique hota hai!

### Process ka lifecycle:
```
Program run karo
      ↓
Process ban jaata hai (PID milta hai)
      ↓
RAM + CPU use karta hai
      ↓
Kaam khatam → apne aap band
Ya
Kill karo   → force band
```

---

## 2️⃣ ps command — processes dekho

```bash
ps aux              # saari processes dekho
ps aux | grep node  # sirf node wali filter karo
ps aux | grep sh | grep -v grep  # grep khud ko remove karo
```

### Columns ka matlab:
```
PID   →  Process ID (Aadhaar number)
PPID  →  Parent PID (kis process ne banaya)
USER  →  kaun chala raha hai
TIME  →  kitna CPU time use kiya
STAT  →  S=Sleeping, R=Running, Z=Zombie
VSZ   →  Virtual memory
%CPU  →  CPU kitna use kar raha hai
COMMAND → kaunsa program hai
```

### grep -v kya karta hai:
```bash
ps aux | grep sh | grep -v grep
```
`-v` = inverse filter — yeh wala mat dikhao!

Kyunki `grep` khud bhi ek process hoti hai — `-v grep` se woh filter ho jaati hai!

---

## 3️⃣ top command — Live Task Manager

```bash
top   # real time processes (q = quit)
```

### top ka output:
```
Mem: 1580376K used, 14719848K free   ← RAM usage
CPU: 0% usr  99% idle                ← CPU usage
Load average: 0.06 0.12 0.09         ← last 1,5,15 min load
```

### Load average samajh:
```
0.06 0.12 0.09
 ↑    ↑    ↑
 │    │    └── last 15 min average
 │    └─────── last 5 min average
 └──────────── last 1 min average

0 ke paas = chill
1+ = busy
```

---

## 4️⃣ kill command — process band karo

### 2 signals:

```bash
kill -15 PID   # SIGTERM — graceful stop
kill -9 PID    # SIGKILL — force kill
```

### Difference:
```
kill -15  =  "Bhai please band ho jao — apna kaam finish karke"
             Process apna data save karke band hoti hai — SAFE!
             Output: "Terminated"

kill -9   =  "ABHI BAND HO — koi mauka nahi!"
             OS directly memory free karta hai — UNSAFE!
             Output: "Killed"
```

### Analogy:
```
kill -15  =  Boss ne bola "aaj jaldi ghar jao"
             Tu apna kaam save karke gaya — safe!

kill -9   =  Light chali gayi — bijli cut!
             Kuch bhi save nahi hua — data corrupt ho sakta hai!
```

### Golden Rule:
```
Hamesha pehle -15 try karo
        ↓
Agar process nahi mani
        ↓
Tab -9 use karo — last resort!
```

### Practice:
```bash
sleep 200 &          # background mein process chalao
                     # & = background mein chalao
ps aux | grep sleep  # PID dhundho
kill -15 PID         # graceful stop → "Terminated"
kill -9 PID          # force kill    → "Killed"
```

---

## 5️⃣ Networking — concepts

### Internet = ek shahar:
```
Website    =  ek building
IP Address =  building ka address
DNS        =  shahar ka Google Maps (naam → address)
Port       =  building ka door number
curl/ping  =  tera delivery boy
```

---

## 6️⃣ ping — internet check karo

```bash
ping google.com -c 4   # 4 packets bhejo phir ruk jao
```

### Output samajh:
```
PING google.com (142.250.67.78)
                 ↑
                 DNS ne naam → IP convert kiya!

64 bytes from 142.250.67.78: seq=0 ttl=111 time=243ms
                               ↑         ↑      ↑
                          packet no   hops   latency
```

### TTL kya hai?
```
TTL = Time To Live = kitne routers se guzar sakta hai

Agar address galat ho → packet forever bounce karta rahega
TTL = maximum hops — phir delete ho jaata hai (infinite loop se bachata hai!)
```

### Latency guide:
```
0-50ms    =  excellent (same city)
50-150ms  =  good (international)
150-300ms =  okay (far servers)
300ms+    =  bad (laggy)
```

### Packet loss:
```
0% packet loss   =  internet bilkul theek ✅
10%+ packet loss =  connection problem ⚠️
100% packet loss =  internet nahi hai ❌
```

---

## 7️⃣ curl — terminal ka browser

```bash
curl -s URL          # silent — API call karo
curl -I URL          # sirf headers dekho
curl -o file.txt URL # output file mein save karo
```

### curl kya hai?
```
Browser mein URL type karo  →  browser request bhejta hai
curl URL type karo           →  terminal se same kaam!

curl = browser without UI!
```

### curl -s — API call:
```bash
curl -s https://api.github.com/users/dev-priyanshu15
```
JSON data aata hai — APIs aise hi kaam karti hain!

### curl -I — HTTP Headers:
```bash
curl -I https://github.com
```

### Important headers:
```
HTTP/2 200              →  status code (200 = OK)
content-type: text/html →  kaunsa data aa raha hai
server: github.com      →  kaun serve kar raha hai
set-cookie: ...         →  cookies set ho rahi hain
strict-transport-security → hamesha HTTPS use karo
x-frame-options: deny   →  iframe mein load nahi ho sakta
```

### HTTP Status Codes:
```
200  =  OK ✅
301  =  Redirect (address badal gaya)
404  =  Not Found
403  =  Forbidden (permission nahi)
500  =  Server Error
```

---

## 8️⃣ netstat — open ports dekho

```bash
netstat -tulpn
```

### Flags:
```
-t  =  TCP connections
-u  =  UDP connections
-l  =  listening (LISTEN state)
-p  =  program name dikhao
-n  =  numbers mein dikhao (names nahi)
```

### TCP vs UDP:
```
TCP  =  Registered courier
        Delivery guarantee hai
        Slow but reliable
        Use: websites, APIs, databases

UDP  =  Normal post
        Koi guarantee nahi
        Fast but unreliable
        Use: video calls, gaming, DNS
```

### Important ports yaad karo:
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

### Local Address samajh:
```
127.0.0.1:3000  →  sirf localhost (bahar se nahi)
0.0.0.0:3000    →  sabko allow (bahar se bhi connect)
```

---

## 9️⃣ nslookup — DNS lookup

```bash
nslookup google.com
```

### Output:
```
Server:  10.255.255.254    ←  DNS server ka IP
Address: 10.255.255.254:53 ←  port 53 (DNS port)

Name:    google.com
Address: 172.217.27.174    ←  IPv4 address
Address: 2404:6800:...     ←  IPv6 address
```

### Authoritative vs Non-authoritative:
```
Authoritative     =  Google ka apna DNS server bata raha hai
                     "Main Google hoon — mera address yeh hai"

Non-authoritative =  beech wala DNS bata raha hai
                     cached answer hai
```

### DNS kaise kaam karta hai — full flow:
```
google.com type kiya
      ↓
Local DNS cache check (pehle visit kiya?)
      ↓
WSL DNS server (10.255.255.254:53)
      ↓
ISP DNS server
      ↓
Root DNS server
      ↓
Google DNS → 172.217.27.174
      ↓
Browser connect karta hai!
```
Yeh sab milliseconds mein hota hai! 🤯

### IPv4 vs IPv6:
```
IPv4  =  172.217.27.174     (4 numbers, ~4 billion addresses)
IPv6  =  2404:6800:4002::   (8 groups, practically infinite)

IPv4 addresses khatam ho rahe hain → IPv6 future hai!
```

---

## 🔟 df aur free — disk + RAM

```bash
df -h && free -h
```

### && operator:
```
&&  =  AND — pehla successful? Tab doosra chalao!
       Pehla fail → doosra nahi chalega!
```

Real use:
```bash
git add . && git commit -m "msg" && git push
# koi fail hua → baaki nahi chalenge
```

### df -h — disk usage:
```
Filesystem   Size    Used  Available  Use%  Mounted on
/dev/sdd     1006G   557M    955G      0%   /
C:\          953G    497G    455G     52%   /mnt/host/c
```

**Important:** `Use% 80%+` = danger zone — disk alert banana chahiye!

### free -h — RAM:
```
              total    used     free   buff/cache  available
Mem:          15.5G   514.8M   14.9G    142.8M      14.9G
Swap:          4.0G        0    4.0G
```

### Swap kya hai?
```
RAM full ho jaaye → Swap use hota hai
Swap = disk ka ek hissa (RAM jaisa kaam, but BAHUT slow)

RAM   =  table pe saman    (fast ⚡)
Swap  =  almaari mein saman (slow 🐢)
```

---

## 1️⃣1️⃣ Project — health_monitor.sh

### Kya karta hai yeh script?
```
5 websites pe curl request bhejta hai
        ↓
HTTP status code check karta hai
        ↓
200 = UP ✅  |  baaki = DOWN ❌
        ↓
Log file mein save karta hai timestamp ke saath
```

### /dev/null kya hai?
```
/dev/null = Linux ka dustbin / black hole
Jo bhi bhejo → gayab ho jaata hai
Disk space nahi leta — hamesha empty!
```

### curl flags jo use kiye:
```
-L            →  redirects follow karo (301 bhi handle hoga)
-o /dev/null  →  response body dustbin mein phenko
-s            →  silent mode
-w "%{http_code}" →  sirf status code print karo
```

### Pehla run vs doosra run:
```
Pehla run (bina -L):
DOWN [301] google.com    ← redirect follow nahi kiya

Doosra run (with -L):
UP   [200] google.com    ← -L ne redirect follow kiya ✅
```

### Script:
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

### Script ke concepts:
```
URLS="..."              →  websites ki list
date +%Y%m%d            →  20260324 format (filename mein)
for url in $URLS        →  har URL ke liye repeat karo
CODE=$(curl ...)        →  status code variable mein save karo
if [ "$CODE" -eq 200 ]  →  agar 200 hai → UP, warna DOWN
-eq                     →  equal to (numbers ke liye)
>>                      →  append karo log file mein
```

---

## 1️⃣2️⃣ Cron — automatic scheduling

### Cron kya hai?
```
Cron = Linux ka alarm clock + scheduler

Phone mein alarm set karte ho → "7 baje bajao"
Cron mein set karte ho → "har 30 min script chalao"
```

### Cron format — yaad karo:
```
*/30  *  *  *  *  command
  ↑   ↑  ↑  ↑  ↑
  │   │  │  │  └── weekday (0=Sunday, 6=Saturday)
  │   │  │  └───── month   (1-12)
  │   │  └──────── day     (1-31)
  │   └─────────── hour    (0-23)
  └─────────────── minute  (0-59)

*/30 = har 30 minute
*    = any (koi bhi)
```

### Common cron examples:
```
*/30 * * * *  =  har 30 minute
0 * * * *     =  har ghante pe
0 2 * * *     =  har din 2 AM pe
* * * * *     =  har minute pe
0 9 * * 1     =  har Monday 9 AM pe
```

### Commands:
```bash
crontab -e   # cron edit karo
crontab -l   # cron list dekho
crontab -r   # sab cron delete karo (careful!)
```

### Humara cron:
```bash
*/30 * * * * /bin/sh /root/devops/scripts/health_monitor.sh
```

---

## ✅ Day 2 Checklist

- [x] Process concept samjha
- [x] ps aux — processes dekha
- [x] grep + grep -v use kiya
- [x] top — live task manager
- [x] kill -15 — graceful stop (Terminated)
- [x] kill -9 — force kill (Killed)
- [x] & operator — background mein chalao
- [x] ping — internet + latency check
- [x] TTL concept samjha
- [x] curl -s — API call
- [x] curl -I — HTTP headers
- [x] HTTP status codes yaad kiye
- [x] netstat — open ports
- [x] TCP vs UDP difference
- [x] Important ports yaad kiye
- [x] nslookup — DNS lookup
- [x] DNS flow samjha
- [x] IPv4 vs IPv6
- [x] df -h — disk usage
- [x] free -h — RAM usage
- [x] && operator
- [x] health_monitor.sh banaya
- [x] curl -L flag — redirects follow karna
- [x] /dev/null concept samjha
- [x] for loop use kiya script mein
- [x] if-else use kiya script mein
- [x] Cron setup kiya — har 30 min auto run
- [x] GitHub pe push kiya

---

## 🎯 Interview Questions — Day 2

**Q: kill -15 aur kill -9 mein kya fark hai?**
> kill -15 (SIGTERM) = graceful stop — process apna kaam finish karke band hoti hai. kill -9 (SIGKILL) = force kill — OS directly memory free karta hai, data corrupt ho sakta hai. Hamesha pehle -15 try karo!

**Q: TCP aur UDP mein kya fark hai?**
> TCP = reliable, guaranteed delivery, slow. UDP = fast, no guarantee. Websites TCP use karti hain, video calls UDP.

**Q: DNS kya hota hai?**
> DNS = Domain Name System = internet ka Google Maps. naam (google.com) ko IP address (172.217.27.174) mein convert karta hai.

**Q: HTTP 200, 404, 500 ka matlab?**
> 200 = OK, 404 = Not Found, 500 = Server Error, 301 = Redirect, 403 = Forbidden.

**Q: Port 80 aur 443 mein kya fark hai?**
> Port 80 = HTTP (unsecure), Port 443 = HTTPS (secure/encrypted).

**Q: `&&` operator kya karta hai?**
> Pehla command successful ho tab doosra run karo. Pehla fail hua toh doosra nahi chalega.

---

> 💡 **Kal — Day 3:** Shell Scripting Deep Dive — variables, if-else, loops, functions + 3 projects!`
