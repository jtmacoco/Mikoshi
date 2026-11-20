---
title: Linux
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc, ripper]
created: 2026-11-17
---

## Overview

Linux practice quizzes

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Linux")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Linux/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Results]]
