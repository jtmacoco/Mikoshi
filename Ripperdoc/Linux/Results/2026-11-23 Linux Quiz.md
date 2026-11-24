---
title: 2026-11-23 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-23
track: Main
level: 2 — Punk
score: 4.5 / 9 (50%)
---

# Linux Quiz — 2026-11-23

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 4.5 / 9 (50%)
- Streak at level: 0 (≥80%) · 0 (<50%), reset
- Level change: none

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Write it | Redirection | `> /dev/null 2>&1` | 🟡 |
| 2 | Recall | Locating | `which python3` | ✅ |
| 3 | Write it | Finding files (review) | `find ~ -type f -size +100M` | 🟡 |
| 4 | Predict the output | Text tools (review) | `sort \| uniq -c \| sort -nr` | ✅ |
| 5 | Write it | Searching text | `grep -c "ERROR"` | ❌ |
| 6 | Write it | Searching text (review) | `grep -l ssh /etc/*.conf` | ❌ |
| 7 | Predict the output | Text tools (review) | `cut -d: -f1,7` | 🟡 |
| 8 | Fix it | Redirection | `sort -o f f` (`>` truncates first) | ❌ |
| 9 | Recall | Shell history (review) | `Ctrl+R` | ✅ |
| 10 | ⚡ Preview (L3) | Processes | `pgrep firefox` | 🟡 |

## Missed → Review Queue
- `2>&1` — used `2>/dev/null` only; stdout still printed
- `find` — used `.` instead of `~`, missed `-type f` (no `-r` this time)
- `grep -c` — used `-n` (line numbers), not a count
- `grep -l` — piped `find` into grep, which searched the file names, not the contents
- `cut -f1,7` — right fields, but thought they print on separate lines; they're joined by `:`
- `sort f > f` — answered `>>`; `>` empties the file before `sort` reads it, so use `sort -o`
- `pgrep` (L3 preview) — used `pkill`, which kills but doesn't show the PID

## Notes
- 50% exactly → stay at Level 2; the <50% streak resets to 0
- 1st ✅ since the miss: `sort | uniq -c | sort -nr`, `Ctrl+R`
- `find`: no more `-r`. Progress
- `2>&1`, `find`, `cut` now missed 3+ sessions → Quick Hacks suggested
- Queue overflowed (18 → 15): parked `>>` vs `>`, `--help | grep`, `ls -A`. Also restored `rm -i`, `whatis`, `touch` to Parked (wrongly dropped on 11-21)
