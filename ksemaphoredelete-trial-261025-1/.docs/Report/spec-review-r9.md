# KSemaphoreDelete spec-r9 独立审阅

2026-10-30，独立 reviewer：`spec_review`。结论：**`KSemaphoreDelete-spec-r9`：review-passed（设计审阅）**。
审阅在收到 pred-r7 通过通知后开始，固定使用 [pred-r7 独立审阅](predicate-review-r7.md) 所对应的定义。
Spec aggregate SHA-256：`00bad529f9b7b9f5a29415d443d27d7e6a7875e9ffc798acefdd6e3285a4c17b`；
predicate aggregate：`9a204245814625aade45188ff92e1cc911bc1aad78fee08d7f2f5dfab8b9d786`。
正式文件清单为 `checks/spec-revision.json`、`checks/predicate-revision.json`。
本 reviewer 未修改正式输入或状态清单，未运行 QCP。

本次检查历史 spec-r7 通过之后的同步修改及受影响内容，并核对当前三个目标的全部路径。
范围仍为非 SMP、32 位、小端、RR_REMAINSLICE 下的 `KSemaphoreDelete`、`_SemaphoreDelete`、
`LinklistResumeAll`；20 个导入函数和 8 个模型/信任边界按 [实现证明范围](verification-scope.md) 处理。
导入函数体不重证，也不因文本一致或类型检查通过而宣称已经在本地模型下证明。

## 三个目标的契约衔接

`KSemaphoreDelete` 仅转发参数，canonical 与 `_SemaphoreDelete` 声明使用同一删除 program、
continuation 及 `OutsideCritical`。参数检查实际位于 `_SemaphoreDelete`，wrapper 没有虚构检查。

`_SemaphoreDelete` 的公开规格没有缩窄为 0..127 或 0..65535；program 覆盖负 ID 立即返回及非负值的
uint16 模转换。未命中时恢复共享资源并解锁；lazy 空桶初始化不被误写为具体字节不变。命中时按源码顺序
判空、必要时 ResumeAll、注销 ID、摘管理链、解锁、释放，且仅原队列非空时调度。token 可作为 ResumeAll 的
frame 保留。ID 已注销而管理链尚未摘除的中间资源不能提前折回稳定 invariant；最终 `os_inv` 排除目标，
完整私有对象才能跨 unlock 转交 `x_free`。这与 pred-r7 的删除效果和退休对象表示一致。

`LinklistResumeAll/semaphore_waiters` 的纯 pending 关联给出对象地址及原等待顺序，实际字段权限来自
`os_inv`，没有重复持有完整 invariant 和独立等待 DLL。接口按已批准的同步方案借还完整 invariant，删除
caller 在对象仍登记时能够提供该入口。每轮重新读取队首，按真实嵌套 sched_link 找任务，先写 exstatus，
再唤醒。NULL 检查的无限循环保留；合法已登记哨兵的空间资源排除 NULL。空队列零次迭代，EOK/KOK 均为 0。

所选 `KTaskWakeup/semaphore_pending_head_ic` 的前态必须是写入 `exstatus=-ERROR` 后的 marked 状态。
当前 call `where` 只固定 sg、sem，没有错误地绑定函数入口 before。该写入不改变队首、ID manager 或
SUSPEND 状态；调用前仍须证明 ID 查询关联，并按新 task map 恢复完整 `os_inv`。callee 返回成功、剩余 rest、
READY/delay/ready 更新及完整 invariant，保留 caller 已写入的 exstatus。每次使用新 pending 继续循环。

出口的整体 `semaphore_resume_all_effect` 已包含原等待任务 READY/-ERROR、延时取消、按原序列插入 ready
和其他状态保持，删除重复的 `tasks_ready_with_exstatus` 未削弱保证；另显式保留同一对象的空 pending。
空列表效果为整个状态不变。逐步到整体的连接及有限队首移除的循环证明仍未完成，不能把 Prop obligation
当作已证引理。

## 直接依赖适用性

`IdGetObj` 的同步仅改逻辑参数名和格式。命中后的 found view 必须收回完整 manager，再恢复 `os_inv` 或继续
后续调用。`IdRemoveObj` 改用导入的 `low_level_spec`：其命中分支保留 `idmanager_contains`、删除后 manager、
ID=65535 和自环节点。已有命中事实、ID 唯一性及节点关联足以识别同一 semaphore 的 ID 子对象；具体桥接仍须
证明。`IsDoubleLinkListEmpty/dll` 保留等待 DLL 并准确区分空链，`DoubleLinkListRmNode/remove_member` 保留
其余管理链顺序并交回目标 payload、自环节点，适用于本次摘链。

`KTaskWakeup/semaphore_pending_head_ic` 的 caller 与 canonical 一致，20 个导入函数的其他内部调用在边界停止。
typed container 只转换地址关系，不产生读写权限；Lock/Unlock、释放和调度模型依照既定 TrustBase/源码处理规则，
没有新增信任假设。

## 证据和后续义务

复用并读取 `checks/review-261030/`：25 个 spec、15 个 predicate 文件哈希匹配；65 处导入契约、4 处 ResumeAll
规格副本一致；153 项 Extern 类型隔离编译通过；根库构建目标 up-to-date。源码/配置/切片和 ABI 结论见
[源码一致性复核](source-check-2026-10-30.md)，本 reviewer 另对照真实 semaphore.c、linklist.c 核对目标路径及顺序。
未用文本一致性替代上述语义审阅，也未把增量构建说成全库重新编译。

未发现本版设计 blocker。实现仍须完成资源拆装、map 重索引、每个调用的前置条件、循环保持和整体效果连接、
删除中间资源组合、`SemaphoreRetired` 到 `SemaphoreRaw` 转换，以及所用 strategy 的正确性证明。
本结论不表示三个函数体已证明；用户版本确认和正式 QCP workflow 由 main 按技能流程处理。
