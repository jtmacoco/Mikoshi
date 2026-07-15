---
title: Mental Math Config
source: "[[Secretes of mental math]]"
tags:
  - mental-math
created: 2026-07-14
status: personal
---
---

```js
const chapters = {
  0: {
    chapter: "Chapter 0 - Quick Tricks",
    sections: [
      { op: "mult11", digitsA: 2, count: 8 },
      { op: "mult5", digitsA: 2, count: 8 },
      { op: "square5", digits: 1, count: 6 },
    ]
  },
  1: {
    chapter: "Chapter 1 - Addition & Subtraction",
    sections: [
      { op: "add", digitsA: 2, digitsB: 2, count: 8 },
      { op: "add", digitsA: 3, digitsB: 3, count: 6 },
      { op: "sub", digitsA: 2, digitsB: 2, count: 6 },
      { op: "sub", digitsA: 3, digitsB: 3, count: 5 },
    ]
  },
  2: {
    chapter: "Chapter 2 - Basic Multiplication",
    sections: [
      { op: "mult", digitsA: 2, digitsB: 1, count: 10 },
      { op: "mult", digitsA: 3, digitsB: 1, count: 8 },
    ]
  },
  3: {
    chapter: "Chapter 3 - Intermediate Multiplication",
    sections: [
      { op: "mult", digitsA: 2, digitsB: 2, count: 10 },
      { op: "mult11", digitsA: 2, count: 5 },
      { op: "mult11", digitsA: 3, count: 5 },
    ]
  },
  4: {
    chapter: "Chapter 4 - Mental Division",
    sections: [
      { op: "div", digitsA: 2, digitsB: 1, count: 10 },
      { op: "div", digitsA: 3, digitsB: 1, count: 8 },
    ]
  },
  5: {
    chapter: "Chapter 5 - Guesstimation",
    sections: [
      { op: "estimate", digitsA: 3, digitsB: 2, count: 10 },
      { op: "estimate", digitsA: 3, digitsB: 3, count: 8 },
    ]
  },
  6: {
    chapter: "Chapter 6 - Pencil-and-Paper Math",
    sections: [
      { op: "mult", digitsA: 3, digitsB: 3, count: 8 },
      { op: "add", digitsA: 4, digitsB: 4, count: 6 },
    ]
  },
  8: {
    chapter: "Chapter 8 - Advanced Multiplication",
    sections: [
      { op: "mult", digitsA: 3, digitsB: 2, count: 8 },
      { op: "square", digits: 3, count: 8 },
      { op: "square", digits: 2, count: 6 },
    ]
  },
};

// ====== CHANGE ONLY THIS LINE TO SWITCH CHAPTERS ======
const config = chapters[1];
```

