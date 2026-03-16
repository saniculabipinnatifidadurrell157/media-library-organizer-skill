# Step 3: Identify Duplicates

## Goal

Find the same content stored in multiple folders, typically from different release groups or quality tiers.

## Detection Patterns

### Pattern 1: Same English title, different release group

```
Mobius.S01.2160p.iQIYI.WEB-DL.AAC2.0.HDR.H.265-MWeb/
Mobius.S01.2025.1080p.WEB-DL.AAC.H264-JKCT/
[不眠日].Mobius.2025.S01.2160p.WEB-DL.HEVC-QHstudIo/
```

### Pattern 2: Chinese vs English naming

```
不眠日.Mobius.S01.2025.2160p-HHWEB/
Mobius.S01.2160p.iQIYI-MWeb/
```

### Pattern 3: Different seasons in separate folders

```
半泽直树.Hanzawa.Naoki.2020.S02/
半沢直樹.Hanzawa.Naoki.S01.2013/
```

### Pattern 4: Bracket variations

```
[我推的孩子]/
【我推的孩子】/
我推的孩子/
【我推的孩子】 (2023)/
```

## Analysis Steps

1. **Extract title and year** from each folder name (strip encoding info)
2. **Group by normalized title** (remove brackets, punctuation, case)
3. **Compare episode coverage** per group — check if they overlap or complement
4. **Compare quality** — prefer: BD Remux > 4K HDR > 4K SDR > 1080p > 720p

## Decision Table

| Scenario | Action |
|----------|--------|
| Full overlap, same quality | Keep one, delete other |
| Full overlap, different quality | Keep higher quality |
| No overlap (complementary episodes) | Merge into one folder |
| Partial overlap | Merge, keep higher quality for overlapping eps |

## Output Format

```
| Content | Copies | Best Version | Can Delete |
|---------|--------|-------------|------------|
| 不眠日 S01 | 5 folders | 4K HDR MWeb (22G) | 4 others (~28G) |
```
