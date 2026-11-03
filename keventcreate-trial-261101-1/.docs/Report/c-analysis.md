# KEventCreate 全新实验：C 分析

日期：2026-11-01。作者：独立 C analysis agent。已完整读 TrustBase、源码处理规则和 predicate 指南 §1；只读权威源码、已有库与规格，不运行 QCP/symbolic/VC/实现证明。

## 配置与来源

权威源码 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c`、`kernel/include/xs_event.h`、`xs_id.h`、`xs_klist.h`、`xs_base.h`、`xs_memory.h`；生命周期上下文 `thread/id.c`、`double_link.c`、`linklist.c`。配置沿用根 `annotated_C/src/include/xsconfig.h`：KERNEL_EVENT、ID_NUM_MAX=128、ID_HTABLE_SIZE=16，无 ARCH_SMP/ARCH_CPU_64BIT，ILP32 为 TrustBase 授权适配。源码树只有另一 XiZi_AIoT_Micro 分支存在 xsconfig.h，不应误用它。

源 event.c SHA256：`1351dfb28f28413e50790fd4390777e647c6d60f1fe9debf850367c902841d64`。

`/tmp/kevent-abi-authoritative.c` 包含权威 Event/Id/Memory 头，用 `gcc -m32 -std=c11 -ffreestanding -fsyntax-only -I Ubiquitous/XiZi_IIoT_Macro/kernel/include -I annotated_C/src/include /tmp/kevent-abi-authoritative.c` 编译 exit 0。检查的真实 ABI：IdNode size12,id@0,link@4,padding[2,4)；Event size32,id@0,options/events 共享[12,16)位域字,pend_list@16,link@24；IdManager size12；指针4字节；DLL next@0,prev@4。

**关键：Event.options 是 uint32:3，events 是 uint32:29。** 创建的位域赋值令 options 取低3位，而不是保存任意输入原值。若按 TrustBase 拆成两个 uint32，模型 Event size36,options@12,events@16,pend_list@20,link@28；应显式记录模型 ABI 与真实 ABI 区别，并把 `event->options = options` 等价适配为 `event->options = options & 7`（或 `%8`），保持观察语义。不能用 Require options<8 或仅0/1来隐藏截断。

## 对象、生命周期、状态与 ownership

DECLARE_ID_MANAGER 产生 manager、16字节 BSS bitmap 和16个 BSS 哈希桶；容量/桶数/数组地址固定。`k_event_list` 静态自环。ID 桶采用懒初始化。模块最小语义状态可为按全局管理链顺序保存的 Event 对象序列，元素含地址、ID、存储的3位 options、29位 events、等待任务地址序列。由对象序列派生 ID 集合及每桶插入顺序；避免同时保存独立可变 manager 副本。Options 创建后不再写，但对象会删除/新建，宜随对象保存。events 运行中 trigger/process 会改，不能设为 stable。

ID manager predicate 唯一拥有各 Event.id（id标量+ID link）；管理 DLL 唯一拥有 Event.link 的两个指针；Event payload 拥有 options/events、padding、pend_list哨兵和等待任务 sched_link 节点。Task descriptor 的 event_id_trigger/event_mode/exstatus 等仍属于 TaskInv，不能在 EventInv 重复拥有。模块需接入全局状态和系统不变量，并加入 event waiters 与 ready/delay/sem/mutex 等队列的跨模块排他与注册关联。已有全局库明确排除 event/msgqueue，必须增量扩展，不能仅 import 新模块。

生命周期：malloc 私有raw→memset全零→锁内 ID 注册（ID node所有权移至manager）→options赋值、pend自环→管理DLL头插→已发布；失败 ID 注册归还未知 ID node，解锁后 free 原始基址；删除唤醒waiters→删ID/管理链→释放。pending任务对象不随Event释放。

## 全模块函数逐项分析

- `_EventCreate` 27–53：分配失败直接 -ENOMEMORY=-5；成功分配先 memset，再 Lock；IdInsertObj 返回负数时 Unlock→free→-5；成功 options低3位、events保持0、空pend、自身link头插，Unlock返回ID。无循环、无阻塞。Lock前和Unlock后环境可演进，外层调用不能声称全局入口=出口或返回时对象仍存在。
- `_EventDelete` 55–77：NULL check；pend非空时 LinklistResumeAll 并标记resched；Lock内删ID和管理link，Unlock后free；如唤醒任务则yield。pend空判断和批量唤醒位于删除锁外；需以后验证时做并发/生命周期分析。
- `_EventTrigger` 79–135：events=0返回-1；Lock内 event.events |= events（实际29位截断）；空pend则Unlock返回0；遍历pend，按task.event_mode AND/OR判定，OR成功会改task.event_id_trigger；先缓存 next 再可能wake并移除当前；AUTOCLEAN 清除触发位；Unlock后若wake过任务则yield，返回0。循环不变式未来需保留已扫描/待扫描链、当前events和wake后的任务资源。读取task模式/触发/ID，修改触发值，KTaskWakeup修改任务调度状态。
- `_EventProcess` 137–203：debug/NULL check；events=0返回-1；获取当前task并置exstatus0，算timeout，Lock；AND/OR测试；立即成功时可写processed并AUTOCLEAN；未满足且timeout0时exstatus=-ETIMEOUT；否则设置task.event_id_trigger为events低29位，event_mode为options低3位，LinklistSuspend(pend,task,event.options)，timeout>0设delay，Unlock→yield；恢复后exstatus非0直接返回，正常恢复再次Lock并可写processed，最后Unlock返回task.exstatus。无本地循环，存在阻塞路径。processed仅非空时写，其所有权应由caller提供。等待链顺序受创建options控制。
- `FindEventById` 212–232：负ID返回NULL；Lock查ID，缺失Unlock返回NULL；成功CONTAINER_OF后Unlock返回指针。manager查询和指针生命周期不是同一保证。
- `KEventCreate` 240–245：debug宏获准删除，唯一 dispatch `_EventCreate`。
- `KEventDelete` 254–264：debug、Find，NULL空操作，非空唯一 dispatch `_EventDelete`。
- `KEventTrigger` 273–283：debug、Find，NULL返回-1，非空唯一 dispatch `_EventTrigger`。
- `KEventProcess` 295–302：debug、Find，无NULL保护，直接 dispatch `_EventProcess`。

静态 done 在205–210初始化，整个翻译单元没有改写或地址逃逸；四个 dispatch 均唯一可解析。本次只 Create 闭包，其余函数用于设计完整模块对象状态，不被误列为本次实现目标。

## 适配后完整 Create 闭包

| symbol | 分类 | 所需接口与依据 |
|---|---|---|
| KEventCreate | 新 active canonical | debug移除，done.EventCreate→_EventCreate |
| _EventCreate | 新 active canonical | static改切片external；保留三个return、锁顺序、释放；位域截断显式保留 |
| x_malloc | TrustBase 已批准 KERNEL_MALLOC 同义模型 | xs_memory.h:49 `KERNEL_MALLOC(sz) x_malloc(sz)`；复用 m_ktask.h delay_object：NULL或正、有界、ALIGN_SIZE对齐的完整未知字节数组 |
| memset | 已批准 C stdlib API | m_ktask.h:590 的 c∈[0,127],字节数组接口，c=0满足；返回原指针和全零数组 |
| CriticalAreaLock | TrustBase trusted symbol | 共享 CrtosRules Outside→Inside+全局inv |
| IdInsertObj | reused-spec 边界 | 根 annotated_C/src/headers/id_module_spec.h:89，保留原 contract；无须递归证明其 AllocId/InsertObj/NULL_PARAM_CHECK |
| InitDoubleLinkList | reused-spec 边界 | 根 annotated_C/src/InitDoubleLinkList.c，未知next/prev→非NULL self-linked |
| DoubleLinkListInsertNodeAfter | reused-spec 边界 | 根 annotated_C/src/DoubleLinkListInsertNodeAfter.c，选择 generic dispatch_case；head锚点实例导出头插 |
| CriticalAreaUnLock | TrustBase trusted symbol | Inside+重组inv+GTrans→Outside |
| x_free | TrustBase 已批准 KERNEL_FREE 同义模型 | xs_memory.h:53 `KERNEL_FREE(ptr) x_free(ptr)`；完整raw字节、原malloc基址→emp |

闭包准确到这些边界停止，不递归 malloc/free 内部或 ID 已复用边界内部；Create无 NULL_PARAM_CHECK，也没有调度/等待callee。所有 caller-local 完整 contract 必须与所选 canonical 原契约等价。

IdInsertObj 失败仅给 `return=-1 ∧ 原manager * store_idnode_insert_ready(idnode)`，不保证full，且归还未知值ID字段；创建失败 abstract program 不能凭空要求manager已满，也不能声称对象仍全零。成功保证 min_free_id 和 idmanager_link(add(...))，新ID字段/节点移交manager。

复用文件 SHA256：id_module_spec.h `cc688388f779c493f303f8347019b74d21ca0c1c51c1d09d2f1627ac48c5a025`；InitDoubleLinkList.c `9b64aea58b40fef8b205772844d978ed5fbfee73892198fd8dcb91f37db0c1ac`；DoubleLinkListInsertNodeAfter.c `66c9654dfb4faea731ccdf647a1b6fed57ef0acd2acf5c1ef5b746f618f0d0dd`。

## 源码问题及对本次范围的影响

本轮按对话确定的最小修复范围处理：E1和E2的非法策略路径作为接口使用条件说明，合法使用场景要求有效事件ID及FIFO/PRIO等待策略，未修改这些输入路径；E3按用户明确的“使用期间不可能被删除”环境约束排除，未实现通用并发删除保护。E2的延时建立失败是合法参数下的缺陷；按用户要求只在trial/source_fixes/_EventProcess.c保存修复候选，权威源码已恢复原样。上述说明不把Create的参数范围收窄：KEventCreate仍接受uint32全域并保存低3位，原predicate/spec保持这一行为；不宣称其返回的任意策略都能用于合法Process等待。

原报告记录的event.c哈希与已恢复的权威源码一致；trial候选、原始快照、具体触发路径、E2时间转换描述更正和回归证据统一见[source-errors.md](source-errors.md)。仅trial候选中的_EventProcess延时失败处理发生变化；KEventCreate/_EventCreate及完整创建闭包保持。独立增量复查见[e2-fix-review.md](e2-fix-review.md)。
