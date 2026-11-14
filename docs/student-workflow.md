# Student workflow and topic card

## Scope

ThesisTrail connects an AI agent to a small, persistent topic card for coursework or a thesis. Installation supplies instructions; the student starts the conversation in their agent client. No agent runs automatically, and there are no special chat commands. When first installing into a nonempty project, [initial project setup](project-setup.md) archives materials and records pending setup in `.tt/setup-state`.

Clients must read the root `AGENTS.md` and its linked `.tt/agent-rules.md`, or the student must configure their client to read those instructions. Release checks and explicit update consent continue to follow [the update specification](update.md).

## Files and ownership

- `.tt/agent-rules.md` contains the student workflow and an inline topic-card template, alongside maintenance instructions. There is no separately installed template file.
- `docs/topic.md` is the default student-owned topic card. First installation archives an existing card with the other materials, without changing its contents; the agent restores it during initial setup. The installer and release applier do not create a new card. Updates leave cards at their working paths untouched.
- The agent creates the card during a student-requested topic discussion and updates it as part of the student's task. Existing documents and custom fields are preserved. If the project already identifies an equivalent card elsewhere, use that location without creating a duplicate; if the location or file purpose is ambiguous, clarify before writing.
- Do not follow a symlink or replace a directory, unreadable file, or unrelated document at the intended card path. Continue the student's task and clarify a suitable location.

This repository's `docs/` contains product specifications, not a student's topic card. Merely working on ThesisTrail does not start student onboarding.

## Topic-card content

Keep six fields:

| Field | Purpose |
| --- | --- |
| Russian title | The Russian topic wording |
| English title | A consistent English wording; a suggested translation remains provisional until accepted |
| Work type | Coursework or thesis, using the student's terminology |
| Study year and degree level | For example, third-year bachelor's student |
| Field of study | The academic context supplied by the student or their materials |
| Short description | Two to four sentences describing the intended work and result |

The installed instructions provide an English template. Write the student's card in their language, retaining both Russian and English title fields. These generated student documents are not repository source files. Unknown values are explicitly marked as not yet specified in the student's language; a partial card is valid. Do not infer the study year, degree level, field of study, supervisor approval, or substantive project scope from a title alone. Goals, tasks, hypotheses, deadlines, and progress tracking are outside this initial card's required structure.

## Conversation behavior

Before normal topic onboarding, follow pending [project setup](project-setup.md), if recorded. Restore existing materials and reuse their context before asking for information or creating a duplicate card. A completed setup does not repeat on later sessions or releases.

### First discussion without a card

1. Recognize a request to start, formulate, or organize the student's work. Use the current message and relevant materials already supplied before asking questions.
2. Ask only a few missing questions at a time. An incomplete card must not prevent useful work or force a questionnaire before an unrelated concrete request, such as reviewing an introduction.
3. Help with title wording, an English translation, and a short description. Label suggestions and provisional translations clearly. Do not invent facts, requirements, supervisor decisions, sources, or results.
4. When the topic discussion provides useful content, create `docs/topic.md` with the known fields and explicit unknowns. A request to organize the topic authorizes this ordinary document edit; no separate installation approval or full-card confirmation is required. If the student only requests discussion or asks not to save, keep suggestions in the conversation.
5. Briefly report the saved path and suggest one relevant next step. Do not imply that saving the card means supervisor approval.

### Existing card

Read the card at the start of substantive student work. Use its context instead of asking for known information again; do not reread or restart onboarding on every message. Work on the student's requested task. Preserve useful existing content and do not normalize or rewrite the card merely because its formatting differs from the template.

### Changes to the topic

Update relevant fields after the student accepts a change or reports a new decision, including a supervisor's decision. An alternative merely proposed by the agent is not a replacement for the current wording. If a new message conflicts with the card without clearly accepting a change, clarify the discrepancy. When the Russian title changes, review the English wording and description for consistency; do not replace an explicitly approved translation with an unapproved one. Briefly state what changed.

## Initial-installation handoff

After a successful initial protocol installation, print an English next-step message directing the student to open the project in an AI agent that reads `AGENTS.md`. For an archived project, show the backup location and ask the student to request preparation of the project from the backup. For an empty project, ask them to start coursework or a thesis and explain that the agent will help create `docs/topic.md` during the conversation. Do not show first-install onboarding after an update, a same-release no-op, or a failed application. Published `v0.0.1` and `v0.0.2` retain their original behavior.

## Acceptance criteria

Technical checks in disposable projects must verify:

- Installation supplies the workflow instructions and a root hook covering both the student workflow and release/update consent.
- Initial installation prints the handoff but creates no `docs/` or card.
- Installing into a project with a card archives it with its bytes, permissions, and modification time preserved, along with other project materials. Original root instructions remain active in the regenerated root hook file.
- Updating a `v0.0.2` installation replaces its maintenance-only instructions and hook with the new workflow while preserving the card, original installation time, and unknown metadata fields. The update does not print initial onboarding.
- Syntax remains compatible with Bash 3.2 and paths containing spaces; failures and same-release no-ops do not print onboarding.

Review the installed instructions against these four conversation scenarios. These are manual agent acceptance scenarios, not assertions that shell tests prove agent behavior:

| Scenario | Example student message | Expected behavior |
| --- | --- | --- |
| New project | "Help me start my coursework about equipment tracking." | Use the supplied idea; ask a few missing questions, help formulate the topic, and save known details when appropriate. |
| Partial information | "Third-year bachelor's student in software engineering; I want an equipment tracking system. Let's organize the topic." | Reuse the supplied context; offer provisional wording and translation, keep unknowns explicit, and do not require all fields before saving. |
| Existing card | "Review my introduction." | Read the card and supplied introduction, review the text, and do not repeat onboarding or silently rewrite the topic. |
| Accepted change | "My supervisor approved the new title: Equipment Tracking for University Laboratories. Update the card." | Update the relevant wording, review bilingual consistency, preserve unrelated content, and distinguish reported approval from proposed translations. |

## Verification

On 2026-11-14, installation and update handling passed six disposable-project checks on macOS with Bash 3.2.57, including topic-card preservation and the initial-installation handoff. The checks used the real installer, the `v0.0.2` launcher, and the current applier against local Git fixtures; no production refs were changed. The temporary test harness is not included in the repository. Individual Bash syntax checks and `git diff --check` also passed.

That run preceded initial archival. Verification of the current backup-and-restore handoff is recorded in [project setup verification](project-setup.md#verification).

The four conversation scenarios above were reviewed against the instructions. File-handling checks do not establish an AI client's conversational behavior; a student pilot in an actual client remains a separate manual check. Linux execution remains unverified.
