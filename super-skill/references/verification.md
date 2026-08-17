# Verification Playbook: Verification and Completion

> Blends: obra/superpowers (evidence iron rule), ECC verification-loop/delivery-gate (mechanical gates), addyosmani (shipping gate).

## Evidence Iron Rules

- You cannot claim something passes unless you ran the full command **in the same message** and read the output.
- No "should/probably/seems to"; no "Done!" before verifying.
- An agent reporting success is not completion: independently check the VCS diff.
- Regression tests run the red-green loop: write -> pass -> revert the fix and the test must fail -> restore -> pass.

### Rationalizations to Reject

| Excuse | Reality |
|---|---|
| "Too simple to test" | Simple code breaks. |
| "Small PR, quick review" | Heartbleed was 2 lines. Classify by risk, not size. |
| "Keep as reference" | You'll adapt it. Delete means delete. |
| "I remember this skill" | Skills evolve. Read the current version. |
| "skip tests for now" | Gate warning: declaring completion without verification is a violation. |
| "This doesn't need a formal plan" | Planning is the task; implementation without a plan is just typing. |
| "I'll clean this up later" | Not acceptable: clean it up now or record it as a task. |
| "I feel like it works" | Feelings are not evidence. Run the command and read the output. |

## Six-Phase Wrap-Up Verification (ECC verification-loop)

1. build (build passes) -> 2. type (type check) -> 3. lint -> 4. test (coverage 80%+) -> 5. security scan -> 6. diff review.
Produce a VERIFICATION REPORT: READY / NOT READY for PR. In long sessions, set a mental checkpoint every 15 minutes.

## Mechanical Gates (delivery-gate idea)

- Mechanical gates check machine-verifiable facts, not self-reports: "same pattern as CI pipeline gates."
- Rationalization patterns get regex-intercepted: "skip tests for now" only warns.
- Above a complexity threshold, the verification report must be complete before declaring completion.
- Decision collection iron rule: **never silently choose for the user**: list each item independently with recommendation + rationale + alternatives; never bundle them into "is everything OK?".
- **Self-check -> fix -> re-report**: any quality finding must be applied to the artifact per the failing items before reporting. "Reporting raw findings without fixing = violation."

## Shipping Gate (Addy shipping-and-launch)

### Pre-Release Checklist (Six Domains)
Code quality / security / performance / accessibility / infrastructure / docs.

### Feature Flag Lifecycle
OFF deploy -> internal -> 5% -> 25% -> 50% -> 100% -> cleanup. Flags need an owner and an expiry date; clean up within 2 weeks; no nesting.

### Rollback Plan (Write It Before Deploying)
Trigger conditions, steps, database rollback, time budget. Canary threshold table: error rate >2x baseline -> roll back; P95 >50% -> roll back.

### First-Hour Post-Launch Verification
Health check, error rate, latency, critical flows, logs, rollback drill.

## Git Wrap-Up Discipline

- Don't start work directly on main/master; create an isolated worktree before starting.
- At wrap-up, present 3 options to a human (merge locally / push a PR / keep); after merging, re-run tests on the merged result ("a green run only proves the tree it ran on").
- Atomic commits: one logical change per commit; write why in the message, not what; a commit is a save point (tests pass -> commit; fail -> revert).
- semver is a promise; tags are the source of truth; hygiene before committing (`git diff --staged`, grep for secrets).

## Five-Axis Self-Check (ECC agent-self-evaluation)

After the task, self-assess on five axes (accuracy/completeness/clarity/actionability/conciseness), each axis backed by concrete evidence, on a 1-5 scorecard. Not a pass/fail gate but a reflection step against overconfidence.

## Key Sentences

- "Evidence before claims, always."
- "If you haven't run the verification command in this message, you cannot claim it passes."
- "'It's done, I just haven't run it yet': unverified work is not done."
- "A result is not just code. It's a trail of evidence: the plan, the failing test, the passing test, the review findings, and the final verification."
