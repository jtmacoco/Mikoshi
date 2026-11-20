---
title: Flatlined
source: "[[SYSTEM MANIFEST]]"
tags: [moc, flatlined, archived]
created: 2026-06-14
description: "Archived/Dead Projects"
---

## Overview

Archived and dead projects

## Archived

- [[CUDA Refresher]]
- [[Linux Kernel Contribution]]

## Dead

- [-] Organize Academy Section #academic ⏬ ❌ 2026-11-19

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Flatlined")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Flatlined/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[SYSTEM MANIFEST]]
- ⬇ [[CUDA Refresher]]
