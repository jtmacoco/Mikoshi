---
Source: "[[Mikoshi/Ripperdoc/Linux/Linux|Linux]]"
Tags:
  - ripperdoc
  - linux
  - jacked-in
Created: 2026-11-17
---

# Linux Quiz

Adaptive command-line practice. Claude follows [[Mikoshi/CLAUDE]] to run sessions and updates this note after each one.
Say **"jack in"** to start.

---

## Current Status

Two tracks, leveled independently.

| Field | Main Track | Kernel Track |
|---|---|---|
| Current level | 2 — Punk | K1 — Ripper |
| Sessions at this level | 1 | 0 |
| Streak (≥80%) | 0 | 0 |
| Streak (<50%) | 0 | 0 |
| ⚡ Preview hits at level | 0 | 0 |
| Total sessions | 5 | 0 |
| Last session | 2026-11-19 (56%) | — |

| Say | Runs |
|---|---|
| "jack in" | Main track |
| "jack in kernel" | Kernel track |
| "jack in mixed" | 5 main + 5 kernel, each at its own level |
| "jack in make" / "jack in cmake" | Kernel track, that topic only, at my current K level |

---

## Review Queue

Commands/concepts I missed. An item clears after 2 ✅ in separate sessions.

| Command / Concept | Track | Level | Times missed | ✅ since | Last seen |
|---|---|---|---|---|---|
| `Ctrl+L` clear / `Ctrl+Z` suspends → `fg` to resume | Main | 1 | 2 | 1 | 2026-11-19 |
| `>>` append vs `>` overwrite | Main | 2 | 1 | 1 | 2026-11-18 |
| `rm -i` (prompt before delete) | Main | 1 | 1 | 1 | 2026-11-18 |
| `whatis` (one-line description) | Main | 1 | 1 | 1 | 2026-11-18 |
| `touch` existing file (timestamp only) | Main | 1 | 1 | 1 | 2026-11-18 |
| `ls -A` (hidden, minus `.` `..`) | Main | 1 | 1 | 1 | 2026-11-18 |
| `cmd --help \| grep` / `man` `/word` to find a flag (`ls -S`) | Main | 1 | 1 | 0 | 2026-11-18 |
| `grep -rn` (`-r` recursive, `-n` line numbers) | Main | 2 | 1 | 0 | 2026-11-19 |
| `uniq -c` (prefix counts; `sort` first) | Main | 2 | 1 | 0 | 2026-11-19 |
| `find . -type f -name` (no `-r`; always recurses) | Main | 2 | 1 | 0 | 2026-11-19 |
| `2>&1` (stderr → same place as stdout, not discarded) | Main | 2 | 1 | 0 | 2026-11-19 |
| `cut -d: -f1` / awk needs single quotes + `-F:` | Main | 2 | 1 | 0 | 2026-11-19 |
| `du -sh * \| sort -h` (biggest item in dir) | Main | 3 | 1 | 0 | 2026-11-19 |

---

## Syllabus

### Level 1 — Street Kid · Getting around
- Where am I / what's here: `pwd`, `ls`, `ls -la`, `ls -lh`, `ls -t`
- Moving: `cd`, `cd ~`, `cd -`, `cd ..`, absolute vs relative paths, `.` and `..`
- Making & moving: `mkdir`, `mkdir -p`, `touch`, `cp`, `cp -r`, `mv` (move + rename), `rm`, `rm -r`, `rm -i`, `rmdir`
- Reading files: `cat`, `less`, `head`, `tail`, `head -n`, `tail -n`
- Getting help: `man`, `--help`, `whatis`, `type`
- Keyboard: Tab completion, `↑`, `Ctrl+C`, `Ctrl+L`, `clear`

