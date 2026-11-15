# Backend development

## When to apply

Use for server applications, APIs, business logic, and persistent data, including servers for mobile clients. Browser-only behavior belongs to web. This area does not prescribe microservices or distributed deployment.

## Baseline guidance

- Describe the main operations, their inputs and outputs, and the business rules they preserve.
- Identify the operation's invariants and any persistent-data relationships; check successful operations and invalid or conflicting requests.
- Make failures visible to callers without exposing internal secrets, and define how retries affect state.
- Demonstrate the main scenario through the actual service boundary; verify outputs and, when data is persisted, the resulting stored state.

## When relevant

- For competing bookings, bids, or edits, check concurrent and repeated requests against the business rules; distinguish an operation from its delivery attempts.
- When making load or latency claims, measure a representative workload and report response times, throughput, failures, and resource conditions. Do not infer scalability from a single-user demonstration.

## Related areas

- [Web](../web/README.md) or [mobile](../mobile/README.md): the relevant client behavior.
- [Infrastructure](../infrastructure/README.md): deployment and operation; [security](../security/README.md): access control and protection properties.
