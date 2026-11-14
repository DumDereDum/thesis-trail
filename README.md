# ThesisTrail

**ENG** | [RUS](README.ru.md)

AI instructions and templates to help students plan, review, and defend coursework and theses, and help supervisors review the work and prepare questions.

## Installation

Run in your project directory to install the most recent version tag by date. Requires Bash, Git, and curl.

```bash
curl -fsSL https://raw.githubusercontent.com/DumDereDum/thesis-trail/main/scripts/install.sh | bash
```

[Installation details](docs/install.md).

Agents using the installed instructions check for releases at most once per day and ask before applying an update. [Update details](docs/update.md).

## After installation: student workflow

The topic-card workflow is unreleased and is not included in `v0.0.2`.

For releases with [initial project setup](docs/project-setup.md), first installation moves existing materials into a unique `.backup/project-.../`. It leaves `.git`, `.tt`, and older backups in place, preserves root instructions, and adds `/.backup/` to `.gitignore`. Your original files remain in the snapshot until the agent copies them back. Updates never repeat this archival step.

Open your project in an AI agent that reads `AGENTS.md` and ask: "Prepare the project from the backup." The agent studies the original materials, restores their existing structure, and adds the topic card according to the project requirements. The snapshot is retained. If the project was empty, ask instead: "Let's start working on my coursework." For clients that do not read `AGENTS.md`, configure them to read `.tt/agent-rules.md`. Installation does not start an agent automatically.

The agent uses your message and supplied materials, asks a few missing questions, and helps create `docs/topic.md`: Russian and English titles, work type, study year and degree level, field of study, and a short description. Unknown fields can stay unspecified; a proposed English translation remains provisional until accepted. The card is created during the conversation, not by the installer.

Continue with ordinary messages such as "Review my introduction" or "My supervisor approved a new title; update the card." Completed preparation does not repeat in later sessions. The agent reads the card and updates accepted changes. The card belongs to you and is preserved during ThesisTrail updates. [Workflow details](docs/student-workflow.md).

## Reference materials

The material-library workflow is also unreleased. Keep reference originals in `materials/`, categorized as `articles/`, `books/`, `regulations/`, `guidelines/`, and `other/`. The agent creates a compact `docs/materials.md` catalog and mirrored cards: `materials/articles/example.pdf` corresponds to `docs/materials/articles/example.pdf.md`. Cards describe contents, use, known source/version, and inspected pages; unread documents are marked explicitly. Originals are ignored by Git, while Markdown metadata remains available in the repository. Missing originals must be supplied again after cloning or located using known source links.

During preparation from `.backup/`, the agent checks the original directory's purpose first. If `materials/` already holds code or rendering assets, it restores that directory at its old path and uses an available `research-materials/` for reference documents. Only the actual reference-library root is ignored; its location is recorded in the catalog. For questions and quotations, the agent checks the relevant original rather than relying solely on a card. [Library and conflict-handling details](docs/material-library.md).
