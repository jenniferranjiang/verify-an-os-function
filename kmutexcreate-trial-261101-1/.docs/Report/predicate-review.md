# Predicate 独立审阅

结论：**review-passed**。审阅者为独立的 `design_review` agent，作者为 `predicate_design` agent；审阅者未修改正式定义。

固定 revision：`038457b98a07c2fa559a7ec4ea7d63e980af6b73b4a8d8782668ffd97640e036`，文件清单与逐文件 SHA256 见 [predicate-revision.json](../../checks/predicate-revision.json)。审阅时重新核对全部36个文件的哈希，与候选一致；[compile-results.json](../../checks/compile-results.json) 中对应36个模块均有实际 `coqc` exit 0。采用非 SMP、ILP32、LittleEndian、128个ID/16桶的既有验证配置；源码及双侧ABI证据见 [C分析](c-analysis.md)。

已对照源码、[设计说明](predicate-design.md)和实际定义检查以下内容：

- [MutexState.v](../../lib/MutexState.v) 保存八个模块函数实际使用的对象字段和等待顺序。holder只作为指针值；没有凭空加入递归计数不回绕、已有等待队列为空等假设。ID管理状态从同一对象序列派生，符合管理链和哈希桶均头插的顺序。
- [MutexInv.v](../../lib/MutexInv.v) 按36字节逐段核对：ID的2字节和8字节嵌入链接归ID manager；管理链接8字节归DLL；payload独占其余字段、等待头与唯一padding `[2,4)`。等待链仅拥有任务的sched_link，任务描述符仍由Task模块拥有。当前QCP `struct_padding=emp`，显式padding不会重复计入。静态初始化资源覆盖manager、16字节bitmap、128字节懒桶和自环管理头。
- 创建时零字节对象可按已存在的尺寸/偏移接口拆成字段；ID失败仅返还未知值节点，`MutexRaw`能与未触达frame组合而不要求仍为零；ID成功后嵌入ID移交manager，余下payload和管理节点在锁内完成初始化及发布。成功出口不会再保留已交给`os_inv`的私有对象。三项byte/初始化义务是待证Prop，不是已证明结论，未被作为公理使用。
- [CrtosGlobState.v](../../lib/CrtosGlobState.v) 的所有状态构造保留新mutex分量；`replace_mutexes`仅改变该分量。[CrtosInv.v](../../lib/CrtosInv.v) 组合模块一次，并把mutex等待节点纳入原有调度owner互斥和覆盖。创建的新对象等待链为空，因此不会凭空引入任务owner。临界区继续使用唯一`CrtosRules`实例及其原有环境关系，没有另造mutex协议。
- [MutexOps.v](../../lib/MutexOps.v) 的逐对象关系保持管理顺序、地址、ID、holder和全部标量，只摘除目标等待成员；全局owner的NoDup使真实目标只有一个等待位置。`KTaskWakeup.v`的其他增量给非mutex路径补齐mutex相等frame、给通用摘链关系加入该模块。旧状态分量的条件保持原文；这不宣称本轮验证了唤醒实现。
- 对共享副本按基线消除逻辑前缀差异后比较，语义改动限于全局状态、全局不变量和上述唤醒适配；其余副本仅为统一Assertion carrier调整imports。没有新增Axiom、Parameter或Admitted。现有布局信任接口继续属于既有信任边界，ABI编译证据不冒充Rocq布局证明。
- [KMutexCreate.v](../../lib/KMutexCreate.v) 分开描述锁外分配失败与一次临界区操作。成功对应最小空闲ID及完整初始对象头插，其他OS分量保持；失败不擅自声称ID已满。环境变化由既有协议表达，不把调用入口观察等同于取得锁时状态。

本结论针对设计与类型检查，无未解决的设计阻塞项。字节资源转换、发布重组、初始化蕴含和C实现满足抽象操作的证明仍未完成；本轮没有运行verification-orchestrator、QCP symbolic或生成VC。该设计审阅通过不能表述为`KMutexCreate`实现已验证。

## 源码缺陷影响复查

用户指出源码问题后，审阅者重新检查了mutex全模块、ID接口、挂起/唤醒与删除交接；确认 [source-errors.md](source-errors.md) 所列缺陷，M1和M5另有原函数体fixture见证。前次审阅只确认模型没有加入“计数不回绕”等虚假不变量，未把这种建模选择与源码本身的错误充分区分，也没有把生命周期竞争明确列为源码缺陷；这一报告遗漏现予纠正。

固定predicate revision及其设计通过结论保持，但含义严格限于**创建目标的对象表示、资源交接与抽象操作设计**：

- M1的回绕值、M4的无timer等待、M5的错误handle别名、M6的通用唤醒和M7的错误队列次序，没有被当前表示假装排除。模型保存实际uint8值、holder和等待顺序，不宣称计数等于成功获取次数，不承诺有限等待时限或高优先级优先，也不规定只有Abandon能唤醒。故这些功能错误不反驳表示中的字段或资源归属；这并不把它们变成正确行为。
- M2/M3会使真实执行产生释放后访问或悬挂等待链，可能破坏共享`os_inv`。因此**不能声称所有现有mutex API及任意并发环境都会维护该不变量**。已有临界区规格交出有效`os_inv`是模块化调用边界；普通硬件加锁并不会修复损坏的heap。要将当前设计扩展为整个模块或允许这些交错的系统正确性结论，必须先修复源码或明确并获准相应调用协议，届时这些项是阻塞问题。
- 重新沿创建闭包检查：create不调用Obtain/Delete/Abandon、LinklistSuspend、KTaskSetDelay或KTaskWakeup；其fresh对象在锁前私有，锁内ID登记至完整初始化/发布之间没有解锁，失败路径没有从共享注册表取回可能已失效的裸指针。复用的IdInsertObj和两个DLL接口也不以有缺陷的获取/释放/删除API正确性作为前提。因而在本轮已采用的信任和有效共享资源边界下，未发现需改变创建设计的相反源码行为。

本次没有新增“禁止并发删除”“禁止外部唤醒”“递归次数有界”等Require，没有修改C或引入新trusted符号来规避缺陷。该影响复查不是整个OS不变量保持证明，也不撤销源码缺陷；它解释了为何创建设计可以通过、而全模块正确性不能由此推出。
