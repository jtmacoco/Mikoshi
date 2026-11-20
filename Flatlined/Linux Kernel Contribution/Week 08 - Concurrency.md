---
title: Week 08 - Concurrency
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-31
status: on-contract
client: personal
deadline:
stack: c
---
| Day       | Task (≈30 min)                                                                                                                                                                   |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Two pthreads increment a shared counter 1M times each _without_ locking. Run it five times, watch the result differ. Your first data race.                                       |
| Tue       | Fix it with a `pthread_mutex_t`. Then fix it again with C11 `atomic_fetch_add`. Time all three versions.                                                                         |
| Wed       | Producer/consumer: one thread `rb_put`s into your Week-4 ring buffer, another `rb_get`s, guarded by a mutex + condition variable.                                                |
| Thu       | Deadlock on purpose: two threads, two mutexes, opposite lock order. Watch it hang, attach `gdb` to see where. Fix with consistent lock ordering.                                 |
| Fri       | Run Monday's racy program under `valgrind --tool=helgrind` or build with `-fsanitize=thread`. Read the report fully.                                                             |
| Sat (lab) | Read about spinlocks vs mutexes and why the kernel cares about the difference (you can't sleep in interrupt context). Skim Billimoria's locking chapters if you've reached them. |
| Sun       | Rest / catch-up. Phase 2 done — userspace holds no mysteries.                                                                                                                    |


## Progress Log

- 2026-08-31: Contract initialized


# Monday

## Solution

```c
#include <pthread.h>
#include <stdio.h>
int counter = 0;
void* increment(void* N){
	for (int i = 0; i < 1000000; i++){
		counter++;
	}
	return NULL;
}
int main(){
	printf("Monday\n");
	pthread_t thread1;
	pthread_t thread2;
	pthread_create(&thread1, NULL, increment, NULL);
	pthread_create(&thread2, NULL, increment, NULL);
	pthread_join(thread1, NULL);
	pthread_join(thread2, NULL);
	printf("Final counter val: %d\n",counter);
}
```

## Notes

The function passed to `pthread_create` (the "start routine") must have the signature `void* (*)(void*)` — it takes a `void*` and returns a `void*`.

- **Argument (`void*`):** lets you pass arbitrary data into the thread (structs, ints via pointer, etc.)
- **Return (`void*`):** lets the thread hand back a result, retrieved via `pthread_join`'s second parameter

### Passing a value in

**Option A: Cast a small value directly to `void*`** (common for a single int)

```c
void* increment(void* arg) {
    int id = (int)(intptr_t)arg;  // cast back to int
    printf("Thread %d running\n", id);
    return NULL;
}

int main() {
    pthread_t t;
    int id = 5;
    pthread_create(&t, NULL, increment, (void*)(intptr_t)id);
    pthread_join(t, NULL);
}
```

This works because a pointer is just a value big enough to hold an integer on most platforms but it's a bit of a hack. Use `intptr_t` for the round-trip cast so it's portable. Don't do this for anything bigger than a pointer-sized int.

**Option B: Pass a pointer to a struct (the "real" way)** — needed when you have multiple values or a value bigger than one pointer:

```c
typedef struct {
    int id;
    int iterations;
} thread_args;

void* increment(void* arg) {
    thread_args* a = (thread_args*)arg;
    for (int i = 0; i < a->iterations; i++) {
        counter++;
    }
    printf("Thread %d done\n", a->id);
    return NULL;
}

int main() {
    pthread_t t;
    thread_args args = {1, 1000000};
    pthread_create(&t, NULL, increment, (void*)&args);
    pthread_join(t, NULL);
}
```

**Watch out:** the struct must stay alive until the thread reads it. Passing `&args` from a local stack variable is fine here because `main` blocks on `pthread_join` before `args` goes out of scope. But if you create the thread and let the _creating_ function return before the thread finishes, you'd be pointing at freed stack memory. In that case, heap-allocate with `malloc` instead and have the thread (or joiner) `free` it.

### Returning a value out

Same idea, in reverse — `pthread_join`'s second parameter is a `void**` that gets filled with whatever the thread returned:

```c
void* increment(void* arg) {
    int* result = malloc(sizeof(int));  // heap, so it survives after thread exits
    *result = 42;
    return (void*)result;
}

int main() {
    pthread_t t;
    pthread_create(&t, NULL, increment, NULL);

    void* ret;
    pthread_join(t, &ret);

    int value = *(int*)ret;
    printf("Thread returned: %d\n", value);
    free(ret);
}
```

 **Same rule as above but flipped:** never `return &local_variable;` from the thread function — that's a stack variable that gets destroyed when the thread exits, so the pointer would be dangling by the time `pthread_join` reads it. Always heap-allocate (`malloc`) anything you return this way, and remember to `free` it in the joining thread.

**Summary:**

- Small values (fit in a pointer) → cast directly with `intptr_t`
- Structs / multiple values → pass a pointer, keep the underlying memory alive until the thread is done with it (stack is OK only if the creator blocks on `join`; otherwise heap it)
- Same logic in reverse for return values — heap-allocate, never return a pointer to a local stack variable
---
# Thursday

## Solution

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t lock_a = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t lock_b = PTHREAD_MUTEX_INITIALIZER;

void *thread1_func(void *arg) {
    printf("Thread 1: locking A\n");
    pthread_mutex_lock(&lock_a);

    sleep(1); // give thread 2 a chance to grab B first

    printf("Thread 1: waiting for B\n");
    pthread_mutex_lock(&lock_b);   // blocks forever — thread 2 holds B

    printf("Thread 1: got both locks\n");

    pthread_mutex_unlock(&lock_b);
    pthread_mutex_unlock(&lock_a);
    return NULL;
}

void *thread2_func(void *arg) {
    printf("Thread 2: locking B\n");
    pthread_mutex_lock(&lock_b);

    sleep(1); // give thread 1 a chance to grab A first

    printf("Thread 2: waiting for A\n");
    pthread_mutex_lock(&lock_a);   // blocks forever — thread 1 holds A

    printf("Thread 2: got both locks\n");

    pthread_mutex_unlock(&lock_a);
    pthread_mutex_unlock(&lock_b);
    return NULL;
}

int main(void) {
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread1_func, NULL);
    pthread_create(&t2, NULL, thread2_func, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Done (you'll never see this)\n");
    return 0;
}
```

- Use the mutex locks to invoke the deadlock 

### How to use GDB

1. `gdb ./main`
2. type `run` (will step through and run program)
3. Ran `thread apply all bt` this shows the backtrace of every thread (Note both threads made stuck in `pthread_mutex_lock`)
