---
title: 2026-11-19 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-19
track: Main
level: 2 — Punk
score: 5 / 9 (56%)
---

# Linux Quiz — 2026-11-19

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 5 / 9 (56%)
- Streak at level: 0
- Level change: none

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Flag check | Searching text | `grep -rn` | ❌ |
| 2 | Scenario | Navigation (review) | `cd -` | ✅ |
| 3 | Predict the output | Text tools | `sort \| uniq -c` | 🟡 |
| 4 | Scenario | Getting help (review) | `type ls` | ✅ |
| 5 | Write it | Finding files | `find . -type f -name "*.log"` | ❌ |
| 6 | Flag check | Redirection | `> file` vs `> file 2>&1` | 🟡 |
| 7 | Scenario | Keyboard (review) | `Ctrl+Z` → `fg` | ✅ |
| 8 | Write it | Text tools | `cut -d: -f1 /etc/passwd` | ❌ |
| 9 | Recall | Shell history | `sudo !!` | ✅ |
| 10 | ⚡ Preview (L3) | Disk usage | `du -sh * \| sort -h` | ❌ |

## Missed → Review Queue
- `grep -rn` — didn't know; `-r` recursive, `-n` line numbers
- `uniq -c` — got sorted unique order, missed the counts
- `find` — added a nonexistent `-r` (find always recurses), missed `-type f`; `2>/dev/null` hid the error
- `2>&1` — thought stderr was discarded; it goes to the same file as stdout
- `cut -d: -f1` — used awk with double quotes (shell ate `$3`), no `-F:`, wrong field
- `du -sh * | sort -h` (L3 preview) — used `ls -lh`, which doesn't size dir contents

## Notes
- First session at Level 2: expected dip after early level-up
- Cleared from queue: `cd -`, `type` (2nd ✅ each)
- `Ctrl+Z` → `fg`: 1st ✅
- Habit to fix: don't add `2>/dev/null` until the command works
- Awk: always single quotes
