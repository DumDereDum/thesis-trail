# ThesisTrail updates

## Responsibilities and commands

The installed `.tt/update.sh` discovers and downloads releases. The downloaded release's `scripts/apply-update.sh` knows how to install that release and migrate supported older installations. Old launchers do not contain future migration rules. Checks must never execute downloaded scripts.

Run from the project directory, or invoke the installed launcher by path from another directory:

```bash
bash .tt/update.sh --check
bash .tt/update.sh --check --now
bash .tt/update.sh --apply --tag v0.0.2
bash .tt/update.sh --dismiss --tag v0.0.2
```

- No arguments means `--check`. Checks attempt remote retrieval at most once per 24 hours; `--now` bypasses the interval for an explicit check.
- Record attempt time before retrieval to limit retries after network errors; successful check time is separate.
- Checks may write `.tt/update-state` (Git config format), but never installation metadata, scripts, or project instructions.
- `--apply` requires an exact numeric `vX.Y.Z` tag. This command is an explicit CLI request to apply; agents obtain approval before issuing it.
- `--dismiss` records a refused/deferred tag. Automatic checks do not offer it again; another tag or an explicit user request can still be considered.
- Exit `0` for successful/skipped checks, dismissals, applications, and an already-installed release; nonzero for errors. A failed check does not mean the installation is current.
- No background service, timer, automatic application, or package manager is installed.

## Discovery and change descriptions

Use the canonical repository and the installer's numeric tag pattern, `creatordate` ordering, and ref-name tie-break. Show current reference/commit and candidate tag/commit. The same tag pointing to another commit is a moved tag: stop with an error. Never silently substitute a branch or tag. Branch installations can explicitly move to a release; the agent describes this switch before consent.

Read `CHANGELOG.md` from the exact target revision. Show sections preceding the installed tag's heading, including an `Unreleased` section from that snapshot when present. Missing notes are reported, never invented. Maintainers should rename `Unreleased` to the release tag before publishing.

After success, print the source/target references and change notes. The agent briefly summarizes actual changes and required follow-up steps. Failures must not be described as successful updates.

## Stable applier protocol: version 1

Participating releases contain regular files:

```text
scripts/update.sh
scripts/apply-update.sh
instructions/agent-rules.md
CHANGELOG.md
```

The launcher exports the exact fetched commit to a temporary directory, then invokes:

```bash
bash RELEASE/scripts/apply-update.sh \
  --project ABSOLUTE_PROJECT_PATH \
  --from-version INSTALLED_VERSION \
  --tag vX.Y.Z \
  --commit FULL_TARGET_COMMIT
```

`INSTALLED_VERSION` is the version without `v`, `branch` for a branch installation, or `none` for initial installation. An initial branch installation passes `--branch NAME` instead of `--tag`. New initial installations use this same applier.

The applier validates arguments, metadata, and supported source versions before applying. The initial implementation supports metadata schema 1, including original `v0.0.1` installations. Future releases own their compatibility checks/migrations. Preserve this launcher-facing interface and readable common metadata fields, or require an explicit intermediate upgrade.

## Managed files and transactions

Updates manage only these destinations:

```text
.tt/update.sh
.tt/agent-rules.md
.tt/instructions/ (for releases implementing the thematic layout)
.tt/CHANGELOG.md
.tt/thesis-trail.json
the marked ThesisTrail section of AGENTS.md
```

Managed kit files are replaced; users keep their own instructions outside them and the marked block. Preserve unrelated files and unknown JSON metadata fields, including nested values. Preserve `installed_at`; change version/reference, commit, and `updated_at` only after successful application. Do not add a `status` field.

The [thematic layout](instructions.md) keeps `.tt/agent-rules.md` as a forwarding entry and delivers all modules under `.tt/instructions/`. Its applier records `instructions_layout: 1`, rejects unrelated legacy directory collisions, and replaces the managed tree in full as part of the transaction. Removed modules do not remain active after an update. The stable launcher-facing protocol is unchanged.

The student-owned `docs/topic.md` described in the [student workflow](student-workflow.md) is outside the update-managed set. Initial installation can archive it under the [project setup protocol](project-setup.md), which also creates `.tt/setup-state` and adds a backup exclusion to `.gitignore`. Updates must leave topic cards, snapshots, setup state, and ignore files untouched. Updating the agent rules and root hook must not trigger initial archival or print the first-installation onboarding prompt.

The [material library](material-library.md) originals, catalog, mirrored document cards, and selected root are also student-owned. Delivering new library instructions does not authorize moving documents, regenerating summaries, or changing ignore rules during an update; those actions belong to requested preparation or document work.

