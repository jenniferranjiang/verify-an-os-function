---
kind: predicate-design
status: review-passed
module: "semaphore"
source_revision: "source-s2-2adc70fc1afc"
predicate_revision: "predicate-r23-1845f34ef435"
formal_sources:
  rocq_files:
    - "lib/SemaphorePure.v"
    - "lib/CrtosOSPure.v"
    - "lib/CrtosOSProtocol.v"
    - "lib/SemaphoreProtocol.v"
    - "lib/SemaphoreRep.v"
    - "lib/CrtosOSRep.v"
    - "lib/SemaphoreCritical.v"
  symbols:
    - "SemaphoreStable"
    - "SemaphoreState"
    - "CrtosOSStable"
    - "CrtosOSWorld"
    - "CrtosSchedulerState"
    - "crtos_task_placement"
    - "crtos_os_world_wf"
    - "crtos_os_sts"
    - "crtos_os_protocol_meta_properties"
    - "crtos_os_owner_reachable_preserves"
    - "CrtosOS_C_Rules"
    - "CrtosTaskStableContext"
    - "store_crtos_task_done"
    - "store_crtos_ready_vector_done"
    - "crtos_semaphore_os_inv"
    - "crtos_wakeup_step_progress"
    - "semaphore_atomic_step"
    - "SemaphoreCritical"
    - "semaphore_inv"
    - "store_semaphore_id_manager"
    - "store_sem_uninitialized_bucket"
    - "store_semaphore_registry"
    - "semaphore_layout_32_ok"
    - "semaphore_task_bridge"
    - "semaphore_slice_inv"
    - "semaphore_alloc_entry_inv_init"
    - "semaphore_alloc_entry_inv_step"
    - "semaphore_alloc_entry_inv_exit"
    - "semaphore_byte_not_full_has_zero_bit"
    - "semaphore_alloc_entry_inv_first_free"
review:
  reviewed_revision: "predicate-r23-1845f34ef435"
  reviewed_by: "predicate_id_view_review (affected-only review)"
  conclusion: "review-passed"
---

# Predicate 设计报告：`semaphore`

> 正式定义及字段对应以七个 `.v` 文件为准；本报告只记录跨文件设计、C 分析与审阅证据。

## 1. Scope 与依据

- 用户批准验证配置：`board/stm32f103-nano/config`，32 位 Cortex-M3、非 SMP，semaphore、small allocator 与 shell 启用，`xs_kdbg.h` 无条件定义 `KERNEL_DEBUG`，`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`。
- 权威模块：`kernel/thread/semaphore.c` 的 10 个 active 函数：五个 `_Semaphore*` 实现和五个 `KSemaphore*` wrapper。
- source manifest：从 trial 根对下列 17 个文件执行 `sha256sum <files> | sort | sha256sum`，结果 `2adc70fc1afc9adc12e575002801d20894672db63764e7fdc7825754648893c2`：`semaphore.c`、`id.c`、`double_link.c`、`CriticalArea.c`、`linklist.c`、`ktask.c`、`delay.c`、`cmd.c`、`xs_sem.h`、`xs_id.h`、`xs_klist.h`、`xs_base.h`、`xs_kdbg.h`、`xs_assign.h`、`xs_ktask.h`、`xs_isr.h`、批准的 board config。s2 只把此前已经作为 `DISABLE_INTERRUPT`/`ENABLE_INTERRUPT` 映射依据读取的 `xs_isr.h` 纳入 drift gate；权威文件内容、配置与 formal predicate 均未变化。
- `semaphore.c:24-28` 把 `KDEBUG_NOT_IN_INTERRUPT` 重定义为空；`SYS_KDEBUG_LOG(KDBG_IPC, ...)` 因 `KDBG_IPC=0` 为常量死分支，但 `NULL_PARAM_CHECK` 仍展开为 `KPrintf` 加无限循环，不能删除。`done` 在同一 TU 只有静态 initializer、无 writer；QCP 不支持函数指针，annotated C 将五个 dispatch 分别解析为对应 `_Semaphore*`，predicate 不拥有或复制 `done` 表。
- predicate 阶段没有 trusted callee。目标 spec 闭包所需 trusted symbols 必须另由用户逐名批准。

### 模块 C 分析

