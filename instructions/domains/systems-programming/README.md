# Systems programming

## When to apply

Use for system components, cross-language libraries, runtime integration, and interface generators such as IDL tooling. A programming language or ordinary dependency alone does not select this area.

## Baseline guidance

- Define the component boundary, supported environments, and public interface or generated output.
- Describe relevant type mappings, resource ownership and lifetimes, and error propagation across that boundary.
- Demonstrate representative calls or generated interfaces and check edge cases such as invalid inputs and partial failures.
- Verify compatibility claims against the supported versions and architectures; distinguish source-level interfaces from binary compatibility where relevant.

## When relevant

- For FFI or concurrent components, check memory and thread assumptions across runtimes, including cleanup after errors.
- For generators, check that representative generated output compiles or is accepted by its consumer and behaves according to the declared interface. Measure overhead if performance is part of the claim.

## Related areas

- [Networks](../networks/README.md): traffic-processing components.
- [Security](../security/README.md): security-sensitive boundaries; [infrastructure](../infrastructure/README.md): build and release automation.
