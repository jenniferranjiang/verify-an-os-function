# PopDataqueue / PushDataqueue 设计说明

本轮是独立的新设计实验，仅完成 predicate、完整调用闭包规格及审阅。没有启动 verification-orchestrator、symbolic、VC 生成或 C 实现证明。审阅版本和结果见 [独立审阅记录](review.md)；本说明解释设计选择，不把正式文件的存在称为验证完成。

本轮新增 9 个 canonical 函数规格：PopDataqueue、PushDataqueue、KSemaphoreObtain、_SemaphoreObtain、KSemaphoreAbandon、_SemaphoreAbandon、LinklistResume、LinklistSuspend、CalculateTickFromTimeMs；另复用下文说明的已有契约边界。新增 8 个 Rocq 库文件提供对应语义及依赖适配。

## 验证对象与已有修复

正式目标是 `annotated_C/src/kernel/dataqueue/PopDataqueue.c` 和 `PushDataqueue.c`。来源、配置、调用闭包见 [source-analysis.md](source-analysis.md)。源码仍保持只读。本轮采用历史已批准且仍有效的 DQ-02/03 修复：所有 timeout 原样交给 Obtain 一次，非 EOK 返回统一的 -ERROR。批准记录末尾明确删除旧分析副本不撤销修复授权，见 [源码错误与授权](../2026-11-16-InitDataqueue-DataqueuePeak/source-errors.md) 及 [修复差异](../2026-11-16-InitDataqueue-DataqueuePeak/source-changes.md)。新 canonical 保留原控制流的注释。结论针对修复副本，不能外推为原源码已正确。

对共享字段的读取遵循已有源码处理规则：首次短临界区缓存 Obtain ID，原 ring 临界区内缓存 Abandon ID。两个 semaphore 调用仍在锁外，避免把阻塞调用包进 queue 锁。打印与新版仅记录诊断/测试计数的 NULL 宏被注释；其原始调试观测不在本次语义内。

## 队列资源与模块范围

本轮直接复用 `DataqueueState.v`、`DataqueueInv.v` 及 `CrtosGlobState.v` / `CrtosInv.v` 中原有集成。模块分析覆盖 Init、DeInit、Push、Pop、Peak 的完整生命周期，而函数规格范围按目标调用闭包确定。

`dataqueue_map` 是已发布对象的地址到状态映射，`dataqueue_inv` 用 `store_map` 拥有结构与完整连续数组。slot 的 None 是未知内容的实际存储，Some 保存已初始化指针/长度；Pop 不清槽，因此已消费槽仍保留旧值。结构的 semaphore 字段只保存 ID，Semaphore 对象仍由 semaphore 模块唯一拥有。payload 只是借用地址，本模块既不解引用也不释放它。原 ready 不变量要求正容量、合法 front/rear、数组长度和当前 FIFO 区间已初始化，允许容量 1 的零有效容量。

不增加独立 OS 外壳，不改原共享 invariant 语义。局部 ring 更新复用 `replace_dataqueues` 和 `dataqueue_publish`，精确保留其他队列和全部非 dataqueue 状态。各次 semaphore 调用自身的修改由对应抽象程序表示，不能把整个 Pop/Push 宣称为仅改 queue。

## 抽象程序与公开规格

新增 `lib/dataqueue/KPushDataqueue.v`、`KPopDataqueue.v`。程序按真实顺序组合：读 Obtain ID 的短临界区、Obtain、ring 临界区、Abandon；每次进入临界区都通过原 `os_atomic_cmd` 接入环境转换，不把一次完整调用伪装成原子操作。首次及 ring 观察检查 queue 存在，采用已有 `dataqueue_peak_entry`；访问权限由该观察的 `os_inv` 获得。

`abs_push_dataqueue` 的错误出口为 -1，成功出口为 0。成功 Obtain 后，若 ring 非满，写 rear 槽的指针与长度并按容量取模推进 rear；满则整个 ring 状态保持。两者随后都调用 Abandon(data)，忽略它的返回码，最终返回 0。

`abs_pop_dataqueue` 区分三个结果：

