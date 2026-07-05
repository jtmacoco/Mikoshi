<%*
let title = await tp.system.prompt("Contract name:");
await tp.file.rename(title);

let client = await tp.system.prompt("Client / employer (leave blank if personal):");
let deadline = await tp.system.prompt("Deadline (YYYY-MM-DD, or blank):");
let status = await tp.system.suggester(
  ["backlog", "active", "on-contract", "completed", "flatlined"],
  ["backlog", "active", "on-contract", "completed", "flatlined"]
);
-%>
---
title: <% title %>
source: "[[Contracts]]"
tags: [contract]
created: <% tp.date.now("YYYY-MM-DD") %>
status: <% status %>
client: <% client %>
deadline: <% deadline %>
stack: 
---

## Objective


## Stack / Tools


## Progress Log

- <% tp.date.now("YYYY-MM-DD") %>: Contract initialized

## Notes


## Links