- `_SemaphoreCreate`：allocator NULL 直接 `-ENOMEMORY`；否则整块清零、lock、ID 登记。ID 满时释放私有对象、unlock、返回 `-ENOMEMORY`；成功时写 value，初始化 pend head，把 registry link 插入 `k_sem_list`，unlock 后返回首个空闲 ID。无循环。
- `_SemaphoreDelete`：负 ID 早返回；lock 后按 `uint16` 形参语义查询（非负 `int32` 会截断），不存在则 unlock。存在时必要时唤醒全部 waiter，移除 ID/bucket 与 registry link，unlock 后 free；有 waiter 时触发调度。`LinklistResumeAll` 的循环只有每个 pending task 可成功 wake/remove 时才推进。
- `_SemaphoreObtain`：负 ID 返回 `-ERROR`；计算 wait ticks，lock/query。不存在返回错误；value>0 时递减成功；零等待返回 timeout；否则当前 task 置 `exstatus=EOK` 并按优先级插入 pend list，正等待值还调用 `KTaskSetDelay`。该调用失败值被忽略，因此 predicate 不承诺一定建立 timeout。解锁、调度，最终读取 task exstatus。
- `_SemaphoreAbandon`：负/不存在返回错误；有 waiter 则 wake 一个并调度，否则 `uint16 value++` 可按 65536 回绕；返回 EOK。
- `_SemaphoreSetValue`：负/不存在返回错误；旧值相等时 stutter；否则有 waiter 就 wake all，随后写输入 `uint16` value，必要时调度。
- 五个 public wrapper：空 debug guard，加由唯一静态 initializer 解析的直接调用，返回/转发实现结果。
- create 可达 ID helper：`AllocId` 两层扫描 bitmap、选择首个空闲 ID 并置 bit；`InsertObj` 对 BSS bucket lazy-init 后表头插入；`IdInsertObj` 串接两者并写 `idnode->id`。
- critical helper：非 SMP `CriticalAreaLock` 保存 PRIMASK 并递增 TU-static `uint16 KTaskOsAssignLockNest`；unlock 在非零时递减并恢复准确 handler。协议必须允许 nesting 且进入前深度小于 65535。
- DLL helper：初始化写 self/self；insert-after 写四个 pointer slot。模块函数自身无循环；`AllocId` 和跨模块 `Linklist*` 有上述循环。
- 外部直接 borrower：shell `ShowSem` 在 critical 内遍历 `k_sem_list`，读取 id/value/pend list，并通过 task 模块借用 task name；它不取得 task object ownership。

## 2. C 对象与抽象状态

- `SemaphoreStable` 保存 `k_sem_id_manager`、16-byte bitmap、16 个连续 bucket heads、`k_sem_list` 的地址以及固定容量；不保存 `done`。
- `SemaphoreObject` 用 allocation address 追踪一次生命周期，保存注册期 ID、`uint16` value 和 pend-list 物理顺序中的 task 基址。地址在 ID 登记前和注销后仍稳定，故生命周期身份不用 ID。
- `SemaphoreState` 只保存 `k_sem_list` 顺序中的 published objects。ID bitmap/buckets 都由同一对象列表派生，不保存第二份 `VarIdmanager` 权威状态。
- `SemBucket = option (list SemaphoreObject)`：`None` 是 BSS `(NULL,NULL)`，`Some nil` 是 lazy-init 后的空 DLL，`Some xs` 是非空 bucket；对象顺序由 ID 插入语义与 registry 表头插入共同派生。
- `semaphore_atomic_step` 覆盖 create/delete/immediate obtain/pend/abandon/wake/timeout/set-value；R/G 是这些真实动作的有限自反传递闭包。Pend 允许按当前 priority 在任意 prefix/suffix 边界插入；timeout 可删除任意 waiter；set-value 仅在新旧值不同时清空 waiter，不错误要求随后一直保持排序。

## 3. Predicate 分层与 Formal Sources

