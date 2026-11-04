# KEventDelete predicate 设计

本轮沿用当前32位非SMP验证配置及共享Event表示，权威C未修改，不采用先前修复候选。源码对象、全模块背景和15-symbol预期闭包见 [c-analysis.md](c-analysis.md)。用户已确认把D1/D2触发场景排除为运行假设，并限制外层ID为 `0 <= id < 65536`；这些是本轮验证条件，不是证明原源码不存在并发缺陷，详见 [source-errors.md](source-errors.md)。

固定审阅版为 `lib/EventInv.v`、`lib/EventOps.v`、`lib/KEventDelete.v`，导入前缀 `KEventDeleteTrial.lib`。前两份是在全局同名文件基线上增补，基线和hash保存在 `checks/predicate-baseline/`；已有类型/表示/操作没有改变含义。其他依赖直接来自全局库，不复制。`_CoqProject`明确引用全局与trial两个逻辑路径。现有全局 `CrtosInv.v` 和 `KEventCreate.v` 用户修改保持原样。

## 对象、状态与所有权

共享 `EventState` 保存地址、ID、3位options、29位events及等待任务基址顺序；ID manager从同一事件序列派生。删除复用这些权威状态，不另建对象表或Task视图。`EventOps`只增加 `event_set_pending` 和 `event_unpublish`：前者只改指定对象的等待序列，后者移除对象并保留其余管理顺序。

| 阶段/内存 | 唯一所有者与前后变化 |
|---|---|
| 已发布Event的ID字段和ID桶link | `store_idmanager`拥有；IdRemoveObj后ID=65535且ID link自环，转给私有退休对象。 |
| 管理链link | `event_inv`的管理DLL拥有；摘链后自环并交给私有对象。 |
| options/events、padding、pending哨兵 | 发布时属于 `store_event`；删除不改位域值或padding，pending必须空才可回收。 |
| 等待任务sched_link | 属于事件pending DLL，唤醒时移交ready结构；退休对象不能继续拥有已唤醒任务节点。 |
| Task字段、Delay、ready及其他模块 | 共用全局 `os_inv` 及已有批量更新；exstatus改为-1、SUSPEND改READY、非零活动Delay取消；其他任务字段和未受影响模块保持。 |
| 注销后的整个Event | 新增 `EventRetired(p,options,events)` 拥有模型36字节的所有字段、两字节padding和三个自环节点；解锁后由当前调用者独占，经 `EventRaw` 重组后交给 `x_free`。 |

`EventRetired`放在Event内存模块，明确不再属于 `event_inv`。`event_retired_raw_obligation`仅保存待证命题，没有用Axiom/Admitted提供转换事实。既有 `event_reclaim_bytes_obligation`继续承担typed字段到整块36字节的转换；ABI依赖沿用共享库。真实位域ABI为32字节、验证位域展开模型为36字节，这一适配及检查范围不变。

模块静态初始化未变化：`event_initial_memory`和`event_initial`继续描述BSS零bitmap/桶与自环管理哨兵。删除过程不增加新的初始化token或第二份全局状态。

## 用户运行条件的形式化边界

原 `CrtosRules` 的rely是True，不能仅凭“查询时有效”推导下一次锁内对象仍存在，也不能通过给普通Lock后的状态加未经授权的assert排除竞争。此次设计保持同一个断言载体、`InsideCritical`、`OutsideCritical`和`LastSeen`，不改全局rely，不复制协议实例。

`event_delete_guard(id,p,empty,st)`明确约束当前加锁观察中的目标对象：同一非零地址p与ID仍登记；仅empty=true时进一步要求pending为空。没有冻结options/events、其他对象、任务表或所有OS状态。`event_delete_gap`把这个后态条件与普通Crtos_RTrans组合；前态guard须由具名Lock合同Require给出。

相应CriticalAreaLock的 `event_delete_gap` 规格是**用户批准的D1/D2运行范围下的额外可信环境接口**，不是原ordinary锁规格可证明的特化。它仅适用于本轮Delete从命中到注销的分段调用，不能在任意其他API或未满足运行条件的系统中使用。纯guard本身没有空间所有权：真正的共享资源仍由该Lock接口交给当前执行的 `os_inv` 提供。 D1的具体运行条件是：查询命中的同一allocation从命中到本次注销前，不能被其他操作回收或复用。形式化guard只记录端点p/id，不保存allocation世代，因此不能靠该纯关系单独排除“先释放再以相同地址和ID重建”的ABA；可信环境Lock边界依赖完整的区间条件。

