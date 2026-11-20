---
title: Leetcode
source: "[[ICEbreaker]]"
tags:
  - moc
  - leetcode
created: 2026-07-04
---
## Overview

Leetcode problems solutions

# Problems Solved
```datacorejsx
return function LeetcodeStats() {
  const pages = dc.useQuery('@page and path("Mikoshi/ICEbreaker/Leetcode")').filter(p => p.value("status"));
  const count = (key, val) => pages.filter(p => p.value(key) === val).length;
  return (
    <p>
      <b>{count("status", "solved")}</b> solved · <b>{count("status", "unsolved")}</b> unsolved
      {"  —  "}{count("difficulty", "easy")} easy · {count("difficulty", "medium")} medium · {count("difficulty", "hard")} hard
    </p>
  );
};
```

# Last Solved

```datacorejsx
return function LastSolved() {
  const pages = dc.useQuery('@page and path("Mikoshi/ICEbreaker/Leetcode")');
  const last = [...pages].filter(p => p.value("status") === "solved").sort((a, b) => b.$ctime - a.$ctime)[0];
  return last ? <p><dc.Literal value={last.$link} /> · {last.$ctime.toFormat("MMM dd")}</p> : <p>None yet</p>;
};
```

## LeetCode Index

```datacorejsx
// One row per topic; problems hidden behind a click.
const COLUMNS = [
  { id: "topic", title: "Topic", value: r => r.topic },
  { id: "count", title: "Count", value: r => r.links.length },
  { id: "problems", title: "Problems", value: r => r.links,
    render: (links) => <details><summary>Show</summary><dc.Literal value={links} /></details> },
];

return function LeetcodeIndex() {
  const pages = dc.useQuery('@page and #leetcode');
  const rows = dc.useMemo(() => {
    const byTopic = {};
    for (const p of pages) for (const t of p.$tags ?? []) {
      const topic = t.replace(/^#/, "");
      if (["leetcode", "moc"].includes(topic)) continue;
      (byTopic[topic] ??= []).push(p.$link);
    }
    return Object.keys(byTopic).sort().map(topic => ({ topic, links: byTopic[topic] }));
  }, [pages]);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```
## Incomplete 

```datacorejsx
const COLUMNS = [
  { id: "problem", title: "Problem", value: p => p.$link },
  { id: "difficulty", title: "Difficulty", value: p => p.value("difficulty") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];

return function LeetcodeIncomplete() {
  const pages = dc.useQuery('@page and path("Mikoshi/ICEbreaker/Leetcode")');
  const rows = [...pages].filter(p => p.value("status") === "unsolved").sort((a, b) => b.$mtime - a.$mtime);
  return <dc.Table columns={COLUMNS} rows={rows} paging={10} />;
};
```


## Completed

```datacorejsx
// Datacore: live filter that keeps its state, with paging.
const FOLDER = "Mikoshi/ICEbreaker/Leetcode";
const topicsOf = p => [...(p.$tags ?? [])].map(t => t.replace(/^#/, "")).filter(t => !["leetcode", "moc"].includes(t));
const num = p => parseInt(p.$name) || 0;

const COLUMNS = [
  { id: "problem", title: "Problem", value: p => p.$link },
  { id: "difficulty", title: "Difficulty", value: p => p.value("difficulty") ?? "" },
  { id: "topics", title: "Topics", value: p => topicsOf(p).join(", ") },
];

return function LeetcodeSolved() {
  const all = dc.useQuery(`@page and path("${FOLDER}")`);
  const solved = dc.useMemo(() => all.filter(p => p.value("status") === "solved").sort((a, b) => num(a) - num(b)), [all]);
  const topics = dc.useMemo(() => [...new Set(solved.flatMap(topicsOf))].sort(), [solved]);

  const [search, setSearch] = dc.useState("");
  const [diff, setDiff] = dc.useState("");
  const [topic, setTopic] = dc.useState("");

  const rows = dc.useMemo(() => {
    const q = search.trim().toLowerCase();
    return solved.filter(p =>
      (!q || p.$name.toLowerCase().includes(q)) &&
      (!diff || p.value("difficulty") === diff) &&
      (!topic || topicsOf(p).includes(topic)));
  }, [solved, search, diff, topic]);

  return (
    <div>
      <div style={{ display: "flex", gap: "0.5em", flexWrap: "wrap", marginBottom: "0.5em" }}>
        <dc.Textbox placeholder="Search problems..." value={search} onInput={e => setSearch(e.currentTarget.value)} style={{ flex: 1, minWidth: "12em" }} />
        <dc.VanillaSelect value={diff} onValueChange={setDiff}
          options={[{ value: "", label: "All difficulties" }, ...["easy", "medium", "hard"].map(d => ({ value: d, label: d }))]} />
        <dc.VanillaSelect value={topic} onValueChange={setTopic}
          options={[{ value: "", label: "All topics" }, ...topics.map(t => ({ value: t, label: t }))]} />
      </div>
      <p style={{ opacity: 0.7, margin: 0 }}>{rows.length} of {solved.length} solved</p>
      <dc.Table columns={COLUMNS} rows={rows} paging={25} />
    </div>
  );
};
```
