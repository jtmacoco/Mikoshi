---
source: "[[Directives]]"
tags: [directives]
created: 2026-11-19
description: Heatmaps of completed directives from Memory Shards, overall and per directive
---

```dataviewjs
// Scans every daily note in Memory Shards once, then renders:
//   1. an overall heatmap (number of TODOs done per day)
//   2. one color-coded heatmap per TODO
// Encoded notes keep each word's length, so tasks are identified by their
// word-length signature (e.g. "Mental Math" -> "6-4"). Any checkbox that
// isn't "[ ]" counts as done.
//
// To add a new TODO: add a line below with its exact name and a color.
const FOLDER = "Mikoshi/Memory Shards";
const TASKS = [
  // name               color
  { name: "Practice Coding", color: "#00f0ff" },
  { name: "Mental Math",     color: "#ff2a6d" },
  { name: "Leetcode",        color: "#f9f871" },
  { name: "Linux Quiz",      color: "#39ff14" },
  { name: "Git Quiz",        color: "#bd00ff" },
];

const sig = s => s.trim().split(/\s+/).map(w => w.length).join("-");
const bySig = Object.fromEntries(TASKS.map(t => [sig(t.name), t]));
const DATE_RE = /encoded_(\d{4})-?(\d{2})-?(\d{2})_notes$/;
const TASK_RE = /^\s*[-*] \[(.)\] (.*?)(?:\s+✅.*)?$/gm;

const overall = [];
const perTask = Object.fromEntries(TASKS.map(t => [t.name, []]));
let maxDone = 1;

for (const page of dv.pages(`"${FOLDER}"`)) {
  const m = page.file.name.match(DATE_RE);
  if (!m) continue;
  const date = `${m[1]}-${m[2]}-${m[3]}`;
  const filePath = page.file.path;
  const text = await app.vault.cachedRead(app.vault.getAbstractFileByPath(filePath));

  let total = 0, done = 0;
  for (const [, mark, label] of text.matchAll(TASK_RE)) {
    total++;
    if (mark === " ") continue;
    done++;
    const task = bySig[sig(label)];
    if (task) perTask[task.name].push({ date, intensity: 1, content: "✓", filePath });
  }
  if (done > 0) overall.push({ date, intensity: done, content: `${done}/${total}`, filePath });
  maxDone = Math.max(maxDone, done);
}

const year = new Date().getFullYear();
const root = this.container;

const section = title => root.createEl("h2", { text: title });
const tracker = (data) => renderHeatmapTracker(root.createDiv(), { year, showCurrentDayBorder: true, ...data });

section("Overall Uptime");
tracker({
  heatmapTitle: "Directives Completed",
  heatmapSubtitle: "TODOs checked off per day",
  entries: overall,
  intensityScaleStart: 1,
  intensityScaleEnd: maxDone,
});

section("Active Directives");
for (const t of TASKS) {
  const entries = perTask[t.name];
  tracker({
    heatmapTitle: t.name,
    heatmapSubtitle: `${entries.length} days completed`,
    entries,
    colorScheme: { customColors: [t.color] },
  });
}
```
