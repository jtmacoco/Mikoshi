---
title: Game Hacking
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc]
created: 2026-11-27
---

## Overview

Learning the RE side of game modding: memory scanning, pointer chains, C++ object reversing, patching, function hooking, and building a mod loader. Single-player / offline, games I own, plus toy targets. Builds on [[Malware RE]] and shares technique with [[Exploit Dev]]. Claude assigns gigs and reviews my work; progress is tracked in [[Mikoshi/Ripperdoc/Game-Hacking/progress|progress]]. Concepts that stick graduate to [[Netrunner]].

## Gigs

```datacorejsx
// One row per gig: links to the README. Named by frontmatter title, else folder name.
const gigName = p => p.value("title") ?? p.$path.split("/").slice(-2, -1)[0];
const COLUMNS = [
  { id: "gig", title: "Gig", value: p => gigName(p),
    render: (name, p) => <dc.Literal value={p.$link.withDisplay(name)} /> },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function Gigs() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Game-Hacking/Gigs")');
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
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Game-Hacking")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Game-Hacking/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Game Hacking Quizzes]] · [[Game Hacking Notes]]
