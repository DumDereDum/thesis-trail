# Infrastructure

## When to apply

Use when CI/CD, environments, deployment, or operation is a substantive part of the work. A single Dockerfile or routine local setup does not require a full operational review.

## Baseline guidance

- Identify the components and environments being automated, their inputs, and the artifacts or services they produce.
- Demonstrate the main pipeline or deployment path and show how failed steps become visible rather than appearing successful.
- Explain configuration and secret handling, and distinguish disposable state from data that must survive replacement or restart.
- Check a relevant failure and recovery scenario at the scale of the project; identify what cannot yet be recovered automatically.

## When relevant

- For CI/CD, show which checks gate artifacts or deployment and how the tested artifact relates to what is released.
- For an operated service, observe relevant traffic, latency, errors, and resource pressure. Check rollback or data restoration when the work claims those capabilities.

## Related areas

- [Backend](../backend/README.md): application behavior; [security](../security/README.md): access and isolation properties.
- [Speech and audio](../speech-audio/README.md) or [machine learning](../machine-learning/README.md): quality of the models or processing being deployed.

Reference: [Google SRE: monitoring distributed systems](https://sre.google/sre-book/monitoring-distributed-systems/) for monitoring concepts; adapt the scope to the student project.
