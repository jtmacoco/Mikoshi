<%*
const year = moment().format("YYYY");
const month = moment().format("MM");
const day = moment().format("YYYY-MM-DD");

const base = `Mikoshi/Engrams`;
const yearPath = `${base}/${year}`;
const monthPath = `${yearPath}/${month}`;
const dayPath = `${monthPath}/${day}`;
const notesName = `${day}_notes`;
const notesPath = `${dayPath}/${notesName}.md`;

const sectorName = `Sector ${month}`;
const sectorPath = `${monthPath}/${sectorName}.md`;
const uplinkName = `Uplink ${year}`;
const uplinkPath = `${yearPath}/${uplinkName}.md`;
const shardsPath = `${base}/Engrams.md`;

// Create folders
for (const path of [yearPath, monthPath, dayPath]) {
    if (!await app.vault.adapter.exists(path)) {
        await app.vault.createFolder(path);
    }
}

// Create Shards.md if missing and add year link
if (!await app.vault.adapter.exists(shardsPath)) {
    await app.vault.create(shardsPath, `**Source**: SYSTEM MANIFEST\nTags: #shards\nDescription: Daily notes\n\n## Years\n- [[${uplinkName}]]`);
} else {
    const shards = await app.vault.adapter.read(shardsPath);
    if (!shards.includes(`[[${uplinkName}]]`)) {
        await app.vault.adapter.write(shardsPath, shards + `\n- [[${uplinkName}]]`);
    }
}

// Create Uplink YYYY.md if missing and add month link
if (!await app.vault.adapter.exists(uplinkPath)) {
    await app.vault.create(uplinkPath, `**Source**: [[Shards]]\nTags: #uplink\nDescription: Keeps Track of monthly notes\n\n## Month\n- [[${sectorName}]]`);
} else {
    const uplink = await app.vault.adapter.read(uplinkPath);
    if (!uplink.includes(`[[${sectorName}]]`)) {
        await app.vault.adapter.write(uplinkPath, uplink + `\n- [[${sectorName}]]`);
    }
}

// Create Sector MM.md if missing and add day link
if (!await app.vault.adapter.exists(sectorPath)) {
    await app.vault.create(sectorPath, `**Source**: [[${uplinkName}]]\nTags: #sector\nDescription: Keeps track of daily entries\n\n## Entries\n- [[${notesName}]]`);
} else {
    const sector = await app.vault.adapter.read(sectorPath);
    if (!sector.includes(`[[${notesName}]]`)) {
        await app.vault.adapter.write(sectorPath, sector + `\n- [[${notesName}]]`);
    }
}

// Create today's notes file
if (!await app.vault.adapter.exists(notesPath)) {
    await tp.file.create_new(tp.file.find_tfile("Template-Daily-Notes"), notesName, false, dayPath);
}
%>