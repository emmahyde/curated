# Opinion Process

The scientific procedure for turning a fetched corpus into an evidence-backed
opinion, plus the Research Brief template to append to `corpus-summary.md`.

## Contents

- [Why scientific](#why-scientific)
- [Procedure](#procedure)
- [Confidence calibration](#confidence-calibration)
- [Source-quality weighting](#source-quality-weighting)
- [Research Brief template](#research-brief-template)

## Why scientific

A book report restates what sources said. An opinion takes a position and
defends it against its own counter-evidence. The difference is method: form a
hypothesis first, then actively hunt the corpus for what would falsify it. An
opinion that never engaged its counter-evidence is not yet an opinion.

## Procedure

Work from the fetched `pages/NN-*.md` files only. Search snippets are not
evidence — they were discarded after Phase 1.

1. **Hypothesis.** State the most likely answer to the research question in one
   sentence, before reading deeply. This is the claim under test.

2. **Evidence pass.** Read every page file. For each relevant claim, record:
   the claim, the page file it came from, and whether it *supports* or
   *challenges* the hypothesis. Hunt as hard for challenges as for support — a
   pass that found only supporting evidence was a biased pass; redo it.

3. **Conflict resolution.** Where pages disagree, do not average them. Name the
   conflict, weigh the sources (see weighting below), and state which side wins
   and why — or declare it genuinely unresolved.

4. **Revise or keep.** If evidence broke the hypothesis, replace it with the
   answer the evidence actually supports. Revising is success, not failure.

5. **State the opinion.** Give the final position, a calibrated confidence
   level, and an explicit *falsifier* — the concrete finding that would change
   the conclusion. An opinion with no stated falsifier is overconfident.

## Confidence calibration

| Confidence | Warranted when |
|------------|----------------|
| High | Multiple independent quality sources agree; little credible dissent |
| Medium | Sources mostly agree, or one strong source with no contradiction |
| Low | Sources thin, dated, conflicting, or mostly secondary |
| Speculative | Corpus does not really answer the question; say so plainly |

Thin or conflicting corpora produce Low-confidence opinions. That is an honest
result — do not inflate it, and do not search more to chase a higher number.

## Source-quality weighting

Rank evidence when sources conflict:

1. Primary sources — specs, papers, official docs, original data, source code.
2. Named experts writing in their domain, with reasoning shown.
3. Substantive secondary analysis citing its own sources.
4. General articles, anonymous posts, marketing content — weak; corroboration
   only, never decisive.

Recency matters for fast-moving topics; note publication dates when they bear
on the conclusion. Flag any claim that rests on a single weak source.

## Research Brief template

Append this section verbatim (filled in) to the end of `corpus-summary.md`:

```markdown
---

## Research Brief

**Question:** <the one-sentence research question>

**Opinion:** <the position taken — direct, no hedging>

**Confidence:** High | Medium | Low | Speculative — <one line of justification>

**Reasoning:**
<2-5 sentences: the hypothesis, what the evidence did to it, how conflicts were
resolved. Cite page files inline, e.g. (03-example-com.md).>

**Key evidence:**
- <claim> — supports — `pages/NN-*.md`
- <claim> — challenges — `pages/NN-*.md`

**Conflicts / unknowns:**
- <disagreement between sources and how it was resolved, or what stayed open>

**Would change this opinion:** <the concrete finding that would flip or weaken
the conclusion>

**Corpus limits:** <searches spent vs budget; fetch failures; coverage gaps>
```

If a `method: failed` row in the corpus index would have carried evidence the
opinion needed, say so under "Corpus limits" — never let a silent fetch failure
masquerade as an absence of evidence.
