---
title: Git Debrief
source: "[[Mikoshi/Ripperdoc/Git/Git|Git]]"
tags: [ripperdoc, git, jacked-in]
created: 2026-11-21
status: active
---

## Description

Pre-quiz review built from the [[Mikoshi/Ripperdoc/Git/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Open each self-check and answer it in your head before you peek.

Built from: [[2026-11-20 Git Quiz]] · [[2026-11-21 Git Quiz]]

## Notes

### 🔁 Missed twice

#### `git status -s` columns
Missed: 11-20 ❌ · 11-21 ❌

```
XY file
│└─ right = working tree (edited, not staged)
└── left  = staging area (staged, ready to commit)

M  a.c    staged, nothing else since
 M b.c    edited, not staged
MM c.c    staged, then edited again
A  d.c    new file, staged
?? e.c    untracked
```
Memory trick: **left = ready to commit, right = still on your desk.**

> [!question]- Self-check: what does ` D old.c` mean?
> Deleted from disk but the deletion isn't staged yet. `git rm old.c` (or `git add old.c`) stages it, and then it shows as `D ` (left column).

#### `git rm --cached`: untrack but keep the file
Missed: 11-20 🟡 · 11-21 🟡 (forgot `-r` and the path)

```bash
git rm --cached secrets.env          # one file
git rm -r --cached build/            # a folder needs -r
git commit -m "Stop tracking build/"
```
It removes the file from the index, so git forgets it, but leaves it on disk. Use `-n` first for a dry run.

> [!question]- Self-check: you committed `node_modules/`. Untrack it and keep it on disk.
> `echo node_modules/ >> .gitignore` → `git rm -r --cached node_modules/` → `git commit -m "Untrack node_modules"`

### 📐 The diff family

Missed: `diff --staged` 11-20 ❌ (✅ 11-21) · `diff HEAD` 11-20 ❌ · `diff` vs `--staged` swapped 11-21 🟡

```
HEAD (last commit) ──── index (staged) ──── working tree (your files)
        └── diff --staged ──┘   └────── diff ───────┘
        └───────────────── diff HEAD ───────────────┘
```

| Command | Compares | Answers |
|---|---|---|
| `git diff` | index → working tree | "What have I edited but not staged?" |
| `git diff --staged` | HEAD → index | "What will `commit` record?" |
| `git diff HEAD` | HEAD → working tree | "Everything I changed since the last commit" |
| `git show` | a commit vs its parent | "What did that commit change?" |

`diff` = uncommitted work. `show` = existing commits.

> [!question]- Self-check: file was `v0` in HEAD. You write `v1`, `git add`, then write `v2`. What does each diff show?
> `git diff` → v1→v2 · `git diff --staged` → v0→v1 · `git diff HEAD` → v0→v2

### 📦 Staging

#### `git add .` vs `git add -A`
Missed: 11-21 ❌

```bash
git add .     # all changes, ONLY under the current directory
git add -A    # all changes across the WHOLE repo, from anywhere
git add :/    # same as -A ( :/ = repo root )
```
Both include new files, edits and deletions in Git 2.x. The only difference is **scope**.

> [!question]- Self-check: you're in `src/` and edited `README.md` in the root. Does `git add .` stage it?
> No. `.` is `src/`. Use `git add -A`, `git add :/` or `git add ../README.md`.

#### `git mv`
Missed: 11-21 ❌

```bash
git mv helpers.c util.c
```
It renames the file on disk and stages the rename in one step, like `mv` + `git rm` + `git add`. Use `git log --follow util.c` to keep seeing the history from before the rename.

> [!question]- Self-check: you already ran plain `mv a.c b.c`. How do you stage it as a rename?
> `git add -A` (or `git rm a.c && git add b.c`). Git detects the rename from the content.

#### `.gitignore` doesn't affect tracked files
Missed: 11-20 ❌ · ✅ 11-21 (1 of 2 to clear)

`.gitignore` only stops **untracked** files from being added. If a file is already committed, git keeps tracking it until you run `git rm --cached` on it (see above).

### 📜 History, help & config

#### `git log --oneline`
Missed: 11-20 🟡 (`-n 5` alone still prints full entries)

```bash
git log --oneline -n 5    # last 5, one line each
git log --oneline -5      # same
```

#### `git <cmd> -h` vs `--help`
Missed: 11-21 🟡

```bash
git log -h        # quick flag summary in the terminal
git log --help    # full man page (= git help log)
```

#### `git config --list`
Missed: 11-20 🟡 · ✅ 11-21 (1 of 2 to clear)

```bash
git config --list --show-origin   # every setting + which file it came from
git config user.email             # check one value
```

### ⚡ Level 2 preview

#### `git branch -d` vs `-D`
Missed: 11-21 ❌ (reversed)

```bash
git branch -d feature   # safe: refuses if feature has unmerged commits
git branch -D feature   # 🔴 force: deletes even if unmerged
```
Neither one asks for confirmation. `-d` protects you from losing work, `-D` doesn't. If you delete by accident, `git reflog` still has the hash, and `git branch feature <sha>` brings the branch back.

## Links

- ⬆ [[Mikoshi/Ripperdoc/Git/Git|Git]]
- [[Mikoshi/Ripperdoc/Git/Quiz|Quiz]]: the live Review Queue
