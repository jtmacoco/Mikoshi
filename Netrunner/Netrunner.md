---
title: Netrunner
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview

Knowledge arsenal — references, snippets, and tech notes to pull from on any job

## MOC Files

```dataview
LIST FROM "Mikoshi/Netrunner"
WHERE contains(file.tags, "moc")
```

## Concept
```dataview
LIST FROM "Mikoshi/Netrunner" 
WHERE notetype = "concept" OR type = "concept"
SORT created DESC
```

## References
```dataview
LIST FROM "Mikoshi/Netrunner" 
WHERE notetype = "reference" OR type = "reference"
SORT created DESC
```

## Cheat Sheets
```dataview
LIST FROM "Mikoshi/Netrunner" 
WHERE notetype = "cheatsheet" OR type="cheatsheet"
SORT created DESC
```

## All Notes

```dataview
LIST
FROM "Mikoshi/Netrunner"
SORT file.name ASC
```
