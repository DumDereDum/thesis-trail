# Thematic agent instructions

## Scope and layout

Keep reusable instructions for coursework and thesis agents under `instructions/`, grouped by subject. Keep product specifications in `docs/`. Do not organize the instruction collection by author or course, and do not add attribution metadata or course profiles.

```text
instructions/
  agent-rules.md
  general/
    git.md
    reproducibility.md
    documentation.md
  research/
    topic.md
    materials.md
  maintenance/
    project-setup.md
    updates.md
  domains/
    README.md
    <area>/README.md
```

`agent-rules.md` is a short entry point containing common behavioral rules and links with applicability conditions. General instructions cover project practices; research instructions cover topic formation, major research decisions, and sources. Maintenance instructions preserve setup and release behavior. Domain instructions provide a starting baseline for technical aspects of student work. The initial collection contains 13 peer areas, each with one short README: web, backend, mobile, games, data-analysis, machine-learning, llm, computer-vision, speech-audio, networks, systems-programming, infrastructure, and security. These are recommendations to develop with instructors, not an official grading rubric.

Read only the modules relevant to the task and session context. Reuse them within the conversation instead of loading the entire collection on every message. Initial setup and release checks retain their existing timing, consent, and ownership rules. A library session check still applies when a library exists and setup is not pending. Domain modules state when they apply, add their specific requirements without copying general rules, and are linked from the domain catalog.

## Adding domain instructions

This section is for contributors and repository-maintenance agents. The installed [domain catalog](../instructions/domains/README.md) is for student agents selecting instructions, not for authoring the collection.

### Choose the scope

Group domains by technical expertise that changes how an aspect of a coursework or thesis is prepared, implemented, or checked. Application sectors such as education, real estate, and transport are project context, not domains in this catalog. Put technology-specific details within a relevant area when needed; a language or dependency alone does not determine which domain applies.

Keep the initial collection flat, without parent-domain inheritance. Web covers browser-facing behavior; backend covers server logic and data even for mobile clients. RAG and LLM agents initially belong to conditional sections of llm; iOS and Android belong to mobile. Several areas can apply to one work. Keep one level by default while there are fewer than 30 areas; reaching 30 prompts a navigation review, not an automatic hierarchy. Add subdomains only when substantial shared guidance and distinct specializations make them more useful than direct links and catalog grouping.

Start from representative student tasks and observed mistakes. Include research methodology, consequential choices, technical practices, and interpretation of results where they affect the quality of work in this area. Keep general Git, reproducibility, documentation, and research-framing rules in their existing modules and link to them.

### Start small

1. Create `instructions/domains/<area>/README.md` using a short, descriptive lowercase directory name with hyphens where needed.
2. Put the area's applicability and an important boundary, three to five useful baseline recommendations, and relevant conditional guidance in that file. Include what to demonstrate or check in the recommendations themselves. Aim for a short README, roughly 15–30 lines, without treating the count as a hard limit. No fixed set of additional files is required.
3. Add thematic Markdown files only for independent subjects worth loading separately. Link every such file directly from the area's README with a short condition for reading it. Use relative links so they also resolve under `.tt/instructions/`.
4. Add an entry to `instructions/domains/README.md` containing the area name, a short applicability description, and a relative link to its README. Link related areas with explicit conditions. Do not list unavailable areas or publish placeholder text, empty directories, author metadata, or course profiles. A short README with useful recommendations is sufficient; a title and a promise of future guidance are not the baseline delivered by this collection.

For example, a catalog entry has this form, with the placeholders replaced:

```markdown
- [Area name](area-name/README.md): use for the stated kinds of tasks.
```

The installer already copies the entire instruction tree. Adding a domain needs no installer edit, dependency, client-specific configuration, or new manifest. These are ordinary Markdown modules selected through the entry point; directory names alone do not register native skills with a client.

### Write actionable instructions

Use the following outline as a starting point, replacing the descriptions with actual domain content. Omit sections or labels with no useful content; do not create a separate template file.

