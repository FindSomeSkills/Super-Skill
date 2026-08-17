# Security Playbook：安全审计与加固

> 融合：Trail of Bits（78 技能方法论）、addyosmani security-and-hardening、ECC AgentShield/security-review、OWASP LLM Top 10。

## ToB 十大方法论原则

1. **先建理解，再猎漏洞**："Build understanding, not verdicts." 逐函数记录它假设什么、保证什么、依赖什么。
2. **跟随调用**：函数正确性取决于被调函数；必须读被调函数，走每条路径。"Every claim cites a line, or becomes an open question."
3. **反合理化表**：每个阶段内置"偷懒借口→为什么错→必须做什么"（如"小 PR 快速过"→ Heartbleed 只有 2 行）。
4. **验证与证伪分离**：用独立反方验证器推翻发现（dedup→fp→refuter 串行）。"Pattern recognition is not analysis."
5. **假阳性治理**：7 布罗卡规则（无威胁模型不叫漏洞 / 利用所需能力≥影响则冗余 / 标准允许的行为不是实现漏洞 / 修复代价>危害则驳回 / CVE 编号≠证据）。LLM 天然偏向报 bug 与高估严重度。
6. **分级处置**：按风险与代码库规模分验证深度；威胁模型（REMOTE/LOCAL）与 severity filter 先行确定。
7. **从已知到未知**（variant analysis）：根因→精确模式→一次只泛化一个元素→分诊。"A pattern that matches nothing means you have misunderstood the bug."
8. **攻击面优先**：先枚举状态变更入口点与信任边界；"零发现需要调查，而不是庆祝"。
9. **证据可衡量**：行号、调用链、产物文件；"检查了 0 个对象的检查器必须失败而不是通过"。
10. **编排纪律**：并行 worker + 串行 judge + 磁盘产物；**部分运行必须显式标注，绝不用成功报告掩盖**。

## 安全工具地图（Trail of Bits 分类 → 代表工具）

| 类别 | 代表工具/技能 | 用途 |
|---|---|---|
| 代码审计 | `audit-context-building` | 审计前逐函数建立"假设/保证/依赖"档案，只记录不裁决 |
| | `differential-review` | PR/diff 安全差分审查（git 历史+爆炸半径+对抗建模） |
| | `fp-check` | 单个可疑发现的系统性假阳性验证（TRUE/FALSE POSITIVE + 证据） |
| | `variant-analysis` | 已知 bug → 找同类变体（一次只泛化一个元素）→ 沉淀 Semgrep/CodeQL 规则 |
| | `vulnerability-triage-brocards` | 7 布罗卡规则快速接受/驳回/索证漏洞报告 |
| | `static-analysis` | Semgrep+CodeQL+SARIF 解析；零发现必须查数据库质量 |
| | `spec-to-code-compliance` | 代码 vs 规格逐条比对，独立 refuter 反驳 |
| 供应链 | `supply-chain-risk-auditor` | npm/PyPI/Go 依赖审计（公告/弃维护/发布者集中度/安装脚本） |
| | `agentic-actions-auditor` | GitHub Actions 中 AI agent 提示注入攻击面（9 向量） |
| 验证 | `property-based-testing` | 9 类属性：roundtrip/inverse/oracle/idempotence…，警惕同义反复 |
| | `mutation-testing` | 变异测试衡量测试质量（mewt/muton） |
| | `constant-time-analysis` | 编译产物级时序侧信道检测；FAILED 报告是工作清单不是判决 |
| | 模糊器全家桶 | libfuzzer/aflpp/libafl/atheris/cargo-fuzz + harness + sanitizer |
| 逆向 | `dwarf-expert` | DWARF 调试信息解析/校验（llvm-dwarfdump --verify） |
| 移动 | `firebase-apk-scanner` | APK 反编译提取 Firebase 配置，实测开放 DB/存储桶（授权前提） |
| 智能合约 | `building-secure-contracts` | 6 链漏洞扫描 + ERC20/721 合规 + weird token 24 模式 |

## 验证手段下沉到日常

