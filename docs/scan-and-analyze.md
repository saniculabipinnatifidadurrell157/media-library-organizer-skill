# Step 1: Scan & Analyze

## Goal

Survey the entire media directory, categorize content, and generate a structured report of issues.

## Procedure

### 1.1 List top-level structure

```bash
ls -la /path/to/media/
```

Identify category directories: `Movie/`, `TV/`, `Bangumi/` (anime), `Music/`, etc.

### 1.2 Check each category size

```bash
du -sh /path/to/media/*/ | sort -rh
```

### 1.3 List contents per category

```bash
ls -la /path/to/media/Movie/
ls -la /path/to/media/TV/
ls -la /path/to/media/Bangumi/
```

Or use the scan script: `scripts/scan-media.sh /path/to/media`

### 1.4 Identify issues

Flag the following:

| Issue Type | How to Detect | Example |
|------------|---------------|---------|
| **Junk files** | Hidden files, `.smbdelete*`, `.parts`, ISOs | `.smbdeleteAAA14f5e4.4` (22G) |
| **Empty dirs** | Size < 1MB | `Movie/SomeTitle/` (20K) |
| **Duplicates** | Same title in multiple folders | `Mobius.S01-ARiC/` + `Mobius.S01-MWeb/` |
| **Misplaced** | TV series in Movie folder, movie in TV folder | `Movie/SomeShow.S01/` |
| **Loose files** | Video files not in a subfolder | `Movie/film.mkv` (no parent folder) |
| **Dotfiles** | Video files starting with `.` (invisible to scrapers) | `.Show.S01E01.mkv` |
| **No SxxExx** | Episodes without standard naming | `Episode 1.mp4` |

### 1.5 Output report format

```
## Junk Files (可立即删除)
| File | Size | Reason |

## Empty/Broken Directories
| Path | Size | Reason |

## Duplicates (同一内容多份)
| Content | Folders | Sizes |

## Misplaced Content
| Path | Current | Should Be |

## Naming Issues
| Path | Issue |
```
