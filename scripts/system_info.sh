#!/bin/bash
echo "=== System Info ==="
echo "User: $(whoami)"
echo "CPU: $(nproc) cores"
echo "RAM: $(free -h | awk '/^Mem:/{print $2}')"
echo "Disk: $(df -h / | awk 'NR==2{print $4}') free"
echo "IP: $(hostname -i)"

