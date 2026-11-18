> 2026-11-18最新状态：Init已接纳44/62顶层VC（10组），累计预算约99–100分钟，停止新增证明尝试；无函数final-check。余18个目标、局部对齐注解修复及重试，详见[implementation-result.md](implementation-result.md)。

> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

# Dataqueue：全局新增内容与规格导读

当前实验已按crtoslatest（a07641a0b58469ae3ea19317cce2cf48974989bb）同步已有InitDataqueue/初始化回滚/Peak设计及源码上下文。这里解释新增内容及其用途；源码修改前后与原因见 [source-changes.md](source-changes.md)，实际检查与旧证明适用性见 [integration-review.md](integration-review.md)。这次整合没有运行QCP或完成新的C实现证明。

## 本轮crtoslatest同步改了什么

当前改动集中在两个已有lib文件、七份canonical C、两份header和三份分析副本：

- SemaphoreOps新增semaphore_id_invalid，表达原实现SemIdInvalid的负值或高于65535检查。KSemaphoreDelete的公开program、IC effect和quiescent条件同步：非法ID直接保持状态；合法表示范围内再查对象，不能把65536窄化为ID0去删除。
- Init/DeInit/Peak及Push/Pop上下文按新NULL诊断宏规则注释移除，取消旧NULL_PARAM_CHECK_1及其非空保证。已有DataqueueStorage/dataqueue_owned或锁内os_inv承担访问权限，未加强入口Require。
- Semaphore wrapper的生命周期检查宏在当前未启用STATIC_OBJECTS的配置下为空；ON_WAKE在未启用DEFER_IPC_SCHED时等同既有调度模型。源码对应条件直接标在输入中。
- _SemaphoreObtain分析副本完整采用新版ID/timeout检查及Delay失败唤醒自身回滚分支；调度后的exstatus读取另作最小临界区适配。它仍不是已完成规格的新证明目标。

人工审阅应重点确认：Delete对65536等高ID现在必须直接返回；诊断宏省略不再提供非空事实；已有Dataqueue副本修复继续适用而没有扩大到原仓库；Obtain的新上游分支不能被误记为本轮新完成的spec或证明。

## 已建立的lib设计及其用途

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

OC契约沿用接口形式并同步新的ID入口检查，旧证明源码保留；没有加强Require或删去queue关联来处理生命周期问题；**旧通用删除保证在新全局模型下需重新处理生命周期条件**。本轮init_cleanup已有无queue引用等guard，不能把它的受限保证推广为通用销毁。类型检查通过与旧API语义重新获证是两回事。

## 本轮函数规格在讲什么

| 函数与位置 | 主要保证 | 人工审阅重点 |
| --- | --- | --- |
| [InitDataqueue](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c) | 成功返回0并发布空队列；三类失败返回-1、回收已取得资源并返还结构。 | caller提供的是新存储或完整退役存储，不是可重复初始化的live queue；失败路径确实经历Unlock到IRQ重入窗口。 |
| [DeInitDataqueue](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c) | init_cleanup清理未发布对象，base清空，已取得的非负ID删除后置-1。 | 此规格是Init回滚用途；已有负错误码保持，不保证所有失败字段都是-1，不覆盖任意等待者/并发销毁。 |
| [KSemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c)、[_SemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) | 新增dataqueue_ic，表达持锁创建成功或-5失败，保存其他模块。 | 全局原OC接口仍存在；IC源码适配与callee选择见下节，不能把OC证明直接视为IC证明。 |
| [KSemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c)、[_SemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) | 新增dataqueue_cleanup_ic，覆盖非法ID、查找失败及无等待者删除。 | quiescent前提限制了实际使用场景；保留真实唤醒分支，但当前清理条件使其不可达。 |
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

四份Semaphore全局canonical保留OC和具名IC两种接口。OC函数体已同步新源码的ID范围检查和当前配置下的宏归一，其余既有OC专用注解继续保留；IC契约和完整callee接口在同一文件前部。每个文件仍只有一个active定义，没有另存第二份IC权威body。原证明文件保留；涉及新行为的旧VC不能直接视为当前输入的已证结论。新增IC契约不表示原OC body无需适配即可满足它，也不表示IC实现已有证明。

