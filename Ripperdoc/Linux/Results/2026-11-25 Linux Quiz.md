---
title: 2026-11-25 Linux Quiz
source: "[[Linux Results]]"
tags: [ripperdoc, linux, completed]
created: 2026-11-25
track: Main
level: 2 — Punk
score: 7.5 / 9 (83%)
---

# Linux Quiz — 2026-11-25

## Summary
- Track: Main
- Level: 2 — Punk
- Score: 7.5 / 9 (83%)
- Streak at level: 1 (≥80%) · 0 (<50%)
- Level change: none (4th ⚡ preview hit, early level-up still on offer)

## Questions
| # | Type | Topic | Command / Concept | Mark |
|---|---|---|---|---|
| 1 | Predict the output | Redirection (review) | `ls /etc /nope > out.txt 2>&1` | ✅ |
| 2 | Recall | Shell history | `cd !$` | ✅ |
| 3 | Write it | Finding files (review) | `find ~ -type f -size +500M` | 🟡 |
| 4 | Predict the output | Text tools (review) | `uniq -c` without `sort` | ✅ |
| 5 | Predict the output | Text tools (review) | `cut -d, -f2,4` | ✅ |
| 6 | Flag check | Searching text (review) | `grep -ivE 'warn\|error'` | ✅ |
| 7 | Write it | Redirection (review) | `make > build.log 2>&1` / `&> build.log` | ❌ |
| 8 | Write it | Text tools (review) | `tr 'a-z' 'A-Z' < notes.txt` | ✅ |
| 9 | Write it | Text tools (review) | `./scan.sh \| tee -a run.log` | ✅ |
| 10 | ⚡ Preview (L3) | Permissions | `chmod +x deploy.sh` | ✅ |

## Missed → Review Queue
- `find`: used `/home` (every user's home) instead of `~`. Flags were perfect
- `2>&1`: wrote `make build.log 2>&1` and `make build.log &>`, with no `>` before the file name, so make treats `build.log` as a target

## Notes
- Best Level 2 score so far (83%). First ≥80% session: streak 1 of 2
- Q5 regraded 🟡 → ✅: the answer was copied wrong, but the concept was known
- `2>&1` reading clicked (Q1 ✅), but writing it from scratch still drops the `>`
- Cleared (✅ twice): `sort | uniq -c | sort -nr`, `tr`, `tee`, `cut -f`
- 1st ✅ since the miss: `grep -iE`
- Queue went 15 → 12, so 3 parked items came back: `grep -rn`, `>>` vs `>`, `--help | grep`, `ls -A`
- Terminology: still says "pipes" for `>`
