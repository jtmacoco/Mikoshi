<%*
let path = await tp.system.prompt("Full vault path to folder (e.g. Mikoshi/Netrunner/Kernel):");
let title = path.split("/").pop();
await tp.file.rename(title);

let overview = await tp.system.prompt("One-line overview:");
-%>
---
title: <% title %>
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: <% tp.date.now("YYYY-MM-DD") %>
---

## Overview

<% overview %>

## All Notes

```dataview
LIST
FROM "<% path %>"
SORT file.name ASC
```

## Links

