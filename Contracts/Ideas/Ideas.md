---
title: Ideas
source: "[[Contracts]]"
tags: [moc, contract]
created: 2026-11-19
---

## Overview

Fleshed-out project ideas, promoted from the Inbox. Once one starts, it becomes its own contract folder.

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Contracts/Ideas")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Contracts/Ideas/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Contracts]]
