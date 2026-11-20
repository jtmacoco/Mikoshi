---
title: Templates
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-06-14
description: "Template Tracker"
---

## Overview

Every note template in the vault

## Template Index

| Area | Templates |
|---|---|
| MOCs | [[Template-MOC]] · [[Template-Sub-MOC]] |
| General | [[Template-General]] · [[Template-Notes]] · [[Template-Kanban]] |
| Daily | [[DailySetup]] · [[Daily-Notes]] · [[Template-Daily-Math]] |
| Directives & Contracts | [[Template-Directive]] · [[Template-Contract]] |
| Netrunner | [[Template-Netrunner]] · [[Template-Netrunner-Reference]] |
| Data Shards | [[Template-Data-shard]] · [[Template-Data-shard-reference]] · [[Template-Data-shard-technical]] |
| ICEbreaker | [[Template-Icebreaker]] · [[Template-Leetcode]] · [[Template-System-Design]] |
| Academy | [[Template-Academy]] |

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Templates")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Templates/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[SYSTEM MANIFEST]]
