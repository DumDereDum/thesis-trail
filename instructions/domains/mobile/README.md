# Mobile development

## When to apply

Use for native and cross-platform mobile applications. Analyzing another application's technology stack alone does not activate this area.

## Baseline guidance

- State the target platforms and OS versions, and identify devices or emulators used for verification.
- Demonstrate the main user flow and relevant failure cases on those targets.
- Check navigation and state preservation when the application is interrupted and resumed.
- Identify what data is stored locally and what should survive restarting the application; verify that behavior.

## When relevant

- If networking is used, define and check behavior on connection loss, retry, and incomplete synchronization.
- If permissions or device capabilities are needed, explain their purpose and handle denial or unavailability.

## Related areas

- [Backend](../backend/README.md): when developing a server for the application.
- [Security](../security/README.md): access control and protection of local or transferred data.

Reference: [Android core app quality](https://developer.android.com/docs/quality-guidelines/core-app-quality) for relevant Android checks; use the chosen platform's guidance for other targets.
