<%*
let folder = await tp.system.prompt("Folder this MOC covers (just the folder name, e.g. Contracts, Data Shards):");
let path = "Mikoshi/" + folder;
await tp.file.rename(folder);
-%>
---
title: <% folder %>
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: <% tp.date.now("YYYY-MM-DD") %>
---

## Overview



## Active

```dataview
LIST
FROM "<% path %>"
WHERE status = "active" OR status = "on-contract" OR status = "reading"
SORT file.mtime DESC
```

## Backlog

```dataview
LIST
FROM "<% path %>"
WHERE status = "backlog"
SORT file.mtime DESC
```

## Completed

```dataview
LIST
FROM "<% path %>"
WHERE status = "completed"
SORT file.mtime DESC
```

## All Notes

```dataview
LIST
FROM "<% path %>"
SORT file.name ASC
```


