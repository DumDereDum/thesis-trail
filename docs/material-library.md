# Material library and document cards

## Scope and ownership

Students keep original reference documents locally, with a Markdown catalog and short document cards available in Git. This workflow is unreleased and is not included in `v0.0.2`.

The agent organizes materials during requested project preparation or document work. The installer supplies these instructions through `.tt/agent-rules.md`; it does not classify documents, create a library, generate summaries, or add a blanket materials ignore rule. Updates replace kit instructions without modifying original documents, student cards, catalogs, or `.gitignore`.

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

Classify by document purpose, not extension. A student's own draft, implementation, graphics assets, datasets, or program configuration do not become reference materials merely because they are PDFs or are inside a directory called `materials`. Do not duplicate a document across categories; preserve existing meaningful subdirectories within a category. Clarify ambiguous purpose before relocating a file.

## Names and existing-path conflicts

Before creating the library or changing `.gitignore`, inspect both the working project and any pending setup snapshot. The absence of a working `materials/` while it is archived does not make that name available.

Treat recorded paths as data: originals and metadata must stay inside the project, with no traversal or symlinked parent components. Never use `.git`, `.tt`, or `.backup` as the active library, and keep Markdown metadata outside the ignored originals root.

- Reuse an existing catalog's explicitly recorded originals root when it still identifies the reference library.
- If `materials/` is absent or is an existing reference-document library, use it. Integrate relevant documents without replacing unrelated files.
- If `materials/` is used for code, shaders, 3D assets, mixed content, a regular file, or a symlink, preserve that entry and its original path. Use `research-materials/` as the reference library when that path is available or already identifies the same library. If both names conflict or the purpose is unclear, clarify the location before writing or ignoring it.
- Record the actual project-relative originals root in `docs/materials.md`. Cards remain under `docs/materials/` and mirror paths beneath the chosen originals root. For example, `research-materials/articles/example.pdf` maps to `docs/materials/articles/example.pdf.md`.
- Existing unrelated `docs/materials.md` or `docs/materials/` must not be overwritten. Clarify an alternative catalog/card location and record it explicitly if these paths are occupied. Do not write through symlinked parents or replace existing incompatible entries.

The normal card mapping appends `.md` to the complete original filename, including its extension, so `example.pdf` and `example.docx` have distinct cards. Preserve filenames unless a concrete requirement needs renaming; handle destination collisions without overwriting another source or card.

## Git exclusions

After establishing the library's actual purpose and location, the agent adds only its anchored root exclusion to the project-owned `.gitignore`: `/materials/` for the default, or `/research-materials/` for the fallback. Preserve existing rules and the `/.backup/` exclusion; avoid duplicate entries. Never add `/materials/` when that directory belongs to the implementation. Keep the catalog and cards outside the ignored root and verify they are not hidden by existing ignore rules. Do not remove broader user rules without resolving their intent.

No `.gitkeep` or empty directory tree is required. Ignoring originals does not untrack files already in Git; do not automatically remove tracked files from the index or stage unrelated changes. A clone contains only tracked metadata, not ignored originals. Store the source URL when available so missing originals can be located again; never invent a URL or download files without a task requiring it.

## Catalog and cards

`docs/materials.md` records the chosen originals root, any nondefault card location, and a compact table of titles, categories, links to cards, and reading status. It helps navigate the library; detailed descriptions belong only in individual cards. Use paths relative to each Markdown file for working links and show original paths relative to the project root. For example, the default catalog links to `materials/articles/example.pdf.md`, while that card links to `../../../materials/articles/example.pdf`.

A card contains:

- A human-readable title and the actual project-relative path/link to its original.
- A short account of what the document contains and why it is useful for this work.
- The source URL and printed date/edition/version when known; otherwise leave them explicitly unknown or omit optional fields. A recorded edition is not a claim that a regulation remains in force.
- Relevant pages or sections when inspected. If only part of a long document was read, state that scope rather than implying a complete review.

