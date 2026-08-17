# Skill Authoring：创建高质量技能

> 融合：Anthropic skill-creator（官方规范）、alchaincyf/darwin-skill（进化循环）、trailofbits skill-improver。

## 什么是 Skill

可复用的任务专属指令包：一个文件夹含 `SKILL.md`（YAML frontmatter + Markdown 指令），可选捆绑 `scripts/`（确定性执行代码）、`references/`（按需载入文档）、`assets/`（输出用文件）。
**Skill ≠ MCP ≠ 工具**：MCP 解决"如何连接外部系统"，工具是"单个可调用函数"，Skill 定义"做什么、按什么顺序、带什么护栏"。三层分工——"MCP for access, tools for actions, skills for behavior."

## Frontmatter

- `name` + `description` 必填。description 是**主要触发机制**，须同时含"做什么"+"何时用"。
- description 要 "pushy" 对抗模型欠触发：把 "How to build a simple fast dashboard" 扩写为补上 "Make sure to use this skill whenever the user mentions dashboards, data visualization, internal metrics… even if they don't explicitly ask for a 'dashboard.'"
- 复杂触发用 `TRIGGER —` 块列触发词 + `SKIP` 规则列豁免。
- 可选：`whenToUse`、`metadata`、`license`。

## 结构与粒度（渐进式披露三级加载）

1. 元数据（name+description）恒在上下文（~100 词）
2. SKILL.md 正文触发时载入（理想 <500 行，接近上限就加层级）
3. 捆绑资源按需载入（脚本可执行而无需读入）

- 多领域技能按变体组织 references（aws.md/gcp.md/azure.md），"Claude reads only the relevant reference file"。
- 大 reference（>300 行）带目录；SKILL.md 保持 <500 行。

## 写作风格

- 用祈使句；**"解释为什么"取代大写 MUST**——"Try to explain to the model why things are important in lieu of heavy-handed musty MUSTs."
- 若发现自己写 ALL CAPS 的 ALWAYS/NEVER 或超刚性结构是黄旗，应重构并讲推理。
- 用输出模板（"ALWAYS use this exact template"）与 Input/Output 示例定义格式。
- 无意外原则："A skill's contents should not surprise the user in their intent if described." 不含恶意/利用代码。
- Waza 风格："Each skill states the outcome, the red lines, and how the result gets verified, then steps back and lets the model choose the path."（写 outcome/red lines/verification，别写死路径）

## 测试与迭代（skill-creator 核心循环）

1. 写草稿 → 造 2-3 条逼真测试 prompt（存 evals/evals.json，先不写断言）
2. **同一轮并行 spawn 两个 subagent**：带技能 vs 不带技能的 baseline（改进旧技能则 baseline 指向快照）
3. 运行期间补断言（客观可验证、描述性命名；主观型技能交人工定性）
4. 抓 total_tokens/duration_ms；grader 子代理判分（grading.json：text/passed/evidence）
5. 聚合 benchmark.json（pass_rate/耗时/token，mean±stddev+delta）
6. 读 feedback 迭代：**泛化**（技能要被用一百万次，不能只对样例过拟合——顽固问题换隐喻/工作模式，而不是加更紧的 MUST）；**精简 prompt**（读 transcript 删不产生价值的段落）；**解释 why**。
7. 发现重复工作就收进脚本："If all 3 test cases resulted in the subagent writing a `create_docx.py`, that's a strong signal the skill should bundle that script."

## 触发优化（20 条查询法）

- 造 20 条查询：8-10 应触发 + 8-10 不应触发。应触发覆盖不同措辞、用户不点名但明显需要、与竞争技能竞争应胜出。
- 不应触发**最有价值的是 near-miss**（共享关键词但实为另一任务）；无关负例没意义。
- 60% 训练/40% 留出、每条跑 3 次、最多 5 轮，按 test 分选 best_description 防过拟合。
- "Claude only consults skills for tasks it can't easily handle on its own… Simple queries like 'read file X' are poor test cases."（测试查询要有实质）

## MCP Builder 要点（agent 工具开发）

- 四阶段：深入研究规划 → 实现 → 评审测试 → 创建评测。质量以"它让 LLM 完成真实任务的能力"衡量。
- **API 覆盖 vs 工作流工具**：不确定时优先全面 API 覆盖（组合自由），但也做高价值工作流工具（如 schedule_event 合并"查空闲+建事件"）。
- 工具命名：一致前缀+动作导向（github_create_issue）；精炼描述、过滤/分页、返回聚焦数据——**把 agent 上下文预算当稀缺资源**。
- 可行动错误消息：引导走向解法（"Try using filter='active_only'"），教育性非纯诊断。
- 推荐栈：TypeScript+Zod；远端 streamable HTTP+无状态 JSON、本地 stdio。注解：readOnlyHint/destructiveHint/idempotentHint/openWorldHint。
- 测试注意：**MCP 是长驻进程，直接前台跑会挂死**——用 tmux、`timeout 5s`、或评测 harness。
- 五条 agent-centric 原则：Build for Workflows、Optimize for Limited Context、Design Actionable Error Messages、Follow Natural Task Subdivisions、**Use Evaluation-Driven Development**（agent 实际表现反哺工具改进）。

## 进化循环（darwin-skill 理念）

评估→改进→测试→保留或回滚：每个技能版本都进 benchmark，退步即回滚；把"训练技能"当"训练程序"。

## 关键句

- "This is the primary triggering mechanism - include both what the skill does AND specific contexts for when to use it."
- "A green recalc proves your formulas *evaluate*, not that they are *right*."（验证原则通用于所有产物）
- "Always run scripts with `--help` first. DO NOT read the source… They exist to be called directly as black-box scripts rather than ingested into your context window."