### Level 2 — Punk · Search, pipes & redirection
- Pipes: `|`, chaining commands
- Redirection: `>`, `>>`, `<`, `2>`, `2>&1`, `&>`, `/dev/null`
- Searching text: `grep`, `grep -i`, `-r`, `-n`, `-v`, `-c`, `-l`, `-E`
- Finding files: `find . -name`, `-iname`, `-type f/d`, `-mtime`, `-size`
- Text tools: `wc -l`, `sort`, `sort -n`, `sort -r`, `uniq`, `uniq -c`, `cut -d -f`, `tr`, `tee`
- Shell history: `history`, `!!`, `!$`, `Ctrl+R`
- Locating: `which`, `whereis`, `locate`

### Level 3 — Merc · Permissions, processes & the system
- Permissions: `rwx`, reading `ls -l`, `chmod 755`, `chmod +x`, `chmod u+w`, `chown`, `sudo`
- Processes: `ps aux`, `ps aux | grep`, `top`, `htop`, `kill`, `kill -9`, `pkill`, `pgrep`
- Jobs: `&`, `jobs`, `fg`, `bg`, `Ctrl+Z`, `nohup`
- Disk & memory: `df -h`, `du -sh`, `du -sh * | sort -h`, `free -h`
- Environment: `env`, `echo $PATH`, `export`, `alias`, `~/.bashrc`, `source`
- Archives: `tar -czf`, `tar -xzf`, `tar -tf`, `zip`, `unzip`, `gzip`
- Users & system: `whoami`, `id`, `uname -a`, `uptime`, `hostname`

### Level 4 — Netrunner · Loops & scripting basics
- Script setup: shebang `#!/usr/bin/env bash`, `chmod +x`, `./script.sh`
- Variables: assignment (no spaces!), `$var`, `"$var"`, `${var}`
- Quoting: `"double"` vs `'single'` vs no quotes, and why it matters
- Command substitution: `$(command)`
- Exit codes: `$?`, `&&`, `||`, `true`, `false`
- Conditionals: `if`, `[ ]` vs `[[ ]]`, `-f`, `-d`, `-z`, `-n`, `-eq`, `==`
- **for loops**: over a list, over files (`for f in *.txt`), over ranges (`{1..10}`, `seq`), C-style `for ((i=0; i<5; i++))`
- **while loops**: counters, `while read -r line; do …; done < file`, infinite loop with `break`
- `case` statements
- Arguments: `$1`, `$2`, `$@`, `$#`, `$0`
- Functions: defining, calling, `local`, `return`

### Level 5 — Fixer · Power tools
- `xargs`, `xargs -I {}`, `find … -print0 | xargs -0`
- `find … -exec cmd {} \;` vs `-exec cmd {} +`
- `awk`: `'{print $1}'`, `-F`, `NR`, `NF`, sums, conditions
- `sed`: `s/old/new/`, `s///g`, `-i`, deleting lines, ranges
- Brace expansion: `mkdir -p proj/{src,docs,tests}`, `cp file{,.bak}`
- Here-docs `<<EOF` and here-strings `<<<`
- Process substitution: `diff <(cmd1) <(cmd2)`
- Safety: `set -euo pipefail`, `trap … EXIT`
- Remote & network: `ssh`, `scp`, `rsync -avz`, `curl -s`, `curl -O`, `wget`, `ping`, `ss -tulpn`
- Services & logs: `systemctl status/start/enable`, `journalctl -u`, `journalctl -f`, `tail -f`
- Scheduling: `crontab -e`, cron syntax

### Level 6 — Legend · Niche daily drivers & mastery
- Parameter expansion: `${var:-default}`, `${var%.*}`, `${var##*/}`, `${var/old/new}`, `${#var}`
- Arrays: declare, loop `"${arr[@]}"`, `mapfile -t`
- `getopts` for script flags
- Comparing: `diff -u`, `comm`, `cmp`, `column -t`
- Watching & limiting: `watch -n`, `timeout`, `time`
- Debugging: `bash -x`, `set -x`, `strace`, `lsof`, `lsof -i :PORT`
- JSON: `jq '.key'`, `jq -r`, filters
- Multiplexing: `tmux` sessions, split, detach/attach
- One-liner challenges combining 3+ tools
- Real scenario chains: log analysis, bulk rename, cleanup scripts

