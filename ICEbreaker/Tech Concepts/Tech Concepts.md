---
title: Tech Concepts
source: "[[ICEbreaker]]"
tags: [moc, icebreaker]
created: 2026-11-19
---

## Overview

Answers to tech concept questions. The concepts underneath live in Netrunner

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/ICEbreaker/Tech Concepts")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/ICEbreaker/Tech Concepts/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[ICEbreaker]]
