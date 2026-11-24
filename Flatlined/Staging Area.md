---
title: Staging Area
source: "[[Flatlined]]"
tags: [netrunner, git]
created: 2026-11-23
stack: Git
status: reference
type: concept
---

## Problem / Goal

Commit exactly what you mean to, nothing more. Git doesn't commit your files directly. It commits whatever is in the **staging area** (the index), which is a draft of the next commit.

## Approach

Three areas, and every command moves changes between them:

```
working tree  ──git add──▶  staging (index)  ──git commit──▶  HEAD (last commit)
 (your files)  ◀─restore──   (next commit)    ◀─restore --staged─
```

| Area | What it holds | See it with |
|---|---|---|
| Working tree | Files on disk, as you're editing them | `git diff` (vs staging) |
| Staging (index) | The snapshot the next commit will record | `git diff --staged` (vs HEAD) |
| HEAD | The last commit | `git show` |

`git diff HEAD` compares HEAD with the working tree: everything you've changed since the last commit.

## Code / Snippets

**Read the state**

```
git status -s
XY file          X = staging (left)   Y = working tree (right)

M  a.c    staged, no further edits
 M b.c    edited, not staged
MM c.c    staged, then edited again
A  d.c    new file, staged
?? e.c    untracked
```

**Stage**

```bash
git add file        # one file
git add .           # everything under the current dir
git add -A          # everything in the whole repo (new, edited, deleted)
git add -p          # pick hunks interactively
git commit -a       # stage tracked edits + deletions, then commit (skips untracked)
```

**Move, remove, untrack**

```bash
git mv old.c new.c          # rename on disk + stage the rename
git rm file                 # delete from disk + stage the deletion
git rm -r --cached build/   # untrack, keep on disk (what .gitignore needs for tracked files)
```

**Back out**

```bash
git restore --staged file   # unstage, keep your edits
git restore file            # 🔴 discard working-tree edits
```

## Notes

- `.gitignore` only stops **untracked** files. Already-tracked files need `git rm --cached` first.
- `git status -s`: left = ready to commit, right = still on your desk.
- A file can be in two states at once (`MM`). Staging takes a snapshot at the moment you run `add`, so later edits aren't included until you add again.

## Links

- [[Netrunner]]
- [[Netrunner/Quick Hacks/Git|Git Quick Hack]]: command reference
