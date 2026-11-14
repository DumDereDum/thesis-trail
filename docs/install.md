# ThesisTrail installer

Status: initial implementation available in `scripts/install.sh`. Branch installation is covered by local integration tests. Successful tag installation and chronological tag selection will be tested after the first version tag is published; tests do not create tags.

## Purpose and scope

`scripts/install.sh` retrieves ThesisTrail from GitHub and initializes its metadata in the user's project on macOS and Linux. The source repository is `https://github.com/DumDereDum/thesis-trail`.

This iteration creates only `.tt/thesis-trail.json`. It does not install the repository snapshot, skills, templates, or scripts in the project, and does not create learning documents or client-specific directories. Rules for installing those files will be specified separately.

Only initial installation through the Bash installer is in scope. Updates, automatic update checks, and a Windows installer are deferred.

## Agreed requirements

### Source and version selection

- Retrieve the selected source from the remote Git repository. A local checkout is not an installation source in this iteration.
- With no arguments, select the most recent tag by date among tags matching `vX.Y.Z`, where each component is numeric. Do not select by the greatest version number or apply an additional stability classification.
- Compare tags using Git's `creatordate`: the tagger date for annotated tags and the committer date for lightweight tags. See the [Git reference](https://git-scm.com/docs/git-for-each-ref).
- `--branch main` selects `main`; `--branch <name>` selects another branch.
- `--tag <tag>` selects an explicit tag.
- For a tag installation, derive the version from the tag name: `v0.1.0` produces `version: "0.1.0"`.
- For a branch installation, `version` and `tag` are `null`. Record the branch name and full commit SHA.

### Project directory and metadata

- The current working directory is the destination project, regardless of where the installer script is stored.
- Create the project's `.tt/` directory at the beginning of installation, after dependency checks.
- Store metadata in `.tt/thesis-trail.json`. This is the only file created in `.tt/` by this iteration.
- The JSON file is intended for broader ThesisTrail project information, not just installation data. Additional information may be specified later.
- Retrieve remote sources in a temporary location rather than storing a repository checkout in `.tt/`.
- Record the following fields:

| Field | Meaning |
| --- | --- |
| `schema_version` | JSON format version, initially `1` |
| `repository` | Source repository URL |
| `version` | Version derived from the selected tag; `null` for a branch installation |
| `tag` | Selected tag; `null` for a branch installation |
| `branch` | Selected branch; `null` for a tag installation |
| `commit` | Full SHA of the selected commit |
| `installed_at` | First successful initialization time, UTC in ISO 8601 format |
| `updated_at` | Most recent successful initialization or update time, UTC in ISO 8601 format |

- On the first successful run, `installed_at` and `updated_at` are equal. Future update behavior will be specified separately.
- Do not include a `status` field.
- Write the completed metadata only after successful retrieval and source resolution. A failed attempt must not record a new successful update time.

### Existing installation

- If `.tt/thesis-trail.json` already exists, stop with a clear message without modifying it or other project files.
- Do not offer or apply updates in this iteration, whether the run is interactive or noninteractive.
- Do not implement `--yes`, `--update`, or a force-overwrite option.

### Dependencies and language

- Require Bash 3.2 or newer, Git, and these standard system utilities: `mktemp`, `mkdir`, `rm`, `date`, and `ln`.
- The README download command also requires `curl`; the installer itself does not use it.
- Do not require Python, Node.js, `jq`, or package managers to run the installer.
- Do not install dependencies automatically.
- Check required utilities before changing files in the user's project.
- Use English for installer messages and repository content, except `README.ru.md`.

## Usage

Run the script from the destination project directory. The following examples assume the script is stored at `/path/to/install.sh`:

```bash
bash /path/to/install.sh                     # Most recent vX.Y.Z tag by date
bash /path/to/install.sh --branch main       # Remote main branch
bash /path/to/install.sh --branch init-work  # Remote development branch
bash /path/to/install.sh --tag v0.1.0         # Explicit version tag
bash /path/to/install.sh --help              # Usage information
```

For the download-and-run command in the README, the URL selects the installer script, while `--branch init-work` selects the source recorded in the project's metadata. The development command is temporary until the first version tag is available.

## Edge-case behavior

- Treat `--branch` and `--tag` as mutually exclusive. Report unknown arguments or missing values and exit with a nonzero code.
- Reject repeated selectors and invalid Git branch names. Explicit tags must match `vX.Y.Z`.
- If a selected tag or branch is missing, fail without selecting a different source.
- If no matching tags exist, fail without falling back to `main`.
- If tag dates are equal, select the first tag in Git's ascending ref-name order.
- On a network error, fail without substituting a local checkout.
- Preserve unrelated project files. An existing metadata file is left untouched regardless of its contents.
- Reject a symbolic link or a regular file at `.tt/` rather than writing through it.
- Check arguments, dependencies, and an existing metadata path before creating `.tt/`. Errors after retrieval begins may leave an empty `.tt/` directory; no completed metadata is written.
- Remove temporary Git data and temporary JSON files on exit. Publish the completed JSON through a hard link in `.tt/` so an existing metadata file is not overwritten.
- Return `0` on successful initialization or help, and a nonzero exit code on an error or an existing installation. Updates are not supported.

## Acceptance criteria

Verify that:

1. A run without arguments selects the most recent matching tag by the agreed date rule, even when another tag has a greater version number.
2. Explicit selection of `main`, another branch, or a tag resolves the requested remote source.
3. `.tt/thesis-trail.json` is valid JSON with the agreed fields, matching version and commit values, and no `status` field.
4. `.tt/` contains only `thesis-trail.json` after a first successful run; no client directories, learning documents, or repository snapshot are installed.
5. The installer works on macOS and Linux, including destination paths containing spaces, with the agreed dependencies.
6. Missing dependencies are detected before project files are changed.
7. An existing `.tt/thesis-trail.json` stops installation without prompting or changing any project files, in both interactive and noninteractive runs.
8. Invalid arguments, missing sources, and retrieval failures follow the specified edge-case rules.
9. No update, automatic update check, confirmation bypass, or force-overwrite mode is implemented.

## Verification

```bash
bash -n scripts/install.sh
python3 tests/test_install.py
```

Python 3 is used only by the development test runner, not by the installer. The runner preserves test projects and logs in a new run directory under `../thesis-trail-install-tests/`; use `--work-dir PATH` to choose another parent directory.

Tests redirect the installer's production Git URL to an isolated bare Git source through a temporary Git configuration. They do not change the user's Git configuration, create tags, or add a local-source option to the installer. They cover `main`, `init-work`, a branch name requiring JSON escaping, paths with spaces, standard-input execution, repeated installation, invalid arguments, missing Git, missing branches, an unavailable source, an existing invalid JSON file, symbolic links, help, and the absence of version tags.

These tests exercise Git retrieval locally; they do not prove GitHub connectivity or the README download URL. The current run was verified on macOS with Bash 3.2. Linux execution and successful tag selection remain to be verified.

## Future update direction

The proposed design is a separate updater rather than an installer flag. Its source would live in `scripts/update.sh` in this repository, and a future installer would place it at `.tt/update.sh` in the user's project. The updater would use `.tt/thesis-trail.json` to identify the current installation.

Automatic checks and applying updates are separate operations: checking may be automatic, while applying an update requires user consent. Exact behavior and installed file rules will be specified when update work begins.

This direction does not add an updater or any other installed file to the current iteration.
