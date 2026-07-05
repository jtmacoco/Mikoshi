---
title: ICEbreaker
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview
## Solved

```dataview
LIST
FROM "Mikoshi/ICEbreaker"
WHERE status = "unsolved" 
SORT file.mtime DESC
```


## Solved

```dataview
LIST
FROM "Mikoshi/ICEbreaker"
WHERE status = "completed" OR status = "solved"
SORT file.mtime DESC
```

## All Notes

```dataview
LIST
FROM "Mikoshi/ICEbreaker"
SORT file.name ASC
```