# Web development

## When to apply

Use for browser interfaces, web clients, and PWAs. Server-only APIs belong to backend; a product called a platform does not necessarily have a browser interface.

## Baseline guidance

- Identify the main user flows and the browsers and screen sizes used for verification.
- Demonstrate those flows, including relevant loading, empty, error, and recovery states.
- Check navigation and form behavior, including invalid input and accidental repeated actions.
- Check keyboard access, visible focus, meaningful control labels, and readable content in the main flows.

## When relevant

- For a PWA, check the claimed installation, offline, caching, and update behavior. For browser performance comparisons, use comparable workloads and report the device and browser conditions.

## Related areas

- [Backend](../backend/README.md): server logic, APIs, and persistent state.
- [Security](../security/README.md): access control and protection properties.

Reference: [W3C WAI tutorials](https://www.w3.org/WAI/tutorials/) for accessibility checks appropriate to the interface.
