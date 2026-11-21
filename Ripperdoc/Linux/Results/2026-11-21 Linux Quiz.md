---
title: 2026-11-21 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-21
track: Main
level: 2 — Punk
score: 3.5 / 9 (39%)
---

# Linux Quiz — 2026-11-21

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 3.5 / 9 (39%)
- Streak at level: 0 (≥80%) · 1 of 2 (<50%)
- Level change: none

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Flag check | Searching text | `grep -rl` | ❌ |
| 2 | Fix it | Redirection (review) | `2>&1 \| grep` | ❌ |
| 3 | Predict the output | Text tools (review) | `tr -d '0-9'` | ✅ |
| 4 | Write it | Finding files (review) | `find . -type d -name build` | ❌ |
| 5 | Predict the output | Text tools (review) | `cut -d, -f2` | 🟡 |
| 6 | Write it | Text tools (review) | `sort \| uniq -c \| sort -nr` | ❌ |
| 7 | Recall | Shell history | `Ctrl+R` | 🟡 |
| 8 | Write it | Text tools (review) | `make \| tee -a build.log` | ✅ |
| 9 | Write it | Searching text | `grep -iE 'warn\|error'` | 🟡 |
| 10 | ⚡ Preview (L3) | Permissions | `chmod +x` | ✅ |

## Missed → Review Queue
- `grep -l` — answered `-n`; `-l` lists matching file names only
- `2>&1` — answered `uniq`; the pipe only carries stdout, so stderr needs `2>&1` first
- `find -type d` — used `tree -I` (that hides matches); finding by name/type is `find`'s job
- `cut -f` — thought `-f2` removes column 2; it keeps it
- `sort | uniq -c | sort -nr` — used `uniq | wc -l` (counts unique lines, not each one)
- `Ctrl+R` — used `history | tail`; works but isn't the search shortcut
- `grep -E` — mismatched quotes, no `-E`, no file

## Notes
- First <50% session at Level 2 → one more in a row means level down to 1
- `tr` and `tee`: 1st ✅ each since the miss
- `2>&1`, `find`, `sort | uniq -c | sort -nr` missed 3 sessions running → Quick Hacks candidates
- ⚡ Preview hits: 2 at Level 2
- Queue overflowed (18 → 15): dropped `rm -i`, `whatis`, `touch` (1 miss each, Level 1)
