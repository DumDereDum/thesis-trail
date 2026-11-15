# Git instructions for student projects

## When to apply

Use these instructions when working with a student's Git repository, preparing a commit, or publishing changes. Apply them to the current task without repeating a checklist on every message. Repository and course requirements provide additional context; clarify a conflicting rule before taking the affected action.

## Agreed requirements

### Branches

- Use a separate task branch for a substantive task, with a short, descriptive name such as `document-search` or `fix-data-import`.
- Keep related small changes on the same task branch. Do not require a new branch for every file or minor edit.
- Inspect the current branch and working changes before switching. Reuse an existing branch for the same task; preserve unrelated work.

### Commits

- Create commits only when the student explicitly requests them. A request to implement or fix something does not by itself authorize a commit.
- After a completed, appropriately checked step, the agent may suggest making a commit without making one automatically.
- An explicit request covering several commits remains valid within its stated scope; do not ask again for each covered commit.

### Publication

- Push changes only on the student's explicit request. Permission to commit does not authorize a push.
- Treat pushing a branch, creating a pull request, and merging as separate actions. Carry out only those requested; a request may explicitly cover several actions at once.
- Before publishing, verify the intended repository and branch. Do not silently add publication or merging to a local development task.

## Additional recommendations

### Commit contents and messages

- Prefer a small, coherent commit that a reviewer can understand and, if necessary, revert independently. Include related code, documentation, and checks together; separate unrelated changes.
- Stage the relevant paths or changes deliberately. Review the staged diff so existing student changes are not accidentally included or attributed to the current task.
- Write a short message describing the concrete change, such as `Handle missing dates during import`, rather than `Updates`. Follow an existing project convention; no particular commit-message format is required here.
- Keep credentials, local configuration containing secrets, temporary output, and dependency caches out of commits. Provide a configuration example with placeholders when useful.
- Respect the project's data and reference-library policy. Inspect a directory's purpose before ignoring it, preserve existing ignore rules, and remember that adding an ignore rule does not remove an already tracked file from Git.

### Checks before a commit

- Inspect the working tree and staged changes. Verify that the commit contains the intended task and no unrelated files or accidental removals.
- Run checks appropriate to the change: for example, a relevant test or a build for a code change, and a content/link review for documentation. Match the checks to the impact; do not add tests just to accompany a minor edit.
- Report checks that failed or could not be run. Do not describe unverified behavior as working or a commit as proof that the task is correct.

### Existing work and history

- Preserve student and collaborator changes. Do not discard, overwrite, stage, or stash unrelated work just to obtain a clean working tree.
- Prefer an ordinary corrective commit for changes already shared. Do not rewrite history, amend an existing commit, discard work, delete branches, or force-push as an unrequested cleanup step.
- If the task actually requires such an operation, establish its target and consequences with the student before acting. An existing explicit request for that operation remains valid within its scope.
- Resolve conflicts using the intended behavior and both sides' changes. Ask about substantive ambiguity instead of choosing one side mechanically.

## How to verify and report

Before a commit, `git status --short --branch`, `git diff`, and `git diff --cached` help identify the branch, working changes, and exact staged contents. `git diff --cached --check` checks whitespace issues in staged changes; it does not replace functional checks.

After a commit, report its identifier and purpose, relevant check results, and any remaining changes. State whether changes were published; a local commit is not a remote backup. Report a push, pull request, or merge as completed only after confirming its result.

Review agent behavior against these scenarios:

| Student request | Expected behavior |
| --- | --- |
| "Implement document search." | Use a task branch for the substantive task, make and check changes, and optionally suggest a commit. Do not commit or publish automatically. |
| "Also fix this typo in the same task." | Keep the related small change on the task branch; do not create a branch for the individual edit. |
| "Commit the search changes." | Inspect and stage only the relevant changes, run appropriate checks, create the commit, and report it without pushing. |
| "Push this branch." | Verify the destination and push the requested branch. Do not create a pull request or merge automatically. |
| "Push this branch and open a pull request." | Perform both explicitly requested actions and report their actual results. Do not merge automatically. |
| Unrelated local changes are present | Preserve them and keep them outside the task's commit; clarify only if they prevent safe progress. |

These scenarios are review criteria for the guidance, not evidence of a completed agent-client test.
