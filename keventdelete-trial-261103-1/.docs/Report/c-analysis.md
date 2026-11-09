# KEventDelete 独立 C 分析

本轮目标已从Create更正为KEventDelete，日期2026-11-03。依据当前工作树权威源码及32位非SMP配置。已读取verify-an-os-function、TrustBase、Predicate指南及最新reporting-guide；只完成源码分析，没有写predicate/spec，没有QCP调用或C实现证明。两项直接影响删除路径的已确认问题见[source-errors.md](source-errors.md)。用户已批准通过环境前提排除D1/D2，并确认0 <= id < 65536；现在仅在这些约束下继续原C设计，源码缺陷仍存在且patch未应用。

## 对象和原始控制流

权威位置为 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c`。Event定义位于`kernel/include/xs_event.h:39–48`：ID节点、3位options、29位events、pending哨兵和管理link。ID manager有128个ID、16个桶和16字节bitmap。Event对象由malloc发布；ID节点归manager，管理link/payload归全局event列表，pending持有task sched_link，任务字段归任务模块。删除必须在移除ID、管理link及全部pending引用后才能取得完整私有块释放。

KEventDelete:254–264先调用FindEventById，NULL则返回，否则done.EventDelete唯一解析为_EventDelete。静态done在205–210初始化，无后续写入。

FindEventById:212–231：负数返回NULL；加锁，把ID窄化为uint16后查找；未命中解锁返回NULL；命中CONTAINER_OF并解锁返回Event地址。查询会懒初始化空桶，根ID模型已允许这一内存表示状态，抽象ID集合不变。

_EventDelete:55–77：NULL检查；锁外调用IsDoubleLinkListEmpty，非空则resched=1并调用有内部锁的LinklistResumeAll；随后取得自己的删除锁，IdRemoveObj、摘管理link、解锁、x_free；resched非零时调度。没有自身循环。对象不存在时public提前返回；存在且pending为空时注销/释放且不显式调度；pending非空时先唤醒全体、再注销/释放并调度。不存在int错误返回值。并发窗口会使这些顺序直觉无法变成无条件安全contract，不能遗漏真实可达交错。

LinklistResumeAll:linklist.c:110–132加锁后循环取队首，CONTAINER_OF到task，设置exstatus=-ERROR，调用KTaskWakeup；队首被摘除后继续，遇哨兵退出并解锁，返回EOK。合法pending关联给出SUSPEND任务和有效ID，是唤醒必定成功且循环缩短的依据。应说明原waiting序列到空列表、每个task READY/exstatus=-1、Delay取消及ready插入、其余资源保持；不只声明链空。该函数的event场景目前无可直接复用的合同。

全模块背景也已检查：Create发布低3位options/events=0/空pending；Trigger修改事件位、匹配并唤醒任务；Process读取/消费事件位或挂起入pending；这些API展示pending资源的所有者及Delete需要保护的生命周期。Process忽略Delay分配失败的问题与本轮D2反例独立，本反例选分配成功路径。

## 适配规则与完整目标调用边界

按当前规则解析后的15个symbol如下。它们是源码分析得到的预期闭包，不声称尚未设计的合同已通过审阅。

| symbol | 归类与依据 |
|---|---|
| KEventDelete | 本轮目标，需完整active canonical文件。 |
| FindEventById | 新设计依赖，保留真实锁/分支/窄化行为；裸指针生命周期是D1。 |
| _EventDelete | 新设计依赖，保留真实路径；不能悄悄改成ID事务。 |
| LinklistResumeAll | 现有根slice仅有semaphore_waiters场景，不能直接用于event；需保留原合同并设计独立event合同及正文验证义务。不是把sem参数改名就能得到的特化。 |
| CriticalAreaLock、CriticalAreaUnLock | TrustBase模型/API边界，采用统一资源协议。 |
| IdGetObj | 根annotated_C/src/IdGetObj.c和headers/id_module_spec.h已有reused-spec；当前参数已窄化，需明确低16位。内部GetObj/Init不递归进实现闭包。 |
| IdRemoveObj | 根同名slice及id_module_spec.h已有high/low_level_spec，可reused-spec边界；内部FreeId/RemoveObj不递归。 |
| IsDoubleLinkListEmpty | 根同名slice的泛型dll合同可复用。 |
| DoubleLinkListRmNode | 根headers/m_double_linklist.h的泛型remove_member可复用，不必复制内部实现调用。 |
| KTaskWakeup | 根headers/ktask_wakeup.h的wakeup_by_id_ic可复用，当前EventOps已描述event摘waiter。调用前必须从event pending及task/id模型导出对应关系。semaphore_pending_head_ic不能直接套event。 |
| CONTAINER_OF_EVENT_ID | CONTAINER_OF(event,id)按TrustBase使用具名类型化模型/API边界，不能凭它创造对象存活权限。 |
| CONTAINER_OF_TASK_SCHED | LinklistResumeAll使用SYS_DOUBLE_LINKLIST_ENTRY，按同一规则具名模型边界；须保持真实Task布局。 |
| x_free | xs_memory.h的KERNEL_FREE宏为x_free，使用已授权释放合同；需完整Event私有字节资源，不能只给地址纯事实。 |
| KTASK_ASSIGN | DO_KTASK_ASSIGN按源代码处理映射的模型/API边界，采用已规定safeExec+OutsideCritical合同。 |

按该计数，四个需要本轮设计的active函数（前三项及LinklistResumeAll），其余11个是模型/API或有适用既存spec的边界。NULL_PARAM_CHECK可以按当前debug配置展开到NULL死循环，非空前提来自有效资源；debug打印与KDEBUG_NOT_IN_INTERRUPT按TrustBase删除，不形成新函数。若采用具名NULL检查API则须另计symbol并给适用合同，不能漏记。

关键限制：原_EventDelete在其自己的CriticalAreaLock之前调用LinklistResumeAll，所以不能直接删除后者的锁，把它伪称为nested critical。根LinklistResumeAll slice已针对锁内Semaphore调用删除内部锁；Event场景若仍按当前权威控制流设计，需按outside调用恢复真实锁并保留原锁内合同语义。用户授权改源码为统一锁事务后，才可根据新控制流使用nested适配。

源代码处理允许给锁外共享访问逐条加临界区；它不允许移动整个查找、清空、注销过程到单一锁内。给第62行读取加锁也不能排除D1的旧指针或D2的读取之后入队。当前根Semaphore源码`semaphore.c:64–97`已经以ID为参数并在74–90持有统一锁，故其slice不是可直接迁移为“Event等价适配”的依据。

## 复用与布局检查

根库EventState/EventInv/EventOps、CrtosGlobState/CrtosInv、KTaskWakeup提供对象状态、生命周期部分形态、等待归属和唤醒关系，删除设计应增量扩展所属模块，不复制公共定义。现有KEventCreate用户未提交改动不应被覆盖。

配置：annotated_C/src/include/xsconfig.h启用KERNEL_EVENT、ID_NUM_MAX=128、ID_HTABLE_SIZE=16，禁用ARCH_CPU_64BIT且无ARCH_SMP；TrustBase授权32位及位域展开。直接包含权威xs_event.h的GCC -m32 ABI检查已复跑，源码和日志见checks/source/event-layout.c和event-layout.log：真实Event=32字节，IdNode=12，pending16/link24；展开模型Event=36，options12/events16/pending20/link28。两者不能混同。释放须与分配所使用模型字节数一致，padding也须归还。

所有源码/配置/复用接口hash见checks/source/sha256.json。当前结论是源码分析完成；本目标内原始缺陷仍存在，已由本轮用户批准的环境限制排除其触发场景，输入限制为0 <= id < 65536。此处理不等于源码修复、predicate/spec审阅通过或实现证明，不计任何依赖为本轮已证明实现。
