# Trigger Synthesis Reference

How to derive and validate trigger phrases. Loaded during Step 5 when trigger selection is ambiguous.

## The core rule

Triggers must come from the source's own language — the terms, commands, and phrases its own documentation uses. Never invent category descriptions like "data processing tool" or "infrastructure management" — these are too broad and will cause the skill to fire on unrelated requests.

## Extraction method

Read the source with this question: "what exact string would a user type when they need this tool?" Answers fall into three tiers:

**Tier 1 — Command names and binary names** (strongest triggers): the tool's own name and its subcommands. These are exact and unambiguous. `kubectl`, `kubectl apply`, `kubectl get pods`, `gh pr create`. Include the full subcommand form when it's the primary use case.

**Tier 2 — Syntax tokens** (medium strength): operators, syntax patterns, or flags that are distinctive to this tool. `jq '.[]'`, `SELECT ... FROM`, `--dry-run`, `terraform plan`. These catch users who paste a command and ask for help without naming the tool.

**Tier 3 — Domain verbs** (weakest, use sparingly): actions strongly associated with the tool. "apply a migration", "drain a node", "cherry-pick a commit". Only include if the tool has a near-monopoly on this action in its domain.

## Validation: the cross-trigger test

For each candidate trigger, ask: "would this phrase also reasonably trigger a different installed skill?" If yes, it's too broad. Examples of triggers that fail this test:

- "working with JSON" — too broad, fires for Python, curl, databases
- "deploy to production" — fires for any deployment skill
- "manage containers" — fires for docker, podman, k8s, compose

Examples that pass: "`kubectl`", "`.[] | select`", "`gh pr`", "`jq -r`", "`terraform apply`".

## Description template

```
"<one sentence: what the skill enables, using the tool's own name>.
Use when the user mentions <term1>, <term2>, asks to <verb from source>, or uses syntax like <token>."
```

The second sentence is the trigger sentence. It must contain at least one Tier 1 trigger (tool name or subcommand). Add Tier 2 only if the tool has distinctive syntax. Add Tier 3 only if needed to cover common phrasings.

## Research validation

After drafting triggers, cross-check against research finds from Step 2: if the top-starred repos in the domain never use a candidate term in their READMEs or issues, drop it. If a term appears in every README, it's load-bearing.

## Length budget

The description is loaded into every session alongside all other skill descriptions. Keep it under 200 words. If the trigger list is long, move domain context to the skill body and keep only the strongest 4–6 triggers in the description.
