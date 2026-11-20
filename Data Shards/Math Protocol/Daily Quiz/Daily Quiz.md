---
title: Daily Quiz
source: "[[Math Protocol]]"
tags: [moc, book]
created: 2026-11-19
---

## Overview

One mental math quiz per day, created from the HUD

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Math Protocol/Daily Quiz")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Math Protocol/Daily Quiz/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Math Protocol]]
