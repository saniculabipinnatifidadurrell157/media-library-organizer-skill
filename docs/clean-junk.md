# Step 2: Clean Junk

## Goal

Remove temp files, broken downloads, and empty directories. Always confirm with user before deleting actual content.

## Safety Tiers

### Tier 1: Always Safe (delete without asking)

```bash
# SMB temp/delete residuals
rm -f /path/.smbdelete*

# Download fragment files
rm -f /path/*.parts

# macOS metadata
rm -rf /path/.DS_Store
rm -rf /path/._*

# TMM (tinyMediaManager) trash
rm -rf /path/.deletedByTMM
```

### Tier 2: Confirm with User

- **Empty directories** (< 1MB, no video files)
  ```bash
  # Find dirs smaller than 1MB
  find /path -maxdepth 2 -type d -exec du -sm {} \; | awk '$1 < 1 {print}'
  ```

- **Orphan single episodes** when full series exists elsewhere
  ```bash
  # e.g. loose Frieren.S01E01.mkv when 葬送的芙莉莲/ folder has full series
  ```

- **Non-media files** in media directories (ISOs, torrents, mp3 in video folder)

### Tier 3: Never Auto-Delete

- Any folder with video files > 100MB
- Any complete or near-complete series
- Any content user hasn't explicitly approved for deletion

## Report format after cleanup

```
已清除:
- .smbdeleteXXX — 22G SMB 残留
- Movie/空目录 × 3
- 释放约 XXG
```
