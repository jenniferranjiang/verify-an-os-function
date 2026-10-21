本轮结论为 **needs-fix**。七个正式文件独立编译全部通过，semaphore 的32字节分工和 heap carrier 桥未发现重复所有权；但当前候选把真实存在的嵌套调用排除在入口之外，且 pending task 的状态关联不足以闭合已声明的生命周期。因此不能自动接受此 revision，也不能进入 spec review。以下是本次草案设计问题，不是已经确认必须修改权威 C 或共享根库。

## 固定对象与证据

审阅对象为 `predicate-r1-f6fc3c3b2bf8`，manifest SHA-256 `f6fc3c3b2bf82120166696c0790a8870c612466b0a1e0a3ab95f1adabaf84b92`。审阅范围是 manifest 中全部七个 `.v`、中文注释、设计记录、所复用根 DLL/ID manager/task state/sched-member/TaskRTrans 与框架实际定义，非 spec 或 C 实现证明。作者与本 reviewer 分开，本 reviewer 没有改任何正式定义。

源码基础为 `source-r1-e1b125e29d37`、Cortex-M3/ILP32/非SMP，另独立检查了真实外部 caller `kernel/thread/data_queue.c`。补充权威输入 hash 见 `evidence/predicate-review-source-inputs.json`；原来源字节未被修改。`predicate-review-create-callers.txt` 是源码树候选调用点扫描，含其他 board 和注释项，不能冒充当前配置完整可达调用图；本 issue 使用的是明确启用的 dataqueue 实现。

在独立 `evidence/predicate-review-build/` 快照中用相同逻辑映射、兼容 Coq8.20.1/OCaml4.14.1 重编译7/7成功，编译前逐一核对被冻结 hash，未借用活动目录的同名 trial `.vo`。记录在 `predicate-review-check.json`。框架打印日志确认 `struct_padding = emp`；heap bridge 的已证分离保持引理只依赖本次批准的地址/sizeof接口及标准外延性，没有新增用户公理。`ReviewCounterexample.v` 的三个 Qed 诊断事实亦单独编译通过，记录在 `predicate-review-counterexample.json`。这些是审阅证据，不是生产 predicate 文件或目标 VC。

## PR-01：实际嵌套 caller 被 nest=0 入口排除

**blocking / 设计问题 / open。** `SemaphoreCritical.v:29–33` 的 Outside 强制 nest=0，`CrtosOSPure.v:63–67` 的 rely/STS 两端也强制0，唯一 roundtrip lemma 只覆盖0→1→0。设计报告承认非嵌套边界，却没有用户批准缩小入口范围或源码依据。

当前 `board/stm32f103-nano/config` 启用 `KERNEL_DATAQUEUE`。`data_queue.c:41` 在 InitDataqueue 先 CriticalAreaLock；成功分配队列缓冲后，`:53` 和 `:58` 调 KSemaphoreCreate；外层 unlock 在`:63`。所以有效 ordinary caller 在nest=1、IRQ已屏蔽时调用目标，目标自身形成1→2→1，而不是0→1→0。`review_nest_one_roundtrip` 已直接确认当前真实算术更新可以处理nest=1。它不构成源缺陷，属于候选协议缺少对应入口/借用接口。

最小修复是本 trial 内支持普通嵌套的 critical adapter/借用边界，并保持 caller 的已有token/invariant唯一所有权、真实IRQ原子边界及恢复旧handler；不能简单再取得一份同一 invariant，也不能只把文字改成“只证明非嵌套”。允许复用现有 NestedCriticalCSL 等有依据的框架接口，不要求修改根库。通过条件：正式状态/Outside/Inside/rely/guarantee及设计记录覆盖上述实际caller；nest=1的进入/退出和caller资源恢复有明确正式statement及适用编译，IRQ trusted边界仍符合用户批准语义。修改后重审protocol、OSInv、Critical及其依赖。

## PR-02：pending membership 没有与 task suspended 状态关联

**blocking / 设计问题 / open。** `CrtosOSPure.v:50–57` 的 CrtosOSValid 对pending成员只要求“不在ready列表且task_desc_map有Some”。`CrtosOSInv.store_task_semaphore_view` 却真实拥有并解释该描述符的tsmStat，因此当前稳定不变量明确允许“pending链上任务的stat为INIT/READY/RUNNING”。这不是仅缺一个无关调度细节。

源 `linklist.c:119–124` 的 ResumeAll 循环不断从pending头取task并调用KTaskWakeup；`ktask.c:494–496` 的 _KTaskWakeup 在任务不为SUSPEND时直接返回-ERROR，`:503` 的摘节点不执行。于是在当前允许的状态中，ResumeAll无法完成摘链，已声明的“pending清空→retired→回收”生命周期无从得到依据。相反，正常 SuspendKTask 先建立SUSPEND，成功wake/timeout再移出pending，这正是需要表达的跨模块关系。

