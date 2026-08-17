# Writing Playbook：写作与文档

> 融合：Waza/write（去 AI 味）、ComposioHQ content-research-writer（研究写作）、Anthropic doc-coauthoring（读者测试）、taste-skill（文案标准）。

## 去 AI 味写作（Waza/write 核心）

- "不要提升词汇，去掉改进的表演。" 删掉重复、总结腔、复述结论。
- 一段文字必须有"说话人"；读起来流畅到像任何人都能写出就是缺陷。**无法归属的流畅本身就是缺陷。**
- **禁止 em-dash（—）**——最强的 AI 口吻指纹；只用普通连字符。
- 三条有力的修改胜过三十个机械替换；输出只给正文，不加修改说明。
- 规则是气味目录不是查表：禁止列表式机械替换。
- **红线护栏**：不给公开文本加 AI 署名；草稿/方案批准 ≠ 写操作授权（批准的是方向，不是执行许可）；对外文本不留 AI 痕迹。

## 研究-写作工作流（content-research-writer）

### 1. 选题/立项（澄清六问）
主题与主论点 / 目标受众 / 篇幅格式 / 目的（教育/说服/娱乐/解释）/ 已有研究或来源 / 写作风格。

### 2. 大纲
Hook → Introduction → Main Sections（每节：关键点+例子/证据+`[Research needed: 主题]` 占位+反方观点与收束）→ Conclusion → **Research To-Do 清单**（`- [ ] Find data on X`）。Hook 给 3 备选（bold statement / personal story / surprising data）。

### 3. 收集
按节研究，输出 Key Findings（编号观点+引用 [1][2][3]）+ Citations（作者/年份/出版物），回填大纲。outline.md / research.md / draft-vN.md / final.md / feedback.md / sources/ 分文件保存。

### 4. 成文
一节一节写、一节一节反馈。反馈模板：What Works Well ✓ → Clarity/Flow/Evidence/Style 四轴改进 → Specific Line Edits（原句精确引用→建议→为什么）。

### 5. 声音保持
"Suggest, don't replace"；"Enhance, don't override"；周期自问 "Does this sound like you?"

### 6. 终审
Full Draft Review（结构流/论点强度/证据充分性/引用完整性）+ Pre-Publish Checklist：All claims sourced / Citations formatted / Examples clear / Transitions smooth / Call to action present / Proofread。

## 读者测试（Anthropic doc-coauthoring）

- 用零上下文的全新 Claude 跑 5-10 个读者真实问题，查歧义/错误假设/自相矛盾。
- 通过标准："Reader Claude consistently answers questions correctly and doesn't surface new gaps or ambiguities."

## 学术论文写作要点（Research-Paper-Writing-Skills 等）

- 先定投稿目标会议/期刊（决定格式与篇幅）；Abstract 最后写。
- Related Work 三问：与谁不同/贡献边界/引文完整。贡献要可验证（实验/证明/数据集）。
- 图表自解释：标题完整句、轴标签明确、同一配色方案。
- 避免 AI 味学术套话：少用 "delve/comprehensive/leverage"；直接陈述方法贡献与局限。

## 文档/ADR

- 决策记录（ADR）：Nygard 格式 Context/Decision/Alternatives/Consequences，**必须写被否决的备选与理由**——"the rationale matters more than the what"，2 分钟可读完。
- changelog 写给人类：按 Added/Changed/Fixed/Deprecated/Removed/Security 分组、新在上、随变更同 commit 写。

## 生产力写作变体（ComposioHQ）

**简历定制**（tailored-resume-generator）：JD 解析出 P1 必须/P2 重要/P3 加分三级 → 经历逐条映射（含可迁移技能、缺口淡化）→ 经历条目格式 **[Action Verb]+[What]+[How/Why]+[Result/Impact]**（强制量化）→ **ATS 优化**（标准标题、精确关键词自然融入、禁表格图形页眉页脚、缩写+全称并列）；诚实底线 never fabricate。

**会议洞察**（meeting-insights-analyzer）：转录稿 → 行为数据（冲突回避 hedgings、"maybe/kind of"、转移话题、无承诺附和；发言占比/打断计数；口头禅频率；积极倾听；领导风格）。每条发现给**带时间戳真实引文**，三段式 What Happened/Why This Matters/Better Approach。

## 关键句

- "Do not improve vocabulary; remove the performance of improvement."
- "A piece has a speaker."
- "Suggest, don't replace… Enhance, don't override."
- "AI-generated cute copy is worse than boring copy."
