# 从 os_inv 拆出 semaphore 资源：VRTOS 的做法与 CRTOS 的适配

日期：2026-10-30。参考 `/home/xinra/vrtos` 当前工作树（HEAD 为 `162a5e7`），并对照 CRTOS 根 `lib/` 和 `ksemaphoredelete-trial-261025-1` 的当前文件。

可以用 strategy 从 `os_inv` 中按需拆出 semaphore 相关资源。关键是先定义并证明“拆出什么、剩下什么、修改后如何归还”，再让 strategy 自动应用这些关系。这样，函数接口仍可使用 `os_inv` 或模块 predicate，具体字段的展开留在实现证明中。

这里的“拆出”有两种不同含义：访问时临时借出资源，随后恢复 invariant；删除时撤销对象登记，将对象所有权移出 invariant，交给调用者释放。两者需要不同的归还关系。

本文是源码调查和适配建议，没有执行新的 QCP symbolic、StrategyCheck 或 Rocq 编译。下文明确区分 VRTOS 已存在的定义及证明脚本与本地待补接口；存在 `Qed` 脚本不等于本次已重新验证通过。文中的资源公式是解释和引理设计示意，不是新的函数 contract。

**1. VRTOS 已经怎样做了**

**1.1 从总 invariant 借出一个子模块，其他资源放进 frame**

VRTOS 的 [os_inv](/home/xinra/vrtos/lib/common/CrtosInv.v:793) 组合了 task、assign、delay、semaphore 等资源。一个很直接的例子是 [critical_task_view.strategies](/home/xinra/vrtos/annotated_C/strategy/critical_task_view.strategies)：

- rule 1 在右侧需要 task ID manager 时，检查目标 manager 地址，消耗左侧 `os_inv`，加入 `task_fields` 和 `os_task_fields_frame`，继续向下寻找 manager 资源。
- rule 2 在 `post` 阶段，将同一 `sg, st` 的 `task_fields` 和 frame 合回 `os_inv`。
- rule 3 对任务状态查询采用相同的分层展开方式，并保留临界区 token。

资源关系可简写为：

```text
os_inv(sg, st)
  ⇄ task_fields(sg, st) * os_task_fields_frame(sg, st)
```

[os_task_fields_frame](/home/xinra/vrtos/lib/common/CriticalViews.v:13) 是具体的剩余资源组合：包含自持调度节点、IPC、delay、assign 等，排除了已经借出的 task fields，也不拥有锁 token。[对应证明](/home/xinra/vrtos/VC/strategy_proof/critical_task_view_strategy_proof.v:10) 展开这些定义，通过分离逻辑重组资源。

这支持在 CRTOS 中建立类似的 semaphore view。但上述 `post` 规则要求同一状态，不能直接用来把任意更新后的资源塞回旧 frame。

**1.2 semaphore 模块内部已有对象级 open/close**

VRTOS 的 [SemaphoreInv.v](/home/xinra/vrtos/lib/common/SemaphoreInv.v:91) 将模块资源分成四部分：ID manager、对象管理 DLL、对象 map、静态 done 表。对象本身的 `store_semaphore` 拥有 value、padding 和等待 DLL。

该文件定义了 `semaphore_inv_except`，使用 `store_map_missing_i` 保存除目标对象外的对象内存，并保留其余模块资源。随后给出两个带 `Qed` 的引理：

```text
前提：st.sem_obj_map(sem) = Some(obj)

semaphore_inv(wait, sg, st)
  |-- semaphore_inv_except(wait, sg, st, sem)
      * store_semaphore(wait, sem, obj)

semaphore_inv_except(wait, sg, st, sem)
  * store_semaphore(wait, sem, obj)
  |-- semaphore_inv(wait, sg, st)
```

实现分别调用 `store_map_split` 和 `store_map_merge`。见 [semaphore_inv_open](/home/xinra/vrtos/lib/common/SemaphoreInv.v:116) 与 [semaphore_inv_close](/home/xinra/vrtos/lib/common/SemaphoreInv.v:130)。

这两个引理处理原状态、原对象的拆出与归还。`close` 不是通用的对象更新定理：如果 obj、map 或等待任务的状态发生变化，还要证明更新后对象和模块的一致性。

