---
title: Linux Debrief
source: "[[Mikoshi/Ripperdoc/Linux/Linux|Linux]]"
tags: [ripperdoc, linux, jacked-in]
created: 2026-11-21
status: active
---

## Description

Review notes built from the [[Mikoshi/Ripperdoc/Linux/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Answer each self-check in your head before you peek.

Built from: [[2026-11-26 Linux Quiz]]

## Notes

### Main track

#### Redirection

##### `2>&1`: send errors where normal output goes
Missed: 11-19 🟡 · 11-20 🟡 · 11-21 ❌ · 11-23 🟡 · 11-24 ❌ · 11-24 drill ❌ · 11-25 ❌ (Q1 reading it ✅, Q7 writing it ❌) · ✅ 11-26 (1 of 2 to clear)

Every command has two output streams: **stdout** (1, normal output) and **stderr** (2, errors). Both show on your terminal, but `>` and `|` only grab stdout.

```bash
cmd > out.txt 2>&1     # both streams into the file
cmd 2>&1 | grep err    # both streams into the pipe
cmd |& grep err        # bash shortcut for the line above
cmd > /dev/null 2>&1   # silence everything (or: cmd &> /dev/null)
```
Read `2>&1` as "2 goes to the same place as 1". Nothing is discarded. Only `2>/dev/null` throws errors away, and *only* errors. Stdout still prints.

Think of two hoses, both aimed at the screen at the start. Bash reads redirects **left to right**, and each one re-aims one hose. `2>&1` **copies** where hose 1 points *right now*. It's not a permanent link, so put it **last**.

| Command | Hose 1 ends at | Hose 2 ends at |
|---|---|---|
| `cmd > f 2>&1` | f | f ✅ |
| `cmd 2>&1 > f` | f | screen (copied before hose 1 moved) |
| `cmd 2>/dev/null 2>&1` | screen | screen (re-aimed back) |
| `cmd > f 2>&1 > /dev/null` | trash (last redirect wins) | f |

Sending a hose to a file **already takes it off the screen**. Add `/dev/null` only when you want output gone.

Don't drop the arrow: `make build.log 2>&1` has no `>`, so make reads `build.log` as a **target** to build. The file name always comes right after `>` or `&>`.

```bash
make > build.log 2>&1   # ✅
make &> build.log       # ✅ shorthand
make build.log &>       # ❌ no file after &>
```

> [!question]- Self-check: what lands on screen for `ls /tmp /nope 2>&1 > out.txt`?
> The `/nope` error. Hose 2 copied "screen" before hose 1 moved to the file.

> [!question]- Self-check: save everything `./run.sh` prints into `all.log`, nothing on screen. Two ways.
> `./run.sh > all.log 2>&1` or `./run.sh &> all.log`

> [!question]- Self-check: `make | tee build.log` but the compiler errors aren't in the log. Fix it.
> `make 2>&1 | tee build.log`. The errors went to stderr, which skipped the pipe.

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

##### `>>` append vs `>` overwrite
Missed: 11-17 🟡 · ✅ 11-18 (1 of 2 to clear)

```bash
echo hi >  log.txt    # wipe file, write "hi"
echo hi >> log.txt    # add "hi" to the end
```

> [!question]- Self-check: you run `date > log.txt` three times. How many lines are in the file?
> One. `>` empties the file every time.

#### Finding files

##### `find`: search by name, type, age or size
Missed: 11-19 ❌ · 11-20 ❌ · 11-21 ❌ · 11-23 🟡 · 11-24 🟡 · 11-25 🟡 · ✅ 11-26 (1 of 2 to clear)

`find` walks a directory tree and prints every path that passes all your filters. It always goes into subfolders, so there's no `-r`.

```bash
find <where> <filters>
find . -type f -name "*.log"      # files ending in .log
find . -type d -name build        # directories named build
find /var/log -type f -mtime -2   # files modified in the last 2 days
find ~ -type f -size +100M        # files over 100 MB anywhere in home
```
`-type f` = file, `-type d` = directory. `.` = where you are now, `~` = **your** home (`/home/you`). `/home` is the folder that holds *every* user's home, so searching it hits other users' files and throws `Permission denied`. Quote the `-name` pattern so the shell doesn't expand `*` first. Leave off `2>/dev/null` until it works.

> [!question]- Self-check: list every `.o` file under `src/` changed in the last day.
> `find src -type f -name "*.o" -mtime -1`

#### Searching text

##### `grep -l`: just the file names
Missed: 11-21 ❌ · 11-23 ❌ · ✅ 11-24 · 11-26 ❌ (0 of 2 to clear)

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

#### Keyboard

##### `Ctrl+L` clear / `Ctrl+Z` suspend → `fg`
Missed: 11-17 🟡 · 11-18 🟡 · ✅ 11-19 (1 of 2 to clear)

`Ctrl+L` clears the screen. `Ctrl+Z` pauses (suspends) the running program, and `fg` brings it back. `Ctrl+C` is the one that kills it.

> [!question]- Self-check: you hit `Ctrl+Z` in vim by accident. Get back in.
> `fg`. Don't reopen the file, or you'll get a swap-file warning.

#### Disk usage

##### `du -sh * | sort -h`: what's eating the space
Missed: 11-19 ❌

```bash
du -sh * | sort -h    # biggest last
```
`du` sums up everything inside each folder, which `ls -lh` doesn't do. `-s` gives one total per item, `-h` makes sizes readable, and `sort -h` understands `K`/`M`/`G`.

> [!question]- Self-check: show only the 3 biggest items here.
> `du -sh * | sort -h | tail -3`

#### Processes

##### `pgrep`: find a PID by name
Missed: 11-23 🟡 (⚡ L3 preview) · 11-26 🟡 (⚡ L3 preview, `pgrep Firefox`)

```bash
pgrep firefox        # PIDs only
pgrep -a firefox     # PID + full command line
pkill firefox        # skip the lookup, send SIGTERM
kill -9 1234         # force-kill one PID
```
`pgrep` and `pkill` match names the same way, and the match is **case-sensitive**: the process is `firefox`, not `Firefox`. Use `-i` to ignore case. `pgrep` shows the PID, `pkill` sends the signal.

> [!question]- Self-check: check whether any `qemu` process is still running.
> `pgrep -a qemu`. No output means none.

#### Navigation

##### `ls -A`: hidden files, without `.` and `..`
Missed: 11-18 🟡 · ✅ 11-18 (1 of 2 to clear)

`-a` shows everything, including `.` and `..`. `-A` shows hidden files but skips those two.

> [!question]- Self-check: `ls -a` vs `ls -A` in an empty folder?
> `-a` shows `.  ..`, `-A` shows nothing.

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

## Cleared
Last 10 only.
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
