<%*
let title = await tp.system.prompt("Problem name:");
await tp.file.rename(title);

let difficulty = await tp.system.suggester(
  ["easy", "medium", "hard"],
  ["easy", "medium", "hard"]
);
let pattern = await tp.system.prompt("Pattern/topic (e.g. hashtable, two-pointer, dp):");
-%>
---
title: <% title %>
source: "[[Template-Leetcode]]"
tags: [leetcode, "<% pattern %>"]
created: <% tp.date.now("YYYY-MM-DD") %>
difficulty: <% difficulty %>
status: unsolved
---

## Problem


---
# Example 1

**Input:** 

**Output:** 

**Explanation:**


---
# Solution

>[!important] Intuition
>

```python

```

---
# Time & Space Complexity

**Time Complexity:** 
**Space Complexity:** 
