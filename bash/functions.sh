#!/bin/bash

check_service() {
	local svc="$1"
	local state
	state=$(systemctl is-active "$svc" 2>/dev/null)

	if [[ "$state" == "active" ]]; then
		echo "✓ $svc is up"
                return 0
        else
                echo "✗ $svc is DOWN"
                return 1
	fi
}

check_service nginx 
check_service ssh
check_service cron

echo "cron check returned: $?"

