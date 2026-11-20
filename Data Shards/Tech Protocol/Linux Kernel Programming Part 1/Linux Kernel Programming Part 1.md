---
title: Linux Kernel Programming Part 1
source: "[[Tech Protocol]]"
tags: [moc, book]
created: 2026-11-19
---

## Overview

Linux Kernel Programming, Part 1: kernel internals, modules and synchronization

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Tech Protocol/Linux Kernel Programming Part 1")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Tech Protocol/Linux Kernel Programming Part 1/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Tech Protocol]]
