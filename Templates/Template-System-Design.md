<%*
let title = await tp.system.prompt("System to design (e.g. 'Design TinyURL'):");
await tp.file.rename(title);
-%>
---
title: <% title %>
source: "[[System Design]]"
tags: [system-design]
created: <% tp.date.now("YYYY-MM-DD") %>
status: unsolved
---

## Problem Statement


## Requirements

### Functional
- 

### Non-Functional
- 

## Capacity Estimation

**Traffic:** 
**Storage:** 
**Bandwidth:** 

## API Design


## High-Level Design

*(diagram / component overview)*


## Deep Dive

*(pick 1-2 components and go deep — data model, algorithm, specific service)*


## Bottlenecks & Scaling


## Tradeoffs & Alternatives

