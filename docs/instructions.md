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
```

`agent-rules.md` is a short entry point containing common behavioral rules and links with applicability conditions. General instructions cover project practices; research instructions cover topic formation, major research decisions, and sources. Maintenance instructions preserve setup and release behavior. Domain instructions supplement these subjects as relevant content becomes available, for example under `domains/ml/`. Do not create empty domain templates or imply that a planned domain already has instructions.

Read only the modules relevant to the task and session context. Reuse them within the conversation instead of loading the entire collection on every message. Initial setup and release checks retain their existing timing, consent, and ownership rules. A library session check still applies when a library exists and setup is not pending. Domain modules state when they apply, add their specific requirements without copying general rules, and are linked from the domain catalog.

## Adding domain instructions

This section is for contributors and repository-maintenance agents. The installed [domain catalog](../instructions/domains/README.md) is for student agents selecting instructions, not for authoring the collection.

### Choose the scope

Group domains by directions and approaches to coursework or thesis work, such as machine learning, web applications, or distributed systems. Add an applied subject area when it has distinct useful requirements. Put technology-specific details within a relevant area when needed; a language or dependency alone does not determine which domain applies.

Start from representative student tasks and observed mistakes. Include research methodology, consequential choices, technical practices, and interpretation of results where they affect the quality of work in this area. Keep general Git, reproducibility, documentation, and research-framing rules in their existing modules and link to them.

### Start small

1. Create `instructions/domains/<area>/README.md` using a short, descriptive lowercase directory name with hyphens where needed.
2. Put the area's applicability, useful initial instructions, and verification expectations in that file. One substantive README is sufficient; no fixed set of additional files is required.
3. Add thematic Markdown files only for independent subjects worth loading separately. Link every such file directly from the area's README with a short condition for reading it. Use relative links so they also resolve under `.tt/instructions/`.
4. Add an entry to `instructions/domains/README.md` containing the area name, a short applicability description, and a relative link to its README. Do not list unavailable areas or publish placeholder text, empty directories, author metadata, or course profiles.

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

## Instructions

- Required: a necessary minimum with a concrete expected outcome.
- If a stated condition holds: the requirement for that case.
- Recommended: a useful practice that can be adapted to the project.

## Verification

Explain what evidence or result demonstrates that the relevant requirements were met.
```

Keep rules concise and specific. Add a reason, example, or checking procedure where it resolves ambiguity; do not require four repeated fields for every rule. Link to primary sources for consequential or changing requirements, without adding a large bibliography by default. Short examples should clarify decisions rather than prescribe a stack, architecture, or research method for every project.

Keep the scale of application proportional to the task. A domain module must not require a new report, a full experiment, or renewed research framing for each minor edit. Optional examples, sources, and scripts belong in the area only when they serve a concrete need, with their purpose and any dependencies stated.

### Selection and review

The agent selects applicable domains from the student's topic and current task, briefly states the selection at first use, and reuses that context. It asks only when ambiguity materially affects the work. Several areas can apply; only relevant instructions are combined, and substantive conflicts are clarified rather than silently resolved by a blanket domain override.

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

Review domain selection against these cases: a clearly applicable task selects the area and relevant modules with a brief first-use notice; later routine edits reuse context without a repeated questionnaire; a materially ambiguous task prompts a focused clarification; unrelated tasks and areas absent from the catalog continue under general instructions without fabricated domain rules. A source review is not an agent-client behavioral test.

Review the entry point for topic formation, routine code edits, documentation changes, literature work, pending setup, and release checks. Manual review does not establish an agent client's behavioral compliance. Keep README descriptions short and distinguish planned domains from available modules.

## Verification

The domain-authoring changes on 2026-11-15 passed 150 assertions covering a temporary single-README area, its later expansion with a thematic file, installed and repository links, and Markdown source formatting. The fixture required no installer changes and added no domain to the actual collection. Selection scenarios were reviewed against the instructions; an actual agent-client behavioral trial remains separate.

After adding `.tt/.gitignore` and local backups on 2026-11-15, 385 assertions passed across 18 scenario groups using Bash 3.2.57 and disposable local fixtures. Coverage included preservation of root ignore rules, custom local-ignore blocks, Git exclusions versus trackable assets, installation and legacy upgrades, rollback including ignore-file publication failures, handled signals, and incomplete recovery paths. Both README files were checked for links and source structure; a rendered visual check remains unavailable.

On 2026-11-15, 313 assertions passed across 14 disposable-fixture scenario groups on macOS with Bash 3.2.57. Checks covered empty and populated installation, archival, legacy migrations, full-tree replacement including a nested domain module, same-release no-op, unsafe-source and destination rejection, rollback after tree and metadata failures, handled signals, and retained recovery backups after an injected restoration failure. An approved update also restored a missing managed tree.

The published `v0.0.2` launcher successfully invoked the new applier against a temporary local Git release; the current installer delegated to that release as well. Installed modules matched their source bytes, local Markdown links and anchors resolved, and individual Bash syntax checks passed. Fixtures and verification scripts remained outside the repository. Linux execution, rendered README appearance, and an actual agent-client pilot remain unverified.
