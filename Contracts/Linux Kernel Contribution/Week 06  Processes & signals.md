---
title: Week 06  Processes & signals
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-17
status: on-contract
client: personal
deadline:
stack: c
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

# Tuesday

## Solution

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
int main(int argc, char **argv){
	pid_t pid;

	pid = fork();
	if (pid == 0){
		execvp(argv[1],&argv[1]);
		perror("execvp");
		_exit(127);
	}
	else if (pid > 0){
		int status;
		waitpid(pid, &status, 0);
		if (WIFEXITED(status)) {
			printf("Exited with code %d\n", WEXITSTATUS(status));
		} else if (WIFSIGNALED(status)) {
			printf("Killed by signal %d\n", WTERMSIG(status));
		}

	}
	else{
		perror("fork failed");
	}

}
```

## Notes

- `execvp`: replaces the currently running process's program with a different one, it doesn't create a new process, it transforms the existing one

Breaking down the name:

exec = execute a new program
v = you pass arguments as a vector: a NULL-terminated array of strings (char *argv[]), rather than as separate arguments
p = it searches your $PATH environment variable to find the executable, so you can write "ls" instead of typing out "/bin/ls"

- `execvp` the second argument 

- `waitpid()` is a system call that pauses a parent process until  a specific child process changes state

`WIFEXITED` and `WIFSIGNALED` are macros that let you interpret the `status` value that `waitpid` fills in — because `status` isn't a simple "exit code," it's a packed integer that encodes _several_ possible outcomes, and you need these macros to safely pull out the right one.
## Links

