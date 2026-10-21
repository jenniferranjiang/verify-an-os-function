本候选已完成七个正式文件的编译，现交独立 full review；这不是审阅通过，也没有声称 C 实现已经证明。设计以完整 semaphore 模块的对象与容器为基础，创建证明只借入实际需要的 task/scheduler 资源。未修改根共享定义或 skill，也未晋升任何 candidate。

正式候选为 `predicate-r1-f6fc3c3b2bf8`，manifest SHA-256 为 `f6fc3c3b2bf82120166696c0790a8870c612466b0a1e0a3ab95f1adabaf84b92`，文件集合见 `evidence/predicate-manifest.json`。状态为 `review-ready`。源码身份和 ARM ABI 依据是 [source-analysis.md](source-analysis.md) 及其 `source-r1-e1b125e29d37` manifest；ABI probe 直接编译当前真实 headers，不使用历史 trial 标签推断字节相同。当前没有作者已知的 ownership/生命周期/接口编译缺口；独立 reviewer 仍须逐项判定下面的边界是否符合批准目标。

## 范围与最小状态

权威目标是 `kernel/thread/semaphore.c` 的五个 static 实现和五个公开 wrapper。全部已读取用于确定生命周期；本次 C 验证闭包仍是 source report 的九个非 trusted 函数。非 create 的 delete/obtain/abandon/set-value 是状态与 owner 的依据，不被冒充为已验证函数。固定 STM32F103、Cortex-M3、ILP32、非 SMP。所有直接字段路径沿用真实 struct，Semaphore 32 字节，IdManager 12 字节，IdNode 12 字节，DLL node 8 字节。

`SemaphorePure.SemaphoreState` 只有按 registry 顺序排列的 `SemaphoreObject`。对象保存分配地址、ID、value 和 pending 的任务基址序列。地址追踪分配到释放的一次生命周期；ID 则支持已发布查询。bitmap、桶、registry links 从这份权威列表派生。无需第二份 mutable ID-manager state，也不保存 done table；唯一 dispatch 已按源码归一为直接函数调用。依赖状态在 `semaphore_manager_state` 处构造并传给共享 ID manager。

跨模块组合 `CrtosOSPure.CrtosOSState` 原样复用根 `VarGlobalState`，加真实 SchedulerState 和 SemaphoreState。scheduler 保存 nest、running task、current priority、ready 队列及两个 ready-vector 缓存。这些对应 C 的可变对象，均没有塞入 semaphore 局部 state。当前 stable record 只保存本 slice 使用的 semaphore 稳定地址；不用未使用的 task stable record。

## 正式分层与复用

- `SemaphorePure.v`：模块纯状态、manager 派生、创建/删除和值或 pending 更新。
- `CrtosOSPure.v`：跨模块纯组合、最小一致性、环境与保证关系、nest 的精确模递增和饱和递减。属于本 trial 的 CRTOS-global candidate。
- `CrtosHeapBridge.v`：在新 carrier 复用根 heap 谓词的通用桥。它只解释无 token、状态集合为全集的标准 heap，不伪造或转换 Task token。
- `CrtosOSProtocol.v`：使用 QCP 已有 critical_STS / CriticalCSL 建立同一个 OS assertion carrier。属于 CRTOS-global candidate。
- `SemaphoreRep.v`：使用根 DLL/IDNode 谓词组成 semaphore heap；没有任何 IRQ token。
- `CrtosOSInv.v`：组合完整 semaphore representation 和 task/scheduler 的精确借用视图，作为本 slice 的 OS invariant。
- `SemaphoreCritical.v`：静态 C 符号绑定、PRIMASK handler、outside/inside interface。

候选不重定义根 DLL、ID bitmap、ID manager、TaskDescriptorAbs 或 TaskSchedMemberAbs。`store_sem_manager` 直接复用 `IDNode.store_idmanager`，包括 lazy bucket 的 `(0,0)` 与空自环两个形态。`store_sem_registry` 用共享 DLL 的 payload callback；pending/ready 队列用同一个共享 DLL spine，并将 task 基址转换成其内嵌 sched_link 地址。

