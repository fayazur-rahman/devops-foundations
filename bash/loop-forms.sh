#!/bin/bash

for FRUIT in apple banana cherry; do
	echo "fruit: $FRUIT"
done

for CONF in /etc/*.conf; do
	echo "config file: $CONF"
done

for USER_HOME in $(ls /home); do
	echo "home dir: $USER_HOME"
done

for (( i=1; i<=3; i++)); do
	echo "iteration $i"
done
