<%*
// --- Prompts (edit defaults as you like) ---
const bookTitle = await tp.system.prompt("Book title", "Linux Kernel Programming");
const author = await tp.system.prompt("Author", "Kaiwan N. Billimoria");
const chapterNum = await tp.system.prompt("Chapter number", "1");
const chapterTitle = await tp.system.prompt("Chapter title", "");
const topicTags = await tp.system.prompt("Topic tags (comma-separated)", "kernel, c");
const prevChapter = await tp.system.prompt("Previous chapter number (blank if none)", "");
const nextChapter = await tp.system.prompt("Next chapter number (blank if none)", "");

const fileName = `${bookTitle} - Ch ${chapterNum} - ${chapterTitle}`;
await tp.file.rename(fileName);
tR += "";
%>---
type: datashard
category: book-chapter
book: "[[<% bookTitle %>]]"
author: "<% author %>"
chapter: <% chapterNum %>
chapter_title: "<% chapterTitle %>"
status: in-progress
tags:
  - book-notes
<% topicTags.split(",").map(t => `  - "${t.trim()}"`).join("\n") %>
date_started: <% tp.date.now("YYYY-MM-DD") %>
last_updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% chapterNum %>. <% chapterTitle %>

**Book:** [[<% bookTitle %>]]
**Author:** <% author %>
**Status:** #in-progress <!-- swap to #done once the chapter is finished -->

> This note grows as you read — jot things down mid-chapter rather than waiting to finish. Treat it like a live wiki page for this chapter, not a final report.

---

## TL;DR
> Keep this updated as your understanding sharpens — it's fine if it's rough or wrong early on.

---

## Vocabulary / Key Terms
<!-- Add terms the moment you hit them, even before you fully understand them -->

| Term | Definition | Notes |
|------|------------|-------|
|      |            |       |

---

## Core Concepts
<!-- One entry per idea — add as you encounter them, expand later -->

- **Concept:**
  - Why it matters:
  - Related to: 

---

## Assumed Knowledge

-

---

## Session Log
<!-- Running, dated notes — the actual "as I read it" capture. Newest entry on top. -->

### <% tp.date.now("YYYY-MM-DD HH:mm") %>
-

---

## Code / Commands / Snippets

```c
// paste and annotate notable code as you go
```

**What it does:**
**Gotchas / edge cases:**

---

## Architecture / Diagrams


---

## Questions & Confusions
- [ ]

---

## Connections
- Builds on: [[]]
- Contrasts with: [[]]
- Referenced later in: [[]]

---

## Personal Analogies 
-

---
## Practical Exercises / Labs

---

## Further Reading / Tangents
<!-- Things this chapter made you curious about but that are out of scope for now -->
-

---

## Chapter Summary (fill in once finished)
> Written last, in your own words, no peeking at the book.


---

## Backlinks
- Table of contents: [[<% bookTitle %> - TOC]]
<%* if (prevChapter) { -%>
- Previous: [[<% bookTitle %> - Ch <% prevChapter %>]]
<%* } -%>
<%* if (nextChapter) { -%>
- Next: [[<% bookTitle %> - Ch <% nextChapter %>]]
<%* } -%>
