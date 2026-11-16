# Dataqueue：全局新增内容与规格导读

本轮将已经完成的InitDataqueue/初始化回滚/Peak设计及源码修复上下文整合到全局工程。这里解释新增内容及其用途；源码修改前后与原因见 [source-changes.md](source-changes.md)，实际检查与旧证明适用性见 [integration-review.md](integration-review.md)。这次整合没有运行QCP或完成新的C实现证明。

## 本轮lib新增和修改在讲什么

| 全局位置 | 内容与原因 |
| --- | --- |
| [DataqueueState.v](../../../../lib/dataqueue/DataqueueState.v) | 新增队列对象、元素槽和FIFO状态，区分未知槽、当前有效元素与出队后的陈旧槽；提供初始化、入队、出队、查询及退役操作。 |
| [DataqueueInv.v](../../../../lib/common/DataqueueInv.v) | 新增结构字段、padding、数组及整队列所有权表示；以共享dataqueue_inv组合已发布队列，关联已有semaphore权威状态。 |
| [KInitDataqueue.v](../../../../lib/dataqueue/KInitDataqueue.v) | 新增初始化抽象，表达malloc、两个Create及失败解锁后回滚的真实阶段，不能把整个失败流程当作一个原子步骤。 |
| [KDeInitDataqueue.v](../../../../lib/dataqueue/KDeInitDataqueue.v) | 新增未发布对象的init_cleanup，表达部分初始化资源、IRQ重新进入时所需观察条件及清理结果。 |
| [KDataqueuePeak.v](../../../../lib/dataqueue/KDataqueuePeak.v) | 新增队首查询抽象与两个option输出槽表示，支持未初始化输出，分别描述空/非空结果。 |
| [CrtosGlobState.v](../../../../lib/common/CrtosGlobState.v)、[CrtosInv.v](../../../../lib/common/CrtosInv.v) | 在已有总state直接加入os_dataqueues，在原os_inv中组合队列资源；相应更新与frame保存未触达的队列分量。 |
| [KSemaphoreCreate.v](../../../../lib/semaphore/KSemaphoreCreate.v)、[KSemaphoreDelete.v](../../../../lib/semaphore/KSemaphoreDelete.v) | 在已有OC支持之外增补Init/回滚实际需要的IC效果和支持义务，保留原接口与其他定义。 |
| [KTaskWakeup.v](../../../../lib/task/KTaskWakeup.v) | 原ready/delay及唤醒效果补充dataqueue保持关系，使未写队列的操作不能任意改变新状态分量。 |

原工作区的29份库输入不等于新增29份全局文件。DLL、ID、Task、Assign、Delay、Semaphore等空间接口在全局已经存在；统一全局总状态后，它们由同一个CrtosRules实例解释，可以直接复用。原工作区为两个逻辑命名空间做的参数化副本无需另存一套。全局原有定义、lemma与非本轮使用的接口继续保留，不能以裁剪过的短副本覆盖完整库。

### 队列资源怎样组织

DataQueue结构由caller提供，20字节中包含front/rear/max_len、base、两semaphore ID和偏移6–7的padding；元素数组每槽8字节。DataqueueStorage表示初始化前完整结构存储；dataqueue_owned表示一个队列结构及其实际分配的数组。

成功Init前，这些资源由caller独占；成功时发布到os_inv，返回时不再把同一结构与数组同时留在caller手中。失败清理把数组释放，结构存储返还caller。队列只保存payload地址和长度，不拥有或释放payload内容。

槽None仍拥有未知内存，Some记录已写入的数据与长度；当前FIFO区间必须已初始化，Pop之后的槽可以保留旧值。ready允许n=1，此时有效容量为0；n=0由实际malloc(0)失败模型进入回滚，而不是由Require直接排除。

semaphore对象只由原semaphore invariant拥有，queue拥有的是两个ID字段。dataqueue_semaphores以纯关系把ID连接到权威semaphore集合。Obtain、ring更新和Abandon分属不同阶段，当前表示没有把semaphore计数强制等于队列长度或空槽数；它也不单凭缓存ID提供对象保活或排除ABA。

### 全局整合后需要重点注意的关系

新增dataqueue关联会影响原本不知道queue存在的共享API。尤其通用OC KSemaphoreDelete的原抽象允许删除任意查得的ID，但新的queue invariant要求关联semaphore存在。如果该ID仍被已发布queue引用，删除后这一关系无法恢复。

本次保留旧OC契约与证明源码，不擅自加强其Require，也不删去queue关联来掩盖问题；**旧通用删除保证在新全局模型下需重新处理生命周期条件**。本轮init_cleanup已有无queue引用等guard，不能把它的受限保证推广为通用销毁。类型检查通过与旧API语义重新获证是两回事。

## 本轮函数规格在讲什么

