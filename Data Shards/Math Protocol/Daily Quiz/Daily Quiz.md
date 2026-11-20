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
// Newest quiz first, by the note's created date (falls back to the YYYY-MM-DD file name).
const createdOf = p => String(p.value("created") ?? p.$name).slice(0, 10);
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "created", title: "Created", value: createdOf },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Data Shards/Math Protocol/Daily Quiz")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Data Shards/Math Protocol/Daily Quiz/") && p.$name !== "Daily Quiz")
    .sort((a, b) => createdOf(b).localeCompare(createdOf(a)));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Math Protocol]]
