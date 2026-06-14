# Interactive Mode

The default `/discuss` flow. The user makes every implementation decision through guided Q&A.

## Step 1: Scope the Work

If work description provided as argument, use it. Otherwise ask:

```
What are you about to work on?

Describe the feature, bug fix, or task. Be as specific or vague as you like —
I'll ask follow-up questions based on what I find in the codebase.
```

Capture as the **work description** — the scope anchor for all discussion.

## Step 2: Load Prior Context

```bash
ls .context/CONTEXT-*.md 2>/dev/null || true
```

For each existing CONTEXT-\*.md, extract `## Implementation Decisions` and `## Specific Ideas`. Build internal `<prior_decisions>` context.

- Skip gray areas already decided in prior contexts
- Annotate options with prior decisions ("You chose X in [previous context]")
- **When prior decisions conflict:** Present explicitly and ask user to keep, override, or discuss. Record the resolution.

## Step 3: Scout Codebase Map

Read all relevant `.context/codebase/` docs based on work description:

- **CONVENTIONS.md** — extract conventions that apply to this work (naming, patterns, error handling)
- **CONCERNS.md** — flag concerns that overlap with files/areas this work will touch
- **TESTING.md** — note the test framework, patterns, and run commands
- **ARCHITECTURE.md** / **STRUCTURE.md** — identify integration points and where new code belongs

Build internal `<codebase_context>`:

- **Reusable assets** — existing helpers, components, utilities with file paths
- **Established patterns** — mandatory vs conventional
- **Integration points** — specific files and extension patterns
- **Creative options** — what the codebase makes easy vs hard (most valuable part)
- **Concerns that apply** — fragile areas, tech debt, known issues in scope
- **Conventions to follow** — relevant rules from CONVENTIONS.md

**Initialize canonical refs accumulator** from specs/ADRs found in codebase map. Accumulate throughout discussion when user references docs.

## Step 4: Surface Relevant Findings

Print the codebase findings as quiet context — the user should see what's being assimilated without it feeling like a presentation. Use subdued formatting (no headers, no bold labels, no "here's what I found"):

```
_Assimilating codebase context..._
_Architecture: [1-line summary of where this work fits]_
_Conventions: [key patterns that apply]_
_Concerns: [relevant items, if any]_
_Reusable: [existing code to extend, if any]_
_Testing: [framework and patterns]_
```

Omit lines where nothing relevant was found. This is input, not output — move directly to gray areas after printing.

## Step 5: Research Gray Areas

Spawn parallel `researcher` agents (one per gray area candidate) for technical tradeoffs, library choices, or architectural decisions. Each returns a comparison table: `| Approach | Pros | Cons | Fit for this codebase |`

**Skip research** for pure preference decisions (naming, visual layout).

**If Agent tool unavailable:** Do inline structured comparison using your own knowledge.

**Persist results:** Write each researcher's output to `.context/research/{topic-slug}.md` so it's durable across sessions.

**Surface to user:** When presenting gray areas (Step 7), include the relevant research table inline with each area. The user should see the tradeoff analysis that informed the options — not just the options alone.

## Step 6: Identify & Filter Gray Areas

Use `prior_decisions`, `codebase_context`, and research results.

1. **Domain boundary** — State what this work delivers
2. **Check prior decisions** — Don't re-ask what's already decided
3. **Understand the domain type:**
   - Users SEE -> presentation, interactions, states
   - Users CALL -> contracts, responses, errors
   - Users RUN -> invocation, output, behavior modes
   - Users READ -> structure, tone, depth, flow
   - Being ORGANIZED -> criteria, grouping, exceptions
4. **Generate 3-5 specific gray areas** — Not generic categories. Annotate with code context.
5. **Skip assessment** — If no meaningful gray areas exist, proceed directly to writing context.

## Step 7: Present Gray Areas

State the domain boundary and prior decisions. Then use AskUserQuestion (multiSelect: true) with 3-5 gray areas annotated with code context and prior decisions.

Read `$CLAUDE_PLUGIN_ROOT/skills/discuss/references/discussion-patterns.md` for annotation patterns and domain-specific examples.

**Do NOT include "skip" or "you decide"** in area selection.

## Step 8: Interactive Discussion

<answer_validation>
After every AskUserQuestion, check for empty response — retry once, then fall back to plain-text numbered list. If AskUserQuestion unavailable, use plain-text throughout.
</answer_validation>

**For each selected area:**

1. Announce the area
2. Ask 3-4 questions via AskUserQuestion with concrete options, code annotations, and research tables where available. Include "You decide" when Claude can reasonably choose.
3. Check: "More questions about [area], or move on? (Remaining: [others])"
4. After all areas: "Explore more gray areas" / "I'm ready for context"

**Question design:** Concrete options, each answer informs the next. "Other" -> plain text follow-up, not another AskUserQuestion.

**Scope creep:** Redirect to deferred ideas, return to current question.

**Canonical refs:** When user references any doc during discussion, read it, add to accumulator, use to inform subsequent questions.

**Track internally:** area, options presented, user's selection, notes — for DISCUSSION_LOG.

## Step 9: Write Context Document

Generate slug from work description (lowercase, hyphens, max 40 chars).

Read `$CLAUDE_PLUGIN_ROOT/skills/discuss/references/output-templates.md` for CONTEXT and DISCUSSION_LOG templates.

Write both `.context/CONTEXT-<SLUG>.md` and `.context/DISCUSSION_LOG-<SLUG>.md`.

## Step 10: Confirm and Present

Show summary of decisions captured, deferred ideas, and next steps. See output-templates.md for format.
