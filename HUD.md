---
Source: "[[SYSTEM MANIFEST]]"
Tags:
  - jacked-in
  - hud
Created: 2026-11-19
cssclasses:
  - hud
---

# ⌬ HUD

> [!quote] Wake up, samurai. We have a city to burn.

## Fast Travel

| Grind | Knowledge | Archive |
|---|---|---|
| [[Directives]] | [[Netrunner]] | [[Data Shards]] |
| [[Contracts]] | [[Ripperdoc]] | [[Memory Shards]] |
| [[Academy]] | [[ICEbreaker]] | [[Flatlined]] |
| [[Inbox]] | [[SYSTEM MANIFEST]] | [[Templates]] |

---

## Active Directives

```tasks
not done
path includes Mikoshi/Directives
(tags include #high) OR (tags include #critical)
sort by priority
hide backlink
short mode
```

## Live Contracts

```dataview
TABLE WITHOUT ID file.link AS "Contract", status AS "Status", dateformat(file.mtime, "MMM dd") AS "Last Touched"
FROM "Mikoshi/Contracts"
WHERE file.name = regexreplace(file.folder, "^.*/", "") AND file.name != "Contracts"
  AND (status = "active" OR status = "on-contract" OR contains(file.tags, "#on-contract") OR contains(file.tags, "#jacked-in"))
SORT file.mtime DESC
```

---

## Inbox

> [!inbox]- Raw capture (click to expand)
> ![[Inbox]]

---

## Directive Heatmap

![[Directive Heatmap]]
