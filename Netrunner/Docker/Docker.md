---
title: Docker
source: "[[Netrunner]]"
tags: [moc, netrunner, docker]
created: 2026-10-01
---

## Overview

Docker concepts

## What Is Docker

Docker builds and runs containers on a single machine

Docker is like a shipping container, a standard box that holds your app and works the same everywhere. Kubernetes is like the port's management system that decides which ship each container goes on, tracks them all, and reroutes them if a ship has a problem.

## All Notes

```datacorejsx
const COLUMNS = [
  { id: "note", title: "Note", value: p => p.$link },
  { id: "status", title: "Status", value: p => p.value("status") ?? "" },
  { id: "modified", title: "Last Touched", value: p => p.$mtime.toFormat("MMM dd") },
];
return function View() {
  const pages = dc.useQuery('@page and path("Mikoshi/Netrunner/Docker")');
  const rows = [...pages].filter(p => p.$path.startsWith("Mikoshi/Netrunner/Docker/")).sort((a, b) => a.$name.localeCompare(b.$name));
  return <dc.Table columns={COLUMNS} rows={rows} paging={15} />;
};
```

## Links

- ⬆ [[Netrunner]]
