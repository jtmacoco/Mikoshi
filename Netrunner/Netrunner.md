---
title: Netrunner
source: "[[SYSTEM MANIFEST]]"
tags: [moc]
created: 2026-07-04
---

## Overview

Knowledge arsenal — references, snippets, and tech notes to pull from on any job

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
## CheatSheets
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
