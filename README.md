# super-skill

A skill package for AI coding agents. It reads the agent skills that have been proven across domains on GitHub, picks out the recurring consensus, and turns it into a set of executable rules.

The current content distills 1865 SKILL.md files. Main sources:

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

## What is inside

- `SKILL.md`: 12 universal operating principles that apply to any task. Think before acting, simplicity first, surgical changes, evidence before claims, root cause before fix, untrusted external input, context budget, token economy, anti-AI-slop, anti-hallucination, security baseline.
- `references/`: 13 domain workflows, loaded by task type. Coding, debugging, code review, research, writing, documents, security, design, verification, token economy, memory, skill authoring, web testing.

Design principle: the main file holds principles and routing only; depth lives in references and is loaded on demand. It does not stuff the whole repository into every session's context.

## How to use

The format is compatible with Claude Code SKILL.md (YAML frontmatter plus Markdown body). It is plain Markdown text, so it works on macOS, Linux, and Windows with any agent that reads a skills directory. Drop it into your agent's skills directory:

```bash
# DeepSeek Harness (macOS / Linux)
cp -R super-skill ~/.dsh/skills/

# DeepSeek Harness (Windows PowerShell)
Copy-Item -Recurse super-skill $env:USERPROFILE\.dsh\skills\

# Claude Code (macOS / Linux)
cp -R super-skill ~/.claude/skills/

# Claude Code (Windows PowerShell)
Copy-Item -Recurse super-skill $env:USERPROFILE\.claude\skills\

# Codex CLI (macOS / Linux / Windows WSL)
cp -R super-skill ~/.codex/skills/
```

The skills directory hot-reloads, so new sessions pick it up directly. When a task involves multiple steps, code, research, or a deliverable, the agent reads this skill first.

## Attribution

Each rule keeps its original source where possible. The key quotes written into the playbooks all come from the repositories listed above; nothing is fabricated.

## License

MIT. The fused source skills have their own licenses; see each source repository.