- `SemaphorePure.v`：纯状态、validity、first-free、AllocId loop invariants、atomic transitions、LastSeen 与 create command。
- `CrtosOSPure.v`：直接复用 `VarGlobalState`/`TaskDescriptorAbs`，新增 scheduler/delay 纯状态、`sched_link` placement、具体 semaphore-task bridge、组合 well-formedness、pending delta 与 `LinklistResumeAll` 严格递减 measure。
- `CrtosOSProtocol.v`：统一 nested STS；同一 carrier 同时保存 task/scheduler/semaphore world、每层 critical depth token 和 Task create reservation owner token。普通 exit 使用组合 R/G；publish/rollback/finalize 保留原 Task owner-sensitive 语义。
- `SemaphoreProtocol.v`：不再实例化 semaphore-only STS，只导出统一 OS protocol 的模块命名适配。
- `SemaphoreRep.v`：carrier-local DLL、bitmap/bucket/manager、registry/object、create/delete lifecycle views 与 task bridge。
- `CrtosOSRep.v`：在统一 carrier 中表示 Task ID manager/registry、真实 116-byte TaskDescriptor runtime、ready queues、Assign metadata、active/inactive delay objects，并与 semaphore heap 组合成 `crtos_semaphore_os_inv`。
- `SemaphoreCritical.v`：统一 STS view 与具体 `KTaskOsAssignLockNest`/PRIMASK handler 栈适配。
- 对外稳定接口是 `semaphore_inv`、`SemaphoreCriticalOutside/Held` 及按动作命名的 lifecycle predicates；bitmap byte、bucket recursion 与链表 cursor 不进入 public API。
- predicate candidate revision：`predicate-r23-1845f34ef435`；完整 manifest `1845f34ef4351d7cb9e97b241d242c8e5295323530c1428066c2f1f273852bfc`。

## 4. Ownership 与 Lifecycle

- manager 四字段、bitmap、bucket heads、每个 `sem->id.id/id.link`：唯一由 `store_semaphore_id_manager` 拥有。
- registry head 与每个 `sem->link`：`store_semaphore_registry` 的 DLL spine；同一 payload 的 value 与 pend head 由 `store_semaphore_body` 拥有。
- pending task 的 sched-link prev/next：所在 semaphore pend DLL；bridge 直接查询现有 Task `task_desc_map` 并要求 `VTS_NORMAL`、masked status `TASK_SUSPEND`、placement 指向该 semaphore，不再接受任意纯谓词。
- ready task 的 sched-link：`store_crtos_ready_queues_from` 中对应 priority DLL；status=RUNNING/INIT 及 local-SUSPEND task：descriptor cell 中的 detached self-loop；external waiting 由 `store_crtos_external_wait_queues` 拥有 head/spine，zombie 由 `store_crtos_zombie_queue` 拥有。`Assign.os_running_task` 只是当前指针，当前任务变成 SUSPEND/CLOSE 后、下一次调度前仍可指向它，不进入 link-owner `NoDup` 集。`crtos_scheduler_wf` 同时检查正向 placement、容器成员反向注册、Done 绑定和非 INIT priority/bitmap 一致性。
- Task runtime 的普通字段由 `store_crtos_task_body` 拥有；Task ID node 与管理 link 分别由 Task ID manager/registry 拥有。实际 Cortex-M3 event bitfield 在 offset 84 打包成一个 `UInt`，exstatus/link/id/Done 分别位于 88/92/100/112，总大小 116；没有复用 Task create trial 的 120-byte 双 event 字段布局。
- descriptor 中的 `task->Done` 只拥有指针槽；全局 `struct KTaskDone Done` 的八个函数指针槽由 `store_crtos_task_done` 唯一拥有，覆盖 `SuspendKTask`/`KTaskWakeup` wrapper 的真实二次读取。
- `Assign.ready_vector_done` 指针槽由 scheduler predicate 拥有；其值固定为 `SingleReadyVectorDone`，三个 policy 函数指针槽由 `store_crtos_ready_vector_done` 唯一拥有，覆盖 suspend/wakeup 内部的 `remove/insert` dispatch。
- active Delay link/payload 由 `xiaoshan_delay_head` DLL 拥有；inactive Delay 保留 payload 与 detached self-loop；`task->delay` 与 delay entry 由 `crtos_scheduler_wf` 双向关联。
- `PendingRemoved` 强制目标 task 从 `CSP_SEMAPHORE_PENDING` 转为某个 `CSP_READY priority`，并由 `semaphore_pending_removed_progress` 机器证明全局 pending measure 严格减一；因此 `LinklistResumeAll` 不再依赖未绑定的“可唤醒”口头条件。
- `semaphore_pending_member_wake_ready` 从 bridge 推出 pending task 的注册、SUSPEND、Done dispatch、priority 与 bitmap 前提；`crtos_wakeup_step_progress` 把一次成功 wake 的正式 OS step 连接到严格递减 measure。
- create：`store_sem_allocated -> store_sem_zeroed_private -> store_sem_manager_id_allocated -> store_sem_registered_unpublished -> store_sem_publish_ready -> semaphore_inv(new)`。ID-full 在发布前释放零化私有对象并恢复 old invariant。
- delete：先确保 waiter links 归还 task/scheduler，再从 manager 和 registry 取回两个 intrusive nodes，形成 `store_sem_detached` 后交给 allocator。
- linker/BSS 和 `k_sem_list` 静态 self-link 建立 `store_semaphore_static_initial`；无虚构 init token。
- `ShowSem` 只在 critical 内借用 registry/body；`semaphore_slice_inv` 把 pending 地址连接到 task 注册/可唤醒投影，task name 仍由 task 客户端 borrow，不归 semaphore 所有。

