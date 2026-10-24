---
title: 253 Meeting Rooms II
source: "[[Leetcode]]"
tags:
  - leetcode
  - intervals
created: 2026-10-24
difficulty: medium
status: solved
---

## Problem

Given an array of meeting time interval objects consisting of start and end times `[[start_1,end_1],[start_2,end_2],...] (start_i < end_i)`, find the minimum number of rooms required to schedule all meetings without any conflicts.

---
# Example 1

**Input:** 
```python
intervals = [(0,40),(5,10),(15,20)]
```

**Output:** 2 

**Explanation:**

```python
room1: `(0,40)`  
room2: `(5,10),(15,20)`
```

---
# Solution

>[!important] Intuition
>- Use a minheap, since the smallest value in the heap frees up the soonest
>- 


```python
"""
Definition of Interval:
class Interval(object):
    def __init__(self, start, end):
        self.start = start
        self.end = end
"""

#[(1, 5), (2, 6), (3, 7), (4, 8), (5, 9)]
class Solution:
    def minMeetingRooms(self, intervals: List[Interval]) -> int:
        intervals.sort(key=lambda x:x.start)
        minheap = []
        heapq.heapify(minheap)
        for i in range(len(intervals)):
            if minheap and minheap[0] <= intervals[i].start:#reuse old room
                heapq.heappop(minheap)
            heapq.heappush(minheap,intervals[i].end)
        return len(minheap)

```

```html-embed
Mikoshi/ICEbreaker/Leetcode/Leetcode_Assets/meeting_rooms_2.html
800
```

---
# Time & Space Complexity

**Time Complexity:** $O(n\log(n))$
**Space Complexity:** $O(n)$
