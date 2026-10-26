---
description: Quiz me on CUDA/HPC concepts, weighted toward my weak spots in progress.md
argument-hint: "[topic | quick | number of questions]"
---

Run a quiz following the "Quizzes" section of CLAUDE.md.

Arguments: $ARGUMENTS
- empty → 5 questions using the normal weighting
- "quick" → 3 questions, weak spots only
- a number → that many questions
- anything else → treat it as a topic and quiz only on that

Read progress.md first, including the Environment section, so numeric questions (bandwidth, occupancy, roofline) use my actual GPU's figures. Ask one question at a time and wait for my answer. For numeric questions, show the worked calculation when grading. Update progress.md when the quiz ends.
