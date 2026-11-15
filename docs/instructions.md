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

## Delivery and ownership

For releases implementing this layout, install the entire release's `instructions/` tree at `.tt/instructions/`, preserving relative links. Keep `.tt/agent-rules.md` as a small forwarding entry point so existing root hooks and client configurations continue to work. The root hook may keep its current path. All thematic files belong to the release; student documents remain outside `.tt/`.

Keep all reusable agent assets supplied by ThesisTrail inside `.tt/`, including future skills, templates, and helper files. Do not install them into the student's source directories or client-specific root folders. `AGENTS.md` supplies the root entry hook. Academic documents and implementation files produced during a separately requested student task are project outputs, not installed agent assets. The initial archive behavior remains specified separately in [project setup](project-setup.md).

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

Review the entry point for topic formation, routine code edits, documentation changes, literature work, pending setup, and release checks. Manual review does not establish an agent client's behavioral compliance. Keep README descriptions short and distinguish planned domains from available modules.

## Verification

On 2026-11-15, 313 assertions passed across 14 disposable-fixture scenario groups on macOS with Bash 3.2.57. Checks covered empty and populated installation, archival, legacy migrations, full-tree replacement including a nested domain module, same-release no-op, unsafe-source and destination rejection, rollback after tree and metadata failures, handled signals, and retained recovery backups after an injected restoration failure. An approved update also restored a missing managed tree.

The published `v0.0.2` launcher successfully invoked the new applier against a temporary local Git release; the current installer delegated to that release as well. Installed modules matched their source bytes, local Markdown links and anchors resolved, and individual Bash syntax checks passed. Fixtures and verification scripts remained outside the repository. Linux execution, rendered README appearance, and an actual agent-client pilot remain unverified.
