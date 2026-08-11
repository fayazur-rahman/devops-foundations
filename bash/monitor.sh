#!/bin/bash

WARN_DISK="${WARN_DISK:-75}"
CRIT_DISK="${CRIT_DISK:-90}"
WARN_MEM="${WARN_MEM:-75}"
CRIT_MEM="${CRIT_MEM:-90}"
SERVICE="${1:-nginx}"

STATUS=0

ok() { echo "OK: $*"; }
warn() { echo "WARN: $*" >&2; (( STATUS < 1 )) && STATUS=1; }
crit() { echo "CRIT: $*" >&2; STATUS=2; }

check_disk() {
	local usage
	usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

	if (( usage >= CRIT_DISK )); then crit "disk / at ${usage}% (>= ${CRIT_DISK}%)"
	elif (( usage >= WARN_DISK )); then warn "disk / at ${usage}% (>= ${WARN_DISK}%)"
	else ok "disk / at ${usage}%"
	fi
}

check_mem() {
  local total used usage
  read -r total used < <(free -m | awk 'NR==2 {print $2, $3}')
  usage=$(( used * 100 / total ))


  if   (( usage >= CRIT_MEM )); then crit "memory at ${usage}% (>= ${CRIT_MEM}%)"
  elif (( usage >= WARN_MEM )); then warn "memory at ${usage}% (>= ${WARN_MEM}%)"
  else                               ok   "memory at ${usage}%"
  fi
}

check_service() {
  local svc="$1"
  if systemctl is-active --quiet "$svc"; then
    ok   "service ${svc} is active"
  else
    crit "service ${svc} is NOT active"
  fi
}


# --- run ---
echo "=== monitor.sh @ $(date '+%Y-%m-%d %H:%M:%S') on $(hostname) ==="
check_disk
check_mem
check_service "$SERVICE"


exit "$STATUS"


