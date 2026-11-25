---
title: 2026-11-24 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-24
track: Main
level: 2 — Punk
score: 6.5 / 9 (72%)
---

# Linux Quiz — 2026-11-24

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 6.5 / 9 (72%)
- Streak at level: 0 (≥80%) · 0 (<50%)
- Level change: none (3rd ⚡ preview hit, early level-up offered)

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Write it | Redirection (review) | `./build.sh > build.log 2>&1` | ❌ |
| 2 | Recall | Shell history | `sudo !!` | ✅ |
| 3 | Write it | Searching text (review) | `grep -c "404"` | ✅ |
| 4 | Predict the output | Text tools (review) | `cut -d: -f1,6` | ✅ |
| 5 | Write it | Finding files (review) | `find ~/projects -type f -name '*.c' -mtime -7` | 🟡 |
| 6 | Flag check | Searching text | `grep -v '^#'` | ✅ |
| 7 | Scenario | Searching text (review) | `grep -rl kernel ~/notes` | ✅ |
| 8 | Predict the output | Text tools | `sort` vs `sort -n` | ✅ |
| 9 | Fix it | Redirection | `make 2> errors.log` | ❌ |
| 10 | ⚡ Preview (L3) | Disk | `df -h` | ✅ |

## Missed → Review Queue
- `2>&1`: wrote `2>/dev/null 2>&1`. Nothing went to the file, and stdout stayed on screen
- `find`: no space after `find`, and no `-name '*.c'`. `-type f` and `-mtime -7` were right
- `2> file`: merged both streams with `2>&1 | tee` when only stderr was wanted

## Notes
- Best Level 2 score so far (72%). Stay at Level 2
- 1st ✅ since the miss: `grep -c`, `cut -f`, `grep -l`
- Redirection is the weak spot: `>`, `2>` and `2>&1` keep getting mixed up
- ⚡ Preview hits: 3 at Level 2, so an early level-up was offered
- Queue overflowed (16 → 15): parked `grep -rn` (1 miss, 1 ✅, oldest)
- Q9 wording was unclear at first. Reworded, no penalty
