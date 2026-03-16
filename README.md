# Media Library Organizer

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill for systematically cleaning, merging, renaming, and verifying media libraries — making them ready for Jellyfin / Emby / Plex auto-scraping.

## What It Does

| Step | Description |
|------|-------------|
| **Scan & Analyze** | Survey directories, flag junk files, duplicates, misplaced content |
| **Clean Junk** | Remove SMB residuals, `.DS_Store`, download fragments, empty dirs |
| **Identify Duplicates** | Find same content across folders by title/year/quality matching |
| **Merge Scattered Episodes** | Combine split episodes from different release groups |
| **Normalize Folder Names** | Rename to `Title (Year)` format for media server recognition |
| **Verify vs TMDB** | Compare local episode counts against TMDB totals |
| **Report & Confirm** | Present findings, wait for user confirmation before deletions |

## Workflow

```
Scan & Analyze → Clean Junk → Identify Duplicates → Merge Scattered Episodes
    → Normalize Folder Names → Verify vs TMDB → Report & Confirm
```

## Installation

### Quick Install (Recommended)

```bash
npx skills add Innei/media-library-organizer-skill
```

This automatically installs the skill into your Claude Code environment.

### Manual Install

Copy the skill into your Claude Code skills directory:

```bash
# Global (all projects)
git clone https://github.com/Innei/media-library-organizer-skill.git ~/.claude/skills/media-library-organizer

# Project-specific
git clone https://github.com/Innei/media-library-organizer-skill.git .claude/skills/media-library-organizer
```

Then invoke it in Claude Code by telling Claude to organize your media library, or use the slash command:

```
/media-library-organizer
```

### Standalone Scripts

The `scripts/` directory contains standalone bash scripts that can be used independently:

```bash
# Scan media directory for issues
./scripts/scan-media.sh /path/to/media

# Check episode completeness
./scripts/check-episodes.sh /path/to/TV/

# Suggest folder name normalization (dry run)
./scripts/normalize-names.sh /path/to/Movie/
```

## Example

Before:
```
Movie/
  默杀.A.Place.Called.Silence.2024.2160p.HQ.WEB-DL.60fps.H265.10bit.DDP5.1-PTerWEB/
  [白蛇：浮生].White.Snake.Afloat.2024.2160p.120fps.WEB-DL.HEVC.10bit.TrueHD5.1-QHstudIo/
  Zootopia.2016.2160p.DSNP.WEB-DL.DDP5.1.Atmos.DV.H.265-HHWEB/
TV/
  Mobius.S01.2160p.iQIYI.WEB-DL.AAC2.0.HDR.H.265-MWeb/
  Mobius.S01.2025.1080p.WEB-DL.AAC.H264-JKCT/
  [不眠日].Mobius.2025.S01.2160p.WEB-DL.HEVC-QHstudIo/
```

After:
```
Movie/
  默杀 (2024)/
  白蛇：浮生 (2024)/
  疯狂动物城 (2016)/
TV/
  不眠日 (2025)/          ← 3 folders merged, best quality kept
```

## Safety

- **Never auto-deletes content** — always confirms with user first
- **Tiered safety system** — only truly safe junk (SMB residuals, `.DS_Store`) is removed without asking
- **PT/BT seeding awareness** — warns before renaming folders that may be actively seeding
- **Dry-run scripts** — `normalize-names.sh` only prints suggested renames, never executes

## Docs

Detailed step-by-step instructions for each phase:

- [Scan & Analyze](docs/scan-and-analyze.md)
- [Clean Junk](docs/clean-junk.md)
- [Identify Duplicates](docs/identify-duplicates.md)
- [Merge Scattered Episodes](docs/merge-scattered-episodes.md)
- [Normalize Folder Names](docs/normalize-folder-names.md)
- [Verify vs TMDB](docs/verify-against-tmdb.md)
- [Report & Confirm](docs/report-and-confirm.md)

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Renaming breaks PT/BT seeding | Confirm with user if they're still seeding |
| Gap detection misses tail truncation | Must compare against TMDB total count |
| macOS `grep` lacks `-P` flag | Use `egrep -o` instead of `grep -oP` |
| Merging without checking overlaps | Always verify no episode overlap before merge |
| Guessing Chinese titles from English | Search TMDB for authoritative names |

## Requirements

- Bash 4+
- `find`, `du`, `awk`, `egrep` (standard Unix tools)
- [TMDB](https://www.themoviedb.org/) access for episode verification
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (for skill usage)

## License

MIT
