#!/bin/bash


echo "Doing work..."


if [ "$1" = "fail" ]; then
    echo "Something went wrong." >&2
    exit 1
fi


echo "Work completed."
exit 0

