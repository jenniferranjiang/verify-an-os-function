# Event 模块源码问题

原问题分析依据修复前权威源码、非 SMP 配置及 `annotated_C/src/include/xsconfig.h`。修复前 `event.c` SHA256：`1351dfb28f28413e50790fd4390777e647c6d60f1fe9debf850367c902841d64`。以下证据是静态执行路径或条件化调度反例，未声称已在真实 OS 运行复现；E2延时失败修复仅保存在trial候选中，权威源码保留原缺陷；其他修复建议未实施。预期行为部分说明问题判据和建议的错误处理方式，不冒充已经证明的函数规格。

本轮按对话确定的最小修复范围处理：E1和E2的非法策略路径作为接口使用条件说明，合法使用场景要求有效事件ID及FIFO/PRIO等待策略，未修改这些输入路径；E3按用户明确的“使用期间不可能被删除”环境约束排除，未实现通用并发删除保护。E2的延时建立失败是合法参数下的缺陷，本轮只修复trial候选，权威源码未修复。上述说明不把Create的参数范围收窄：KEventCreate仍接受uint32全域并保存低3位，原predicate/spec保持这一行为；不宣称其返回的任意策略都能用于合法Process等待。

**修复位置更正：仅修改trial。** 按用户最新要求，权威 `event.c` 已恢复原样（SHA256 `1351dfb28f28413e50790fd4390777e647c6d60f1fe9debf850367c902841d64`）；E2修复保存在 [source_fixes/_EventProcess.c](../../source_fixes/_EventProcess.c)，在文件头和修改分支加入中文注释。它是trial修复候选，未加入本轮Create的QCP调用闭包，不能据此声称权威OS源码已经修复。候选修复与此前已审函数仅注释和存放位置不同；迁移后重新运行回归，原版仍检出缺陷，trial候选16场景通过。

下文原问题轨迹的event.c行号指向[原始快照](../../checks/e2-delay-failure/before-event.c)，与恢复后的权威源码一致。

## E1：无效 ID 未得到一致的拒绝处理

状态：已澄清为非法输入处理问题，本轮不修改源码。下面两条行为确实存在，但“非法输入必须返回错误而不能断言停机”没有独立接口依据；在只传入有效事件ID的使用范围内，不将其列为已确认的合法调用缺陷。若未来要求处理任意int32输入，需重新评估并修复。

源码位置：[KEventProcess 查找后直接调用](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:295)、[FindEventById 只检查负数](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:212)、[_EventProcess 的 NULL 检查](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:147)。调试配置和检查宏见 [xs_kdbg.h 的 KERNEL_DEBUG](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_kdbg.h:31)、[NULL_PARAM_CHECK](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_kdbg.h:96)；ID 类型转换见 [IdGetObj 的 uint16 参数](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c:122)。

**触发场景与预期行为。** 在正常任务上下文调用 `KEventProcess(-1, 1, EVENT_AND, 0, NULL)`。ID 无效，应正常返回错误，不访问对象；建议与同模块 Trigger 的未找到分支一致返回 `-ERROR`。Delete 保持无效 ID 时直接返回的接口行为。

**实际执行路径及后果。**

1. `FindEventById(-1)` 在负数分支返回 `NONE`。
2. `KEventProcess` 没有检查结果，调用 `_EventProcess(NONE, ...)`。
3. 当前权威头文件直接定义 `KERNEL_DEBUG`；`NULL_PARAM_CHECK(event)` 打印错误后进入 `while (RET_TRUE)`，调用无法正常返回。
4. 若另行关闭该调试宏，非零 events 路径会继续到 `event->events` 的 NULL 解引用。这是另一配置下的后果，不是当前配置已经发生的 NULL 解引用。

**同一查找入口的 ID 截断反例。** 假设 ID 0 的事件已存在，调用 `KEventTrigger(65536, 1)`：`FindEventById` 只拒绝负数，随后把 int32 的 65536 传给 uint16 参数，值变成 0；`IdGetObj` 检查的是转换后的 0，因而可能返回 ID 0 的对象。无效输入会误操作合法对象；同样传给 Delete 时可能误删 ID 0 的事件。这不同于已删除 ID 被正常重新分配，修复范围检查也不解决通常的 ID 重用问题。

**可能的修复。** 在任何窄化转换之前检查 `0 <= id < ID_NUM_MAX`；在与 E3 统一后的锁内查找处处理未找到分支，Process/Trigger 返回错误，Delete 直接退出。不能只加一个锁外 NULL 检查便认为生命周期已经安全。

**修复后检查。** 负 ID、未分配 ID、128、65536 和 INT32_MAX 均不得访问或删除合法事件；合法 ID 保持正常行为。分别核对调试宏开、关时的错误返回路径。

## E2：挂起、等待入队与延时建立的失败没有被正确处理

状态：trial候选的延时建立失败分支已修复并通过针对性主机回归，权威源码保持原样；非法等待策略路径未修改，按FIFO/PRIO输入约定限定Process的合法使用场景。下文执行路径记录修复前问题。

