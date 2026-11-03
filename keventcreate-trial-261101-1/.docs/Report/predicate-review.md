# KEventCreate predicate 独立审阅

结论：**review-passed**。审阅对象为 `checks/predicate-manifest.json` 固定的 revision `bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca`，2026-11-01，非 SMP / ILP32 / TrustBase 位域适配配置。Reviewer 为未编写本轮 predicate 或 spec 的 C analysis agent；审阅时只读正式 `.v`。此结论是设计审阅通过，不是 C 实现正确性证明。

已完整阅读 predicate 指南及 skill review 条件，并检查四个新增模块全部定义、三处已有模块语义差异和其余22份文件的导入改动。独立重新计算 manifest revision、全部29个文件哈希及 compile-results 对应关系，一致且29项均exit0；22份导入副本将 KEventTrial.lib 前缀归一后与保存基线逐字一致。新四文件未出现 Axiom、Parameter、Admitted 或 admit；没有把待证 Prop 定义用作证明事实。

`EventState` 按真实对象保存地址、ID、options、events、等待任务顺序；固定 manager/bitmap/桶/管理头归 Stable。管理对象顺序同时派生 ID 集合和桶顺序，符合两个容器的头插算法，避免两份可变权威状态。事件3位options实际截断以及29位events范围得到保留；`event_created`对整个uint32输入取mod8，无0/1或小于8的额外调用范围限制。

`EventRaw`/`EventZero`覆盖适配后的全部36字节，包含ID padding[2,4)，并使用现有ID、DLL和节点槽定义。发布后，manager持有ID标量/ID link，管理DLL持有Event.link，payload持有options/events/padding/pend哨兵和等待任务sched_link；展开复用的 `store_idnode_insert_ready`、`store_dll`、`pure_suspend_sched_link` 后，未见重复描述符权限或丢失字段。等待关联仅为纯事实，任务字段由TaskInv持有。新对象等待链为空，但现有事件可以有等待者。

创建中ID注册到管理链头插之间暂时拆开模块表示，锁内可持有局部资源；Unlock前由restore义务重组。ID失败只返回未知字段权限，回收采用Raw，未错误保留全零断言。初始化拥有BSS bitmap/懒桶和管理头自环，未虚构初始化token。`event_byte_layout`明确描述的是位域展开后的模型布局，真实ABI32字节与模型36字节有区分；零字节转换和回收陈述显式依赖布局条件，未把检查结果冒充全称布局公理。

`CrtosGlobState`的所有已有record更新保留event，新replace_events只更新event。`CrtosInv`在资源组合、sched owners的NoDup和注册覆盖中实际接入event；空pending发布不会改变调度所有者。`KTaskWakeup`一般关系新增事件等待节点摘除，保持对象其他字段；delay-only、已知semaphore来源和detached路径保留event。由于任务唯一调度所有权，`EventOps`逐对象remove_found只会改变其实际来源等待链。统一临界区协议本身只更换一致的总状态类型，没有第二套锁token或协议假设。

`abs_event_create_locked`覆盖-5且本次操作状态不变、最小空闲ID成功头插并保持其余模块；不存在“ID失败必满”的无来源保证。外层malloc失败或原子创建经既有LastSeen/atomic接口连接，未错误保证返回时全局状态等于入口或返回ID仍存在。

剩余的字节转换、split/restore、ID派生一致性和初始化均明确为后续证明义务；本轮只要求陈述设计与类型检查。现有全局C证明不能因类型扩展自动算作重新完成，此影响已在设计报告说明。Create闭包外的源码问题见 source-errors.md，不构成本次predicate的隐含输入限制。未发现阻塞本revision设计审阅的问题。


主 agent 后续处置：此前因源码问题暂停推进。E2的延时建立失败路径已完成候选修复、故障注入及独立增量复查；按用户最新要求，候选仅保存在trial/source_fixes/_EventProcess.c，权威源码已恢复原样；E1/E2非法输入按本轮接口使用范围说明，E3按用户不并发删除约束排除。当前原formal revision保持不变，创建函数正文及闭包未变化；本报告的设计结论继续适用。最新范围、源码revision和检查限制以[e2-fix-review.md](e2-fix-review.md)、[source-errors.md](source-errors.md)及[status.md](status.md)为准。后续实现已获用户批准，最终结果见[status.md](status.md)。
