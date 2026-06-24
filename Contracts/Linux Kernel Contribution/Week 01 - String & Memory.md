**Source**: [[Linux Kernel Contribution]]
**Tags**: #linux #on-contract
**Description**: Week one notes

## PHASE 1 — Weeks 1–4: C mastery, kernel-style

### Week 1 — String & memory functions

| Day       | Task (≈30 min)                                                                                                                                                                  |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Write `my_memset` and `my_memcpy` (byte-by-byte versions). Write the week's Makefile from scratch: one target, `CFLAGS`, `clean`.                                               |
| Tue       | Write `my_memmove` — handle overlapping regions (copy backwards when dst > src). Write a test that proves plain memcpy breaks on overlap and memmove doesn't.                   |
| Wed       | Write `my_strlen`, `my_strcpy`, `my_strncpy`, `my_strcmp`. Add pattern rules (`%.o: %.c`) and automatic variables (`$@`, `$<`) to the Makefile.                                 |
| Thu       | Write `my_strtok` (it keeps state between calls — use a `static` pointer, then think about why that's not thread-safe).                                                         |
| Fri       | Optimize `my_memcpy`: copy `size_t`-sized words instead of bytes; handle the unaligned head and tail bytes. Benchmark vs Monday's version with `clock_gettime`.                 |
| Sat (lab) | Read the kernel's real implementations in [`lib/string.c`](https://github.com/torvalds/linux/blob/master/lib/string.c). Compare to yours. Note every trick you didn't think of. |
| Sun       | Rest / catch-up.                                                                                                                                                                |

---
# Monday

## Solution 
```c
#include <stdio.h>
void *my_memset(void * ptr, int value, size_t num){
	unsigned char *p = (unsigned char *)ptr;
	for (size_t i = 0; i < num; ++i){
		p[i] = (unsigned char)value;
	}
	return p;
}
void *my_memcpy(void *dest, const void *src, size_t n){
	unsigned char *d = (unsigned char *) dest;
	const unsigned char *s = (const unsigned char *) src; while (n > 0){
		*d = *s;
		d++;
		s++;
		n--;
	}
	return d;

}
int main(){
	char str[50] = "GeeksForGeeks is for programming geeks.";
	printf("\nBefore memset(): %s\n", str);

	// Fill 8 characters starting from str[13] with '.'
	my_memset(str + 13, '.', 8*sizeof(char));

	printf("After memset():  %s\n", str);

	int src_array[] = {1, 2, 3, 4, 5};
	int dest_array[5];
	int a = 20;
	int b = 10;

	printf("Value of b before calling memcpy: %d\n", b);

	// Use memcpy to copy the value of 'a' into 'b'
	my_memcpy(&b, &a, sizeof(int)); 

	printf("Value of b after calling memcpy: %d\n", b);


}
```

>[!Important] Key Idea
>- Cast as `unsigned char *` so can index memory one byte at a time with values guaranteed to be in 0-255 range and non sign-bit surprises

---
# Tuesday 
```c
#include <stdio.h>
void *my_mmemove(void *dest, const void *src, size_t n){
	unsigned char *d = dest;
	const unsigned char *s = src;
	if (d > s){
		for(size_t i = n; i-- > 0;){
			d[i] = s[i];
		}

	}
	else{
		for(size_t i = 0; i < n; ++i){
			d[i] = s[i];
		}

	}
	return dest;
}
int main(){
	char str[] = "abcdef";
	char str1[] = "Geeks"; 
	char str2[] = "Quiz"; 

	//puts("str1 before memmove ");
	//puts(str1);

	/* Copies contents of str2 to sr1 */
	my_mmemove(str+2, str, 4);
	printf("%s\n",str);

	//puts("\nstr1 after memmove ");
	//puts(str1);
	return 0;
}
```

>[!Important] Key Idea
>Need to have this wrap around idea with the `d>s`

`(src=index 0, dest = index 1, n =4)`
## Visual Example
```
Index:  0   1   2   3   4
Data: [ A | B | C | D | _ ]
        ^src
            ^dest
```

## Left to Right
```
Step 1: d[0]=s[0] → [ A | A | C | D | _ ]  ✓
Step 2: d[1]=s[1] → [ A | A | A | D | _ ]  ✗ corrupted! s[1] was already overwritten
```

## Right to Left

```
Step 1: d[3]=s[3] → [ A | B | C | D | D ]  ✓
Step 2: d[2]=s[2] → [ A | B | C | C | D ]  ✓
Step 3: d[1]=s[1] → [ A | B | B | C | D ]  ✓
Step 4: d[0]=s[0] → [ A | A | B | C | D ]  ✓
```

so if dest > src (dest is ahead) then forward copy overwrites the src data before it's read 
if dest < src then backward copy overwrites src data before it's read

>[!important] Note
>`i-->0` is meant since using size_t which is unsigned so can't be negative so would always be true and infinite loop in normal for loop format

---
# Wednesday 