源码位置：[_EventCreate 保存未经校验的 options](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:27)、[Event.options 为 3 位位域](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_event.h:42)、[LinklistSuspend 先挂起再检查 flag](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c:32)、[_EventProcess 忽略等待和延时操作结果](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:178)。任务挂起的副作用见 [_SuspendKTask 从就绪队列摘除并置 SUSPEND](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c:524)；延时失败分支见 [KTaskSetDelay 的分配失败返回](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/delay.c:40)。

**触发场景与预期行为。** 分配和 ID 登记成功时，`id = KEventCreate(2)` 得到事件，初始事件位为 0。运行中的任务 T 随后调用 `KEventProcess(id, 1, EVENT_AND, 1000, NULL)`。创建策略 2 不属于等待链支持的 FIFO=0 或 PRIO=1。应在改变任务调度状态前拒绝该策略；若等待或延时建立失败，应恢复调用前可运行状态并返回错误，不能留下未正确登记的挂起任务。

**实际执行路径及后果。**

1. Create 未校验 options，把 2 保存到 3 位字段并返回成功。
2. 当前 `TICK_PER_SECOND=100`，`CalculateTickFromTimeMs(1000)` 得到 100 ticks；事件位 0 不满足等待位 1，进入等待分支。
3. `LinklistSuspend` 先调用 `SuspendKTask`。T 是当前可运行任务时，挂起成功：从就绪队列摘除、置 SUSPEND。
4. 随后的 switch 遇到 flag=2，进入 default 返回 `-EINVALED`，没有把 T 插入事件 pending。
5. `_EventProcess` 忽略该错误，继续建立延时、解锁并调度。如果延时建立成功，另一任务在超时前调用 `KEventTrigger(id, 1)` 时，pending 中没有 T，Trigger 无法唤醒它。即使事件位已经满足，T 仍可能等到超时返回 `-ETIMEOUT`。
6. 若 T 尚无 Delay 对象，且 `KTaskSetDelay` 的 malloc 失败，它返回 `-ENOMEMORY`；Process 同样忽略返回值继续调度。此时 T 既不在事件 pending，也没有超时登记。在没有其他显式唤醒的条件下，事件触发和超时机制都无法恢复它，造成持续挂起。

**对先前报告的更正。** 原报告直接使用“timeout<0 的无限等待”作为触发条件，依据不足，撤回该表述。[CalculateTickFromTimeMs](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c:99) 接收 uint32 并做数值换算，不直接保留调用者的负数；不能从 `msec=-1` 推出本函数中的 `timeout<0`。这里用明确的有限超时和实际分配失败分支建立反例。

**可能的修复。**

- `_EventCreate` 在 malloc 之前校验完整 options 值，只接受 FIFO/PRIO；非法值返回 `-EINVALED`，并更新参数说明。这样会新增真实错误返回路径，后续 spec 必须据源码更新。
- `LinklistSuspend` 在挂起之前校验 flag，并检查 `SuspendKTask` 的返回值，挂起失败时不插链。
- `_EventProcess` 检查 `LinklistSuspend` 的结果，失败就返回；也检查 `KTaskSetDelay` 的结果，失败时在锁内撤销本次挂起/等待入队，恢复可运行状态，再返回错误。
- `LinklistSuspend` 是共享函数，修复时检查 semaphore、mutex、msgqueue 等调用者的兼容性。

**修复后检查。** FIFO/PRIO 均正常等待和唤醒；2..7及含高位的非法创建选项不分配对象、不占用ID；挂起失败或Delay分配失败时，不留下孤立SUSPEND任务，不残留等待或延时节点。触发、超时和删除唤醒三种路径分别检查。

### E2延时失败的trial修复与检查

修复位置：[trial _EventProcess.c:58](/home/xinra/crtos/keventcreate-trial-261101-1/source_fixes/_EventProcess.c:58)。文件头注明来源和trial范围，分支内中文注释说明E2修改、回滚原因及为何保留后续调度。只提取并修改这一函数，Create、共享LinklistSuspend及权威源码均保持原样。

现在保存 `KTaskSetDelay` 的返回值；失败时把错误写入 `task->exstatus`，在仍持有原临界区的情况下调用 `KTaskWakeup(task->id.id)`，摘除本次pending节点并恢复READY。随后复用原来的解锁、`DO_KTASK_ASSIGN` 和exstatus错误返回检查。保留调度是必要的：Wakeup只设置READY，公共调度路径才能在本任务继续执行时恢复RUNNING。没有在额外持锁期间等待，也没有直接从READY状态提前返回。

`KTaskSetDelay` 当前唯一失败路径是在新Delay分配失败时返回；此时尚未安装Delay对象，所以不增加free。回滚不改事件位和调用者processed输出。其他等待者的顺序与节点保持。

检查证据：[故障注入结果](../../checks/e2-delay-failure/results.json)、[测试驱动](../../checks/e2-delay-failure/run.py)、[主机模型](../../checks/e2-delay-failure/harness.c)。驱动从原始源码和真实依赖提取函数，修复版只用trial候选替换_EventProcess，共18个函数正文，包括Process、Trigger、挂起、唤醒、延时、链表和临界区函数；IRQ、ready存储、分派查找和上下文切换采用明确主机模型。相同检查在原版以exit20检出“延时分配失败后仍保持SUSPEND”，修复版16个场景全部通过，且启用UBSan。覆盖FIFO/PRIO、已有等待者、连续失败、初次分配成功、已有Delay复用、立即满足及正常超时；核对错误返回、RUNNING恢复、pending/ready/delay无残留、其他等待者保持、输出不写及锁平衡。

