---
title: Git
source: "[[Git]]"
tags:
  - git
type: cheatsheet
created: 2026-08-02
---

- `git remote add upstream [URL]`: 
	- `git remote`: Command used to manage links to external repos
	- `add`: Action telling Git to create a new shortcut/link
	- `upstream`: Default name given to the original repo
	- `[URL]`: Web address of og repo

# Git Rebase

`git rebase <branch>`  replay your branch's commits on top of `<branch>`'s latest commit, for a clean, linear history (no merge commit).

```bash
git checkout feature
git rebase main
```

`feature`'s commits now sit on top of main, as if you'd branched off today.

Don't rebase commits others have already pulled -- it rewrites hashes and breaks their history

**`git rebase -i <branch/commit>`** — interactive rebase: edit, reorder, squash, or drop commits before replaying them.

```bash
git rebase -i HEAD~3        # last 3 commits
git rebase -i main          # everything since branching off main
```

Opens a list like:

```bash
pick a1b2c3 first commit
pick d4e5f6 second commit
pick g7h8i9 third commit
```

**Commands** (edit the word, then save & close):

|Command|Effect|
|---|---|
|`pick`|keep commit as-is|
|`reword`|keep changes, edit commit message|
|`edit`|pause here to amend the commit|
|`squash`|merge into previous commit, combine messages|
|`fixup`|merge into previous commit, discard this message|
|`drop`|delete the commit|
**Reordering lines = reordering commits.**