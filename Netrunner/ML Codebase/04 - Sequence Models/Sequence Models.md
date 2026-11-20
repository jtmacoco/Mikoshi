---
title: Sequence Models
source: "[[ML Codebase]]"
tags: [moc, netrunner]
created: 2026-09-02
---

## Overview

Sequence models (RNN, LSTM, etc..) reference guid

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Netrunner/ML Codebase/04 - Sequence Models")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Netrunner/ML Codebase/04 - Sequence Models/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[ML Codebase]]
