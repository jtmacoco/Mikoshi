---
title: Results
source: "[[Linux]]"
aliases: [Results MOC]
tags:
  - moc
created: 2026-11-17
---

## Overview

Results from quizzes

## All Notes

```datacorejsx
// Reads each result note's frontmatter. Newest first.
const COLUMNS = [
  { id: "date", title: "Date", value: p => p.$link,
    render: (link, p) => <dc.Literal value={link.withDisplay(String(p.value("date") ?? p.$name).slice(0, 10))} /> },
  { id: "track", title: "Track", value: p => p.value("track") ?? "" },
  { id: "level", title: "Level", value: p => p.value("level") ?? "" },
  { id: "score", title: "Score", value: p => p.value("score") ?? "" },
];

return function QuizResults() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Linux/Results")');
  const rows = [...pages].filter(p => p.$name !== "Results").sort((a, b) => b.$name.localeCompare(a.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## Sessions
- [[2026-11-17 Linux Quiz]]
- [[2026-11-18 Linux Quiz]]
- [[2026-11-18 Linux Quiz 2]]
- [[2026-11-18 Linux Quiz 3]]
- [[2026-11-19 Linux Quiz]]
