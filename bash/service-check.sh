#!/bin/bash

SERVICE="$1"

echo "Checking service: $SERVICE"
systemctl is-active "$SERVICE"
echo "Exit code was: $?"