`event_delete_atomic_cmd`与这项接口一一对应：每次从LastSeen允许集合中选择还满足guard的实际加锁观察，执行锁内操作，再产生普通rely后态集合。只在这个显式假设下缩小可观察环境，不偷偷更改普通 `task_atomic_cmd`。在已有guard的前态，保持状态不变本身就是合法gap见证，因此没有用空环境关系或不可满足的“所有OS状态都保持对象”前提绕过错误。类型化待证义务 `event_delete_gap_nonempty_obligation`记录这一检查；它不是赋予额外权限的公理。

## 分段行为与全部路径

`abs_find_event`保留普通一次查找临界区。未命中返回0；命中返回当前同ID对象的基址。外层ID范围保证传给uint16不改变数值；容量128之外的ID仍可正常查找失败，不把“对象必须存在”塞入Require。

`abs_event_delete_at`保持原C控制流：

1. 按源码处理规则，为锁外IsDoubleLinkListEmpty的共享读取单独加锁；使用存活guard，检查结果决定resched。
2. 检查非空时调用保留自身锁的ResumeAll；加锁前仅使用存活guard。此时等待者可以已因其他操作离队，甚至队列已空；批量效果依据此次真正加锁观察的waiting，不能沿用较早检查时的列表。
3. 无论前面哪条路径，最后注销前都使用空pending guard。检查空分支的空条件来自检查结果；非空分支来自ResumeAll的后态。
4. 注销ID和管理链后，把EventRetired带过解锁并释放；仅最初检查非空时调用调度模型。即使ResumeAll实际进入时已空，resched仍是1，调度不能省略。

`abs_event_delete`组合查找及命中删除，未命中立即返回；抽象程序不把多段临界区说成一次原子删除，也不承诺整个调用入口/出口之间其他模块绝对不变。每段自身不修改的资源由精确局部更新及frame保持，段间变化属于已声明环境。free的私有资源消费由C规格处理，纯抽象状态移除不冒充物理释放。

## 批量唤醒及恢复义务

`event_resume_all_effect`复用根库 `resume_all_task_map`、`resume_all_delays` 和 `resume_all_ready`，给出整条当前waiting的任务/Delay/ready更新和事件pending清空。空队列是状态不变；非空效果使用已有的SUSPEND及NoDup事实，这些来自实际等待DLL和全局唯一所有权，不新增外层ID以外的用户参数限制。

循环内部的 `event_resume_one`先写exstatus，再使用根 `ktask_wakeup_step`；来源队首由 `event_pending_at`明确。`event_resume_all_steps`用于后续循环不变式，整体合同使用批量效果。`event_resume_all_effect_steps_obligation`只在合法os_inv与实际事件成员前提下连接二者；没有把semaphore场景合同改名当成事件证明。

最后注销复用 `CrtosInv.event_create_frame` 的精确其他模块资源，虽有历史名字，其内容适用于event拆出后的任何不改其他模块的操作。`event_unpublish_manager_obligation`记录ID移除与事件管理序列同步；`event_delete_restore_obligation`要求此前已导出的地址唯一性、空pending和manager等式，再恢复os_inv并单独返还EventRetired。这些是设计阶段类型检查过的证明义务，未当作已证明事实使用，也不要求在canonical C前提中重复加入可从旧os_inv推导的唯一性。

## 检查与审阅状态

三份正式文件均使用trial自己的 `_CoqProject` 和现有Coq 8.20.1工具链编译通过，日志为 `checks/predicate-EventOps.log`、`checks/predicate-EventInv.log`、`checks/predicate-KEventDelete.log`，退出码均0。没有运行QCP parser、symbolic、closure script、VC生成或C实现证明。没有新增Axiom/Parameter/Admitted；共享ABI公理仍是既有信任边界。

`keventdelete-predicate-r1` 已独立 review-passed，见 [predicate-review.md](predicate-review.md)。正式hash由 `checks/predicate-revision.json` 固定；trial/lib现在只保留审阅快照，活动定义已合并到全局库，纯路径迁移与重编译结果见 [status.md](status.md)。后续正式语义变更仍须重新检查受影响内容。

独立审阅后的r1注释澄清：补明同一allocation的区间存活与ABA限制，仅改变解释文字，正式定义/类型/语义未变；更新文件hash，不另建formal revision。
