# CRTOS Mutex 与 Event 源代码错误汇总报告

状态：`source-review / open`

日期：2026-09-30

## 1. 报告范围

本文汇总四个可以从当前 C 源码直接说明的问题：

1. `MUTEX-ERR-002`：持有 mutex 的任务被删除后，`mutex->holder` 成为无效引用；
2. `MUTEX-ERR-004`：8 位递归计数回绕，可能导致过早释放；
3. `MUTEX-ERR-006`：零等待与永久等待参数没有按预期语义执行；
4. `EVENT-ERR-002`：Event 删除过程中允许新 waiter 加入，任务节点最终关联到已释放 Event。

按要求，Mutex `MUTEX-ERR-001`、`MUTEX-ERR-005` 和 Event 原报告中的问题一不纳入本文。本文只分析源码行为，不讨论形式化验证模型和证明过程。

复现配置采用 `board/stm32f103-nano/config`，其中 `CONFIG_TICK_PER_SECOND=1000`，目标为非 SMP Cortex-M3。

## 2. 摘要

| 编号 | 错误 | 主要后果 | 优先级 |
|---|---|---|---|
| MUTEX-ERR-002 | 删除任务时未处理其持有的 mutex | 永久锁死、悬空指针、错误认主、非法内存访问 | 高 |
| MUTEX-ERR-004 | `recursive_cnt` 无上限检查 | 递归深度超过 255 后可能过早交锁 | 中；触发少见但后果严重 |
| MUTEX-ERR-006 | 特殊等待值进入普通无符号时间换算 | 零等待实际阻塞；永久等待约 71 分 35 秒后超时 | 高 |
| EVENT-ERR-002 | 清空 waiter 与撤销 Event 发布之间存在窗口 | waiter 失联、链表悬空、释放后写入、堆破坏 | 高 |

## 3. MUTEX-ERR-002：删除持锁任务后遗留 `holder` 指针

### 3.1 源码位置

