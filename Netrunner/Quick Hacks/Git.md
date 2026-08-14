---
title: Git
source: "[[Quick Hacks]]"
tags:
  - git
type: cheatsheet
created: 2026-08-02
---
**Practice URL**: [learn git branching](https://learngitbranching.js.org/?)

# git flags
| Flag                 | Full name        | Used with                        | What it does                                                        | Danger                        |
| -------------------- | ---------------- | -------------------------------- | ------------------------------------------------------------------- | ----------------------------- |
| `-f`                 | `--force`        | `push`                           | Overwrites remote branch history — dangerous, use with care         | 🔴 Destructive                |
| `--force-with-lease` | —                | `push`                           | Safer force push — fails if remote has commits you haven't seen     | 🟡 Caution                    |
| `-i`                 | `--interactive`  | `rebase`                         | Lets you pick, reword, squash, fixup, drop commits before replaying | 🟡 Caution                    |
| `-n`                 | `--no-commit`    | `cherry-pick`                    | Applies changes but doesn't commit — stages only                    | 🟢 Safe                       |
| `-e`                 | `--edit`         | `cherry-pick`                    | Opens editor to change commit message before committing             | 🟢 Safe                       |
| `-x`                 | —                | `cherry-pick`                    | Appends "(cherry picked from commit ...)" to the message            | 🟢 Safe                       |
| `--soft`             | —                | `reset`                          | Undo commit, keep changes staged                                    | 🟢 Safe                       |
| `--mixed`            | —                | `reset`                          | Undo commit, keep changes unstaged (default)                        | 🟡 Caution                    |
| `--hard`             | —                | `reset`                          | Undo commit, discard changes entirely                               | 🔴 Destructive                |
| `-p`                 | `--patch`        | `add`, `checkout`, `restore`     | Interactively stage/discard changes in chunks                       | 🟢 Safe                       |
| `--staged`           | —                | `restore`                        | Target the staging area instead of working directory                | 🟢 Safe                       |
| `--no-edit`          | —                | `commit --amend`                 | Keep existing commit message, just update contents                  | 🟡 Caution (rewrites history) |
| `-m`                 | `--message`      | `commit`                         | Set commit message directly, skip editor                            | 🟢 Safe                       |
| `-a`                 | `--all`          | `commit`                         | Auto-stage tracked, modified files before committing                | 🟢 Safe                       |
| `-b`                 | `--branch`       | `checkout`, `switch`             | Create a new branch and switch to it                                | 🟢 Safe                       |
| `-d`                 | `--delete`       | `branch`                         | Delete a branch (fails if unmerged)                                 | 🟡 Caution                    |
| `-D`                 | —                | `branch`                         | Force-delete a branch, even if unmerged                             | 🔴 Destructive                |
| `-u`                 | `--set-upstream` | `push`                           | Link local branch to a remote branch for future `push`/`pull`       | 🟢 Safe                       |
| `--abort`            | —                | `rebase`, `cherry-pick`, `merge` | Cancel the in-progress operation, return to prior state             | 🟢 Safe                       |
| `--continue`         | —                | `rebase`, `cherry-pick`, `merge` | Resume after resolving a conflict                                   | 🟢 Safe                       |

---
- `git remote add upstream [URL]`: 
	- `git remote`: Command used to manage links to external repos
	- `add`: Action telling Git to create a new shortcut/link
	- `upstream`: Default name given to the original repo
	- `[URL]`: Web address of og repo
---
# git rebase

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

| Command  | Effect                                           |
| -------- | ------------------------------------------------ |
| `pick`   | keep commit as-is                                |
| `reword` | keep changes, edit commit message                |
| `edit`   | pause here to amend the commit                   |
| `squash` | merge into previous commit, combine messages     |
| `fixup`  | merge into previous commit, discard this message |
| `drop`   | delete the commit                                |
**Reordering lines = reordering commits.**

**Note on fast-forwarding**

If the branch you're rebasing _has no unique commits_ — meaning your current branch is already an ancestor of `<branch>` — git doesn't replay anything. It just moves your branch pointer forward to match. No new commits are created, since there's nothing to reapply.

```
git checkout main
git rebase feature
```

If `main` is fully contained in `feature`'s history, `main` just fast-forwards to `feature`'s tip.

This only kicks in when there's nothing to replay — if your branch has its own unique commits, rebase does the normal thing: replay them on top of the new base.

---
# git cherry-pick

**`git cherry-pick <commit-hash>`** — apply a specific commit from another branch onto your current branch, without merging the whole branch.

```bash
git cherry-pick a1b2c3d
```

 Copies that one commit's changes onto your current branch as a new commit.

**Multiple commits:**

```bash
git cherry-pick a1b2c3d e4f5g6h    # picks both, in order
git cherry-pick a1b2c3d^..e4f5g6h  # picks a range (inclusive)
```

**Useful flags:**

| Flag                 | Effect                                              |
| -------------------- | --------------------------------------------------- |
| `-n` / `--no-commit` | apply changes but don't commit yet (stage only)     |
| `-e`                 | edit commit message before committing               |
| `-x`                 | append "(cherry picked from commit ...)" to message |

**If there's a conflict:**

```bash
# fix conflicted files, then:
git add <file>
git cherry-pick --continue
# or bail out:
git cherry-pick --abort
```

**Use case**: you need one bug fix from another branch without pulling in all its other commits.

---
# git reset \<Commit\>

`git reset <commit>`

Moves the current branch pointer back to `<commit>`, undoing commits after it.

```bash
git reset --soft HEAD~1   # undo commit, keep changes staged
git reset --mixed HEAD~1  # undo commit, keep changes unstaged (default)
git reset --hard HEAD~1   # undo commit, discard changes entirely
```

️ Rewrites history — don't use on commits already pushed/shared.

---
# git revert \<commit\>

Creates a _new_ commit that undoes the changes from `<commit>`, leaving history intact.

```bash
git revert a1b2c3d          # revert one commit
git revert HEAD~3..HEAD     # revert a range
```

Safe for shared/pushed branches — nothing gets rewritten.
 
In order to reverse changes and _share_ those reversed changes with others, we need to use `git revert`. 

---
# HEAD

A special ref that points to your current commit — basically "where you are right now."

- Normally `HEAD` points to a branch (e.g. `main`), and the branch points to a commit.
- If you check out a specific commit directly, `HEAD` points straight at that commit instead of a branch — this is called **"detached HEAD"** state.
- `HEAD` is what moves when you commit, checkout, reset, etc.

```bash
git log HEAD        # log starting from current commit
git checkout main   # HEAD now points to branch main
git checkout a1b2c3 # detached HEAD — points directly at that commit
``` 


---
# `~`(tilde)

~ (tilde) — walk back through first parents

Moves back N commits, always following the first parent (the main line).

```bash
HEAD~1   # 1 commit before HEAD
HEAD~2   # 2 commits before HEAD
HEAD~    # same as HEAD~1
```

---
# `^` (caret) -picks specific parent

^ (caret) — pick a specific parent

Moves back 1 commit, but lets you choose which parent when there's a merge commit (which has 2+ parents).
```bash
HEAD^    # 1st parent (same as HEAD~1 for normal commits)
HEAD^2   # 2nd parent (only relevant for merge commits)
HEAD^^   # 1st parent of 1st parent = HEAD~2
```
Combine them:

`HEAD~2^2   # go back 2 first-parents, then take the 2nd parent`

Rule of thumb: use `~` for simple "go back N commits," use `^` only when you need to navigate a merge commit's specific parent.

---
# Staging Area
Git splits work into three zones: working directory (where you edit files), staging area (a loading dock for what goes into the next commit), and repository (permanent history).

Nothing becomes a commit automatically — you choose exactly what goes in, so you never accidentally commit secrets or half-finished changes.

```bash
git status          # see what's staged, unstaged, untracked
git add <file>       # stage a specific file
git add .            # stage everything changed
git add -p           # stage chunks/hunks interactively
git restore --staged <file>   # unstage a file (keep the edits)
```

Flow: edit file (working dir) → git add (staging) → git commit (repository).

---
# git restore

The modern, purpose-built undo button for your working directory and staging area.

```bash
git restore --staged <file>   # unstage a file, keep your edits
git restore <file>             # discard edits entirely (changes are gone)
```
Two flavors, two zones:

Unstage — moves a file back out of the staging area, no edits lost.
Discard — reverts a file in your working directory back to its last committed state. Careful, this is destructive.

Quick rule of thumb: staged something by mistake → --staged. Want to throw away changes → plain restore.

---
# git ammend

Replaces last commit with a new one combining any staged changes with the prev commit, or just editing its message

```bash
git commit --amend # opens editor to update commit
message
git commit --amend -m "new msg" # skip editor, set message
```

**Common flow**: forgot to add a file, or made a typo in the last commit:
```bash
git add forgotten-file.txt
git commit --amend --no-edit
```
Rewrites history (new commit hash) same rules as rebase: don't amend commits already pushed/shared

---

# git tag

A way to **permanently** mark historical points in project's history. Helpful since branches are constantly changing

Helps keep track of major releases ore big merges

```bash
git tag v1 c1
```

where `v1` is tag name and `c1` is the commit (hash)

---
# git describe

A way to describe where you are relative to the closest `tag`

Helpful after returning from a vacation or getting your bearings after moved many commits backwards

```bash
git describe <ref>
```

`<ref>` is anything git can resolve into a comit. If no ref is specified then git uses `HEAD`

**Output**: `<tag>-<numCommits>-g<gash>`

Where `tag` is the closest ancestor tag in history, `numCommits` is how many commits away that tag is, and `<hash>` is the hash of the commit being described.

---

# git branch

A way to branch off and work on separate features

```bash
git checkout -b <branch> # create branch and checkout to the new branch
git branch <branch> # create a branch but don't checkout to it
git branch <branch1> <branch2> # create branch1 from from branch2

git branch <branch1> branch2>^^2^ # go back 2 commits then take the second parent of that commit then the first parent of that

```

**`git branch -f <b1> <b2>`**

Force-moves branch `<b1>` to point at wherever `<b2>` (branch, commit hash, `HEAD~2`, etc.) is pointing — no checkout needed.

```bash
git branch -f main HEAD~3
```

→ `main` now points 3 commits back from where you currently are.

```bash
git branch -f main feature
```

→ `main` now points to the same commit as `feature`.

 Doesn't touch your working directory or `HEAD` — it just relocates the branch pointer. If you're currently _on_ `<b1>`, you won't see the change reflected until you check it out again or move around.

---

# git fetch

`git fetch` performs two main steps
1. Downloads the commits that the remote has but are missing from our local repo
2. Updates where our remote branches point (for instance `o/main`)

`git fetch` brings local representation of the remote repo into sync with what the actual repo looks like

`git fetch` downloads the latest state of the remote (GitHub, etc.) and updates your local _notes_ about it — without touching any of your own work.

`git fetch` does not change anything about local state. It won't update the `main` branch or change anything about how the file system looks right now