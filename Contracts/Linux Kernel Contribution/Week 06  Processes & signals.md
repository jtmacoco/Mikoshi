---
title: Week 06  Processes & signals
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-17
status: on-contract
client: personal
deadline:
stack:
---

| Day       | Task (≈30 min)                                                                                                                                                                     |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | `fork()` hello world: parent prints its PID and the child's; child prints its own and its parent's. Then fork twice and draw the process tree on paper.                            |
| Tue       | `fork` + `execvp` + `waitpid`: run a command given on argv and report its exit status.                                                                                             |
| Wed       | **Mini shell, part 1**: read a line, split into argv tokens (use your strtok!), fork/exec/wait in a loop. `exit` builtin.                                                          |
| Thu       | **Mini shell, part 2**: add `cd` builtin and `>` output redirection (`open` + `dup2`).                                                                                             |
| Fri       | Signals: install a `SIGINT` handler with `sigaction` so Ctrl-C prints a message instead of killing your shell. Read why you can only call async-signal-safe functions in handlers. |
| Sat (lab) | **Mini shell, part 3**: pipes — support `cmd1                                                                                                                                      |
| Sun       | Rest / catch-up.                                                                                                                                                                   |
## Progress Log

- 2026-08-17: Contract initialized

# Monday

## Solution

```c
#include <stdio.h>
#include <unistd.h>
int main(){
	pid_t pid;
	pid = fork();
	if (pid == 0){
		printf("[CHILD] MY PID: %d\n",getpid());
		printf("[CHILD] My Parent's PID %d\n",pid);
	}
	else{
		printf("[PARENT] MY PID: %d\n",getpid());
		printf("[PARENT] My child's PID %d\n",pid);
	}
	return 0;
}
```

## Notes

- Child Process always returns 0
- `pid_t` is a PID data type specifically for processes
- `getpid()` is a function that retrieves the current processes PID
- `getppid()` retrieves the current process's parent's PID


```html-embed
Mikoshi/Contracts/Linux Kernel Contribution/Linux Kernel Contribution_Assets/fork_tree_animation.html
600
```

## Links

