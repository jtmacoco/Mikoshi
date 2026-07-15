<%*
let title = await tp.system.prompt("Book title:");
await tp.file.rename(title);

let author = await tp.system.prompt("Author:");
let genre = await tp.system.suggester(
  ["fiction", "non-fiction"],
  ["fiction", "non-fiction"]
);
let status = await tp.system.suggester(
  ["backlog", "reading", "completed"],
  ["backlog", "reading", "completed"]
);
-%>
---
title: <% title %>
source: "[[Data Shards]]"
tags: [book, "<% genre %>"]
created: <% tp.date.now("YYYY-MM-DD") %>
author: <% author %>
status: <% status %>
rating: 
---

## Summary


## Key Takeaways

- 

## Quotes


## Notes


## Links

