# Security

## When to apply

Use for security-focused work or specific protection properties in another project. Select the relevant properties; adding a login form does not by itself require a full security research project.

## Baseline guidance

- Identify the assets, actors, trust boundaries, and threat assumptions relevant to the claimed protection.
- State the intended security properties and their limits; distinguish assumptions about dependencies from properties the work verifies.
- Check both intended access and relevant prohibited behavior with evidence tied to those properties.
- Use established mechanisms and authoritative documentation for security-sensitive choices; explain the basis for cryptographic claims rather than inferring them from a library name.

## When relevant

- For intentionally vulnerable examples, define the intended weakness, expected observation, and containment of the demonstration environment.
- For RAG or agents, treat retrieved material and model output according to their trust level; check that they cannot grant access or action authority beyond the application's rules.

## Related areas

- [Mobile](../mobile/README.md), [backend](../backend/README.md), or [networks](../networks/README.md): the component whose protection is evaluated.
- [Infrastructure](../infrastructure/README.md): isolation and operation of demonstration or deployment environments.

Reference: [OWASP threat modeling](https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html) for relating assets, threats, and mitigations.
