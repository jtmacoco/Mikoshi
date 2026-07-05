---
title: Directives
source: "[[SYSTEM MANIFEST]]"
tags:
  - directives
created: 2026-07-04
---

## Overview

Task hub — active jobs, queued ops, and completed contracts

---

## Status

- [[On-Contract]]  — Currently running
- [[Backlog]]  — Queued, not yet started
- [[Completed]]  — Flatlined and done

---

## Critical & High Priority (auto)

```dataview
TASK
FROM "Mikoshi/Directives"
WHERE !completed AND (contains(tags, "#critical") OR contains(tags, "#high"))
```

---

## Priority Legend

- `#critical` → do now, no excuses
- `#high` → important, this week
- `#low` → whenever, no rush

## Area Tags

- `#academic` → Academy tasks
- `#contract` → Contracts/projects
- `#netrunner` → Coding tasks
- `#personal` → personal tasks

---

## Rules

- Tasks live here, projects live in [[Contracts]]
- Every task links back to its source project
- Move to [[Completed]] when done
- Move to [[Flatlined]] when cancelled
