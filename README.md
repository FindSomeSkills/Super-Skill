# super-skill

A fused operating manual for coding agents: 12 universal operating principles and 13 domain playbooks distilled from the top-rated agent skills on GitHub.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20Linux%20Windows-lightgrey)]()
[![Agents](https://img.shields.io/badge/agents-Claude%20Code%20Codex%20DSH%20Cursor%20Gemini%20CLI-blueviolet)]()
[![Version](https://img.shields.io/badge/version-1.2.0-green)]()
[![Stars](https://img.shields.io/github/stars/FindSomeSkills/Super-Skill)]()

## Why this exists

GitHub already carries thousands of agent skills. Most of them repeat the same lessons: plan before coding, prove it with tests, verify before claiming done, treat external input as untrusted, never ship an AI-flavored default design. super-skill reads the top-rated collections, extracts the consensus, and packages it as one loadable skill instead of 1865 separate files.

## Features

- 12 universal operating principles that apply to every task: think before acting, simplicity first, surgical changes, goal-driven execution, evidence before claims, root cause before fix, untrusted external input, context budget, token economy, anti-AI-slop, anti-hallucination, security baseline
- 13 domain playbooks loaded on demand: coding, debugging, code review, research, writing, documents, security, design, verification, token economy, memory, skill authoring, web testing
- Progressive disclosure: the main file holds principles and routing only; depth lives in references and is read only when the task needs it
- Agent-agnostic: plain SKILL.md format, works with any skills-compatible agent

## Compatibility

Plain Markdown with YAML frontmatter, compatible with the Agent Skills open standard (agentskills.io).

| Agent | Skills directory |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex CLI | `~/.codex/skills/` |
| DeepSeek Harness (DSH) | `~/.dsh/skills/` |
| Cursor, Gemini CLI, Windsurf, Cline | their own skills directories |

| Platform | Supported |
|---|---|
| macOS | Yes |
| Linux | Yes |
| Windows | Yes (PowerShell or WSL) |

## Quick start

```bash
# One-line install into Claude Code skills (macOS / Linux)
curl -fsSL https://raw.githubusercontent.com/FindSomeSkills/Super-Skill/main/install.sh | bash
```

The script only downloads and copies files into your skills directory; it runs no code from the repository. Review it before running if you prefer. For Windows, use the PowerShell command below.

## Install

```bash
# Claude Code (macOS / Linux)
cp -R super-skill ~/.claude/skills/

# Claude Code (Windows PowerShell)
Copy-Item -Recurse super-skill $env:USERPROFILE\.claude\skills\

# DeepSeek Harness (macOS / Linux)
cp -R super-skill ~/.dsh/skills/

# DeepSeek Harness (Windows PowerShell)
Copy-Item -Recurse super-skill $env:USERPROFILE\.dsh\skills\

# Codex CLI (macOS / Linux / Windows WSL)
cp -R super-skill ~/.codex/skills/
```

The skills directory hot-reloads, so new sessions pick it up directly. When a task involves multiple steps, code, research, or a deliverable, the agent reads this skill first.

## How it works

Design principle: the main file holds principles and routing only; depth lives in references and is loaded on demand. It does not stuff the whole repository into every session's context. The domain router in SKILL.md maps task types to playbooks, and each playbook carries the workflow, checklists, and key quotes for that domain.

## What's inside

- `SKILL.md`: 12 universal operating principles, the domain router, and a definition of done
- `references/`: 13 domain playbooks, each with a workflow and checklists

| Playbook | Covers |
|---|---|
| coding.md | Spec, plan, vertical slices, TDD, context engineering |
| debugging.md | Root cause, evidence ladder, sibling sweep |
| review.md | Five-axis review, fix loops, DoD x AC |
| research.md | Five-phase pipeline, multi-source confidence, anti-hallucination |
| writing.md | Anti-AI-flavor writing, research-writing workflow, reader test |
| documents.md | docx/pptx/xlsx/pdf gotchas, triple QA |
| security.md | Threat model, per-scenario checklists, tool map |
| design.md | Read the room, anti-cliche, UI priority table |
| verification.md | Evidence gates, launch checklist, rationalization table |
| token-economy.md | What to cut, when brevity stops |
| memory.md | Decision records, handoffs, instincts |
| skill-authoring.md | Anthropic authoring guide, evals loop, MCP principles |
| web-testing.md | Recon then act, snapshot first, adversarial testing |

## Sources

The content distills 1865 SKILL.md files. Main sources:

| Repository | Topic |
|---|---|
| affaan-m/ECC | Agent harness operating system, evidence chains, mechanical gates |
| obra/superpowers | Discipline for planning, TDD, debugging, code review |
| anthropics/skills | Document skills, skill authoring guidelines |
| addyosmani/agent-skills | Context engineering, doubt-driven development |
| trailofbits/skills | Security audit methodology |
| tw93/Waza | Engineering habits |
| multica-ai/andrej-karpathy-skills | LLM coding pitfalls and countermeasures |
| JuliusBrussee/caveman | Token economy |
| Leonxlnx/taste-skill | Design taste, anti-AI-slop |
| nextlevelbuilder/ui-ux-pro-max-skill | UI/UX design intelligence |
| mvanhorn/last30days-skill | Recency research |
| ComposioHQ/awesome-claude-skills | Workflow skills |
| vercel-labs/agent-skills | Official team skill writing style |

## Changelog

- **1.2.0** (2026-08-18): Audience and platform coverage rule in skill-authoring; Windows and Linux install docs; zero em-dash cleanup across quoted lines
- **1.1.0** (2026-08-18): Full English translation of SKILL.md, README, and all 13 playbooks
- **1.0.0** (2026-08-17): Initial release with Chinese content

## License

MIT. The fused source skills have their own licenses; see each source repository.
