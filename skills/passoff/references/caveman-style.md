# Caveman Style — Vendored Reference for Passoff

Distilled from the `caveman` plugin. Vendored here so passoff works without the plugin installed.

## Intent

Cut token usage ~50-75% in passoff body lines while keeping full technical fidelity. Apply to every prose-bearing line; leave code, commands, paths, errors, and identifiers untouched.

## Core Rules

**Drop:**
- Articles: `a`, `an`, `the`
- Filler: `just`, `really`, `basically`, `actually`, `simply`, `quite`, `very`
- Pleasantries: `sure`, `certainly`, `of course`, `happy to`, `let me`
- Hedging: `might be`, `it seems`, `perhaps`, `I think`
- Copulas where unambiguous: `is`, `are`, `was` (when subject obvious)

**Keep:**
- Fragments OK. Sentence structure not required.
- Short synonyms over long phrases: `fix` not `implement a fix for`, `big` not `extensive`, `cut` not `eliminate`.
- Technical terms exact. Never abbreviate API names, function names, type names.
- Code blocks unchanged.
- Error messages quoted exact.

**Pattern:**
```
[thing] [action] [reason]
[thing] [state] [next step]
```

## Examples (passoff-flavored)

| Verbose | Caveman |
|---------|---------|
| There is a bug in the auth middleware where the token expiry check uses `<` instead of `<=` | `Bug @auth/mw.py:84 — token expiry uses < not <=` |
| We need to add a length gate before doing the cosine comparison | `length-gate before cosine cmp` |
| The reason for batching is to avoid running out of memory | `because avoid OOM` |
| This task is currently blocked because the upstream dependency has not yet been released | `blocked: upstream not released` |
| It would be a good idea to write a regression test for this case | `regression test for short-note dedup` |

## Intensity for Passoff

Always **full** level (not lite, not ultra). Reasoning:
- **lite** keeps articles → 30-40% of savings lost.
- **full** matches passoff goals: dense, scannable, fragments fine.
- **ultra** abbreviates (`DB`, `auth`, `cfg`) which is fine, but cross-project ambiguity risk; only use when the audience is one specific project's agents.

## Auto-Clarity (when to break style)

Switch to normal prose for:
1. **Destructive `RESUME` commands.** If the resume command drops data, force-pushes, etc., write a normal-prose warning line above it.
2. **Multi-step sequences** where fragment ordering could be misread.
3. **Open questions whose meaning would change with normal grammar.** Better to spend tokens than be misunderstood.

After the clarity-required part, resume caveman.

Example:
```
## RESUME
Warning: this drops the local replay_db. Confirm backup exists at ~/.claude/memory/backups/ before running.
$ rm -rf eval/recall/replay_db && python3 scripts/evolve.py --rebuild
```

## Boundaries (do NOT compress)

- Code blocks / fenced examples
- Shell commands
- File paths, line numbers, commit shas
- Error message strings
- Environment variable names and values
- Function/class/type identifiers
- Markdown headers (`##`, `###`)
- Section labels in the template (`NOW`, `NEXT`, `RESUME`, etc.)

## Anti-patterns

- ✗ Compressing identifiers: `consol_dedup` instead of `consolidator dedup` — readability cost > token savings.
- ✗ Dropping `because`/`> ` reason markers: the reason itself is high-signal, even if terse.
- ✗ Caveman-ing a warning: `delete prod data` reads ambiguously; spell out.
- ✗ Fragmenting so hard the next agent can't reconstruct: `cosine .95 short` — too lossy. Aim for `cosine ≥0.95 false-positive on short notes`.

## Self-check

Before emitting a passoff, scan each line and ask:
1. Any articles I can drop? (the/a/an)
2. Any copulas redundant?
3. Any filler words?
4. Could a shorter synonym carry the same meaning?
5. Is anything now ambiguous? If yes, restore.

If a line still reads as a normal English sentence with helping verbs, it's not compressed enough — unless it's a warning, in which case leave it.
