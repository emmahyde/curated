# Fit-Mapping Reference

Extended guide for choosing skill shape and degree-of-freedom. Loaded when the Step 4 decision is non-obvious.

## Degree-of-freedom decision tree

Start here:

```
Does the source have commands with exact, non-negotiable syntax?
  YES → LOW freedom (literal commands in skill body)
  NO  → Does the source define a preferred sequence with some configurability?
    YES → MEDIUM freedom (pseudocode with parameters, named decision points)
    NO  → HIGH freedom (text-based heuristics, principles)
```

## Shape × Freedom matrix with examples

| Shape | Freedom | Example source | What the skill body looks like |
|-------|---------|---------------|-------------------------------|
| workflow | low | bash script, kubectl, git subcommands | verbatim command blocks, exact flags |
| workflow | medium | CI/CD pipeline, deploy checklist | step names + configurable parameters |
| reference | high | architecture guide, design principles | bullet principles + "use X when Y" rules |
| integration | medium | Stripe API, GitHub API | auth block + endpoint index + request shapes |
| hybrid | medium | terraform (commands + concepts) | command quick-ref upfront, concept sidebar after |

## Edge cases

**Tool with both exact commands AND abstract concepts** (e.g. terraform, ansible): use hybrid. Put the command reference in a `references/commands.md` and keep the conceptual workflow in SKILL.md body. Freedom = medium for the workflow, low for the command reference.

**API with 200+ endpoints**: don't try to index all of them. Extract the 5–10 endpoints that appear in >80% of real usage (check GitHub issues and Stack Overflow for the source). Put the full index in `references/endpoints.md` and load it on demand.

**Script with no --help output**: treat as a black box — read the source code, extract function signatures and meaningful variable names, infer the intended workflow. Freedom = low, but derive commands from source code not documentation.

**Source is itself a skill or prompt template**: extract its trigger phrases, step structure, and output format. The generated skill wraps those patterns, not the raw text.

## Anti-patterns in freedom selection

- **High freedom for CLI tools**: giving Claude latitude on exact flag names leads to hallucinated flags that look plausible but don't exist.
- **Low freedom for conceptual workflows**: rigid step ordering for tasks that are inherently iterative (debugging, refactoring) frustrates users who need to adapt the sequence.
- **Mixed freedom without separation**: if SKILL.md mixes literal commands and abstract guidance in the same section, Claude can't tell which parts require precision.
