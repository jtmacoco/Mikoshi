---
title: 2026-11-27 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-27
track: Main
level: 3 — Merc
score: 6.5 / 9 (72%)
---

# Linux Quiz — 2026-11-27

## Summary
- Track: Main
- Level: 3 — Merc
- Score: 6.5 / 9 (72%)
- Streak at level: 0 (≥80%) · 0 (<50%)
- Level change: none

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Predict the output | Permissions | `-rwxr-x---` → `chmod 750` | 🟡 |
| 2 | Write it | Redirection (review) | `./backup.sh > backup.log 2>&1` | ✅ |
| 3 | Scenario | Jobs (review) | `Ctrl+Z` → `jobs` → `fg` | 🟡 |
| 4 | Write it | Finding files (review) | `find ~ -type f -mtime -2` | ✅ |
| 5 | Recall | Disk & memory | `df -h` vs `du -sh` | ✅ |
| 6 | Write it | Searching text (review) | `grep -l malloc *.c` | 🟡 |
| 7 | Write it | Archives | `tar -czf project.tar.gz project/` | ✅ |
| 8 | Predict the output | Environment | `export MYVAR=hello` | 🟡 |
| 9 | Scenario | Processes (review) | `pgrep firefox` / `kill -9` | 🟡 |
| 10 | ⚡ Preview (L4) | Loops | `for f in *.txt; do echo "$f"; done` | ❌ |

## Missed → Review Queue
- `chmod 750`: read the permissions right, but wrote group `r-x` as 1 instead of 5 (4+1)
- `jobs`: knew `Ctrl+Z` suspends and `fg %` resumes, but didn't say how to see the suspended job
- `grep -l`: quoted the glob (`"*.c"`), so grep looked for a file literally named `*.c`
- `export`: knew the child shell sees nothing, but tried `echo $MYVAR > hello` (writes a file) instead of `export`
- `kill -9`: wrote `kill -f`. The reason given (wrong PID) was off: SIGKILL skips cleanup
- `for` loop (L4 preview): looped over `.`, used `file` with no `$`, and left out the `;` before `done`

## Notes
- First session at Level 3. Every L3-only question (df, tar) was ✅. Misses were half-right 🟡s
- Q4 counted ✅: came through as `find~` with no space. Same transit issue as 11-26
- Cleared (✅ twice): `2>&1` (missed 7 times, now written from scratch twice in a row), `find ~ -type f`
- 1st ✅ since the miss: `pgrep firefox`
- Queue went 15 → 17, so 2 were parked: `>>` vs `>`, `ls -A`
