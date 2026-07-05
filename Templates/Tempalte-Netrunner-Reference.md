<%*
let title = await tp.system.prompt("Concept/topic name:");
await tp.file.rename(title);

let topicFolder = await tp.system.prompt("Language/tool folder (e.g. C, Kernel, Vim):");
-%>
---
title: <% title %>
source: "[[<% topicFolder %>]]"
tags: 
created: <% tp.date.now("YYYY-MM-DD") %>
---

## What is <% title %>


---

## Example / Usage

```

```

---

## When to Use


---

## Watch Out For


---

## Links

