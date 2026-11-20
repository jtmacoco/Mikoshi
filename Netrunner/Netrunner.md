---
title: Netrunner
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview

Knowledge arsenal — references, snippets, and tech notes to pull from on any job

## MOC Files

```datacorejsx
return function NetrunnerMocs() {
  const mocs = [...dc.useQuery('@page and path("Mikoshi/Netrunner") and #moc')]
    .filter(p => p.$name !== "Netrunner").sort((a, b) => a.$name.localeCompare(b.$name));
  return <p>{mocs.map((p, i) => <span>{i > 0 && " · "}<dc.Literal value={p.$link} /></span>)}</p>;
};
```

## Concept
```datacorejsx
const ROOT = "Mikoshi/Netrunner";
const folderOf = p => {
  const f = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return f === ROOT ? "—" : f.slice(ROOT.length + 1);
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "folder", title: "Folder", value: folderOf },
  { id: "created", title: "Created", value: p => String(p.value("created") ?? "").slice(0, 10) },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].filter(p => [p.value("type"), p.value("notetype")].includes("concept"))
    .sort((a, b) => String(b.value("created") ?? "").localeCompare(String(a.value("created") ?? "")));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## References
```datacorejsx
const ROOT = "Mikoshi/Netrunner";
const folderOf = p => {
  const f = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return f === ROOT ? "—" : f.slice(ROOT.length + 1);
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "folder", title: "Folder", value: folderOf },
  { id: "created", title: "Created", value: p => String(p.value("created") ?? "").slice(0, 10) },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].filter(p => [p.value("type"), p.value("notetype")].includes("reference"))
    .sort((a, b) => String(b.value("created") ?? "").localeCompare(String(a.value("created") ?? "")));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## Cheat Sheets
```datacorejsx
const ROOT = "Mikoshi/Netrunner";
const folderOf = p => {
  const f = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return f === ROOT ? "—" : f.slice(ROOT.length + 1);
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "folder", title: "Folder", value: folderOf },
  { id: "created", title: "Created", value: p => String(p.value("created") ?? "").slice(0, 10) },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].filter(p => [p.value("type"), p.value("notetype")].includes("cheatsheet"))
    .sort((a, b) => String(b.value("created") ?? "").localeCompare(String(a.value("created") ?? "")));
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## All Notes

```datacorejsx
const ROOT = "Mikoshi/Netrunner";
const folderOf = p => {
  const f = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return f === ROOT ? "—" : f.slice(ROOT.length + 1);
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "folder", title: "Folder", value: folderOf },
  { id: "type", title: "Type", value: p => p.value("type") ?? p.value("notetype") ?? "" },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```
