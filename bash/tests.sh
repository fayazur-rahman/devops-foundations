#!/bin/bash

NAME="fayazur"
EMPTY=""
NUM=42

[ "$NAME" = "fayazur" ] && echo "1: name matches"
[ -z "$EMPTY" ] && echo "2: EMPTY is empty"
[ -n "&NAME" ] && echo "3: NAME is non-empty"
[ "$NUM" -gt 40 ] && echo "4: NUM over 40"
[ "$NUM" = "42" ] && echo "5: string compare works too"
[ -f /etc/hostname ] && echo "6: /etc/hostname is a file"
[ -d /etc ] && echo "7: /etc is a directory"
[ -f /etc ] && echo "8: should not be printed"
