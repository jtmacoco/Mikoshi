---
title: Checkmate Protocol
source: "[[Data Shards]]"
tags: [moc, book]
created: 2026-11-19
---

## Overview

Chess books

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Checkmate Protocol")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Checkmate Protocol/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Data Shards]]
