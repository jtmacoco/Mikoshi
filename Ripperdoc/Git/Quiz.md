---
source: "[[Mikoshi/Ripperdoc/Git/Git|Git]]"
tags:
  - ripperdoc
  - git
  - jacked-in
created: 2026-11-20
---

# Git Quiz

Adaptive git practice. Claude follows [[Mikoshi/Ripperdoc/Git/CLAUDE|CLAUDE.md]] to run sessions and updates this note after each one.
Say **"jack in git"** to start.

---

## Current Status

| Field | Value |
|---|---|
| Current level | 1 — Street Kid |
| Sessions at this level | 1 |
| Streak (≥80%) | 0 |
| Streak (<50%) | 1 |
| ⚡ Preview hits at level | 1 |
| Total sessions | 1 |
| Last session | 2026-11-20 — 39% |

| Say | Runs |
|---|---|
| "jack in git" | Full mix at current level |
| "jack in git <topic>" | That topic only (e.g. "rebase", "undo", "bisect") |

---

## Review Queue

Commands/concepts I missed. An item clears after 2 ✅ in separate sessions.

| Command / Concept | Level | Times missed | ✅ since | Last seen |
|---|---|---|---|---|
| `git diff --staged` | 1 | 1 | 0 | 2026-11-20 |
| `git diff HEAD` | 1 | 1 | 0 | 2026-11-20 |
| `git rm --cached` (untrack, keep on disk) | 1 | 1 | 0 | 2026-11-20 |
| `.gitignore` doesn't affect tracked files | 1 | 1 | 0 | 2026-11-20 |
| `git status -s` columns | 1 | 1 | 0 | 2026-11-20 |
| `git log --oneline` | 1 | 1 | 0 | 2026-11-20 |
| `git config --list` | 1 | 1 | 0 | 2026-11-20 |

---

## Syllabus

### Level 1 — Street Kid · Snapshots & the staging area
- The three areas: working tree → staging area (index) → commits
- Starting: `git init`, `git clone`, `git clone <url> dir`
- Checking state: `git status`, `git status -s`, reading its output
- Staging: `git add file`, `git add .`, `git add -A`, `git rm`, `git rm --cached`, `git mv`
- Committing: `git commit -m`, `git commit -a`, writing a good message (short subject, blank line, body)
- History: `git log`, `git log --oneline`, `git log -n 5`, `git show`
- Diffs: `git diff` (unstaged) vs `git diff --staged` (staged) vs `git diff HEAD`
- Ignoring: `.gitignore` patterns, why already-tracked files ignore `.gitignore`
- Config: `git config --global user.name/user.email`, `git config --list`, `core.editor`
- Help: `git help <cmd>`, `git <cmd> -h`

### Level 2 — Punk · Branches & remotes
- What a branch is (a movable pointer), what `HEAD` is
- Branching: `git branch`, `git branch -a`, `git branch -v`, `git switch`, `git switch -c`, `git checkout -b`
- Deleting & renaming: `git branch -d` vs `-D`, `git branch -m`
- Merging: `git merge`, fast-forward vs merge commit, `--no-ff`, `--ff-only`
- Conflicts: reading `<<<<<<<` / `=======` / `>>>>>>>`, resolve → `git add` → `git commit`, `git merge --abort`
- Remotes: `git remote -v`, `git remote add`, `origin` vs `upstream`
- Syncing: `git fetch` vs `git pull` (fetch + merge), `git pull --rebase`, `git push`, `git push -u origin branch`
- Tracking branches: `origin/main` vs `main`, ahead/behind in `git status`, `git branch -vv`
- Tags: `git tag`, `git tag -a v1.0 -m`, `git push --tags`

