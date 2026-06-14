# Auto Mode (`--auto`)

Replaces interactive Q&A with a multi-stakeholder panel discussion. Three AI agents with distinct technical perspectives debate the implementation approach across multiple waves and produce consensus recommendations.

## Step 1: Scope and Scout

If work description provided as argument (after `--auto`), use it. Otherwise ask:

```
What should the panel discuss?
```

Then run the same codebase scout as interactive mode:

- Load prior context from existing `CONTEXT-*.md` files
- Read CONVENTIONS.md, CONCERNS.md, TESTING.md, ARCHITECTURE.md, STRUCTURE.md, STACK.md, INTEGRATIONS.md
- Build `<codebase_context>` with reusable assets, patterns, concerns, conventions

**Surface to user** (same italic format as interactive mode):

```
_Assimilating codebase context..._
_Architecture: [1-line summary]_
_Conventions: [key patterns]_
_Concerns: [relevant items]_
_Stack: [languages, frameworks]_
_Integrations: [external services in scope]_
```

## Step 2: Generate Stakeholders

Based on the work description and codebase context, generate three technical stakeholders with distinct perspectives. Each has:

- **Name and role** — concrete, not generic (e.g., "Priya, senior Rails engineer who owns the Ops layer" not "Backend Developer")
- **Expertise** — what they know deeply
- **Bias** — what they'll push for (performance? correctness? simplicity? test coverage?)
- **Concern** — what they'll worry about

Choose perspectives that create productive tension for THIS specific work:

| Work Type              | Good Panel                                                                         |
| ---------------------- | ---------------------------------------------------------------------------------- |
| New API endpoint       | API architect, domain model owner, QA automation lead                              |
| Frontend feature       | React component author, accessibility specialist, design system maintainer         |
| Database migration     | DBA/performance engineer, Rails migration expert, data integrity advocate          |
| Background job         | Sidekiq/infrastructure engineer, domain logic owner, monitoring/observability lead |
| Cross-cutting refactor | System architect, test coverage advocate, product engineer who uses the code daily |

## Step 3: Run Discussion Waves

Spawn all three stakeholders as `sonnet` agents. Run at least 2 waves.

**Surface progress** as each wave completes:

```
_Panel Wave 1: initial positions from [Name A], [Name B], [Name C]..._
_Panel Wave 2: debate and convergence..._
```

**Persist each wave's responses** to `.context/research/panel-<SLUG>-wave-<N>.md` so the full discussion is durable beyond the DISCUSSION_LOG.

**Wave 1 — Initial Positions:**

Prompt each stakeholder simultaneously:

```
You are [Name], [Role]. Your expertise: [expertise]. You tend to push for [bias]. Your concern: [concern].

Context:
- Work: [work description]
- Architecture: [from ARCHITECTURE.md — layers, patterns, data flow, entry points]
- Structure: [from STRUCTURE.md — directory layout, where new code belongs]
- Codebase conventions: [from CONVENTIONS.md]
- Known concerns: [from CONCERNS.md]
- Reusable assets: [from codebase_context — existing helpers, components, utilities]
- Testing patterns: [from TESTING.md]
- Tech stack: [from STACK.md — languages, frameworks, key dependencies]
- Integrations: [from INTEGRATIONS.md — external APIs, databases, event systems]

Artifact structure your recommendations will feed into:
```

.context/
CONTEXT-<SLUG>.md # locked decisions (your consensus goes here)
DISCUSSION_LOG-<SLUG>.md # full transcript of this panel
PLAN-<SLUG>.md # wave plan generated from your recommendations

```

Given this work, provide:
1. Your recommended implementation approach (2-3 sentences)
2. What you'd decompose this into (rough task list)
3. Your top concern or risk
4. What convention or pattern MUST be followed
5. What existing code should be reused

Keep it concise — you'll debate with two other stakeholders next.
```

**Wave 2 — Debate and Convergence:**

Send each stakeholder the other two's Wave 1 responses:

```
Here are your colleagues' positions:

[Stakeholder B]: [their Wave 1 response]
[Stakeholder C]: [their Wave 1 response]

Before revising your position:
1. Identify the strongest objection to EACH colleague's proposal
2. State what risk or cost their approach introduces that yours avoids

Then:
3. Where do you now agree, having considered their arguments?
4. Where do you still disagree, and why does your concern outweigh theirs?
5. Produce a revised recommendation that accounts for their input

Flag any unresolved disagreements — these become decision points for the user.
```

**Wave 3+ (if needed):** Run additional waves focused on specific disagreements. Max 4 waves total — if consensus isn't reached, record the disagreement with each stakeholder's position.

## Step 4: Synthesize Consensus

After the final wave, synthesize:

1. **Agreed approach** — what all three converged on
2. **Agreed task decomposition** — rough wave structure for `/plan-waves`
3. **Conventions to enforce** — specific patterns the panel flagged
4. **Concerns to watch** — specific items the panel flagged
5. **Reusable code** — existing assets identified
6. **Unresolved disagreements** — positions that didn't converge, with each stance

## Step 5: Write Documents

Generate slug from work description (lowercase, hyphens, max 40 chars).

Write `.context/CONTEXT-<SLUG>.md` using the panel's consensus as the decisions section. Include the stakeholder recommendations in the canonical refs.

Write `.context/DISCUSSION_LOG-<SLUG>.md` with the full panel transcript:

```markdown
# Discussion Log: [Work Description]

**Date:** [YYYY-MM-DD]
**Mode:** Panel discussion (--auto)
**Stakeholders:**

- [Name], [Role] — bias: [bias]
- [Name], [Role] — bias: [bias]
- [Name], [Role] — bias: [bias]

---

## Wave 1: Initial Positions

### [Stakeholder A]

[full response]

### [Stakeholder B]

[full response]

### [Stakeholder C]

[full response]

---

## Wave 2: Debate and Convergence

### [Stakeholder A] (revised)

[full response]

### [Stakeholder B] (revised)

[full response]

### [Stakeholder C] (revised)

[full response]

---

## Consensus

[synthesized consensus]

## Unresolved Disagreements

[list or "None — full consensus reached"]
```

## Step 6: Present Results

```
Panel discussion complete (3 stakeholders, [N] waves).

Consensus:
[summary of agreed approach]

Recommended waves:
[rough task structure]

Flagged conventions: [list]
Flagged concerns: [list]
Unresolved: [list or "None"]

Full transcript: .context/DISCUSSION_LOG-<SLUG>.md

Next: /plan-waves <SLUG>
```
