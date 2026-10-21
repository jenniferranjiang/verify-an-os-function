# Event 模块并发删除错误报告

> 2026-10-06 更新：问题 1 已按用户决定改为显式环境假设；问题 2 的推荐修复与验收条件见 [Event 删除窗口修复分析](./2026-10-06-1-event-delete-fix-analysis.md)。下文保留最初发现问题时的证据。

## 一句话结论

Event 模块目前存在对象生命周期竞争：一个任务刚通过 ID 找到 event，另一个任务就可能把这个 event 删除并释放；前一个任务恢复运行后仍会继续访问原指针，形成 use-after-free。

这个问题不是证明脚本写不出来，而是当前 C 代码本身没有保证指针在使用期间仍然有效。因此，在源码修复前，不能把 event 模块的 ownership 和生命周期谓词审阅为通过。

## 影响范围

受影响的公开接口包括：

- `KEventDelete`
- `KEventTrigger`
- `KEventProcess`

`KEventCreate` 自身没有经过 `FindEventById`，目前没有在它的创建路径上发现同样的悬空指针问题。但本次验证流程要求先为整个 event 模块建立闭合的 predicate；模块中其他接口的生命周期缺口会破坏全局 event invariant，所以仍然阻塞 `KEventCreate` 的后续 spec 审阅。

## 问题一：查到对象后过早解锁

`FindEventById` 在临界区内查询 ID manager，得到 `struct Event *` 后先解锁，再把指针返回：

- 查询和解锁：`kernel/thread/event.c:220-228`
- 返回裸指针：`kernel/thread/event.c:230`
- wrapper 随后才使用它：`kernel/thread/event.c:258-263, 277-282, 299-301`

可以出现下面的执行顺序：

1. 任务 A 调用 `KEventTrigger(id)`。
2. A 在 `FindEventById` 中找到 event 指针。
3. `FindEventById` 恢复中断并返回指针。
4. A 在真正调用 `_EventTrigger(event, ...)` 前被中断抢占。
5. 任务 B 调用 `KEventDelete(id)`，从 ID manager 和 event 链表中移除对象，然后执行 `x_free(event)`。
6. A 恢复运行，把已经释放的地址传给 `_EventTrigger` 并访问 `event->events`、`event->pend_list` 等字段。

此时访问的是已释放内存。根据内存是否已被重新分配，结果可能是数据破坏、错误唤醒任务、链表损坏或不可预测崩溃。

这不是只存在于理论上的“多核并发”。当前选择的非 SMP Cortex-M3 配置也允许发生：`CriticalAreaUnLock` 会恢复 PRIMASK；中断退出路径会调用调度器，并可通过 PendSV 切换到另一个任务。

相关证据：

- `kernel/thread/CriticalArea.c:132-138`
- `arch/arm/cortex-m3/interrupt.c:25-35, 48-59`
- `kernel/thread/assign.c:115-196`
- `arch/arm/shared/arm32_switch.c:22-65`
- `arch/arm/shared/pendsv.S:40-115`

## 问题二：删除过程中允许重新加入 waiter

`_EventDelete` 先检查并唤醒所有等待任务：

- `kernel/thread/event.c:62-65`

`LinklistResumeAll` 自己进入临界区，但返回前已经解锁：

- `kernel/thread/linklist.c:110-131`

随后 `_EventDelete` 才再次进入临界区，移除 ID 和 event 链表节点：

- `kernel/thread/event.c:67-73`

这两个临界区之间存在窗口。另一个任务可能在这个窗口中通过 `KEventProcess` 找到仍然处于 ID manager 中的 event，并再次把自己挂入 `event->pend_list`。删除任务之后不会再次检查 pend list，而是直接移除并释放 event。

结果是新 waiter 的调度链表节点仍指向已经释放的 event 链表头。该任务可能永久无法被唤醒，后续链表操作也可能访问释放后的内存。

## 根本原因

当前代码只用临界区保护了单次查询或单次链表修改，没有保护完整的对象生命周期：

```text
通过 ID 取得对象
    -> 持续使用对象
    -> 停止发布对象
    -> 清理 waiter
    -> 释放对象
```

只要 event 仍可能被其他任务删除，“查询到指针”就不等于“获得了可以安全使用的对象”。当前实现中没有引用计数、borrow token、删除中状态或覆盖整个操作的外层锁。

## 建议修复

优先建议采用同一个外层 critical 保护 event 的查询和整个操作：

1. public API 先进入 critical。
2. 在 critical 内按 ID 查找 event。
3. 找不到时直接退出 critical 并返回。
4. 找到后，在同一个外层 critical 尚未释放时完成 trigger/process/delete 中所有会使用该 event 的步骤。
5. delete 必须先阻止新的查询和 waiter，再清空 waiter、移除 ID/registry，最后释放对象。
6. 只有不再访问 event 后才能退出生命周期保护。

现有 helper 内部会再次调用 `CriticalAreaLock`，因此修复时必须系统检查 nested critical 的保存值和退出次序，不能只在 wrapper 外简单加一对 lock/unlock 就结束。尤其需要确认：

- `LinklistResumeAll`
- `LinklistSuspend`
- `KTaskWakeup`
- `IdRemoveObj`
- `x_free`

如果不希望长时间持有 critical，也可以实现引用计数：查询成功时增加引用，使用结束后释放引用；delete 先把对象从 ID manager 中隐藏，再等待引用归零后释放。但这种方案改动和证明成本更高。

## 修复验收条件

修复完成后应满足：

- 从 ID 查询成功到最后一次 event 字段访问之间，对象不会被释放。
- delete 开始后，新的查询不能取得该对象，新的 waiter 也不能再加入。
- free 前 `pend_list` 已为空，所有 waiter 的 sched-link ownership 已交还 task/scheduler。
- 所有成功和失败路径都会正确释放 critical 或引用。
- nested critical 的计数和 PRIMASK 恢复值在每条返回路径上匹配。
- 重新检查 `KEventDelete`、`KEventTrigger`、`KEventProcess` 的所有任务切换点后，不再存在裸 `Event *` 跨越生命周期保护。

## 当前验证状态

- 权威输入 revision：`source-s1-830483391cb0`
- Predicate：尚未达到 `review-ready`
- Spec：尚未开始审阅
- 未运行 QCP symbolic、VC 生成或 proof
- 没有通过增加“调用期间无人删除 event”等无源码依据的前置条件规避错误

另有一个独立的配置确认项：仓库根目前没有激活的 `.config/xsconfig.h`。继续验证前，需要明确采用 `board/stm32f103-nano/config`，或提供实际构建所用配置。
