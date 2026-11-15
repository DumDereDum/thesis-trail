# Initial project-setup specification

## Scope

This document specifies the installation transaction and setup-state contract for maintainers. The agent-facing restoration procedure lives in [the setup instructions](../instructions/maintenance/project-setup.md).

For releases implementing this specification, the first installation archives existing project materials before handing the project to an agent. The agent's first task is to restore and prepare the project from this snapshot, following existing requirements and the [student workflow](student-workflow.md). This behavior is unreleased; published `v0.0.1` and `v0.0.2` retain their original behavior.

Only initial installation (`--from-version none`) may archive materials. An existing `.tt/thesis-trail.json`, even invalid, prevents installation. An empty or unrelated `.tt/` alone is not an installed version. Updating any existing version never archives project materials or restarts completed setup.

## Archive and installation

1. Validate the release, destinations, root instruction markers, and backup location before moving materials. The release staging directory (and the installer's `TMPDIR`) must be outside the project, so the running release is not archived. `.backup` must be absent or a real directory, never a symlink. Existing `AGENTS.md` and `.gitignore` must be regular files when edited.
2. Collect every root entry, including hidden files, ignored files, directories, and symlinks, except `.git`, `.tt`, and `.backup`. Do not follow symlinks while moving entries. Root `.git` may be a directory or a worktree/submodule pointer file; leave it untouched.
3. If there are entries, create a unique `.backup/project-UTC_TIMESTAMP.RANDOM/` and move the collected entries into it, preserving their names and contents. Never reuse an existing snapshot. Existing backups and unrelated `.tt/` files remain in place.
4. Install the kit. Recreate root `AGENTS.md` with the original instructions preserved and the ThesisTrail hook added or replaced. Recreate `.gitignore` with the original content and a final `/.backup/` exclusion. The snapshot retains the original versions of both files.
5. Write `.tt/setup-state` in Git config format with `setup.status = pending` and `setup.backup = .backup/project-...`. This runtime file is separate from installation metadata. It is created only for an archived project; existing setup state without installation metadata is a conflict requiring inspection.
6. Publish installation metadata last, then print the snapshot location and direct the student to ask their agent to prepare the project from the backup. An empty project gets the ordinary topic-discussion handoff, without a snapshot or setup-state file.

The installer does not create a topic card, infer a topic, parse academic documents, or run an agent. Existing cards and requirements are archived with the rest of the materials, without content changes. Until the agent restores them, original files are intentionally absent from their former paths, except the regenerated `AGENTS.md` and `.gitignore`. Already tracked files can appear deleted in Git during this interval. An ignore rule excludes new backups from ordinary staging but does not untrack any files already tracked by the student.

Stage replacements and transaction backups before moving materials. On an ordinary failure or handled signal, restore managed files and move archived entries back to their original paths. Keep the original file contents, permissions, and modification times. Do not overwrite a newly appeared conflicting destination during restoration. Report and retain both the transaction and snapshot if restoration is incomplete. A fully restored failure may leave empty `.tt/` and `.backup/` directories. There is no cross-file atomicity or power-loss recovery; do not rerun installation blindly after an unhandled interruption.

## Agent handoff and state transitions

`.tt/setup-state` is Git config data. The installed setup instructions consume it before normal onboarding:

| State | Required outcome |
| --- | --- |
| Missing | No pending archive preparation is inferred. |
| `pending` | A requested preparation restores or accounts for the exact snapshot, preserves originals, reuses existing context, and creates or reuses a topic card. |
| `complete` | Later sessions and releases do not restart preparation. |
| Invalid state, unsafe path, or missing snapshot | Preparation remains unresolved; the agent does not guess another snapshot or overwrite conflicting files. |

Completion requires every archived entry to be restored or explicitly accounted for, the snapshot retained, root instructions preserved, and any reference-library metadata consistent with the [library contract](material-library.md). Existing and newly created working files remain protected during partial restoration. Unread reference placeholders can satisfy inventory requirements without fabricated summaries.

Only successful completion changes `setup.status` to `complete`. Interruptions and unresolved conflicts leave it `pending`. Setup does not stage, commit, or publish the temporarily emptied project. A discussion-only request does not trigger restoration writes. The detailed procedure and conflict handling belong to the installed setup instructions.

## Acceptance criteria

Verify in disposable projects without adding a test suite to the repository:

- Initial installation archives visible and hidden files, nested directories, filenames containing spaces, ignored files, symlinks, and an existing topic card; archived bytes and attributes remain unchanged.
- `.git` directories and pointer files, unrelated `.tt/` files, and older snapshots remain in place. The snapshot is ignored by Git, while old root instructions and ignore rules remain active.
- State references the exact snapshot and is pending. Empty projects create neither a snapshot nor setup state.
- Repeated installation, unsafe backup/ignore destinations, malformed markers, and conflicting setup state fail without moving materials.
- Injected archive-move, kit-file replacement, and final-metadata replacement failures restore original materials, modes, and modification times. An incomplete restoration retains and reports recovery paths.
- Updating a `v0.0.2` installation leaves working materials, setup state, and backups untouched. The updated instructions can resume pending setup but do not create it themselves.
- Bash 3.2 syntax and execution pass. Review the installed agent instructions for first setup, resuming a partial restore, conflicts, completed setup, and existing topic cards. An actual agent-client pilot remains a separate behavioral check.
- For a snapshot whose `materials/` contains code or rendering assets, restore it in place without adding `/materials/` to `.gitignore`; route references to an available fallback and preserve existing working references. Keep catalogs/cards and original-to-restored mappings consistent as specified in the [material library](material-library.md).

## Verification

On 2026-11-14, 75 assertions passed across ten disposable-source scenarios on macOS with Bash 3.2.57. Checks covered initial archival and standard-input installation, an empty project, hidden/ignored files and symlinks, original attributes, a root Git pointer file, existing snapshots and instructions, a copy-based restoration exercise, pending/completed setup preservation during updates, and application through the published `v0.0.2` launcher. Unsafe destinations and staging inside the project were rejected before archival.

Injected archive-move, kit-file, final-metadata, and handled-signal failures restored the original materials. An injected restoration failure retained all originals across the working directory and snapshot, retained transaction backups, and reported both recovery paths. Individual Bash syntax checks and `git diff --check` passed. The temporary verification harness is outside the repository; no test files or production refs were added. Linux execution and an actual agent-client restoration pilot remain unverified.
