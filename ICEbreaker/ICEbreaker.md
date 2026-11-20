---
title: ICEbreaker
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview

Practice for interview questions

# MOC

```datacorejsx
return function IcebreakerMocs() {
  const mocs = [...dc.useQuery('@page and path("Mikoshi/ICEbreaker") and #moc')]
    .filter(p => p.$name !== "ICEbreaker").sort((a, b) => a.$name.localeCompare(b.$name));
  return <p>{mocs.map((p, i) => <span>{i > 0 && " · "}<dc.Literal value={p.$link} /></span>)}</p>;
};
```

## Unsolved

```datacorejsx
const ROOT = "Mikoshi/ICEbreaker";
const sectionOf = p => {
  const folder = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return folder === ROOT ? "ICEbreaker" : folder.slice(ROOT.length + 1).split("/")[0];
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "section", title: "Section", value: p => sectionOf(p) },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].filter(p => ["unsolved"].includes(p.value("status"))).sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```


## Solved

```datacorejsx
const ROOT = "Mikoshi/ICEbreaker";
const sectionOf = p => {
  const folder = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return folder === ROOT ? "ICEbreaker" : folder.slice(ROOT.length + 1).split("/")[0];
};
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "section", title: "Section", value: p => sectionOf(p) },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];

return function View() {
  const pages = dc.useQuery(`@page and path("${ROOT}")`);
  const rows = [...pages].filter(p => ["completed", "solved"].includes(p.value("status"))).sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```

## All Notes

```datacorejsx
// Datacore: live filter that keeps its state, with paging.
const ROOT = "Mikoshi/ICEbreaker";
const sectionOf = p => {
  const folder = p.$path.slice(0, p.$path.lastIndexOf("/"));
  return folder === ROOT ? "ICEbreaker" : folder.slice(ROOT.length + 1).split("/")[0];
};

const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "section", title: "Section", value: p => sectionOf(p) },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
];

return function IcebreakerNotes() {
  const all = dc.useQuery(`@page and path("${ROOT}")`);
  const pages = dc.useMemo(() => [...all].sort((a, b) => a.$name.localeCompare(b.$name)), [all]);
  const sections = dc.useMemo(() => [...new Set(pages.map(sectionOf))].sort(), [pages]);
  const statuses = dc.useMemo(() => [...new Set(pages.map(p => p.value("status")).filter(Boolean))].sort(), [pages]);

  const [search, setSearch] = dc.useState("");
  const [section, setSection] = dc.useState("");
  const [status, setStatus] = dc.useState("");

  const rows = dc.useMemo(() => {
    const q = search.trim().toLowerCase();
    return pages.filter(p =>
      (!q || p.$name.toLowerCase().includes(q)) &&
      (!section || sectionOf(p) === section) &&
      (!status || p.value("status") === status));
  }, [pages, search, section, status]);

  return (
    <div>
      <div style={{ display: "flex", gap: "0.5em", flexWrap: "wrap", marginBottom: "0.5em" }}>
        <dc.Textbox placeholder="Search notes..." value={search} onInput={e => setSearch(e.currentTarget.value)} style={{ flex: 1, minWidth: "12em" }} />
        <dc.VanillaSelect value={section} onValueChange={setSection}
          options={[{ value: "", label: "All sections" }, ...sections.map(s => ({ value: s, label: s }))]} />
        <dc.VanillaSelect value={status} onValueChange={setStatus}
          options={[{ value: "", label: "Any status" }, ...statuses.map(s => ({ value: s, label: s }))]} />
      </div>
      <p style={{ opacity: 0.7, margin: 0 }}>{rows.length} of {pages.length} notes</p>
      <dc.Table columns={COLUMNS} rows={rows} paging={25} />
    </div>
  );
};
```