## 5. 关键设计选择

- 未直接复用 `task-proof/lib/idnode.v`/`dll.v` 的空间谓词：它们已实例化在旧 Task carrier，不能与统一 carrier 做空间合取；`CrtosOSRep.v` 复用同一 `StableIdmanager`/`VarIdmanager`/`IdNodeAbs` 纯状态，并仅重建 carrier-local heap interpretation。没有复制 Task abstract state。
- 不定义 `SemaphoreTaskView`；pending 只保存 task address，跨模块状态由 bridge/interface 提供。
- 不为 `done` 建 state/predicate；direct-call normalization 保留在 spec extraction 记录。
- 当前 QCP 的 `struct_padding` 不自动产生 ownership；`Semaphore` 的 offset 2..3 与 14..15 两段 padding 由 `CharArray` 显式拥有，并由 `semaphore_layout_32_ok` 绑定批准的 32-bit ABI。所有 allocate/zero/published/detached 生命周期 view 合计覆盖完整 32 bytes。
- `IdGetObj(uint16)` 的截断语义必须由非 create API spec 保留；不能把所有 `id>=128` 直接写成失败。本轮目标 create 不接收 ID。

## 6. 检查结果

- Coq 8.20.1/OCaml 4.14.1：按 `_CoqProject` 顺序编译七个文件，全通过；`.vo` 全部生成。
- trust scan：`rg -n '\b(Parameter|Axiom|Admitted|admit)\b' lib -g '*.v'` 零匹配。
- `coqchk`：七个正式 library 全部通过。
- VsRocq 已映射当前绝对路径 `/home/xinra/crtos/ksemaphorecreate-trial-260928-1/lib`，`*.v` 关联 `rocq`。
- owner ledger 覆盖 semaphore manager/bitmap/bucket/registry/pend spines、Task ID manager/registry/descriptor runtime/stack frame、scheduler ready/external/zombie heads 与 spines、scheduler metadata/policy table、delay objects、Task Done 表和 critical counter。

## 7. Review Issues

