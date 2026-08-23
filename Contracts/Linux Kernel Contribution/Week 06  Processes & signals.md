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


# Wednesday

## Solution

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <wait.h>

char *my_strtok(char *restrict str, const char *restrict delim){
	size_t count = 0;
	static char *saved = NULL;
	if (str == NULL){
		str = saved;
	}
	if (str == NULL){
		return NULL;
	}
	str += strspn(str,delim);//moved after checks
	if (*str == '\0'){
		saved = NULL;
		return NULL;
	}
	char *token_end = str + strcspn(str,delim);
	if (*token_end == '\0'){
		saved = NULL;
	}
	else{
		*token_end = '\0';
		saved = token_end+1;
	}
	return str;
}

int main(int argc, char **argv){
	char line[1024];
	while(1){
		printf("myShel> ");
		if (!fgets(line,sizeof(line),stdin)) break;
		char *args[64];
		int i = 0;
		char *tok = my_strtok(line, " \t\n");
		while (tok != NULL){
			args[i++] = tok;
			tok = my_strtok(NULL, " \t\n");
		}
		args[i] = NULL;//set end
		if (i == 0) continue;                     
		if (strcmp(args[0], "exit") == 0) break;
		pid_t pid;
		pid = fork();
		if (pid == 0){//child
			execvp(args[0], args);
			perror("exec failed");
			_exit(1);
		}
		else if (pid > 0){//parent
			int status;
			waitpid(pid,&status,0);
		}else{
			perror("fork failed");
			continue;
		}
		
	}
}
```

## Notes

- `fgets`: Function used to read line of text or string from specified input stream
- `fgets` : `char *fgets(char *str, int n, FILE *stream);`
- fixed `my_strtok`: had issue where would move str before the `NULL` check so moved it down after check


# Thursday

## Solution 

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <wait.h>

char *my_strtok(char *restrict str, const char *restrict delim){
	size_t count = 0;
	static char *saved = NULL;
	if (str == NULL){
		str = saved;
	}
	if (str == NULL){
		return NULL;
	}
	str += strspn(str,delim);
	if (*str == '\0'){
		saved = NULL;
		return NULL;
	}
	char *token_end = str + strcspn(str,delim);
	if (*token_end == '\0'){
		saved = NULL;
	}
	else{
		*token_end = '\0';
		saved = token_end+1;
	}
	return str;
}

int main(int argc, char **argv){
	char line[1024];
	while(1){
		printf("myShel> ");
		if (!fgets(line,sizeof(line),stdin)) break;
		char *args[64];
		int i = 0;
		char *tok = my_strtok(line, " \t\n");
		while (tok != NULL){
			args[i++] = tok;
			tok = my_strtok(NULL, " \t\n");
		}
		args[i] = NULL;//set end
		if (i == 0) continue;                       
		
		if (strcmp(args[0], "exit") == 0) break;

		if (strcmp(args[0], "cd") == 0){//verify path
			const char *path = args[1];
			if (path == NULL){
				path = getenv("HOME");
				if (path == NULL){
					perror("cd: HOME not set\n");
					continue;
				}
			}
			if(chdir(path) != 0){
				perror("cd");
			}
			continue;
		}
		//output redirection
		char *outFile = NULL;
		for (int j = 0; args[j] != NULL; j++){
			if(strcmp(args[j], ">") == 0){
				args[j] = NULL;
				outFile = args[j+1];
				break;
			}
		}
		pid_t pid;
		pid = fork();
		if (pid == 0){//child
			if (outFile != NULL){
				int fd = open(outFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
				if (fd < 0){
					perror("open failed");
					_exit(1);
				}
				if (dup2(fd,STDOUT_FILENO) < 0){
					perror("dup2 failed");
					_exit(1);
				}
				close(fd);
			}
			execvp(args[0], args);
			perror("exec failed");
			_exit(1);
		}
		else if (pid > 0){//parent
			int status;
			waitpid(pid,&status,0);
		}else{
			perror("fork failed");
			continue;
		}
		
	}
}
```

## Notes

- `chdir()`: A function used to change the current working directory of calling process
- `dup2()`: used to duplicate existing file descriptor to a specific user defined file descriptor

