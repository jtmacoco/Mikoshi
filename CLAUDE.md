# CLAUDE.md — Mikoshi

This is my Obsidian vault, called Mikoshi. It's a personal knowledge system named after Cyberpunk 2077: projects, tasks, coding notes, school, journals, book notes, interview prep and guided curricula. Your job is mostly busy work: sorting, linking, tables, MOCs, templates and keeping things consistent. Follow these rules every session.

## Before you change anything

- Read [[SYSTEM MANIFEST]] and the MOC of the folder you're working in before you edit it.
- Never delete a note. Move it to Flatlined instead.
- Don't reorganize things I didn't ask about. If you spot a problem somewhere else, tell me and don't fix it.
- For bulk changes (more than ~5 files, renames, moves), show me the plan first and wait for a yes.
- Renaming or moving a note: update every link to it, or tell me which links will break.
- Don't touch `Academy/`. It's legacy notes from my old vault. Leave them as they are, even when they break the rules below.
- If a folder has its own `CLAUDE.md` (for example `Ripperdoc/Linux/CLAUDE.md`), follow it for work inside that folder. It wins over this file where they conflict.

## Folder map

| Folder | What lives here | Tag |
|---|---|---|
| `SYSTEM MANIFEST.md` | Root of the vault; top-level MOC | — |
| `HUD.md` | Dashboard: Dataview queries, heatmap, inbox, fast travel | `#jacked-in` |
| `Inbox/Inbox.md` | Raw capture. One file inside the Inbox folder | — |
| `Directives/` | Tasks: `On-Contract/` (active), `Backlog/` (queued), `Completed/` | — |
| `Contracts/` | Projects and builds; `Ideas/` for fleshed-out project ideas | `#contract` |
| `Netrunner/` | Distilled coding and tech knowledge | `#netrunner` |
| `Quick Hacks/` | Anything I've Googled twice | `#netrunner` |
| `Academy/` | School and coursework | `#academic` |
| `Data Shards/` | Book notes | `#book` |
| `ICEbreaker/` | Interview answers | `#icebreaker` |
| `Ripperdoc/` | Guided curricula: lessons, quizzes, gigs | `#ripperdoc` |
| `Templates/` | Netrunner and general templates | — |
| `Flatlined/` | Archive: done projects and cancelled tasks | — |
| Daily journal | Journal entries | `#shards` |

You may add a new folder if it clearly makes things more organized. When you do, give it a CP2077-style name, a MOC, and a link from its parent MOC, and tell me you added it.

## Structure

- Every folder has a MOC that links up to its parent and down to its children.
- Every MOC's Source points to [[SYSTEM MANIFEST]] or its parent MOC.
- No orphan notes. Every note lives in a folder and links to that folder's MOC.
- Don't nest more than 3 levels deep unless it's truly needed.
- Memory Shards keeps one folder per day (`YYYY/MM/YYYY-MM-DD/`), even with a single note inside. This is on purpose: each day's shard can be decoded later without making a mess. Don't flatten it.
- Number prefixes on folders are optional. Let the names speak for themselves.
- Attachments go in an `Assets/` folder inside the relevant subfolder.
- Every MOC uses the same template structure. No exceptions.

## Capture

- Inbox first, sort later. When I'm capturing, don't organize.
- Raw ideas go straight into `Inbox/Inbox.md` as a line, not as a new file.
- New project idea: Inbox first, then `Contracts/Ideas/` once it's fleshed out.
- When I ask you to process the inbox, propose where each item goes, then move it once I agree.

## Notes

- Every note starts from the Netrunner or general template in `Templates/`. No blank files.
- `source` and `tags` are required on every note. No exceptions.
- Frontmatter keys are lowercase (`source`, `tags`, `created`, `status`).
- Frontmatter fields are plain text. Never bold them.
- Only add links I'd actually click. No linking for its own sake.
- Split a note into several files only when it genuinely earns it.

Frontmatter shape:

```yaml
---
title: Note Name
source: "[[Parent MOC]]"
tags: [netrunner, jacked-in]
created: YYYY-MM-DD
---
```

## Tasks

- Tasks live in Directives. Projects live in Contracts.
- Every task links back to its source project.
- `On-Contract/` holds active tasks only. Completed tasks move to `Completed/` right away. Don't let them pile up.
- `Backlog/` is for queued but not started. It's not a dumping ground.
- Priority tags: `#critical` = do now, `#high` = this week, `#low` = whenever. The HUD's Dataview queries depend on these, so spell them exactly.

## Knowledge

- If I Google something twice, it earns a spot in Quick Hacks.
- Books go in Data Shards. The distilled knowledge from them goes in Netrunner.
- Interview answers go in ICEbreaker. The concepts underneath them go in Netrunner.
- Contracts can link to Netrunner. Netrunner never links to Contracts.
- Split book notes by chapter only for dense technical books worth studying.
- Ripperdoc tests what I know. Netrunner stores what stuck.

## Archiving

- Done project: move to Flatlined.
- Cancelled task: move to Flatlined.
- Never delete. Flatline instead.

## Naming and tags

- CP2077 naming across all folders. Keep it consistent.
- Tags are kebab-case: `#on-contract`, not `#onContract` or `#on_contract`.
- File names use spaces, not underscores: `Memory Layout.md`, not `Memory_Layout.md`.
- Links use `[[wikilinks]]`, not markdown links.

| Tag | Meaning |
|---|---|
| `#academic` | Academy |
| `#netrunner` | Coding and tech reference |
| `#contract` | Projects and builds |
| `#shards` | Daily journal |
| `#book` | Book notes |
| `#icebreaker` | Interview prep |
| `#ripperdoc` | Guided curricula |
| `#personal` | Personal tasks (Directives area tag) |
| `#jacked-in` | Currently active |
| `#backlog` | Queued, not started |
| `#completed` | Done |
| `#critical` | Do now |
| `#high` | This week |
| `#low` | Whenever |

## Style

- Keep answers and notes short. This is a working vault, not an essay.
- CP2077 flavor is good in names and framing. Keep the actual explanations plain.
- Tables and checklists are welcome when they make something easier to scan.