- `PRED-R3-01` | blocker | `SemaphoreRep.v:15-23,84-101,221-298` | 原 r3 缺少对象两段 padding ownership | `memset`/`x_free` 无法取得完整 32 bytes | 已用 layout 条件与两段 `CharArray` 覆盖全部生命周期 | full object owner ledger 为 32/32 bytes且编译通过 | `resolved-in-r4`.
- `PRED-R3-02` | blocker | `CrtosOSPure.v` symbols `CSP_SUSPEND_DETACHED`, `crtos_task_ready_metadata`, `semaphore_task_bridge`, `crtos_task_scheduler_step`, `crtos_wakeup_step_progress`; `CrtosOSRep.v` symbols `store_crtos_local_sched_link`, `store_crtos_external_wait_queues`, `store_crtos_zombie_queue`, `store_crtos_task_done`, `store_crtos_ready_vector_done`, `crtos_semaphore_os_inv` | r12 review 指出 local suspend、external/zombie owner、Done/priority/bitmap 与实际 wake-progress 尚未闭合 | 无法证明全部 sched-link 唯一 owner 与 ResumeAll 真实进展 | 按 reviewer 六项 required fix 补齐 | 所有 placement 有正式 owner，pending head 推出真实 wake 前提，一次 wake 严格减 measure | `resolved-in-r15`.
- `PRED-R3-03` | blocker | `SemaphorePure.v:330-356`（r4 行号以 symbol 为准） | r3 缺 timeout 任意删除且 set-value 无值变化前提 | rely/guarantee 多承诺或漏真实动作 | 增加 `SemStepTimeout`，限制 `SemStepSetValue` | 两路径与源码一致并编译 | `resolved-in-r4`.
- `PRED-R3-04` | blocker | `CrtosOSPure.v` symbols `crtos_selected_ready_task`, `crtos_ready_switch_step`, constructors `CrtosRuntimeScheduleSwitch`, `CrtosRuntimeScheduleBlocked`; `assign.c:56-89`; `assignstat.c:53-63` | r19 re-review 指出 scheduler 仍可任选 ready task，且 normal switch 缺 priority guard | guarantee 可切到非最高队列/非首节点，或在 C 应 stutter 时切换 | 绑定 before highest queue head、最高 priority 和 normal guard | `to` 是 before highest queue 的首节点，`to_priority=highest_prio`，normal switch 满足 `to_priority>=from.cur_prio` | `resolved-in-r20`.
- `PRED-R3-05` | blocker | `SemaphorePure.v:165-365`（以 symbols 为准） | r4 虽有 prefix lemma，但 `offset<8` 仍是外部不可得前提 | 无法闭合内层循环与 first-free 后置 | r5 把“所选 byte 存在零 bit”纳入 invariant，以 `entry<>255` 建立 init，并让 step/exit 内部推出边界；新增有限 byte lemma与双层 prefix 到 `semaphore_first_free` 的连接证明 | 所有前提由 invariant、guard 和 outer invariant 给出，Rocq 编译/coqchk/trust scan 通过 | `resolved-in-r5`.
- `PRED-R3-06` | blocker | `xs_kdbg.h:31,47-101`; 三个 ID annotated slices | r3 错判 debug/NULL 宏为空 | 闭包遗漏 `KPrintf` 与 non-returning 路径 | 已修正分析并展开三个 `NULL_PARAM_CHECK`；`KPrintf` 加入待批准 trusted 候选 | C99 syntax pass且报告一致 | `resolved-in-r4`.
- `PRED-R3-07` | non-blocker | Pure/Rep 注释位置、Critical 核心注释、frontmatter symbols | r3 注释错位/语言与索引不完整 | 可审阅性不足 | 已移动注释、改为中文并补 symbols | 注释紧邻定义且索引完整 | `resolved-in-r4`.
- `PRED-R21-01` | blocker | `SemaphoreRep.v:140-145`; `xs_id.h:50,55`; `semaphore.c:30`; `id.c:67-70`; generated `InsertObj_which_implies_wit_3` | r20 的 None bucket 只拥有两个 NULL pointer cells，没有给出连续数组元素 `head <> 0` | `InsertObj` 在首次读取 `head->node_prev` 前无法建立 C pointer safety，不能用无依据的 proof-local 假设绕过 | 在真实 bucket representation 中加入纯事实 `head <> 0`，footprint仍为原两个 pointer cells；focus lemma在 None/Some 两分支均保留非空与精确 remainder | 权威宏声明真实连续 bucket-head 数组，固定配置下索引落在 16 个元素内；七 formal+helper clean build、coqchk、trust scan及 focus lemma通过 | `resolved-in-r21-reviewed`.
- `PRED-R22-01` | blocker | `SemaphoreRep.v:15-47`; generated `InsertObj_which_implies_wit_2/6`; `IdInsertObj` 与 `_SemaphoreCreate` call-facing views | r21 layout只记录从 `Semaphore` nested dot-path计算的嵌入字段地址，没有连接真实 `IdNode*`/`SysDoubleLinklistNode*` call expressions；QCP 的 `eval_addr_expr` 是抽象的，不能自行把两条路径化简为同一地址 | 无法把对象内 owned cells交给 DLL helper，也无法证明真实 `&idnode->link`/pend/registry node的安全；r16 review-only lemma仅检查nested path，覆盖不足 | 在同一 `semaphore_layout_32_ok` 中加入IdNode与三个embedded DLL node的call-facing、nested地址等式，全部固定到已批准ILP32 offsets | 18项 sizeof/offset C静态断言、真实generated idnode focus/standalone VC、七formal+helper build/coqchk/trust scan均通过；不增加byte footprint | `resolved-in-r22-reviewed`.

## 8. Review 记录

