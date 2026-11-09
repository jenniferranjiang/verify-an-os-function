# KMutexDelete r1 历史验证结果

> 本文只记录 2026-11-04 对 predicate/spec r1 完成的实现证明。当前设计已进展到 [predicate-spec-r3.md](predicate-spec-r3.md) 固定的 r3；r3 尚未重新运行 QCP implement，因此不得把下述 `done` 解读为当前 r3 已证明。

**r1 实现验证完成，结论受已批准的 A1/A2 及既有模型/复用边界约束。** 2026-11-04，三个目标的 QCP controller 均返回 `done`，各自 final-check 均为 `passed`、`errors: []`。这些结果只对当时冻结的 r1 predicate 和调用闭包 spec 有效。

| 本轮实现目标 | 结果 | 最终检查证据 |
|---|---|---|
| `KMutexDelete` | done；8/8 组 accepted | [final-check](../checks/final-check-KMutexDelete.json) |
| `_MutexDelete`（case `MutexDelete`） | done；11/11 组 accepted | [final-check](../checks/final-check-MutexDelete.json) |
| Mutex 锁外场景 `LinklistResumeAll`（case `MutexResumeAll`） | done；15/15 组 accepted | [final-check](../checks/final-check-MutexResumeAll.json) |

全部 34 个证明组已接纳，三个函数均完成整体合并检查、正式写回和最终检查。最终检查包含独立 symbolic 重放、当前 VC 与证明对应关系、冻结规格与库边界、完整 Rocq 编译及禁止占位证明等安全检查。最终完整性审阅复用这些实际结果，没有另行重复执行证明检查；汇总与正式文件哈希见 [final-integrity.json](../checks/final-integrity.json)。

用户先前的“你implement吧”和 2026-11-04 的“明确允许 symbolic、VC 和实现证明”已取代最初仅设计审阅的阶段限制，授权记录见 [explicit-implementation-approval-20261104.json](../checks/explicit-implementation-approval-20261104.json)。此前的设计阶段报告保留其历史范围。

## 结论条件与闭包边界

- A1：成功查找后直到本次注销，同一对象分配保持存活，不发生竞争删除、释放或地址复用。
- A2：等待队列排空后直到注销，不再有新等待任务入队。
- `IdGetObj`、`IdRemoveObj`、`DoubleLinkListRmNode`、`KTaskWakeup` 是已审阅适用性的 reused-spec 边界，未计作本轮新完成的函数体证明。
- `CriticalAreaLock`、`CriticalAreaUnLock`、两个 container API 和 `x_free` 使用已记录的模型/信任合同。结论限于所审阅的 32 位非 SMP 配置及 TrustBase 适配。

权威 C 源码未修改，原并发缺陷没有修复，源码修复补丁未应用。三个 active C 切片、权威 mutex.c/linklist.c、配置及 TrustBase 的哈希与相应一致性记录相符，故复用 [implementation-source-consistency.md](implementation-source-consistency.md) 和 [source-consistency.md](source-consistency.md) 的结论。已批准的 IdRemoveObj field_addr/store 等价规范化仅同步 trial canonical/caller，语义和执行代码保持不变，见 [等价审阅](idnode-spec-normalization-review.md)。

正式实现证明位于 trial 的 [VC](../../VC/) 目录：`KMutexDelete_*`、`MutexDelete_*`、`MutexResumeAll_*`；各 case 的 `_lib.v` 和 `_proof_manual.v` 是最终写回文件。共享设计库为 [lib/KMutexDelete.v](../../../lib/KMutexDelete.v)。设计审阅与迁移依据见 [design-complete-status.md](design-complete-status.md)。本次没有修改独立的 KEventDelete 实验。
