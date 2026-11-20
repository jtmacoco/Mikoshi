---
title: Ripperdoc
source: "[[SYSTEM MANIFEST]]"
tags:
  - moc
  - ripperdoc
  - ripper
created: 2026-10-25
---

## Overview

Structured skill upgrades: Claude-guided curricula with lessons, quizzes, and hands-on gigs. Concepts I've mastered graduate to [[Netrunner]]; real builds graduate to [[Contracts]].

---

## All Notes

```datacorejsx
// Grouped by curriculum. Gig READMEs show under their gig folder name.
const ROOT = "Mikoshi/Ripperdoc";
const parts = p => p.$path.slice(ROOT.length + 1).split("/");
const kindOf = p => {
  const sub = parts(p)[1] ?? "";
  if (/^gigs$/i.test(sub)) return "gig";
  if (/^(quizzes|results)$/i.test(sub)) return "result";
  if (/quiz/i.test(p.$name)) return "quiz";
  return "core";
};
const labelOf = p => p.$name === "README" ? parts(p).at(-2) : null;
const ORDER = { core: 0, quiz: 1, gig: 2, result: 3 };

const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link,
    render: (link, p) => labelOf(p) ? <dc.Literal value={link.withDisplay(labelOf(p))} /> : <dc.Literal value={link} /> },
  { id: "kind", title: "Kind", value: kindOf },
];

return function RipperdocNotes() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const groups = dc.useMemo(() => {
    const by = {};
    for (const p of pages) {
      if (p.$name === "CLAUDE" || parts(p).length < 2) continue;
      (by[parts(p)[0]] ??= []).push(p);
    }
    return Object.keys(by).sort().map(key => ({
      key,
      rows: by[key].sort((a, b) => ORDER[kindOf(a)] - ORDER[kindOf(b)] || a.$name.localeCompare(b.$name)),
    }));
  }, [pages]);
  return <dc.Table columns={COLUMNS} rows={groups} groupings={{ render: key => <h4 style={{ margin: "0.4em 0" }}>{key}</h4> }} />;
};
```


