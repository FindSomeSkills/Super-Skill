# Research Playbook: Deep Research and Information Synthesis

> Blends: mvanhorn/last30days (timeliness-gated research, five phases), ECC deep-research/market-research (decision-oriented), ComposioHQ content-research-writer (research writing), Browserbase company-research (anti-inference).

## Five-Phase Pipeline

### Phase A: Intent Parsing
Extract TOPIC / TARGET_TOOL / QUERY_TYPE (PROMPTING / RECOMMENDATIONS / NEWS / COMPARISON / GENERAL). Comparison queries must resolve each entity individually.

### Phase B: Query Quality Precheck (kill bad queries before searching)
Detect five keyword traps: demographic shopping phrasing ("gift for 42 year old man"), number/age conflict words, over-literal concept phrasing ("how to use Docker" vs. the community saying "my Docker setup"), generic single nouns ("sneakers" with no anchor), and non-Latin topics. On a hit, rewrite or ask a clarifying question: "Running the engine on a doomed query burns 5+ minutes and produces junk."

### Phase C: Pre-Research (entity-level resolution before searching)
- Use 2-3 searches to locate entities: main X account plus company/founder accounts, GitHub username (person-mode to gauge PR velocity), GitHub repo (pull live star counts), Reddit community (dedicated vs. broad), and force expansion into peer subreddits of the category.
- **First-party positioning must be scraped live from the official site, never from memory**: "homepages and positioning go stale."

### Phase D: Query Plan
Produce a JSON plan: 1-4 subqueries, each with a keyword-dense `search_query` + a natural-language `ranking_query` + a source list + weights (primary 1.0 / secondary 0.6-0.8 / fringe 0.3-0.5). Hard rules: `search_query` never contains time words; easily-confused entities get per-query disambiguation anchors.

### Phase E: Engine Execution + Post-Fill
- Search platforms in parallel, use real engagement data (upvotes/views), hard-filter by date, dedupe URLs.
- After the run, do 2-3 more follow-up searches (separate budget) for blog posts, long-form writing, and critical reactions; append every supplementary retrieval to the log so any claim can be traced back to a source.

## Multi-Source Cross-Validation

- **Cluster first**: cluster by story/theme rather than by source. Cross-source clusters across Reddit+X+YouTube beat single sources.
- **Confidence labels**: `Uncertainty: single-source` (single platform, low confidence) / `Uncertainty: thin-evidence` (everything below threshold, unconfirmed).
- **Source weighting**: Reddit/X highest (engagement data), YouTube/TikTok high, Web lowest; **top comments beat the main post**; X reply clusters are the strongest community endorsement.
- Prediction-market odds are high-signal data (real money); report percentages only, never volume.
- For recommendations, rank by **signal quality, not mention count**: practitioner testimony (5) > authority endorsement or quantifiable claims (4) > reasoned comparisons (3) > multi-source convergence (2) > descriptive mentions (1) > promotional content (0). "The failure mode for RECOMMENDATIONS queries is 'counting when you should have judged.'"

## Timeliness Discipline

- Hard date filtering; `--days=N`/`--as-of` lookback; `--verify-freshness` to double-check.
- Windowed phrasing: "keep claims windowed - 'this month's conversation' - never trend verbs."
- Distinguish "no results" from "not found": `no-results` = the source ran clean and matched nothing; `partial/rate-limited/auth-failed` = unconfirmed this run. Never write "nothing on X" for those states.
- **"Nothing solid this window" is a valid answer**: report it faithfully, never retry or fabricate a topic.
- **Close with the six-phase learning method** (Waza/learn): collect (primary sources only) → digest (three-question check: appears in two contexts / can it predict / is it domain consensus) → outline (attach sources to every section) → fill in (stuck = weak mental model, go back to the source) → refine (delete only, never write new content) → **human final review: the user reads the whole piece linearly twice; the AI must not read it on their behalf**; when sources conflict, keep both positions, never silently pick a side.

## Knowledge-Retrieval Discipline (kb-retriever / deep-dive)

