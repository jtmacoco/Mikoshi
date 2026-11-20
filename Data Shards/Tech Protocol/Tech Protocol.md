---
title: Tech Protocol
source: "[[Data Shards]]"
tags: [moc, book]
created: 2026-11-19
---

## Overview

Dense technical books, split by chapter

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Tech Protocol")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Tech Protocol/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Data Shards]]
- ⬇ [[Linux Kernel Programming Part 1]] · [[Linux Kernel Programming Part 2]]
