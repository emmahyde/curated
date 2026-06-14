# Audit Rubric — scales, lenses, and prompt templates

Table of contents:
- Grade scale
- The three lenses
- Severity tiers
- Grader prompt template (one expert per criterion)
- Verifier prompt template (one skeptic per weakness)
- Scorecard output template

## Grade scale

Each criterion gets ONE overall grade. Same scale for code and plans.

| Grade | Score | Meaning |
|-------|-------|---------|
| A | 4 | Exemplary — actively embodies the criterion. |
| B | 3 | Solid — follows it; only minor gaps. |
| C | 2 | Mixed — partially follows; real gaps. |
| D | 1 | Weak — largely violates the criterion. |
| F | 0 | Violation — directly contradicts it. |
| N/A | — | Criterion does not apply to this target (excluded from the average). |

A grade of **C or worse produces a draft weakness.** The overall verdict is the mean score of the graded (non-N/A) criteria, mapped back to a letter.

## The three lenses

Every expert applies all three to its single criterion, then resolves them into the one grade above.

1. **Adherence** — Does the target follow this criterion? This is the spine of the grade. Cite specific evidence (a line, a construct, a step), not a vibe.
2. **Severity** — If it's violated, how costly is the violation in this context? Feeds the weakness's severity tier, not the grade directly. Use the book's own cost framing where the criterion supplies one (e.g. cost-of-change, opportunity cost).
3. **Applicability (steelman / skeptic)** — Is this criterion genuinely relevant here, or would penalizing the target be a false positive? If the criterion doesn't apply, return **N/A** with a one-line reason rather than a low grade. This lens is the false-positive guard at grading time; Step 5 is the second guard.

## Severity tiers

For each draft weakness, assign one — roughly (how central the criterion is) × (Severity lens):

- **Critical** — violates a core framework in a way that will cause bugs or block an imminent change.
- **High** — clear violation of an important criterion; meaningful future cost.
- **Medium** — real but localized; worth fixing, not urgent.
- **Low** — minor or stylistic; note it, don't insist.

## Grader prompt template (one expert per criterion)

Dispatch one `Agent` (general-purpose, sonnet) per kept criterion. Fill every placeholder; both the criterion AND the target text must be inline — the expert sees nothing else.

```
You are a single expert on one evaluation criterion, grading a piece of work. Judge ONLY against your assigned criterion; ignore everything else.

CRITERION: <criterion name>
SOURCE: <file + section / Ch N from the knowledge skill>
RULE STATEMENT: <the full rule, verbatim from SKILL.md / patterns.md / the chapter>

TARGET KIND: <diff | file | dir | repo | plan>
TARGET:
<the full target content — diff text, file body, or plan prose>

Apply three lenses, then return one grade:
1. ADHERENCE — does the target follow the rule? Cite specific evidence (file:line for code; "step N" or a short quote for a plan).
2. SEVERITY — if violated, how costly here? Use the rule's own cost framing if it has one.
3. APPLICABILITY — is this criterion genuinely relevant to this target? If not, grade N/A with a one-line reason.

Return EXACTLY this structure (no extra prose):
GRADE: <A|B|C|D|F|N/A>
ADHERENCE: <1-2 sentences with concrete evidence>
APPLICABILITY: <relevant | N/A because ...>
STRENGTH: <one thing the target does well re: this criterion, or "none">
WEAKNESS: <if GRADE is C/D/F: location | what's wrong | why it matters (tie to the rule) | concrete fix | suggested severity Critical/High/Medium/Low. If GRADE A/B/N/A: "none">
```

## Verifier prompt template (one skeptic per weakness)

Dispatch one `Agent` (general-purpose, sonnet) per draft weakness. The skeptic's job is to REFUTE — default to upholding only what survives scrutiny. For a thorough audit, run 3 skeptics per weakness and uphold on majority.

```
You are a skeptical reviewer. Try to REFUTE the weakness below. Default to "refuted" if the evidence is thin, the criterion is misapplied, or the code/plan was misread.

CRITERION: <name> — <rule statement>
TARGET KIND: <diff | file | dir | repo | plan>
TARGET:
<the full target content>

CLAIMED WEAKNESS:
<location | what's wrong | why it matters | proposed fix | severity>

Check: (a) Is the criterion actually relevant here? (b) Is the evidence real and correctly read? (c) Is this a genuine violation, or acceptable in context? (d) Is the severity right?

Return EXACTLY:
VERDICT: <upheld | refuted>
REASON: <1-2 sentences>
ADJUSTED_SEVERITY: <Critical|High|Medium|Low|unchanged>
```

## Scorecard output template

Render this after Step 5. Keep prose minimal; the table and ranked list carry the value.

```markdown
# Audit: <target description> against /<knowledge-skill>

**Target:** <diff / path / plan> · **Criteria evaluated:** <N> of <M candidates> · **Mode:** <full | degraded>

## Scorecard
| # | Criterion | Source | Grade | Finding |
|---|-----------|--------|-------|---------|
| 1 | <name> | <file · Ch N> | <A–F> | <one-line> |
...

**Overall: <letter> (<mean score>/4)** — <one-line verdict>

## Weaknesses (verified, ranked by severity)
### [Critical] <title> — violates <criterion>
- **Location:** <file:line | step N | "quote">
- **Problem:** <what's wrong>
- **Why it matters:** <tie to the rule's rationale>
- **Fix:** <concrete change>
- **Confidence:** <upheld k/n skeptics>

(repeat, Critical → Low; omit the section if none survived verification)

## Strengths
- <criterion>: <what the target does well>

## Not applicable
- <criterion> — <why it was judged N/A or dropped in gating>
```
