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
