<%*
let title = await tp.system.prompt("Note title (e.g. lecture/topic name):");
await tp.file.rename(title);

let course = await tp.system.prompt("Course name:");
let status = await tp.system.suggester(
  ["active", "completed"],
  ["active", "completed"]
);
-%>
---
title: <% title %>
source: "[[Template-Academy]]"
tags: [academic]
created: <% tp.date.now("YYYY-MM-DD") %>
course: <% course %>
status: <% status %>
---

## Key Concepts


## Notes


## Questions / Follow-up


## Links

