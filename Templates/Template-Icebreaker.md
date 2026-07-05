<%*
let title = await tp.system.prompt("Company / Role:");
await tp.file.rename(title);

let stage = await tp.system.suggester(
  ["prep", "scheduled", "completed", "offer", "rejected"],
  ["prep", "scheduled", "completed", "offer", "rejected"]
);
let date = await tp.system.prompt("Interview date (YYYY-MM-DD, or blank):");
-%>
---
title: <% title %>
source: "[[Template-Icebreaker]]"
tags: [interview]
created: <% tp.date.now("YYYY-MM-DD") %>
stage: <% stage %>
date: <% date %>
---

## Role / Company Notes


## Questions to Prep

- 

## Questions Asked (post-interview)


## Reflection


## Links