迁移后trial候选通过主机GCC语法检查，见[trial语法日志](../../checks/e2-delay-failure/trial-host-syntax.log)。此前对临时修改的完整event.c尝试32位整翻译单元检查时，因缺少32位libc头 `bits/libc-header-start.h` 未完成；仍不声称目标构建或目标板运行验证通过。这不是QCP实现证明；未运行symbolic或生成VC。

修复影响与独立复查见 [e2-fix-review.md](e2-fix-review.md)。两个Create函数正文及其predicate/spec未变化，继续原设计审阅结论，不为未修改的formal文件制造新revision。

## E3：查找返回裸指针后，对象可能在使用前被删除

状态：按用户明确的“事件使用期间不会被删除”环境约束排除本轮触发条件，未修改源码。下列轨迹仍说明不满足该约束时的风险；没有声称实现了通用并发删除保护或真实调度复现。

源码位置：[FindEventById 解锁后返回指针](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:212)、[KEventTrigger 使用查找结果](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:273)、[_EventTrigger 重新加锁后访问对象](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:94)、[_EventDelete 摘链后解锁并释放](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:55)；Process 的对应窗口在 [KEventProcess](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:295) 和 [_EventProcess](/home/xinra/crtos/keventcreate-trial-261101-1/checks/e2-delay-failure/before-event.c:137)。非 SMP 临界区的关中断和恢复见 [CriticalAreaLock / CriticalAreaUnLock](/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/CriticalArea.c:117)。

**触发场景与预期行为。** A、B 两个任务操作同一个事件 ID，调用发生在允许抢占的普通任务上下文。一个操作成功取得对象后，应保证直到最后一次访问完成，对象仍存活；或者删除先完成，后续操作查找失败并返回错误。

**支持判断的交错反例。**

| 步骤 | 任务 | 执行位置及状态 |
| --- | --- | --- |
| 1 | A | 执行 `KEventTrigger(id, 1)`，在 FindEventById 锁内取得对象地址 p。 |
| 2 | A | FindEventById 解锁并返回 p；在 `_EventTrigger` 取得自己的锁之前，被中断/调度切换出去。此场景要求 A 进入 API 时没有外层临界区。 |
| 3 | B | 执行 `KEventDelete(id)`；假设 pending 为空，正常注销ID、摘除管理link，解锁后 `x_free(p)`。 |
| 4 | A | 恢复并执行 `_EventTrigger(p, 1)`。p 非NULL，NULL检查通过；随后重新加锁。 |
| 5 | A | 在 `event->events |= events` 处访问已经释放的 p。重新加锁不能使旧地址恢复存活。 |

后果是释放后访问；若该内存已经重用，可能改写其他对象。两个 Delete 都在释放前取得同一指针时，也存在重复删除/释放的窗口。这些是上述调度条件下的静态反例，不声称已经测得具体堆损坏结果。

另外，Delete 在取得第67行的删除锁之前检查pending并调用ResumeAll；即使只缩短查找窗口，这段“检查/唤醒”和“注销/摘链”之间仍需防止新的等待者进入。修复必须覆盖整个删除事务。

**可能的修复。** 在当前非 SMP 配置下，让查找与全部对象访问处于同一个临界区：

- 将内部 Delete/Trigger/Process 改为接收ID，取得各自临界区后调用只供持锁者使用的查找函数；同步调整EventDoneType和初始化表，公开API签名保持不变。
- Trigger在锁内完成查找、事件位更新和等待者唤醒，解锁后再调度。
- Delete在锁内完成查找、等待者唤醒、ID注销和管理链摘除；解锁后释放已脱离共享结构的对象，再按需调度。
- Process在锁内完成查找、条件检查、等待入队及延时建立；解锁后才调度。恢复后只使用任务自身保存的结果，禁止继续解引用旧Event指针。当前恢复分支已经读取 `task->event_id_trigger`，可保留这一安排。

不要在整个公开Process外面简单再包一层临界区：它内部会阻塞和调度，额外外层持锁会改变调度行为。若将来覆盖SMP，还需另行建立对应锁和生命周期保证，不能直接推广本方案。

**修复后检查。** 控制或注入交错，覆盖Trigger/Delete、Process/Delete、Delete/Delete及等待者入队与Delete的竞争；检查删除后查找失败、正在执行的访问结束前不能释放、等待者得到错误唤醒，以及解锁后无旧对象访问。若将来允许并发删除，必须重新开启E3并完成相应修复和检查。

用户随后批准了KEventCreate实现证明；两个Create函数的最终结果见[status.md](status.md)。该证明不覆盖_EventProcess修复候选，原始权威源码的E2缺陷没有因此消失。若扩大输入范围或允许事件并发删除，需重新处理相应问题。
