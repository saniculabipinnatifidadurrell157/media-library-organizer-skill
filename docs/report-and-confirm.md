# Step 7: Report & Confirm

## Goal

Present all findings to user in a clear, actionable format. Never auto-delete content.

## Final Report Structure

### Section 1: Summary

```
整理完毕:
- 清理垃圾: XXG
- 合并重复: X 组 → X 目录
- 重命名: X 个目录
- 完整剧集: X 部
- 缺集剧集: X 部
```

### Section 2: Actions Taken (already done)

- Junk files removed (with sizes)
- Folders renamed (old → new)
- Episodes merged (from → to)

### Section 3: Requiring User Decision

Present as clear tables with recommendations:

```markdown
## 缺集剧集 (需确认是否删除)
| Show | Have | Total | Missing | Recommendation |
|------|------|-------|---------|----------------|
| Show A | 11/12 | E04 | 已完结，建议删除 |
| Show B | 5/40 | E06-E40 | 连载中，建议保留 |
```

## Rules

1. **Never delete without explicit user confirmation**
2. **Group decisions logically** — let user batch approve/reject
3. **Distinguish ended vs airing** — user may want to keep airing shows
4. **Mention space savings** — helps user make informed decisions
