# Mutex 模块错误与验证阻断报告

状态：`confirmed-blockers`

关联 predicate review：[`predicate-r2-838b778f1e41`](2026-09-28-1-predicate-design.md)，结论 `needs-fix`。

这份报告把问题分成两类：一类是原始 C 代码本身可能出错，另一类是现有验证库还不足以证明这段代码。每个问题都给出可以直接跳转的源码位置、触发过程、后果和验收方法。它不修改 predicate revision，也不代替正式设计报告。

## 1. 复现上下文

- 配置：`board/stm32f103-nano/config`，Cortex-M3、32 位、非 SMP。
- `KERNEL_MUTEX=y`、`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`、`TICK_PER_SECOND=1000`。
- 权威实现：`kernel/thread/mutex.c`，SHA-256 `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645`。
- 权威类型：`kernel/include/xs_mutex.h`，SHA-256 `714bf24131f29d3f7b0f480525007b90d1f9e5ff63e8bf2526840e5e8f08c43f`。
- Formal candidate：`predicate-r2-838b778f1e41`；Rocq 8.20.1 编译和 `coqchk` 均通过，trust scan 零匹配。

## 2. 摘要

| ID | 分类 | 严重度 | 状态 |
|---|---|---|---|
| MUTEX-ERR-001 | C 生命周期竞态 | blocker / 高 | open |
| MUTEX-ERR-002 | holder 悬空引用 | blocker / 高 | open |
| MUTEX-ERR-003 | Task/Scheduler formal ownership 与 ABI | blocker | open |
| MUTEX-ERR-004 | recursive count 回绕 | 运行时风险 / 中 | open |
| MUTEX-ERR-005 | ID 隐式截断 | API 风险 / 中 | open |
| MUTEX-ERR-006 | timeout 语义偏差 | API 风险 / 中 | open |
| MUTEX-ERR-007 | debug 配置与实际预处理不一致 | 构建/闭包风险 | open |
| MUTEX-ERR-008 | KMutexCreate spec 闭包缺失依赖 | verification blocker | open |

## 3. 错误详情

### MUTEX-ERR-001：ID 查询解锁后的裸指针可被并发释放

- 级别：`blocker`
- 原代码：[KMutexDelete 查询后先解锁（mutex.c:246）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L246)、[KMutexObtain 查询后先解锁（mutex.c:279）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L279)、[KMutexAbandon 查询后先解锁（mutex.c:311）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L311)。
- 问题是什么（mismatch）：`KMutexDelete`、`KMutexObtain`、`KMutexAbandon` 在 `IdGetObj` 返回对象后先执行 `CriticalAreaUnLock`，随后才调用使用该裸指针的内部函数。对象没有 refcount、reservation 或可见的 shared/exclusive handle。
- 可复现场景：任务 A 查询 ID 并解锁；任务 B 删除同一 ID、移除对象并 `x_free`；任务 A 随后进入 `_MutexDelete/_MutexObtain/_MutexAbandon`。
- 会发生什么（concrete consequence）：use-after-free；两条 delete 路径并发时还可能演化为 double-free 或链表损坏。
- 建议怎么改（required fix）：在 lookup 到最终使用期间保持对象生命周期，例如保持临界区、增加 refcount，或实现有源码依据的 shared-borrow/delete-exclusive capability。
- 怎样算修好（pass condition）：机器检查的协议证明三个 wrapper 的 lookup-to-use 窗口内不存在并发 free；压力测试覆盖 lookup/delete 交错。
- 状态：`open`。

### MUTEX-ERR-002：Task 删除不会清理 mutex holder

