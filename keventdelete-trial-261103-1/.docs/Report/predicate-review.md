# Predicate 独立审阅

> 历史 r1 审阅结论；r2 修改了函数级 predicate/program，当前结论见 `predicate-spec-r2.md`。

审阅人：独立 `delete_protocol_review` agent；作者：`delete_predicate` agent。审阅日期2026-11-03。对象为 `checks/predicate-revision.json` 固定的 `keventdelete-predicate-r1`：`lib/EventInv.v`、`lib/EventOps.v`、`lib/KEventDelete.v` 及其设计记录。审阅依据为当前权威 Event/ID/链表源码、32位非SMP配置、共享库实际定义、TrustBase及本轮用户批准的D1/D2环境条件和ID范围。

结论：**review-passed**。固定 revision 为 `keventdelete-predicate-r1`，采用最后的注释澄清版本。已核对三个正式文件的SHA256：

- `EventInv.v`：`c0ac8f814f8fbb52d7d8f1dcc06224f1a3f9641850c9a0f8d24443e774ce2dfa`
- `EventOps.v`：`cc40d236a2e2ee33383ad07f1cef6ffa586a4c0be93f7abe1df9b762c0fb3a80`
- `KEventDelete.v`：`03edcc31ebb4a58ac57ecd4de9fec4e08a072112f15d4ddde5c49f2060de45c4`

审阅要求补充的唯一澄清已经落实：guard仅描述端点p/id，不能单独排除删除后地址与ID复用的ABA；D1明确要求同一allocation从查找命中到本次注销前不被其他操作回收或复用。该修改只涉及注释，正式关系、类型及接口未变；复用此前编译结果。没有待解决的predicate设计阻塞项。

## 已检查的设计

Event模块延续根库的单一对象序列及派生ID manager。新增pending更新与注销操作保持其余对象及顺序，不另建重复的Task或manager状态。新增EventRetired只持有已经注销对象的ID字段、两个外部link、pending哨兵、options/events和padding；等待任务的sched_link已转给ready结构，不会在退休对象中重复拥有。完整36字节模型范围与既有EventRaw及布局条件一致，真实位域ABI32字节的适配限制明确。

与C对象生命周期逐项对照：查找只是观察，不创造堆权限；pending检查不改变状态；ResumeAll写各任务exstatus=-1、将SUSPEND改READY、取消适用延时并按已有RRR关系插入ready；最终注销要求pending已空，更新ID manager及管理链后产生私有退休对象；该对象可以在解锁后单独释放。未修改模块经精确replace操作和frame保留，段间的环境变化不冒称函数自身修改。

批量唤醒使用实际加锁时的waiting序列。非空检查后队列可能被环境清空，此时ResumeAll的抽象效果为空操作，但resched仍沿用早先检查结果，因此仍保留调度分支。没有将多个临界区合并为一个原子删除，也没有把Root的Semaphore IC场景当作Event OC实现。

## 环境条件与非空行为

统一CrtosRules的rely=True及断言载体均未修改；event_delete_atomic_cmd在普通LastSeen允许的观察中加入本轮guard，并在正常关系与错误关系中采用相同的观察筛选。它依赖当前删除场景的具名可信Lock合同，不能从ordinary Lock合同推出，也不是纯guard提供共享堆。实际os_inv仍由Lock提供，解锁前必须恢复。

live阶段只要求目标仍注册，不冻结事件位、pending或其他OS分量；empty阶段要求已观察/清空的pending保持空。Lock前置明确需要旧观察中对应guard成立，调用者不能凭空要求empty。无变化的环境步是满足该前态的一个gap见证，未采用不可能的全称状态保持条件。查找未命中、查空后注销、查非空后实际清空、查非空后进入ResumeAll时已空等路径均有对应描述。正常合法等待状态的批量转移沿已有有限RRR插入关系和延时更新构造，不以移除所有正常行为规避目标。

环境限制是用户批准的本轮验证假设，源码缺陷仍存在。结论不能推广到任意Event调用环境或其他线程持有无保护旧指针的执行，也不证明硬件中断或Lock实现保证这些环境条件。

## 待证义务与检查证据

资源转换、批量效果与逐步关系连接、ID移除一致性及恢复均明确为Definition保存的Prop，没有新增Axiom、Parameter或Admitted，未把它们当作已证明结论。`event_delete_restore_obligation`实有地址NoDup、空pending和移除后manager等于新对象序列派生manager的前提；因此不会从一个缺少ID/payload一致性的剩余堆无条件恢复os_inv。这些局部事实应从先前有效资源导出，不是新加到公开API的用户限制。

三个文件的编译日志与manifest退出码均为0，对应.vo在正式内容编译后存在；最终只增加ABA注释，没有改变正式内容，无须重复编译。审阅时SHA256与固定manifest逐项一致。共享.v依赖与trial建立时基线一致；根_CoqProject另新增KMutexDelete构建项，不改变本候选使用的路径映射或定义。没有运行QCP parser、symbolic、closure工具、VC生成或C实现证明。

本审阅仅覆盖predicate设计；后续完整调用闭包spec必须引用同一个通过版本另行审阅。设计通过不能表述为KEventDelete实现已经得到证明。
