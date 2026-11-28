---
title: Linux Debrief
source: "[[Mikoshi/Ripperdoc/Linux/Linux|Linux]]"
tags: [ripperdoc, linux, jacked-in]
created: 2026-11-21
status: active
---

## Description

Review notes built from the [[Mikoshi/Ripperdoc/Linux/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Answer each self-check in your head before you peek.

Built from: [[2026-11-27 Linux Quiz]]

## Notes

### Main track

#### Searching text

##### `grep -l`: just the file names
Missed: 11-21 ❌ · 11-23 ❌ · ✅ 11-24 · 11-26 ❌ · 11-27 🟡 (quoted the glob) (0 of 2 to clear)

By default grep prints every matching line. `-l` prints each matching **file name** once instead.

```bash
grep -rl "malloc" src/    # which files mention malloc
grep -rL "malloc" src/    # which files don't
grep -l ssh /etc/*.conf   # which .conf files mention ssh
```
Give grep the files as **arguments** to search inside them. `find ... | grep ssh` only searches the list of names.

```bash
grep -l TODO *.c                       # ✅ shell expands *.c into file names
grep -rl TODO --include='*.c' .        # ✅ same, into subfolders
find . -name '*.c' | grep -rl TODO     # ❌ grep ignores the pipe's names, searches all of .
```
Also: it's `-type f`, not `-type -f`.

Don't quote the glob. Quotes stop the shell from expanding `*.c`, so grep looks for one file literally named `*.c`:

```bash
grep -l malloc *.c      # ✅ shell expands to a.c b.c ...
grep -l malloc "*.c"    # ❌ grep: *.c: No such file or directory
```
Quote the **pattern**, not the **glob**. The exception is `--include='*.c'`, where grep does the matching itself.

> [!question]- Self-check: which `.h` files in `include/` mention `uint64_t`?
> `grep -l uint64_t include/*.h`

> [!question]- Self-check: how many files under `src/` contain `TODO`?
> `grep -rl TODO src/ | wc -l`

##### `^$`: regex anchors (empty line)
Missed: 11-26 🟡

In a grep pattern, `^` = start of line and `$` = end of line. `$` is not a literal dollar sign.

```bash
grep -v '^$' f       # drop empty lines
grep -vc '^$' f      # count non-empty lines
grep '^#' f          # lines starting with #
grep 'bash$' f       # lines ending in bash
grep '\$HOME' f      # a literal $: escape it
```

> [!question]- Self-check: show `nginx.conf` without comments or blank lines.
> `grep -v '^#' nginx.conf | grep -v '^$'` (or `grep -vE '^(#|$)' nginx.conf`)

##### `grep -c`: count matching lines
Missed: 11-23 ❌ · ✅ 11-24 (1 of 2 to clear)

```bash
grep -c "ERROR" app.log            # number of lines with ERROR
grep "ERROR" app.log | wc -l       # same thing
grep -o "ERROR" app.log | wc -l    # every match, even 2 on one line
```
`-c` = count. `-n` = line numbers in front of each match, which still prints every line.

> [!question]- Self-check: how many lines in `/etc/passwd` end in `bash`?
> `grep -c 'bash$' /etc/passwd`

##### `grep -E`: match this or that
Missed: 11-21 🟡 · ✅ 11-25 (1 of 2 to clear)

```bash
grep -iE 'warn|error' kern.log
grep -i -e warn -e error kern.log   # same result
```
Plain grep treats `|` as a literal character. `-E` makes it mean "or". Put the whole pattern inside one pair of single quotes.

> [!question]- Self-check: lines with `fail` or `panic` in `dmesg` output, any case.
> `dmesg | grep -iE 'fail|panic'`

##### `grep -rn`: recursive with line numbers
Missed: 11-19 ❌ · ✅ 11-20 (1 of 2 to clear)

```bash
grep -rn "TODO" .
```
`-r` searches every file under the folder, and `-n` adds the line number to each match.

> [!question]- Self-check: what does `-n` add to the output?
> `file:LINE:` before each match.

#### Keyboard & jobs

##### `Ctrl+Z` suspend → `jobs` → `fg` / `Ctrl+L` clear
Missed: 11-17 🟡 · 11-18 🟡 · ✅ 11-19 · 11-27 🟡 (no `jobs`) (0 of 2 to clear)

`Ctrl+Z` pauses (suspends) the running program and gives you the prompt back. It's still alive. `Ctrl+C` is the one that kills it. `Ctrl+L` clears the screen.

```bash
jobs      # [1]+  Stopped   vim notes.txt
fg        # resume the current job (same as fg %1 / fg %)
bg        # resume it in the background instead
```

> [!question]- Self-check: you hit `Ctrl+Z` in vim by accident. Confirm it's still there, then get back in.
> `jobs`, then `fg`. Don't reopen the file, or you'll get a swap-file warning.

#### Processes

##### `pgrep`: find a PID by name
Missed: 11-23 🟡 (⚡ L3 preview) · 11-26 🟡 (⚡ L3 preview, `pgrep Firefox`) · ✅ 11-27 (1 of 2 to clear)

```bash
pgrep firefox        # PIDs only
pgrep -a firefox     # PID + full command line
pkill firefox        # skip the lookup, send SIGTERM
kill -9 1234         # force-kill one PID
```
`pgrep` and `pkill` match names the same way, and the match is **case-sensitive**: the process is `firefox`, not `Firefox`. Use `-i` to ignore case. `pgrep` shows the PID, `pkill` sends the signal.

> [!question]- Self-check: check whether any `qemu` process is still running.
> `pgrep -a qemu`. No output means none.

##### `kill` vs `kill -9`: ask nicely, then force
Missed: 11-27 🟡 (wrote `kill -f`)

```bash
kill 1234       # SIGTERM (15): "please quit", the default
kill -9 1234    # SIGKILL: dies instantly, can't be caught or ignored
pkill -9 firefox
kill -l         # list all signals
```
Try plain `kill` first. SIGTERM lets the program **clean up** (save, release locks, delete temp files). SIGKILL skips all of that, so it can leave corrupt files or stale locks. There's no `-f` flag.

> [!question]- Self-check: `qemu` hangs and ignores `pkill qemu`. Next step?
> `pkill -9 qemu`

#### Redirection

##### `2> file`: save only the errors
Missed: 11-24 ❌ · ✅ 11-24 drill (1 of 2 to clear)

```bash
make 2> errors.log          # errors → file, progress stays on screen
make > /dev/null            # hide progress, see only errors
make > out.log 2> err.log   # each stream in its own file
```
Pick the stream: `>` (or `1>`) = stdout only, `2>` = stderr only, `> f 2>&1` or `&> f` = both. `2>&1 | tee` merges them, so it can't separate anything.

> [!question]- Self-check: run `./build.sh` with progress in `out.log` and errors in `err.log`.
> `./build.sh > out.log 2> err.log`

##### `sort -o f f`: don't redirect into the file you're reading
Missed: 11-23 ❌ · ✅ 11-26 (1 of 2 to clear)

```bash
sort names.txt > names.txt        # ❌ file ends up empty
sort -o names.txt names.txt       # ✅ sort writes it safely
sort names.txt > tmp && mv tmp names.txt   # ✅ works for any command
```
The shell sets up `> names.txt` **before** the command runs, and `>` truncates the file to zero bytes. Then `sort` reads an empty file. `>>` doesn't fix it: it appends the sorted copy after the original lines.

> [!question]- Self-check: strip blank lines from `list.txt` in place with grep.
> `grep -v '^$' list.txt > tmp && mv tmp list.txt`

#### Permissions

##### `chmod 750`: turning `rwx` into numbers
Missed: 11-27 🟡 (wrote 710)

Each of the three groups (owner, group, others) gets one digit: add up **r=4, w=2, x=1**.

```bash
# -rwxr-x---  →  rwx | r-x | ---  →  7 | 5 | 0
chmod 750 deploy.sh
stat -c '%a %n' deploy.sh   # prints: 750 deploy.sh
```
`r-x` = 4+0+1 = **5**. A `1` would be `--x`: run but not read, which doesn't work for scripts because bash has to read the file to run it.

> [!question]- Self-check: what number is `rw-r-----`?
> `640` (rw = 6, r = 4, nothing = 0)

#### Environment

##### `export`: let child processes see a variable
Missed: 11-27 🟡 (tried `echo $MYVAR > hello`)

```bash
MYVAR=hello                 # shell variable: this shell only
bash -c 'echo "[$MYVAR]"'   # []
export MYVAR                # now an environment variable
bash -c 'echo "[$MYVAR]"'   # [hello]

CC=clang make               # one-off: set it for a single command
```
Scripts, `make` and `bash -c` all run as **child processes**, and they only inherit exported variables. `>` writes to a *file*, not a variable.

> [!question]- Self-check: your script can't see `$BUILD_DIR`, even though `echo $BUILD_DIR` works in your shell. Fix it.
> `export BUILD_DIR` (or run it as `BUILD_DIR=... ./script.sh`)

#### Loops

##### `for` loop over files
Missed: 11-27 ❌ (⚡ L4 preview)

A `for` loop runs the same commands once for each item in a list. Each time through, the variable holds the next item.

```bash
for VAR in LIST; do
    commands using "$VAR"
done

for f in *.txt; do echo "$f"; done     # one-liner form
for n in 1 2 3; do echo "$n"; done     # plain list
for i in {1..5}; do echo "$i"; done    # range
```
- The list is the **glob** `*.txt`, and the shell expands it into the file names. `.` is a single item.
- Read the variable with `$`: `"$f"`. Plain `f` is just the letter f.
- `do` and `done` each need a new line or `;` before them.

> [!question]- Self-check: make a `.bak` copy of every `.conf` file here.
> `for f in *.conf; do cp "$f" "$f.bak"; done`

#### Disk usage

##### `du -sh * | sort -h`: what's eating the space
Missed: 11-19 ❌

```bash
du -sh * | sort -h    # biggest last
```
`du` sums up everything inside each folder, which `ls -lh` doesn't do. `-s` gives one total per item, `-h` makes sizes readable, and `sort -h` understands `K`/`M`/`G`.

> [!question]- Self-check: show only the 3 biggest items here.
> `du -sh * | sort -h | tail -3`

#### Getting help

##### `--help | grep` / `man` then `/word`: find a flag
Missed: 11-18 ❌

```bash
ls --help | grep -i size    # → -S sort by size
man ls    # then type /size, press n for the next match
```
`apropos` finds *commands*, not flags.

> [!question]- Self-check: find the `grep` flag that counts matches.
> `grep --help | grep -i count` → `-c`

### Kernel track

No sessions yet.

## Parked
Out of the queue for now (it was full). Not quizzed, not cleared.

##### `rm -i`: ask before deleting
Parked 2026-11-21
Missed: 11-18 ❌ · ✅ 11-18 (1 of 2 to clear)

`rm -i file` asks `remove file?` before each delete. `rm -I` asks once for big deletes.

##### `whatis`: one-line description of a command
Parked 2026-11-21
Missed: 11-18 ❌ · ✅ 11-18 (1 of 2 to clear)

`whatis grep` prints the one-line summary from the man page. `apropos word` searches those summaries for commands.

##### `touch` on an existing file
Parked 2026-11-21
Missed: 11-18 ❌ · ✅ 11-18 (1 of 2 to clear)

`touch` creates a file if it's missing. If the file exists, it only updates the timestamp. The contents are left alone.

##### `>>` append vs `>` overwrite
Parked 2026-11-27
Missed: 11-17 🟡 · ✅ 11-18 (1 of 2 to clear)

```bash
echo hi >  log.txt    # wipe file, write "hi"
echo hi >> log.txt    # add "hi" to the end
```

> [!question]- Self-check: you run `date > log.txt` three times. How many lines are in the file?
> One. `>` empties the file every time.

##### `ls -A`: hidden files, without `.` and `..`
Parked 2026-11-27
Missed: 11-18 🟡 · ✅ 11-18 (1 of 2 to clear)

`-a` shows everything, including `.` and `..`. `-A` shows hidden files but skips those two.

> [!question]- Self-check: `ls -a` vs `ls -A` in an empty folder?
> `-a` shows `.  ..`, `-A` shows nothing.

## Cleared
Last 10 only.
- `2>&1` — cleared 2026-11-27
- `find ~ -type f -name/-size/-mtime` — cleared 2026-11-27
- `Ctrl+R` — cleared 2026-11-26
- `cut -d -f` — cleared 2026-11-25
- `sort | uniq -c | sort -nr` — cleared 2026-11-25
- `tr 'a-z' 'A-Z'` — cleared 2026-11-25
- `cmd | tee -a file` — cleared 2026-11-25
- `tail -n` (off-by-one) — cleared 2026-11-18
- `cd -` — cleared 2026-11-19
- `type` — cleared 2026-11-19

## Links

- ⬆ [[Mikoshi/Ripperdoc/Linux/Linux|Linux]]
- [[Mikoshi/Ripperdoc/Linux/Quiz|Quiz]]: the live Review Queue