根 heap carrier 原本固定于 Task protocol，不能直接与新 OS token 相乘。实际实现并编译了 `crtos_heap_lift_sep`、`crtos_heap_lift_entails` 等桥接证明；把共享 predicate 标准化到同一内存后，得到新 carrier 上完全相同的分离所有权。这是可执行的 integration 方案，不是“必须改共享库”的推测。没有复制或修改根 Task protocol。根 Task stack 是 RISC-V 初始化表示，不能作为 Cortex-M3 运行时栈契约，因此这里仅复用适用的任务纯类型和 sched 字段接口，不把整包 `crtos_inv` 放进 Require。

## 每个字节的 owner

| C 区域 | 私有清零对象 | 完整发布对象 | 摘除后对象 |
|---|---|---|---|
| sem+0..1，id.id | store_sem_id_detached | ID manager 的 id payload | store_sem_id_detached，id=65535 |
| sem+2..3，id padding | store_sem_padding | store_sem_padding | store_sem_padding |
| sem+4..11，id.link | store_sem_id_detached | ID bucket DLL spine | store_sem_id_detached，自环 |
| sem+12..13，value | 私有零值字段 | store_semaphore_body | store_semaphore_body |
| sem+14..15，padding | store_sem_padding | store_sem_padding | store_sem_padding |
| sem+16..23，pending head | detached 零节点 | body 内 pending DLL head | 空 pending DLL head |
| sem+24..31，registry link | detached 零节点 | registry DLL spine | detached 自环节点 |

`store_sem_allocated` 拥有完整32字节未初始化块。QCP 当前 `CommonAssertion.struct_padding` 的实现是 `emp`，并不提供物理 padding byte ownership；因此本候选显式保留两段2字节零 padding。这是对经验文件中“工具已经提供 padding 资源时不得重复拥有”的条件检查：本安装的该条件不成立。没有与字段谓词或 bucket spine 重叠的 owner。

全局 `k_sem_id_manager` 的四字段、16-byte bitmap、16个连续 bucket heads 及其中的 id 节点由唯一 `store_sem_manager` 拥有。`k_sem_list` 的 head 和每个 registry link 由 `store_sem_registry` 拥有，payload 只带本体。C 数组 bucket 使用根已有表示；没有把连续 bucket 对象误建模为指针 map。

跨模块分工如下：

- pending 的 task.sched_link 在入队后由 semaphore DLL spine 所有，ready 的相同节点由 scheduler DLL spine 所有。`CrtosOSValid` 排除二者成员重叠；同一 pending 集合自身也 NoDup。
- `store_task_semaphore_view` 从唯一根 task_desc_map 出借 exstatus 和共享 `store_task_sched_member` 的六个调度标量。它不含 sched_link 指针，因此不会与 ready/pending 队列重复所有权。Suspend/Resume/timeout 负责在各容器间交接该节点；这不是复制一个新任务对象。
- task 的 ID/registry、base-info、stack、delay、Done 与 event packed 字段未借给 semaphore。它们保留在 task/ID/delay 模块的外部 frame；当前 slice 不需要读取或转移这些字节，也不冒充拥有整块 TaskDescriptor。根库中职责匹配的 ID manager、DLL、TaskBaseInfo/stack predicate 是各自模块的接口；当前 ARM task完整表示不在本次 create证明闭包内，不能借用根 RISC-V stack作为它的证明。
- scheduler 借出 Assign 本体、ready 节点和 `KTaskOsAssignLockNest`。函数指针槽本身由 scheduler view 所有；ready_vector_done 指向的函数表、timer/zombie/其他 IPC 节点继续由各自模块 frame 所有。Assign 的276-byte布局已由 source probe 确认，尾padding也有实际 owner。

这是完整 semaphore 模块 invariant 与明示跨模块借用资源的 `SemaphoreOSInvariant`，不是包含全部 CRTOS 内存的总 invariant。外部 frame 没有被替换成任意 Assertion 参数、占位 `emp` 或未解释 token。

## 初始化、发布与退出

静态 C 初始化提供 manager 配置、全零 bitmap/buckets、自环 registry；`store_semaphore_static_initial` 明确写出这份输入，模块初态为 `[]`。空 bucket 的 lazy init 可在 InsertObj/GetObj 中变为自环，根 store_idbucket 同时容纳这两种真实稳定形态。