### Level 3 — Merc · Undoing things
- Discarding edits: `git restore file`, `git restore --staged file`, `git checkout -- file`
- `git reset --soft` vs `--mixed` vs `--hard`, and what each does to index and working tree
- `git reset HEAD~1` vs `git revert <sha>`: rewrite vs new undo commit, and when to use which
- Fixing the last commit: `git commit --amend`, `--amend --no-edit`
- Stashing: `git stash`, `stash push -m`, `stash list`, `stash pop` vs `stash apply`, `stash drop`, `stash -u`
- Cleaning: `git clean -n` (dry run), `git clean -fd`
- Recovery: `git reflog`, `git reset --hard HEAD@{2}`, getting a deleted branch back
- Detached HEAD: what it means, `git switch -c` to keep work, `git switch -` to leave
- Common scenarios: committed to the wrong branch, committed a secret, need to undo a pushed commit

### Level 4 — Netrunner · Rewriting history
- `git rebase main`: replaying commits, why hashes change
- Rebase conflicts: resolve → `git add` → `git rebase --continue`, `--skip`, `--abort`
- Interactive rebase: `git rebase -i HEAD~N`, `pick`, `reword`, `edit`, `squash`, `fixup`, `drop`, reordering
- Autosquash: `git commit --fixup <sha>`, `git rebase -i --autosquash`
- Cherry-pick: `git cherry-pick <sha>`, ranges, `-x`, `-n`, `--continue/--abort`
- Force pushing: `push -f` vs `--force-with-lease`, the golden rule (don't rewrite shared history)
- Rebase vs merge: when each fits, `pull --rebase`, `rebase.autoStash`
- `git reset` to move a branch, `git branch -f`
- Splitting a commit with `rebase -i` + `edit` + `reset HEAD~`

### Level 5 — Fixer · Digging through history
- Log power: `git log --graph --oneline --all`, `--decorate`, `--author`, `--since`, `--grep`, `-- path`
- Pickaxe: `git log -S 'string'`, `git log -G 'regex'`, `git log -p -- file`, `git log -L :func:file`
- Revisions: `HEAD~2` vs `HEAD^2`, `sha^{tree}`, `main@{yesterday}`
- Ranges: `A..B` vs `A...B`, `git log main..feature`, `git diff main...feature`
- Blame: `git blame file`, `-L 10,20`, `-w`, `-C`, then `git show <sha>`
- Bisect: `git bisect start/bad/good`, `git bisect run ./test.sh`, `git bisect reset`, `skip`
- Searching code: `git grep -n`, `git grep` in an old commit
- Inspecting: `git show sha:path`, `git diff --stat`, `--name-only`, `git shortlog -sn`
- Comparing branches: `git log --left-right --oneline A...B`, `git cherry`

### Level 6 — Legend · Kernel & open-source workflow
- Fork workflow: `remote add upstream`, `fetch upstream`, `rebase upstream/master`, keeping a fork in sync
- Partial staging: `git add -p`, `git restore -p`, `git commit -p`
- Patches: `git format-patch -1`, `format-patch -3 --cover-letter`, `-v2` rerolls, `git am`, `git am --abort`, `git apply --check`
- Kernel conventions: `Signed-off-by` (`commit -s`), subject prefix `subsystem: description`, `Fixes:` tag, `--subject-prefix="PATCH net"`
- Sending: `git send-email`, `--to/--cc`, `scripts/get_maintainer.pl`, `scripts/checkpatch.pl`
- `git range-diff` between patch versions
- Worktrees: `git worktree add`, `list`, `remove`
- Hooks: `.git/hooks/pre-commit`, `commit-msg`, what `--no-verify` skips
- Internals: objects (blob, tree, commit), `git cat-file -p`, `git rev-parse`, refs in `.git/refs`
- Large repos: `clone --depth 1`, `--filter=blob:none`, `sparse-checkout`
- Scenario chains: "rebase your series on latest upstream and send v2", "find which commit broke the build and send a fix"

---

## Session Log

Newest first. Full details live in [[Git Results]].

| Date | Level | Score | Change | Note |
|---|---|---|---|---|
| [[2026-11-20 Git Quiz\|2026-11-20]] | 1 — Street Kid | 3.5 / 9 (39%) | none | First session; diffs weakest |
