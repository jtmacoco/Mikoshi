---
source: "[[SYSTEM MANIFEST]]"
tags:
  - jacked-in
  - hud
created: 2026-11-19
cssclasses:
  - hud
---

# ⌬ HUD

> [!quote] Another tale for the next dreamer

## Fast Travel

> [!abstract] ⟁ Jump points
> | Sector | Destinations |
> |---|---|
> | 🩺 [[Ripperdoc]] | [[Cuda Dev]] · [[Driver Dev]] · [[Mikoshi/Ripperdoc/Git/Git\|Git]] · [[Mikoshi/Ripperdoc/Linux/Linux\|Linux]] |
> | 📋 Debriefs | [[Git Debrief\|Git]] · [[Linux Debrief\|Linux]] |
> | 🧊 [[ICEbreaker]] | [[Leetcode]] |

---

## Today

```dataviewjs
// Today's Memory Shard (created by the DailySetup template): link + checkable TODOs.
const day = moment().format("YYYY-MM-DD");
const path = `Mikoshi/Memory Shards/${moment().format("YYYY/MM")}/${day}/encoded_${day}_notes.md`;
const page = dv.page(path);
if (page) {
  dv.paragraph(`📓 ${dv.fileLink(path, false, `Memory Shard — ${moment().format("ddd, MMM D")}`)}`);
  dv.taskList(page.file.tasks, false);
} else {
  dv.paragraph(`No shard for ${day} yet. Run the DailySetup template to create it.`);
}

// Today's Mental Math quiz: link if it exists, otherwise a button that creates it from the template.
const QUIZ_DIR = "Mikoshi/Data Shards/Math Protocol/Daily Quiz";
const quizPath = `${QUIZ_DIR}/${day}.md`;
const quiz = dv.page(quizPath);
if (quiz) {
  const status = quiz.quizCompleted ? `✓ ${quiz.quizScore} in ${quiz.quizTimeSec}s` : "not taken yet";
  dv.paragraph(`🧮 ${dv.fileLink(quizPath, false, "Mental Math Quiz")} · ${status}`);
} else {
  const btn = dv.container.createEl("button", { text: "🧮 Start today's Mental Math Quiz" });
  btn.onclick = async () => {
    const tp = app.plugins.plugins["templater-obsidian"]?.templater;
    const tpl = app.vault.getAbstractFileByPath("Mikoshi/Templates/Template-Daily-Math.md");
    if (!tp || !tpl) return new Notice("Templater or the Daily Math template is missing");
    await tp.create_new_note_from_template(tpl, QUIZ_DIR, day, true);
  };
}
```

---

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