因此，可以把这些关系包装成 strategy，但不能把“存在 open/close 引理”表述为“已经存在可直接用于 CRTOS semaphore 删除的完整 strategy”。

**1.3 唤醒路径用 restore 记录更新后的归还条件**

最值得参考的是 VRTOS 的唤醒证明。它需要从自持节点或某个 IPC 等待 DLL 中摘出任务，再移入 ready 队列。来源资源由 [suspend_source_transform](/home/xinra/vrtos/lib/common/SchedNodeSource.v:33) 描述。其成员分支的核心形状是：

```text
P |-- exists source,
        suspend_source_pre(T, task, source)
        * (suspend_source_post(T, source) -* Q)
```

这里还要求目标成员关系和 owners 的 `NoDup`，不是无条件展开。`P` 是原容器资源，`Q` 是目标容器后态。`-*` 是分离蕴含：调用者交回指定的局部后态后，才能恢复 `Q`。

对于 linked 来源：

```text
pre  = 等待 DLL(prefix ++ task :: suffix)
post = 等待 DLL(prefix ++ suffix)
```

摘除后的目标节点单独交给 ready 插入流程；它不再归还给原等待 DLL。对于 detached 来源，pre 是目标自环节点，post 是 `emp`。

VRTOS 通过两层引理将这个关系落实到 semaphore：

- [suspend_source_semaphore_object](/home/xinra/vrtos/lib/common/SchedNodeIpc.v:20)：只借出对象的等待 DLL，保留 value 和 padding。
- [suspend_source_semaphore_inv](/home/xinra/vrtos/lib/common/SchedNodeIpc.v:198)：将对象级关系提升到整个模块，保留 ID manager、管理链、done 表，并更新对象 map 中的等待序列。

这些引理允许任务 map 从 `T` 变为 `U`，但要求所有非目标任务的映射不变。目标任务摘除后，剩余等待任务仍能满足新 map 下的 SUSPEND 关联。

[suspend_source_restore](/home/xinra/vrtos/lib/common/SchedNodePool.v:148) 进一步把归还目标固定为更新后的挂起来源集合：

```text
suspend_source_post(T, source)
  -* suspend_sched_pool(U, sg, suspend_unlink_state(task, st))
```

这里的 `suspend_sched_pool` 包含自持节点以及 semaphore、mutex、msgqueue、event 的等待资源，不包含 task fields。restore 保留的是可消费的空间关系，不能当作可任意复制的纯命题。

**1.4 strategy 调用这些引理，控制何时展开和恢复**

[wakeup_views.strategies](/home/xinra/vrtos/annotated_C/strategy/wakeup_views.strategies) 的 rule 2/3 按自持与等待链两条来源拆开 `os_inv`，得到：

```text
wakeup_global_frame
* delay_inv
* task_fields
* assign_ready_pending
* 目标来源的局部资源
* suspend_source_restore
```

对应证明直接使用 [wakeup_open_detached / wakeup_open_linked](/home/xinra/vrtos/lib/task/KTaskWakeupViews.v:14)。[sched_source_views.strategies](/home/xinra/vrtos/annotated_C/strategy/sched_source_views.strategies) 在摘链后消费 restore 和剩余 DLL，恢复来源集合，并留下目标节点权限供 ready 插入。

VRTOS 在 [ktask_wakeup.c](/home/xinra/vrtos/annotated_C/src/kernel/task/ktask_wakeup.c) 中显式安排这些阶段：

```text
提取来源纯事实 → 按来源分支 → do wakeup_unfold
→ 摘链 → do sched_source_fold
→ 取消 delay → 更新 task / ready
→ do wakeup_fold_os
```

因此，strategy 不必全部依赖 `core/post` 自动触发。对跨模块、多步骤的更新，可以用具名策略组和 `do` 明确指定应用点。

最后恢复总 invariant 的工作由 [wakeup_finish](/home/xinra/vrtos/lib/task/KTaskWakeupProof.v:584) 和 `wakeup_close` 承担，包括新的 task/assign/delay/global 一致性。尤其要重新证明调度节点所有者的互斥和覆盖：目标节点离开等待链后，必须由新的 ready 队列接管。

