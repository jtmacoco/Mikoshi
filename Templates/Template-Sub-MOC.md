<%*
let path = await tp.system.prompt("Full vault path to folder (e.g. Mikoshi/Netrunner/Kernel):");
let parts = path.replace(/\/+$/, "").split("/");
let title = parts.pop();
// Parent MOC = the parent folder's name (folder MOCs share their folder's name).
// A folder directly under the vault root falls back to SYSTEM MANIFEST.
let parentFolder = parts.pop();
let parent = (!parentFolder || parentFolder === "Mikoshi") ? "SYSTEM MANIFEST" : parentFolder;
await tp.file.rename(title);

let overview = await tp.system.prompt("One-line overview:");
-%>
---
title: <% title %>
source: "[[<% parent %>]]"
tags: [moc]
created: <% tp.date.now("YYYY-MM-DD") %>
---

## Overview

<% overview %>

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("<% path %>")');
  const rows = [...pages].sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```


