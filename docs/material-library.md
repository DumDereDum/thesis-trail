# Material-library specification

## Scope and ownership

This document defines library paths, ownership, behavioral contracts, and verification for ThesisTrail maintainers. Agent-facing procedures and the card template live in [the material instructions](../instructions/research/materials.md).

Students keep original reference documents locally, with a Markdown catalog and short document cards available in Git. This workflow is unreleased and is not included in `v0.0.2`.

The agent organizes materials during requested project preparation or document work. With the [thematic layout](instructions.md), the installer delivers `.tt/instructions/research/materials.md`, reached through `.tt/agent-rules.md`. The installer does not classify documents, create a library, generate summaries, or add a blanket materials ignore rule. Updates replace kit instructions without modifying original documents, student cards, catalogs, or `.gitignore`.

## Layout and categories

The default originals root is `materials/`. Create directories only when needed:

```text
materials/                         # Local originals, ignored by Git
  articles/example.pdf
  books/textbook.pdf
  regulations/regulation.pdf
  guidelines/department-guide.pdf
  other/presentation.pptx
docs/
  materials.md                     # Catalog, available in Git
  materials/
    articles/example.pdf.md
    books/textbook.pdf.md
    regulations/regulation.pdf.md
    guidelines/department-guide.pdf.md
    other/presentation.pptx.md
```

| Category | Contents |
| --- | --- |
| `articles/` | Research papers, reviews, and other scientific articles |
| `books/` | Books, textbooks, monographs, and individual book chapters |
| `regulations/` | Laws, orders, standards, regulations, and other normative documents |
| `guidelines/` | Department guidance, assignment requirements, assessment criteria, and methodological instructions |
| `other/` | Reference documents that do not fit the preceding categories |

## Path and ownership contracts

- Classification depends on document purpose. Student drafts, implementation, assets, datasets, and configuration are outside the reference-library workflow.
- `materials/` is the default originals root. Existing implementation assets, mixed content, files, or symlinks reserve that path, including while archived. The fallback is an available `research-materials/`; unresolved collisions block relocation, not useful discussion.
- Catalogs record the actual originals root and any nondefault metadata location. Paths stay inside the project without traversal or symlinked parents; `.git`, `.tt`, and `.backup` cannot be active reference libraries. Existing unrelated documents and user notes are preserved.
- A card mirrors the original path beneath its library root and appends `.md` to the full filename. Thus `example.pdf` and `example.docx` have different cards. Default catalog links are `materials/articles/example.pdf.md`; that card links to `../../../materials/articles/example.pdf`.
- Only the selected originals root is ignored by the library workflow. Catalogs and cards remain available to Git; existing tracked files are not automatically untracked. Directory exclusions must not hide implementation assets.
- During initial restoration, the snapshot stays intact. The catalog accounts for changed source-to-destination paths; dependent working paths remain valid until relocation is resolved. Projects without references require no library or empty metadata.

## Content and access contracts

The catalog provides navigation and access/reading status; cards contain detailed descriptions, relevance, verified source information, and inspected pages or sections. Unknown or unread content is explicit. Metadata uses the student's language. Missing originals do not justify deleting their cards, inventing quotations, or treating a summary as verified source text.

A requested search can obtain accessible originals and maintain metadata within its scope. Distinct works, downloaded files, and completed cards are separate reported outcomes. An inaccessible work can have a verified source-link entry, but no fictitious local file or card. Source verification, version distinctions, original-based answers, and download restrictions are defined in the material instructions.

Session discovery reports new or missing local files without changing files, metadata, or ignore rules and without downloading replacements. Expected source-only entries are not missing files. Pending setup takes precedence, and checks do not repeat on every message. Already authorized library work may resolve differences within its scope.

### Example: `materials/` already contains rendering assets

For an archived `materials/wood.shader` and `papers/example.pdf`, acceptance requires the asset at its original working path, a document under the available reference root, a recorded relocation, and no `/materials/` ignore rule. The original snapshot remains unchanged. This is a regression scenario for path ownership, not a new directory convention for student projects.

## Acceptance criteria

- Installed instructions contain all five categories, the card template, catalog navigation, original-based answers, and path/ignore conflict handling.
- Each original has a unique mirrored card; extension collisions remain distinct. Default and fallback links resolve to the actual files, with catalogs/cards available to Git and only the chosen originals root ignored.
- An existing code/asset `materials/` is restored without changes and is not ignored by the library workflow. An unavailable fallback or conflicting documentation path is clarified before writing.
- Initial setup preserves the snapshot and accounts for relocated references; unread documents do not receive fabricated summaries or block completion. A missing original after cloning is reported without discarding the card.
- Installer/update delivery leaves classification and ignore-rule selection to the agent, preserving existing catalogs, cards, and implementation paths. No dependencies, background services, or test files are added to the repository.
- A requested topic-based search uses existing context, verifies sources, avoids duplicate versions, and reports actual found/downloaded/card counts. Saved originals have verified files, source metadata, and corresponding cards; unavailable originals have source links without fabricated local files. Search-only requests do not modify the project. Tool availability and limited reading scope are stated honestly.
- A session-start library check reports new/missing files without changing project files or downloading replacements, skips pending backup restoration and expected source-only entries, and does not repeatedly notify on every message. Explicitly authorized library work remains allowed within its scope.

## Verification

On 2026-11-14, 57 disposable-project and documentation checks passed on macOS with Bash 3.2.57. The current applier delivered the installed rules byte for byte, including all five categories, the card template, original-based answers, and the archived rendering-directory conflict example. Initial installation preserved archived implementation assets and originals without selecting or ignoring a reference-library root. Empty installation created no library metadata. Applying the current release fixture over `v0.0.2` preserved implementation files, existing catalog/cards, ignore rules, and modification times without restarting setup.

Default and fallback link mappings resolved correctly; Git ignored only the chosen originals root while leaving the catalog and cards available. Local documentation links and `git diff --check` passed. Verification used temporary fixtures outside the repository and added no test files. These checks establish delivery and file ownership, not an agent's ability to classify or summarize real documents; an actual agent-client pilot remains a separate manual check.
