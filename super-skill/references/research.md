# Research Playbook：深度研究与信息综合

> 融合：mvanhorn/last30days（时效研究五阶段）、ECC deep-research/market-research（决策导向）、ComposioHQ content-research-writer（研究写作）、Browserbase company-research（防推断）。

## 五阶段流水线

### 阶段 A：意图解析
拆出 TOPIC / TARGET_TOOL / QUERY_TYPE（PROMPTING / RECOMMENDATIONS / NEWS / COMPARISON / GENERAL）。比较型必须逐实体解析定位。

### 阶段 B：查询质量预检（查之前先判死）
检测五类关键词陷阱：人口学购物式提问（"gift for 42 year old man"）、数字/年龄冲突词、过度字面化概念短语（"how to use Docker" vs 社区说 "my Docker setup"）、通用单名词（"sneakers"无锚点）、非拉丁语主题。命中即改写或问澄清问题——"Running the engine on a doomed query burns 5+ minutes and produces junk."

### 阶段 C：预研究（搜索前的实体级解析）
- 用 2-3 次搜索定位实体：X 主账号+公司/创始人账号、GitHub 用户名（person-mode 看 PR 速度）、GitHub 仓库（拉实时 star）、Reddit 社区（dedicated vs broad）、品类同行子版块强制扩展。
- **第一方定位必须现场抓取官网当前说辞，禁止凭记忆**——"homepages and positioning go stale."

### 阶段 D：查询计划
产出 JSON 计划：1-4 条 subquery，每条含关键词密集的 `search_query` + 自然语言 `ranking_query` + 来源清单 + 权重（主 1.0/次 0.6-0.8/外围 0.3-0.5）。硬规则：search_query 永不含时间词；易撞名实体逐条消歧锚定。

### 阶段 E：引擎执行 + 后置补充
- 并行搜各平台，用真实互动数据（upvotes/views），按日期硬过滤，URL 去重。
- 跑完必须再做 2-3 次后置搜索（独立预算）补博客/长文/批评反应；每次补充检索追加保存，保证任何声明可回源。

## 多源交叉验证

- **聚类优先**：按故事/主题聚类而非按来源排列。Reddit+X+YouTube 的跨源簇 > 单源。
- **置信度标签**：`Uncertainty: single-source`（单平台，低置信）/ `Uncertainty: thin-evidence`（全低于阈值，未证实）。
- **来源加权**：Reddit/X 最高（互动数据）、YouTube/TikTok 高、Web 最低；**顶评论比主帖更强**；X 回复簇是最强社区背书。
- 预测市场赔率是高信号数据（真金白银），只报百分比不报交易量。
- 推荐类按**信号质量排序**而非提及次数：实践者证言(5) > 权威背书/可量化声明(4) > 有理由的比较(3) > 多源收敛(2) > 描述性提及(1) > 推广内容(0)。"The failure mode for RECOMMENDATIONS queries is 'counting when you should have judged.'"

## 时效性纪律

- 日期硬过滤；`--days=N`/`--as-of` 回溯；`--verify-freshness` 核对。
- 窗口化措辞："keep claims windowed - 'this month's conversation' - never trend verbs."
- 区分"没结果"与"没查到"：`no-results` = 源正常跑完零匹配；`partial/rate-limited/auth-failed` = 本次未证实——绝不写 "nothing on X" for those states。
- **"Nothing solid this window" 是有效答案**——如实转达，绝不重试或编造主题。
- **六阶段学习法收尾**（Waza/learn）：collect（只收一手来源）→ digest（三问校验：两处上下文出现/能否预测/是否领域共识）→ outline（每节挂来源）→ fill in（写不动=心智模型弱，回炉）→ refine（只删不新写）→ **人类终审：用户线性通读两遍，不许 AI 代读**；矛盾来源保留双方立场，绝不静默选边。

## 知识检索纪律（kb-retriever / deep-dive）

