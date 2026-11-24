---
title: Linux Debrief
source: "[[Mikoshi/Ripperdoc/Linux/Linux|Linux]]"
tags: [ripperdoc, linux, jacked-in]
created: 2026-11-21
status: active
---

## Description

Review notes built from the [[Mikoshi/Ripperdoc/Linux/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Answer each self-check in your head before you peek.

Built from: [[2026-11-23 Linux Quiz]]

## Notes

### Main track

#### Redirection

##### `2>&1`: send errors where normal output goes
Missed: 11-19 🟡 · 11-20 🟡 · 11-21 ❌ · 11-23 🟡

Every command has two output streams: **stdout** (1, normal output) and **stderr** (2, errors). Both show on your terminal, but `>` and `|` only grab stdout.

```bash
cmd > out.txt 2>&1     # both streams into the file
cmd 2>&1 | grep err    # both streams into the pipe
cmd |& grep err        # bash shortcut for the line above
cmd > /dev/null 2>&1   # silence everything (or: cmd &> /dev/null)
```
Read `2>&1` as "2 goes to the same place as 1". Nothing is discarded. Only `2>/dev/null` throws errors away, and *only* errors. Stdout still prints.

> [!question]- Self-check: `make | tee build.log` but the compiler errors aren't in the log. Fix it.
> `make 2>&1 | tee build.log`. The errors went to stderr, which skipped the pipe.

##### `sort -o f f`: don't redirect into the file you're reading
Missed: 11-23 ❌

```bash
sort names.txt > names.txt        # ❌ file ends up empty
sort -o names.txt names.txt       # ✅ sort writes it safely
sort names.txt > tmp && mv tmp names.txt   # ✅ works for any command
```
The shell sets up `> names.txt` **before** the command runs, and `>` truncates the file to zero bytes. Then `sort` reads an empty file. `>>` doesn't fix it: it appends the sorted copy after the original lines.

> [!question]- Self-check: strip blank lines from `list.txt` in place with grep.
> `grep -v '^$' list.txt > tmp && mv tmp list.txt`

#### Finding files

##### `find`: search by name, type, age or size
Missed: 11-19 ❌ · 11-20 ❌ · 11-21 ❌ · 11-23 🟡

`find` walks a directory tree and prints every path that passes all your filters. It always goes into subfolders, so there's no `-r`.

```bash
find <where> <filters>
find . -type f -name "*.log"      # files ending in .log
find . -type d -name build        # directories named build
find /var/log -type f -mtime -2   # files modified in the last 2 days
find ~ -type f -size +100M        # files over 100 MB anywhere in home
```
`-type f` = file, `-type d` = directory. `.` = where you are now, `~` = home. Quote the `-name` pattern so the shell doesn't expand `*` first. Leave off `2>/dev/null` until it works.

> [!question]- Self-check: list every `.o` file under `src/` changed in the last day.
> `find src -type f -name "*.o" -mtime -1`

#### Text tools

##### `sort | uniq -c | sort -nr`: count and rank
Missed: 11-19 🟡 · 11-20 🟡 · 11-21 ❌ · ✅ 11-23 (1 of 2 to clear)

```bash
sort ips.txt | uniq -c | sort -nr | head
```
1. `sort` puts identical lines next to each other (`uniq` only collapses neighbours).
2. `uniq -c` collapses each group and puts the count in front.
3. `sort -nr` sorts by that number, biggest first.

`sort | uniq | wc -l` is a different question: how many *distinct* lines there are, as a single number.

> [!question]- Self-check: `words.txt` has one word per line. Show the 3 most common words.
> `sort words.txt | uniq -c | sort -nr | head -3`

##### `cut -d -f`: pick columns
Missed: 11-19 ❌ · 11-21 🟡 · 11-23 🟡

```bash
cut -d: -f1 /etc/passwd     # usernames
cut -d, -f2,3 users.csv     # keep columns 2 and 3
```
`-d` sets the delimiter and `-f` sets the fields to **keep**. Several fields print on **one line**, joined by the same delimiter: `echo a:b:c | cut -d: -f1,3` → `a:c`. To drop a column instead, use `--complement`. If you use awk, wrap it in single quotes: `awk -F: '{print $1}'`.

> [!question]- Self-check: what does `cut -d, -f1` print for the line `3,alice,/bin/sh`?
> `3`

##### `tr`: translate or delete characters
Missed: 11-20 ❌ · ✅ 11-21 (1 of 2 to clear)

```bash
tr 'a-z' 'A-Z'    # uppercase
tr -d '0-9'       # delete digits
tr -d '\r'        # strip Windows line endings
```
`tr` reads from stdin only, so feed it with a pipe or `<`.

> [!question]- Self-check: `echo "a-b-c" | tr '-' ' '` prints?
> `a b c`

##### `tee`: screen and file at once
Missed: 11-20 ❌ · ✅ 11-21 (1 of 2 to clear)

```bash
make 2>&1 | tee -a build.log
```
`-a` appends instead of overwriting.

> [!question]- Self-check: save `dmesg` to `boot.txt` and still see it on screen.
> `dmesg | tee boot.txt`

#### Searching text

##### `grep -l`: just the file names
Missed: 11-21 ❌ · 11-23 ❌

By default grep prints every matching line. `-l` prints each matching **file name** once instead.

```bash
grep -rl "malloc" src/    # which files mention malloc
grep -rL "malloc" src/    # which files don't
grep -l ssh /etc/*.conf   # which .conf files mention ssh
```
Give grep the files as **arguments** to search inside them. `find ... | grep ssh` only searches the list of names.

> [!question]- Self-check: how many files under `src/` contain `TODO`?
> `grep -rl TODO src/ | wc -l`

##### `grep -c`: count matching lines
Missed: 11-23 ❌

```bash
grep -c "ERROR" app.log            # number of lines with ERROR
grep "ERROR" app.log | wc -l       # same thing
grep -o "ERROR" app.log | wc -l    # every match, even 2 on one line
```
`-c` = count. `-n` = line numbers in front of each match, which still prints every line.

> [!question]- Self-check: how many lines in `/etc/passwd` end in `bash`?
> `grep -c 'bash$' /etc/passwd`

##### `grep -E`: match this or that
Missed: 11-21 🟡

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

#### Shell history

##### `Ctrl+R`: search history as you type
Missed: 11-21 🟡 · ✅ 11-23 (1 of 2 to clear)

Press `Ctrl+R` and start typing part of an old command. The most recent match appears.
- `Ctrl+R` again: next older match
- `Enter`: run it
- `→`: put it on the line to edit
- `Ctrl+G`: cancel

```bash
history | grep qemu    # the long way
!1234                  # rerun history line 1234
```

> [!question]- Self-check: pull back your last `qemu-system-x86_64` command without scrolling.
> `Ctrl+R`, type `qemu`, then press Enter.

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
Missed: 11-23 🟡 (⚡ L3 preview)

```bash
pgrep firefox        # PIDs only
pgrep -a firefox     # PID + full command line
pkill firefox        # skip the lookup, send SIGTERM
kill -9 1234         # force-kill one PID
```
`pgrep` and `pkill` match names the same way. `pgrep` shows the PID, `pkill` sends the signal.

> [!question]- Self-check: check whether any `qemu` process is still running.
> `pgrep -a qemu`. No output means none.

### Kernel track

No sessions yet.

## Parked
Out of the queue for now (it was full). Not quizzed, not cleared.

##### `>>` append vs `>` overwrite
Parked 2026-11-23
Missed: 11-17 🟡 · ✅ 11-18 (1 of 2 to clear)

```bash
echo hi >  log.txt    # wipe file, write "hi"
echo hi >> log.txt    # add "hi" to the end
```

> [!question]- Self-check: you run `date > log.txt` three times. How many lines are in the file?
> One. `>` empties the file every time.

##### `--help | grep` / `man` then `/word`: find a flag
Parked 2026-11-23
Missed: 11-18 ❌

```bash
ls --help | grep -i size    # → -S sort by size
man ls    # then type /size, press n for the next match
```
`apropos` finds *commands*, not flags.

> [!question]- Self-check: find the `grep` flag that counts matches.
> `grep --help | grep -i count` → `-c`

##### `ls -A`: hidden files, without `.` and `..`
Parked 2026-11-23
Missed: 11-18 🟡 · ✅ 11-18 (1 of 2 to clear)

`-a` shows everything, including `.` and `..`. `-A` shows hidden files but skips those two.

> [!question]- Self-check: `ls -a` vs `ls -A` in an empty folder?
> `-a` shows `.  ..`, `-A` shows nothing.

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
- `tail -n` (off-by-one) — cleared 2026-11-18
- `cd -` — cleared 2026-11-19
- `type` — cleared 2026-11-19

## Links

- ⬆ [[Mikoshi/Ripperdoc/Linux/Linux|Linux]]
- [[Mikoshi/Ripperdoc/Linux/Quiz|Quiz]]: the live Review Queue