**2. 当前 CRTOS 的资源归属与迁移差异**

当前 [os_inv](/home/xinra/crtos/lib/CrtosInv.v:47) 已包含 `semaphore_inv`，所以有资源来源。`InsideCritical` 在 [CrtosRules.v](/home/xinra/crtos/lib/CrtosRules.v:114) 中只提供临界区 token 和纯上下文，不替代共享内存权限。只有 token 而没有 `os_inv`，不能通过 strategy 凭空取得 semaphore 内存。

当前 semaphore 的 ownership 如下，依据 [SemaphoreInv.v](/home/xinra/crtos/lib/SemaphoreInv.v:98) 和 [TaskInv.v](/home/xinra/crtos/lib/TaskInv.v:193)：

| 资源 | 当前 owner | 拆分时的要求 |
|---|---|---|
| `sem->id.id`、ID link、bitmap、哈希桶 | `store_idmanager` | 对象 payload 不能重复拥有 ID 字段 |
| `sem->link` 管理链节点 | 外层管理 DLL | 暂时借出 payload 不等于 C 已执行摘链 |
| `sem->value`、padding | `store_semaphore` | 保留到重新封装或最终回收 |
| `sem->pend_list` 哨兵、等待任务的 sched_link | 内层等待 DLL | 节点摘除后必须明确交给哪个 owner |
| 等待任务的 exstatus、调度标量等字段 | `task_inv` 中的 descriptor 资源 | 从等待 DLL 得到任务地址，不等于取得这些字段权限 |
| 任务 delay 对象与延时链 | `delay_inv` | 唤醒需要独立借还 |

`pure_suspend_sched_link` 只提供 task map、节点地址和 SUSPEND 状态的纯关联；它不拥有任务字段。`semaphore_pending_nodes` 也只是纯关系，不能单独支持 `list->node_next` 的读取。

两边的表示差异决定了可迁移的是证明结构：

| 项目 | VRTOS | 当前 CRTOS |
|---|---|---|
| SemaphoreState | 对象 map、指针 list、ID manager 分开记录 | `list SemaphoreAbs`，元素携带地址、ID、value、等待任务地址序列 |
| 对象内存 | `store_map (store_semaphore ...)` | 外层管理 DLL 的 payload |
| 对象拆出接口 | `store_map_missing_i` 和 map split/merge | 需要管理 DLL 的 payload focus/restore，或带前后缀的等价接口 |
| ID manager 抽象值 | 独立状态字段 | 由对象序列的 `semaphore_manager` 派生 |
| done 表 | semaphore invariant 持有 | 本地已归一为直接调用，不持有运行时表资源 |
| store 实例 | Arch32 BigEndian | Arch32 LittleEndian |

本地表示见 [SemaphoreState.v](/home/xinra/crtos/lib/SemaphoreState.v:11)。尤其在删除时，C 先移除 ID、再移除管理链，这个中间态不能硬塞回由同一对象序列同时派生两者的稳定 `semaphore_inv`。

**3. 建议怎样设计本地的 view 和 strategy**

以下名称均为建议名，不表示仓库已有对应定义或证明。

先补一层 `os_semaphore_frame(sg, st)`，精确拥有 `os_inv` 中除 semaphore 模块以外的资源。证明同一状态下的分解与重组：

```text
os_inv(sg, st)
  ⇄ semaphore_inv(wait(st), sg.os_semaphore_stable, st.os_semaphores)
     * os_semaphore_frame(sg, st)

wait(st) = pure_suspend_sched_link(st.os_tasks.task_desc_map)
```

frame 要保留原来的纯约束，且不重复拥有借出的模块。策略只有在右侧需要 semaphore 的 manager、对象或等待 DLL，并能确认目标归属时才展开，避免遇到任何 `os_inv` 就展开全部模块。

第二层为目标 semaphore 提供对象/等待链 focus。由于本地对象内存在管理 DLL 的 payload 中，必须保留外层链结构及其他对象，不能直接照抄 VRTOS 的 map missing-cell 定义。对于只读等待链的场景，可采用这种资源关系：