| canonical | IC目标选择 | body适配 |
| --- | --- | --- |
| `annotated_C/src/kernel/semaphore/KSemaphoreCreate.c` | `dataqueue_ic` | wrapper无锁操作，仅选择内部create的IC契约 |
| `annotated_C/src/kernel/semaphore/_SemaphoreCreate.c` | `dataqueue_ic` | 去除一次内嵌Lock赋值及两处Unlock，其他行为保持 |
| `annotated_C/src/kernel/semaphore/KSemaphoreDelete.c` | `dataqueue_cleanup_ic` | wrapper无锁操作，仅选择内部delete的IC契约 |
| `annotated_C/src/kernel/semaphore/_SemaphoreDelete.c` | `dataqueue_cleanup_ic` | 去除一次内嵌Lock赋值及两处Unlock，其他行为保持 |

正式IC实现尚未启动。后续在获准实施时，从同一canonical构造工具管理的临时切片：选择前部IC目标契约和下表的完整callee声明；使用`dataqueue.h`及`dataqueue_semaphore_logic.h`词汇；提取唯一原body，按上表删除内嵌锁调用；去除body内OC专用的Assert/Given/which-implies/where等证明注解，再按IC契约补证明注解。保留负ID/查找失败/分配失败/空pending分支及所有真实字段操作；不可把不可达的ResumeAll或KTASK_ASSIGN分支直接删掉。OC专用顶层契约、旧callee选择及VC proof imports不混入该临时IC输入。旧OC路径继续使用原body及原注解，未被此记录重新声明为IC证明。

原global内部create以32字节常量分配/清零，trial设计以`sizeof(struct Semaphore)`表达；当前ILP32两者相等。原global内部delete在删除前缓存`sem->id.id`，trial设计直接传该字段；锁内两者无中间改写，保留原缓存即可。两wrapper仅有空调试语句/注释差别。以上是同一算法的已有切片表示差异，不是新的源码修复。

### IC调用选择

以下新增选名只区分同一C符号的OC/IC声明，不修改所迁入的Require/Ensure含义。此前无名的导入契约命名为`dataqueue_ic_import`；其余导入场景加`dataqueue_ic_`前缀。目标四函数的既定IC名字保持。OC契约名字保留，其引用的Delete抽象已按新ID范围语义更新。

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

7份全局canonical通过ILP32 GCC C11语法检查（原OC内部两份保留的未使用lock局部仅作既有警告抑制）。4个Semaphore文件各恰好一个active目标定义，本轮源对应检查覆盖OC/IC共享函数体中的新ID检查及配置归一。3份未完成规格的分析副本已于2026-11-17按用户要求删除；批准修复及适配代码保留在[source-changes.md](source-changes.md)。迁移没有运行QCP parser/symbolic、VC或实现证明；全局Rocq一致性检查另由构建记录说明。

## 本轮VC及证明内容

最新工作区没有Dataqueue VC或实现证明，本轮也没有运行symbolic或生成新VC，因此没有可报告的新增Dataqueue证明。全局原有VC/goal_check保留，检查结果和因共享状态变化需要复核的目标见integration-review。

将来进入获批实现阶段后，关键义务将包括结构/数组字节拆合、两次Create的发布与失败frame、IRQ回滚资源恢复，以及Peak借出队首槽并归还os_inv。这些是现有设计中待证明的关系，当前不能称为已完成VC或已证结论。

## 后续范围与当前限制

`PushDataqueue`、`PopDataqueue`和`_SemaphoreObtain`尚无完整新spec；分析时直接读取源码，已删除独立分析副本。Dataqueue原文件中四项仍存在的问题和副本处理见 [source-errors.md](source-errors.md)。新版已处理的等待缺陷不再作为当前错误项或待批准补丁。

Push/Pop及Obtain/Abandon的完整新spec还未编写，后续需据新源码设计多阶段行为、生命周期与相应等待接口。此前通用OC删除可能破坏queue引用关系的模型问题仍需单独处理，不能用新ID上界检查替代它。本轮未运行QCP或生成新VC。

## 2026-11-17 实现阶段：Init VC

已生成 [InitDataqueue_goal.v](../../../../VC/dataqueue/InitDataqueue_goal.v)、auto/manual及goal_check四份正式VC。当前只完成annotation接纳和依赖准备，未完成实现证明。VC对应：DataqueueStorage展开为memset所需字节资源；清零后字段与padding的拆分；malloc分支的数组所有权；两次Create后的成功发布；三类失败将私有对象交给cleanup并衔接safeExec返回-1的续体。新增断言是待证明的切点，不是额外Require，也没有将lib中的obligation Prop当作定理使用。

两份公共header仅拆开混合kind/term的Extern Coq块，声明序列保持；Init链式赋值按原顺序拆为rear=0、front=0。正式契约含义保持已批准revision，新增body注解的义务须由manual证明。工具适配文件为根qcp-project.json、qcp-layout.json，QCP四处路径适配使同一全局工程的符号执行、依赖构建和VC输出使用VC/dataqueue。恢复与实际结果见 [controller](../../../../reports/InitDataqueue-20261117004005/controller_state.json)。

