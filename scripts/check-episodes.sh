#!/bin/bash
# check-episodes.sh — Check episode completeness for TV/anime directories
# Usage: ./check-episodes.sh /path/to/TV/
#        ./check-episodes.sh /path/to/TV/ShowName/
#
# Reports: episode count per season, internal gaps, and total coverage

set -euo pipefail

TARGET="${1:-.}"

check_show() {
  local show_dir="$1"
  local show_name
  show_name=$(basename "$show_dir")

  # Collect all SxxExx patterns from video files
  local episodes
  episodes=$(find "$show_dir" -maxdepth 3 \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" \) \
    -print0 | xargs -0 -I{} basename "{}" \
    | egrep -oi 'S[0-9]+E[0-9]+' | tr '[:lower:]' '[:upper:]' | sort -u)

  if [ -z "$episodes" ]; then
    # Count raw video files if no SxxExx naming
    local raw_count
    raw_count=$(find "$show_dir" -maxdepth 3 \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" \) | wc -l | tr -d ' ')
    if [ "$raw_count" -gt 0 ]; then
      echo "$show_name | $raw_count files (no SxxExx naming)"
    fi
    return
  fi

  # Group by season
  local seasons
  seasons=$(echo "$episodes" | sed 's/E[0-9]*//' | sort -u)

  for season in $seasons; do
    local eps_in_season
    eps_in_season=$(echo "$episodes" | grep "^${season}E" | sed "s/${season}E//" | sed 's/^0*//' | sort -n)

    local count first last expected
    count=$(echo "$eps_in_season" | wc -l | tr -d ' ')
    first=$(echo "$eps_in_season" | head -1)
    last=$(echo "$eps_in_season" | tail -1)
    expected=$((last - first + 1))

    if [ "$count" -lt "$expected" ]; then
      # Find missing episodes
      local missing=""
      for i in $(seq "$first" "$last"); do
        if ! echo "$eps_in_season" | grep -qx "$i"; then
          missing="${missing} ${season}E$(printf '%02d' "$i")"
        fi
      done
      echo "$show_name | $season: $count/$expected (E$(printf '%02d' "$first")-E$(printf '%02d' "$last")) | GAP:$missing"
    else
      echo "$show_name | $season: $count eps (E$(printf '%02d' "$first")-E$(printf '%02d' "$last")) | OK"
    fi
  done
}

# If target is a single show directory
if find "$TARGET" -maxdepth 1 \( -name "*.mkv" -o -name "*.mp4" \) -print -quit 2>/dev/null | grep -q .; then
  check_show "$TARGET"
elif [ -d "$TARGET/Season 1" ] || [ -d "$TARGET/Season1" ]; then
  check_show "$TARGET"
else
  # Target is a parent directory containing multiple shows
  echo "=========================================="
  echo "  Episode Completeness Report"
  echo "  Directory: $TARGET"
  echo "=========================================="
  echo ""
  for show_dir in "$TARGET"/*/; do
    [ -d "$show_dir" ] || continue
    check_show "$show_dir"
  done
fi