- **Layered index navigation**: walk `data_structure.md` at every level of the directory tree, narrow the candidate set by navigation before searching, never load whole files; check directory existence with `test -d`, not Glob.
- **Progressive retrieval**: 3-8 keywords (including synonyms and hypernyms/hyponyms) → precise grep scoping → read only the few dozen lines around each hit → save "filename + location + snippet" (`file:line` provenance); **at most 5 unified iteration rounds**; if information is insufficient, state it plainly rather than fabricating.
- **Learn before processing**: when you hit PDF/Excel or similar formats, first read the handling method (pdftotext/pdfplumber/pandas) before acting, with a mandatory checklist.
- **DAG research**: decompose the problem into a graph of sub-questions with `depends_on` edges, fan out in topological waves in parallel, and feed each wave's gap analysis back as new sub-questions; persist sources to JSON to survive context compression.
- **Anti-inference**: do not infer product description, industry, or audience from fonts, framework, or design system: "These are cosmetic and say nothing about what the company sells." If you don't know, write `Unknown`.

## Ten Anti-Hallucination Rules (hard discipline)

1. Every claim needs a source; assertions without one are forbidden.
2. Mark single-source claims as unverified.
3. Acknowledge gaps: "If you couldn't find good info on a sub-question, say so."
4. Keep facts, inferences, and recommendations in separate evidence classes; never mislabel them.
5. Fresh answers must not come from stale memory: "do not answer current questions from stale memory when fresh search is cheap."
6. Ground synthesis in actual retrieval results, not prior knowledge (never describe product A as product B).
7. Never guess-reconstruct citation URLs; quotes verbatim, attributed to their authors.
8. Do not narrate tool mechanics in output ("the engine found nothing"); state only facts about the topic.
9. Label numbers without a source as estimates; date old data explicitly; include counter-evidence and downside risks.
10. Escalate in layers: do not run the heavy pipeline for questions answerable locally.

## Report Templates

### Deep Research Report Skeleton
```
# [Topic]: Research Report
*Generated: [date] | Sources: [N] | Confidence: [High/Medium/Low]*
Executive Summary (3-5 sentences) → topic sections (inline citations [Source](url)) → Key Takeaways → Sources ([Title](url) with a one-line description) → Methodology
```

### Decision-Oriented Skeleton (market-research)
executive summary → key findings → implications → risks and caveats → recommendation → sources. Quality Gate: numbers sourced, old data dated, recommendations derived from evidence, counterarguments included, decisions made easier. "Produce research that supports decisions, not research theater."

### Timeliness Query Plan JSON (last30days Step 0.75)
```json
{"intent":"RECOMMENDATIONS","freshness_mode":"balanced_recent","cluster_mode":true,
 "subqueries":[{"label":"main","search_query":"keyword-dense query (no time words)",
   "ranking_query":"natural-language question","sources":["reddit","x","youtube","hackernews"],"weight":1.0}]}
```
Hard rules: `search_query` never contains time words; easily-confused entities get per-query disambiguation anchors ("kevin rose digg founder" instead of "kevin rose").

### Community Brief Output Contract (last30days)
Badge on the first line (`🌐 last30days v{v} · synced {YYYY-MM-DD}`) → `What I learned:` bolded heading narrative (one strongest quote per paragraph) → `KEY PATTERNS` numbered list → engine stats passed through verbatim → invite follow-up questions (with 2-3 examples grounded in actual findings). Comparison type: Quick Verdict → Community Sentiment/Strengths/Weaknesses per entity → Head-to-Head table → The Bottom Line.

### Evidence-Boundary Report (research-ops)
`QUESTION TYPE` (factual/comparison/enrichment/monitoring) → `EVIDENCE` (sourced facts / user-provided context) → `INFERENCE` (what follows from the evidence) → `RECOMMENDATION` (an answer or next step, plus whether to switch to monitoring). Facts, inferences, and recommendations are separate evidence classes; never mix labels.

## Key Lines

- "Google aggregates editors. /last30days searches people."
- "Multi-source clusters are highest confidence."
- "Every claim needs a source. No unsourced assertions."
- "If you don't know, say 'insufficient data found.'"
- "NEVER infer product_description from a site's fonts or framework; these are cosmetic and say nothing about what the company sells."