Reject unsafe paths, malformed metadata, unsupported schemas, and malformed/duplicate root instruction markers. `.tt/.update-lock` excludes concurrent checks/applications. A stale lock after an unhandled termination requires manual inspection/removal.

Prepare files and backups before replacement; rename staged files into place, metadata last. Restore originals after an ordinary failure or handled signal. This is not a cross-file atomic transaction or power-loss recovery. If restoration fails, retain backups and report their path. Clean up temporary releases and successful transaction backups.

The standalone launcher includes its JSON reader and does not depend on another installed library. JSON is data, never shell code. Dependencies are the same as the installer.

## Agent instructions

A marked root `AGENTS.md` block links to `.tt/agent-rules.md`. Preserve existing instructions and update only that block. Clients that do not read `AGENTS.md` require separate configuration; installing these files does not create a background agent.

Rules for the agent:

1. At the start of work on the project, run the interval-limited check. Do not check on every message or repeatedly retry an outage.
2. Explain an available non-dismissed tag, the current/candidate versions, and supplied change notes.
3. Ask whether to apply that exact tag. A general request to work on the project is not approval to update ThesisTrail.
4. On refusal/deferral, dismiss the tag. On approval, issue the exact `--apply --tag` command.
5. After success, summarize the version change and actual changes. On failure, report it and continue the user's task where possible.

## Bootstrapping v0.0.1

The immutable `v0.0.1` release contains neither updater nor agent hook. Do not mix files from `main` into that old release during installation. After publishing a release that contains this protocol, migrate a metadata-only project by downloading the launcher from `main` and explicitly applying the desired tag from that project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/DumDereDum/thesis-trail/main/scripts/update.sh \
  -o /tmp/thesis-trail-update.sh
bash /tmp/thesis-trail-update.sh --apply --tag v0.0.2
```

Use the actual published target tag. This is a one-time bootstrap; later updates use `.tt/update.sh`.

## Acceptance criteria

Verify in disposable projects: initial protocol installation; migration from `v0.0.1`; 24-hour checks and forced checks; refusal; missing/moved tags; network failure; checks never executing an applier; applications invoking the target release's applier; unknown metadata/root instruction preservation; same-version no-op; symlink and lock rejection; rollback after replacement failure; standard-input bootstrap; Bash 3.2; paths containing spaces; invocation from outside the project directory.

## Verification

Verified on 2026-11-14 on macOS with Bash 3.2.57, using disposable Git sources and student projects outside the repository:

- Initial tag/branch installation, default chronological tag selection and equal-date tie-break, stdin bootstrap, and repeat-install rejection.
- A newer release's applier adding a migration field unknown to the installed launcher.
- Preservation of nested unknown JSON values, metadata permissions, original installation time, root instructions, and student documents.
- Check/application separation, the 24-hour interval, explicit checks, deferred tags, missing/moved tags, and failed-network retry throttling.
- Same-release no-op, unsupported-schema/lock/symlink/marker/conflict rejection, and restoration of file contents and modification times after injected kit-file and final-metadata replacement failures.
- Invocation by path from outside the project and by filename from inside `.tt/`.

After `v0.0.2` was published, a live GitHub run passed all seven scenarios and 87 assertions using the published scripts and releases:

- The exact README pipeline selected `v0.0.2` at `a365bff3629077e2b40687d889cc8710cb568278`; installed kit files matched that tag byte for byte. Repeated installation was rejected without changing file contents, permissions, or modification times.
- A metadata-only `v0.0.1` installation at `481adfe3fde49489edf590019da0c46ff615254b` discovered `v0.0.2`, respected the 24-hour interval and deferral, and migrated successfully using the launcher downloaded through standard input. Checks left installation files unchanged.
- Migration preserved student documents, unrelated `.tt/` files, existing root instructions, nested unknown metadata including Unicode, metadata permissions, and `installed_at`; it advanced `updated_at` and installed exactly one root instruction block.
- Explicit `v0.0.2` and `main` installations, branch-to-release application, same-release no-op, and launcher invocation from outside the project and from inside `.tt/` passed.
- Invalid arguments, a missing release, an existing lock, malformed metadata, metadata symlinks, and a mismatched installed commit for the same tag were rejected without changing installation files.
- An injected Git fetch failure recorded the attempt without changing the last successful check time or installation; the next automatic check was throttled.
- Injected kit-file and final-metadata replacement failures in the fetched release's applier restored file contents, permissions, and modification times. Temporary releases, transactions, and acquired locks were cleaned up.

No newer published release was available to test a future upgrade from `v0.0.2`. Linux execution remains unverified because the Docker daemon was unavailable.
