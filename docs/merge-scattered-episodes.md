# Step 4: Merge Scattered Episodes

## Goal

Combine episodes of the same show split across multiple folders into one unified directory.

## Pre-Merge Checklist

1. **Verify no episode overlap** — if same episode exists in multiple folders, decide which quality to keep
2. **Check file naming** — ensure SxxExx pattern exists for media server recognition
3. **Check for dotfiles** — files starting with `.` are invisible to scrapers

## Merge Scenarios

### Scenario A: Complementary Episodes (no overlap)

Episodes split across release groups with no duplicates.

```bash
# Step 1: Verify distribution
for dir in "Show-ARiC" "Show-MWeb" "Show-HHWEB"; do
  echo "=== $dir ==="
  ls "$dir/" | egrep -oi 'S[0-9]+E[0-9]+' | sort -u
done

# Step 2: Move all to primary folder
for dir in "Show-MWeb" "Show-HHWEB"; do
  mv "$dir"/*.mkv "Show-ARiC/" 2>/dev/null
  mv "$dir"/*.mp4 "Show-ARiC/" 2>/dev/null
  mv "$dir"/*.ass "Show-ARiC/" 2>/dev/null
  mv "$dir"/*.srt "Show-ARiC/" 2>/dev/null
done

# Step 3: Verify and cleanup
ls "Show-ARiC/" | egrep -oi 'S[0-9]+E[0-9]+' | sort -u
rm -rf "Show-MWeb" "Show-HHWEB"
```

Use `scripts/check-episodes.sh` to verify completeness after merge.

### Scenario B: Different Seasons in Separate Folders

```bash
# Create unified structure
mkdir -p "Show (Year)/Season 1" "Show (Year)/Season 2"
mv "Show S01"/* "Show (Year)/Season 1/"
mv "Show S02"/* "Show (Year)/Season 2/"
rmdir "Show S01" "Show S02"
```

### Scenario C: Same Season, Different Quality (with overlap)

Keep higher quality for overlapping episodes:

```bash
# Compare sizes for same episode
du -sh "Show-4K/S01E05.mkv"   # 2.1G (4K)
du -sh "Show-1080p/S01E05.mp4" # 800M (1080p)
# Keep 4K, only take 1080p for missing episodes
```

### Scenario D: Hidden Dotfiles

Files prefixed with `.` won't be recognized by media servers:

```bash
cd "Show/Season 1/"
for f in .[!.]*.mkv .[!.]*.mp4; do
  [ -f "$f" ] && mv "$f" "$(echo "$f" | sed 's/^\.[^.]*\.//')"
done
```

## Post-Merge Verification

```bash
# Run episode check script
scripts/check-episodes.sh "Show (Year)/"
```

Confirm:
- All episodes present with no gaps
- No duplicate episode numbers
- Files are not hidden (no `.` prefix)
