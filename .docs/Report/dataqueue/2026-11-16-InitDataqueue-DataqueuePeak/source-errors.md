> 全局整合后的位置：Init/DeInit/Peak在annotated_C/src/kernel/dataqueue；Push/Pop在annotated_C/module_context/dataqueue；已批准的_Obtain副本在annotated_C/module_context/semaphore。下面的早期阶段描述和hash保留为源码证据，当前状态见function-status.md及integration-review.md。

# 当前源码缺陷、验证副本修复与门禁

**当前新增阻塞（Push/Pop等待路径）：零超时补丁已独立复核通过；另确认deadline回绕插入导致旧任务延迟唤醒，以及有限等待忽略Delay分配失败导致没有超时节点。两项新问题均未获修复授权、正式源码副本未改，状态needs-fix，详见本文末尾。**

**当前增量状态（2026-11-16，Push/Pop新范围）：发现 `_SemaphoreObtain` 的 timeout=0 仍挂起缺陷；用户已明确批准最小补丁，现已应用到module_context源码副本并通过实际副本对照测试，等main已独立复核通过。既有 Init/DeInit、Push/Pop、Peak 修复/适配及其检查保持有效；不能将先前针对已知问题的解除门禁结论扩展到这个新发现。**

当前状态：**用户批准的 Init/DeInit、Push/Pop 修复已应用于验证副本并通过针对性检查；原源码缺陷仍存在。Peak 共享访问疑点已按默认源码处理规则在副本适配。Main 已逐行独立复核三份新副本，认可修复与适配；本轮已识别源码问题门禁针对下列副本版本解除。** 尚未编写 formal spec，未运行 QCP，不表示实现已获证明。

