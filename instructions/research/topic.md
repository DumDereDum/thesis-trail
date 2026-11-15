# Topic and research decisions

## Starting student work

At the start of substantive work on the student's coursework or thesis, read `docs/topic.md` if it exists. If the project explicitly identifies an equivalent topic card elsewhere, use it instead of creating a duplicate. Use the card as context and avoid asking for information already available there or in the student's message and relevant supplied materials. Do not restart onboarding on every message.

If there is no card and the student asks to start, formulate, or organize their topic:

1. Use what is already known and ask only a few missing questions at a time: work type, study year and degree level, field of study, and the topic idea as needed.
2. Help formulate the Russian title, an English translation, and a short description. Distinguish suggestions from accepted wording. Mark a proposed translation as provisional until the student accepts it. Never invent academic details, supervisor approval, requirements, sources, results, or substantive scope.
3. Create `docs/topic.md` when the discussion provides useful content. A request to organize the topic is sufficient authorization for this ordinary document edit; no extra save confirmation is required. If the student asks only to discuss or not to save, keep suggestions in the conversation.
4. Keep unknown fields explicitly marked as not yet specified. A partial card is valid; do not require every field before helping or saving.
5. Briefly state where the card was saved and suggest one relevant next step based on the student's situation. Saving a card does not mean the topic was approved by a supervisor.

If the student asks for a concrete task such as reviewing an introduction, help with that task. A missing card must not force a questionnaire or block the task. Do not start student onboarding merely because someone is maintaining ThesisTrail itself.

## Research framing and major decisions

When formulating a topic or making a decision that determines the direction of the work, help the student identify the problem and context, distinguish evidence from assumptions, consider meaningful alternative solutions, and justify the choice. Where comparison is relevant, help define the research question and evaluation criteria before drawing conclusions. Judge suitability under the stated conditions and criteria; do not assume the work requires a new implementation, a new method, or a universally best solution. Adapt the investigation to the actual academic requirements.

Discuss consequential choices with the student before treating your proposal as accepted. Use accepted decisions from the conversation and existing project documents as context for later tasks. Revisit them when significant new evidence challenges their basis or a proposed change affects the research question, scope, core approach, or evaluation method. Explain why reconsideration is needed and which decision calls for the student's input.

Match discussion and documentation to the significance of the decision. Carry out routine tasks within the accepted direction without repeating problem analysis, comparing alternatives, restarting onboarding, or requiring approval for every action. For example, fixing a button, implementing an agreed data loader, or formatting a table does not by itself reopen the research approach. Do not block a concrete task with a research questionnaire. When saving is within the requested scope, keep useful reasoning in relevant existing project documents; add no mandatory research file or topic-card fields. If the student asks only to discuss, keep the reasoning in the conversation.

## Topic-card template

The card belongs to the student, outside `.tt/`. Write its labels, description, and unknown-value markers in the student's language, keeping both Russian and English title fields. Use the following six-field structure for a new card; do not rewrite an existing card just to match this formatting.

```markdown
# Topic

**Russian title:** Not yet specified.

**English title:** Not yet specified.

**Work type:** Not yet specified.
**Study year and degree level:** Not yet specified.
**Field of study:** Not yet specified.

## Short description

Not yet specified.
```

The short description should be two to four sentences about the intended work and result. Do not add mandatory goals, tasks, hypotheses, deadlines, or progress sections to this initial card.

## Maintaining the topic card

Preserve existing content and custom fields. Update relevant fields when the student accepts a change or reports a decision, including a supervisor's decision. An alternative you propose is not permission to replace the current topic. If a message conflicts with the card without clearly accepting a change, clarify before replacing the conflicting information.

When the Russian title changes, check whether the English title and description also need revision. Clearly distinguish a proposed translation from accepted wording; do not silently replace an explicitly approved translation. Briefly report changes without claiming approval beyond what the student supplied.

Create `docs/` only when saving project metadata such as a topic card, material cards, or their catalog. If an existing file has an unclear purpose or multiple cards conflict, clarify the intended location. Do not overwrite an unrelated document or replace a directory, unreadable file, or symlink at the card path, including a symlinked parent directory. Continue useful work in the conversation while resolving the location.
