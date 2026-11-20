---
title: Templates
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-06-14
description: "Template Tracker"
---

## Overview

Every note template in the vault

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Templates")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Templates/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[SYSTEM MANIFEST]]
