<%*
let title = await tp.system.prompt("Concept/topic name:");
await tp.file.rename(title);

let topicFolder = await tp.system.prompt("Language/tool folder (e.g. C, Kernel, Vim):");
let noteType = await tp.system.prompt("Type (reference/snippet/cheatsheet/concept):");
-%>
---
title: <% title %>
source: "[[<% topicFolder %>]]"
tags: 
type: <% noteType %>
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