- 首次 full review：`predicate-r3-92e6d098c1a0`，结论 `needs-fix`，共 7 项。
- r4 作者修复后 mechanical checks：Rocq 8.20.1 四文件编译通过；`coqchk` 通过；trust scan 零匹配；九个 annotated C 的 `gcc -m32 -std=c99 -fsyntax-only -fno-builtin` 通过。
- r4 affected-only review：`predicate-r4-da307f6bed04`，结论 `needs-fix`；01/03/06/07 resolved，02/04/05 open。
- r5 仅修改 PRED-R3-05 及其 pure dependency closure：正式 invariant 保存 non-full byte 的 free bit，init/step/exit 与 first-free 连接均为已完成 proof。affected-only review `predicate-r5-5188d755cb69` 结论：05 `resolved-in-r5`，总体仍 `needs-fix`。
- r12 independent affected-only review 结论 `needs-fix`：PRED-R3-02/04 仍 open；机械检查和 116-byte ABI/统一 carrier 方向通过。
- r19 affected-only re-review 仍为 `needs-fix`：稳定插入问题已解决，但 schedule target 尚未绑定最高队列首节点。r20 新增 `crtos_selected_ready_task`；normal/blocked switch 均固定 before-state highest queue 的 `node_next` 与 priority，normal path 另保留源码 priority guard。r20 完整编译，等待最终 re-review。
- r20 最终 affected-only re-review：PRED-R3-04 `resolved-in-r20`，无 open blocker；独立复核 manifest、七文件 build、trust scan 与 `coqchk` 全部通过。结论 `review-passed`。
- r21 作者修复：implement 展开 `InsertObj` 首次 bucket 解引用时发现 r20 的 None representation 未携带 head 非空。仅在 `store_sem_uninitialized_bucket` 加入 `head <> 0` 并更新紧邻注释；精确恢复这处 delta 后七文件 aggregate 回到 r20 `77f0b1b0...53a8`，证明其余六文件及其他正式定义未改。当前 manifest 为 `ff08c5d6...b9e`，helper 为 `44a3c078...2681`。
- r21 独立 affected-only review：reviewer `predicate_r21_review`，2026-10-08；复算 source17 `2adc70fc...93c2`、r20 reconstruction、r21 formal/helper hashes，对照 `DECLARE_ID_MANAGER` 连续数组与 `id.c` 首次解引用，检查 None/Some ownership及初始化/已有桶/删除依赖，并用 Coq 8.20.1/OCaml 4.14.1 独立 `coqchk` 七 formal+helper；trust scan 零匹配。`PRED-R21-01` resolved，结论 `review-passed`。
- r22 作者修复：MCP 展开真实 call-facing `IdNode*`/DLL field expressions后发现 r21 layout closure不足；在 `semaphore_layout_32_ok` 中补齐IdNode id/link、id-link、pend-list和registry-link的两种访问路径及offset。其余六formal与r21逐字相同，重构r21 aggregate精确为 `ff08c5d6...b9e`；r22为`5b808e69...0780`。
- r23 proof-discovered representation 修复：`_SemaphoreCreate` publish 证明发现旧 bucket 纯模型把不属于 ID manager ownership 的 `value/pending` 纳入完整对象相等性，使 reserve(value=0) 到 create(value=val) 无法重封装。新增 `semaphore_id_view` 仅保留 addr/id，并由 `semaphore_objects_in_bucket` 对过滤结果规范化；filter、顺序、link、bitmap、None/Some 与所有实际 ownership 不变。七 formal manifest 为 `1845f34e...2bfc`，helper 为 `9e3f0a26...f482`。独立 reviewer `predicate_id_view_review` 对照权威 ID manager 实现、受影响 representation/proof closure 与 trust scan，结论 `review-passed`；spec r24 dependency 继续有效。
- r22 独立 affected-only review：reviewer `predicate_r21_review`，2026-10-08；独立复算formal/helper/source，运行九切片C99与18项ABI静态断言、Coq 8.20.1/OCaml 4.14.1七formal+helper `coqchk`、trust scan，并在只读Coqtop中完成真实generated idnode focus及standalone spatial VC。结论`review-passed`，无predicate open blocker；其发现的ambient pure事实遗漏均归类为implement-local annotation修复，不改变canonical spec。
- 2026-10-07 source-ledger 修复：spec full review 发现旧 16-file manifest 漏列已用于 IRQ macro 解析的 `xs_isr.h`。作者扩充为 `source-s2-2adc70fc1afc`；该 header 内容与 r20 审阅时使用的证据相同，七个 formal 文件 manifest 仍为 `77f0b1...`，因此不改变 predicate 语义、ownership 或接口。独立 affected-only dependency check 已确认 predicate r20 仍有效。
- 当前 predicate `[OPEN]`：无；六个 trusted symbols 已获用户批准，统一 OS carrier 与全部既有 ownership不变。
- 结论：`review-passed`。
- Review-passed predicate revision：`predicate-r23-1845f34ef435`（完整 manifest `1845f34ef4351d7cb9e97b241d242c8e5295323530c1428066c2f1f273852bfc`）。
- 用户确认及时间：r20 于 2026-10-07 获明确批准；用户随后在 implement 中明确授权“发现 spec/设计问题回去改不需要再次批准，可以直接继续证明”，因此独立 review-passed 的 r21/r22 最小回退修复按该 standing approval 恢复 implement。