- `DqPopFailed`：Obtain 非 0，C 返回 -1，输出 cell 原样保留，无 ring 访问与 Abandon。
- `DqPopEmpty`：Obtain 成功但实际 ring 观察为空，C 返回 0，输出仍保持，随后仍 Abandon(blank)。
- `DqPopItem e`：实际非空，输出旧 front 的指针/长度，仅推进 front，数组各槽不变；随后 Abandon(blank)，C 返回 0。

Pop 的两个输出 cell 直接复用 Peak 的 `peak_data_slot` 与 `peak_length_slot`，caller 可以提供已知旧值 Some 或未知存储 None。两个 cell 与 `OutsideCritical` 分离组合，保证实际写权限和彼此独立；它们不属于 queue 或 payload 所有权。公开 With 不暴露内部 queue descriptor、semaphore ID 或对象地址 witness。

`dataqueue_push_ready_obligation` / `dataqueue_pop_ready_obligation` 仅是待证 Prop 陈述，不是 Axiom、Admitted 或已证引理。原有 split/merge/slot view 和模块集成义务继续按原状态保留。设计阶段不提前完成这些实现证明。

## 需要重点审阅的边界

“Obtain 成功”在当前模型下不意味着 ring 必然非空/非满。原代码仍有空/满分支，本次不擅自删除，也不加强入口把这些路径排除。因此 `return == 0` 不能解释为“必定插入/取出一个元素”。Abandon 的失败同样不改变上层返回值；这是原算法的真实行为。

缓存地址/ID 仅支持该次读取和后续参数传递，不证明跨解锁时对象世代稳定。模型允许不同临界区间环境变化，规格只要求每个真实解引用时可取得对应 live 对象；不声称排除并发销毁重建的 ABA，也不声称整体线性化 FIFO 性质。

默认白名单 001 适用于原 `Rely=True` 下 `assertS` 对候选观察的全称检查；审阅可以接受其可满足性未证的建模妥协，但不得把它写成已证调用可行性或增加新信任公理。信任边界沿用 TrustBase 的临界区/布局/源码处理规则。

下文说明 Semaphore 新增契约与复用依赖；来源未证契约不自动变成 trusted 或已证。最终设计审阅不表示 C 实现满足这些规格。

## Pop/Push 内存访问核对

| 访问 | 唯一 owner | 前后值及未修改资源 |
| --- | --- | --- |
| 首锁读取 sem_blank / sem_data | `os_inv` → `dataqueue_inv` → `store_dataqueue` → `dataqueue_fields` | 锁内原值缓存到局部 int32；结构与数组不变 |
| ring 锁内 front/rear/max_len/base 与对偶 ID | 同上 | ready 保证正模数和数组界限；对偶 ID 只读 |
| Push 的 base[rear].data/length | `dataqueue_buffer` → `store_array dataqueue_slot` | 允许覆盖旧 Some 或未知 None，变为输入指针/长度；其他槽不变 |
| Push rear | `dataqueue_fields` 中 UShort cell | 非满时变为 `(rear+1) mod max_len`，其余字段不变 |
| Pop 的 base[front].data/length | `dataqueue_buffer` 中已初始化 Some 槽 | ready 与非空条件提供读取值；整个数组不变 |
| Pop front | `dataqueue_fields` 中 UShort cell | 非空时变为 `(front+1) mod max_len`，其余字段不变 |
| Pop 的 *StartAddr、*size | caller 分离提供的两个输出 cell | 实际元素路径覆盖；错误/空路径保留旧值或未知内容 |
| payload 指向内存 | 不属于本模块 | 没有读写，不要求 payload allocation 或非空 |

所需 arithmetic/array split-merge/ready 保持的实现推导尚待未来证明；本轮编译确认这些陈述类型正确，不将其当作已证的内存转换。

## Semaphore Obtain / Abandon 的设计增量

