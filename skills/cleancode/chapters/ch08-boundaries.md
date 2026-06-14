# Chapter 8: Boundaries

## Core Idea
Every system integrates foreign code — third-party packages, open source, or internal subsystems outside your control. The discipline of clean boundaries is about keeping that integration from spreading its complexity into your core: wrap, adapt, and test at the seam so change stays local.

## Frameworks Introduced
- **Learning Tests**: Write isolated tests that call a third-party API exactly as you intend to use it in production — controlled experiments to lock in your understanding of that API.
  - When to use: Whenever adopting a new third-party library; run the same tests against each new release to catch breaking changes before integration does.
- **Boundary Wrapper (encapsulation)**: Hide a boundary interface (e.g. `Map`) inside a class whose public API exposes only the operations your application actually needs.
  - When to use: Any time a third-party interface is broader than your use case, or when you're passing that interface across multiple call sites.
- **Adapter Pattern at Unknown Boundaries**: Define the interface *you wish existed*, implement your code against it, then write an Adapter once the real API is available.
  - When to use: When a dependency is undefined or controlled by another team — define your own `Transmitter` interface, keep working, bridge it later with `TransmitterAdapter`.

## Key Concepts
- **Provider/User Tension**: Third-party providers optimize for *broad applicability*; users need *focused, constrained interfaces* — this mismatch is the root problem at every boundary.
- **Boundary Interface**: Any API surface you don't own — `java.util.Map`, a logging framework, a hardware subsystem's API.
- **Learning Test**: A test that exercises third-party code to confirm your understanding, doubles as a regression guard across library upgrades.
- **Outbound Boundary Test**: A test that exercises the third-party interface the same way production code does, kept alongside or after integration, to detect incompatible upgrades early.
- **Seam**: A point in the codebase where you can substitute one implementation for another without changing surrounding code — the Adapter creates a natural seam for testing.

## Mental Models
1. **Depend on what you control.** It's better to depend on an interface you own than one you don't. The uncontrolled interface will change on someone else's schedule; your wrapper absorbs that shock at one place.
2. **Minimize boundary surface area.** Have as few places in the codebase as possible that know the third-party particulars. A boundary that leaks into 40 call sites costs 40x to migrate; one confined to a single class costs one.
3. **Learning before integrating, not during.** Debugging integration failures and learning an unfamiliar API simultaneously is doubly hard. Spike with learning tests first; integrate once the API behavior is understood and verified.
4. **Design the interface you wish you had.** When the real API doesn't exist yet, writing your ideal interface keeps code expressive and unblocked. It also clarifies your requirements for the team implementing the other side.

## Anti-patterns
- **Passing boundary types through public APIs**: Returning or accepting `Map<Sensor>` from public methods spreads the third-party coupling to every caller. When the `Map` interface changes (e.g., generics in Java 5), every call site breaks.
- **Experimenting in production code**: Reading documentation then writing exploratory third-party calls directly inside production classes mixes learning with integration — bugs become ambiguous (yours or theirs?), and the experiments leave residue.
- **No outbound tests**: Without boundary tests exercising the third-party API, there is no early warning when a library upgrade introduces incompatible behavior changes. You discover breakage in production.
- **Letting third-party specifics spread**: Allowing low-level details (casting, generics workarounds, log4j configuration) to scatter across the codebase makes every future upgrade a system-wide refactor.

## Code Examples
```java
public class Sensors {
    private Map sensors = new HashMap();

    public Sensor getById(String id) {
        return (Sensor) sensors.get(id);
    }
    // snip
}
```
- **What it demonstrates**: The `Map` boundary interface is hidden as a private field; callers interact only with the domain-typed `getById` method, making generics changes, casting, and `clear()` exposure an internal concern.

## Key Takeaways
1. Third-party interfaces are too broad by design — wrap them so your application only sees the subset it needs and can enforce its own rules.
2. Learning tests cost nothing: you had to learn the API anyway; the tests encode that knowledge and become a free regression harness for every future upgrade.
3. Unknown or unavailable dependencies are not blockers — define the ideal interface yourself, implement against it, and bridge the gap with an Adapter when the real API arrives.
4. Minimize the number of places that touch a boundary type; every extra call site is future maintenance debt when the third-party code changes.
5. Clean boundaries mean fewer maintenance points, more internally consistent usage, and code that expresses your domain rather than the vendor's API surface.

## Connects To
- **Ch 9 (Unit Tests)**: Learning tests are unit tests for third-party code; the same discipline of fast, isolated, expressive tests applies — clean tests and clean boundaries reinforce each other.
- **Ch 11 (Systems)**: System-level design separates construction from use; the Adapter pattern and boundary wrapping are concrete tactics for enforcing that separation at integration seams.
- **Ch 17 (Smells and Heuristics)**: Exposing third-party types in public APIs is a concrete code smell; this chapter provides the fix — wrap and hide.
