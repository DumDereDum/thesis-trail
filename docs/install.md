# ThesisTrail installer

## Scope and installed files

`scripts/install.sh` initializes ThesisTrail in the current project on macOS and Linux. Sources always come from `https://github.com/DumDereDum/thesis-trail.git`, retrieved into a temporary directory.

Releases containing the [update protocol](update.md) install:

- `.tt/thesis-trail.json`: installation/project metadata.
- `.tt/update.sh`: the standalone launcher from that revision.
- `.tt/agent-rules.md`: agent instructions.
- `.tt/CHANGELOG.md`: that revision's release notes.
- A marked ThesisTrail section in root `AGENTS.md` linking to the rules.

Existing root instructions are preserved; a missing `AGENTS.md` is created. No skills, separate template files, student documents, or client-specific directories are installed. Clients that do not read `AGENTS.md` need their own instruction configuration.

Revisions implementing the [student workflow](student-workflow.md) include an inline topic-card template in the agent rules and a root hook covering student work as well as maintenance. On first installation, [project setup](project-setup.md) moves existing root materials, including `docs/`, into a unique `.backup/project-.../`, excluding `.git`, `.tt`, and `.backup`. Root instructions and ignore rules are preserved in regenerated `AGENTS.md` and `.gitignore`; the latter excludes `/.backup/`. Runtime `.tt/setup-state` identifies the pending restoration and snapshot. The agent's first task is to copy materials back from the retained snapshot and create or reuse the topic card. Empty projects get the ordinary topic-discussion prompt without a backup or setup state. Installation does not start an agent or create a new card. Updates do not archive materials or print initial onboarding. This workflow is not included in `v0.0.2`.

`v0.0.1` predates the updater. Selecting that revision retains its metadata-only behavior; files from different revisions are never mixed. See [bootstrapping an older installation](update.md#bootstrapping-v001).

## Source selection

- No arguments: choose the newest tag by Git `creatordate` among numeric `vX.Y.Z` names, not the greatest semantic version. Annotated tags use tagger date; lightweight tags use committer date. Equal dates use ascending ref-name order.
- `--branch NAME`: select that remote branch.
- `--tag vX.Y.Z`: select that exact tag.
- Selectors are mutually exclusive and cannot be repeated. Invalid arguments, missing references, and retrieval failures stop without a fallback.
- The README downloads the launcher from `main`; its arguments select the installed source. The default command requires a published version tag.

## Metadata

`.tt/thesis-trail.json` contains:

| Field | Meaning |
| --- | --- |
| `schema_version` | Metadata schema, initially `1` |
| `repository` | Canonical source repository URL |
| `version` | Tag without `v`, or `null` for a branch |
| `tag` | Selected tag, or `null` for a branch |
| `branch` | Selected branch, or `null` for a tag |
| `commit` | Full commit SHA |
| `installed_at` | Initial installation time, UTC ISO 8601 |
| `updated_at` | Last successful installation/update time, UTC ISO 8601 |

First installation timestamps are equal. There is no `status` field. Existing metadata is never overwritten by the installer, even if invalid; updates use the separate launcher.

## Dependencies and failure behavior

- Require Bash 3.2+, Git, `mktemp`, `mkdir`, `rm`, `date`, `ln`, `awk`, `cp`, `mv`, `chmod`, and `cmp`. The README additionally uses `curl`.
- No Python, Node.js, `jq`, package manager, or automatic dependency installation.
- Check utilities, arguments, and destination conflicts before modifying project files.
- Reject a symlink or non-directory at `.tt/`; managed files and `AGENTS.md` must be regular files, not symlinks or directories.
- Stop if `.tt/thesis-trail.json` exists. No installer update, overwrite, or confirmation-bypass flags.
- Stage files and back up existing managed destinations before applying. Restore them on an ordinary application failure or handled signal. If restoration fails, retain and report the backup directory.
- For initial archival, also validate `.backup` and `.gitignore` before moving materials. Keep the successful snapshot; restore archived entries on a handled application failure. Empty `.backup/` may remain after rollback. See [project setup](project-setup.md) for the handoff interval and recovery limits.
- Remove temporary Git data on exit. A failure may leave an empty `.tt/` directory.
- Messages and code use English; `README.ru.md` is the documentation exception.

## Usage

```bash
bash /path/to/install.sh
bash /path/to/install.sh --branch main
bash /path/to/install.sh --tag v0.0.1
bash /path/to/install.sh --help
```

## Acceptance criteria and verification

Verify source selection, valid metadata and timestamps, same-revision installed files, legacy metadata-only behavior, preservation of user files/root instructions, repeat-install rejection, dependencies, unsafe destinations, and retrieval failures. Verify Bash 3.2 and paths containing spaces. Syntax check:

```bash
bash -n scripts/install.sh
bash -n scripts/update.sh
bash -n scripts/apply-update.sh
```

Installation and update behavior was verified in disposable projects on macOS with Bash 3.2 on 2026-11-14. Live GitHub tests passed for the exact README installation command selecting published `v0.0.2`, explicit tag/branch installation, and migration from published `v0.0.1`. See [update verification](update.md#verification) for details and remaining platform coverage.
