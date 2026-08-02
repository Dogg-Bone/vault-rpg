# 10 Obsidian Plugin Ideas for the Root RPG Vault

Based on the specific structure, mechanics, and formatting rules of your Root RPG vault and the "Woodland Lost" campaign, here are 10 original, highly tailored, and do-able Obsidian plugin ideas ranging from easy to moderate difficulty.

Each idea includes a description and a brief overview of how you could build it using the Obsidian API.

---

## 1. PbtA Move Quick-Reference Modal
**Description:** Since all your RPG moves are strictly formatted using `> [!tip] Title` callouts (e.g., in `Rules/Moves/`), it can be tedious to find the exact 10+, 7-9, and 6- outcomes during a live session. This plugin adds a hotkey to open a fuzzy-search modal. Typing a move name instantly shows the parsed contents of the callout, allowing the GM to read the results without leaving their current session note.
**How to Build (Easy):**
- Extend `SuggestModal` from the Obsidian API.
- Use `app.metadataCache` to find all files in the `Rules/Moves/` directory.
- Use `app.vault.cachedRead()` and basic Regex to extract blocks starting with `> [!tip]`.
- Display the matched text in the modal's preview area.

## 2. Endgame Faction Clock Tracker
**Description:** The vault utilizes 6-segment PbtA-style Faction Clocks for endgame scenarios. This plugin adds a custom right-sidebar pane that visually renders 6-segment pie-chart clocks. GMs can click to advance or decrease segments during a session, and tie specific PbtA GM moves to the clock's completion.
**How to Build (Moderate):**
- Register a custom `ItemView` to live in the right workspace leaf.
- Use simple HTML/CSS or an SVG circle with `stroke-dasharray` to draw a 6-segment pie chart.
- Store the state of active clocks (name, current segment 0-6) in the plugin's `data.json` file.

## 3. Single-Link Enforcer / Auditor
**Description:** Your vault has a strict rule: "link proper nouns, factions, and characters exactly once per target per file." Manually checking this is painful. This plugin adds a command to audit the current file (or entire vault). It detects if a target (e.g., `[[The Magpie Syndicate]]`) is linked multiple times in the same note, and optionally auto-converts duplicates back to plain text.
**How to Build (Moderate):**
- Create a command using `addCommand`.
- Use `app.metadataCache.getFileCache(file).links` to get all links in a file.
- Count occurrences of each link destination.
- Use the `Editor` API or `app.vault.modify` with String `.replace()` (skipping the first match) to strip brackets from duplicates.

## 4. Fractal Clearing Scaffolder
**Description:** Creating a "fractal clearing" requires a massive overarching profile and multiple nested district profiles, all adhering to a specific markdown template (Atmosphere, Shape Flow, 3-5 evocative details, etc.). This plugin prompts for a Clearing Name and a number of districts, then auto-generates the folder structure and pre-fills the files with the correct `> [!tip]` callouts and layout headers.
**How to Build (Moderate):**
- Create a `Modal` with a text input (Clearing Name) and a number input (Districts).
- Use `app.vault.createFolder()` to make a new directory in `jules/` (or designated folder).
- Use `app.vault.create()` to generate the overarching note and nested notes, injecting a hardcoded template string that matches your `Workshop/Clearing Creation Guidelines.md`.

## 5. 5-Room Dungeon Spark Roller
**Description:** The vault contains definitive 2d6 spark tables for 5-Room Dungeons (`jules/5-Room Dungeon Spark Tables.md`). Instead of rolling physical dice and looking up the tables, this plugin adds a command that simulates the 2d6 rolls, reads the spark tables, and directly inserts a randomly generated dungeon outline (Entrance, Puzzle, Setback, Climax, Resolution) into your current cursor position.
**How to Build (Moderate):**
- On plugin load, read the spark table markdown file using `app.vault.read()`.
- Use a simple regex to parse the markdown tables into JavaScript arrays/objects.
- Generate random 2d6 rolls (`Math.floor(Math.random() * 6) + 1`).
- Use the `Editor.replaceRange()` method to insert the generated text into the active editor.

## 6. Woodland Lost Party Dashboard
**Description:** A GM dashboard specifically for your campaign. It tracks the Harm and Exhaustion tracks for the specific party members: Warren the Exile, Anita Break, and Robin Banks. It also includes quick-reference buttons for their preferred combat styles (e.g., throwing knives for Anita, oil/torches for Robin).
**How to Build (Moderate):**
- Register an `ItemView` and place it in a workspace leaf.
- Hardcode or configure the UI for the three specific characters.
- Add simple clickable checkboxes or custom SVG boxes for Harm/Exhaustion tracks, saving their state to the plugin's `data.json`.
- Add internal links that use `app.workspace.openLinkText()` to open their character sheets.

## 7. Moldy Worldbuilding Prompter
**Description:** "Moldy/Stratified worldbuilding" is a core concept for your clearings. This plugin adds a ribbon icon (the left sidebar). When clicked while editing a Clearing note, it inserts a random, evocative prompt about stratified history (e.g., "What pre-Dynastic mechanical genius is buried under the current market?") to help spur inspiration.
**How to Build (Easy):**
- Use `addRibbonIcon()` to add a button to the sidebar.
- Create an array of 20-30 hardcoded stratified worldbuilding prompts tailored to the Root universe.
- Check if `app.workspace.getActiveViewOfType(MarkdownView)` is active.
- Insert a random prompt string using `editor.replaceSelection()`.

## 8. Relic & Equipment Tag Linter
**Description:** Relics in your vault must have Wear and Load tracks, and equipment tags must exist in `Rules/Equipment/Tags/`. This plugin adds a "Lint Equipment" command. When run on a note, it verifies that Relics have the required tracks, and highlights any tags (e.g., `+valuable`) that don't have a corresponding markdown file in the tags directory.
**How to Build (Moderate):**
- Add a command `addCommand` that reads the active note.
- Use regex to search for the word "Relic", "Wear:", and "Load:". If tracks are missing, show an Obsidian `Notice`.
- Parse words starting with `+`. Use `app.vault.getAbstractFileByPath('Rules/Equipment/Tags/' + tag + '.md')` to verify existence, and show a `Notice` if a tag is invalid.

## 9. NPC Strict Layout Generator
**Description:** The vault strictly replaces old NPC formats with a specific 'Character template' (Faction, Name, Job, Drive, Equipment, etc.). This plugin provides a command to quickly spawn a new NPC in `0. Bestiary/jules/` or `jules/Characters/`. It asks for the NPC name and auto-populates the strict layout, even auto-formatting the "Moves" section as bulleted PbtA-style narrative GM moves.
**How to Build (Easy):**
- Use `Modal` to ask for the NPC Name and Destination Folder.
- Use `app.vault.create()` to create the file.
- The content string should exactly match the fields defined in `Workshop/NPC Creation Guidelines.md`, ready to be filled out.

## 10. Reputation Move Auto-Formatter
**Description:** Formatting Reputation moves manually can be tedious, as they require a tip callout with the reputation requirement in the title, narrative text below, and the faction name appended to the filename. This plugin takes a rough draft of a move in an active note, and via a command, auto-formats it perfectly into the `> [!tip]` structure and prompts to rename the file.
**How to Build (Easy):**
- Use the `Editor` API to get the current selection (the raw move text).
- Use string manipulation to wrap the mechanical parts in `> [!tip] Move Name (Requires Reputation +X)`.
- Use `app.fileManager.renameFile()` to append `(Faction Name)` to the file's title.
