# Step 5: Normalize Folder Names

## Goal

Rename all media folders to `Title (Year)` format for media server auto-identification.

## Target Format

- **Movie**: `中文名 (Year)/` or `English Title (Year)/`
- **TV/Bangumi**: `中文名 (Year)/` with `Season X/` subfolders if multi-season

## Naming Rules

1. **Chinese title preferred** — fall back to original language title, then English
2. **Year always in parentheses** — `(2024)` not `2024` or `[2024]`
3. **Strip ALL encoding info** — resolution, codec, HDR, release group, source
4. **Use show's premiere year** — not the season's air year (半泽直树 S02 aired 2020 but show is 2013)
5. **No brackets in title** — `白蛇：浮生` not `[白蛇：浮生]`

## Common Folder Name Patterns

Use `scripts/normalize-names.sh` for automated extraction, or parse manually:

| Input Pattern | Extract |
|---------------|---------|
| `中文名.English.2024.2160p.WEB-DL.H265-Group` | Title: `中文名`, Year: `2024` |
| `[中文名].English.2024.1080p.NF-Group` | Title: `中文名`, Year: `2024` |
| `English.Title.2024.UHD.BluRay.2160p-Group` | Title: `English Title`, Year: `2024` |
| `Show.S01.2024.2160p.WEB-DL-Group` | Title: `Show`, Year: `2024` |

## Title Lookup

For uncertain Chinese names:
1. Search TMDB: `https://www.themoviedb.org/search?query=TITLE`
2. Search MyDramaList: `https://mydramalist.com/search?q=TITLE`
3. Use web search with query: `"English Title" site:themoviedb.org`

Dispatch parallel agents (batch 10-15 titles per agent) for efficiency.

## Rename Examples

```bash
cd /path/to/Movie
mv "默杀.A.Place.Called.Silence.2024.2160p.HQ.WEB-DL.60fps.H265.10bit.DDP5.1-PTerWEB" "默杀 (2024)"
mv "[白蛇：浮生].White.Snake.Afloat.2024.2160p.120fps.WEB-DL.HEVC.10bit.TrueHD5.1-QHstudIo" "白蛇：浮生 (2024)"
mv "Zootopia.2016.2160p.DSNP.WEB-DL.DDP5.1.Atmos.DV.H.265-HHWEB" "疯狂动物城 (2016)"
```

## Loose File Handling

Video files not inside a subfolder must be wrapped:

```bash
# Create folder, move file in
mkdir -p "Title (Year)"
mv "Title.2025.2160p.WEB-DL.mkv" "Title (Year)/"
```

## Misplaced Content

Move content to correct category:
```bash
# TV series found in Movie/
mv "Movie/SomeShow.S01.1080p-Group" "TV/SomeShow (Year)"

# Movie found in TV/
mv "TV/SomeMovie (2022)" "Movie/SomeMovie (2022)"
```

## Caution

- **PT/BT seeding** — renaming breaks seeding. Confirm with user first.
- **NFO/artwork files** — existing `.nfo`, `poster.jpg`, `fanart.jpg` inside folders should be preserved during rename.