- [`struct Mutex::holder`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h#L38) 直接保存 `TaskDescriptor *`。
- 首次取得 mutex 时，[`_MutexObtain`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L98) 将当前任务写入 `holder`。
- 交接 mutex 时，[`_MutexAbandon`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L178) 将等待任务写入 `holder`。
- [`_KTaskResourceDelete`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L98) 只从 ready vector 移除任务并将其标为 close，没有检查 mutex。
- [`_DeleteKTask`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L643) 没有检查目标任务是否持有 mutex。
- [`KTaskQuit`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L569) 对主动退出任务执行同类资源删除。
- zombie recycler 在 [`zombierecycle.c`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/zombierecycle.c#L64) 释放任务栈，并在第 74 行释放 `TaskDescriptor`。
- [`ShowMutex`](../../Ubiquitous/XiZi_IIoT_Macro/tool/shell/letter-shell/cmd.c#L246) 在 `holder != NONE` 时解引用 `holder->task_base_info.name`。

### 3.2 问题解释

假设任务 A 的 `TaskDescriptor` 地址为 `0x1000`：

```text
1. A 取得 mutex M
   M->val    = 0
   M->holder = 0x1000

2. B 调用 KTaskDelete(A)
   A 被标记为 close，并进入 zombie 队列
   M->holder 仍为 0x1000

3. zombie recycler 回收 A
   地址 0x1000 对应的 TaskDescriptor 被释放
   M->holder 仍为 0x1000
```

从第 2 步开始，A 已经不能继续运行，因此无法正常执行 `KMutexAbandon`。从第 3 步开始，`M->holder` 成为悬空指针。

### 3.3 可能后果

1. **Mutex 永久占用**：`val` 仍为 0，原 holder 已不能运行，其他任务只能等待或超时。
2. **释放后读取**：`ShowMutex` 读取已经释放的 `holder->task_base_info.name`，可能打印错误数据或触发异常。
3. **地址复用后错误认主**：若新任务 C 复用地址 `0x1000`，`mutex->holder == task` 可能错误成立。C 会被当作递归持有者，也可能释放一个从未正常取得的 mutex。

### 3.4 根本原因

Mutex 保存 Task 地址，但 Task 生命周期没有维护反向关系。源码既没有禁止删除持锁任务，也没有延迟回收、自动清理或 owner-dead 机制。

### 3.5 解决方式

推荐给 `TaskDescriptor` 增加 `held_mutex_list` 或 `held_mutex_count`：

- mutex 从空闲变为持有时登记到任务；
- 递归取得只增加递归计数，不重复登记；
- 最后一层 abandon 时从任务持有集合移除；
- `_DeleteKTask` 在临界区内发现集合非空时返回 `-EBUSY`；
- `KTaskQuit` 执行相同检查，并采用明确的拒绝、诊断或 owner-dead 策略。

改动较小的方案是在删除任务时遍历 `k_mutex_list` 查找 `holder == task`，但所有任务退出入口都必须统一执行该检查。

若产品要求 holder 异常退出后系统继续运行，可以实现 robust mutex：将 mutex 标记为 `OWNER_DEAD`，下一位持有者收到专门错误并修复共享数据。不能简单清空 `holder` 或无条件释放，因为受保护数据可能处于不一致状态。

### 3.6 验收条件

1. A 持有一个或多个 mutex 时，删除和退出路径不得留下悬空 `holder`。
2. A 递归持锁时不得漏检。
3. A 释放最后一层后，删除能够正常完成。
4. 删除处理后运行 `ShowMutex` 不访问已释放 Task。
5. 任意稳定状态下，`holder != NONE` 必须表示对应任务仍存活。

## 4. MUTEX-ERR-004：递归计数回绕造成过早释放

### 4.1 源码位置

- [`recursive_cnt`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h#L36) 是 `uint8`，范围为 0～255。
- 同一 holder 再次 obtain 时，[`mutex.c:95-96`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L95) 直接执行 `recursive_cnt++`，没有上限检查。
- abandon 时，[`mutex.c:171-172`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L171) 先执行 `recursive_cnt--`，结果为 0 就释放或交接 mutex。

### 4.2 问题解释

任务 A 总共取得同一个 mutex 257 次：

```text
取得总次数       recursive_cnt
1               1
255             255
256             0
257             1
```

此时 A 逻辑上仍有 257 层持有，但内核只记录了 1。A 随后只调用一次 `KMutexAbandon`，计数从 1 变为 0，源码就会释放 mutex 或将其交给等待任务 B，尽管 A 仍有 256 层没有释放。

恰好取得 256 次后，下一次 abandon 会把计数从 0 回绕到 255，并不会立即释放。能够直接说明过早释放的边界例子是“取得 257 次后只释放 1 次”。总体问题是递归深度超过 255 后，内核无法正确表示剩余层数。

### 4.3 可能后果

- B 过早进入临界区，与仍认为自己持锁的 A 同时访问共享数据；
- 受保护的链表、缓冲区、文件系统结构或设备状态被并发破坏；
- A 后续 abandon 时收到“不是 holder”的错误；
- `ShowMutex` 出现 holder 非空但递归计数为 0 的状态。

### 4.4 解决方式

推荐在递增前检查上限：

```c
if (mutex->recursive_cnt == UINT8_SIZE_MAX) {
    CriticalAreaUnLock(lock);
    return -EOVERFLOW;
}
mutex->recursive_cnt++;
```

当前错误码集合没有 `EOVERFLOW`，可以新增专用错误码，或选择并文档化一个现有错误码。溢出失败时，holder、计数、value 和等待队列必须保持不变。

也可以将计数扩大为 `uint16` 或 `uint32`，但仍建议保留显式上限检查。不能采用计数饱和后继续返回成功的方案，因为该方案仍会丢失真实递归层数。

### 4.5 验收条件

若最大合法深度为 255：

1. 前 255 次 obtain 成功，第 256 次返回溢出错误且状态不变。
2. 前 254 次 abandon 不得释放或交接 mutex。
3. 第 255 次 abandon 才能释放或交接。
4. 边界失败不得唤醒 waiter。
5. 不得存在 `holder != NONE && recursive_cnt == 0` 的稳定状态。

## 5. MUTEX-ERR-006：零等待和永久等待被错误换算

### 5.1 源码位置

- `_MutexObtain` 的 `msec` 是有符号 `int32`，见 [`mutex.c:77`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L77)。
- [`mutex.c:86`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L86) 直接调用 `CalculateTickFromTimeMs(msec)`。
- [`CalculateTickFromTimeMs`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c#L99) 的参数是无符号 `uint32`。
- [`tick.c:104-107`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c#L104) 将 0 tick 强制改成 1 tick。
- [`WAITING_FOREVER`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_base.h#L125) 定义为 `-1`。
- [`mutex.c:104`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L104) 的 `wait_time == 0` 分支因此无法处理输入 0。

### 5.2 零等待问题解释

`KMutexObtain(id, 0)` 经过换算后得到 1 tick。mutex 忙时，任务不会立即返回，而是加入等待队列、设置 1 tick delay、发生调度，然后由超时路径唤醒并返回 `-ETIMEOUT`。

当前配置为 1000 Hz，1 tick 名义上约为 1 ms。该行为会使非阻塞调用实际挂起，并增加调度和 delay 管理开销。

### 5.3 永久等待问题解释

`WAITING_FOREVER(-1)` 传给 `uint32 ms` 后变成 `0xffffffff`。当前换算表达式为：

```c
(uint64)(ms * TICK_PER_SECOND)
```

强制转换发生在乘法之后，因此在 1000 Hz 配置下先发生 32 位回绕：

```text
(0xffffffff * 1000) mod 2^32 = 4,294,966,296
4,294,966,296 / 1000          = 4,294,966 ticks
4,294,966 ticks               ≈ 71 分 35 秒
```

mutex 持续忙超过该时间后，声明为永久等待的调用会返回 `-ETIMEOUT`。仓库中已有文件系统锁、总线锁、SPI flash 锁和 lwIP mutex 适配层使用 `WAITING_FOREVER`。

`-2`、`-3` 等其他负数也没有被拒绝，会被转换成没有明确 API 语义的有限等待。

### 5.4 解决方式

在普通换算前处理特殊值：

```c
if (msec == WAITING_FOREVER) {
    wait_time = WAITING_FOREVER;
} else if (msec == 0) {
    wait_time = 0;
} else if (msec < 0) {
    return -EINVALED;
} else {
    wait_time = CalculateTickFromTimeMs((uint32)msec);
}
```

通用换算函数还应避免先做 32 位乘法：

```c
uint64 product = (uint64)ms * (uint64)TICK_PER_SECOND;
ticks = (product + 999U) / 1000U;
```

随后检查结果是否能放入 `x_ticks_t` 并满足 delay 算法的最大期限要求。`WAITING_FOREVER` 不应进入普通无符号毫秒换算。

### 5.5 验收条件

1. mutex 空闲且 `msec=0` 时立即成功。
2. mutex 忙且 `msec=0` 时立即返回 `-ETIMEOUT`，任务不进入 pending list，也不激活 delay。
3. `msec=WAITING_FOREVER` 时，超过原来的 4,294,966 tick 后仍不得超时。
4. `msec=-2` 时立即返回 `-EINVALED`，状态不变。
5. 大的有限正值不得在乘法中发生 32 位回绕。
6. 文件系统、总线、SPI flash 和 lwIP 的永久等待调用通过回归测试。

## 6. EVENT-ERR-002：Event 删除过程中仍允许新 waiter 加入

### 6.1 源码位置

[`_EventDelete`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c#L55) 先在第 62～64 行检查并清空 `pend_list`，随后才在第 67～70 行重新进入临界区并撤销 ID 和全局 Event 链表节点，最后在第 73 行释放 Event。

[`LinklistResumeAll`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c#L110) 在内部加锁并唤醒 waiter，但在第 129 行解锁后才返回。因此，从它返回到 `_EventDelete` 第 67 行重新加锁之间存在调度窗口。

[`_EventProcess`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c#L137) 在条件不满足时，于第 179～182 行记录等待条件并将任务的 `sched_link` 插入 `event->pend_list`，有限等待还会在第 184～185 行设置 delay。

在 `IdRemoveObj` 执行前，Event 仍处于 ID manager 中，新的 `KEventProcess` 仍可找到并进入该对象。

### 6.2 问题解释

#### 场景 A：删除开始时等待队列为空

```text
任务 D（删除者）                         任务 P（新 waiter）
----------------------------------------------------------------
D 检查 pend_list，结果为空
D 跳过 LinklistResumeAll

                 <任务切换>

                                       P 调用 KEventProcess
                                       Event 条件不满足
                                       P->sched_link 加入 pend_list
                                       P 进入 suspend

                 <切回 D>

D 移除 Event ID 和 registry node
D 执行 x_free(event)
```

D 不会再次检查等待队列，因此 P 被遗漏。

#### 场景 B：删除开始时已经存在 waiter

```text
D 调用 LinklistResumeAll，旧 waiter 全部被唤醒
LinklistResumeAll 解锁并返回
                 <任务切换>
P 通过 KEventProcess 加入仍然发布的 Event
                 <切回 D>
D 不再检查 pend_list，直接撤销发布并释放 Event
```

问题不在于 `LinklistResumeAll` 没有唤醒旧 waiter，而在于“清空旧 waiter”和“禁止新 waiter 进入”之间存在窗口。非 SMP 系统中，中断恢复和任务调度同样可以形成该执行顺序。

### 6.3 与 Mutex `MUTEX-ERR-002` 的关系

两者属于同一类跨对象生命周期错误，但引用方向相反：

```text
Mutex：Task 被释放，mutex->holder 仍指向该 Task。
Event：Event 被释放，waiter 的 sched_link 仍指向 event->pend_list。
```

Event 问题还会通过 intrusive 双向链表形成后续写入已释放内存的路径。

### 6.4 可能后果

#### Waiter 失联

Event 已从 ID manager 删除并释放，任务 P 不能再由该 Event 的正常 trigger/delete 路径唤醒。没有有效有限超时时，P 会长期保持 suspend。

#### 超时路径写入已释放内存

若 P 有有限超时，[`KTaskTimeout`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L407) 会执行：

```c
DoubleLinkListRmNode(&P->task_dync_sched_member.sched_link);
```

[`DoubleLinkListRmNode`](../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c#L71) 通过 `node_next` 和 `node_prev` 写入相邻节点。对于唯一 waiter，这些指针通常指向已经释放的 `event->pend_list`，从而形成 use-after-free write。

若该内存已经被新 Event 或其他对象复用，超时摘链可能破坏新对象字段或堆管理信息，表现为链表死循环、非法地址访问、后续 malloc/free 失败或不相关模块崩溃。

此外，`KEventDelete` 返回类型为 `void`，调用者无法得知是否存在被遗漏的 waiter。

### 6.5 根本原因

正确删除可等待对象需要按顺序完成：

```text
禁止新调用者进入
    -> 清理已有 waiter
    -> 确认等待队列为空
    -> 释放对象
```

当前实现却先清理当时能够看到的 waiter，再开放调度窗口，之后才撤销 Event 的 ID，导致新 waiter 可以在删除过程中加入。

### 6.6 解决方式

推荐在同一个外层 critical 中先撤销发布，再清空 waiter：

```text
进入外层 critical
    -> 从 ID manager 移除 Event
    -> 从 k_event_list 移除 Event
    -> 唤醒并摘除全部已有 waiter
    -> 确认 pend_list 为空
退出外层 critical
    -> x_free(event)
    -> 必要时调度
```

示意代码：

```c
static void _EventDelete(struct Event *event)
{
    int resched = 0;
    x_base lock = CriticalAreaLock();

    IdRemoveObj(&k_event_id_manager, event->id.id);
    DoubleLinkListRmNode(&event->link);

    if (!IsDoubleLinkListEmpty(&event->pend_list)) {
        resched = 1;
        LinklistResumeAll(&event->pend_list);
    }

    /* 调试构建中断言 pend_list 已为空。 */
    CriticalAreaUnLock(lock);

    x_free(event);
    if (resched)
        DO_KTASK_ASSIGN;
}
```

实现前需要核对 `LinklistResumeAll`、`KTaskWakeup` 等内部 nested critical 的保存值和返回路径，防止提前恢复中断。

其他方案包括：

- 增加受同一临界区保护的 `deleting` 标志，process 在插入等待队列前检查；
- 修改 API，使存在 waiter 时返回 `-EBUSY`。此时“检查为空”和“撤销发布”仍必须原子完成。

本文不纳入 Event 问题一。上述方案阻止删除开始后的新 ID 查询；对于删除前已经取得 Event 指针但尚未进入内部操作的调用者，由项目针对问题一采用的设计约束负责。

### 6.7 验收条件

1. 初始队列为空时，在删除检查后强制切换到 process，任务不得遗留在待释放 Event 上。
2. 初始队列非空时，删除后全部 waiter 以约定错误返回，`pend_list` 为空。
3. 清空最后一个旧 waiter 后强制执行新的 process，不得在已释放对象上留下节点。
4. 有限超时 waiter 在 Event 删除后推进 tick，不得向已释放地址写链表指针。
5. 删除 Event 后立即复用同尺寸内存，旧 waiter 的后续路径不得修改新对象。
6. 多 waiter 场景下，每个 `sched_link` 都已从 Event 队列摘除并进入正确的 ready 状态。
7. 高频 create/process/delete 配合堆 canary 或内存检查，不出现链表或堆损坏。
8. 所有路径结束后，critical nesting 和中断状态恢复到调用前值。
9. Event 释放前，`pend_list` 必须为空。

## 7. 建议修复顺序

1. `MUTEX-ERR-002`：可能造成悬空指针和永久锁死；
2. `EVENT-ERR-002`：可能造成释放后链表写入和 waiter 失联；
3. `MUTEX-ERR-006`：已有多个真实调用者依赖 `WAITING_FOREVER`；
4. `MUTEX-ERR-004`：固定最大递归深度和溢出返回值。

正式修改源码前需要确认：

1. 持锁任务退出时采用拒绝删除还是 robust mutex；
2. 递归计数溢出使用新错误码还是现有错误码；
3. Event 删除采用唤醒全部 waiter，还是存在 waiter 时返回 `-EBUSY`。

当前 Event 源码已经采用唤醒 waiter 的方向，因此优先建议保留该行为并修正删除步骤的原子性。

## 8. 本报告未做的修改

本文只汇总并解释源码错误，没有修改 `mutex.c`、`event.c`、`ktask.c`、`tick.c`、`linklist.c`、`double_link.c` 或相关公开 API。
