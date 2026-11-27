---
title: 2026-11-26 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-26
track: Main
level: 2 — Punk
score: 7.5 / 9 (83%)
---

# Linux Quiz — 2026-11-26

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 7.5 / 9 (83%)
- Streak at level: 2 (≥80%) · 0 (<50%)
- Level change: ⬆️ up to 3 — Merc

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Write it | Redirection (review) | `./test.sh > test.log 2>&1` | ✅ |
| 2 | Recall | Locating | `which python3` | ✅ |
| 3 | Write it | Finding files (review) | `find ~ -type d -name build` | ✅ |
| 4 | Predict the output | Text tools | `wc -l file` vs `wc -l < file` | ✅ |
| 5 | Flag check | Searching text | `grep -vc '^$'` | 🟡 |
| 6 | Fix it | Text tools (review) | `sort -o names.txt names.txt` | ✅ |
| 7 | Scenario | Searching text (review) | `grep -l TODO *.c` | ❌ |
| 8 | Recall | Shell history | `Ctrl+R` / `history \| grep ssh` | ✅ |
| 9 | Predict the output | Pipes | `tr \| sort \| uniq \| wc -l` | ✅ |
| 10 | ⚡ Preview (L3) | Processes | `pgrep firefox` / `pkill firefox` | 🟡 |

## Missed → Review Queue
- `^$`: read `$` as a literal dollar sign. It's the end-of-line anchor, so `^$` = empty line. Both flags were right
- `grep -l`: piped `find` output into `grep -rl` (grep searches the piped text, not those files) and wrote `-type -f`
- `pgrep`: wrote `pgrep Firefox`. Matching is case-sensitive and the process is `firefox`. Using `pkill` was right

## Notes
- Second ≥80% session in a row: **level up to 3 — Merc**
- Q3 regraded 🟡 → ✅: the space after `find` showed on the user's screen but was lost on the way. Flags were all right
- 1st ✅ since the miss: `2>&1` (written from scratch this time), `find ~`, `sort -o`
- Cleared (✅ twice): `Ctrl+R`
- `grep -l` is the habit to fix: give grep file names as arguments (`grep -l TODO *.c`)
