# ThesisTrail

**ENG** | [RUS](README.ru.md)

AI-agent instructions to help students prepare and defend coursework and theses, and help supervisors review the work and prepare questions.

## Installation

Run in your project directory. Requires Bash, Git, and curl. The command selects the most recent version tag by date.

```bash
curl -fsSL https://raw.githubusercontent.com/DumDereDum/thesis-trail/main/scripts/install.sh | bash
```

[Installation details](docs/install.md). The agent checks for updates at most once per day and asks before applying them.

## After installation: student workflow

1. Open the project in an AI agent that reads `AGENTS.md`.
2. Send one of these messages:

   - **The project already had files:** "Prepare the project from the backup."
   - **The project was empty:** "Let's start working on my coursework."

3. The agent restores materials, asks for missing information, and creates or updates `docs/topic.md`.

**Topic card:** Russian and English titles, work type, study year and degree level, field of study, and a short description. Unknown fields can remain unspecified; suggested translations stay provisional until accepted.

**Backup:** existing files temporarily move to `.tt/backups/project-…/`. The agent must restore them to working locations and verify the result. The backup does not accompany a Git clone; remove it only on your explicit request after verification.

Continue with "Review my introduction" or "Update the approved topic title." Preparation does not repeat, and your documents survive updates.

Installation does not start an agent. If your client does not read `AGENTS.md`, configure it to read `.tt/agent-rules.md`. [Topic workflow](instructions/research/topic.md) · [Backup preparation](instructions/maintenance/project-setup.md).

## Reference materials

The agent organizes originals and creates a catalog with document cards:

```text
materials/                         # Local originals
├── articles/                      # Research papers
├── books/                         # Books and chapters
├── regulations/                   # Normative documents
├── guidelines/                    # Methodological guidance
└── other/                         # Other sources
docs/
├── materials.md                   # Shared catalog
└── materials/
    └── articles/example.pdf.md    # Card for materials/articles/example.pdf
```

Originals are ignored by Git; the catalog and cards are tracked. After cloning, supply originals again or retrieve them using recorded links.

**Document cards:** contents, relevance, source, version, and pages actually inspected. Unread documents are marked explicitly; for quotations and document-grounded answers, the agent checks the original.

If `materials/` contains code or project assets, the agent preserves it and uses an available `research-materials/` for sources. At session start, it reports new or missing library files; resolving differences requires your instruction.

You can request a search:

> Use my topic to find five relevant articles, download them, and fill their cards and catalog.

Your agent client needs search and download tools. The agent verifies sources and reports what it found and actually saved.

[Library and search instructions](instructions/research/materials.md).

## Instruction structure

The [entry point](instructions/agent-rules.md) selects modules relevant to the task:

```text
instructions/
├── agent-rules.md             # Entry point and instruction selection
├── general/                   # General project practices
│   ├── git.md                 # Branches, commits, and publication
│   ├── reproducibility.md     # Setup and repeatable experiments
│   └── documentation.md       # README and documentation
├── research/                  # Research work
│   ├── topic.md               # Topic and major decisions
│   └── materials.md           # Sources and document cards
├── maintenance/               # ThesisTrail maintenance
│   ├── project-setup.md       # Project preparation from a backup
│   └── updates.md             # Updates
└── domains/                   # Subject areas
    └── README.md              # Domain instruction catalog
```

Subject directories, such as `domains/ml/`, are added as instructions become available. [How to add an area](docs/instructions.md#adding-domain-instructions).

In a student's project, instructions live in `.tt/`, linked from a marked block in `AGENTS.md`. `.tt/.gitignore` excludes backups and local state while keeping instructions available to Git. This repository's `docs/` contains ThesisTrail development specifications and is not installed into student projects.
