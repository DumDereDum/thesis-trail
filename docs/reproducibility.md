# Reproducibility guidelines for student projects

## When to apply

Apply the relevant sections to running a student's software and repeating research experiments. The goal is for another person to obtain the required inputs, follow working instructions, and check the stated result under the documented conditions. Use the project's actual academic and technical requirements.

Maintain reproducibility as the project develops. Update the relevant instructions when behavior, dependencies, data, or commands change; do not repeat the full review for every minor action or require complete reproduction before every commit. At significant milestones, check the main scenario and report gaps. Before final submission, verify the complete main scenario, including any experiments supporting the reported conclusions, or explicitly identify what could not be reproduced.

These are student-project guidelines. They do not add dependencies or CI to ThesisTrail itself. This document is not yet included in the installed agent instructions.

## Agreed requirements

### Supported environments

- The project may support any number of environments. For each environment advertised as supported, provide working installation and execution instructions and verify that the main scenario works there.
- Identify the relevant operating system, runtime or language version, and hardware requirements. Describe environment-specific commands or prerequisites where they differ; shared instructions are sufficient when they work unchanged.
- Distinguish intended but unverified environments from verified support. Do not claim compatibility based only on similar environments or a successful run on one CI runner. Report verification gaps and resolve the intended support scope with the student.

### Dependencies, setup, and execution

- Use the ecosystem's standard dependency declaration and a lock file when the chosen tool supports one. Include the versions of relevant external tools and system dependencies in the instructions.
- Provide verified commands for obtaining the project, preparing the environment, installing dependencies, and running the main scenario from an identified working directory. Identify manual prerequisites and steps that require external access.
- Give an example input and the expected observable result, such as an output file, application behavior, or metric. Include the commands needed to generate the reported result where applicable.
- Add setup or execution scripts when the sequence becomes complex or easy to misapply. A small project may use a short sequence of documented commands; a single command for everything is not required.

### Configuration

- Provide an example configuration without credentials or other secrets. Explain required parameters, where values come from, and reasonable defaults where possible.
- State which settings affect the result and how to supply them. Do not rely on unexplained values in the student's local environment or absolute paths specific to their machine.
- Keep actual secrets outside version control, following the [Git guidelines](git.md).

### Data and other inputs

- Identify the source, version or retrieval date, and acquisition procedure for required datasets, documents, models, and other inputs. Explain preparation steps and relevant input formats or directory locations.
- Preserve enough information to identify the inputs used for a reported result. If an upstream source can change, record a stable identifier or checksum when available and useful.
- For restricted or unavailable inputs, state the access requirements and the resulting reproduction limitation. Do not claim full reproduction if a required input is missing.
- A small example or substitute dataset can make a demonstration useful, but is not mandatory for every restricted dataset. Distinguish a demonstration on substitute inputs from reproduction of the original experiment.
- Respect existing storage and ignore rules. These guidelines do not require putting all data or large files in Git; see the [material-library rules](material-library.md) for reference documents.

### External services and resources

- Describe required services, API or model versions where identifiable, access requirements, and relevant usage limits. Identify resources such as a GPU, memory, storage, or paid access when they affect execution.
- State known or estimated runtime and costs when relevant, distinguishing estimates from measurements. Do not invent values or imply that execution is free when paid access is required.
- Add a local, free, or demonstration mode when it serves the project. Such a mode is not a universal requirement and must not be presented as reproducing results obtained with a different service or model.
- Identify aspects that cannot be fixed or reproduced exactly, such as an externally updated model, and explain their effect on the result.

### Research experiments

- Record the code revision when available, relevant local modifications, input versions, preparation steps, parameters, data splits, metrics, and substantial environment or library versions needed to repeat the experiment.
- Record random seeds where applicable and known sources of nondeterminism. A seed alone does not establish exact repeatability; state any remaining variability.
- Explain how the outputs are evaluated and what counts as reproducing the stated finding. Use justified tolerances or qualitative criteria when identical outputs are not expected.
- Match the procedure to the research question. Multiple runs and estimates of variability may be needed to support a conclusion, but this document does not prescribe the same number of runs for every experiment.

### Results and artifacts

- Keep the parameters and compact final results associated with each reported experiment so that tables, figures, and conclusions can be traced to a run.
- For large logs, models, intermediate files, or other artifacts needed to repeat or verify the result, identify their storage location and acquisition or regeneration procedure. State access restrictions or missing artifacts.
- Distinguish recorded results from expected outcomes and examples. Preserve the context of an earlier result when changing the setup; do not silently relabel it as a result of a new configuration.

### Minimal continuous integration

- For a project with code, provide a simple CI workflow using the project's hosting or CI service. Reuse an existing suitable workflow where possible. Configure it to check proposed code changes, for example on branch pushes and pull requests.
- Start with a small, relevant automated check: a linter, a formatter in check mode, a syntax check, or another lightweight check appropriate to the technology. Existing fast tests can also run there. Do not choose a check merely to produce a passing job.
- Use the declared runtime and dependency installation procedure. Document how to run the same checks locally and make a failing check fail the job.
- Keep the baseline runnable without Docker or a container build. Containers are not required by these guidelines; retain an existing project dependency on them only when the project itself needs it.
- Do not require the CI job to repeat long experiments or access paid services, restricted datasets, or special hardware. Use a suitable lightweight check and describe what still needs separate verification.
- A passing lint or syntax job does not prove that the application runs, that all supported environments work, or that research results were reproduced. Security scanning, deployment, and other advanced checks are outside this document's baseline and will be addressed separately.

## Additional recommendations

- Keep a concise entry point in the README with links to detailed instructions only where useful. No particular filename or additional document tree is mandatory.
- Prefer the simplest tools that meet the project's needs. Do not introduce containers, orchestration, or extra environments solely to satisfy a documentation template.
- Use a small, representative scenario for quick setup verification when practical, and clearly separate it from a full experimental run.

## How to verify and report

At a significant milestone, follow the documented main scenario in a clean environment or separate project copy, avoiding reliance on unexplained local files or configuration. Check each advertised supported environment, using CI or manual execution as appropriate. Verify the relevant inputs, commands, and expected outputs, not just the existence of an instruction file.

Report which environment and scenario were checked, the commands or procedure used, and the observed result. State which parts were not checked and why, including unavailable platforms, data, services, or resources. Do not equate a fresh copy using the same local dependencies with a verified fresh dependency installation.

Review the guidance against these scenarios:

| Scenario | Expected behavior |
| --- | --- |
| Two environments are advertised as supported | Provide applicable instructions and verify the main scenario in both; one successful CI job is insufficient evidence for the other environment. |
| A new environment is proposed but cannot be tested | Mark it as intended and unverified; discuss the support scope rather than presenting it as confirmed support. |
| A small command-line tool needs CI | Use a suitable lightweight check with documented local commands; do not add a container build just to meet the baseline. |
| An experiment requires restricted data or a paid API | Document access, inputs, parameters, and relevant costs; report reproduction limitations and use a demonstration mode only when useful. |
| Repeated runs produce different values | Record randomness and the evaluation procedure; distinguish justified variation from a failure to reproduce the finding. |
| A minor edit leaves the execution procedure unchanged | Apply relevant checks without repeating full reproduction or creating new documentation solely for the edit. |
| The agent can inspect a CI file but cannot run or observe the job | Report the configuration review and any local checks; do not claim that CI passed. |

These scenarios are review criteria for the guidance, not evidence of completed project or agent-client verification.
