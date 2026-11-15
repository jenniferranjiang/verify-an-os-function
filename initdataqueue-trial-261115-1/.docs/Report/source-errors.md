# 当前源码缺陷、验证副本修复与门禁

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
