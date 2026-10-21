当前为 **r2 draft**：已经实施 PR-02 的 task/pending 一致性修复，并通过受影响编译；PR-01 的普通嵌套接口与 PR-03 的最大计数问题仍为 open。因此本候选不处于 review-ready，也未通过审阅，不得用于开始 spec review 或 implement。

当前来源记录为 `source-r2-0c50c37013e9`（manifest `0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651`）：仅补入独立review使用的data_queue.c，原46份源码字节、ARM ABI及9+6闭包不变。

当前 formal revision 为 `predicate-r2-fc2db1b1c887`，manifest SHA-256 为 `fc2db1b1c8870dbbffdca92e0ad739aca885c70d8a752eb028caf203030a10e3`。manifest 与编译记录仍位于 `evidence/predicate-manifest.json`、`evidence/predicate-build.json`。r1 七份正式源及本次复制保留的 r1 manifest/build/设计报告均在 `evidence/predicate-review-build/`；[独立 full review](2026-10-12-1-predicate-review.md) 仍绑定原 r1。r1 未获批准，因此本轮按草案修复记录，不冒充已批准设计变更。

## PR-02 修复

只修改 `CrtosOSPure.v` 的有效性及相关注释，并增加两个已证明的投影引理；heap owner、SemaphorePure/Rep、共享根定义、权威C及六个trusted边界均未修改。

`CrtosOSValid` 现在直接复用根 `task_world_wf`，使 descriptor map 与 task registry、ID节点身份关联，而非仅假定某个地址存在任意描述符。每个 semaphore pending 成员仍持有原来的节点唯一所有权，还必须满足共享 `TASK_STAT_MASK` 下的 `TASK_SUSPEND`。`CrtosOSValid_pending_suspended` 确保不能换另一份同地址描述符绕过状态义务；`CrtosOSValid_pending_registered` 确保 pending task 属于同一个根任务注册表。

Ready队列中的任务必须为 `TASK_READY`，并在 `tsmCurPrio` 对应的队列中，符合 `KTaskInsertToReadyVector`/`AssignPolicyInsert`。具有 `TASK_RUNNING` 状态的任务只能是 `Assign.os_running_task` 指定的任务。反向只要求非空 running 指针在 descriptor map 中，不强制该描述符永远为 RUNNING：`_SemaphoreObtain` 将当前任务挂起后，退出临界区再调度，期间 running 指针仍可指向 SUSPEND；ready插入与上下文切换之间也可短暂指向 READY。该范围在正式定义旁说明。

没有要求 pending 永远按当前优先级排序，因为 `_KTaskPrioSet` 对已挂起任务可直接修改优先级而不重新排列 pending。也没有禁止非空 pending。

源码依据是 `ktask.c` 的 `_SuspendKTask`、`_KTaskWakeup`、`KTaskTimeout`、`_KTaskPrioSet`，`linklist.c` 的 Suspend/Resume/ResumeAll，以及 `assign.c` 的 ready插入/移除与调度。Suspend先建立SUSPEND再移交sched_link；成功Wakeup和timeout将节点从pending移走并建立READY/ready membership。描述这些稳定端点不等于已证明这些非create函数体。

## 机器检查与范围

`evidence/probes/PR02PendingCheck.v` 已编译通过，记录在 `pr02-pending-check.json`。四个Qed证明：测试任务身份满足根task_world_wf；合法非空pending且running指针仍指向刚挂起任务的状态可满足新validity；原来的任意非SUSPEND描述符反例被排除；移走pending、建立READY/ready队列的唤醒或timeout稳定端点仍可表示。exstatus不被额外限定为0，保留真实错误/超时结果的空间。这些是修复检查，不是目标函数VC。

复现受影响编译：

`python3 ksemaphorecreate-trial-261012-1/tools/check-predicates.py --revision-number 2 --incremental`

CrtosOSPure及依赖的CrtosOSProtocol、CrtosOSInv、SemaphoreCritical四份文件均exit0；另外三份正式源与r1相同，没有重复编译。该修复不产生新的ownership分区，原设计的32-byte ledger及统一heap bridge仍适用。

PR-02已由作者实施，等待同一reviewer的delta确认，不能自行标为review-passed。PR-01/03尚未改变：现有formal仍有r1的零nest入口限制。`evidence/probes/nested-carrier-note.md` 只记录嵌套适配的类型检查及未解决语义限制；它不是已经修复普通嵌套的证据。最大计数的API序列反例由主agent及独立reviewer单独归因；本修复没有通过加任意深度上界或转移字段隐藏该问题。
