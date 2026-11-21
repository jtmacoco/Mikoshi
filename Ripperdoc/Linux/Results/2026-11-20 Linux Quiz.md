---
title: 2026-11-20 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-20
track: Main
level: 2 — Punk
score: 5 / 9 (56%)
---

# Linux Quiz — 2026-11-20

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 5 / 9 (56%)
- Streak at level: 0
- Level change: none

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Flag check | Searching text | `grep -vc "^#"` | ✅ |
| 2 | Scenario | Searching text (review) | `grep -rn "TODO" .` | ✅ |
| 3 | Predict the output | Text tools | `tr 'a-z' 'A-Z'` | ❌ |
| 4 | Write it | Finding files | `find /var/log -type f -mtime -2` | ❌ |
| 5 | Predict the output | Redirection (review) | `> out.txt 2>&1` | 🟡 |
| 6 | Write it | Text tools | `make \| tee build.log` | ❌ |
| 7 | Write it | Text tools (review) | `sort \| uniq -c \| sort -nr` | 🟡 |
| 8 | Predict the output | Text tools | `sort` vs `sort -n` | ✅ |
| 9 | Recall | Shell history | `cd !$` | ✅ |
| 10 | ⚡ Preview (L3) | Permissions | reading `-rwxr-x---` | ✅ |

## Missed → Review Queue
- `tr` — didn't know it; translates characters one-for-one (`a-z` → `A-Z` uppercases)
- `find -mtime -2` — reached for `ls`; time filters are `find`'s job (`-2` = within 2 days)
- `2>&1` — got the terminal right, but still thinks it sends to stderr; it sends stderr to where stdout goes
- `tee` — guessed `make -v`; `cmd | tee file` = screen + file
- `uniq -c` — counts right, missed the final `sort -nr` for most-frequent-first

## Notes
- Same score as last session; text tools (`tr`, `tee`) are the weak spot
- `grep -rn`: 1st ✅ since the miss
- `2>&1` missed 2 sessions running; read `&1` as "same place as 1"
- ⚡ Preview hits: 1 at Level 2
