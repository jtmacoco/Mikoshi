<%*
let folder = await tp.system.prompt("Folder this MOC covers (just the folder name, e.g. Contracts, Data Shards):");
let path = "Mikoshi/" + folder;
await tp.file.rename(folder);
-%>
---
title: <% folder %>
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: <% tp.date.now("YYYY-MM-DD") %>
---

## Overview



## Active

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("<% path %>")');
  const rows = [...pages].filter(p => ["active", "on-contract", "reading"].includes(p.value("status"))).sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## Backlog

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("<% path %>")');
  const rows = [...pages].filter(p => ["backlog"].includes(p.value("status"))).sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## Completed

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("<% path %>")');
  const rows = [...pages].filter(p => ["completed"].includes(p.value("status"))).sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

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


