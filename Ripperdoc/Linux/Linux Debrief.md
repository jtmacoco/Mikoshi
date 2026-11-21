---
title: Linux Debrief
source: "[[Mikoshi/Ripperdoc/Linux/Linux|Linux]]"
tags: [ripperdoc, linux, jacked-in]
created: 2026-11-21
status: active
---

## Description

Review notes built from the [[Mikoshi/Ripperdoc/Linux/Quiz#Review Queue|Review Queue]]. Read it before jacking in. Most-missed first. Answer each self-check in your head before you peek.

Built from: [[2026-11-21 Linux Quiz]]

## Notes

### Main track

#### Redirection

##### `2>&1`: send errors where normal output goes
Missed: 11-19 🟡 · 11-20 🟡 · 11-21 ❌

Every command has two output streams: **stdout** (1, normal output) and **stderr** (2, errors). Both show on your terminal, but `>` and `|` only grab stdout.

```bash
cmd > out.txt 2>&1     # both streams into the file
cmd 2>&1 | grep err    # both streams into the pipe
cmd |& grep err        # bash shortcut for the line above
```
Read `2>&1` as "2 goes to the same place as 1". Nothing is discarded. Only `2>/dev/null` throws errors away.

> [!question]- Self-check: `make | tee build.log` but the compiler errors aren't in the log. Fix it.
> `make 2>&1 | tee build.log`. The errors went to stderr, which skipped the pipe.

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
Missed: 11-19 ❌ · 11-20 ❌ · 11-21 ❌

`find` walks a directory tree and prints every path that passes all your filters. It always goes into subfolders, so there's no `-r`.

```bash
find <where> <filters>
find . -type f -name "*.log"      # files ending in .log
find . -type d -name build        # directories named build
find /var/log -type f -mtime -2   # files modified in the last 2 days
find . -size +100M                # bigger than 100 MB
```
`-type f` = file, `-type d` = directory. Quote the `-name` pattern so the shell doesn't expand `*` first. Leave off `2>/dev/null` until it works.

> [!question]- Self-check: list every `.o` file under `src/` changed in the last day.
> `find src -type f -name "*.o" -mtime -1`

#### Text tools

##### `sort | uniq -c | sort -nr`: count and rank
Missed: 11-19 🟡 · 11-20 🟡 · 11-21 ❌

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
Missed: 11-19 ❌ · 11-21 🟡

```bash
cut -d: -f1 /etc/passwd     # usernames
cut -d, -f2,3 users.csv     # keep columns 2 and 3
```
`-d` sets the delimiter and `-f` sets the fields to **keep**. To drop a column instead, use `--complement`. If you use awk, wrap it in single quotes: `awk -F: '{print $1}'`.

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
Missed: 11-21 ❌

By default grep prints every matching line. `-l` prints each matching **file name** once instead.

```bash
grep -rl "malloc" src/    # which files mention malloc
grep -rL "malloc" src/    # which files don't
```

> [!question]- Self-check: how many files under `src/` contain `TODO`?
> `grep -rl TODO src/ | wc -l`

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
Missed: 11-21 🟡

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

#### Listing

##### `ls -A`: hidden files, without `.` and `..`
Missed: 11-18 🟡 · ✅ 11-18 (1 of 2 to clear)

`-a` shows everything, including `.` and `..`. `-A` shows hidden files but skips those two.

> [!question]- Self-check: `ls -a` vs `ls -A` in an empty folder?
> `-a` shows `.  ..`, `-A` shows nothing.

#### Disk usage

##### `du -sh * | sort -h`: what's eating the space
Missed: 11-19 ❌

```bash
du -sh * | sort -h    # biggest last
```
`du` sums up everything inside each folder, which `ls -lh` doesn't do. `-s` gives one total per item, `-h` makes sizes readable, and `sort -h` understands `K`/`M`/`G`.

> [!question]- Self-check: show only the 3 biggest items here.
> `du -sh * | sort -h | tail -3`

### Kernel track

No sessions yet.

## Cleared
- `tail -n` (off-by-one) — cleared 2026-11-18
- `cd -` — cleared 2026-11-19
- `type` — cleared 2026-11-19
- `rm -i` — dropped from queue 2026-11-21 (queue cap, 1 ✅ of 2)
- `whatis` — dropped from queue 2026-11-21 (queue cap, 1 ✅ of 2)
- `touch` on existing file — dropped from queue 2026-11-21 (queue cap, 1 ✅ of 2)

## Links

- ⬆ [[Mikoshi/Ripperdoc/Linux/Linux|Linux]]
- [[Mikoshi/Ripperdoc/Linux/Quiz|Quiz]]: the live Review Queue