权威来源：`/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c`，HEAD `340892ea259f1d38e418f7099277e3ede9f1d1fd`，当前文件 SHA-256 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`。源码只读，修复前后 hash 一致。此前读取的 `6ff659…` 文件已被外部改变，其 sentinel 已修复结论不再用于当前原源码。

## Semaphore ID 判断缺陷

原 Init 用 `if (!p_queue->sem_blank)` 和 `if (!p_queue->sem_data)` 判断失败，而 create 返回非负 ID（含0）表示成功、负数表示失败。故首个合法 ID0 被错误拒绝，清理的 `if (id)` 又不会删除它；负失败值反而可使 Init 继续并最终返回 EOK。memset 把尚未创建的 ID 置0，不能区分未获得资源与持有 ID0。

用户本轮明确授权额外修复 Init/DeInit 副本。实际补丁：Init memset 后两 ID 置 -1，两次 create 后以 `<0` 判断失败；DeInit 对 `>=0` 的 ID 删除并置 -1。副本注释保留原判断/重置代码及原 zero 初始化行为。**create 返回的负失败码保持原值**：例如 first-create=-5 时结果为 (-5,-1)，second-create=-5 时清理后为 (-1,-5)。DeInit 不重置已经为负的字段，因此失败后契约应允许“两 ID 均负”，不能无依据断言均等于 -1。

## Timeout 路径缺陷

原 Push/Pop 仅处理 timeout=-1 与0；其他值跳过 Obtain，却在末尾 Abandon 对偶信号量。容量2的初始空队列调用 Pop(...,1) 会保持输出旧值、将 blank 从1增到2、返回 EOK。满队列调用 Push(...,1) 对称地不插入却增加 data 并成功返回。

用户授权修复两份副本：完整注释保留原 do-while；改为统一 `KSemaphoreObtain(id, timeout)`，非 EOK 立即返回 -ERROR，成功才继续原数组/索引/Abandon 路径。此修复也处理原无限等待分支忽略 Obtain 失败的问题。没有限制 timeout 只能为0/-1。Push/Pop 仅作为模块分析的修复输入，不加入 Init 实现调用闭包。

## Peak 的规则允许适配

原 Peak 先在锁外检查 front/rear，再锁内读取元素，两次观察可能被并发 Pop 分隔。当前 `DataqueuePeak.c` 把 CriticalAreaLock 移至条件之前，已有非空出口解锁保留，空出口增加解锁；检查和元素读取在同一临界区。原锁位置注释保留。

这是《源代码处理》“在实际执行共享访问的 callee 中加入最小临界区”的适配，未改变 caller 或声称原源码无条件等价；也未把该函数加入 Init 实现闭包。先前的两阶段观察疑点在此适配副本中已消除。

## 副本版本与检查

本 trial 的 Init/DeInit 位于 `annotated_C/src/`；Push/Pop/Peak 位于 `annotated_C/module_context/`，不属于实现证明目标。下表 hash 不因移动改变：

| 文件 | SHA-256 |
| --- | --- |
| InitDataqueue.c | `1e5df77f4758ca99d4698792d91dc28bc57a8682e82e5fe5eefaaec31b3ce531` |
| DeInitDataqueue.c | `74c4afd9b9c4ebb75491ac7e81243b43e203d3987f6ae1a3c37cea94f5c3d5e1` |
| DataqueuePeak.c | `e44ca0f1dd5143fb06bfe15b0be6a4b0a80b96704b0fb498f65aabea2f576900` |
| PushDataqueue.c | `31d2a1e65c031bcdbc824457fc007083b2a1b4c3c1266b85dd08ae56b88e87b8` |
| PopDataqueue.c | `fab095b76f466969a845e1b48688de69e5a8729e99a980eeea4e1e137bbe8370` |

GCC C11 `-Wall -Wextra -Werror` 编译实际副本函数体，依赖使用可观察 stub；通过：

- Init 成功，ID0分别位于 blank/data，检查初值、数组大小、两次create参数和锁平衡。
- malloc失败、首次create失败、第二次create失败三处回滚；分别检查释放/删除的次数和ID，不误删未创建对象；回滚后base为空且两ID为负。
- 补充精确断言：首次create失败后ID为(-5,-1)，第二次失败后为(-1,-5)，再次DeInit保持这两个精确状态且不增加delete，编译执行通过。
- 每次清理后再次 DeInit，无额外free/delete；NodeNumber=0（模拟真实malloc返回NULL）和1路径。
- Peak空/非空，两出口锁平衡，空时输出保留，非空时输出正确且索引不变。
- Push/Pop 对 timeout=0/1/17/-1（main）及-1/0/1/20（独立复核）分别测试成功/失败，每组16例，检查timeout原样传递、输出/索引、副作用与失败frame。

全部通过。所有一次性测试目录已清理；这些是控制流检查，不是实际OS并发证明、ILP32 ABI确认或Rocq证明。后续设计须以这组修复/适配版本及明确的32位非SMP验证配置为依据；结论不套用到原仓库。


## 新门禁：Obtain 的零超时错误进入等待路径（2026-11-16）

状态：**用户已批准并应用源码副本；作者对照测试通过，等main已独立复核通过后解除此增量门禁。**

当前权威 `kernel/thread/semaphore.c` SHA-256 为 `d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec`，`kernel/thread/tick.c` 为 `4db5cceacbf0f7a6c4d72151c9e66cdf30bdfa0eb455820cdf5048365456323d`。原仓库只读，未修改。此前获批 Push/Pop 副本仍原样把 timeout 传给 KSemaphoreObtain；原数据队列代码明确将 timeout=0 标为 Nonblocking。

`_SemaphoreObtain` 只特殊处理 -1，其余 msec 均送入 CalculateTickFromTimeMs。真实 converter 在算出0时返回 MIN_TICKS=1，包括输入0；项目配置 TICK_PER_SECOND=100。因此已找到且 value=0 的 semaphore 在 timeout=0 时不会命中 `wait_time == 0` 的立即 -ETIMEOUT 路径，而会设置当前任务exstatus、调用LinklistSuspend和KTaskSetDelay(task,1)，解锁并请求调度。此前Push/Pop以可控Obtain stub执行的测试只检查参数转发和上层控制流，未验证这个实际callee行为。

独立可运行反例直接提取当前源码的 CalculateTickFromTimeMs 和 _SemaphoreObtain 两个函数体；仅用可观测stub替代系统锁、ID查找、当前任务、挂起、delay和调度依赖，32位无符号/有符号运算类型使用stdint精确定义。GCC `-std=c11 -Wall -Wextra -Werror` 编译并运行通过：

| 输入/版本 | lock/unlock | Suspend | SetDelay | ticks | Assign |
| --- | --- | --- | --- | --- | --- |
| 原版，id有效/value=0/timeout=0 | 1/1 | 1 | 1 | 1 | 1 |
| 最小提案，同输入 | 1/1 | 0 | 0 | 0 | 0 |

两次测试返回-2；原版的返回值来自调度stub模拟唤醒后的exstatus，不能把它解释成原版立即返回。反例证明的是确实选择了挂起/延时/调度分支，不是完整scheduler或墙钟延时证明。提案对照另检查有可用计数时仍递减成功、负ID仍立即失败、正timeout=1仍走等待、timeout=-1不设置有限延时；均通过。

最小建议只改本trial将来的 `_SemaphoreObtain` 副本，在原等待时间选择前增加 `if (msec == 0) wait_time = 0; else if (...) ...`，保留 -1 和其他timeout转换及 CalculateTickFromTimeMs API 原行为。该提案现已获用户批准并应用到下述源码处理副本；Push/Pop已批准代码不变。

零超时提案及反例已完成应用和独立复核，临时测试文件已清理；实际全局副本、差异及测试摘要在本报告和source-changes.md保留。


### 已批准零超时补丁的应用与实际副本测试

用户明确批准上述proposal.diff后，创建 `annotated_C/module_context/semaphore/_SemaphoreObtain.c`，提取当前权威完整函数，保留static签名、全部原控制流、打印和末尾exstatus读取；只在等待时间选择前增加 `msec == 0` 分支。原选择代码作为注释保留。副本 SHA-256 为 `bfd1a4a4fa37af2895ffb7853d8780949f25fb20d0a8b60362e3209c6e120fd3`。这是供spec作者后续迁入src的源码处理副本，当前无正式spec；未额外实施共享读取适配或其他算法修改。

从新副本重新提取实际body放入原对照harness（不是再次生成提案函数体），GCC C11 `-Wall -Wextra -Werror` 编译、运行通过。有效ID/value=0/timeout=0的副本轨迹为ret=-2、lock/unlock=1/1、Suspend=0、SetDelay=0、Assign=0；原版对照仍有Suspend=1、SetDelay=1、ticks=1、Assign=1。可用value、负ID、timeout=1与-1对照全部通过。去注释/空白核对新body与“原body仅应用已批准patch”完全一致。原semaphore.c hash仍为 `d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec`。

上述首次测试由补丁作者执行；其后main已完成独立复核，结论见下段。测试新增文件为原临时目录中的 `applied-counterexample.c` 与 `applied-counterexample`，待独立复核完成后清理。未生成或修改formal/VC，保留既有.vo。

Main已核对批准diff与实际副本完全一致并独立重跑控制流测试，全部通过。零超时门禁针对该副本解除，原源码缺陷仍存在。


## 新门禁：deadline回绕插入使旧任务晚唤醒

状态：**needs-fix，尚未获用户修复授权；正式C未应用此提案。** 当前权威delay.c SHA-256为 `96bae0517d57db4dd5b960a0bc88fa1b096b15eca5d0c69224d6b93f309e0961`。

这不只是参考invariant不匹配。实际KTaskSetDelay以无符号绝对数值 `<` 插入，而CheckTaskDelay只检查队首、以 `(current_tick - node->ticks) < TICK_SIZE_MAX/2` 判断到期；错误队首可以阻挡已到期的后续任务。

完整触发：当前tick=0xfffffffe，既有任务A的deadline=0xffffffff（再1tick到期），新任务B请求3ticks（当前100Hz下Obtain的ms=30可达），B的新deadline回绕为1。数值比较1<0xffffffff把B排到A前。到tick=0xffffffff时，队首B的模差为0xfffffffe，不满足到期条件，CheckTaskDelay直接break；A虽已到期却不被检查。到tick=0同样如此，直到tick=1才先唤醒B、再唤醒A，A晚了2ticks。

可运行反例直接使用当前源码的KTaskSetDelay、KTaskUnSetDelay、CheckTaskDelay以及InitDoubleLinkList/InsertBefore/RmNode/IsEmpty真实函数体，仅stub锁、当前tick、分配器与timeout回调；使用精确uint32运算。GCC C11 `-Wall -Wextra -Werror` 编译运行通过，记录：

| 版本 | 插入后队首deadline | tick=0xffffffff的A/B唤醒次数 | tick=1的A/B累计唤醒次数 |
| --- | --- | --- | --- |
| 原版 | 00000001 | 0/0 | 1/1 |
| 仅比较器提案 | ffffffff | 1/0 | 1/1 |

提案仅将比较条件改为“deadline不相等且 `(uint32)(old_deadline-new_deadline) < TICK_SIZE_MAX/2`”，保留相等项的稳定顺序；未增加其他返回分支。可审阅文件为 `/tmp/crtos-verify-initdataqueue-trial-261115-1-delay-wrap-Q4gwoM/proposal.diff`，同目录counterexample.c与counterexample保留本次证据。这一局部对照不是任意跨度时间戳的全机制证明：导入参考for_null_inactive契约仍需其合法时长、NULL/inactive及共同时间窗口前提。 当前Obtain的实际转换先在uint32中计算ms×100，再提升uint64并除1000，因此返回ticks至多4294968，严格小于TICK_SIZE_MAX/2=2147483647；本调用的新请求时长可满足半周期界，但已有active deadline共同未来窗口仍是独立条件。不能据此声称通用SetDelay对任意ticks已修复。未擅自添加no-wrap前提，也未修改权威源码或正式trial输入。

## 新门禁：有限等待忽略Delay分配失败

状态：**needs-fix，已由直接控制流确认，未提出已批准补丁，未修改正式C。** 这是与上述比较器问题独立的等待失败处理问题。

可达入口为正常运行任务、task.delay=NULL、目标semaphore存在且value=0、正有限timeout。Obtain先将task.exstatus置0，经LinklistSuspend挂起任务并加入semaphore pending；随后KTaskSetDelay尝试分配Delay对象。分配器允许返回NULL，真实KTaskSetDelay在此立即返回-ENOMEMORY（-5），没有写task.delay或加入全局Delay链。Obtain丢弃这个返回码，仍解锁并调度；该任务继续SUSPEND且只存在于semaphore等待链，没有timeout节点。

如果之后没有其他任务Abandon/Delete该semaphore或显式唤醒该任务，CheckTaskDelay无从发现它，有限等待不会因所请求timeout结束。这不应被描述成“允许任意最终exstatus”的普通契约分支来掩盖，也不能将分配成功设为无依据前提。此结论来自真实失败分支、被忽略调用结果和任务/Delay生命周期；本节未另做调度器执行测试或声称已证明永不返回。

最小处理方向是检查KTaskSetDelay返回值，失败时在锁内撤回本次pending并恢复可运行状态，再解锁返回错误；必须同时审阅节点唯一归属、任务状态及ready/Delay资源，不能仅提前return把已挂起节点遗留。 回滚必须定位本次task，不能调用只处理队首的LinklistResume，因为队首可能是另一优先级任务。可进一步评估KTaskWakeup(task->id.id)后返回原错误的方案，但本轮未完成该方案的测试/审阅，不宣称它已经正确。这里只记录建议，不设计或应用额外大补丁；它不包含在上面的比较器proposal.diff中。

当前两项新门禁交main向用户说明。此前已批准并完成复核的零超时修复保持有效，但不解决回绕排序或分配失败回滚。原仓库、全局formal与稳定trial设计不因本节更改；未运行QCP或实现证明。
