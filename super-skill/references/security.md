# Security Playbook: Security Auditing and Hardening

> Distilled from: Trail of Bits (78-skill methodology), addyosmani security-and-hardening, ECC AgentShield/security-review, OWASP LLM Top 10.

## ToB's Ten Methodological Principles

1. **Build understanding before hunting for bugs**: "Build understanding, not verdicts." For each function, record what it assumes, what it guarantees, and what it depends on.
2. **Follow the calls**: a function's correctness depends on the functions it calls; read the callees and walk every path. "Every claim cites a line, or becomes an open question."
3. **Anti-rationalization table**: every stage carries a built-in "lazy excuse → why it's wrong → what you must do" mapping (e.g. "small PR, quick pass" → Heartbleed was only 2 lines).
4. **Separate verification from falsification**: an independent adversarial verifier tries to overturn findings (dedup → fp → refuter in sequence). "Pattern recognition is not analysis."
5. **False positive governance**: the 7 brocard rules (no threat model, no vulnerability / if the capability needed to exploit ≥ the impact, it is redundant / behavior allowed by the standard is not an implementation flaw / if the fix costs more than the harm, reject / a CVE number is not evidence). LLMs naturally bias toward reporting bugs and overestimating severity.
6. **Tiered triage**: scale verification depth by risk and codebase size; settle the threat model (REMOTE/LOCAL) and the severity filter up front.
7. **From known to unknown** (variant analysis): root cause → precise pattern → generalize one element at a time → triage. "A pattern that matches nothing means you have misunderstood the bug."
8. **Attack surface first**: enumerate state-changing entry points and trust boundaries first; "zero findings requires investigation, not celebration."
9. **Evidence must be measurable**: line numbers, call chains, artifact files; "an inspector that checked 0 objects must fail, not pass."
10. **Orchestration discipline**: parallel workers + serial judge + disk artifacts; **partial runs must be explicitly labeled, never masked by a success report**.

## Security Tool Map (Trail of Bits Categories → Representative Tools)

| Category | Representative tool/skill | Purpose |
|---|---|---|
| Code audit | `audit-context-building` | Build a per-function "assumptions/guarantees/dependencies" profile before the audit; record only, never judge |
| | `differential-review` | Security differential review of PRs/diffs (git history + blast radius + adversarial modeling) |
| | `fp-check` | Systematic false positive verification of a single suspicious finding (TRUE/FALSE POSITIVE + evidence) |
| | `variant-analysis` | Known bug → find sibling variants (generalize one element at a time) → distill into Semgrep/CodeQL rules |
| | `vulnerability-triage-brocards` | Accept/reject/request-evidence on vulnerability reports with the 7 brocard rules |
| | `static-analysis` | Semgrep+CodeQL+SARIF parsing; zero findings must trigger a database quality check |
| | `spec-to-code-compliance` | Line-by-line code vs spec comparison, with an independent refuter to challenge |
| Supply chain | `supply-chain-risk-auditor` | npm/PyPI/Go dependency audit (advisories/abandonment/publisher concentration/install scripts) |
| | `agentic-actions-auditor` | AI agent prompt injection attack surface in GitHub Actions (9 vectors) |
| Verification | `property-based-testing` | 9 property classes: roundtrip/inverse/oracle/idempotence..., watch for tautologies |
| | `mutation-testing` | Mutation testing to measure test quality (mewt/muton) |
| | `constant-time-analysis` | Compile-artifact-level timing side channel detection; a FAILED report is a work list, not a verdict |
| | Fuzzer family | libfuzzer/aflpp/libafl/atheris/cargo-fuzz + harness + sanitizer |
| Reverse engineering | `dwarf-expert` | DWARF debug info parsing/validation (llvm-dwarfdump --verify) |
| Mobile | `firebase-apk-scanner` | APK decompile to extract Firebase config; probe open DBs/buckets in practice (authorization required) |
| Smart contracts | `building-secure-contracts` | 6-chain vulnerability scan + ERC20/721 compliance + 24 weird token patterns |

## Bringing Verification into Daily Practice

