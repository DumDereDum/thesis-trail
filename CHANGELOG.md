# Changelog

## [Unreleased]

- Guide students through a first topic discussion and a six-field, bilingual topic card in `docs/topic.md`.
- Reuse existing topic context and update accepted decisions without repeating onboarding or inventing academic details.
- Include the card template in the agent rules and extend the root `AGENTS.md` hook to cover the student workflow.
- Print a next-step prompt after initial installation; keep topic cards student-owned and outside installer/update management.

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
