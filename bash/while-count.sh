#!/bin/bash

COUNT=1
while [[ "$COUNT" -le 5 ]]; do
	echo "attempt $COUNT"
	COUNT=$(( COUNT + 1 ))
done
