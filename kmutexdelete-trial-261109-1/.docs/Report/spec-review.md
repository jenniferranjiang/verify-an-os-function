# KMutexDelete 调用闭包 spec 修改复查

2026-11-10，reviewer：checked_revision_review（非作者）。当前状态：`needs-fix`。
旧版 `review-passed` 不适用于本次 revision；当前 predicate 尚未通过，因而本记录
是接口修改与影响复查，不宣称完成新的 spec 通过审阅。

当前正式输入为 `annotated_C/src/` 中的三个 C 文件、`mutex_delete_logic.h` 和
`mutex_delete_types.h`，以及 `checks/ExternCheck.v`；固定版本见当前 manifest。

用户要求的接口修改已落实：`_MutexDelete::outside_critical` 只以
`safeExec(LastSeen(before), abs_mutex_delete(sg, mutex), X)` 和
`OutsideCritical(sg, before)` 描述入口；不存在公开 `exists obj` 或额外 `With obj`。
`LinklistResumeAll::mutex_waiters_oc` 使用同样结构，仅保留实际链表参数与
`mutex_pending_head(p)` 的关联；`p` 是该 helper 场景所需地址参数。
`KMutexDelete` 的公开程序调用同步增加 `sg`。两个 local callee 声明与 canonical
定义均已同步，出口仍量化执行后才得到的 `after`，使用同一 continuation `X`。

对象存在性移到抽象程序是正确的接口方向；但不能仅凭入口变短就认定设计成立。
[predicate 复查](predicate-review.md) 发现当前 `assertS` 检查与 universal rely
之间的非真空性缺口，它同时影响新 `LinklistResumeAll`、`_MutexDelete` 以及
`KMutexDelete` 的查询命中路径。负 ID 和查询未命中的控制流不能代替成功删除路径
的适用性依据。因此完整调用闭包当前不能获得新的 `review-passed`。

三个 C body、ordinary Lock/Unlock、复用的 IdGetObj/IdRemoveObj/DLL remove/
KTaskWakeup 与 free 边界没有因本次接口修改而改变。原源码 A1--A3 的条件范围仍然
有效，未扩大为任意世界的对象存在保证。当前缺口属于 predicate/spec 抽象设计，
不是本次新发现或修复的 C 源码缺陷。

作者执行的 QCP 依赖重建、trial Rocq 编译及按完整 `_CoqProject` 配置执行的
`checks/ExternCheck.v` 类型检查均 exit 0；Reviewer 检查本地三个 `.vo` 及
`ExternCheck.vo` 已生成，并核对 `spec-manifest.sha256` 固定的输入哈希。
独立比较确认两个 local callee 的 caller-local/canonical contracts 各自一致，三份
ordinary Lock/Unlock contracts 各自一致。类型正确不等于入口可满足，结论仍为
`needs-fix`。
未启动 verification-orchestrator，未运行 QCP parser/symbolic，未生成 VC，未做
C 实现证明。需修正并先完成 predicate 独立复审后，再进行正式 spec 审阅。