- **属性测试**：roundtrip（编解码往返）、inverse（逆操作）、oracle（对照实现）、idempotence（幂等）是最强属性；警惕同义反复与空洞断言。
- **变异测试**：衡量测试质量——把测试全绿但变异存活视为测试无效信号。
- **模糊器**：harness 编写 + `FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION` 条件编译绕过校验障碍 + sanitizer 进 CI。
- **审计前自备**（audit-prep-assistant）：静态分析清零或记录豁免、覆盖率 >80%、删死代码、冻结审查 commit、建构建说明、文档化假设/角色/权限——准备好再送审。

## 按场景检查清单

### 写代码时
- [ ] 系统边界校验全部外部输入（schema/参数化/编码），失败 fail-closed
- [ ] 默认值即安全值；`0/空/null/负值` 语义已定义；无算法/模式可选项或已锁死（JWT alg:none 类）
- [ ] 秘密只进环境变量；敏感数据用零化 API（explicit_bzero 族，memset 会被优化掉）；比较用常量时间 API
- [ ] SQL/命令/HTML 无字符串拼接；URL 抓取有 scheme+host 白名单 + 私有 IP 拒绝（知悉 TOCTOU 残留）
- [ ] 认证≠授权：每个端点检查资源属主；cookie httpOnly+secure+sameSite
- [ ] LLM 输出经 schema 解析校验后再用；工具/权限最小化、消耗封顶
- [ ] 为有代数形状的代码补属性测试（roundtrip/inverse/idempotence）；模糊器+sanitizer 进 CI
- [ ] 依赖变更走 review：lockfile diff + 安装脚本审查 + typosquat（cross-env vs crossenv）

### 审查代码时
- [ ] 先建基线上下文（每函数假设/保证/依赖），再谈发现
- [ ] 按风险分类：auth/crypto/值转移/外部调用 = HIGH；"小 PR 快速过"是借口
- [ ] git blame 被删除的安全代码；计算爆炸半径（50+ 调用方 + HIGH = 立即升级）
- [ ] 每个发现给根因→数据流路径→行号/提交证据
- [ ] 先问威胁模型："拥有[能力]的攻击者能[动作]达成[影响]吗？" 答不上来=证据不足
- [ ] 独立验证者反驳后才定稿；检查漏洞链组合；有 CVE 不自动采信（布罗卡 7）

### 部署时
- [ ] 发布前跑包管理器原生 audit（锁定 lockfile）；`npm ci --ignore-scripts` 拦安装脚本
- [ ] 检查不安全默认：fallback 密钥、默认凭据、fail-open 开关、调试开关关闭
- [ ] CI 用最小权限 token；`pull_request_target`/`issue_comment` 触发的 job 视为暴露面
- [ ] 安全响应头（CSP/HSTS/X-Frame-Options）、CORS 白名单、错误不暴露内部细节
- [ ] 认证端点限流；密码 bcrypt/scrypt/argon2；重置令牌有过期
- [ ] 个人信息有收集目的、保留期限、可工作的删除路径（含备份/缓存/索引）
- [ ] 开源前：秘密扫描、许可证、CI 就绪

### 分析未知代码时
- [ ] 先枚举入口点与信任边界（网络/文件/CLI/IPC/反序列化），标注 REMOTE/LOCAL
- [ ] 逐函数记录 `nothing found` 假设与开放问题，冲突记录双方引用而非强行调和
- [ ] 静态分析（Semgrep+CodeQL）先跑，但零发现必须验证数据库质量与规则覆盖
- [ ] 对每个可疑点做标准/深度假阳性验证，而非直接报
- [ ] 已知 bug 后用变体分析找同类；无法证明可达≠不可达
- [ ] 输出可复核产物（REPORT.md/SARIF/证据文件），部分覆盖显式标注

## 威胁建模（5 分钟版）

映射信任边界 → 命名资产 → STRIDE 逐边界 → abuse case 当第一个测试。"无法命名信任边界，就不配谈安全。"

## 依赖审计三问

①漏洞代码在运行/构建/测试/部署路径上可达吗？②修复是补丁还是跨大版本？③部署上下文可利用吗？绝不自动 `npm audit fix --force`。

## 关键句

- "Treat every external input as hostile, every secret as sacred, and every authorization check as mandatory."
- "The system prompt is not a security boundary; enforce permissions in code, not in the prompt."
- "Zero findings needs investigation, not celebration."
- "Secure usage should be the path of least resistance."（pit of success）
