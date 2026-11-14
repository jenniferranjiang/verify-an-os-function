# KMutexDelete C 分析

分析日期：2026-11-09；2026-11-10 按用户批准的 A1--A3 恢复设计。
本记录只分析当前配置下的权威 C，不是 predicate/spec 或实现证明结论。

## 配置与适配

当前切片配置启用 `KERNEL_MUTEX`，使用 32 位、非 SMP、
`SCHED_POLICY_RR_REMAINSLICE`，`ID_NUM_MAX=128`、ID hash bucket 数为 16、
任务优先级数为 32。`KDEBUG_NOT_IN_INTERRUPT` 的调试行为按 TrustBase 删除；
`NULL_PARAM_CHECK` 的空指针分支仍是非返回路径。固定 `done.MutexDelete` 可由
静态初始化唯一解析为 `_MutexDelete`。`CONTAINER_OF` 按 TrustBase 的具名模型处理。

源码哈希及三个并发问题见 [source-gate.md](source-gate.md)。用户批准本 trial
按 A1--A3 排除这些交错；该批准不冻结无关 OS 状态。

## 目标路径

`KMutexDelete(int32 id)` 有三条正常返回路径：负 ID 直接返回；非负 ID 经临界区
查询未命中时解锁返回；命中时由 `IdNode` 得到 `Mutex` 基址，解锁后调用
`_MutexDelete`。非负 `int32` 传给 `uint16` 查询参数时按低 16 位转换，因此例如
65536 查询 ID 0，spec 不能擅自加强成 `id < 65536`。

`_MutexDelete` 的空指针路径不返回；正常路径在临界区外调用
`LinklistResumeAll(&mutex->pend_list)`，随后另行加锁，读取当前 `mutex->id.id`，
调用 `IdRemoveObj`，摘除 `mutex->link`，解锁并以原分配基址调用 `x_free`。
它不检查 holder/value/recursive count，不恢复 holder 优先级，也不触发调度。

`LinklistResumeAll` 的空指针路径不返回。正常路径自己加锁，反复读取等待链头：
空链时退出；非空时从队首 `sched_link` 得到任务，写 `exstatus=-ERROR`，读取任务
ID 并调用 `KTaskWakeup`，忽略其返回值。只有每个 waiter 都是登记中的 SUSPEND
任务、且 wakeup 严格摘除当前队首时循环才正常终止；否则可不返回。函数解锁后
返回 `EOK=0`，不执行 `DO_KTASK_ASSIGN`。

## 内存与效果

32 位 `Mutex` 布局为：`id.id` offset 0，padding `[2,4)`，`id.link` offset 4，
`val` 12，`recursive_cnt` 14，`origin_prio` 15，`holder` 16，`pend_list` 20，
`link` 28，总大小 36、4 字节对齐。

ID manager 唯一拥有 bitmap、bucket、`id.id/id.link`；`k_mutex_list` 拥有
`mutex.link`；mutex payload 拥有标量、padding 与 pending head；pending list
拥有 waiter 的 `sched_link` 槽但不拥有整个任务；task、scheduler、delay 模块分别
拥有 descriptor 字段、ready 结构和 delay 对象。注销、摘链和排空后，完整 36 字节
对象转成私有退休资源，最终交给 allocator。

新的 `LinklistResumeAll` 抽象效果必须按原 pending 顺序把所有任务改为 READY 且
`exstatus=-ERROR`，取消 active delay，按 RR_REMAINSLICE 规则插入 ready bucket，
更新 ready group/highest priority，并把目标 pending 清空；mutex 的 ID、管理链、
holder 与各标量保持不变。循环 proof 接口应描述“已处理前缀 + 未处理 suffix”，
公开 contract 使用整队效果。

## 完整调用闭包分类候选

- 本轮新设计并保留 active body：`KMutexDelete`、`_MutexDelete`、
  `LinklistResumeAll`。
- reused-spec 候选：`IdGetObj`、`IdRemoveObj`、`DoubleLinkListRmNode`、
  `KTaskWakeup`；每项仍须核对来源 revision、证明状态、类型和 caller-local contract。
- TrustBase/模型候选：`CriticalAreaLock`、`CriticalAreaUnLock`、两个
  `CONTAINER_OF`、`KDEBUG_NOT_IN_INTERRUPT`、`NULL_PARAM_CHECK_1`。
- allocator 边界：权威 C 直接调用 `x_free`；需核对它与 TrustBase 中
  `KERNEL_FREE` contract 的配置对应后才能结束分类。

当前根全局模型已移除 task/assign/delay，不能使用残留 `.vo` 或旧 mutex
`LinklistResumeAll` 合同。新 trial 必须建立类型一致、可编译的 task/wakeup provider，
并重新生成 canonical spec。
