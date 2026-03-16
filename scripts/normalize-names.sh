#!/bin/bash
# normalize-names.sh — Extract title and year from media folder names
# Usage: ./normalize-names.sh /path/to/Movie/
#
# Parses folder names and suggests "Title (Year)" renames.
# DRY RUN only — prints mv commands without executing.

set -euo pipefail

TARGET="${1:-.}"

echo "=========================================="
echo "  Folder Name Normalization (DRY RUN)"
echo "  Directory: $TARGET"
echo "=========================================="
echo ""

for d in "$TARGET"/*/; do
  [ -d "$d" ] || continue
  name=$(basename "$d")

  # Skip already normalized names: "Title (YYYY)"
  if echo "$name" | egrep -q '^.+ \([0-9]{4}\)$'; then
    continue
  fi

  # Try to extract year (4 digits preceded by . or space or -)
  year=$(echo "$name" | egrep -o '[\.\- ](19|20)[0-9]{2}[\.\- ]' | head -1 | tr -d '.  -')

  if [ -z "$year" ]; then
    year=$(echo "$name" | egrep -o '(19|20)[0-9]{2}' | head -1)
  fi

  # Try to extract Chinese title
  # Pattern: [中文] or 中文.English or 中文名
  chinese_title=""

  # Check for [中文名] pattern
  if echo "$name" | egrep -q '^\[.+\]'; then
    chinese_title=$(echo "$name" | sed 's/^\[\([^]]*\)\].*/\1/')
  # Check for 中文名.English pattern (Chinese chars before first ASCII-only segment)
  elif echo "$name" | egrep -q '^[^a-zA-Z\[]*[\.\- ]'; then
    chinese_title=$(echo "$name" | sed 's/[\.\- ].*//')
  fi

  # Fall back to English title extraction
  if [ -z "$chinese_title" ]; then
    # Strip year and everything after it (encoding info)
    if [ -n "$year" ]; then
      english_title=$(echo "$name" | sed "s/[\.\- ]*${year}.*//" | tr '.' ' ')
    else
      english_title="$name"
    fi
    title="$english_title"
  else
    title="$chinese_title"
  fi

  # Clean up title
  title=$(echo "$title" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [ -n "$year" ] && [ -n "$title" ]; then
    new_name="$title ($year)"
    if [ "$name" != "$new_name" ]; then
      echo "mv \"$name\""
      echo "   \"$new_name\""
      echo ""
    fi
  else
    echo "# MANUAL: $name (could not parse title/year)"
    echo ""
  fi
done

echo "=========================================="
echo "  DRY RUN complete. Review and execute manually."
echo "=========================================="
