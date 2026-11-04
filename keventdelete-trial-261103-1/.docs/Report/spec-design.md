# KEventDelete 完整调用闭包规格设计

当前输入为 `annotated_C/src/` 的15个symbol和 `annotated_C/include/` 的类型/逻辑声明。四个新目标有真实active正文，其余是具名模型/API或reused-spec边界。正式契约仅保存在C文件；本记录不重复With/Require/Ensure。

用户于2026-11-03确认D1/D2触发场景不发生，并确认 `0 <= id < 65536`。公开入口和查找规格据此限制ID；128..65535仍允许查找未命中后正常返回，不要求对象已存在。权威C的int32签名、uint16调用、负ID分支全部保留，负值只是本次公开合同覆盖范围之外；没有把所有输入改成uint16类型。

## 真实调用闭包

从四份适配后active正文手工重扫，边如下：

- KEventDelete → FindEventById、_EventDelete。
- FindEventById → CriticalAreaLock、IdGetObj、CONTAINER_OF_EVENT_ID、CriticalAreaUnLock。
- _EventDelete → CriticalAreaLock、IsDoubleLinkListEmpty、CriticalAreaUnLock、LinklistResumeAll、IdRemoveObj、DoubleLinkListRmNode、x_free、KTASK_ASSIGN。
- LinklistResumeAll → CriticalAreaLock、CONTAINER_OF_TASK_SCHED、KTaskWakeup、CriticalAreaUnLock。

| symbol及同名canonical文件 | 边界/审阅范围 |
|---|---|
| KEventDelete、FindEventById、_EventDelete、LinklistResumeAll | 4个新设计目标，每个文件一个真实active定义，完整canonical规格及调用者本地callee规格。 |
| IdGetObj、IdRemoveObj | 根ID模块原contract的reused-spec边界，含原有具名形式；不递归GetObj/FreeId/RemoveObj实现。 |
| IsDoubleLinkListEmpty、DoubleLinkListRmNode | 根链表合同的reused-spec边界，采用dll和remove_member；保留其他已有具名形式。 |
| KTaskWakeup | 根任务通用wakeup_by_id_ic的reused-spec边界，未把semaphore特化改名为event合同；其他原有具名形式保留。 |
| CriticalAreaLock、CriticalAreaUnLock | TrustBase已有临界区接口；普通ordinary/stable原合同保持。额外event_delete_gap是本轮用户环境条件下的可信接口，不是ordinary的已证明特化。 |
| CONTAINER_OF_EVENT_ID、CONTAINER_OF_TASK_SCHED | TrustBase允许的类型化CONTAINER_OF模型；只给地址关系，不提供分配存活或内存权限。 |
| x_free | TrustBase的KERNEL_FREE/x_free边界，消费完整EventRaw。未复用不适用的SemaphoreRaw合同，也未把free实现当作本轮已证明。 |
| KTASK_ASSIGN | 《源代码处理》规定的调度模型，保留原有safeExec及OutsideCritical接口。 |

边界文件的声明是完整API合同，不是裸prototype；只有4个新目标纳入后续实现证明目标。根复用来源、原始contract文件hash与精确位置见 `checks/source-slices/manifest.json`。本轮没有使用新的未经用户批准trusted C symbol。

## 分段临界区和运行条件

FindEventById返回地址时，实际锁已经释放。命中后的纯guard仅是最近观察到的对象关系；它不持有共享内存。下一次加锁通过本轮具名环境合同取得实际os_inv后才能读写对象。

D1按用户确认解释为：查找命中的同一分配对象在本次注销前不会被其他操作删除、回收或复用。端点具有相同p/id不足以证明没有ABA，排除这种回收/复用来自该运行条件，而不是guard的数学形状。D2保证本次观察/清空后的空pending直到注销仍空。并未冻结所有OS状态，检查非空之后、ResumeAll真正加锁前，原等待者可离队；实际清空效果按ResumeAll取得锁时的waiting序列计算。

`event_delete_gap`锁contract的使用范围仅是本轮删除调用链，普通锁仍不提供这样的保证。它在Require中要求调用前观察已经满足对应guard，不能对任意未知对象凭空要求存在或队列为空。此可信环境接口结合用户批准条件才适用，不能单独推广到其他调用者或任意Event并发程序。

