# Step 6: Verify Episode Completeness Against TMDB

## Goal

Compare local episode counts against TMDB/MyDramaList actual totals to find genuinely incomplete shows.

## Why Internal Gap Detection Is Insufficient

Checking gaps within existing episodes misses tail truncation:
- Local: E01-E12, no gaps → appears complete
- TMDB: 24 episodes total → actually missing E13-E24

**Always verify against external source.**

## Procedure

### 6.1 Count local episodes

Use `scripts/check-episodes.sh`:

```bash
scripts/check-episodes.sh /path/to/TV/
```

Or manually:
```bash
find "Show (Year)/" -maxdepth 2 \( -name "*.mkv" -o -name "*.mp4" \) \
  -print0 | xargs -0 -I{} basename "{}" \
  | egrep -oi 'S[0-9]+E[0-9]+' | sort -u | wc -l
```

### 6.2 Query TMDB for actual episode counts

Dispatch **parallel agents** (batch 10-15 shows per agent) to search TMDB:

```
For each show, search TMDB or MyDramaList for total episode count per season.
Report: Show Name | Season X: total Y episodes
```

Reliable sources:
- TMDB: `https://www.themoviedb.org/tv/SHOW_ID/seasons`
- MyDramaList: `https://mydramalist.com/SHOW_ID`

### 6.3 Compare and categorize

| Category | Criteria | Action |
|----------|----------|--------|
| **Complete** | Local count = TMDB count | No action needed |
| **Incomplete (ended)** | Show finished airing, local < TMDB | Report to user, candidate for deletion |
| **Incomplete (airing)** | Show still airing, local < TMDB | Expected, not a problem |
| **Over-count** | Local > TMDB | Likely specials/extras counted, verify |

### 6.4 Report format

```markdown
## Complete
| Show | Local | TMDB | Status |
|------|-------|------|--------|
| 不眠日 | 16 | 16 | ✓ |

## Incomplete (ended shows)
| Show | Local | TMDB | Missing |
|------|-------|------|---------|
| 孤独摇滚！ | 11 | 12 | E04 |

## Incomplete (still airing)
| Show | Local | TMDB | Note |
|------|-------|------|------|
| 逐玉 | 5 | 40 | 连载中 |
```

## Handling Results

Present report to user with clear categorization. Let user decide:
- Delete incomplete ended shows
- Keep incomplete airing shows
- Keep specific shows despite incompleteness (e.g. BD Remux quality worth preserving)
