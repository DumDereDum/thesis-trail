# Machine learning

## When to apply

Use when developing or evaluating learned models, including comparisons of pretrained models. Calling a model API does not by itself require training a model or running every procedure here.

## Baseline guidance

- Define the prediction or learning task, the data and labels available, and metrics that reflect the intended use.
- Separate development and final evaluation data appropriately; account for time, users, or related samples when they could leak information between sets.
- Compare with a relevant simple method or existing model under comparable conditions, and examine representative errors rather than only an aggregate score.
- Record the evaluated model and data versions, preprocessing, and settings needed to interpret the results.

## When relevant

- When training or tuning, fit preprocessing on training data and keep final evaluation data out of model selection. Assess run-to-run variation when it could change a conclusion.
- For deployment claims, measure inference quality together with relevant latency and resource use under the target conditions.

## Related areas

- [Data analysis](../data-analysis/README.md): analytical preparation and interpretation.
- [Computer vision](../computer-vision/README.md), [speech and audio](../speech-audio/README.md), or [LLM systems](../llm/README.md): task-specific quality checks.

Reference: [scikit-learn common pitfalls](https://scikit-learn.org/stable/common_pitfalls.html) for preprocessing and leakage examples; the guidance does not require that library.