- 级别：`blocker`
- 原代码：[保存 holder（mutex.c:95）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L95)、[向 waiter 交接 holder（mutex.c:178）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L178)、[ShowMutex 解引用 holder（cmd.c:246）](../../../Ubiquitous/XiZi_IIoT_Macro/tool/shell/letter-shell/cmd.c#L246)、[删除 task（ktask.c:643）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L643)、[最终回收 TaskDescriptor（zombierecycle.c:41）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/zombierecycle.c#L41)。全树没有 task-delete 到 mutex-holder 的清理。
- 问题是什么（mismatch）：mutex 保存 TaskDescriptor 裸地址，但 task 生命周期没有被 mutex capability 约束。
- 可复现场景：task 持有 mutex 后被删除并由 zombie recycler 回收；随后执行 `ShowMutex`、handoff 或 holder 比较。
- 会发生什么（concrete consequence）：`holder` 会变成悬空指针，后续代码可能访问已经释放的 TaskDescriptor。

  用一个具体地址举例：

  ```text
  1. Task A 取得 mutex，Task A 的 TaskDescriptor 地址是 0x1000
     mutex->holder = 0x1000

  2. Task A 被删除，zombie recycler 释放地址 0x1000
     但是 mutex->holder 仍然保存 0x1000

  3. 此时 mutex->holder 已经是悬空指针：
     它看起来仍是一个地址，但这个地址已经不再属于 Task A
  ```

  如果 `ShowMutex` 随后执行：

  ```c
  mutex->holder->task_base_info.name
  ```

  它就是在读取已经释放的内存，这叫 use-after-free。轻则打印垃圾内容，重则访问非法地址并导致系统崩溃。

  还有一种更隐蔽的情况：系统后来可能把同一个 `0x1000` 地址分配给新建的 Task B。此时：

  ```text
  mutex->holder == 0x1000
  Task B 的地址   == 0x1000
  ```

  于是源码中的 `task == mutex->holder` 可能错误成立，系统会把 Task B 当成原来的持有者。Task B 可能因此递归取得或释放一个实际上不属于它的 mutex。
- 建议怎么改（required fix）：禁止/延迟删除仍持有 mutex 的 task，或在 task delete 中遍历并清理/拒绝 holder 引用；同步定义可维护的 lifetime contract。
- 怎样算修好（pass condition）：证明 holder 非零期间对应 TaskDescriptor 始终存活，delete/recycle 与 holder capability 互斥。
- 状态：`open`。

### MUTEX-ERR-003：Task/Scheduler formal 无法提供 mutex 所需的唯一 ownership

- 级别：`blocker`
- 原代码：[非 TASK_INIT 的 sched-link 返回 emp（CrtosInv.v:89）](../../../lib/CrtosInv.v#L89)、[TaskDescriptor ABI 差异说明（KTaskDescriptor.v:76）](../../../lib/KTaskDescriptor.v#L76)、[Suspend/Resume 移动 sched-link（linklist.c:32）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c#L32)、[Timeout 移动 sched-link（ktask.c:407）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L407)。
- 问题是什么（mismatch）：没有 ready/running/suspend 状态下 sched-link 的 owner，也没有 task fields、ready/delay queues 与 mutex pending DLL 的成对 transfer 接口；Task 与 Mutex formal 又使用不同 STS carrier。
- 会发生什么（concrete consequence）：无法证明 `LinklistSuspend/Resume/ResumeAll/KTaskTimeout`；若直接组合当前 predicates，会缺权限、重复 ownership 或发生 ABI 地址错误。
- 建议怎么改（required fix）：修复 TaskDescriptor 的真实 ABI 表示，补齐 Scheduler 生命周期 invariant，并在统一或可提升的 assertion carrier 中提供 acquire/release 接口。
- 怎样算修好（pass condition）：每个相关字节在所有稳定状态下恰有一个 owner；ready→pending→ready、timeout、delete-resume 均可 refold；Rocq compile/coqchk 通过。
- 状态：`open`。

### MUTEX-ERR-004：`recursive_cnt` 可从 255 回绕到 0

- 级别：`non-blocker finding`
- 原代码：[`recursive_cnt` 是 uint8（xs_mutex.h:36）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h#L36)、[递归取得时直接加一（mutex.c:95）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L95)、[释放时根据递减结果决定是否解锁（mutex.c:171）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L171)。
- 问题是什么（mismatch）：256 次递归 obtain 后 holder 仍非空、value 仍为 0，但 count 变为 0；下一次 abandon 会回绕为 255，而不是释放。
- 会发生什么（concrete consequence）：mutex 可在极端递归下长时间无法释放，行为与常见递归锁计数语义不符。
- 建议怎么改（required fix）：在 255 时返回溢出错误，或扩大计数类型并定义上限行为。
- 怎样算修好（pass condition）：边界测试覆盖 254、255、256 次 obtain/abandon；formal transition 不再需要接受 holder 非空且 count=0 的回绕态。
- 状态：`open`；当前 predicate 忠实建模了 modulo-256 行为，没有隐藏该风险。

### MUTEX-ERR-005：公开 `int32` ID 被静默截断为 `uint16`

- 级别：`non-blocker finding`
- 原代码：[`IdGetObj` 接收 uint16 ID（xs_id.h:59）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_id.h#L59)、[KMutexDelete 调用点（mutex.c:247）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L247)、[KMutexObtain 调用点（mutex.c:280）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L280)、[KMutexAbandon 调用点（mutex.c:312）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L312)。
- 问题是什么（mismatch）：非负大 ID 不一定失败。例如 `65536` 被截断为 0，可能命中 ID 0。
- 会发生什么（concrete consequence）：调用者可能操作与输入 ID 不同的 mutex。
- 建议怎么改（required fix）：wrapper 在调用前验证 `0 <= id < ID_NUM_MAX`，或统一 API/内部参数类型并显式定义转换。
- 怎样算修好（pass condition）：测试 `128`、`65535`、`65536`、`65536+n`；超范围输入不得命中有效对象。
- 状态：`open`。

### MUTEX-ERR-006：零等待与 forever 等待语义和源码分支不一致

- 级别：`non-blocker finding`
- 原代码：[毫秒转 tick（mutex.c:85）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L85)、[`wait_time == 0` 分支（mutex.c:104）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L104)、[正等待值进入 delay（mutex.c:125）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L125)、[`CalculateTickFromTimeMs` 把 0 改为至少 1 tick（tick.c:99）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c#L99)。
- 问题是什么（mismatch）：`wait_time == 0` 分支在当前 callee 实现下不可达；`msec=-1` 先转为 `uint32 0xffffffff`，得到约 4,294,966 ticks，而非永久等待。
- 会发生什么（concrete consequence）：零等待调用至少阻塞一个 tick；期望 forever 的调用最终仍会 timeout。
- 建议怎么改（required fix）：在换算前显式处理 `msec==0` 与 `WAITING_FOREVER`，并让 API 文档、类型和实现一致。
- 怎样算修好（pass condition）：0、1、-1、最大正值的路径测试和 spec 与期望语义一致。
- 状态：`open`。

### MUTEX-ERR-007：配置声称关闭 debug，但源码无条件启用

- 级别：`verification/build finding`
- 原代码：[配置写着 debug 未启用（config:160）](../../../Ubiquitous/XiZi_IIoT_Macro/board/stm32f103-nano/config#L160)、[头文件无条件定义 KERNEL_DEBUG（xs_kdbg.h:31）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_kdbg.h#L31)、[KMutexCreate 的 active guard（mutex.c:222）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L222)、[guard 的 IRQ/ISR/无限循环内容（xs_kdbg.h:114）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_kdbg.h#L114)。
- 问题是什么（mismatch）：构建配置不能关闭 debug guards；mutex 又没有 semaphore.c 的局部 undef。
- 会发生什么（concrete consequence）：实际调用闭包包含 IRQ、ISR done-table、KPrintf 和无限 CHECK 路径；若按 config 把宏视为空，会得到不忠实 spec。
- 建议怎么改（required fix）：让 `KERNEL_DEBUG` 由生成配置控制，或明确记录该项目始终启用 debug 的政策并删除无效配置项。
- 怎样算修好（pass condition）：预处理输出与配置选择一致；两种模式的闭包测试固定。
- 状态：`open`。

### MUTEX-ERR-008：无 trusted 批准时 KMutexCreate 闭包不能形成 canonical specs

- 级别：`verification blocker`
- 原代码：[KMutexCreate wrapper（mutex.c:222）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L222)、[_MutexCreate 实现（mutex.c:27）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L27)、[`x_malloc/x_free` 实现（byte_manage.c:631）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/memory/byte_manage.c#L631)、[ID helpers（id.c:24）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c#L24)、[DLL helpers（double_link.c:30）](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c#L30)。闭包还包含 IRQ、ISR counter、日志和 `memset`；当前配置下仓库没有 active newlib `memset` 函数体。
- 问题是什么（mismatch）：skill 要求每个可达 symbol 要么有唯一 active canonical body/spec，要么由用户逐名批准 trusted contract；当前两者均未满足。
- 会发生什么（concrete consequence）：即使 predicate blockers 修复，spec 仍不能达到 `review-ready`。
- 建议怎么改（required fix）：为闭包每个非 trusted symbol建立一函数一文件 canonical slice/spec；或由用户逐名批准 trusted symbol及精确 contract。不能用裸 prototype 或 `implementation-pending` 代替。
- 怎样算修好（pass condition）：从 `KMutexCreate` 重扫闭包后，每个 symbol 恰好归入 canonical 或 approved-trusted 一类，且所有 caller-local contracts 一致。
- 状态：`open`。

## 4. 当前验证影响

- Predicate：`predicate-r2-838b778f1e41` 保持 `needs-fix`，不存在可批准 revision。
- Spec：因 predicate gate 未通过，尚未创建 spec revision，也未进入 spec review。
- Implement：未运行 QCP parser/symbolic、closure script、VC generation 或 proof。

## 5. 建议处理顺序

1. 先决定并修复 mutex object 与 holder-task 的生命周期策略（MUTEX-ERR-001、002）。
2. 修复 TaskDescriptor ABI，并闭合 Task/Scheduler ownership 与统一 carrier（MUTEX-ERR-003）。
3. 重新做 predicate affected-only review；通过后再处理 trusted/canonical closure（MUTEX-ERR-008）。
4. MUTEX-ERR-004～007 建议同时进入源码缺陷跟踪，避免后续 spec 忠实证明了非预期行为。

## 6. 复核命令

```sh
rg -n 'KMutex(Create|Delete|Obtain|Abandon)|_Mutex(Create|Delete|Obtain|Abandon)' \
  Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c
rg -n 'KERNEL_DEBUG|KDEBUG_NOT_IN_INTERRUPT|KDEBUG_IN_KTASK_CONTEXT' \
  Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_kdbg.h
rg -n 'store_task_sched_link|TASK_INIT|bitfield' \
  lib/CrtosInv.v lib/KTaskDescriptor.v
```
