# Skill Authoring: Creating High-Quality Skills

> Distilled from: Anthropic skill-creator (official spec), alchaincyf/darwin-skill (evolution loop), trailofbits skill-improver.

## What a Skill Is

A reusable, task-specific instruction package: a folder containing `SKILL.md` (YAML frontmatter + Markdown instructions), optionally bundling `scripts/` (deterministic execution code), `references/` (load-on-demand docs), and `assets/` (files for outputs).
**Skill ≠ MCP ≠ tool**: MCP answers "how to connect to external systems", a tool is "a single callable function", and a Skill defines "what to do, in what order, with what guardrails". The three-way split: "MCP for access, tools for actions, skills for behavior."

## Frontmatter

- `name` + `description` are required. The description is the **primary triggering mechanism**; it must include both "what it does" and "when to use it".
- The description should be "pushy" to counter under-triggering: expand "How to build a simple fast dashboard" to add "Make sure to use this skill whenever the user mentions dashboards, data visualization, internal metrics… even if they don't explicitly ask for a 'dashboard.'"
- For complex triggers, use a `TRIGGER` block to list trigger words, plus `SKIP` rules to list exemptions.
- Optional: `whenToUse`, `metadata`, `license`.

## Structure and Granularity (Three-Level Progressive Disclosure Loading)

1. Metadata (name+description) is always in context (~100 words)
2. The SKILL.md body loads when triggered (ideally <500 lines; add hierarchy levels as you approach the limit)
3. Bundled resources load on demand (scripts can be executed without being read into context)

- Multi-domain skills organize references by variant (aws.md/gcp.md/azure.md); "Claude reads only the relevant reference file".
- Large references (>300 lines) come with a table of contents; keep SKILL.md under 500 lines.

## Writing Style

- Use the imperative mood; **"explain why" replaces ALL-CAPS MUST**: "Try to explain to the model why things are important in lieu of heavy-handed musty MUSTs."
- If you catch yourself writing ALL-CAPS ALWAYS/NEVER or hyper-rigid structures, that is a yellow flag; refactor and explain the reasoning instead.
- Define formats with output templates ("ALWAYS use this exact template") and Input/Output examples.
- The no-surprise principle: "A skill's contents should not surprise the user in their intent if described." No malicious or exploit code.
- Waza style: "Each skill states the outcome, the red lines, and how the result gets verified, then steps back and lets the model choose the path." (write the outcome/red lines/verification; don't hard-code the path)

## Testing and Iteration (The Skill-Creator Core Loop)

1. Write a draft → create 2-3 realistic test prompts (stored in evals/evals.json; no assertions yet)
2. **Spawn two subagents in parallel in the same round**: with the skill vs a baseline without it (when improving an existing skill, point the baseline at a snapshot)
3. Add assertions while they run (objectively verifiable, descriptively named; subjective skills go to human qualitative review)
4. Capture total_tokens/duration_ms; a grader subagent scores (grading.json: text/passed/evidence)
5. Aggregate into benchmark.json (pass_rate/duration/tokens, mean±stddev+delta)
6. Read the feedback and iterate: **generalize** (a skill will be used a million times; don't overfit to your samples; for stubborn problems, change the metaphor or working model instead of adding tighter MUSTs); **trim the prompt** (read the transcripts and cut paragraphs that produced no value); **explain why**.
7. Fold repetitive work into scripts: "If all 3 test cases resulted in the subagent writing a `create_docx.py`, that's a strong signal the skill should bundle that script."

## Trigger Optimization (The 20-Query Method)

- Build 20 queries: 8-10 should trigger + 8-10 should not. The should-trigger set covers different phrasings, cases where the user doesn't name the skill but clearly needs it, and head-to-head matchups with competing skills that this one should win.
- The most valuable should-not-trigger cases are **near-misses** (shared keywords but actually a different task); unrelated negatives are meaningless.
- 60% train / 40% held out, 3 runs per query, at most 5 rounds; pick best_description by test score to avoid overfitting.
- "Claude only consults skills for tasks it can't easily handle on its own… Simple queries like 'read file X' are poor test cases." (test queries must have substance)

## MCP Builder Essentials (Agent Tool Development)

- Four phases: deep research and planning → implementation → review and test → create evaluations. Quality is measured by "how well it lets an LLM complete real tasks".
- **API coverage vs workflow tools**: when unsure, prefer broad API coverage (freedom to compose), but also build high-value workflow tools (e.g. schedule_event combines "check availability + create event").
- Tool naming: consistent prefix + action-oriented (github_create_issue); tight descriptions, filtering/pagination, focused return data: **treat the agent's context budget as a scarce resource**.
- Actionable error messages: steer toward the fix ("Try using filter='active_only'"), educational rather than purely diagnostic.
- Recommended stack: TypeScript+Zod; remote streamable HTTP + stateless JSON, local stdio. Annotations: readOnlyHint/destructiveHint/idempotentHint/openWorldHint.
- Testing note: **MCP is a long-running process; running it directly in the foreground hangs**: use tmux, `timeout 5s`, or an evaluation harness.
- Five agent-centric principles: Build for Workflows, Optimize for Limited Context, Design Actionable Error Messages, Follow Natural Task Subdivisions, **Use Evaluation-Driven Development** (the agent's real performance feeds back into tool improvements).

## Evolution Loop (Darwin-Skill Philosophy)

Evaluate → improve → test → keep or roll back: every skill version enters the benchmark, and a regression rolls back; treat "training a skill" like "training a program".

## Key Lines

- "This is the primary triggering mechanism - include both what the skill does AND specific contexts for when to use it."
- "A green recalc proves your formulas *evaluate*, not that they are *right*." (the verification principle applies to every artifact)
- "Always run scripts with `--help` first. DO NOT read the source… They exist to be called directly as black-box scripts rather than ingested into your context window."