---

## Kernel Track

Build systems, binaries and kernel tooling. Main track Level 4 (loops & scripting) helps from K3 on, but it isn't required.

### K1 — Ripper · Makefile foundations & gcc
- Anatomy: target, prerequisites, recipe. Recipes must start with a **tab**
- Default goal (first target), `make <target>`, `.PHONY`, `all`, `clean`
- Variables: `CC`, `CFLAGS`, `LDFLAGS`, `LDLIBS`
- Assignment: `=` (recursive) vs `:=` (immediate) vs `?=` (if unset) vs `+=` (append)
- Automatic variables: `$@`, `$<`, `$^`, `$?`, `$*`
- Pattern rules: `%.o: %.c`, built-in implicit rules and why `make -r` disables them
- Running make: `-n` (dry run), `-j$(nproc)`, `-B` (force), `-C dir`, `-f file`, `VAR=value` on the command line
- Silencing: `@` prefix, `-` prefix (ignore errors)
- gcc basics: `-c`, `-o`, `-Wall -Wextra -Werror`, `-g`, `-O0` / `-O2`, `-I`, `-D`, `-L`, `-l`
- gcc stages: `-E` (preprocess), `-S` (assembly), `-c` (object), then link
- **Build it:** write a Makefile for a small multi-file C project from scratch

### K2 — Chrome · Real Makefiles, binaries & kernel builds
- Functions: `$(wildcard)`, `$(patsubst)`, `$(SRCS:.c=.o)`, `$(addprefix)`, `$(notdir)`, `$(shell)`, `$(foreach)`
- Auto dependencies: `-MMD -MP` and `-include $(DEPS)`
- Out-of-tree build dirs: `$(BUILD)/%.o: src/%.c`, `mkdir -p $(@D)`
- Order-only prerequisites: `target: deps | $(BUILD)`
- Conditionals: `ifeq`, `ifdef`, `DEBUG=1` builds
- Debugging make: `$(info)`, `$(warning)`, `$(error)`, `make -p`, `make --trace`
- Freestanding kernel flags: `-ffreestanding`, `-nostdlib`, `-fno-builtin`, `-fno-stack-protector`, `-mno-red-zone`, `-fno-pic`, `-mcmodel=kernel`
- Linking: `ld -T linker.ld`, `-nostdlib`, `-Map=kernel.map`, what `ENTRY` and `SECTIONS` do in a linker script
- Assembling: `nasm -f elf64`, `as`, `.S` vs `.s` (preprocessed or not)
- Inspecting binaries: `objdump -d`, `-h`, `-M intel`, `readelf -h/-S/-s/-l`, `nm`, `size`, `file`, `xxd`, `hexdump -C`, `addr2line -e`, `objcopy -O binary`
- Linux kernel builds: `make defconfig`, `menuconfig`, `olddefconfig`, `make -j$(nproc)`, `V=1`, `O=build/`
- Kbuild modules: `obj-m += mod.o` and `make -C /lib/modules/$(uname -r)/build M=$(PWD) modules`
- **Build it:** a kernel Makefile with asm + C, a build dir, a linker script, and an `iso` or `run` target

