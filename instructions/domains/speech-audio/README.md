# Speech and audio

## When to apply

Use for speech recognition, synthesis, speaker analysis, and audio processing or visualization. This includes non-learned signal processing; merely playing an audio file does not require this area's full guidance.

## Baseline guidance

- Define the task and expected output, including relevant languages, speakers, recording conditions, and input audio format.
- Explain preprocessing and reference-data conventions so quality measures have a clear meaning.
- Use task-appropriate checks and representative listening or error analysis; report where noise or recording differences affect results.
- Keep related recordings and speakers from invalidating evaluation comparisons when independent generalization is claimed.

## When relevant

- For streaming or interactive systems, measure latency under stated input and hardware conditions, including buffering and interruptions.
- For LLM correction of recognized speech, compare outputs before and after correction and check whether meaning or factual details changed.

## Related areas

- [Machine learning](../machine-learning/README.md): learned model development or evaluation; [LLM systems](../llm/README.md): language-model components.
- [Infrastructure](../infrastructure/README.md): production operation; [computer vision](../computer-vision/README.md): visual components of multimodal systems.
