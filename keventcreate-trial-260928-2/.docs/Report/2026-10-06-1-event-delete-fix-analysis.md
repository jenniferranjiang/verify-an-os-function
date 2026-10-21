# Event 删除窗口修复分析

状态：`candidate-fix-not-implemented`

## 1. 本轮决定

问题 1 不再作为源码修复 blocker。本轮采用用户在 2026-10-06 明确批准的环境假设：

> `FindEventById` 成功返回后，直到对应 `_EventDelete`、`_EventTrigger` 或 `_EventProcess` 取得其第一次 event critical 之前，同一个 event 不会被其他执行流删除或重新分配。

这是验证环境假设，不是当前 C 实现能够自行保证的性质。后续 predicate/spec 必须显式记录它，不能把它描述成已经由 `FindEventById` 或 ID manager 证明的事实。

问题 2 仍按源码问题处理：`_EventDelete` 必须防止“清空 waiter 后、摘除 event 前”重新加入 waiter。

## 2. 推荐的最小修复

把 `_EventDelete` 已有的 outer critical 从 `IdRemoveObj` 前移动到第一次读取 `event->pend_list` 前，并保持到 ID manager 与 `k_event_list` 都完成摘除：

```c
static void _EventDelete(struct Event *event)
{
    int resched = 0;
    x_base lock = 0;

    NULL_PARAM_CHECK(event);

    lock = CriticalAreaLock();

    if (!IsDoubleLinkListEmpty(&event->pend_list)) {
        resched = 1;
        LinklistResumeAll(&event->pend_list);
    }

    IdRemoveObj(&k_event_id_manager, event->id.id);
    DoubleLinkListRmNode(&event->link);

    CriticalAreaUnLock(lock);

    x_free(event);

    if (resched)
        DO_KTASK_ASSIGN;
}
```

相对当前实现只有一个关键变化：原来的 `lock = CriticalAreaLock()` 位于 `LinklistResumeAll` 之后；候选修复把它提前，并删除后面的重复加锁。

## 3. 为什么这个修复能关闭问题 2

进入 outer critical 后，当前单核执行不能被普通 IRQ 调度切走。删除路径按以下顺序原子推进：

```text
锁住 event 共享状态
  -> 检查并清空 pend_list
  -> 从 ID manager 摘除
  -> 从 k_event_list 摘除
  -> 解锁
  -> 释放已经不再 published 的对象
  -> 必要时调度被唤醒任务
```

因此，在 `LinklistResumeAll` 清空 waiter 后到 `IdRemoveObj` 完成之间，不会有另一个任务运行 `KEventProcess` 并把新 waiter 插入该 event。解锁后，新的 ID 查询已经找不到该 event。

`x_free(event)` 保持在 outer unlock 之后，避免无必要地把 allocator 工作放进较长的 event critical。它依赖第 1 节批准的问题 1 假设：不存在已经取得该指针、但尚未进入 event critical 的并发调用者。

## 4. Nested critical 检查

候选修复会让下面的调用在 outer event critical 内执行：

- `LinklistResumeAll`
- `KTaskWakeup`
- `GetTaskWithIdnodeInfo`
- `_KTaskWakeup`
- `KTaskUnSetDelay`
- ready-vector 插入及 DLL 操作

当前非 SMP `CriticalAreaLock` 先保存 PRIMASK，再禁中断并递增 `KTaskOsAssignLockNest`；unlock 递减计数并恢复本层保存的 PRIMASK。outer critical 已经把 PRIMASK 置为 1，因此所有内层 lock 保存的也是 1，内层 unlock 仍恢复为 1，不会提前开放中断。只有最外层 unlock 恢复进入删除前的值。

源码依据：

- `kernel/thread/CriticalArea.c:98-138`
- `kernel/thread/linklist.c:110-131`
- `kernel/thread/ktask.c:64-81, 488-515, 1066-1075`

当前配置未启用 `KERNEL_HOOK`，唤醒路径中的 hook 不增加新的可调度调用；`KTaskWakeup` 本身也不执行 `DO_KTASK_ASSIGN`。实际任务切换仍由 `_EventDelete` 末尾的 `DO_KTASK_ASSIGN` 发起。

嵌套深度远低于 `uint16 KTaskOsAssignLockNest` 的上限，但后续 predicate 仍应记录“进入路径具有足够 nesting capacity”的条件，而不能忽略计数回绕。

## 5. 可复用的源码先例

`kernel/thread/semaphore.c:64-97` 的 `_SemaphoreDelete` 已采用同一结构：

- 先进入 outer critical；
- 在锁内查询对象并清空 waiter；
- 在同一 outer critical 中移除 ID 与 registry node；
- 解锁后 free；
- 最后按需调度。

Event 的最小修复可以沿用这个经过项目自身使用的临界区边界，但 Event 的 bitfield、trigger/process 语义仍需独立建模，不能直接复制 semaphore predicate。

## 6. 仍需检查的失败条件

`LinklistResumeAll` 只有在 `KTaskWakeup` 每轮都成功移除当前 pend node 时才会推进。后续 predicate/spec 必须保证 pend list 中的每个 task：

- 仍然注册在 task ID manager 中；
- 状态为可唤醒的 suspend；
- `sched_link` 当前唯一属于该 event 的 pend list；
- 唤醒后该 link 转移到 ready queue，而不是同时属于两个容器。

如果这些条件不能从 `LinklistSuspend`、task lifecycle 和删除约束建立，循环可能不推进；不能仅凭函数名假定 `LinklistResumeAll` 一定清空链表。

此外，event 创建时 `options` 会被截断为 3 bit，而 `LinklistSuspend` 只接受 FIFO=0 或 PRIO=1。`options` 为 2..7 时，process 路径会先 suspend task、再从 switch default 返回 `-EINVALED`，而调用者忽略返回值。这个异常路径与问题 2 不同，后续 whole-module predicate review 仍必须单独处理。

## 7. 修复验收条件

源码修改后，至少执行以下检查：

1. `_EventDelete` 在第一次读取 `event->pend_list` 前取得 outer critical。
2. `LinklistResumeAll`、`IdRemoveObj` 和 `DoubleLinkListRmNode` 都在同一个 outer critical 生命周期内。
3. 每条返回路径恰好释放一次 outer critical；没有新增 early return 泄漏锁。
4. 内层 critical 均恢复 PRIMASK=1，outer unlock 才恢复原始 handler。
5. `IdRemoveObj` 完成后，新调用不能再通过 ID 找到该 event。
6. free 前 pend list 为空，所有 waiter sched-link 已转移给 ready/task owner。
7. `x_free` 和 `DO_KTASK_ASSIGN` 保持在 outer unlock 之后。
8. 重新做 whole-module C scan 后，问题 2 可标记为 fixed；问题 1 仍标记为 user-approved assumption，而不是 source-fixed。

## 8. 对验证流程的影响

目前只完成修复设计，没有修改 `event.c`，所以问题 2 仍是 open blocker，predicate 仍不能进入 review-ready。

若用户授权实施上述 C 修改，下一步应先固定新的 source revision，重做受影响的 `_EventDelete`、`LinklistResumeAll`、`KTaskWakeup` dependency closure 检查；随后才能恢复 Event predicate 设计。此次源码修复不会授权进入 QCP symbolic、VC 或 proof。
