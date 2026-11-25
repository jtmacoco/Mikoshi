---
title: Git Debrief
source: "[[Mikoshi/Ripperdoc/Git/Git|Git]]"
tags: [ripperdoc, git, jacked-in]
created: 2026-11-21
status: active
---

## Description

Pre-quiz review built from the [[Mikoshi/Ripperdoc/Git/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Open each self-check and answer it in your head before you peek.

Built from: [[2026-11-20 Git Quiz]] · [[2026-11-21 Git Quiz]] · [[2026-11-23 Git Quiz]] · [[2026-11-24 Git Quiz]]

## Notes

### 📐 The diff family (missed most)

Missed: `diff --staged` 11-20 ❌ · 11-23 🟡 (✅ 11-24, 1 of 2) · `diff` vs `--staged` swapped 11-21 🟡 · 11-23 🟡 (✅ 11-24, 1 of 2) · `diff HEAD` 11-20 ❌ · 11-24 🟡 (answered `git status`)

Your definitions are right. What keeps slipping is turning them into area pairs. Each command compares **two neighbours in the chain**:

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

Memory trick: plain `diff` = the right-hand gap, `--staged` = the left-hand gap, `HEAD` = both.

> [!question]- Self-check: HEAD has `v0`. You write `v1`, `git add`, then write `v2`. What does each diff show?
> `git diff` → v1→v2 · `git diff --staged` → v0→v1 · `git diff HEAD` → v0→v2

> [!question]- Self-check: one command to see the actual line changes since the last commit, staged and unstaged together?
> `git diff HEAD`. `git status` only lists the file names.

#### `git show HEAD~1` vs `git diff HEAD~1`
Missed: 11-24 ❌ (used `diff HEAD~1`)

```bash
git show HEAD~1          # message + diff of the commit one before HEAD
git show HEAD~1 --stat   # just the files it touched
git diff HEAD~1          # HEAD~1 → working tree (≠ one commit!)
```
`show` = look at a commit that exists. `diff` = compare two states.

> [!question]- Self-check: show what the commit two before the latest one changed.
> `git show HEAD~2`

### 🔁 Missed twice

#### `git rm --cached`: untrack but keep the file
Missed: 11-20 🟡 · 11-21 🟡 · ✅ 11-23 (1 of 2 to clear)

```bash
git rm --cached secrets.env          # one file
git rm -r --cached build/            # a folder needs -r
git commit -m "Stop tracking build/"
```
It removes the file from the index, so git forgets it, but leaves it on disk. Use `-n` first for a dry run.

> [!question]- Self-check: you committed `.env`. Untrack it and keep it on disk.
> `echo .env >> .gitignore` → `git rm --cached .env` → `git commit -m "Untrack .env"`

#### Commit message format
Missed: 11-23 ❌ (flagged the hash and date) · 11-24 🟡 (fixed the format, missed that it was 3 changes)

```
parser: Fix crash on empty input        ← subject ~50 chars, imperative

The tokenizer returned NULL for an      ← blank line, then a body: what + why
empty buffer and the parser
dereferenced it.
```
- Short subject, then a blank line, then the body
- Use the imperative mood: "Fix", not "Fixed". The subject completes "If applied, this commit will ___"
- **One logical change per commit.** If the subject needs "and" or "also", split it. A parser fix, a refactor and a README update are 3 commits

> [!question]- Self-check: what's wrong with `Fixed stuff and updated docs and refactored tokenizer`?
> It's vague, in the past tense, and bundles 3 changes into one commit. Split it up and write a specific subject for each.

### ✍️ Commits

#### `git commit -a`: tracked files only
Missed: 11-23 🟡 · ✅ 11-24 (1 of 2 to clear)

```bash
git commit -am "msg"   # = git add -u (tracked edits + deletions) + commit
git add -A && git commit -m "msg"   # include new files too
```
`-a` stages every modified **tracked** file and commits it. Untracked files are never included.

> [!question]- Self-check: you edited `app.py` (tracked) and created `new.py`, then ran `git commit -am "x"`. What does `git status -s` show?
> Only `?? new.py`. The `app.py` edit is in the commit.

### 🙈 Ignoring

#### `.gitignore` root anchor
Missed: 11-24 🟡 (wrote `build/`)

```gitignore
*.log        # every .log, any depth
!keep.log    # re-include one file
/build/      # root build/ only
build/       # build/ at ANY depth (src/build/ too)
```
A leading `/` pins the pattern to the `.gitignore`'s own folder. `git check-ignore -v path` shows which rule matched.

> [!question]- Self-check: ignore every `temp/` folder at any depth, and only the root `dist/`.
> `temp/` · `/dist/`

### 📦 Staging

#### `git add .` vs `git add -A`
Missed: 11-21 ❌ · ✅ 11-23 (1 of 2 to clear)

```bash
git add .     # all changes, ONLY under the current directory
git add -A    # all changes across the WHOLE repo, from anywhere
git add :/    # same as -A ( :/ = repo root )
```
Both include new files, edits and deletions in Git 2.x. The only difference is **scope**.

> [!question]- Self-check: you're in `src/` and edited `README.md` in the root. Does `git add .` stage it?
> No. `.` is `src/`. Use `git add -A`, `git add :/` or `git add ../README.md`.

#### `git mv`
Missed: 11-21 ❌ · ✅ 11-23 (1 of 2 to clear)

```bash
git mv helpers.c util.c
```
It renames the file on disk and stages the rename in one step, like `mv` + `git rm` + `git add`. Use `git log --follow util.c` to keep seeing the history from before the rename.

> [!question]- Self-check: you already ran plain `mv a.c b.c`. How do you stage it as a rename?
> `git add -A` (or `git rm a.c && git add b.c`). Git detects the rename from the content.

### 📜 History, help & config

#### `git config --global core.editor`
Missed: 11-23 🟡 (wrote `git config editor vim`) · ✅ 11-24 (1 of 2 to clear)

```bash
git config --global core.editor vim   # key is section.key → core.editor
git config --global --edit            # open the whole global config
```
Without `--global`, the setting only goes into this repo's `.git/config`.

> [!question]- Self-check: set your name for all repos.
> `git config --global user.name "Your Name"`

#### `git <cmd> -h` vs `--help`
Missed: 11-21 🟡 · ✅ 11-24 (1 of 2 to clear)

```bash
git log -h        # quick flag summary in the terminal
git log --help    # full man page (= git help log)
```

#### `git log --oneline`
Missed: 11-20 🟡 · ✅ 11-23 (1 of 2 to clear)

```bash
git log --oneline -n 5    # last 5, one line each
git log --oneline -5      # same
```

#### `git config --list`
Missed: 11-20 🟡 · ✅ 11-21 (1 of 2 to clear)

```bash
git config --list --show-origin   # every setting + which file it came from
git config user.email             # check one value
```

### ⚡ Level 2 preview

#### `git branch -d` vs `-D`
Missed: 11-21 ❌ (reversed) · 11-24 🟡 (safe/destructive right; left out `branch`, used `-d` on the unmerged branch)

```bash
git branch -d feature   # safe: refuses if feature has unmerged commits
git branch -D feature   # 🔴 force: deletes even if unmerged
```
Neither one asks for confirmation. `-d` protects you from losing work, `-D` doesn't. If you delete by accident, `git reflog` still has the hash, and `git branch feature <sha>` brings the branch back.

### ✅ Cleared

- `git status -s` columns: left = staged, right = working tree (✅ 11-23, 11-24)
- `.gitignore` doesn't affect tracked files: run `git rm --cached` first (✅ 11-21, 11-23)

## Links

- ⬆ [[Mikoshi/Ripperdoc/Git/Git|Git]]
- [[Mikoshi/Ripperdoc/Git/Quiz|Quiz]]: the live Review Queue
