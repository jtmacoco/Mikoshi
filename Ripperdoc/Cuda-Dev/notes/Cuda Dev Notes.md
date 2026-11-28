---
title: Cuda Dev Notes
source: "[[Cuda Dev]]"
tags: [moc, ripperdoc]
created: 2026-11-27
---

## Overview

Concept notes from Cuda Dev explain sessions

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Cuda-Dev/notes")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Cuda-Dev/notes/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Cuda Dev]]
