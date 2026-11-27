---
title: Git
source: "[[Ripperdoc]]"
tags: [moc, ripperdoc]
created: 2026-11-20
---

## Overview

Git practice quizzes

## Quizzes

```datacorejsx
// Result notes, newest first.
const COLUMNS = [
  { id: "quiz", title: "Quiz", value: p => p.$link },
  { id: "level", title: "Level", value: p => p.value("level") ?? "" },
  { id: "score", title: "Score", value: p => p.value("score") ?? "" },
];
return function Quizzes() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Git/Results")');
  const rows = [...pages].filter(p => p.$name !== "Git Results").sort((a, b) => b.$name.localeCompare(a.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
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
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Git")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Ripperdoc/Git/")).sort((a, b) => b.$mtime.toMillis() - a.$mtime.toMillis());
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Ripperdoc]]
- ⬇ [[Git Results]]
- ⬇ [[Git Debrief]]