```text
semaphore_inv(...)
  |-- 目标等待 DLL * 其余模块资源及归还条件
```

第三层再复用 DLL 或字段 strategy，满足当前实际读取或写入所需的资源。

| 操作 | 合适的策略方式 | 恢复条件 |
|---|---|---|
| ID 查询、读取等待链首节点、判空 | 按需 `core` 展开；同态 `post` 或显式 close | 原资源已归还；查询的 found view 也已正确收回 |
| 写入目标 task 的 exstatus | task 字段 view 与写权限规则 | 新 descriptor 与其他模块对 task map 的引用一致 |
| 唤醒任务、跨队列转移 sched_link | 具名 open/restore/fold 策略组 | 新 task、delay、ready、等待链及全局一致性成立 |
| ID 注销后再摘除管理 link | 明确的删除中间态 view | 所有登记均撤销后，才能恢复稳定模块 invariant |
| 形成私有 retired 对象 | 删除提交引理，必要时包装具名 strategy | 新 `os_inv` 不再拥有对象，局部资源完整 |

读规则和写规则还要分开设计。VRTOS 的 [access_exstatus_view.strategies](/home/xinra/vrtos/annotated_C/strategy/access_exstatus_view.strategies) 有针对 `undef_data_at(..., I32)` 的写权限匹配；它的特定规则依赖 running-task 关系，不能直接套到 semaphore 等待任务。具体匹配形状应以本地生成的资源需求为准。

对于变化后的状态，需要额外的 update/reindex 引理。不能声称：

```text
新 semaphore_inv * 任意旧 os_semaphore_frame
  |-- 新 os_inv
```

等待任务 map 改变时，其他 IPC、ready、zombie 等 predicate 即使没有写入其物理内存，也可能引用旧 task map。必须证明这些关联仍成立，才能把 frame 换成新状态索引。

strategy、局部注解和 Rocq 引理的分工可沿用 [QCPStrategy.md](/home/xinra/vrtos/QCPStrategy.md)：表示层的拆分、字段权限和重组优先使用 strategy；循环推进、具体状态转换和全局一致性由引理证明；不适合安全匹配的局部步骤保留 `which implies`。VRTOS 的 Wakeup 自身也保留了 delay 更新后的显式重索引步骤。

**4. 落到当前 LinklistResumeAll 和 _SemaphoreDelete**

[LinklistResumeAll.c](/home/xinra/crtos/ksemaphoredelete-trial-261025-1/annotated_C/src/LinklistResumeAll.c) 每轮先读取等待队首，写 `task->exstatus = -ERROR`，再调用 `KTaskWakeup`。当前选用的 `semaphore_pending_head_ic` 要求调用点持有完整 `os_inv`。

因此，本轮资源流转应是：

```text
os_inv(current)
  → 借出 sem 等待 DLL，读取 node_next，确认队首 task
  → 归还等待 DLL，恢复当前 os_inv
  → 从 task 资源借出 exstatus，执行 C 写入
  → 更新 descriptor，重索引相关 frame，恢复 os_inv(marked)
  → 取得 task ID 读资源并归还
  → 使用 marked 状态调用 KTaskWakeup 的 semaphore_pending_head_ic
  → 获得 os_inv(next)，等待序列剩余 tail
```

实际实现可以合并相邻的借还步骤，但调用边界必须满足完整的 ownership。不能同时携带完整 `os_inv` 和另一个独立拥有同一等待链的 `store_dll`；也不能只交给 Wakeup 半个 invariant，再假定 callee 能自行补回。

exstatus 更新要用本地 `set_task_desc_exstatus` 建立 marked 状态。等待链的纯 payload 不读取 exstatus，这为重索引提供了依据，但仍需证明其与新 task map 的关联。VRTOS 的 [TaskExstatusView.v](/home/xinra/vrtos/lib/task/TaskExstatusView.v:138) 提供 task 字段级 open/close 的参考，恢复总 `os_inv` 的桥接还要按本地定义补齐。

