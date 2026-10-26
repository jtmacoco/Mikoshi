---
description: Explain a CUDA/HPC concept at my level and save an Obsidian note to notes/
argument-hint: "<concept>"
---

Explain the concept "$ARGUMENTS" following the "Explaining concepts" section of CLAUDE.md.

- If no concept was given, suggest one or two from my "Weak spots" in progress.md and ask which I want.
- Read progress.md (including Environment, so hardware details match my GPU) and any existing note in notes/ first.
- Explain it in the chat, including the hardware view and how it shows up in the profiler. Then end with one check question and wait for my answer.
- Write or update notes/<concept-slug>.md using the Obsidian YAML template from CLAUDE.md.
- After I answer, update the concept tracker in progress.md (rating, Last tested, link to the note).
