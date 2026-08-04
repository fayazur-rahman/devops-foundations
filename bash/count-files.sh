#!/bin/bash
# Counts files in a directory.
# Usage: ./count-files.sh [directory]   (defaults to current dir)


TARGET="${1:-.}"


TOTAL=$(ls -A "$TARGET" | wc -l)
FILES=$(find "$TARGET" -maxdepth 1 -type f 2>/dev/null | wc -l)
DIRS=$(find "$TARGET" -maxdepth 1 -type d 2>/dev/null | wc -l)
SIZE=$(du -sh "$TARGET" 2>/dev/null | awk '{print $1}')


echo "Directory: $TARGET"
echo "  Entries:      $TOTAL"
echo "  Files:        $FILES"
echo "  Directories:  $((DIRS - 1))"
echo "  Total size:   $SIZE"