# Friday

## Solution
```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <wait.h>

void handle_sigint(int sig){
	write(STDOUT_FILENO, "\n", 6);
}

char *my_strtok(char *restrict str, const char *restrict delim){
	size_t count = 0;
	static char *saved = NULL;
	if (str == NULL){
		str = saved;
	}
	if (str == NULL){
		return NULL;
	}
	str += strspn(str,delim);
	if (*str == '\0'){
		saved = NULL;
		return NULL;
	}
	char *token_end = str + strcspn(str,delim);
	if (*token_end == '\0'){
		saved = NULL;
	}
	else{
		*token_end = '\0';
		saved = token_end+1;
	}
	return str;
}

int main(int argc, char **argv){
	char line[1024];
	struct sigaction sa;
	sa.sa_handler = handle_sigint;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART;
	sigaction(SIGINT, &sa, NULL);
	while(1){
		printf("myShel> ");
		if (!fgets(line,sizeof(line),stdin)) break;
		char *args[64];
		int i = 0;
		char *tok = my_strtok(line, " \t\n");
		while (tok != NULL){
			args[i++] = tok;
			tok = my_strtok(NULL, " \t\n");
		}
		args[i] = NULL;//set end
		if (i == 0) continue;                       
		
		if (strcmp(args[0], "exit") == 0) break;

		if (strcmp(args[0], "cd") == 0){//verify path
			const char *path = args[1];
			if (path == NULL){
				path = getenv("HOME");
				if (path == NULL){
					perror("cd: HOME not set\n");
					continue;
				}
			}
			if(chdir(path) != 0){
				perror("cd");
			}
			continue;
		}
		//output redirection
		char *outFile = NULL;
		for (int j = 0; args[j] != NULL; j++){
			if(strcmp(args[j], ">") == 0){
				args[j] = NULL;
				outFile = args[j+1];
				break;
			}
		}
		pid_t pid;
		pid = fork();
		if (pid == 0){//child
			signal(SIGINT, SIG_DFL);
			if (outFile != NULL){
				int fd = open(outFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
				if (fd < 0){
					perror("open failed");
					_exit(1);
				}
				if (dup2(fd,STDOUT_FILENO) < 0){
					perror("dup2 failed");
					_exit(1);
				}
				close(fd);
			}
			execvp(args[0], args);
			perror("exec failed");
			_exit(1);
		}
		else if (pid > 0){//parent
			int status;
			waitpid(pid,&status,0);
			if (WIFSIGNALED(status)){
				int sig = WTERMSIG(status);
				if (sig == SIGINT){
					printf("terminate\n");
				}else{
					printf("Termianted by signal %d\n",sig);
				}
			}
		}else{
			perror("fork failed");
			continue;
		}
		
	}
}
```

## Notes

- `sigaction ` modern version to tell the kernel when this signal arrives run this function, it replaced the older `signal()` function
- A signal is an async notification from the kernel to your process. When it arrives it interrupts the flow of the program
- `SIGINT` is what the kernel sends when someone presses `Ctrl-C` in the terminal
- 3 **handling modes** per signal:
	1. **Default action**(`SIG_DFL`) - for `SIGINT` means terminate the process 
	2. **Ignore**(`SIG_IGN`) - signal is silently discarded, nothing happens
	3. **Custom handler** - write own function that will run instead
- `sa_handler` is a function pointer, it's the function the kernel will jump to when the signal arrives, most have the signature of `void handler(int sig)`
- `sa_mask` - a set of other signals to temporarily block while your handler is running, `sigemptyset(&sa.sa_mask)` just zeroes it out meaning don't block anything extra
- `sa_flags` - tweaks behavior. `SA_RESTART`: normally if a signal interrupts a blocking system, that call fails immediately and returns `-1`, `SA_RESTART` tells the kernel if this signal interrupts a restartable syscall, just automatically resume it
- `sigaction()` - signature is:

```c
int sigaction(int signum, const struct sigaction *act, structaction *oldact)
```