| 函数与位置 | 主要保证 | 人工审阅重点 |
| --- | --- | --- |
| [InitDataqueue](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c) | 成功返回0并发布空队列；三类失败返回-1、回收已取得资源并返还结构。 | caller提供的是新存储或完整退役存储，不是可重复初始化的live queue；失败路径确实经历Unlock到IRQ重入窗口。 |
| [DeInitDataqueue](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c) | init_cleanup清理未发布对象，base清空，已取得的非负ID删除后置-1。 | 此规格是Init回滚用途；已有负错误码保持，不保证所有失败字段都是-1，不覆盖任意等待者/并发销毁。 |
| [KSemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c)、[_SemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) | 新增dataqueue_ic，表达持锁创建成功或-5失败，保存其他模块。 | 全局原OC接口仍存在；IC源码适配与callee选择见下节，不能把OC证明直接视为IC证明。 |
| [KSemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c)、[_SemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) | 新增dataqueue_cleanup_ic，覆盖负ID、查找失败及无等待者删除。 | quiescent前提限制了实际使用场景；保留真实唤醒分支，但当前清理条件使其不可达。 |
| [DataqueuePeak](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c) | 空时返回-1并保持输出；非空返回0，写同次锁内观察的队首指针和长度。 | 输出cell由caller提供且可未初始化；payload不归函数拥有，操作不推进front或修改semaphore。 |

### 初始化的成功与失败

成功时front/rear为0，数组非空，两ID非负且不同；数组元素尚未初始化。第一次Create初值n-1、第二次初值0。失败后base为0，两个ID的真实组合为(-1,-1)、(-5,-1)或(-1,-5)，对应数组分配失败、第一次创建失败及第二次创建失败后的清理。

审阅时应对照三个失败出口，确认规格没有把原负错误码覆盖成统一哨兵，也没有漏掉成功创建后需删除的ID0。源码中的sentinel修复只应用于验证副本，原仓库仍有原始缺陷。

### Peak的输出与原子观察

公开规格用真实p_queue定位对象，访问权限从锁内os_inv取得。空分支保留两个输出槽原option表示：Some保留已知旧值，None保留未知内容；非空时将两个输出表示为Some。调用者不必为了使用写入参数而先初始化它们。

锁内抽象令整个OS状态保持，因为Peak只读取queue并写caller的两个输出cell。外层允许加锁前环境变化，不能从锁内只读推出函数入口状态与出口状态相等。条件与队首读取已在批准适配副本中放入同一临界区，两出口恢复同次保存值。

### 需要明确接受的抽象与依赖

cleanup和Peak的assertS观察条件沿用当前Rely=True协议与默认审阅白名单001；候选观察条件的可满足性/非真空性不作为该规则下的审阅blocker，但没有因此获得新信任或完成VC证明。保存地址/ID不表示世代身份保证。

ID与DLL等已有接口以caller-local完整契约复用；其实现证明状态单独记录，导入契约不等于整个调用链已证。LinklistResumeAll沿用已有规格语义并补dataqueue frame义务。新字节/数组拆合、发布/撤回、frame等Prop只是待证陈述。

## Semaphore IC设计的单canonical保存方式

四份既有Semaphore全局canonical保留原OC函数体、原OC契约及其所有OC专用注解，迁入的IC契约和完整callee接口以额外具名declaration放在同一文件前部。每个文件仍只有一个active定义，没有另存第二份IC权威body。原OC段已逐字核对保持；原证明文件未被该迁移覆盖或删除。新增IC契约不表示原OC body无需适配即可满足它，也不表示IC实现已有证明。

| canonical | IC目标选择 | body适配 |
| --- | --- | --- |
| `annotated_C/src/kernel/semaphore/KSemaphoreCreate.c` | `dataqueue_ic` | wrapper无锁操作，仅选择内部create的IC契约 |
| `annotated_C/src/kernel/semaphore/_SemaphoreCreate.c` | `dataqueue_ic` | 去除一次内嵌Lock赋值及两处Unlock，其他行为保持 |
| `annotated_C/src/kernel/semaphore/KSemaphoreDelete.c` | `dataqueue_cleanup_ic` | wrapper无锁操作，仅选择内部delete的IC契约 |
| `annotated_C/src/kernel/semaphore/_SemaphoreDelete.c` | `dataqueue_cleanup_ic` | 去除一次内嵌Lock赋值及两处Unlock，其他行为保持 |

正式IC实现尚未启动。后续在获准实施时，从同一canonical构造工具管理的临时切片：选择前部IC目标契约和下表的完整callee声明；使用`dataqueue.h`及`dataqueue_semaphore_logic.h`词汇；提取唯一原body，按上表删除内嵌锁调用；去除body内OC专用的Assert/Given/which-implies/where等证明注解，再按IC契约补证明注解。保留负ID/查找失败/分配失败/空pending分支及所有真实字段操作；不可把不可达的ResumeAll或KTASK_ASSIGN分支直接删掉。OC专用顶层契约、旧callee选择及VC proof imports不混入该临时IC输入。旧OC路径继续使用原body及原注解，未被此记录重新声明为IC证明。

