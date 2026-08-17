# Review Playbook：代码审查与质量门禁

> 融合：obra/superpowers（双门禁+修复循环上限）、addyosmani（五轴+DoD×AC）、Trail of Bits（证据强制）。

## 审查是质量门禁，不可跳过

- 任何 merge 前必审：spec 合规 + 代码质量双门禁，二缺一不可。
- 审查者拿到的是**精心构造的产物而非会话历史**：diff 打包成文件、带 brief 与报告、约束逐字传给审查者。
- 禁止预判（"do not flag" 就是在作弊）；不要求重跑实现者已跑的测试。

## 五轴审查

1. **正确性**（逻辑、边界、并发）2. **可读性**（命名、结构）3. **架构**（职责、耦合）4. **安全**（输入校验、权限）5. **性能**（复杂度、N+1）

- 先审测试，再审实现；最后"验证审查者的验证故事"。
- 分级处理：Critical 立即修 / Important 必改 / Minor-Nit 记录延迟。审查结论按杠杆排序：正确性与安全在前，结构回归次之，装饰性意见垫底。
- 按风险分类而非规模："Small PR, quick review" 是借口——**Heartbleed 只有 2 行**。
- 每个发现给出：根因（为什么错）→ 数据流路径 → 行号/提交证据。模糊的发现会训练读者忽略真实的发现。

## 修复循环（obra：最多 5 轮）

- 1-3 轮恢复原实现者（上下文完好）；4-5 轮换更强者（"三次都没收敛说明失败是结构性的"）。
- 5 轮后 breaker 仲裁：审查者错/可争论 → park 并记 Ruling；真实但无下游依赖 → park；真实且承重 → 最小裁决并带进下一任务。
- 终审 findings 只派**一个**修复代理，只做一次范围化复审，没有第二波。

## 接收审查时

- **先验证再实现，禁止表演式同意**（"You're absolutely right!" 是明文违规；不道谢——"actions speak"）。
- 对外部评审者先查 5 项：技术正确性 / 破坏性 / 原实现原因 / 平台兼容 / 对方上下文，再动手。
- 多条目反馈先澄清所有不明项再动手；分歧裁决层级：技术事实 > 风格指南 > 工程原则 > 一致性。
- "我以后再清理"不可接受。

## 双层完成标准（Addy）

- **验收标准 AC**：回答"做对了吗"（每任务不同，≤3 条可测试）。
- **Definition of Done**：回答"达标了吗"（项目级常驻、每次变更同一根杠：正确性/质量/集成/文档/可发布）。
- 两者都满足才算完成。"DoD 每次迭代都被重新谈判就不是 DoD。"
- 批准标准："变更只要明确改善整体代码健康即可批准，不必完美"；诚实审查——不 rubber-stamp、量化问题（"N+1 每项 +50ms"）、防 sycophancy。

## 变更尺寸

~100 行佳 / ~300 可接受 / ~1000 必须拆；重构与功能**分开提交**。

## 关键句

- "Review early, review often."
- "Approve a change when it definitely improves overall code health, even if it isn't perfect."
- "LGTM without evidence of review helps no one."
- "A clean review is a valid review." / "Vague findings train the reader to ignore real ones."
