---
title: Game Hacking Notes
source: "[[Game Hacking]]"
tags: [moc, ripperdoc]
created: 2026-11-27
---

## Overview

Concept notes from Game Hacking explain sessions

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Game-Hacking/notes")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Game-Hacking/notes/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Game Hacking]]
