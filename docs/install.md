# ThesisTrail installer

Status: requirements for the initial implementation. Open decisions are listed below. The installer has not been implemented yet.

## Purpose and scope

`scripts/install.sh` retrieves ThesisTrail from GitHub and initializes its metadata in the user's project on macOS and Linux. The source repository is `https://github.com/DumDereDum/thesis-trail`.

This iteration creates only `.tt/thesis-trail.json`. It does not install the repository snapshot, skills, templates, or scripts in the project, and does not create learning documents or client-specific directories. Rules for installing those files will be specified separately.

Only the Bash installer is in scope. A Windows installer is deferred.

## Agreed requirements

### Source and version selection

- Retrieve the selected source from the remote Git repository. A local checkout is not an installation source in this iteration.
- With no arguments, select the most recent tag by date among tags matching `vX.Y.Z`, where each component is numeric. Do not select by the greatest version number or apply an additional stability classification.
- The exact Git date used to compare tags remains an open decision.
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

- On the first successful run, `installed_at` and `updated_at` are equal. Preserve `installed_at` on updates.
- Do not include a `status` field.
- Write the completed metadata only after successful retrieval and source resolution. A failed attempt must not record a new successful update time.

### Existing installation

- If an installation already exists, offer to update it and request confirmation before applying the update.
- An update requires the user's consent.
- The behavior without an interactive terminal remains an open decision.

### Dependencies and language

- Require Bash, Git, and a minimal set of standard system utilities.
- Do not require Python, Node.js, `jq`, or package managers to run the installer.
- Do not install dependencies automatically.
- Check required utilities before changing files in the user's project.
- Use English for installer messages and repository content, except `README.ru.md`.

## Proposed edge-case behavior

These implementation proposals have not yet been explicitly agreed:

- Treat `--branch` and `--tag` as mutually exclusive. Report unknown arguments or missing values and exit with a nonzero code.
- If a selected tag or branch is missing, fail without selecting a different source.
- If no matching tags exist, fail without falling back to `main`.
- On a network error, fail without substituting a local checkout.
- If the selected source and commit already match the recorded installation, report that it is current and leave the JSON unchanged.
- Preserve unrelated project files and any additional metadata fields introduced in future iterations.

## Acceptance criteria

After resolving the open decisions, verify that:

1. A run without arguments selects the most recent matching tag by the agreed date rule, even when another tag has a greater version number.
2. Explicit selection of `main`, another branch, or a tag resolves the requested remote source.
3. `.tt/thesis-trail.json` is valid JSON with the agreed fields, matching version and commit values, and no `status` field.
4. `.tt/` contains only `thesis-trail.json` after a first successful run; no client directories, learning documents, or repository snapshot are installed.
5. The installer works on macOS and Linux, including destination paths containing spaces, with the agreed dependencies.
6. Missing dependencies are detected before project files are changed.
7. Existing installations trigger an update offer; declining leaves the metadata unchanged. An accepted update preserves `installed_at` and records the new source and `updated_at`.
8. Invalid arguments, missing sources, network failures, and noninteractive runs follow the agreed rules.

## Open decisions

1. Tag dates: proposed use of Git's `creatordate`, which uses the tagger date for annotated tags and the committer date for lightweight tags. See the [Git reference](https://git-scm.com/docs/git-for-each-ref).
2. Noninteractive updates: proposed refusal to update without confirmation, with an explicit `--yes` option to grant consent for automated runs.
