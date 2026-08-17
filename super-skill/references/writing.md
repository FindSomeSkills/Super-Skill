# Writing Playbook: Writing and Documentation

> Blends: Waza/write (de-AI'd writing), ComposioHQ content-research-writer (research writing), Anthropic doc-coauthoring (reader testing), taste-skill (copy standards).

## Writing Without an AI Flavor (Waza/write core)

- "Do not improve vocabulary; remove the performance of improvement." Cut repetition, summary-voice, and re-stated conclusions.
- Every piece of writing must have a "speaker"; if it flows so smoothly that anyone could have written it, that is a flaw. **Fluency that cannot be attributed to anyone is itself a flaw.**
- **No em-dashes (U+2014)**: the strongest AI-voice fingerprint; use plain hyphens only.
- Three forceful edits beat thirty mechanical replacements; output only the final text, with no edit commentary.
- The rules are a smell catalog, not a lookup table: no mechanical list-based replacements.
- **Red-line guardrails**: never add AI attribution to public text; approval of a draft or plan ≠ authorization to write (approval covers direction, not execution); no AI traces in external-facing text.

## Research-Writing Workflow (content-research-writer)

### 1. Topic Selection / Framing (six clarifying questions)
Topic and main thesis / target audience / length and format / purpose (educate/persuade/entertain/explain) / existing research or sources / writing style.

### 2. Outline
Hook → Introduction → Main Sections (each: key point + example/evidence + `[Research needed: topic]` placeholder + counterargument and wrap-up) → Conclusion → **Research To-Do list** (`- [ ] Find data on X`). Provide 3 Hook options (bold statement / personal story / surprising data).

### 3. Collection
Research section by section, output Key Findings (numbered points with citations [1][2][3]) + Citations (author/year/publication), and backfill the outline. Save separate files: outline.md / research.md / draft-vN.md / final.md / feedback.md / sources/.

### 4. Drafting
Write section by section, get feedback section by section. Feedback template: What Works Well ✓ → improvements along four axes (Clarity/Flow/Evidence/Style) → Specific Line Edits (exact quote of the original line → suggestion → why).

### 5. Voice Preservation
"Suggest, don't replace"; "Enhance, don't override"; periodically ask yourself "Does this sound like you?"

### 6. Final Review
Full Draft Review (structural flow / argument strength / evidence sufficiency / citation completeness) + Pre-Publish Checklist: All claims sourced / Citations formatted / Examples clear / Transitions smooth / Call to action present / Proofread.

## Reader Testing (Anthropic doc-coauthoring)

- Run 5-10 realistic reader questions through a fresh Claude with zero context; check for ambiguity, wrong assumptions, and self-contradiction.
- Pass criterion: "Reader Claude consistently answers questions correctly and doesn't surface new gaps or ambiguities."

## Academic Paper Writing Essentials (Research-Paper-Writing-Skills et al.)

- Decide the target venue (conference/journal) first, since it dictates format and length; write the Abstract last.
- Related Work, three questions: who we differ from / boundary of the contribution / complete citations. Contributions must be verifiable (experiment, proof, or dataset).
- Figures and tables must be self-explanatory: full-sentence titles, explicit axis labels, one consistent color scheme.
- Avoid AI-flavored academic filler: use "delve/comprehensive/leverage" sparingly; state the method's contributions and limitations directly.

## Documents / ADR

- Decision records (ADR): Nygard format, Context/Decision/Alternatives/Consequences. **Rejected alternatives and their reasons are mandatory**: "the rationale matters more than the what". Keep them readable in 2 minutes.
- Changelogs are for humans: group by Added/Changed/Fixed/Deprecated/Removed/Security, newest first, written in the same commit as the change.

## Productivity-Writing Variants (ComposioHQ)

**Resume tailoring** (tailored-resume-generator): parse the JD into three tiers, P1 required / P2 important / P3 nice-to-have → map each experience item (including transferable skills, de-emphasizing gaps) → format each entry as **[Action Verb]+[What]+[How/Why]+[Result/Impact]** (quantification required) → **ATS optimization** (standard headings, precise keywords woven in naturally, no tables/images/headers/footers, abbreviations paired with full names); honesty floor: never fabricate.

**Meeting insights** (meeting-insights-analyzer): transcript → behavioral data (conflict-avoidance hedgings, "maybe/kind of", topic deflection, uncommitted agreement; speaking share / interruption count; filler-phrase frequency; active listening; leadership style). Back every finding with a **timestamped verbatim quote**, in a three-part structure: What Happened / Why This Matters / Better Approach.

## Key Lines

- "Do not improve vocabulary; remove the performance of improvement."
- "A piece has a speaker."
- "Suggest, don't replace… Enhance, don't override."
- "AI-generated cute copy is worse than boring copy."
