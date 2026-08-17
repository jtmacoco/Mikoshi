---
title: Linux
source: "[[Quick Hacks]]"
tags:
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

## Search & Filter
| Command | Action |
|---|---|
| `grep -rn "pattern"` | Recursive search with line numbers |
| `grep -i` | Case insensitive |
| `awk '{print $1}'` | Print first column |
| `sed 's/old/new/g'` | Find and replace |
| `cut -d: -f1` | Cut by delimiter |

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
| Command | Action |
|---|---|
| `chmod 755` | rwx r-x r-x |
| `chmod 644` | rw- r-- r-- |
| `sudo !!` | Rerun last command as sudo |
| `chown -R` | Recursive ownership change |

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

