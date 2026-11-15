# Game development

## When to apply

Use when game mechanics, rules, game state, or player interaction are part of the work. A points counter or a game-like product name alone does not establish this scope.

## Baseline guidance

- Explain the core play loop, allowed actions, state transitions, and completion or progression rules.
- Demonstrate a playable scenario and check invalid actions, restarting, and relevant edge cases in the rules.
- State the target platform and assess whether responsiveness supports the intended play experience.
- Use play observations or an appropriate evaluation to support claims about usability or engagement; a working build alone does not demonstrate them.

## When relevant

- For multiplayer play, identify the authority over shared state and check competing actions, joining, leaving, and disconnections.
- If progress persists, verify saving and restoring it. Check timing or randomness only to the extent needed for the game's rules and claims.

## Related areas

- [Backend](../backend/README.md): server coordination and persistent shared state.
- [Mobile](../mobile/README.md) or [web](../web/README.md): behavior specific to the client platform.
