---
title: System Design
source: "[[ICEbreaker]]"
tags: [moc, icebreaker]
created: 2026-07-04
---

## Overview

Solutions & notes to System Design problems

## Completed

```dataview
LIST
FROM "Mikoshi/ICEbreaker/System Design"
WHERE status = "solved"
SORT file.mtime DESC
```

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/ICEbreaker/System Design")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/ICEbreaker/System Design/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[ICEbreaker]]
