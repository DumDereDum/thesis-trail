# Documentation instructions for student projects

## When to apply

Apply these instructions when creating or changing a student's README or other project documentation. Write for someone encountering the project for the first time, including a supervisor, reviewer, or future developer. Match the detail to the reader's task and the significance of the change.

## Agreed requirements

### Keep the README useful and short

- Use the README as the project's entry point: explain its purpose, show a short example or result, provide the minimum steps to run the main scenario, and link to relevant details. Mention limitations when they affect a reader's expectations or ability to proceed.
- Keep enough context and commands for a newcomer to get started. Move lengthy setup alternatives, architecture explanations, experiment procedures, and detailed results to appropriate documents with clear links.
- Prefer a concise introduction and quick start over a fixed line limit. Remove material that does not help the reader understand, run, use, or check the project. Do not expand the README merely because more information is available.
- Keep each detailed explanation in one appropriate place. Summarize and link from the README instead of copying entire sections into it.
- Do not use the README as an agent's work report, session transcript, or running history of completed tasks. Give brief work reports in the conversation, use Git for change history, and maintain a separate changelog only when it serves the project.

### Maintain documentation within the task

- Update the parts affected by changes to behavior, setup, commands, or limitations. Preserve useful existing structure and author content; a small task does not authorize rewriting all documentation or removing unrelated material.
- Create a separate document when it has a useful, distinct subject that does not fit comfortably in an existing document. Reuse suitable files and do not create empty templates or a standard document tree without a need.
- Explain substantial decisions and limitations where they help a reader. Avoid documenting every minor action or duplicating what code and configuration already express clearly.
- Use concrete statements and examples. Remove repetition, promotional claims, generic introductions, and explanations that add no project-specific information. Distinguish implemented behavior, measured results, plans, and unverified claims.
- Follow the project's language requirements and existing agreements. If none are specified, use the student's language; translations and a second README are not mandatory. Keep related language versions consistent when maintaining them within the task.

### Use restrained, readable Markdown

- Prefer ordinary Markdown that the target hosting service or viewer supports. Use a clear heading hierarchy, short paragraphs, lists for parallel items, and fenced blocks with an appropriate language label for commands or code.
- Use tables or diagrams when they make the information easier to understand. Avoid wide tables, large directory listings, or elaborate layouts that make the main page difficult to read. Check viewer support before relying on diagrams, HTML, or other extensions.
- Do not add decorative banners, emoji, or collections of badges by default. Add visual elements only when they serve a clear purpose for this project.
- Include screenshots and other images when they explain the interface or result. Check their size, readability, and consistency with current behavior; do not use images to repeat all the surrounding text.
- Use working relative paths for repository documents and images. Check navigation links and heading anchors. Do not leave links pointing to the agent's local machine, temporary files, or nonexistent documents.

### Review the rendered page

- After creating a document or making substantial content or layout changes, inspect its rendered form on the target platform or in a compatible preview. Reviewing Markdown source, passing a linter, or generating HTML alone is not a visual check.
- Review the whole affected document, including the top of the README. Check heading hierarchy, spacing, list indentation, tables, code blocks, links, image sizes, and diagrams. Correct awkward or broken presentation before describing the page as visually checked.
- If rendering tools or the target platform are unavailable, state that visual verification remains incomplete. Perform available source and link checks without claiming they establish the final appearance.
- After a substantial README change, briefly explain the change and give the student a path or link to the page. Ask them to view the rendered main page before publication, within any already requested publication task; do not introduce approval for every minor edit or commit. The student's review supplements the agent's own available checks.

## Additional recommendations

- Keep the quick start focused on one representative scenario. Link to environment-specific instructions and full reproduction procedures as described in the [reproducibility instructions](reproducibility.md).
- When moving details out of the README, preserve useful content and update links together. Avoid replacing an informative page with a bare collection of links.
- Before adding a section, identify the question it answers for the intended reader. If another section already answers it, edit or link to that section instead.

## How to verify and report

Review content for relevance, accuracy, duplication, and scope. Check that commands and described behavior match the project, using the relevant reproducibility checks when execution is needed. Verify local links and assets, then perform the rendered review appropriate to the changes.

Report the files changed and the checks actually performed, distinguishing source/link checks, command execution, and visual inspection. Identify the viewer or platform used for visual inspection and any remaining gaps. Follow the [Git instructions](git.md) for commits and publication.

Review agent behavior against these scenarios:

| Scenario | Expected behavior |
| --- | --- |
| The README contains long setup alternatives and session reports | Preserve useful setup details in suitable documentation, link to them, and keep work reports out of the main page. |
| A new installation option is added | Update the relevant instructions and README links without rewriting unrelated documentation. |
| The agent proposes a standard set of empty documentation files | Create only documents with a current, distinct purpose. |
| Raw Markdown looks correct but the rendered table or image is unreadable | Fix the layout and inspect the rendered result again. |
| A new README has been written but no compatible preview is available | Report source and link checks and explicitly leave visual verification incomplete. |
| The README has been substantially reorganized | Inspect the rendered page and give the student a path or link for their own review before publication. |

These scenarios are review criteria for the guidance, not evidence of completed agent-client verification.