```markdown
# Area name

## When to apply

State which tasks this covers and an important boundary where it does not apply.

## Baseline guidance

- State a useful recommendation and the result to demonstrate or check.
- Add other recommendations specific to this area's work.

## When relevant

- If a stated condition holds: explain the additional guidance.

## Related areas

Link another area and state when to use it.
```

Keep rules concise and specific. Add a reason, example, or checking procedure where it resolves ambiguity; do not require four repeated fields for every rule. Link to primary sources for consequential or changing requirements, without adding a large bibliography by default. Short examples should clarify decisions rather than prescribe a stack, architecture, or research method for every project. Keep the common status of the starter recommendations in the catalog. Do not turn them or linked external checklists into mandatory academic requirements; label an actual requirement with its applicability and supplied basis when one exists.

Keep the scale of application proportional to the task. A domain module must not require a new report, a full experiment, or renewed research framing for each minor edit. Optional examples, sources, and scripts belong in the area only when they serve a concrete need, with their purpose and any dependencies stated.

### Selection and review

When starting or planning a student's work, or when asked what is expected, the agent selects areas for the known scope of the whole work, reads their short READMEs, and gives a concise overview of the applicable baseline and conditional expectations. Distinguish confirmed aspects from possibilities; do not invent a stack or method to complete the selection. Installation and repository maintenance alone do not trigger this overview. Pending setup still takes priority. A concrete task is not blocked by an incomplete topic or a full-project questionnaire.

During later tasks, apply only relevant guidance and reuse the established selection. Revisit it when substantive scope changes or the student asks for a review, not for each edit or session. A first concrete task can introduce only the areas relevant to that task. Use existing project documents as context across sessions; no mandatory overview file, topic-card fields, or automatic document edits are added. Save a useful overview in existing student documents only within the requested scope, outside the managed `.tt/` collection.

Several areas can apply; only relevant instructions are combined, and substantive conflicts are clarified rather than silently resolved by a blanket domain override. Related-area links are conditional navigation, not automatic dependencies: do not recursively load their neighbors. Apply data-persistence checks only when the component actually stores state; a stateless service can be checked through its output and failure behavior. Instructors contribute reusable guidance to this source repository. Project-specific agreements belong to student documents outside `.tt/` and remain distinct from the shared baseline.

Before adding or substantially changing an area:

- Review a few representative student requests, the expected actions and evidence, and a case where the area should not apply. Include a routine task that must not trigger a full domain review.
- Check consistency with general instructions and actual project requirements, meaningful distinctions between required, conditional, and recommended practices, and absence of copied boilerplate.
- Check relative links and any runnable examples. Where feasible, try the instructions with an agent on a representative task and refine them from observed behavior. Report source review and actual agent trials separately.

