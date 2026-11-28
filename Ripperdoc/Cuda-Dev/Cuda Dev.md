---
title: Cuda Dev
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc]
created: 2026-10-25
---

## Overview

Learning GPU programming by writing, profiling, and optimizing CUDA kernels.

## Gigs

```datacorejsx
// One row per gig: links to the gig's README. Named by frontmatter title, else folder name.
const gigName = p => p.value("title") ?? p.$path.split("/").slice(-2, -1)[0];
const COLUMNS = [
  { id: "gig", title: "Gig", value: p => gigName(p),
    render: (name, p) => <dc.Literal value={p.$link.withDisplay(name)} /> },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function Gigs() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Cuda-Dev/Gigs")');
  const rows = [...pages].sort((a, b) => a.$path.localeCompare(b.$path));
  return <dc.Table columns={COLUMNS} rows={rows} />;
};
```

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Cuda-Dev")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Cuda-Dev/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Cuda Dev Quizzes]] · [[Cuda Dev Notes]]
