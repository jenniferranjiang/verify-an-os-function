# KSemaphoreDelete pred-r7 独立审阅

2026-10-30，独立 reviewer：`predicate_review`。结论：**`KSemaphoreDelete-pred-r7`：review-passed（设计审阅）**。
对象为 `checks/predicate-revision.json` 的 15 个文件，aggregate SHA-256 为
`9a204245814625aade45188ff92e1cc911bc1aad78fee08d7f2f5dfab8b9d786`；逐文件哈希已独立核对，无不一致。
没有修改正式 predicate、spec 或状态清单，也没有运行 QCP 实现证明。

本次沿用 r5 对未变内容的审阅，检查 r6/r7 同步修改及其受影响定义。验证范围仍是非 SMP、32 位、小端配置下的 `KSemaphoreDelete`、`_SemaphoreDelete`、`LinklistResumeAll`。20 个导入函数按已确认的外部契约使用，8 个既定模型/信任边界保持；本结论不宣称这些依赖的本地实现已经证明。依据包括当前正式 `.v`、r5 快照、10 月 28/29 日变更记录、TrustBase，以及真实 CRTOS 的 semaphore、linklist、ktask、delay、assign、RRR、idle 和 zombierecycle 源码。

## 修改后的资源归属与状态关系

`os_inv` 仍唯一持有各模块资源。`semaphore_pending_nodes` 仅把对象序列中的等待任务与规范 `sched_link_node` 列表关联，不重复拥有链表或任务字段。等待 DLL 拥有 `task_dync_sched_member.sched_link`，任务描述符的 exstatus、调度标量及 delay 指针仍由 `task_inv` 的 map cell 持有，ID 标量及 link 归 ID manager。新接口没有把知道队首地址误当作持有任务字段。

`semaphore_resume_one` 先以 `set_task_desc_exstatus` 和 `replace_task_desc_map` 表示实际的 `exstatus=-ERROR` 写入，再调用 `wakeup_semaphore_head` 对应的关系。此时的 Wakeup 输入是 marked 状态。`ktask_wakeup_pending_frame` 保持任务 ID/管理链、自持列表、running/current priority、其他 IPC 与全局分量，只更新任务 READY 状态、delay 与 ready vector；信号量关系精确移除原队首。对本地对象序列使用 `semaphore_set_pending`，保持对象管理次序、ID/value 和其他对象，与真实 C 摘链行为一致。

exstatus 更新保持调度状态、优先级、时间片、bitmap、delay 指针与基础信息，因此不改变等待 payload 的 SUSPEND 关联、delay 的 owner 关联、ready 的排序依据或服务任务的入口/ID 条件。恢复这些 predicate 的新 map 索引需要引理，但没有发现定义使这一步不可能成立。唤醒后的 READY 状态与节点转移则必须一起恢复：不能将更新后的 semaphore 资源与未经重索引的旧全局 frame 直接拼回 `os_inv`。

`task_fields` 同步为完整 ID manager、管理 DLL、descriptor map 和 Done 表组合，不包括调度节点；它是 `task_inv` 的可借出部分，并非能与完整 `os_inv` 同时独立持有的资源。原 `task_wakeup_inv` 定义仍可作为局部组合使用，但本轮整体/逐步连接义务已正确改为以完整 `os_inv` 为资源前提。

## 批量效果与真实操作

`resume_all_task_map` 只修改原等待任务的 stat/exstatus。`resume_all_delays` 按原任务非零 tdDelay 选择实际对象，删除 active 项时保留其他项次序，并将对应 payload 置为 INACTIVE；与 `KTaskUnSetDelay` 的 NULL、inactive、active 三种路径一致。active/inactive 唯一性及 task 指针对应依赖原 `delay_inv`，不是额外假设。

