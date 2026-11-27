---
title: Linux
source: "[[Quick Hacks]]"
tags:
  - netrunner
  - linux
type: cheatsheet
created: 2026-08-15
---
## Navigation
|                      | Action                        |
| -------------------- | ----------------------------- |
| `pwd`                | Print working directory       |
| `cd -`               | Go to previous directory      |
| `ls -lah`            | List all files human readable |
| `tree -L 2`          | Directory tree 2 levels deep  |
| `find . -name "*.c"` | Find all .c files recursively |
| `find . -type d -name build` | Directories only (`-type f` = files only) |
| `find /var/log -type f -mtime -2` | Files modified in the last 2 days |
| `find ~ -type f -size +100M` | Files over 100 MB anywhere in home |

> `find` always recurses, so there's no `-r`. Quote the `-name` pattern. `.` = current dir, `~` = home. Add `-type f` when you only want files.

---

## File Operations
| Command            | Action                                       |
| ------------------ | -------------------------------------------- |
| `cp -r`            | Copy directory recursively                   |
| `mv`               | Move or rename                               |
| `rm -rf`           | Force delete recursively                     |
| `chmod +x`         | Make executable                              |
| `chown user:group` | Change ownership                             |
| `stat file`        | File metadata, size, permissions, timestamps |

---

## File Viewing
| Command      | Action                  |
| ------------ | ----------------------- |
| `cat`        | Print file              |
| `less`       | Scrollable file view    |
| `head -n 20` | First 20 lines          |
| `tail -f`    | Follow file live (logs) |
| `xxd`        | Hex dump                |

---

## Getting Help
| Command | Action |
|---|---|
| `type name` | Is it an alias, builtin, function or file? |
| `type -a name` | Every match (alias + `/usr/bin/...`) |
| `type -t name` | Category only, good for scripts |
| `whatis name` | One-line description from man page |
| `apropos word` | Find commands related to a word |

> `cd` is a **builtin**, not a program: a child process can't change your shell's directory.

---

## Search & Filter
| Command | Action |
|---|---|
| `grep -rn "pattern"` | Recursive search with line numbers |
| `grep -i` | Case insensitive |
| `grep -l TODO *.c` | File names only (pass files as args, don't pipe names in) |
| `grep -rl TODO --include='*.c' .` | Same, into subfolders, `.c` only |
| `awk '{print $1}'` | Print first column |
| `sed 's/old/new/g'` | Find and replace |
| `cut -d: -f1` | Keep field 1 (`-d` delimiter, `-f` fields to keep) |
| `cut -d: -f1,7` | Keep fields 1 and 7 → `root:/bin/bash` (one line, same delimiter) |
| `cut -d: -f1,7 --output-delimiter=' '` | Same, joined with a space |
| `sort \| uniq -c \| sort -nr` | Count each line, most frequent first |
| `tr 'a-z' 'A-Z' < file` | Uppercase (`tr` reads stdin only) |
| `tr -d '\r'` | Delete chars (strip Windows line endings) |

> `uniq` only collapses lines that sit next to each other, so always `sort` first.

---

## Shell History
| Command | Action |
|---|---|
| `Ctrl+R` | Search history as you type (`Ctrl+R` again = older match, `Ctrl+G` = cancel) |
| `history \| grep ssh` | Every past command with `ssh`, with numbers |
| `!512` | Rerun history entry 512 |

---

## Redirection
| Command | Action |
|---|---|
| `cmd > file` | stdout to file (overwrite) |
| `cmd >> file` | stdout to file (append) |
| `cmd > file 2>&1` | stdout **and** stderr to file |
| `cmd 2>&1 \| grep err` | Pipe errors too (`\|` only carries stdout) |
| `cmd \|& grep err` | Bash shortcut for `2>&1 \|` |
| `cmd 2>/dev/null` | Throw errors away (stdout still prints) |
| `cmd > /dev/null 2>&1` | Silence everything |
| `cmd &> /dev/null` | Bash shortcut for the line above |
| `cmd \| tee file` | Screen **and** file (`-a` appends) |
| `cmd 2>&1 \| tee -a log` | Screen + log, errors included |

> `2>&1` = "send stream 2 (stderr) to the same place as stream 1 (stdout)". Nothing is discarded. Order matters: `2>&1 > /dev/null` leaves errors on screen.

---

## Process Management
| Command | Action |
|---|---|
| `ps aux` | All running processes |
| `htop` | Interactive process viewer |
| `kill -9 PID` | Force kill process |
| `killall name` | Kill by process name |
| `jobs` | List background jobs |
| `fg` | Bring job to foreground |
| `Ctrl+Z` | Suspend process |
| `bg` | Resume in background |

---

## Networking
| Command | Action |
|---|---|
| `ip a` | Show network interfaces |
| `ping` | Test connectivity |
| `curl -I` | Fetch headers only |
| `wget` | Download file |
| `ss -tulnp` | Show open ports |
| `netstat -an` | Network connections |

---

## Disk & Memory
| Command | Action |
|---|---|
| `df -h` | Disk usage human readable |
| `du -sh *` | Size of each item in dir |
| `free -h` | Memory usage |
| `lsblk` | List block devices |

---

## Permissions
| Command     | Action                     |
| ----------- | -------------------------- |
| `chmod 755` | rwx r-x r-x                |
| `chmod 644` | rw- r-- r--                |
| `sudo !!`   | Rerun last command as sudo |
| `chown -R`  | Recursive ownership change |

| Value | Permission | Symbol |
|:-----:|:-----------|:------:|
| 4     | Read       | r      |
| 2     | Write      | w      |
| 1     | Execute    | x      |
| 0     | None       | -      |

| Position | Category | Description             |
|:--------:|:---------|:-------------------------|
| 1st      | User (u) | Owner of the file        |
| 2nd      | Group (g)| Users in the file's group|
| 3rd      | Others (o)| Everyone else           |
### Example

| Category | Value | Symbol | Meaning              |
| :------- | :---: | :----: | :------------------- |
| User     |   7   |  rwx   | Read, Write, Execute |
| Group    |   5   |  r-x   | Read, Execute        |
| Others   |   4   |  r--   | Read only            |

---

## Compression
| Command | Action |
|---|---|
| `tar -czf out.tar.gz dir/` | Compress directory |
| `tar -xzf file.tar.gz` | Extract |
| `zip -r out.zip dir/` | Zip directory |
| `unzip file.zip` | Unzip |

---

## System Info
| Command | Action |
|---|---|
| `uname -r` | Kernel version |
| `lscpu` | CPU info |
| `lspci` | PCI devices |
| `dmesg` | Kernel ring buffer |
| `uptime` | System uptime |

---

## One Liners
```bash
# Find largest files in current dir
du -ah . | sort -rh | head -20

# Kill all processes matching name
ps aux | grep name | awk '{print $2}' | xargs kill

# Watch a command every 2 seconds
watch -n 2 free -h

# Count lines in all .c files
find . -name "*.c" | xargs wc -l
```

