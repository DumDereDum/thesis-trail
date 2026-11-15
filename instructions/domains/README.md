# Domain instructions

## Available areas

These areas provide starting recommendations for technical aspects of coursework and theses. They are a baseline to develop with instructors, not an official grading rubric or a complete set of academic requirements. Use the student's supplied requirements and accepted project decisions alongside them.

| Area | When to use |
| --- | --- |
| [Web](web/README.md) | Browser interfaces, web clients, and PWA behavior. |
| [Backend](backend/README.md) | Server logic, APIs, persistent data, and concurrent operations. |
| [Mobile](mobile/README.md) | Native or cross-platform mobile applications and device behavior. |
| [Games](games/README.md) | Game rules, state, play loops, and player interaction. |
| [Data analysis](data-analysis/README.md) | Data preparation, analytical indicators, and interpretation of results. |
| [Machine learning](machine-learning/README.md) | Developing or evaluating learned models and their predictions. |
| [LLM systems](llm/README.md) | Language-model applications, including RAG and LLM-based agents. |
| [Computer vision](computer-vision/README.md) | Images, video, tracking, and spatial data such as lidar point clouds. |
| [Speech and audio](speech-audio/README.md) | Speech recognition, synthesis, and audio processing or analysis. |
| [Networks](networks/README.md) | Routing, protocols, tunneling, and traffic processing. |
| [Systems programming](systems-programming/README.md) | System components, cross-language libraries, and interface generation. |
| [Infrastructure](infrastructure/README.md) | CI/CD, environments, deployment, and operation of systems. |
| [Security](security/README.md) | Threats, access control, protection mechanisms, and security evaluation. |

Areas can be combined; they do not form a hierarchy. Education, transport, and other application sectors are project context. If no area fits, continue with general and research instructions; do not invent domain rules or create a missing area during an unrelated student task.

## Selecting instructions

1. Use the student's topic, accepted decisions, existing project documents, and these applicability descriptions. A language, library, product name, or keyword alone is not enough: an unspecified AI agent may not use LLMs, and analyzing mobile apps may not involve building a mobile client.
2. When starting or planning the work, or asked what is expected, read the short READMEs for the known scope of the whole work. Give the student a concise overview of applicable baseline recommendations and conditional expectations. Identify unknowns without assuming a stack or method. Pending project setup retains priority; installation or maintaining ThesisTrail itself does not trigger this overview.
3. For a concrete task, read and apply only the relevant areas and linked details. Briefly identify them at first use. Do not delay useful work for a full-project overview or questionnaire; ask only when ambiguity materially affects the task.
4. Reuse the selection and overview from the conversation and existing project documents. Revisit them when the scope changes substantially or the student requests a review, not for every edit or session. Do not load the entire collection or repeatedly announce the same selection.

For example, a mobile booking service may use mobile and backend. Explain client interruption handling and competing bookings during initial planning; a later UI change need not rerun the server review. Using HTTP does not by itself select networks, and using a model API does not require model training.

Several areas may apply to one project. Related-area links are conditional navigation, not automatic dependencies; do not recursively load their neighbors. Combine only relevant instructions, preserving general rules and accepted project requirements. Clarify substantive conflicts rather than silently replacing a decision.

## Applying the baseline

Apply recommendations within their stated scope and conditional guidance only when its condition holds. Explain adaptations that affect the work's claims or expected results. Distinguish these recommendations from actual academic or project requirements; do not present a linked external checklist as mandatory in full. Use evidence appropriate to the claim being checked.

Match effort to the task. A routine edit does not by itself require a new report, an entire experiment, a new document, or renewed research framing. The overview adds no mandatory file or topic-card fields. Save it or relevant results in existing student documents outside `.tt/` only within the requested scope. Keep the student's existing authorization and accepted decisions in effect.