`ReviewCounterexample.v` 的 `review_pending_accepts_arbitrary_descriptor` 已机器证明：一个sem pending=[1000]、ready全空、task registry/id地址对应且map中存在desc的构造，对**任意desc**都满足当前CrtosOSValid。因而可选tsmStat低位为0，而不只是声称“可能存在漏洞”。本结论不等于真实已初始化系统一定会产生坏状态；它说明候选validity没有表达已承诺的pending语义。

最小修复是复用根TaskSchedMemberAbs/stat常量，对sem pending成员补齐真实的SUSPEND及必要task身份一致性关系，并说明 Suspend/Resume/timeout 的节点移交怎样保持它。ready/running视图若声称对应实际调度队列，也应补齐其必要membership关联或明确可接受的抽象范围。不要无依据添加“pending永远按当前优先级排序”等更强条件；条件必须经真实PrioSet/调度路径检查。通过条件：上述任意描述符反例被准确排除；合法pending、唤醒、timeout及未涉及task/scheduler frame仍能表示；不能以禁止所有非空pending队列来修复。

## PR-03：扩展嵌套时必须解决最大uint16计数的适用范围

**blocking [OPEN] / 待归因 / open。** 当前候选允许CrtosOSValid的nest达到65535，但通过PR-01中的零入口约束绕过了该值。去掉零限制后，不能直接宣称“所有合法nest都保持整个scheduler分量”。真实 CriticalArea.c:122–124 是uint16递增，`:133–135` 是非零才递减；所以65535→0→0。诊断引理 `review_max_nest_does_not_roundtrip` 已机器确认这一算术事实。

这与PR-01的实际nest=1支持是两件事。本轮没有证明当前配置实际caller可以达到65535，也没有发现支持任意固定更低上界的完整可达性证据；普通词法上配对的token栈本身亦不推出深度<65535。因此这里不写SRCERR、不要求修改源码、不把“目前不会证明”冒充真实缺陷。

通过条件：在当前授权语义内给出有源码/协议可达性依据的有效调用深度不变式，或给出其它不加强无依据Require且能准确表达入口/恢复的正规方案。不得仅为通过证明写任意cap，也不得把wrap后的0等同于原65535。若后续证据真能确认已批准范围内的可达路径违反scheduler保持，应再按报告指南归因，并由主agent处理授权边界。

## 已核对的其余部分

- 对象资源分割匹配32-byte真实ABI：ID manager拥有id.id与id.link，registry拥有sem.link，body拥有value/pending/padding；私有/registered-private/retired形态互补，没有把同一个嵌入节点同时交给对象和container。两段显式零padding共4字节与当前框架emp padding不重叠。malloc→zero→ID失败→完整私有free语义可表达。
- ID bitmap/16 bucket/lazy zero-or-self-loop形态复用正式根表示；manager从对象列表派生避免两个mutable事实来源。registry与桶的头插顺序符合当前源码。未发现第七个trusted需求。
- task scalar借用视图正确复用根store_task_sched_member，并不重复拥有sched_link；pending/ready spine与semaphore对象之间分离。Assign276字节、current_priority272、尾padding273..275由真实ARM编译确认。未用根RISC-V初始栈表示冒充ARM运行时栈。
- 统一新OS carrier、heap lift与token层分离合理；桥不把旧Task协议token转换成新token。rely允许环境变化，guarantee显式保留task和scheduler，成功create关系要求首空ID和值/pending初始化。PR-01/03尚未闭合，不代表这些其他部分需要推倒重写。
- 当前正式新文件没有手写Axiom/Parameter/Admitted/admit或占位定义。全量coqchk、目标VC/goal-check属于后续implement/final，未在本次predicate review中冒称完成。

修复后固定新manifest，重跑受影响compile/typecheck，交同一reviewer作issue及依赖范围的delta review。除非来源/config/scope发生实质变化，不重新对未变部分无限重复full review。当前没有用户决策请求；普通嵌套与pending一致性存在trial内可尝试修复方向。

## PR-03 新增 C 诊断证据的独立核对

修正后的 harness 已完成独立 delta 核对：真实 `struct Semaphore arena_object` 作为分配存储，消除了先前 char-array 类型访问疑点；caller 在目标调用后完整配对全部65535个外层 unlock。九份切片与当前权威源码宏展开后的tokens仍一致，原源码hash、harness与binary均核对通过。reviewer经自动批准独立再运行exit0，复现进入目标前nest=65535、成功创建id0/value3后nest=0/PRIMASK1，最终caller收尾后nest=0/PRIMASK0。证据在 `evidence/predicate-review-nest-check.json`。

