<%*
let title = await tp.system.prompt("Book title:");
await tp.file.rename(title);

let author = await tp.system.prompt("Author:");
let subject = await tp.system.prompt("Subject/skill (e.g. chess, mental math, kernel programming):");
let status = await tp.system.suggester(
  ["backlog", "reading", "completed"],
  ["backlog", "reading", "completed"]
);
-%>
---
title: <% title %>
source: "[[Data Shards a]]"
tags: [book, reference]
created: <% tp.date.now("YYYY-MM-DD") %>
author: <% author %>
subject: <% subject %>
status: <% status %>
rating: 
---

## Why I'm Reading This


## Notes

