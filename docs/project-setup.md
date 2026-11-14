# Initial setup of an existing project

## Scope

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

## First agent task

At the start of work, check `.tt/setup-state` before normal topic onboarding. Read it as data using `git config --file`; never source it or execute its contents. A missing file means no pending archive setup. A completed state must not restart setup. Invalid status, an unsafe path, or a missing snapshot requires clarification, not a guessed replacement.

When setup is pending and the student asks to work on or prepare the project:

1. Validate that the snapshot is a real directory directly under the project's real `.backup/`, with no traversal or symlink components. Read archived root instructions, README, relevant requirements, and the file listing. Do not execute archived code or follow symlinks outside the snapshot while inspecting it.
2. Briefly describe the existing work and intended restoration. Use existing requirements and specifications; distinguish agreed requirements from proposals. Preserve original paths and organization unless a concrete agreed requirement needs a change. Reference documents follow the [material library](material-library.md); inspect archived `materials/` and any catalog before selecting a library path or changing ignore rules. For implementation changes, record expected behavior and acceptance criteria in the relevant project specification first.
3. Copy materials back, preserving the entire snapshot. Preserve symlinks as links and file permissions. Do not copy `.git`, `.tt`, or `.backup` into the working root. Keep the current root `AGENTS.md` and `.gitignore`: they already preserve the original content plus required kit additions. Add a library ignore rule only after establishing the chosen directory's purpose. Resolve differing existing destination files rather than overwriting them blindly; identical existing files can be reused. Resume partial work without deleting newly created files. Recognized references can be copied directly into library categories with source-to-destination paths recorded in the catalog; preserve their previous working paths when links or build inputs depend on them until relocation is resolved.
4. Reuse the restored topic card if present. Otherwise create `docs/topic.md` from known information using the six-field template, with explicit unknowns and provisional translations. Respect an explicitly identified equivalent card elsewhere. Do not rewrite source documents solely to populate the card or introduce an unsupported folder taxonomy.
5. If reference documents exist, create or reuse their mirrored cards and `docs/materials.md`, including explicitly unread placeholders when needed. Keep originals ignored and metadata available to Git. A technical `materials/` directory is restored at its original path and is not ignored; use an available `research-materials/` for references and record that choice. If both paths or the documentation locations conflict, clarify before writing. See the [rendering-assets example](material-library.md#example-materials-already-contains-rendering-assets).
6. Verify that each archived entry has been restored or its different treatment is accounted for under the agreed library rules or an explicit decision, the snapshot remains intact, the root kit hook and required ignore rules remain, and the topic card has been created or reused. References must have catalog entries and cards, but reading every document in full is not required. Only then run `git config --file .tt/setup-state setup.status complete` and summarize the prepared structure and unresolved academic questions. If interrupted or conflicts remain, keep `pending` and report the remaining work. Do not stage, commit, or publish the temporarily emptied project as part of setup.

The pending state identifies the first task; it does not override a student's request to discuss only or otherwise restrict changes. No separate blanket confirmation is required when the student explicitly asks to prepare the project.

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