本次绑定的binary SHA-256为 `d4145a1b12480f33ea16725fbe892fcb80e34cc51830254f677240e3c06b70b3`，C harness SHA-256为 `b27b3d8773b6e5128c04489ac6255edb92dc4b8cd8b174d7fd68c88dd44af49e`；这与主agent最终escalated记录一致。先前重建期间的hash暂不匹配已经解决，不再是open issue。

该证据的范围必须保持准确：这是ILP32下无上界API-client序列的具体计数诊断，不是当前STM32板上既有调用图达到该深度的证明。IRQ测试stub只复现PRIMASK具体读写；没有证明其满足完整Rely/token合同。尤其r1的Outside本来要求nest=0，所以这个序列不能被称为“在r1全部Require已满足时推翻其Qed证明”。它揭示修复PR-01、扩展入口时必须处理的语义范围，不能替代正式接口/可达性论证。PR-03的适用域问题仍待解决，PR-01/02及本轮needs-fix结论不变。

## r2 的 PR-02 及依赖 delta review

**PR-02 在 `predicate-r2-fc2db1b1c887` 上闭合；整体仍 needs-fix。** 本次只审 PR-02 修复及依赖，不把未解决的 PR-01/03合并标为passed。r2 manifest为 `fc2db1b1c8870dbbffdca92e0ad739aca885c70d8a752eb028caf203030a10e3`。对照独立r1快照，七份正式源中仅CrtosOSPure.v改变，其余六份hash完全相同；source-r2仅补入既有dataqueue caller证据，不重新启动full review。

独立检查在新的 `evidence/predicate-review-r2-build/` 完成：复用经r1核对且未受影响的三个 `.vo`，重新编译CrtosOSPure、CrtosOSProtocol、CrtosOSInv、SemaphoreCritical，均exit0；另外从作者源码独立编译PR02PendingCheck的四个Qed，exit0。全部命令与hash绑定在 `evidence/predicate-review-r2-check.json`，补查当前C的hash在 `predicate-review-r2-source-inputs.json`。

r2的实际修复符合PR-02要求：

- task_world_wf复用正式根定义，将map成员与registry、ID节点连接；pending状态使用同一个desc/map及共享stat低位，不引入另一份任务状态。pending_suspended/registered两个投影引理没有隐藏假设或用不同desc替换现有task。
- pending必须SUSPEND，准确对应_SuspendKTask以及Wakeup/timeout摘链的条件。原“任意desc都valid”的反例已排除；非空pending且Assign.os_running_task仍指向刚挂起任务的例子通过，故没有靠排除所有等待者修复。
- ready成员要求READY且cur_prio等于队列下标，与assign.c的KTaskInsertToReadyVector先设READY、再交RR_REMAINSLICE按cur_prio插入的稳定端点吻合。PrioSet处理READY任务时先摘旧队列、改优先级、再插回；处理中间值时仍持有临界区，不能把每一条指令后的暂态当作已经闭合的stable invariant。
- running指针只要求有map项，不反向强制其状态永远RUNNING。因此Obtain挂起当前task后尚未调度、ready插入后尚未切换、KTaskQuit把当前task设CLOSE并加入zombie后尚未调度的端点均没有因该字段被排除。KTaskQuit/_DeleteKTask此时仍保留task registry/ID；真正摘除发生于后续zombie回收。新任务设RUNNING、再更新os_running_task的短暂不同步发生于已禁IRQ的调度内部，不要求外部稳定态逐语句成立。
- 唤醒/timeout后pending移除、READY队列接纳的例子通过，exstatus保持可为0/-ERROR/-ETIMEOUT；未对pending当前优先级排序作无来源加强。本次没有改变任何heap owner，既有spine与task标量分离结论不变。

这些检查确认修复后的稳定端点和必要一致性，不冒充已证明Suspend/Wakeup/timeout/调度函数体，也不证明它们全部中间路径都满足完整OSInvariant。未来PR-01的nested adapter仍需正确处理持有invariant期间的局部暂态，不能借此delta结论跳过nested资源规则。

当前issue状态：PR-01 open；PR-02 closed in r2；PR-03 open。整体不得接受predicate revision，不得开始spec review/implement。作者设计报告将probe编译记录简称为 `pr02-pending-check.json`；实际位置是 `evidence/probes/pr02-pending-check.json`，这是非阻塞引用精确性问题，不影响formal revision或本次结论。

完成r2 delta后，主agent传达用户新增明确授权：“允许 nest<65535，明确排除更深调用”。这解决PR-03原先的范围授权问题，但r2尚未实现该新范围或嵌套接口；后续revision仍须检查入口与rely取得的current均满足批准深度、普通nest=1仍被支持。这里不把尚未修改的r2自动标为passed，也不将更深调用宣称为已验证。授权原文及设计变更记录由主agent保存。