`KSemaphoreObtain.v` 的 `abs_semaphore_obtain` 保留所有 int32 timeout 分支：非法 ID 或非法负 timeout 在锁前返回 -1；0 使用零 tick，-1 使用无限等待，有限等待调用修正后的 64 位乘法 tick 转换。锁内找不到 ID 返回 -1；正计数减一成功；零计数且不等待返回 -2。需要等待时把当前任务 exstatus 清零、按优先级挂入 semaphore pending；有限等待建立 delay，失败唤醒回滚并统一返回 -5。正常挂起退出锁后使用既有 KTASK_ASSIGN，随后以最小临界区读缓存 task 的 exstatus。这里不承诺阻塞终止，也不把永久等待视为必成功。

该程序的 assertS 明确检查等待路径的当前任务可挂起条件、有限等待的 null/inactive delay 与 delay window 条件、恢复后 task 仍存在。它们不是来自裸指针或 Rely=True 的保证，也不是已经证明的入口性质；采用默认白名单001的候选观察检查方式。SetDelay 的较窄复用契约限制必须在这一步呈现，不能藏在口头说明中。queue、无关 semaphore 和任务字段由局部 replace/既有 suspend-delay-wakeup关系保持。

`KSemaphoreAbandon.v` 的锁内结果区分未登记 -1、空等待链计数饱和 -3、计数加一成功、非空等待链直接唤醒首任务成功。仅最后一路在锁外调度；LinklistResume 不设置 exstatus，与删除用的 ResumeAll 不同。`semaphore_resume_head_effect` 直接复用全局 `wakeup_semaphore_head`，描述 pending、delay、ready 的一致迁移而不复制任务所有权。两个 K wrapper 仅调用静态 done 表唯一指向的底层实现。

新增函数 contract 位于各 canonical `.c`，caller-local 声明完整可读。GetKTaskDescriptor、IdGetObj、IsDoubleLinkListEmpty、KTaskWakeup、SetDelay 复用已有契约，具体适用性和来源版本由闭包审阅记录固定；复用不声明这些 C 函数已获本轮证明。CONTAINER_OF/锁及 KTASK_ASSIGN 沿用 TrustBase/源码处理模型。所有新 `.v` 为设计语义，无新 C 实现证明。

## 新增闭包接口与移植边界

`lib/pendlist/LinklistSuspend.v` 和 `kernel/pendlist/LinklistSuspend.c` 为本轮信号量等待链新增规格。VRTOS 的同名规格只覆盖 Msg/Event，不能据此把该函数当复用边界。这里复用合法 flag 的优先级插入关系，针对 SemaphoreState 的地址列表编写准确更新：保留地址、ID、value和管理顺序，仅把 sched_link 从 task 自持集合转交到目标 semaphore。FIFO、PRIO 和非法 flag 提前返回均保留；当前源码先检查 flag，不沿用旧版先挂起再失败的行为。

其 SuspendKTask 契约来自 VRTOS `annotated_C/src/kernel/pendlist/linklist_suspend.c` 的 `suspend_by_id_ic`，所用纯定义移入 `lib/task/KTaskSuspend.v`，适配本工程的状态表示并显式保持 dataqueue 分量。只复制所需语义，没有复制或声明已完成其 C 实现证明。链表插入直接复用本工程两个 canonical 的 dispatch_case；容器转换沿用现有 TrustBase。

`lib/delay/KTaskSetDelayState.v` 移植 VRTOS 的 null/inactive delay 设置关系，保留当前 tick 加 ticks、按循环比较插入、malloc失败保持原态等行为，更新只涉及 task.delay、inactive map、active DLL。共同半区间窗口与 null/inactive 前提由 Obtain 等待路径的观察检查承担，不假称原 os_inv 自动蕴含。相关资源拆分与恢复仍是后续证明义务；本阶段只检查语义、类型及契约适用性。

`lib/common/TickConversion.v` 与 `kernel/common/CalculateTickFromTimeMs.c` 是新写规格：当前源码先将 ms 扩宽为64位再乘100，而 VRTOS 旧契约先按32位回绕，不能保持语义地复用。当前uint32毫秒输入乘100不溢出uint64，结果保留最少1 tick和余数5至9才加1的原规则。此叶子无callee，也不拥有共享内存。