每次 Wakeup 后，要从新的等待序列重新取得下一轮队首，不能沿用已经转入 ready 的节点作为等待链遍历游标。循环证明还要连接逐步唤醒与整体 `semaphore_resume_all_effect`；strategy 本身不会代替这个归纳证明。

对 [_SemaphoreDelete.c](/home/xinra/crtos/ksemaphoredelete-trial-261025-1/annotated_C/src/_SemaphoreDelete.c)，建议按现有调用顺序安排视图：

1. 加锁取得 token 和 `os_inv`，按需拆出 semaphore ID manager 做查询。成功返回的 `store_idmanager_found` 需要归还/转换桥；失败分支也必须恢复完整资源以解锁。
2. 借出目标等待 DLL 做判空，归还后再调用要求完整 `os_inv` 的 `LinklistResumeAll`。
3. 等待链清空后进入删除视图。先注销 ID，保留“ID 已移除、管理 link 尚未摘除”的真实中间资源；再调用管理链摘除函数。
4. 证明新模块登记与全局约束，得到 `os_inv(after) * SemaphoreRetired(sem, value)`。
5. 使用新 `os_inv` 解锁，私有 `SemaphoreRetired` 作为 frame 穿过解锁；随后转换为 `SemaphoreRaw` 交给 `x_free`。

这里已经不再是“读完按原样归还对象”：新 `os_inv` 必须排除 sem。否则对象一边仍由全局 invariant 拥有，一边又交给 `x_free`，会重复计算 ownership。

本地 [KSemaphoreDelete.v](/home/xinra/crtos/lib/KSemaphoreDelete.v:108) 已定义 `SemaphoreRetired`。但 `semaphore_retired_raw_obligation` 和 `semaphore_resume_all_effect_steps_obligation` 当前是 `Definition ... : Prop` 的待证陈述，不能当作可调用的已证引理。

**5. 建议的落地顺序与证明范围**

先实现一个最小只读闭环：从 `os_inv` 借出 semaphore manager 或指定等待 DLL，完成查询/判空，再原样收回。这样可以检验 ownership、地址定位和策略触发是否正确，不必一开始就迁移整个唤醒证明。

随后补目标 task 的 exstatus 更新和总 invariant 重建；再实现删除中间态与 retired 资源转换。跨等待链、delay、ready 的 Wakeup 证明，按当前采用的 dependency boundary 决定是否迁移；仅有导入 spec 或 strategy 文本，不能算作本地实现证明已经完成。

建议的文件分工是：本地 `lib/` 放 view 定义、拆分/归还和状态一致性引理；`annotated_C/src/headers/` 放 Coq 导入与声明；`annotated_C/strategy/` 放规则；策略生成目标及证明按项目当前 VC 配置接入。函数 canonical contract 继续保存在各自 annotated C 中。

VRTOS 的 [wakeup_views_strategy_proof.v](/home/xinra/vrtos/VC/strategy_proof/wakeup_views_strategy_proof.v) 使用上述 view 引理完成规则证明，[goal_check](/home/xinra/vrtos/VC/strategy_proof/wakeup_views_strategy_goal_check.v) 将实现装配到策略正确性接口。后续本地实现也应完成对应链路：strategy 可匹配、生成的 entailment 有证明、goal_check 接入函数验证。只让 symbolic execution 继续运行不足以证明规则正确。

本次核对的 VRTOS semaphore open/close、source-transform、Wakeup view 及相关 strategy proof 文件中未见 `Admitted`；这不是完整依赖闭包审计。VRTOS 仍有 [布局公理](/home/xinra/vrtos/lib/common/StructFieldOffsetAxiom.v:388)，Wakeup C 注释也标明了查询发布性的授权假设切点，不能据此宣称整条实现无额外假设。生成的 `Module Type` 中用于声明待实现规则的 `Axiom` 则是接口要求，应检查是否由 `goal_check` 的证明模块实现，不能只凭关键词判断。

适用于当前 spec 设计的结论是：函数接口可以保持在 `os_inv` 或模块 predicate 层次，函数体访问字段所需的资源由已证明的 view/strategy 提供。跨模块更新和删除阶段要先设计好中间资源及恢复条件，再实现自动展开与折叠。