- `signum`: which signal you're configuring (`SIGINT`)
- `act`: the new configuration you want (the struct you built)
- `oldact`: optional out-parameter to save the _previous_ configuration, so you could restore it later. You pass `NULL` since you don't need it.
- After `execvp` once it succeeds, the entire image is replaced with a new program, that programs code doesn't know about the `handle_sigint` function. So it falls back to the default function

The rule POSIX sets is:

- Signal disposition was `SIG_DFL` → stays `SIG_DFL` after exec (no change).
- Signal disposition was `SIG_IGN` → stays `SIG_IGN` after exec (preserved, since "ignore" needs no code pointer).
- Signal disposition was a **custom handler function** → reset to `SIG_DFL` after exec.

So in this case falls back to the custom handler function
- The code at the top setting the `sigaction` struct overrides the default function basically
- **hangs until Enter** because of how `SA_RESTART` works

### What's actually happening

```c
while(1){
    printf("myShel> ");
    if (!fgets(line,sizeof(line),stdin)) break;   // <-- SIGINT arrives HERE, mid-call
    ...
}
```

When you press Ctrl-C while `fgets` is blocked waiting for input:

1. The kernel delivers `SIGINT`.
2. Your handler runs, does `write(STDOUT_FILENO, "\n", 1)` — that's the blank-looking newline you see.
3. Handler returns.
4. Because of `SA_RESTART`, the kernel **resumes the exact same `fgets` call** — not the top of the `while` loop, not the `printf` — just the same blocked read, still waiting for a line of input.

# Saturday

## Solution

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <wait.h>

void handle_sigint(int sig){
	write(STDOUT_FILENO, "\n", 1);
}

char *my_strtok(char *restrict str, const char *restrict delim){
	size_t count = 0;
	static char *saved = NULL;
	if (str == NULL){
		str = saved;
	}
	if (str == NULL){
		return NULL;
	}
	str += strspn(str,delim);
	if (*str == '\0'){
		saved = NULL;
		return NULL;
	}
	char *token_end = str + strcspn(str,delim);
	if (*token_end == '\0'){
		saved = NULL;
	}
	else{
		*token_end = '\0';
		saved = token_end+1;
	}
	return str;
}

