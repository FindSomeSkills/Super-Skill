# Review Playbook: Code Review and Quality Gates

> Blends: obra/superpowers (dual gates + fix-loop cap), addyosmani (five axes + DoD×AC), Trail of Bits (evidence required).

## Review Is a Quality Gate; It Cannot Be Skipped

- Every merge gets reviewed: spec compliance + code quality, a dual gate where neither alone is enough.
- The reviewer receives a **carefully constructed artifact, not the conversation history**: the diff packaged into files, with a brief and a report, constraints passed to the reviewer verbatim.
- No prejudging ("do not flag" is cheating); don't ask to re-run tests the implementer already ran.

## Five-Axis Review

1. **Correctness** (logic, edge cases, concurrency) 2. **Readability** (naming, structure) 3. **Architecture** (responsibilities, coupling) 4. **Security** (input validation, permissions) 5. **Performance** (complexity, N+1)

- Review the tests first, then the implementation; finally "verify the reviewer's verification story".
- Triage: Critical / fix immediately; Important / must fix; Minor-Nit / record and defer. Rank findings by impact: correctness and security first, structural regressions next, cosmetic opinions last.
- Classify by risk, not by size: "Small PR, quick review" is an excuse; **Heartbleed was only 2 lines**.
- Every finding states: root cause (why it is wrong) -> data flow path -> line/commit evidence. Vague findings train readers to ignore real ones.

## Fix Loops (obra: maximum 5 rounds)

- Rounds 1-3 go back to the original implementer (context intact); rounds 4-5 hand off to someone stronger ("three failed rounds mean the failure is structural").
- After 5 rounds a breaker arbitrates: reviewer wrong/debatable -> park and record a Ruling; valid but no downstream dependency -> park; valid and load-bearing -> minimal ruling carried into the next task.
- At final findings, dispatch **one** fix agent and run **one** scoped re-review; no second wave.

## When Receiving Review

- **Verify first, then implement; performative agreement is banned** ("You're absolutely right!" is an explicit violation; no thanking, "actions speak").
- For external reviewers, check 5 things first: technical correctness / destructiveness / why the original implementation exists / platform compatibility / the reviewer's context, then act.
- For multi-item feedback, clarify all unclear items before acting; dispute resolution hierarchy: technical facts > style guide > engineering principles > consistency.
- "I'll clean this up later" is not acceptable.

## Two-Layer Completion Standard (Addy)

- **Acceptance Criteria (AC)**: answers "did we do it right" (per-task, up to 3 testable items).
- **Definition of Done (DoD)**: answers "did we meet the bar" (project-level and standing; the same bar for every change: correctness/quality/integration/docs/shippability).
- Both must be met for completion. "A DoD renegotiated every iteration is not a DoD."
- Approval bar: "approve a change when it definitely improves overall code health, even if it isn't perfect"; review honestly, no rubber-stamping, quantify problems ("N+1 adds +50ms per item"), guard against sycophancy.

## Change Size

~100 lines good / ~300 acceptable / ~1000 must be split; refactors and features go in **separate commits**.

## Key Sentences

- "Review early, review often."
- "Approve a change when it definitely improves overall code health, even if it isn't perfect."
- "LGTM without evidence of review helps no one."
- "A clean review is a valid review." / "Vague findings train the reader to ignore real ones."