Useful background: [Agent Skills structure and selective loading](https://agentskills.io/specification), [instruction authoring and evaluation](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices). These inform content organization without imposing their client-specific formats on ThesisTrail.

## Delivery and ownership

For releases implementing this layout, install the entire release's `instructions/` tree at `.tt/instructions/`, preserving relative links. Keep `.tt/agent-rules.md` as a small forwarding entry point so existing root hooks and client configurations continue to work. The root hook may keep its current path. All thematic files belong to the release; student documents remain outside `.tt/`.

Keep all reusable agent assets supplied by ThesisTrail inside `.tt/`, including future skills, templates, and helper files. Do not install them into the student's source directories or client-specific root folders. `AGENTS.md` supplies the root entry hook. Academic documents and implementation files produced during a separately requested student task are project outputs, not installed agent assets. The initial archive behavior remains specified separately in [project setup](project-setup.md).

Install a marked block in `.tt/.gitignore` for local backups, setup/update state, locks, and temporary transactions. The ignore file and release assets are intended for Git; the whole `.tt/` directory is not excluded. Preserve custom rules and the root `.gitignore`, and never automatically untrack existing files. Updates preserve local snapshots and state, including legacy backup locations.

Record `instructions_layout: 1` in installation metadata under the existing metadata schema. Missing layout metadata identifies a legacy installation. Reject unsupported layout values and an existing `.tt/instructions` at initial installation or a legacy upgrade, rather than replacing unrelated files. When layout 1 is already recorded, `.tt/instructions` is a managed directory and is replaced in full, removing obsolete modules. A missing managed tree may be restored by an approved update. Reject symlinks and non-directory destinations for the tree, and reject symlinks or non-regular entries in the release tree before application.

Stage the full tree before replacing managed files. Include its replacement in the existing transaction, publish metadata last, and restore the previous tree and managed files after an ordinary failure or handled signal. Preserve file permissions during rollback. Keep transaction backups when recovery is incomplete. Updates preserve student documents, root custom instructions, unrelated `.tt/` files, setup state, snapshots, unknown metadata, and the original installation time.

The installer and updater keep their Bash 3.2 and standard-utility dependencies. The standalone release launcher and its protocol remain unchanged; the target release's applier delivers this layout. Published older revisions retain their original behavior.

## Acceptance criteria

Verify in disposable projects:

- Empty and populated initial installation deliver all thematic files byte for byte, a forwarding entry point, valid layout metadata, and resolving instruction links. Existing archival and onboarding behavior remains intact.
- A metadata-only `v0.0.1` or maintenance-only `v0.0.2` installation upgrades to this layout without changing student files, setup state, custom root instructions, or unknown metadata. The existing launcher can invoke the new applier.
- Updating layout 1 replaces the whole managed tree, removes obsolete modules, and includes newly added nested domain files without changing a hardcoded file list.
- Initial or legacy destination collisions, unsafe release trees, unsupported layout values, and symlinked destinations fail without replacing student or managed content.
- Injected tree-publication and final-metadata failures restore previous tree contents, permissions, and managed files. An initial-installation failure also restores archived materials.
- Bash 3.2 syntax, paths containing spaces, relative links, and `git diff --check` pass.
- A domain containing only its substantive README can be added by editing its folder and the catalog. A later thematic file resolves directly from that README and is delivered without changing installation scripts.
- The initial 13 areas each contain only a README, are directly reachable from the catalog, and have resolving related-area links in the repository and installed tree. Every README states a boundary and a useful baseline, without requiring a particular stack or implying official grading criteria.

Review the initial baseline against these representative cases:

| Case | Expected selection and guidance |
| --- | --- |
| Browser PWA benchmark | Web: target browsers and comparable measurement conditions; n-body input does not automatically create a games or ML task. |
| Concurrent auction bids or room bookings | Backend: business invariants, conflicting operations, and relevant load; no automatic microservices requirement. |
| Stateless conversion API | Backend: observable outputs and failures; no invented database or persistent-state checks. Related links do not activate every neighboring area. |
| Mobile student registration with a server | Mobile and backend: explain client lifecycle and booking behavior early; a later button edit does not restart the overview. |
| Multiplayer game | Games and backend when a server exists: game state and coordination; using a connection does not itself select networks. |
| Financial reporting dashboard | Data-analysis, plus web/backend as implemented: traceable metrics and transformations; no automatic ML selection. |
| ML pair-trading experiment | Machine-learning and data-analysis: time-aware evaluation, leakage checks, and a comparison method. |
| Corporate RAG or LLM interviewer | LLM systems, with security/backend as relevant: retrieval and answer checks for RAG, action boundaries for agents; training is not mandatory. |
| GPU object tracking or lidar segmentation | Computer-vision, plus machine-learning when developing/evaluating learned models: modality-specific errors and quality/resource tradeoffs. |
| Speech recognition or music visualization | Speech-audio: suitable quality checks and recording conditions; music analysis does not automatically imply ML. |
| FRR/VPP routing or NGFW filtering | Networks, plus security for protection properties: topology, traffic conditions, intended forwarding and isolation. |
| Python/Java bridge or IDL generator | Systems-programming: types, resource ownership, errors, and interface compatibility; no separate language domain. |
| CI for an NGFW sandbox | Infrastructure: pipeline failures and artifacts; networks only if traffic behavior is part of the task. |
| Mobile protected storage or vulnerable-app examples | Security, plus mobile or the relevant implementation area: threat assumptions and scoped verification. |
| Mobile-stack detector, unspecified AI agents, or an unspecified HSK platform | Clarify only material ambiguity; do not infer mobile runtime, LLMs, or web architecture from keywords. |
| Existing work, missing topic card, or unrelated routine edit | Reuse available context, help with the task, and avoid new mandatory documents or a repeated onboarding questionnaire. |

Review domain selection against these cases: a clearly applicable task selects the area and relevant modules with a brief first-use notice; later routine edits reuse context without a repeated questionnaire; a materially ambiguous task prompts a focused clarification; unrelated tasks and areas absent from the catalog continue under general instructions without fabricated domain rules. A source review is not an agent-client behavioral test.

Review the entry point for topic formation, routine code edits, documentation changes, literature work, pending setup, and release checks. Manual review does not establish an agent client's behavioral compliance. Keep README descriptions short and distinguish planned domains from available modules.

## Verification

The 13-area baseline was reviewed on 2026-11-15. Related-area links were clarified as conditional navigation rather than recursive dependencies, and backend persistence checks were limited to operations that store state. Update guidance now explicitly respects requests that prohibit runtime-state writes.

Seven local installation scenario groups passed through the actual `install.sh` and installed `update.sh`: default installation via stdin, explicit tag and branch selection, populated-project archival and root hooks, repeat-install rejection, destination collisions, release checks and interval handling, and full-tree update with preservation and same-version no-op. Git URL rewriting pointed the unmodified scripts at a temporary local repository with fixture tags. All 22 instruction files matched their source bytes and permissions; 120 repository links and 75 installed instruction links and anchors resolved. Student documents, pending setup state, snapshots, custom ignore rules, and unknown metadata survived updates. Bash syntax and `git diff --check` passed. Test code and logs were kept outside this repository.

Codex CLI 0.167.2 completed six representative student scenarios: mobile/backend planning, a single button-label edit, an ambiguous mobile-stack analysis topic, corporate RAG with access restrictions, a stateless API, and pending-backup restoration. Command traces and answers were reviewed in addition to file snapshots: selected guidance matched the task, discussion-only requests left files unchanged, the routine edit touched only the requested label, and restoration retained the backup and topic content. Two additional runs with stale update timestamps verified that discussion-only and narrowly scoped edits defer maintenance writes under the clarified rule. These are observed runs of one client, not a guarantee of behavior across clients or all prompts. Linux, live publication of this unreleased tree, and rendered-page appearance remain unverified.

The domain-authoring changes on 2026-11-15 passed 150 assertions covering a temporary single-README area, its later expansion with a thematic file, installed and repository links, and Markdown source formatting. The fixture required no installer changes and added no domain to the actual collection. Selection scenarios were reviewed against the instructions; an actual agent-client behavioral trial remains separate.

After adding `.tt/.gitignore` and local backups on 2026-11-15, 385 assertions passed across 18 scenario groups using Bash 3.2.57 and disposable local fixtures. Coverage included preservation of root ignore rules, custom local-ignore blocks, Git exclusions versus trackable assets, installation and legacy upgrades, rollback including ignore-file publication failures, handled signals, and incomplete recovery paths. Both README files were checked for links and source structure; a rendered visual check remains unavailable.

On 2026-11-15, 313 assertions passed across 14 disposable-fixture scenario groups on macOS with Bash 3.2.57. Checks covered empty and populated installation, archival, legacy migrations, full-tree replacement including a nested domain module, same-release no-op, unsafe-source and destination rejection, rollback after tree and metadata failures, handled signals, and retained recovery backups after an injected restoration failure. An approved update also restored a missing managed tree.

The published `v0.0.2` launcher successfully invoked the new applier against a temporary local Git release; the current installer delegated to that release as well. Installed modules matched their source bytes, local Markdown links and anchors resolved, and individual Bash syntax checks passed. Fixtures and verification scripts remained outside the repository. Those earlier runs did not cover Linux, rendered README appearance, or agent-client behavior; the later domain-baseline checks above report the additional coverage.
