#!/bin/bash

TODAY=$(date +%Y-%m-%d)
HOSTNAME=$(hostname)
LOG_COUNT=$(ls /var/log | wc -l)
DISK_USED=$(df -h / | tail -n 1 | awk '{print $5}')

echo "Report for $HOSTNAME on $TODAY"
echo "Files in /var/log: $LOG_COUNT"
echo "Root filesystem usage: $DISK_USED"
