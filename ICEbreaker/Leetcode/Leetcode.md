---
title: Leetcode
source: "[[ICEbreaker]]"
tags:
  - moc
  - leetcode
created: 2026-07-04
---
## Overview

Leetcode problems solutions

# Problems Solved
```dataview
TABLE length(rows) AS "Count"
FROM "Mikoshi/ICEbreaker/Leetcode"
WHERE status != null AND status != ""
GROUP BY status
```


## LeetCode Index

```dataview
TABLE rows.file.link AS "Problems"
FROM #leetcode
FLATTEN file.tags AS tag
WHERE tag != "#leetcode"
GROUP BY tag
SORT tag ASC
```
## Incomplete 

```dataview
LIST
FROM "Mikoshi/ICEbreaker/Leetcode"
WHERE status = "unsolved"
SORT file.mtime DESC
```


## Completed

```dataview
LIST
FROM "Mikoshi/ICEbreaker/Leetcode"
WHERE status = "solved"
SORT file.mtime DESC
```


