# LLM systems

## When to apply

Use for applications built on language models, including RAG and LLM-based agents. An unspecified AI or multiagent system is not necessarily LLM-based; training is not a prerequisite for this area.

## Baseline guidance

- Define the intended tasks, supported inputs, and what counts as an acceptable or incorrect result.
- Record the model or service version where available, prompts, generation settings, and external information or tools used.
- Evaluate representative cases, including failures and unsupported requests, against a suitable simpler approach or existing system. Do not treat fluent output as evidence of correctness.
- Check result quality alongside latency and cost or resource use where these affect the intended application.

## When relevant

- For RAG, identify the corpus and its update process; evaluate retrieval separately from answer quality, check support for cited claims, and include questions the corpus cannot answer.
- For agents, define available actions, their authority, stopping conditions, and failure recovery; assess completed tasks and unintended actions rather than conversation quality alone.
- When information or tools have access restrictions, apply the relevant security guidance to retrieved content, model inputs, and actions.

## Related areas

- [Security](../security/README.md): trust boundaries, access, and protection checks; [backend](../backend/README.md): service behavior.
- [Machine learning](../machine-learning/README.md): model training or comparative model evaluation; [speech and audio](../speech-audio/README.md): voice interaction.
