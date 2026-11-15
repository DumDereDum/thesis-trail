# Networks

## When to apply

Use for routing, protocols, tunneling, isolation, and traffic-processing components. An ordinary application using HTTP does not by itself require network-system evaluation.

## Baseline guidance

- Describe the topology, component roles, configuration, and expected paths or handling of traffic.
- Verify intended forwarding, routing, or filtering behavior with representative traffic and observable results.
- State traffic characteristics and test conditions when reporting throughput, latency, or loss; distinguish the tested component from limits of the test setup.
- Check relevant failure and configuration-change scenarios, including their effect on existing flows.

## When relevant

- For tunnels or traffic isolation, check permitted and prohibited paths and relevant encapsulation constraints.
- For centralized control, check how configuration reaches forwarding components and what happens during an incomplete or failed update.

## Related areas

- [Security](../security/README.md): firewall, IDS, and other protection properties.
- [Systems programming](../systems-programming/README.md): low-level components; [backend](../backend/README.md): management services.
