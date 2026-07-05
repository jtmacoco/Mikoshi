---
title: Data Shards
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview



## Active

```dataview
LIST
FROM "Mikoshi/Data Shards"
WHERE status = "active" OR status = "on-contract" OR status = "reading"
SORT file.mtime DESC
```

## Backlog

```dataview
LIST
FROM "Mikoshi/Data Shards"
WHERE status = "backlog"
SORT file.mtime DESC
```

## Completed

```dataview
LIST
FROM "Mikoshi/Data Shards"
WHERE status = "completed"
SORT file.mtime DESC
```

## All Notes

```dataview
LIST
FROM "Mikoshi/Data Shards"
SORT file.name ASC
```

## Links

