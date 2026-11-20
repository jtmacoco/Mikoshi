---
title: ML Codebase
source: "[[Netrunner]]"
tags: [moc, netrunner]
created: 2026-08-31
---

## Overview

Machine learning reference guide

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Netrunner/ML Codebase")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Netrunner/ML Codebase/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Netrunner]]
- ⬇ [[Foundations]] · [[Evaluation & Practice]] · [[MLP Core]] · [[CNN]] · [[Sequence Models]] · [[Mikoshi/Netrunner/ML Codebase/05 - Generative Models/Generative Models|Generative Models]] · [[Mikoshi/Netrunner/ML Codebase/06 - NLP/NLP|NLP]]
