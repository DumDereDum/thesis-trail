# Working on ThesisTrail

## Language

- Use English for repository content, including documentation, code comments, and script messages. `README.ru.md` is the Russian-language exception.

## Branches

- Create a new task branch before making commits. Never commit directly to `main` or push `main`.
- Keep subsequent commits for the same task on its task branch. Publish a branch only when requested.

## Specification-driven development (SDD)

- Keep requirements and acceptance criteria in `docs/`.
- Describe expected behavior in the relevant specification before implementing it. Update the specification when behavior changes.
- Distinguish agreed requirements from proposals and open questions.
- Implement according to the specification and verify against its acceptance criteria.

## Installer

- Keep external dependencies in `scripts/install.sh` to a minimum.
- Use Bash, Git, and standard system utilities. Prefer simple solutions with fewer dependencies.
- Do not require Python, Node.js, `jq`, or package managers to run the installer.
- Do not install dependencies automatically.
- Document required external utilities and check for them before changing files in the user's project.
- Support macOS and Linux, accounting for differences between their standard utilities.
