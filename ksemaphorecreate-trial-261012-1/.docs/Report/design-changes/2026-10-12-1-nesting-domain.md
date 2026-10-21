本次验证的入口范围经用户明确批准改为 `nest < 65535`，更深调用不在证明范围内。权威 C 不修改，成功/失败行为、所有权转移、task/scheduler 保持目标及六个 trusted symbols 保持原要求。普通嵌套（包括当前 dataqueue 的 nest=1 调用）仍必须支持。

记录 ID：`DCHG-20261012-01`，状态 `approved-for-design`。它修改的是用户预批准的验证调用域；此前 predicate r1/r2 尚未 review-passed，不将其误标为已经通过后失效。

## 依据与用户决定

`CriticalArea.c` 使用 uint16 递增，然后在退出时仅对非零计数递减。65535→0→0 无法满足调用前后计数保持。独立审阅 PR-03 和 ILP32 C 诊断确认这一事实；诊断不证明固定板级调用图达到该状态，也没有证明 IRQ 测试 stub 满足完整逻辑合同。因此没有把诊断报告冒充为已确认的板级源码错误。

`evidence/probes/NestRoundtripDomain.v` 机器证明：在 uint16 范围内，真实加减的计数保持恰好等价于 `nest < 65535`；没有新增公理依赖。更深调用的排除属于功能范围限制，而非规避未定义行为。

用户对异步范围问题的原答复为：**“允许 nest<65535，明确排除更深调用”**。该授权仅适用于本次实验；不修改 skill 或长期规则。它不是自动批准新 predicate/spec revision，所有独立审阅和机器检查仍然必须完成。

## 实施与审阅要求

- 新 formal revision 和顶层 spec 明示该范围，不得把溢出后的0等同于原65535。
- 进入 IRQ 边界取得的 current 状态也须满足可恢复条件；Rely 及真实嵌套 caller 协议必须支持这一点。
- ordinary nest=1 的 caller token、已有 invariant 和真实计数必须完整恢复，不重复获得同一 heap。
- 未授权第七个 trusted symbol，也未授权额外 IRQ 假设。新增 hs 参数或协议表达必须由独立 reviewer 检查与既定 trusted 语义的对应。
- 修复后固定新 predicate/spec manifests，重跑受影响编译、独立 delta review，再按原一次性授权自动接受 review-passed revision 并进入 implement。

关联：[predicate review](../2026-10-12-1-predicate-review.md)、[r2 设计](../2026-10-12-2-predicate-design.md)。证据分别为 `evidence/predicate-review-nest-check.json`、`evidence/nest-counterexample-escalated-result.json`、`evidence/probes/nest-roundtrip-domain-result.json`。本记录不宣称 PR-01 或新调用域已经验证通过。

最终状态（2026-10-16）：本决定已落实到当前接受的 predicate/spec revisions，完整九函数闭包已重验，全部机器终检通过；当前结论与边界见 [final integrity](../2026-10-16-1-final-integrity.md)。本记录所述原诊断保留，不改变权威源码。
