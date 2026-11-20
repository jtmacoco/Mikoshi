---
title: Linux Kernel Programming Part 2
source: "[[Tech Protocol]]"
tags: [moc, book]
created: 2026-09-14
---

## Overview

Main index linking related notes to this book

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Tech Protocol/Linux Kernel Programming Part 2")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Tech Protocol/Linux Kernel Programming Part 2/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Data Shards]]
