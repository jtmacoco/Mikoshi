---
title: Git Results
source: "[[Mikoshi/Ripperdoc/Git/Git|Git]]"
tags: [moc, ripperdoc]
created: 2026-11-20
---

## Overview

Results from git quizzes

## All Notes

```datacorejsx
// Reads each result note's frontmatter. Newest first.
const COLUMNS = [
  { id: "date", title: "Date", value: p => p.$link,
    render: (link, p) => <dc.Literal value={link.withDisplay(String(p.value("created") ?? p.$name).slice(0, 10))} /> },
  { id: "level", title: "Level", value: p => p.value("level") ?? "" },
  { id: "score", title: "Score", value: p => p.value("score") ?? "" },
];

return function QuizResults() {
  const pages = dc.useQuery('@page and path("Mikoshi/Ripperdoc/Git/Results")');
  const rows = [...pages].filter(p => p.$name !== "Git Results").sort((a, b) => b.$name.localeCompare(a.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## Links

- ⬆ [[Mikoshi/Ripperdoc/Git/Git|Git]]
