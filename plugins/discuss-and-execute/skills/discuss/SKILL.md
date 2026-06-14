---
description: >-
  Interactive session that surfaces gray areas and captures implementation
  decisions into .context/CONTEXT-<SLUG>.md before planning begins. Pass
  --auto for an automated panel discussion with three AI stakeholders instead
  of interactive Q&A. Requires .context/codebase/ (run /gather-context first).
  <triggers>
    /discuss, run discuss, discuss grey areas, surface gray areas,
    talk through implementation decisions, scope this ticket,
    clarify ambiguities before planning, discuss --auto, panel discussion
  </triggers>
---

# Discuss

Surface what matters before a line of code is written — conventions to follow, concerns to avoid, and decisions to lock. This step saves the most time: 20 minutes here prevents hours of rework after review.

**Requires:** `.context/codebase/` (run `/gather-context` first)

**Modes:**

- **Interactive (default):** You make every decision through a guided Q&A
- **Auto (`--auto`):** Three AI stakeholders debate and reach consensus on your behalf

Both modes produce the same output: `.context/CONTEXT-<SLUG>.md` + `.context/DISCUSSION_LOG-<SLUG>.md`

<philosophy>
**User = founder/visionary. Claude = builder.**

The user knows:

- How they imagine it working
- What it should look/feel like
- What's essential vs nice-to-have
- Specific behaviors or references they have in mind

The user doesn't know (and shouldn't be asked):

- Codebase patterns (read from the codebase map)
- Technical risks (identify these yourself)
- Implementation approach (figure this out during implementation)
- Success metrics (infer from the work)
  </philosophy>

<scope_guardrail>
**CRITICAL: No scope creep.**

The work description is the scope boundary. Discussion clarifies HOW to implement what's scoped, never WHETHER to add new capabilities.

**The heuristic:** Does this clarify how we implement what's already scoped, or does it add a new capability that could be its own task?

**When user suggests scope creep:** Note it as a deferred idea, redirect to current scope.
</scope_guardrail>

## Step 0: Verify and Route

```bash
ls .context/codebase/*.md 2>/dev/null && echo "MAP_EXISTS" || echo "NO_MAP"
```

**If NO_MAP:** Tell user to run `/gather-context` first. Stop.

**If `--auto` in arguments:**
Read `$CLAUDE_PLUGIN_ROOT/skills/discuss/references/auto-mode.md` and follow that process.

**Otherwise:**
Read `$CLAUDE_PLUGIN_ROOT/skills/discuss/references/interactive-mode.md` and follow that process.