2026-11-17 当前实现状态：Init已生成VC并接纳annotation/VC-checking，首组因缺少正式DataQueue/DataElem ABI连接被controller接纳为blocked；无实现证明或final-check完成，后续阶段未启动。当前结果、任务表与待决方案见[implementation-result.md](implementation-result.md)。

## 2026-11-17 地址map改造（当前设计）

用户授权将列表对象集改为partial function。新的DataQueueAbs去掉dq_addr，结构地址由map key及store_dataqueue的p参数承担；dq_base仍描述malloc得到的元素数组。DataqueueState只保存dataqueue_map : addr -> option DataQueueAbs，无额外权威对象列表。Some表示已发布，None也允许尚未初始化/私有回滚对象存在于os_inv外，不等于该地址物理未分配。

全局原os_dataqueues分量与replace_dataqueues接口位置保持，分量类型内部变为map；原os_inv中的dataqueue_inv改用store_map store_dataqueue并逐lookup要求ready及semaphore关联。每个cell拥有结构字段、原padding与完整槽数组，不拥有payload或Semaphore本体。有限定义域及无重复key来自QCP store_map，不虚构C全局管理表。

发布在map p=None时写Some q；其他key保持。Peak用lookup定位并拆合store_dataqueue p q；Push/Pop已有纯操作保留，未来更新同一key即可。cleanup guard改为map p=None；仅处理未发布的私有对象，abs_deinit显式接收真实地址p。SemaphoreDelete的无引用条件改为对所有lookup命中条目量化。跨生命周期地址复用、semaphore ABA和通用删除生命周期问题没有因此解决。

本轮正式规格改为DataQueueAbs和store_dataqueue(p_queue,q)，Init成功Ensure用lookup=Some，DeInit canonical与Init内导入同步。C可执行语句逐字归一比较不变。split/merge、发布/撤回等原待证义务已按map接口改写，仍不是已证明定理。新接口没有新增Axiom/Admitted或布局信任。

旧dq-predicate/spec-crtoslatest-20261116-r1不再描述当前formal输入，标为invalidated（历史记录保留）。旧Init run和四份VC也为invalidated，依旧保存为workflow恢复/诊断依据；不得手改生成VC来匹配新设计。恢复实现需以重新审阅的map设计初始化新的冻结输入，不能继续旧run宣称当前版本通过。ABI布局连接缺口仍未解决，当前授权不包含其信任例外。

## ABI授权后的验证恢复

用户已确认按原第一阶段、再Pop、再Push继续，并授权类似本次有依据的修改。DataqueueInv新增唯一具体ABI公理dataqueue_layout_abi，内容严格为既有dataqueue_layout陈述（两个sizeof及八个字段地址偏移），依据当前ILP32 GCC静态断言检查。此授权不把任何资源拆合、map操作或函数效果当作公理。TrustBase用户文件不修改，既有IRQ边界保持。map设计与canonical契约含义不变；布局缺失的阻塞已补入正式输入，实际VC是否通过仍由新workflow检查。

当前map+ABI发布组的实际证明路线：从typed ushort store推出NodeNumber范围；展开QCP sizeof包装后应用dataqueue_layout_abi，将分配长度归一为n*8并证明32位截断无影响。随后构造8字节到DataElem指针/长度两字段的转换与数组组合。已通过的调试步骤不代表完整VC已证；完整发布还需要map地址freshness、semaphore关联及safeExec精化。

2026-11-18 annotation-r2修复：memset后字节到字段的which-implies显式在两侧保留已有addr_aligned(p_queue,4)。此前CharArray.full仅给字节对齐，不能推出typed字段对齐，这是局部注解遗漏，不是源码错误，也不需要新Require/ABI。公开spec与执行语句未变。r1已接纳60/62顶层VC，r2重新生成后部分下游目标新增显式对齐前提，必须按当前目标检查/适配旧证明，不自动继承旧accepted。

## Init实现证明完成

InitDataqueue-20261117224043 controller完成第二轮9组63个顶层VC，parent整文件检查、final-apply、final-check均通过，phase=done。正式manual位于VC/dataqueue/InitDataqueue_proof_manual.v。关键证明以具体ABI为布局依据，构造字节/数组转换、map freshness与发布、三类失败cleanup续体、返回和安全目标。第二轮修复了memset局部which-implies遗漏对齐前提，未改公开Require或函数行为。结论相对于KSemaphoreCreate和DeInit的canonical contracts，不能代替这些callee实现证明；后续串行验证闭包。
