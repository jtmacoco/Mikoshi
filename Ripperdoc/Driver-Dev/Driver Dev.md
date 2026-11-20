---
title: Driver Dev
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc, ripper]
created: 2026-10-25
---

## Overview

Learning to write Linux device drivers by building them. Claude assigns gigs and reviews my code; progress is tracked in [[Mikoshi/Ripperdoc/Driver-Dev/progress]].

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Driver-Dev")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Driver-Dev/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Driver Dev Quizzes]] · [[Driver Dev Notes]]
