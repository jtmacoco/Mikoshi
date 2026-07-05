<%*
let title = await tp.system.prompt("Note title:");
await tp.file.rename(title);

let lang = await tp.system.prompt("Language/stack (e.g. Python, React, blank if N/A):");
let status = await tp.system.suggester(
  ["active", "backlog", "completed", "reference"],
  ["active", "backlog", "completed", "reference"]
);
-%>
---
title: <% title %>
source: "[[Netrunner]]"
tags: [netrunner]
created: <% tp.date.now("YYYY-MM-DD") %>
stack: <% lang %>
status: <% status %>
---

## Problem / Goal


## Approach


## Code / Snippets

```

```

## Notes


## Links