`resume_all_ready` 按 waiting 顺序组合插入关系。新的 `assign_insert_step_ic` 使用关系式 RRR 插入和 32 位 OR 截断：严格小于比较时插在第一个更大 rest_timeslice 之前，advance_cnt 达到阈值则尾插，不要求整个桶已排序。fixed-map `T` 不妨碍这一组合：被唤醒任务原有优先级、时间片、bitmap 和地址保持，扫描关系 `ready_node_task_desc` 不要求在固定原 map 中已经 READY。循环中使用更新后的 map 和整体效果中使用原 map 的连接仍须证明，不能用这段解释代替证明。

`semaphore_resume_all_effect` 的空列表分支保持整个状态；非空分支一次清空目标 pending，组合上述任务、delay、ready 更新并保持其他分量。新增 pending-head 关系与该效果一致，没有多做第二次摘链。`semaphore_resume_all_effect_steps_obligation` 仍是带合法资源及成员条件的 `Prop` 待证陈述，没有被作为已证引理或公理使用。

删除 program 仍覆盖负 ID 直接返回、非负 ID 的 uint16 查询归一、未命中、有/无等待者和条件调度。注销 ID 与管理摘链的中间态不能提前折回稳定 `semaphore_inv`；最终的 `SemaphoreRetired` 拥有 ID=65535、原 value、padding 以及三个自环节点，完整对象已从共享 invariant 移出后才能越过 unlock 交给 x_free。`semaphore_retired_raw_obligation` 仍需通过字段遗忘和布局组合证明。

## 全局一致性同步

`os_world_wf` 的 NoDup/domain 分解仍表达调度节点所有者互斥和已发布任务的完整覆盖。共享 `ServiceSlotAbs` 替换旧 role 命名；新增服务任务条件只提供纯关系，不产生内存。正常服务任务入口的源码中，idle 不进入等待链，recycler 无等待任务时调用 SuspendKTask，其 delay 保持为空，符合自持节点及 NULL delay 的设计。等待 semaphore 的任务由全局 NoDup 与 SUSPEND 关联排除为同时自持的服务任务；本目标更新不会破坏服务任务条件。完整服务生命周期及其他 API 对 invariant 的保持性没有在本次证明。

新增 `task_wf_init_close_bitmap` 允许 INIT/CLOSE 的掩码为 0 或当前优先级的单比特值：`_KTaskDyncMemberInit` 写 0，INIT 优先级修改重新计算，Startup 重算，关闭操作保留已有掩码。原 RUNNING/SUSPEND 条件合并未弱化其单比特关联。descriptor 的基址对齐从外层移入 `store_task_descriptor`，组合后的已发布对象权限没有增加或丢失。

存在一处非阻塞的旧注释：`TaskInv.v` 的长说明仍使用“不约束 INIT 的初始零掩码”的说法。当前正式条件明确允许 INIT/CLOSE 的 0 或单比特值；本审阅按该正式定义判断，保留原文件哈希，未作文字修正。

## 检查证据与实现义务

复用 10 月 28/29 日共享库编译记录，并核对主线程本次生成的 `checks/review-261030/`：15 个 predicate 输入哈希、根构建状态及隔离编译的 153 项形式接口检查。源码输入、可执行切片与 ABI 依据见同目录 `source-check.json` 和 `source-check-2026-10-30.md` 报告。未把这些检查当作 C 实现证明，也没有重复运行它们。

尚需在 implement 完成：os_inv 的借还与 map 重索引、exstatus 写权限和新状态恢复、队首任务 ID 查询关联、循环不变式与整体/逐步关系连接、ID 查询 found view 归还、删除中间资源组合、退休对象到原始释放块转换，以及实际使用到的 strategy 正确性证明。缺少这些实现证明不影响本次设计通过，但任何一项都不能凭导入契约文本或本审阅豁免。

本结论不扩大到整个 OS 的所有内存或生命周期：原 msg_buf 内容未建模的范围限制仍保留；CriticalAreaLock/UnLock、释放、typed container 和调度模型依照既定边界使用。可以在此固定 predicate revision 上进入 spec-r9 审阅。
