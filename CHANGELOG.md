# Changelog

## [Unreleased]

- Group agent instructions by general practices, research, maintenance, and future domains, with a short entry point selecting relevant modules. Install and update the complete instruction tree while retaining the existing entry path.
- Frame topics and major research decisions around the problem, meaningful alternatives, and justified choices; reuse accepted decisions for routine tasks without repeating research analysis or adding mandatory documents.
- Guide students through a first topic discussion and a six-field, bilingual topic card in `docs/topic.md`.
- Reuse existing topic context and update accepted decisions without repeating onboarding or inventing academic details.
- Include the card template in the agent rules and extend the root `AGENTS.md` hook to cover the student workflow.
- On first installation into an existing project, move original materials into a unique ignored `.backup/` snapshot and record pending preparation in `.tt/setup-state`.
- Make restoring the project from the retained snapshot the agent's first task; preserve original paths, use existing specifications, and create or reuse the topic card.
- Print the appropriate next-step prompt after initial installation; preserve student documents, backups, and setup state during updates.
- Organize local reference documents into articles, books, regulations, guidelines, and other materials, with a Git-visible catalog and mirrored Markdown cards.
- During backup restoration, preserve a technical `materials/` directory and choose a separate document library before adding ignore rules; answer document questions from relevant originals.
- Support explicit topic-based literature searches, accessible full-text downloads, and card/catalog completion with verified source metadata, relevance, and honest access/reading status.
- Report new or missing library files at session start without automatically changing files, metadata, ignore rules, or downloading replacements.

## [v0.0.2]

- Install a standalone update launcher, agent rules, and release notes in `.tt/`.
- Add a marked root `AGENTS.md` section without replacing existing instructions.
- Check for release tags at most once per 24 hours and remember deferred tags.
- Apply only an explicitly requested release using that release's own installation and migration script.
- Preserve project documents, unknown metadata fields, and the original installation time; restore managed files after an application failure.
- Support a one-time migration from the metadata-only `v0.0.1` installation.

## [v0.0.1]

- Initialize `.tt/thesis-trail.json` from a remote version tag or branch.
- Record the selected source, full commit SHA, and UTC installation timestamps.
- Preserve existing project files and reject repeated installation.
