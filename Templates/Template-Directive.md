<%*
let title = await tp.system.prompt("Task name:");
await tp.file.rename(title);

let due = await tp.system.prompt("Due date (YYYY-MM-DD, or blank):");
let priority = await tp.system.suggester(
  ["low", "medium", "high", "critical"],
  ["low", "medium", "high", "critical"]
);
let linked = await tp.system.prompt("Related project/note (e.g. Contracts note name, or blank):");
-%>
---
title: <% title %>
source: "[[Directives]]"
tags: [directive]
created: <% tp.date.now("YYYY-MM-DD") %>
due: <% due %>
priority: <% priority %>
status: open
related: "[[<% linked %>]]"
---

## Task

- [ ] <% title %>

## Notes

