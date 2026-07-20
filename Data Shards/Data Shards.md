---
title: Data Shards
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview
- Stores notes on various topics


## Active

```dataview
LIST
FROM "Mikoshi/Data Shards"
WHERE status = "active" OR status = "on-contract" OR status = "reading"
SORT file.mtime DESC
```


## All Notes

```dataview
LIST
FROM "Mikoshi/Data Shards"
SORT file.name ASC
```