最后一次删除锁前，空条件分别来自先前IsEmpty结果或ResumeAll完成。注销后完整Event资源从全局不变量移到私有EventRetired，再带过解锁交给x_free；退出仅返还OutsideCritical及抽象continuation，不把已经释放对象保留给caller。

## 路径和资源检查

- ID未命中：只发生查询临界区，直接返回，不释放、不调度。ID懒桶初始化可能改变具体形态，抽象集合不变不等于所有字节不变。
- 命中且检查为空：共享读取临界区后进入注销临界区；空pending保持由D2给出。释放对象，不显式调度。
- 命中且检查非空：ResumeAll保留自身真实锁，逐个写task.exstatus=-1并调用通用KTaskWakeup。循环每次重新取队首，空时退出；任务/Delay/ready的整体更新由event_resume_all_effect表达。
- 检查非空但ResumeAll实际加锁时已空：ResumeAll无共享状态更新，但resched仍为1，注销/释放后仍执行KTASK_ASSIGN。
- NULL_PARAM_CHECK的非返回分支保留为while(1)；合法对象/哨兵权限使该分支在合同前提下不可达。没有删掉非终止路径来取得通过。

内存对应：查找读manager/bitmap/桶由os_inv中的store_idmanager提供；IsEmpty读哨兵由event_inv的pending DLL提供；ResumeAll的哨兵和sched_link由event等待链拥有，exstatus及task ID来自task_inv；Wakeup转换任务、delay、ready和来源等待链。最终ID字段/ID link由IdRemoveObj返还，管理link由DoubleLinkListRmNode返还，未改options/events/padding和空pending一起组成EventRetired。具体ledger与待证桥见predicate设计报告。

## 源码适配与ABI

原函数摘录及hash在 `checks/source-slices/`，不是从先前未应用修复候选提取。没有移动或合并原锁：Find的锁、ResumeAll的锁和最终删除锁均保留。唯一新增临界区按《源代码处理》只包围_EventDelete的一次共享IsEmpty检查，把其结果存入新的局部pending_empty，再解锁并执行原if；没有在检查后跨ResumeAll持锁。

其他适配：删除已授权debug打印/宏；静态done.EventDelete依据唯一initializer解析为_EventDelete；static转切片external；NULL检查保留死循环；CONTAINER_OF/SYS_DOUBLE_LINKLIST_ENTRY采用已授权类型化模型；DO_KTASK_ASSIGN采用规定模型。嵌套于ResumeAll的KTaskWakeup使用已导入的锁内contract边界，不重新递归其实现。

类型头保留本次访问所需的完整TaskDescriptor嵌套布局，Event位域按TrustBase展开为两个uint32。实际ILP32原Event为32字节、展开后36字节；Task sched_link偏移16、exstatus偏移92、id偏移104，完整TaskDescriptor为120字节。`checks/source/event-layout.c`检查真实Event头文件，`checks/source/slice-layout.c`检查实际切片及共享布局接口使用的偏移，均用GCC -m32静态断言。

根LinklistResumeAll的semaphore_waiters是锁内场景，原适配删除了nested locks，不能作为本次Event锁外合同使用。本轮是新的event_waiters_oc场景，使用真实带锁正文；原根Semaphore场景及同步出现的Mutex场景均不修改。审阅后新增Event场景保存在独立命名验证输入目录，避免把不同场景共同编译或覆写已有合同。

## 设计阶段检查

15个C文件通过GCC ILP32语法检查，日志 `checks/annotated-c-syntax.log`。GCC不会解析QCP注解，因此这不是QCP语法验收；本阶段按技能只做注解结构、接口和源码一致性人工检查。正式predicate编译日志及 `checks/DesignInterface.v` 的Rocq类型检查用于确认注解引用的语义接口；没有复制C契约到.v，也没有运行QCP parser/symbolic、closure脚本、VC或C实现证明。

`keventdelete-spec-r1` 已在 predicate r1 明确 review-passed 后完成独立审阅，结论为 review-passed，见 [spec-review.md](spec-review.md)。精确审阅输入、共享场景迁移和合并后检查见 [status.md](status.md)。
