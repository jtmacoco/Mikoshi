---
title: Directives
source: "[[SYSTEM MANIFEST]]"
tags: [moc, directives]
created: 2026-07-04
---

## Overview

Task hub — active jobs, queued ops, and completed contracts

## Status

- [[On-Contract]]  — Currently running
- [[Backlog]]  — Queued, not yet started
- [[Completed]]  — Flatlined and done
- [[Directive Heatmap]]  — Daily TODO completion heatmap

## Critical & High Priority (auto)

```dataview
TASK
FROM "Mikoshi/Directives"
WHERE !completed AND (contains(tags, "#critical") OR contains(tags, "#high"))
```

## Priority Legend

- `#critical` → do now, no excuses
- `#high` → important, this week
- `#low` → whenever, no rush

## Area Tags

- `#academic` → Academy tasks
- `#contract` → Contracts/projects
- `#netrunner` → Coding tasks
- `#personal` → personal tasks

## Rules

- Tasks live here, projects live in [[Contracts]]
- Every task links back to its source project
- Move to [[Completed]] when done
- Move to [[Flatlined]] when cancelled

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Directives")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Directives/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[SYSTEM MANIFEST]]
