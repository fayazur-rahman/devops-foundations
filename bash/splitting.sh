#!/bin/bash 

FILE="my report.txt"

touch "$FILE"
ls -l

rm $FILE
ls -l

rm "$FILE"
ls -l

