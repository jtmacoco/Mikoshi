<%*
const year = moment().format("YYYY");
const month = moment().format("MM");
const day = moment().format("YYYY-MM-DD");

const base = `Mikoshi/Memory Shards`;
const yearPath = `${base}/${year}`;
const monthPath = `${yearPath}/${month}`;
const dayPath = `${monthPath}/${day}`;
const notesName = `encoded_${day}_notes`;
const encodedNotesName= `encoded_${day}_notes`;
const notesPath = `${dayPath}/${notesName}.md`;
const encodedNotesPath = `${dayPath}/${encodedNotesName}.md`;

const sectorName = `Sector ${month}`;
const sectorPath = `${monthPath}/${sectorName}.md`;
const uplinkName = `Uplink ${year}`;
const uplinkPath = `${yearPath}/${uplinkName}.md`;
const shardsPath = `${base}/Memory Shards.md`;

// Create folders
for (const path of [yearPath, monthPath, dayPath]) {
    if (!await app.vault.adapter.exists(path)) {
        await app.vault.createFolder(path);
    }
}

// Journal MOCs follow the standard MOC shape. Links go at the end of "## All Notes", above "## Links".
const today = moment().format("YYYY-MM-DD");
const mocText = (title, source, tag, overview, link) =>
    `---\ntitle: ${title}\nsource: "[[${source}]]"\ntags: [moc, shards, ${tag}]\ncreated: ${today}\n---\n\n` +
    `## Overview\n\n${overview}\n\n## All Notes\n\n- [[${link}]]\n\n## Links\n\n- ⬆ [[${source}]]\n`;
const ensureMoc = async (path, link, makeText) => {
    if (!await app.vault.adapter.exists(path)) {
        await app.vault.create(path, makeText());
        return;
    }
    const text = await app.vault.adapter.read(path);
    if (text.includes(`[[${link}]]`)) return;
    const i = text.indexOf("\n## Links");
    const out = i === -1
        ? text.trimEnd() + `\n- [[${link}]]\n`
        : text.slice(0, i).trimEnd() + `\n- [[${link}]]\n` + text.slice(i);
    await app.vault.adapter.write(path, out);
};

await ensureMoc(shardsPath, uplinkName, () => mocText("Memory Shards", "SYSTEM MANIFEST", "engrams", "Daily journal, one folder per day", uplinkName));
await ensureMoc(uplinkPath, sectorName, () => mocText(uplinkName, "Memory Shards", "uplink", "Keeps track of monthly notes", sectorName));
await ensureMoc(sectorPath, notesName, () => mocText(sectorName, uplinkName, "sector", "Keeps track of daily entries", notesName));

// Create today's notes file
if (!await app.vault.adapter.exists(notesPath) && !await app.vault.adapter.exists(encodedNotesPath)) {
    await tp.file.create_new(tp.file.find_tfile("Daily-Notes"), notesName, false, dayPath);
}
%>