int main(int argc, char **argv){
	char line[1024];
	struct sigaction sa;
	sa.sa_handler = handle_sigint;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART;
	sigaction(SIGINT, &sa, NULL);
	while(1){
		printf("myShel> ");
		if (!fgets(line,sizeof(line),stdin)) break;
		char *args[64];
		int i = 0;
		char *tok = my_strtok(line, " \t\n");
		while (tok != NULL){
			args[i++] = tok;
			tok = my_strtok(NULL, " \t\n");
		}
		args[i] = NULL;//set end
		if (i == 0) continue;                       

		if (strcmp(args[0], "exit") == 0) break;

		if (strcmp(args[0], "cd") == 0){//verify path
			const char *path = args[1];
			if (path == NULL){
				path = getenv("HOME");
				if (path == NULL){
					perror("cd: HOME not set\n");
					continue;
				}
			}
			if(chdir(path) != 0){
				perror("cd");
			}
			continue;
		}
		//output redirection
		char *outFile = NULL;
		for (int j = 0; args[j] != NULL; j++){
			if(strcmp(args[j], ">") == 0){
				args[j] = NULL;
				outFile = args[j+1];
				break;
			}
		}

		char **cmds[64];
		int numCmds = 0;
		cmds[numCmds++] = &args[0];//postfix
		for (int j = 0; args[j] != NULL; j++){
			if (strcmp(args[j], "|") == 0){
				args[j] = NULL;
				cmds[numCmds++] = &args[j+1];
			}
		}
		int pipes[numCmds - 1 > 0 ? numCmds -1 : 1][2];
		for (int j = 0; j < numCmds -1 ; j++){
			if (pipe(pipes[j]) < 0){
				perror("pipe failed");
				_exit(-1);
			}
		}
		pid_t pids[64];
		int forkFailed = 0;
		for (int j = 0; j < numCmds; j++){
			pid_t pid;
			pid = fork();
			if (pid == 0){//child
				signal(SIGINT, SIG_DFL);

				if ( j > 0){
					dup2(pipes[j-1][0], STDIN_FILENO);
				}
				if ( j < numCmds - 1){
					dup2(pipes[j][1], STDOUT_FILENO);
				}
				for (int k = 0; k < numCmds - 1; k++){
					close(pipes[k][0]);
					close(pipes[k][1]);
				}

				if (j == numCmds -1 && outFile != NULL){
					int fd = open(outFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
					if (fd < 0){
						perror("open failed");
						_exit(1);
					}
					if (dup2(fd,STDOUT_FILENO) < 0){
						perror("dup2 failed");
						_exit(1);
					}
					close(fd);
				}
				execvp(cmds[j][0], cmds[j]);
				perror("exec failed");
				_exit(1);
			}
			else if (pid > 0){//parent
				pids[j] = pid;
			}else{
				perror("fork failed");
				forkFailed = 1;
				pids[j] = -1;
			}
		}
		for (int k = 0; k < numCmds - 1; k++){
			close(pipes[k][0]);
			close(pipes[k][1]);
		}
		for (int j = 0; j < numCmds; j++){
			if (pids[j] <= 0) continue;
			int status;
			waitpid(pids[j], &status, 0);
			if (WIFSIGNALED(status)){
				int sig = WTERMSIG(status);
				if (sig == SIGINT){
					printf("terminate\n");
				}else{
					printf("Terminated by signal %d\n",sig);
				}
			}
		}
		if (forkFailed) continue;

	}
}
```
## Notes

- Each pipe gets it's own string of commands from `args` which is why it needs to be a double pointer

Walk through the types:

- `args` is declared as `char *args[64]`. So `args` is an array of `char*`. The type of `args[0]` is `char*`. The type of `&args[0]` is `char**` (a pointer to a `char*`).
- Each `cmds[j]` needs to hold one of these `&args[...]` values — a pointer to "the first `char*` in this command's slice of the array."
- So `cmds` needs to be an array of `char**`, i.e. `char **cmds[64]`.

Think of it in layers:

```c
char*        →  a string (e.g. "ls")
char*[]      →  an argv array (e.g. args = {"ls", "-la", NULL})
char**       →  a pointer to the start of an argv array
char**[]     →  cmds: an array of pointers, each pointing to the start of a different argv array
```

Concretely, for `ls -la | grep foo | wc -l`, after parsing, `args` in memory looks like:

```c
args[0] = "ls"
args[1] = "-la"
args[2] = NULL     (was "|", nulled out)
args[3] = "grep"
args[4] = "foo"
args[5] = NULL     (was "|", nulled out)
args[6] = "wc"
args[7] = "-l"
args[8] = NULL
```

And `cmds` just stores three pointers _into_ that same array, marking where each command starts:

```c
cmds[0] = &args[0]   →  points at "ls",   reading forward hits {"ls","-la",NULL}
cmds[1] = &args[3]   →  points at "grep", reading forward hits {"grep","foo",NULL}
cmds[2] = &args[6]   →  points at "wc",   reading forward hits {"wc","-l",NULL}
```

- `pids[64]` since each fork call gives back different `pid` since forking `numCmds` times 

```c
#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2
```

### What a file descriptor actually is

Every process has a small table (managed by the kernel) mapping small integers → open "things" (files, pipes, sockets, terminals, whatever). By convention, when a process starts, the OS/shell has already set up:

- fd `0` → wherever input comes from (usually your terminal keyboard)
- fd `1` → wherever output goes (usually your terminal screen)
- fd `2` → wherever errors go (usually also your terminal screen)

```c 
else if (pid > 0){//parent
	pids[j] = pid;
}
```

- Record it instead of waiting immediately because it can cause a deadlock in the pipe.

Without this line, `pids[j]` would stay whatever garbage/uninitialized value it had (since you never assigned it), and your later `waitpid(pids[j], ...)` loop would be calling `waitpid` on garbage PIDs instead of your actual children — likely producing `ECHILD` errors or, worse, silently doing nothing useful for that slot.

So to directly answer "what's the point": it's the parent's bookkeeping step — the moment it captures and stores the child's PID before moving on to fork the next pipeline stage, so that the deferred `waitpid` loop later has something valid to work with.

## Links