- **Property testing**: roundtrip (encode/decode round trip), inverse (inverse operation), oracle (reference implementation), and idempotence are the strongest properties; watch for tautologies and vacuous assertions.
- **Mutation testing**: measures test quality; all-green tests with surviving mutants signal ineffective tests.
- **Fuzzers**: write a harness, use `FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION` conditional compilation to bypass validation obstacles, and run sanitizers in CI.
- **Prepare before the audit** (audit-prep-assistant): static analysis at zero or with documented exemptions, coverage >80%, dead code removed, a frozen review commit, build instructions, documented assumptions/roles/permissions. Get ready before sending the code in.

## Checklists by Scenario

### While Writing Code
- [ ] Validate all external input at the system boundary (schema/parameterized/encoding), fail closed on error
- [ ] Defaults are safe values; the semantics of `0/empty/null/negative` are defined; no selectable algorithm/mode option remains, or it is pinned (the JWT alg:none class)
- [ ] Secrets enter only through environment variables; sensitive data is wiped with zeroing APIs (the explicit_bzero family; memset may be optimized away); comparisons use constant-time APIs
- [ ] No string concatenation in SQL/commands/HTML; URL fetching has a scheme+host allowlist and rejects private IPs (acknowledge the residual TOCTOU)
- [ ] Authentication ≠ authorization: check resource ownership on every endpoint; cookies are httpOnly+secure+sameSite
- [ ] LLM output is schema-parsed and validated before use; tools/permissions are minimal and consumption is capped
- [ ] Property tests exist for code with algebraic shape (roundtrip/inverse/idempotence); fuzzers + sanitizers run in CI
- [ ] Dependency changes go through review: lockfile diff + install script inspection + typosquat checks (cross-env vs crossenv)

### While Reviewing Code
- [ ] Build baseline context first (per-function assumptions/guarantees/dependencies), then discuss findings
- [ ] Classify by risk: auth/crypto/value transfer/external calls = HIGH; "small PR, quick pass" is an excuse
- [ ] git blame deleted security code; compute the blast radius (50+ callers + HIGH = escalate immediately)
- [ ] Every finding comes with root cause → data flow path → line/commit evidence
- [ ] Ask the threat model question first: "Can an attacker with [capability] do [action] to achieve [impact]?" Not being able to answer = insufficient evidence
- [ ] Finalize only after an independent verifier has tried to refute; check vulnerability chain combinations; never accept a finding automatically just because it has a CVE (brocard 7)

### While Deploying
- [ ] Run the package manager's native audit before release (lockfile pinned); `npm ci --ignore-scripts` blocks install scripts
- [ ] Check for unsafe defaults: fallback keys, default credentials, fail-open switches, debug switches off
- [ ] CI uses least-privilege tokens; jobs triggered by `pull_request_target`/`issue_comment` count as exposed surface
- [ ] Security response headers (CSP/HSTS/X-Frame-Options), CORS allowlist, errors that expose no internal details
- [ ] Rate limit auth endpoints; passwords use bcrypt/scrypt/argon2; reset tokens expire
- [ ] Personal data has a collection purpose, a retention period, and a working deletion path (including backups/caches/indexes)
- [ ] Before open sourcing: secret scan, license, CI readiness

### While Analyzing Unknown Code
- [ ] Enumerate entry points and trust boundaries first (network/file/CLI/IPC/deserialization), labeling each REMOTE/LOCAL
- [ ] Record per-function `nothing found` assumptions and open questions; when claims conflict, record both citations rather than forcing a reconciliation
- [ ] Run static analysis (Semgrep+CodeQL) first, but zero findings must still validate database quality and rule coverage
- [ ] Run standard/deep false positive verification on every suspicious point instead of reporting it directly
- [ ] After a known bug, use variant analysis to find siblings; failing to prove reachability ≠ unreachable
- [ ] Produce reviewable artifacts (REPORT.md/SARIF/evidence files); label partial coverage explicitly

## Threat Modeling (5-Minute Version)

Map trust boundaries → name assets → walk STRIDE boundary by boundary → treat the abuse case as the first test. "If you can't name your trust boundaries, you have no business talking about security."

## Dependency Audit, Three Questions

① Is the vulnerable code reachable on the run/build/test/deploy paths? ② Is the fix a patch or a major version bump? ③ Is the deployment context exploitable? Never run `npm audit fix --force` automatically.

## Key Lines

- "Treat every external input as hostile, every secret as sacred, and every authorization check as mandatory."
- "The system prompt is not a security boundary; enforce permissions in code, not in the prompt."
- "Zero findings needs investigation, not celebration."
- "Secure usage should be the path of least resistance." (pit of success)
