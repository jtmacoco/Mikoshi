---
title: CUDA Programming
source: "[[Netrunner]]"
tags: [moc, netrunner]
created: 2026-07-06
---

## Overview

Cuda Reference Guide

## What is CUDA

CUDA is a parallel computing platform and programming model to increase computing performance.

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Netrunner/CUDA Programming")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Netrunner/CUDA Programming/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Netrunner]]
