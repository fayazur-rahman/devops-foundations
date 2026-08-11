#!/bin/bash

for SERVICE in nginx ssh cron; do
	STATE=$(systemctl is-active "$SERVICE" 2>/dev/null)
	echo "$SERVICE: $STATE"
done
