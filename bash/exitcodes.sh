#!/bin/bash


echo "--- succeeds ---"
ls /etc > /dev/null
echo "Exit code: $?"


echo "--- fails ---"
ls /this/does/not/exist 2> /dev/null
echo "Exit code: $?"


echo "--- grep found a match ---"
echo "hello world" | grep -q "hello"
echo "Exit code: $?"


echo "--- grep found nothing ---"
echo "hello world" | grep -q "goodbye"
echo "Exit code: $?"


echo "--- the trap ---"
ls /nope 2>/dev/null
echo "Exit code: $?"
echo "Exit code again: $?"

