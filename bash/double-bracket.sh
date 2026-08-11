#!/bin/bash

FILE="my report.txt"
NAME="production-server-01"

if [[ -f $FILE ]]; then
	echo "FOUND THE FILE (UNQUOTED, STILL SAFE IN [[ ]])"
else 
	echo "FILE NOT FOUND"
fi

if [[ -n "NAME" && "$NAME" != "localhost" ]]; then
	echo "NAME is not localhost but set"
fi

if [[ "$NAME" =~ ^production ]]; then
	echo "this is a production host"
fi