Write student metadata in the student's language. Include an inline card template in the installed instructions; no separate template file is needed. Newly inventoried documents may have cards explicitly marked as unread, with contents/use not yet assessed. Read the document before summarizing it; filenames alone do not establish content. Partial or unread cards allow setup to finish without requiring every book to be read in full.

Use the catalog and cards to choose relevant originals. For document-grounded questions, exact requirements, or quotations, inspect the relevant part of the original and identify the file and page/section. If the original is absent or unreadable, explain the limitation and do not present the card as a verified quotation. Clearly separate a document's statements from suggestions or inferences. Extract reusable requirements into the relevant working Markdown document with source locations; the short source card is not a replacement for the original.

When a document is added, changed, moved, or removed during requested work, maintain its card and catalog entry together. Keep existing custom notes, update links, and mark unverified descriptions as stale or not yet reviewed when needed. Do not invent reading progress. This is an agent workflow, not a background file watcher; do not rescan every material on every message. Missing files after cloning do not justify silently deleting useful cards.

## Restoration from `.backup/`

During [initial project setup](project-setup.md), inspect the archived layout and any catalog before selecting the originals root or adding ignore rules. Restore implementation and the student's own draft at their previous paths. Recognized reference documents can be copied directly from the snapshot into the chosen category instead of restored at their old locations. Record each changed source-to-destination path in the catalog, preserving original snapshot-relative paths, so completion checks can account for every archived item. Preserve the full original snapshot; do not rename or edit files inside it.

If moving a document would break existing links or build inputs, preserve the working path and clarify a relocation before changing it. Existing mirror cards and catalogs should be reused and updated, preserving notes rather than replaced. Inventory recognized references, create cards or explicit unread placeholders, update the catalog, and add the correct library-only ignore rule before marking setup complete. Projects without reference documents need no library or empty catalog. Unresolved naming or restoration conflicts keep setup pending.

### Example: `materials/` already contains rendering assets

The snapshot contains `materials/wood.shader`, `materials/textures/wood.png`, and a research paper at `papers/example.pdf`. The agent restores the rendering directory to `materials/` and preserves its build references. It chooses `research-materials/` for documents, checks whether relocating the paper breaks any existing reference, and, when relocation is appropriate, copies it to `research-materials/articles/example.pdf`. The card is `docs/materials/articles/example.pdf.md`, and the catalog records the chosen root and original `papers/example.pdf` path. `.gitignore` excludes `/research-materials/`, never `/materials/`. The archived assets and paper remain intact.

## Acceptance criteria

- Installed instructions contain all five categories, the card template, catalog navigation, original-based answers, and path/ignore conflict handling.
- Each original has a unique mirrored card; extension collisions remain distinct. Default and fallback links resolve to the actual files, with catalogs/cards available to Git and only the chosen originals root ignored.
- An existing code/asset `materials/` is restored without changes and is not ignored by the library workflow. An unavailable fallback or conflicting documentation path is clarified before writing.
- Initial setup preserves the snapshot and accounts for relocated references; unread documents do not receive fabricated summaries or block completion. A missing original after cloning is reported without discarding the card.
- Installer/update delivery leaves classification and ignore-rule selection to the agent, preserving existing catalogs, cards, and implementation paths. No dependencies, background services, or test files are added to the repository.

## Verification

On 2026-11-14, 57 disposable-project and documentation checks passed on macOS with Bash 3.2.57. The current applier delivered the installed rules byte for byte, including all five categories, the card template, original-based answers, and the archived rendering-directory conflict example. Initial installation preserved archived implementation assets and originals without selecting or ignoring a reference-library root. Empty installation created no library metadata. Applying the current release fixture over `v0.0.2` preserved implementation files, existing catalog/cards, ignore rules, and modification times without restarting setup.

Default and fallback link mappings resolved correctly; Git ignored only the chosen originals root while leaving the catalog and cards available. Local documentation links and `git diff --check` passed. Verification used temporary fixtures outside the repository and added no test files. These checks establish delivery and file ownership, not an agent's ability to classify or summarize real documents; an actual agent-client pilot remains a separate manual check.
