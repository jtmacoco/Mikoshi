---
title: Git
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc]
created: 2026-11-20
---

## Overview

Git practice quizzes

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Git")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Git/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Git Results]]