原global内部create以32字节常量分配/清零，trial设计以`sizeof(struct Semaphore)`表达；当前ILP32两者相等。原global内部delete在删除前缓存`sem->id.id`，trial设计直接传该字段；锁内两者无中间改写，保留原缓存即可。两wrapper仅有空调试语句/注释差别。以上是同一算法的已有切片表示差异，不是新的源码修复。

### IC调用选择

以下新增选名只区分同一C符号的OC/IC声明，不修改所迁入的Require/Ensure含义。此前无名的导入契约命名为`dataqueue_ic_import`；其余导入场景加`dataqueue_ic_`前缀。目标四函数的既定IC名字保持。原OC契约名字与内容不变。

| caller | callee | IC切片选名 | 迁入前选名 |
| --- | --- | --- | --- |
| `KSemaphoreCreate` | `_SemaphoreCreate` | `dataqueue_ic` | `dataqueue_ic` |
| `_SemaphoreCreate` | `x_malloc` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreCreate` | `memset` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreCreate` | `x_free` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreCreate` | `IdInsertObj` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreCreate` | `InitDoubleLinkList` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreCreate` | `DoubleLinkListInsertNodeAfter` | `dataqueue_ic_dispatch_case` | `dispatch_case` |
| `KSemaphoreDelete` | `_SemaphoreDelete` | `dataqueue_cleanup_ic` | `dataqueue_cleanup_ic` |
| `_SemaphoreDelete` | `IdGetObj` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreDelete` | `CONTAINER_OF_SEMAPHORE_ID` | `dataqueue_ic_import` | `(unnamed)` |
| `_SemaphoreDelete` | `IsDoubleLinkListEmpty` | `dataqueue_ic_dll` | `dll` |
| `_SemaphoreDelete` | `LinklistResumeAll` | `dataqueue_ic_semaphore_waiters` | `semaphore_waiters` |
| `_SemaphoreDelete` | `IdRemoveObj` | `dataqueue_ic_low_level_spec` | `low_level_spec` |
| `_SemaphoreDelete` | `DoubleLinkListRmNode` | `dataqueue_ic_remove_member` | `remove_member` |
| `_SemaphoreDelete` | `KTASK_ASSIGN` | `dataqueue_ic_outside_critical` | `outside_critical` |
| `_SemaphoreDelete` | `x_free` | `dataqueue_ic_import` | `(unnamed)` |

`InitDataqueue`中的KSemaphoreCreate及`DeInitDataqueue`中的KSemaphoreDelete继续引用同名IC目标契约。新header只保存类型/词汇，不集中保存函数契约。所有词汇已改为全局逻辑路径，不依赖trial或临时目录。

### 迁移检查

7份全局canonical通过ILP32 GCC C11语法检查（原OC内部两份保留的未使用lock局部仅作既有警告抑制）。4个Semaphore文件各恰好一个active目标定义，原OC完整文本段与迁移前SHA-256一致。3份未完成规格的源码副本逐字保存在`annotated_C/module_context/dataqueue/`及`annotated_C/module_context/semaphore/`，没有误放为新canonical，也没有丢失已批准修复。迁移没有运行QCP parser/symbolic、VC或实现证明；全局Rocq一致性检查另由构建记录说明。

## 本轮VC及证明内容

最新工作区没有Dataqueue VC或实现证明，本轮也没有运行symbolic或生成新VC，因此没有可报告的新增Dataqueue证明。全局原有VC/goal_check保留，检查结果和因共享状态变化需要复核的目标见integration-review。

将来进入获批实现阶段后，关键义务将包括结构/数组字节拆合、两次Create的发布与失败frame、IRQ回滚资源恢复，以及Peak借出队首槽并归还os_inv。这些是现有设计中待证明的关系，当前不能称为已完成VC或已证结论。

## 待继续的函数与未修复问题

[PushDataqueue](../../../../annotated_C/module_context/dataqueue/PushDataqueue.c)、[PopDataqueue](../../../../annotated_C/module_context/dataqueue/PopDataqueue.c)与[_SemaphoreObtain](../../../../annotated_C/module_context/semaphore/_SemaphoreObtain.c)保留为源码上下文。零超时Obtain副本修复已批准并独立检查；它不等于完整Obtain契约已完成。

新增Push/Pop及Obtain/Abandon设计仍受两个源码问题阻塞：延时链回绕排序，以及有限等待时Delay分配失败未回滚。它们尚未获修复授权；并发退役/ID复用条件及成功Obtain后仍空/满的真实分支也需如实设计。此次整合只保存现有成果和证据，未补写这些未完成规格。
