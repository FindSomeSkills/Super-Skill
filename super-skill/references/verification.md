# Verification Playbook：验证与完成

> 融合：obra/superpowers（证据铁律）、ECC verification-loop/delivery-gate（机械门禁）、addyosmani（上线门禁）。

## 证据铁律

- 没有在**同一条消息里**运行完整命令并读到输出，就不能声称通过。
- 禁止 "should/probably/seems to"；禁止在验证前说 "Done!"。
- agent 报告成功 ≠ 完成：查 VCS diff 独立核实。
- 回归测试要红绿循环：写→过→回退修复必须失败→恢复→过。

### 反合理化表（Rationalizations to Reject）

| 借口 | 现实 |
|---|---|
| "Too simple to test" | Simple code breaks. 简单代码一样会坏。 |
| "Small PR, quick review" | Heartbleed 只有 2 行。按风险分类，不按规模。 |
| "Keep as reference" | You'll adapt it. Delete means delete. |
| "I remember this skill" | Skills evolve. 读当前版本。 |
| "skip tests for now" | 门禁警告：不验证就宣称完成是违规。 |
| "This doesn't need a formal plan" | Planning is the task; implementation without a plan is just typing. |
| "I'll clean this up later" | "我以后再清理"不可接受——现在清理或记录为任务。 |
| "I feel like it works" | 感觉不是证据。跑命令读输出。 |

## 收工六阶段验证（ECC verification-loop）

1. build（构建通过）→ 2. type（类型检查）→ 3. lint → 4. test（覆盖率 80%+）→ 5. security 扫描 → 6. diff 复核。
产出 VERIFICATION REPORT：READY / NOT READY for PR。长会话每 15 分钟设心理检查点。

## 机械门禁（delivery-gate 理念）

- 机械门禁检查机器可验证事实，不信自我报告——"same pattern as CI pipeline gates."
- 合理化模式正则拦截："skip tests for now" 仅警告。
- 复杂度阈值之上必须完成验证报告才能宣告完成。
- 决策收集铁律：**禁止静默替用户选择**——逐项独立列出+推荐+理由+备选，绝不打包"全部 OK 吗"。
- **自检→修复→再汇报**：任何质检结论必须先按 fail 项改完产出再汇报——"直接拿原始结论汇报但不修复 = 违规"。

## 上线门禁（Addy shipping-and-launch）

### 预发布清单（六域）
代码质量 / 安全 / 性能 / 可访问性 / 基础设施 / 文档。

### Feature flag 生命周期
OFF 部署 → 内部 → 5% → 25% → 50% → 100% → 清理。flag 要有 owner 和过期日，2 周内清理，不嵌套。

### 回滚计划（部署前写好）
触发条件、步骤、数据库回滚、时间预算。灰度阈值表：错误率 >2x 基线即回滚、P95 >50% 即回滚。

### 上线后首小时验证
health check、错误率、延迟、关键流、日志、回滚演练。

## git 收尾纪律

- 不在 main/master 上直接开工；开工前建隔离 worktree。
- 收尾呈现 3 选项给人（本地合并/推 PR/保留）；合并后必须在合并结果上重跑测试（"绿跑只证明它所跑的那棵树"）。
- 原子提交：一个逻辑事一个提交；消息写 why 不写 what；提交即保存点（测试过→提交，失败→回退）。
- semver 是承诺；tag 是真相源；提交前卫生（`git diff --staged`、grep secrets）。

## 自检五轴（ECC agent-self-evaluation）

任务后五轴自评（准确性/完整性/清晰性/可行动性/简洁性），每轴要具体证据，1-5 分记分卡——不是 pass/fail 门，而是防过度自信的反思步。

## 关键句

- "Evidence before claims, always."
- "If you haven't run the verification command in this message, you cannot claim it passes."
- "'It's done, I just haven't run it yet': unverified work is not done."
- "A result is not just code. It's a trail of evidence: the plan, the failing test, the passing test, the review findings, and the final verification."