### K3 — Black ICE · CMake
- Configure vs build: `cmake -S . -B build`, then `cmake --build build -j`
- Generators: `-G Ninja` vs Unix Makefiles, `cmake --build` works with either
- Cache variables: `-DCMAKE_BUILD_TYPE=Debug/Release/RelWithDebInfo`, `-D` options, `ccmake`, `cmake -L`, deleting `CMakeCache.txt`
- Basics: `cmake_minimum_required`, `project(… LANGUAGES C ASM)`, `add_executable`, `add_library` (STATIC/SHARED/OBJECT)
- Target-based commands: `target_include_directories`, `target_compile_options`, `target_compile_definitions`, `target_link_libraries`, `target_link_options`
- `PUBLIC` vs `PRIVATE` vs `INTERFACE`, and why target commands beat global `include_directories`
- Variables & logic: `set`, `option`, `if()`, `message()`, `file(GLOB …)` (and why people avoid it)
- `CMAKE_EXPORT_COMPILE_COMMANDS=ON` makes `compile_commands.json` for clangd / editor autocomplete
- Cross-compiling: toolchain files, `CMAKE_TOOLCHAIN_FILE`, `CMAKE_SYSTEM_NAME Generic`, `CMAKE_C_COMPILER`, `CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY`
- Kernel builds in CMake: linker script with `target_link_options(-T …)`, `set_target_properties(LINK_DEPENDS)`, custom post-build steps with `add_custom_command(POST_BUILD)`, `add_custom_target(run …)`
- Subprojects: `add_subdirectory`, `FetchContent` basics
- Testing: `enable_testing`, `add_test`, `ctest`
- Make vs CMake: when each is the better fit
- **Build it:** a `CMakeLists.txt` + toolchain file for a freestanding kernel

### K4 — Daemon · Run & debug
- QEMU: `qemu-system-x86_64 -kernel`, `-cdrom`, `-drive`, `-m`, `-smp`, `-nographic`, `-serial stdio`, `-d int,cpu_reset`, `-no-reboot`, `-no-shutdown`, `-monitor stdio`
- QEMU + GDB: `-s -S`, `gdb` → `target remote :1234`, `symbol-file`, `add-symbol-file`
- GDB: `break`, `hbreak`, `continue`, `step`/`next`/`stepi`, `info registers`, `x/16x $rsp`, `x/10i $rip`, `bt`, `layout asm`/`layout src`, `display`, `.gdbinit`
- Kernel runtime: `dmesg -w`, `dmesg -T`, `lsmod`, `insmod`, `rmmod`, `modprobe`, `modinfo`
- `/proc` and `/sys`: `/proc/cpuinfo`, `/proc/interrupts`, `/proc/meminfo`, `/proc/kallsyms`, `/sys/module`
- Disk images: `dd if= of= bs= count= conv=notrunc`, `mkfs`, `losetup`, `mount -o loop`, `grub-mkrescue`
- Tracing: `strace -f`, `ltrace`, `ldd`

### K5 — Soulkiller · Source tree, git & performance
- Navigating huge trees: `grep -rn --include='*.c'`, `rg` (ripgrep) with `-t c` and `-w`, `ctags -R`, `cscope -Rb`, `git grep`
- Git archaeology: `git log -S`, `git log -p -- file`, `git blame -L`, `git bisect start/good/bad/run`, `git show`
- Kernel-style patches: `git format-patch`, `git am`, `scripts/checkpatch.pl`, `scripts/get_maintainer.pl`
- Performance: `perf stat`, `perf record`/`perf report`, `perf top`, `time`, `valgrind` basics
- Static analysis: `make C=1` (sparse), `-fsanitize=address,undefined` for userspace test code
- Scenario chains: "kernel triple-faults on boot, find out why", "find which commit broke the build"

---

## Session Log

Newest first. Full details live in [[Results MOC]].

| Date | Track | Level | Score | Change | Note |
|---|---|---|---|---|---|
| 2026-11-19 | Main | 2 — Punk | 5 / 9 (56%) | none | [[2026-11-19 Linux Quiz]] |
| 2026-11-18 | Main | 1 — Street Kid | 7.5 / 9 (83%) | ⬆️ early up to 2 (3/3 previews) | [[2026-11-18 Linux Quiz 3]] |
| 2026-11-18 | Main | 1 — Street Kid | 7 / 9 (78%) | none | [[2026-11-18 Linux Quiz 2]] |
| 2026-11-18 | Main | 1 — Street Kid | 5 / 9 (56%) | none | [[2026-11-18 Linux Quiz]] |
| 2026-11-17 | Main | 1 — Street Kid | 6 / 9 (67%) | none | [[2026-11-17 Linux Quiz]] |
