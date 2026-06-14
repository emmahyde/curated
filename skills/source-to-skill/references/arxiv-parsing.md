# arXiv Paper Parsing Reference

Full AST traversal approach for extracting actionable patterns from arXiv papers. Loaded when Step 1 encounters an arxiv.org URL.

## Fetch strategy

Always use the abs URL form, not the PDF URL: `https://arxiv.org/abs/XXXX.XXXXX`. The abs page renders as structured HTML that context-mode converts to clean markdown with section headings intact. The PDF URL returns binary that requires extraction tooling. If only a PDF URL is given, derive the abs URL by replacing `/pdf/` with `/abs/` and stripping `.pdf`.

```
ctx_fetch_and_index(url="https://arxiv.org/abs/XXXX.XXXXX", label="paper-title")
```

After indexing, use `ctx_search` to probe the structure before loading sections: `ctx_search(queries=["methods", "algorithm", "evaluation", "results", "conclusion"])`.

## AST section extraction

Run `mcp__codemode__ast` on the indexed markdown to extract the heading tree. The AST call returns a node list — filter for heading nodes (h1, h2, h3) to build the section inventory without loading body text.

Expected section tree for a typical ML/systems paper:

```
Abstract
1. Introduction
2. Background / Related Work
3. Method / Approach / Architecture
4. Implementation / System Design
5. Experiments / Evaluation
6. Results / Analysis
7. Discussion / Limitations
8. Conclusion
References / Appendix
```

Map each discovered section to this canonical template. Sections that don't fit (e.g. "Theoretical Analysis", "Proof of Theorem 1") are usually `background` or `none` for skill-generation purposes.

## Section annotation schema

For each section, assign two fields:

**functionality** — what capability, technique, mechanism, or procedure this section describes that could inform how an agent uses or implements the paper's contribution. Write as a gerund phrase: "describing the attention routing mechanism", "specifying the fine-tuning procedure", "listing hyperparameter search space". If the section has no agent-actionable content, write "none".

**result_contribution** — how directly this section supports the paper's core claims:
- `core` — contains the primary method, algorithm, or system design; removing it breaks the paper's argument
- `supporting` — contains experiments, ablations, or analysis that validate the core claim
- `background` — context, related work, motivation; useful for terminology but not for technique extraction
- `none` — proofs, appendices, acknowledgments, references; skip entirely

## Section map output format

```
| Section | Functionality | Contribution |
|---------|--------------|--------------|
| Abstract | summarizing the main claim and approach | core |
| 1. Introduction | motivating the problem; states main contributions | supporting |
| 2. Related Work | situating vs. prior art; terminology anchoring | background |
| 3. Method | describing the core algorithm/architecture | core |
| 4. Experiments | specifying evaluation setup and baselines | supporting |
| 5. Results | reporting quantitative findings | supporting |
| 6. Conclusion | restating claims; noting limitations | background |
```

## Selective deep-read

After building the section map, load only `core` sections in full. For `supporting` sections, load only the subsections that contain the evaluation setup and key quantitative results (tables, figures captions). Skip `background` and `none` entirely unless a specific term or concept from a `core` section requires clarification.

Use `ctx_search` for targeted lookup rather than re-reading sections: `ctx_search(queries=["evaluation metric", "dataset", "baseline comparison"])`.

## Extraction targets for skill generation

From a paper, extract:
- **Core algorithm or procedure** (from `core` sections): the step-by-step method an agent would implement or invoke. Write as a numbered procedure, not prose.
- **Key terminology** (from abstract + `core` sections): terms the authors invented or use distinctively — these become the strongest triggers.
- **Evaluation conditions** (from `supporting` sections): what inputs, datasets, or conditions the method was tested on — defines the scope of the generated skill.
- **Stated limitations** (from discussion/conclusion): these become the skill's scope boundary and prevent over-promising.
- **Do NOT extract**: proofs, theoretical guarantees, comparison tables between baselines (those are results evidence, not agent-actionable patterns).

## Ambiguity check for papers

Papers are especially prone to terminology overload — the same word means different things in different subfields. For each extracted term, note its definition as used in this paper specifically, not the general field definition. Flag any term that conflicts with common usage as `[TERM CONFLICT]` in the ambiguity log.
