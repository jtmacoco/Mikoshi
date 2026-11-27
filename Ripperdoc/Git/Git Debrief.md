---
title: Git Debrief
source: "[[Mikoshi/Ripperdoc/Git/Git|Git]]"
tags: [ripperdoc, git, jacked-in]
created: 2026-11-21
status: active
---

## Description

Pre-quiz review built from the [[Mikoshi/Ripperdoc/Git/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Open each self-check and answer it in your head before you peek.

Built from: [[2026-11-20 Git Quiz]] · [[2026-11-21 Git Quiz]] · [[2026-11-23 Git Quiz]] · [[2026-11-24 Git Quiz]] · [[2026-11-25 Git Quiz]] · [[2026-11-26 Git Quiz]]

## Notes

### 📐 The diff family (missed most)

Missed: `diff` vs `--staged` swapped 11-20 ❌ · 11-21 🟡 · 11-23 🟡 · 11-25 🟡 · ✅ 11-26 (1 of 2 to clear)

Each command compares **two neighbours in the chain**:

```
HEAD (last commit) ──── staging (index) ──── working tree (your files)
        └── diff --staged ──┘    └────── diff ───────┘
        └────────────────── diff HEAD ───────────────┘
```

| Command             | Compares               | Answers                                      |
| ------------------- | ---------------------- | -------------------------------------------- |
| `git diff`          | index → working tree   | "What have I edited but not staged?"         |
| `git diff --staged` | HEAD → index           | "What will `commit` record?"                 |
| `git diff HEAD`     | HEAD → working tree    | "Everything I changed since the last commit" |
| `git show`          | a commit vs its parent | "What did that commit change?"               |

Memory trick: plain `diff` = the right-hand gap, `--staged` = the left-hand gap, `HEAD` = both. "`diff` = what's still on my desk."

> [!question]- Self-check: HEAD has `v0`. You write `v1`, `git add`, then write `v2`. What does each diff show?
> `git diff` → v1→v2 · `git diff --staged` → v0→v1 · `git diff HEAD` → v0→v2

### ⚡ `git branch -d` vs `-D` (Level 2 preview, missed 3×)

Missed: 11-21 ❌ (reversed) · 11-24 🟡 (used `-d` on the unmerged branch) · 11-26 🟡 (thought `-d` deletes an unmerged branch safely)

```bash
git branch -d feature   # safe: REFUSES if feature has unmerged commits
                        # error: The branch 'feature' is not fully merged.
git branch -D feature   # 🔴 force: deletes even if unmerged
```
"Safe" means `-d` won't run at all on an unmerged branch. It doesn't delete and keep the commits. If you `-D` by accident, `git reflog` still has the hash, and `git branch feature <sha>` brings it back.

> [!question]- Self-check: `experiment` has 2 unmerged commits. What does `git branch -d experiment` do?
> Nothing gets deleted. Git errors with "not fully merged". You need `-D` to force it.

### 🔁 Missed twice: `log` vs `show` vs `HEAD~N`

#### `git show HEAD~N`
Missed: 11-24 ❌ (used `diff HEAD~1`) · ✅ 11-25 · 11-26 🟡 (wrote `git show -n 1`, which is HEAD)

```bash
git show HEAD~1          # message + diff of the commit one before HEAD
git show HEAD~1 --stat   # just the files it touched
git diff HEAD~1          # HEAD~1 → working tree (≠ one commit!)
```
You **pick** the commit with `HEAD~N` or a hash. `-n` only limits *how many*, so `show -n 1` is just HEAD.

> [!question]- Self-check: open the commit two before the latest one.
> `git show HEAD~2`

#### `git log --oneline -n N`
Missed: 11-20 🟡 · ✅ 11-23 · 11-26 🟡 (used `git show --oneline -n 2`)

```bash
git log --oneline -n 5    # last 5, one line each
git log --oneline -5      # same
```
`log` = **list** commits (walks history). `show` = **open** one commit (no walking).

> [!question]- Self-check: list the last 3 commits, one line each.
> `git log --oneline -3`

### 🆕 New misses

#### `git status -s` deletions
Missed: 11-26 ❌ (wrote `MM` / `??`)

```
 D old.c   deleted with shell rm: working tree only, NOT staged
D  old.c   deleted with git rm: deletion staged
```
Same two columns as always: left = index (staged), right = working tree. Fix an unstaged ` D` with `git rm old.c` or `git add old.c`.

> [!question]- Self-check: you ran `rm notes.md` and then `git add -A`. What does `status -s` show?
> `D  notes.md`, with the deletion now staged.

### 📋 Status & config (1 of 2 to clear)

#### `git status -s` on new files
Missed: 11-25 ❌ · ✅ 11-26 (1 of 2 to clear)

```
A  a.txt   new file, staged (never committed, so it's A, not M)
AM a.txt   new file, staged, then edited again
?? b.txt   never `git add`-ed, so it's untracked
```

> [!question]- Self-check: fresh repo. `echo x > n.c`, `git add n.c`, `echo y >> n.c`, `touch m.c`. What does `git status -s` show?
> `AM n.c` and `?? m.c`

#### `git config --global user.name / user.email`
Missed: 11-25 🟡 (missing closing quote) · ✅ 11-26 (1 of 2 to clear)

```bash
git config --global user.name "Jordan T"
git config --global user.email "jt@example.com"
```
Quote values that have spaces. An unclosed `"` leaves the shell waiting at `>`.

> [!question]- Self-check: check which email git will use in this repo.
> `git config user.email`

#### `.gitignore` root anchor
Missed: 11-24 🟡 (wrote `build/`) · ✅ 11-26 (1 of 2 to clear)

```gitignore
/build/      # root build/ only
build/       # build/ at ANY depth (src/build/ too)
```
`git check-ignore -v path` shows which rule matched.

> [!question]- Self-check: ignore every `temp/` folder at any depth, and only the root `dist/`.
> `temp/` · `/dist/`

### ✍️ Commits

#### `git commit -a`: tracked files only
Missed: 11-23 🟡 · ✅ 11-24 (1 of 2 to clear)

```bash
git commit -am "msg"   # = git add -u (tracked edits + deletions) + commit
```
Untracked files are never included.

> [!question]- Self-check: you edited `app.py` (tracked) and created `new.py`, then ran `git commit -am "x"`. What does `git status -s` show?
> Only `?? new.py`.

### 📜 Help & config

#### `git config --global core.editor`
Missed: 11-23 🟡 · ✅ 11-24 (1 of 2 to clear)

```bash
git config --global core.editor vim
```

#### `git <cmd> -h` vs `--help`
Missed: 11-21 🟡 · ✅ 11-24 (1 of 2 to clear)

```bash
git log -h        # quick flag summary
git log --help    # full man page (= git help log)
```

#### `git config --list`
Returned from Parked 2026-11-26 · Missed: 11-20 🟡 · ✅ 11-21 (1 of 2 to clear)

```bash
git config --list --show-origin   # every setting + which file it came from
```

### 🅿️ Parked

None right now.

### ✅ Cleared

- Commit message format: short imperative subject, blank line, why-body, one change per commit (✅ 11-25, 11-26)
- `git diff HEAD`: HEAD → working tree, staged + unstaged together (✅ 11-25, 11-26)
- `git add .` vs `-A`: same changes, `.` = current dir only, `-A` = whole repo (✅ 11-23, 11-26)
- `git mv`: rename + stage in one step (✅ 11-23, 11-26)
- `git rm --cached`: untrack but keep on disk, `-r` for folders (✅ 11-23, 11-25)
- `git status -s` columns: left = staged, right = working tree (✅ 11-23, 11-24)
- `.gitignore` doesn't affect tracked files: run `git rm --cached` first (✅ 11-21, 11-23)

## Links

- ⬆ [[Mikoshi/Ripperdoc/Git/Git|Git]]
- [[Mikoshi/Ripperdoc/Git/Quiz|Quiz]]: the live Review Queue
