#!/bin/bash

USAGE=$(df -h / | tail -n 1 | awk '{print $5}' | tr -d '%')

echo "Root Usuage: ${USAGE}%"
