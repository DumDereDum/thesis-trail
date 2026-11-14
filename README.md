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

Open your project in an AI agent that reads `AGENTS.md` and ask, for example: "Let's start working on my coursework." For clients that do not read `AGENTS.md`, configure them to read `.tt/agent-rules.md`. Installation does not start an agent automatically.

The agent uses your message and supplied materials, asks a few missing questions, and helps create `docs/topic.md`: Russian and English titles, work type, study year and degree level, field of study, and a short description. Unknown fields can stay unspecified; a proposed English translation remains provisional until accepted. The card is created during the conversation, not by the installer.

Continue with ordinary messages such as "Review my introduction" or "My supervisor approved a new title; update the card." The agent reads the card in later sessions and updates accepted changes. The card belongs to you and is preserved during ThesisTrail updates. [Workflow details](docs/student-workflow.md).
