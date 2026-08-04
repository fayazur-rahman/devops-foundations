#!/bin/bash
# A greeter. Takes a name as an argument, or asks for one.


NAME="$1"


if [ -z "$NAME" ]; then
    read -p "What's your name? " NAME
fi
echo "Hello, ${NAME}! Today is $(date +%Y-%m-%d)."
echo "You are logged in as $USER on $(hostname)."

