<%*
let title = await tp.system.prompt("Note title:");
await tp.file.rename(title);

let moc = await tp.system.prompt("Parent MOC (e.g. Netrunner, Contracts):");
let status = await tp.system.suggester(
  ["active", "backlog", "on-contract", "completed", "personal"],
  ["active", "backlog", "on-contract", "completed", "personal"]
);
-%>
---
title: <% title %>
source: "[[<% moc %>]]"
tags: 
created: <% tp.date.now("YYYY-MM-DD") %>
status: <% status %>
---

## Description


## Notes


## Links