- **分层索引导航**：目录树里层层 `data_structure.md`，先导航缩小候选集再搜索，绝不整文件加载；目录存在性用 `test -d` 而非 Glob。
- **渐进式检索**：3-8 个关键词（含同义词/上下位词）→ grep 精确限定 → 只读命中附近几十行 → 保存"文件名+位置+片段"（`file:line` 溯源）；**统一迭代最多 5 轮**，信息不足明确告知不臆造。
- **先学后处理**：遇到 PDF/Excel 等格式必须先读处理方法（pdftotext/pdfplumber/pandas）再动手，配强制清单。
- **DAG 研究**：问题分解为带 `depends_on` 的子问题图，拓扑序分波并行 fan-out，每波 gap 分析回流成新子问题；sources 落盘 JSON 抗上下文压缩。
- **防推断**：不从字体/框架/设计系统推断产品描述、行业或受众——"These are cosmetic and say nothing about what the company sells." 不知道就写 `Unknown`。

## 防幻觉十条（硬性纪律）

1. 每条声明都要有来源；无来源的断言禁止。
2. 单源声明标记未验证。
3. 承认空白："If you couldn't find good info on a sub-question, say so."
4. 事实/推断/建议四类证据分离，绝不混标。
5. 新鲜答案禁用过期记忆："do not answer current questions from stale memory when fresh search is cheap."
6. 综合扎根于实际检索结果，不靠先验知识（禁止把产品 A 写成 B）。
7. 引用 URL 永不猜测重建；引号逐字、归属作者。
8. 产出里不叙述工具机制（"引擎没搜到"），只陈述关于主题的事实。
9. 数字无源即标为估计；旧数据显式标注；含反面证据与下行风险。
10. 分层出击：本地能回答的问题不起重型流水线。

## 报告模板

### 深度研究报告骨架
```
# [Topic]: Research Report
*Generated: [date] | Sources: [N] | Confidence: [High/Medium/Low]*
Executive Summary (3-5 句) → 主题节（行内引用 [Source](url)）→ Key Takeaways → Sources（[Title](url) — 一句话）→ Methodology
```

### 决策导向骨架（market-research）
executive summary → key findings → implications → risks and caveats → recommendation → sources。Quality Gate：数字有出处、旧数据标注、建议由证据推出、含反方、让决策更容易。"Produce research that supports decisions, not research theater."

### 时效查询计划 JSON（last30days Step 0.75）
```json
{"intent":"RECOMMENDATIONS","freshness_mode":"balanced_recent","cluster_mode":true,
 "subqueries":[{"label":"main","search_query":"关键词密集查询（不含时间词）",
   "ranking_query":"自然语言问句","sources":["reddit","x","youtube","hackernews"],"weight":1.0}]}
```
硬规则：`search_query` 永不含时间词；易撞名实体逐条消歧锚定（"kevin rose digg founder" 而非 "kevin rose"）。

### 社区简报输出契约（last30days）
首行徽章（`🌐 last30days v{v} · synced {YYYY-MM-DD}`）→ `What I learned:` 加粗标题叙事（每段 1 条最强引用）→ `KEY PATTERNS` 编号列表 → 引擎统计原样透传 → 邀请追问（含 2-3 个基于实际发现的示例）。比较型：Quick Verdict → 每实体 Community Sentiment/Strengths/Weaknesses → Head-to-Head 表 → The Bottom Line。

### 证据边界报告（research-ops）
`QUESTION TYPE`（factual/comparison/enrichment/monitoring）→ `EVIDENCE`（sourced facts / user-provided context）→ `INFERENCE`（从证据推出什么）→ `RECOMMENDATION`（答案或下一步 + 是否转监控）。事实/推断/建议四类证据绝不混标。

## 关键句

- "Google aggregates editors. /last30days searches people."
- "Multi-source clusters are highest confidence."
- "Every claim needs a source. No unsourced assertions."
- "If you don't know, say 'insufficient data found.'"
- "NEVER infer product_description from a site's fonts or framework — these are cosmetic and say nothing about what the company sells."
