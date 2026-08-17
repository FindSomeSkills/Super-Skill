# super-skill

一个给 AI 编码代理用的技能包。把 GitHub 上能找到的、各领域被验证过的 agent skills 读了一遍，挑出反复出现的共识，融成一套可执行的规则。

现在的内容来自 1865 个 SKILL.md 的提炼，主要来源：

| 仓库 | 主题 |
|---|---|
| affaan-m/ECC | 代理运行系统、证据链、机械门禁 |
| obra/superpowers | 计划、TDD、调试、代码审查的纪律 |
| anthropics/skills | 文档技能、技能创作规范 |
| addyosmani/agent-skills | 上下文工程、怀疑驱动开发 |
| trailofbits/skills | 安全审计方法论 |
| tw93/Waza | 工程习惯 |
| multica-ai/andrej-karpathy-skills | LLM 编码陷阱与反制 |
| JuliusBrussee/caveman | token 经济学 |
| Leonxlnx/taste-skill | 设计品味、反 AI 味 |
| nextlevelbuilder/ui-ux-pro-max-skill | UI/UX 设计智能 |
| mvanhorn/last30days-skill | 时效性研究 |
| ComposioHQ/awesome-claude-skills | 工作流技能 |
| vercel-labs/agent-skills | 官方团队技能写法 |

## 里面有什么

- `SKILL.md`：12 条通用操作原则，任何任务都适用。包括思考先于行动、简单优先、外科手术式修改、证据先于宣称、先根因后修复、外部输入不可信、上下文预算、token 经济学、反 AI 味、防幻觉、安全基线。
- `references/`：13 个领域工作流，按任务类型读取。编码、调试、代码审查、研究、写作、文档、安全、设计、验证、token 精简、记忆、技能创作、Web 测试。

设计原则：正文只放原则和路由，深度放在 references 里按需加载。不把整个仓库塞进每次会话的上下文。

## 怎么用

格式与 Claude Code 的 SKILL.md 兼容（YAML frontmatter + Markdown 正文）。放到对应代理的技能目录即可：

```bash
# DeepSeek Harness
cp -R super-skill ~/.dsh/skills/

# Claude Code
cp -R super-skill ~/.claude/skills/
```

技能目录会自动热更新，新会话直接可用。任务涉及多步骤、代码、研究或交付物时，代理会先读这个技能。

## 引用

每条规则尽量保留原文出处。写进 playbook 的关键句都来自上面列出的仓库，没有编造。

## 许可

MIT。融合的原始技能各有其许可证，详见各来源仓库。