创建的 ownership 路径为：分配32-byte私有块 → memset后的完整清零对象 → 进入临界 → ID成功后manager取得id字段/嵌入link，私有余部由 `store_sem_registered_private` 保留 → value写入、pending初始化、registry插入 → 所有对象资源并入 `store_semaphore`。

ID分配失败不改对象、bitmap或容器；`store_sem_id_detached` 的旧id/prev/next参数保证失败返回原值，不能仅返还undef从而遗失“全清零”。重新组合的完整 `store_sem_zeroed_private` 被批准的x_free消费，之后临界退出不遗留任何私有对象。

正常删除的表示端点是 `store_sem_retired`：ID注销后为65535，两个容器都把自环节点返还本体，pending已由ResumeAll清空，再由删除路径释放。该表示说明模块生命周期闭合，但并未扩大本次x_free的trusted contract；用户只批准创建失败时清零私有对象的free。非create删除的C正确性仍未证明。

## 真正 IRQ 边界与环境

`DisableLocalInterrupt` 才交出 `SemaphoreOSInvariant(current)` 和 inside token；外层 CriticalAreaLock 随后执行真实nest递增。调用者持有的token仍索引current，内存用increment(current)解释。CriticalAreaUnLock先执行真实条件递减，只有 `EnableLocalInterrupt` 才消费inside及最终invariant，交还outside。handler允许0或1，精确恢复旧PRIMASK。

当前对外create的OutsideCritical是非嵌套调用边界，nest为0。源码 `assign.c` 的 KTaskOsAssign/KTaskOsAssignDoIrqSwitch 在nest>=1时不切换；CriticalAreaLock/UnLock的嵌套调用在内部以实际计数表示，不作为新的对外outside资源。`semaphore_nesting_roundtrip` 已机器证明本边界0→1→0；不声称65535溢出也能恢复。这个适用边界必须由独立review确认，不能把它写成源代码普遍保证任意调用者都非嵌套。

`SemaphoreRely` 允许临界区外环境改变有效 semaphore/task/scheduler 状态，task部分复用根TaskRTrans；它不是before=current。两端outside nest0由同一个关系维护。Guarantee额外要求task和整个scheduler分量保持；具体create成功效果则是首空ID、精确头插新对象、value=输入、pending为空。未触及的heap资源经分离frame原样保留。

Outside并不遗失before的有效性：QCP OutsideCritical自身存在一条Rely，Rely包含有效性；`SemaphoreOutsideCritical_valid`已证明这一点。inside只拥有协议资源，不与heap invariant重复拥有任何C字节。

## 本轮检查与审阅入口

复现 `python3 ksemaphorecreate-trial-261012-1/tools/check-predicates.py`。固定使用 `/home/xinra/.opam/default/bin/coqc`（Coq8.20.1、OCaml4.14.1）；PATH默认工具的OCaml4.14.2无法读取正式根.vo，已通过选择兼容工具解决，未改根.vo。`evidence/predicate-build.json`记录七个文件的完整命令、exit0、manifest与机械耗时。不是用历史hash代替新编译。

本次proof源新增的桥接、frame投影、nest roundtrip和outside有效性均有Qed；没有新增手写Axiom、Parameter、Admitted或admit。根共享输入及工具框架的已有可信基由主agent的`root-shared-inputs.json`和后续final trust scan记录，不能误报为本任务新假设。

旧trial未作为任何formal输入、导入、load path或构建目标。主agent记录了一次初始AGENTS文件名枚举未显式排除的过程偏差，没有返回旧trial文件或内容；详见`evidence/session-constraints.json`与`evidence/isolation-check.json`。本报告不宣称会话中从未发生那次目录枚举；本候选与当前检查闭包均明确隔离。

下一步由独立reviewer对上述revision做full predicate review，尤其检查跨模块借用边界、lazy bucket、32-byte完整生命周期、非嵌套outside语义和统一carrier。通过且无open blocker后才按用户一次性授权自动接受；当前报告不自行批准。
