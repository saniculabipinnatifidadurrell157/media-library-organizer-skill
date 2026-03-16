#!/bin/bash
# scan-media.sh — Scan media directory and report issues
# Usage: ./scan-media.sh /path/to/media

set -euo pipefail

MEDIA_DIR="${1:-.}"

echo "=========================================="
echo "  Media Library Scan Report"
echo "  Directory: $MEDIA_DIR"
echo "=========================================="
echo ""

# 1. Junk files
echo "## Junk Files"
echo "---"
found_junk=0
while IFS= read -r -d '' f; do
  size=$(du -sh "$f" 2>/dev/null | cut -f1)
  echo "  $size  $f"
  found_junk=1
done < <(find "$MEDIA_DIR" -maxdepth 2 \( -name ".smbdelete*" -o -name "*.parts" -o -name ".DS_Store" -o -name "._*" -o -name ".deletedByTMM" \) -print0 2>/dev/null)
[ $found_junk -eq 0 ] && echo "  (none)"
echo ""

# 2. Empty / near-empty directories (< 1MB)
echo "## Empty/Broken Directories (< 1MB)"
echo "---"
found_empty=0
for d in "$MEDIA_DIR"/*/; do
  [ -d "$d" ] || continue
  for sub in "$d"*/; do
    [ -d "$sub" ] || continue
    size_kb=$(du -sk "$sub" 2>/dev/null | cut -f1)
    if [ "$size_kb" -lt 1024 ] 2>/dev/null; then
      size=$(du -sh "$sub" 2>/dev/null | cut -f1)
      echo "  $size  $sub"
      found_empty=1
    fi
  done
done
[ $found_empty -eq 0 ] && echo "  (none)"
echo ""

# 3. Loose video files (not in subdirectory)
echo "## Loose Video Files (not in subfolder)"
echo "---"
found_loose=0
for category in "$MEDIA_DIR"/*/; do
  [ -d "$category" ] || continue
  while IFS= read -r -d '' f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  $size  $f"
    found_loose=1
  done < <(find "$category" -maxdepth 1 \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" \) -print0 2>/dev/null)
done
[ $found_loose -eq 0 ] && echo "  (none)"
echo ""

# 4. Hidden video files (dotfiles)
echo "## Hidden Video Files (dotfiles, invisible to scrapers)"
echo "---"
found_hidden=0
while IFS= read -r -d '' f; do
  size=$(du -sh "$f" 2>/dev/null | cut -f1)
  echo "  $size  $f"
  found_hidden=1
done < <(find "$MEDIA_DIR" -maxdepth 4 \( -name ".*mkv" -o -name ".*mp4" \) -not -name ".DS_Store" -print0 2>/dev/null)
[ $found_hidden -eq 0 ] && echo "  (none)"
echo ""

# 5. Directory sizes
echo "## Directory Sizes"
echo "---"
for category in "$MEDIA_DIR"/*/; do
  [ -d "$category" ] || continue
  name=$(basename "$category")
  size=$(du -sh "$category" 2>/dev/null | cut -f1)
  count=$(find "$category" -maxdepth 1 -type d | wc -l | tr -d ' ')
  count=$((count - 1))
  echo "  $size  $name/ ($count items)"
done
echo ""
echo "=========================================="
echo "  Scan complete"
echo "=========================================="
