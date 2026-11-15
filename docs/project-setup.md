# Initial project-setup specification

## Scope

This document specifies the installation transaction and setup-state contract for maintainers. The agent-facing restoration procedure lives in [the setup instructions](../instructions/maintenance/project-setup.md).

For releases implementing this specification, the first installation archives existing project materials before handing the project to an agent. The agent's first task is to restore and prepare the project from this snapshot, following existing requirements and the [student workflow](student-workflow.md). This behavior is unreleased; published `v0.0.1` and `v0.0.2` retain their original behavior.

Only initial installation (`--from-version none`) may archive materials. An existing `.tt/thesis-trail.json`, even invalid, prevents installation. An empty or unrelated `.tt/` alone is not an installed version. Updating any existing version never archives project materials or restarts completed setup.

## Archive and installation

1. Validate the release, destinations, instruction and ignore markers, and backup location before moving materials. Release staging and `TMPDIR` must be outside the project. `.tt/backups` must be absent or a real directory, never a symlink. Edited `AGENTS.md` and `.tt/.gitignore` destinations must be regular files.
2. Collect root entries, including hidden and ignored files, directories, and symlinks, except `.git`, `.tt`, `.gitignore`, and legacy `.backup`. Do not follow symlinks. Root `.git` may be a directory or pointer file. Leave root `.gitignore` byte for byte and attribute for attribute unchanged.
3. If there are entries, create a unique `.tt/backups/project-UTC_TIMESTAMP.RANDOM/` and move the entries into it, preserving names, bytes, permissions, and modification times. Existing snapshots, legacy `.backup`, and unrelated `.tt/` files remain in place.
4. Install the kit and regenerate `AGENTS.md`, preserving custom root instructions. Add or update only the marked ThesisTrail block in `.tt/.gitignore`. It excludes `/backups/`, `/setup-state`, `/update-state`, locks, and transaction/temporary files, while allowing instructions, version metadata, the updater, and the ignore file itself to be tracked. Preserve custom ignore rules and reject malformed or duplicate markers before archival.
5. Write local `.tt/setup-state` in Git config format with `setup.status = pending` and `setup.backup = .tt/backups/project-...`. It is created only for an archived project; conflicting initial state requires inspection.
6. Publish metadata last. Print the snapshot location, explain that it is local and ignored by Git, and direct the student to request preparation from the backup. State that all materials must be restored and verified before backup removal. An empty project gets the ordinary topic-discussion handoff without a snapshot or setup state.

The installer does not create a topic card, infer a topic, parse academic documents, or run an agent. Existing cards and requirements are archived without content changes. Until restoration, original materials are absent from their former paths, except regenerated `AGENTS.md`; root `.gitignore` remains untouched. Already tracked files can appear deleted during this interval. Ignore rules do not untrack files already in Git.

Stage replacements and transaction backups before moving materials. Ordinary failures and handled signals restore managed files and archived entries with their original attributes. Conflicting recovery destinations are not overwritten. Incomplete recovery retains and reports the transaction and snapshot. A fully restored failure may leave empty `.tt/` directories. There is no cross-file atomicity or power-loss recovery.

## Agent handoff and state transitions

`.tt/setup-state` is Git config data. The installed setup instructions consume it before normal onboarding:

| State | Required outcome |
| --- | --- |
| Missing | No pending archive preparation is inferred. |
| `pending` | A requested preparation restores or accounts for the exact snapshot, preserves originals, reuses existing context, and creates or reuses a topic card. |
| `complete` | Later sessions and releases do not restart preparation. |
| Invalid state, unsafe path, or missing snapshot | Preparation remains unresolved; the agent does not guess another snapshot or overwrite conflicting files. |

Completion requires every archived entry to be restored or explicitly accounted for, the snapshot retained, root instructions preserved, and any reference-library metadata consistent with the [library contract](material-library.md). Existing and newly created working files remain protected during partial restoration. Unread reference placeholders can satisfy inventory requirements without fabricated summaries.

Every retained material needs a verified working copy outside the snapshot; an inventory entry alone does not count as restoration. Unresolved files or conflicts keep setup pending. Backup removal is a separate explicit student request after restoration is complete and rechecked; neither setup nor updates delete snapshots automatically. Existing states pointing to legacy `.backup/project-...` remain supported without relocating those snapshots.

Only successful completion changes `setup.status` to `complete`. Interruptions and unresolved conflicts leave it `pending`. Setup does not stage, commit, or publish the temporarily emptied project. A discussion-only request does not trigger restoration writes. The detailed procedure and conflict handling belong to the installed setup instructions.

## Acceptance criteria

Verify in disposable projects without adding a test suite to the repository:

- Initial installation archives visible and hidden files, nested directories, filenames containing spaces, ignored files, symlinks, and an existing topic card; archived bytes and attributes remain unchanged.
- `.git` directories and pointer files, root `.gitignore`, unrelated `.tt/` files, and older snapshots remain in place. New snapshots and local state are ignored by `.tt/.gitignore`, while installable assets remain trackable.
- State references the exact snapshot and is pending. Empty projects create neither a snapshot nor setup state.
- Repeated installation, unsafe `.tt/backups` or `.tt/.gitignore` destinations, malformed markers, and conflicting setup state fail without moving materials.
- Injected archive-move, kit-file replacement, and final-metadata replacement failures restore original materials, modes, and modification times. An incomplete restoration retains and reports recovery paths.
- Updating a `v0.0.2` installation leaves working materials, setup state, and backups untouched. The updated instructions can resume pending setup but do not create it themselves.
- Bash 3.2 syntax and execution pass. Review the installed agent instructions for first setup, resuming a partial restore, conflicts, completed setup, and existing topic cards. An actual agent-client pilot remains a separate behavioral check.
- For a snapshot whose `materials/` contains code or rendering assets, restore it in place without adding `/materials/` to `.gitignore`; route references to an available fallback and preserve existing working references. Keep catalogs/cards and original-to-restored mappings consistent as specified in the [material library](material-library.md).

## Verification

On 2026-11-15, the revised local-backup layout passed the thematic-installation and recovery checks, plus 41 dedicated local-data assertions. Git checks confirmed that `.tt/backups/`, state, locks, and temporary files are ignored while release assets remain trackable. Root `.gitignore` bytes, mode, and modification time stayed unchanged. Custom local-ignore rules and modes survived installation and updates; malformed markers and unsafe local destinations were rejected before archival. Legacy snapshots were left in place. The handoff explicitly required complete restoration before backup removal.

The following earlier run verified the predecessor layout with root `.backup/`; it is historical coverage, not a claim that the old path is still used for new installations.

On 2026-11-14, 75 assertions passed across ten disposable-source scenarios on macOS with Bash 3.2.57. Checks covered initial archival and standard-input installation, an empty project, hidden/ignored files and symlinks, original attributes, a root Git pointer file, existing snapshots and instructions, a copy-based restoration exercise, pending/completed setup preservation during updates, and application through the published `v0.0.2` launcher. Unsafe destinations and staging inside the project were rejected before archival.

Injected archive-move, kit-file, final-metadata, and handled-signal failures restored the original materials. An injected restoration failure retained all originals across the working directory and snapshot, retained transaction backups, and reported both recovery paths. Individual Bash syntax checks and `git diff --check` passed. The temporary verification harness is outside the repository; no test files or production refs were added. Linux execution and an actual agent-client restoration pilot remain unverified.
