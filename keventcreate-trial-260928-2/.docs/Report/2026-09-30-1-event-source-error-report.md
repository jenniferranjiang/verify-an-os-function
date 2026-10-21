# Event 源代码错误报告：删除窗口中可重新加入等待任务

状态：`source-review / open`

## 1. 报告范围

本文只报告现有 Event 报告中的“问题二”：`_EventDelete` 清理等待队列和撤销发布 Event 不是一个不可分割的过程，因此删除途中仍可能有新任务加入 `event->pend_list`。

按要求，原报告的“问题一：通过 ID 查询后返回裸指针”不在本文中列为错误，也不作为本文结论。本文只讨论 C 源码行为，不讨论 predicate、STS、ownership 或证明闭包。

本问题编号记为 `EVENT-ERR-002`。

## 2. 一句话结论

`_EventDelete` 先唤醒当前 waiter，离开临界区后才撤销 Event 的 ID 并释放对象；在这个窗口里，另一个任务仍能找到该 Event 并把自己挂入等待队列。删除任务不会再次清理它，随后直接释放 Event，造成等待任务失联，并使任务链表节点指向已释放内存。

## 3. 与 Mutex `MUTEX-ERR-002` 的关系

两者属于同一类“两个内核对象存在引用关系，但删除其中一个对象时没有完整收尾”的生命周期错误，但引用方向相反：

| 问题 | 被删除对象 | 删除后遗留的引用 |
|---|---|---|
| Mutex `MUTEX-ERR-002` | Task | `mutex->holder` 仍指向已删除 Task |
| Event `EVENT-ERR-002` | Event | waiter 的 `sched_link` 仍连接到已删除 Event 的 `pend_list` |

所以它们的共同点是“删除后留下跨对象的失效关系”；具体出错代码和修复位置并不相同。

## 4. 错误位置

### 4.1 Event 删除路径

[`_EventDelete`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c#L55) 的关键顺序是：

```c
if (!IsDoubleLinkListEmpty(&event->pend_list)) {
    resched = 1;
    LinklistResumeAll(&event->pend_list);
}

lock = CriticalAreaLock();
IdRemoveObj(&k_event_id_manager, event->id.id);
DoubleLinkListRmNode(&event->link);
CriticalAreaUnLock(lock);

x_free(event);
```

具体位置：

- 第 62 行：在外层没有持有临界区时检查 `pend_list`；
- 第 64 行：调用 `LinklistResumeAll`；
- 第 67 行：`LinklistResumeAll` 返回后，才重新进入删除临界区；
- 第 68～70 行：撤销 ID 和全局 Event 链表节点；
- 第 73 行：释放 Event。

### 4.2 `LinklistResumeAll` 返回前已经解锁

[`LinklistResumeAll`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c#L110) 在内部进入临界区，逐个调用 `KTaskWakeup`，然后在第 129 行解锁并返回。

因此，它只能保证“本次遍历和唤醒”期间等待队列不被当前 CPU 上的其他任务修改，不能保证返回后到 `_EventDelete` 第 67 行再次加锁之间没有任务切换。

### 4.3 新 waiter 的加入位置

[`_EventProcess`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c#L137) 在事件条件不满足且需要等待时：

- 第 179～180 行把等待条件记录到当前任务；
- 第 182 行通过 `LinklistSuspend` 把任务的 `sched_link` 插入 `event->pend_list`；
- 第 184～185 行对有限等待设置 delay；
- 第 187～189 行退出临界区并调度其他任务。

在 `_EventDelete` 真正执行 `IdRemoveObj` 前，该 Event 仍然处于 ID manager 中，新的 `KEventProcess` 仍可以找到它。

## 5. 两种可复现的竞争过程

### 5.1 场景 A：删除开始时等待队列为空

这是最短的触发过程：

```text
任务 D（删除者）                         任务 P（新 waiter）
----------------------------------------------------------------
检查 event->pend_list，结果为空
因此跳过 LinklistResumeAll

                 <发生中断或任务切换>

                                       KEventProcess(id, ...)
                                       Event 条件不满足
                                       将 P->sched_link
                                       插入 event->pend_list
                                       P 进入 suspend

                 <切回任务 D>

进入临界区
从 ID manager 移除 Event
从 k_event_list 移除 Event
退出临界区
x_free(event)
```

D 在最初看到空队列后不会再次检查，所以 P 不会被 `LinklistResumeAll` 唤醒。

### 5.2 场景 B：删除开始时已经有 waiter

```text
任务 D                                 任务 P
----------------------------------------------------------------
发现 pend_list 非空
LinklistResumeAll 唤醒当前全部 waiter
LinklistResumeAll 解锁并返回

                 <发生中断或任务切换>

                                       KEventProcess(id, ...)
                                       Event 仍可通过 ID 查到
                                       条件不满足
                                       P 加入 pend_list 并挂起

                 <切回任务 D>

D 不再检查 pend_list
移除 ID 和 registry node
x_free(event)
```

已有 waiter 被正确唤醒并不能解决问题，因为“唤醒完成”和“禁止新 waiter”之间没有原子边界。

## 6. 为什么单核系统也会发生

这里不要求两个 CPU 真正同时执行。当前非 SMP Cortex-M3 配置中，`LinklistResumeAll` 返回时已经调用 `CriticalAreaUnLock`。中断恢复后，tick、中断退出调度或其他调度点都可能让另一个任务先运行。

只要执行顺序能够在两个临界区之间交错，就会产生这个错误：

```text
清空旧 waiter
    ↓ 临界区已经结束，可发生任务切换
新 waiter 加入
    ↓
删除者重新加锁并释放 Event
```

所以这不是 SMP 才有的错误。

## 7. 删除后留下了什么坏状态

假设 P 是删除窗口中新加入的唯一 waiter。它的链表节点是：

```c
P->task_dync_sched_member.sched_link
```

作为唯一节点插入 Event 等待队列后，其两个链表指针通常都指向：

```c
&event->pend_list
```

删除者随后执行 `x_free(event)`。P 自身还活着，但 P 的 `sched_link.node_prev` 和 `node_next` 指向的 Event 内存已经被释放。

此时系统同时存在两个错误状态：

1. P 仍处于 suspend 状态，却已经没有一个存活的 Event 能正常遍历并唤醒它；
2. P 的 intrusive list 节点仍保存指向已释放 Event 链表头的地址。

## 8. 会导致什么问题

### 8.1 无限等待或无法由 Event 唤醒

Event 已从 ID manager 删除，其他任务不能再通过原 ID trigger 它；Event 对象本身也已释放。因此 P 不可能再由这个 Event 的正常 trigger/delete 路径唤醒。

如果 P 没有有效的有限超时，它会永久保持 suspend，表现为某个业务线程突然停止运行。

### 8.2 超时时写入已释放内存

如果 P 设置了有限超时，超时路径 [`KTaskTimeout`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L407) 会在第 420 行执行：

```c
DoubleLinkListRmNode(&P->task_dync_sched_member.sched_link);
```

[`DoubleLinkListRmNode`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c#L71) 会通过该节点的 `node_next` 和 `node_prev` 写回相邻节点：

```c
linklist_node->node_next->node_prev = linklist_node->node_prev;
linklist_node->node_prev->node_next = linklist_node->node_next;
```

这些相邻地址可能正是已经释放的 `event->pend_list`。结果是向已释放堆内存写数据，属于 use-after-free write。

### 8.3 破坏后来复用这块内存的新对象

`x_free(event)` 后，分配器可能把同一地址分给另一个 Event 或完全不同的对象。如果 P 随后超时并执行链表摘除，可能覆盖新对象中的字段或分配器管理信息。

可能表现为：

- 新 Event 的等待队列突然损坏；
- 后续链表遍历死循环或访问非法地址；
- 堆结构被破坏，错误在更晚的一次 malloc/free 才暴露；
- 不相关模块随机崩溃。

### 8.4 删除返回并不代表关联任务已经清理干净

`KEventDelete` 的返回类型是 `void`。调用者无法获知删除过程中是否有任务遗漏在等待队列，也没有错误码提示“对象仍被使用”。表面上删除已经成功，实际系统中却留下了一个无法正常归属的 suspend task。

## 9. 根本原因

删除一个可等待对象至少包含以下三个逻辑步骤：

```text
1. 禁止新的调用者找到或进入该对象
2. 清理并唤醒已经存在的 waiter
3. 释放对象
```

当前 Event 实现采用的顺序是：

```text
1. 清理当时看见的 waiter
2. 开放一个可调度窗口
3. 才禁止通过 ID 找到 Event
4. 释放对象
```

关键错误不是 `LinklistResumeAll` 没有工作，而是删除流程没有先“关门”，也没有让“关门”和“清空屋内的人”处在同一个外层临界区中。

## 10. 可能的解决方式

### 10.1 推荐方案：先撤销发布，再在同一外层临界区清空 waiter

删除流程应在一个外层 critical 中完成以下状态变化：

```text
进入外层 critical
    ↓
从 ID manager 移除 Event，阻止新的 ID 查询
    ↓
从 k_event_list 移除 Event
    ↓
唤醒并摘除全部已有 waiter
    ↓
确认 pend_list 为空
    ↓
退出外层 critical
    ↓
释放 Event
    ↓
必要时调度
```

示意代码如下，具体补丁仍需按项目的 nested critical 约定调整：

```c
static void _EventDelete(struct Event *event)
{
    int resched = 0;
    x_base lock;

    lock = CriticalAreaLock();

    IdRemoveObj(&k_event_id_manager, event->id.id);
    DoubleLinkListRmNode(&event->link);

    if (!IsDoubleLinkListEmpty(&event->pend_list)) {
        resched = 1;
        LinklistResumeAll(&event->pend_list);
    }

    /* 调试构建中应断言 pend_list 已为空。 */
    CriticalAreaUnLock(lock);

    x_free(event);

    if (resched)
        DO_KTASK_ASSIGN;
}
```

这里最重要的不是代码排版，而是两个约束：

- Event 一旦开始删除，新的 ID 查询必须先被阻止；
- 从禁止新进入到确认 waiter 全部移除之间，不能重新开放任务切换窗口。

当前非 SMP critical 支持嵌套计数，因此外层持锁时调用内部也会加锁的 `LinklistResumeAll/KTaskWakeup` 在设计上有基础，但实现前仍应逐条核对每个 nested lock 保存值和返回路径，避免提前恢复中断。

### 10.2 可选方案：增加 `deleting` 状态

可以给 Event 增加 `deleting` 标志：

- delete 在临界区内先置 `deleting=1`；
- process 在准备加入 `pend_list` 前，在同一临界区检查该标志；
- 若正在删除，则返回明确错误，不得 suspend；
- delete 清空 waiter 后再撤销发布并释放。

仅增加标志但仍在不同临界区读写是不够的；检查标志和插入等待队列必须原子化。

### 10.3 可选方案：删除时发现 waiter 就返回 busy

如果产品不要求删除操作自动唤醒 waiter，可以修改 API：

- 在临界区内发现 `pend_list` 非空时返回 `-EBUSY`；
- 只有队列为空时才撤销发布并释放；
- `KEventDelete` 需要从 `void` 改为可返回错误的类型，调用者必须处理失败。

该方案语义更保守，但仍必须把“检查为空”和“撤销发布”放在同一个临界区，否则检查后仍可加入新 waiter。

## 11. 关于已排除的问题一

本文按要求不把“ID 查询返回后到内部操作开始前的裸指针窗口”列为错误，也不据此否定 Event API。

但修复 `EVENT-ERR-002` 时需要明确一个工程边界：上面的“先撤销发布”方案阻止的是删除开始后的新 ID 查询；对于删除前已经取得指针、但尚未进入内部操作的调用者，应由项目对问题一所采用的设计约束负责。本文不重复评价该约束。

## 12. 验收测试

至少增加以下可控交错测试：

1. **初始队列为空**：让删除者完成空队列检查后暂停，再让另一任务尝试 process。修复后，process 应当在 Event 已撤销发布后失败，不能进入 pending list。
2. **初始队列非空**：删除时先准备多个 waiter。删除完成后所有 waiter 都应以约定错误被唤醒，`pend_list` 必须为空。
3. **清空后的再加入竞争**：在最后一个旧 waiter 被唤醒后强制调度另一个 process 任务。它只能在“删除前成功加入并随后被本次删除唤醒”或“撤销发布后直接失败”两种结果中出现，不能遗留在已释放对象上。
4. **有限超时 waiter**：删除完成后推进 tick，不能发生对已释放 Event 地址的链表写入。
5. **内存复用**：删除 Event 后立即分配并填充同尺寸对象，再推进旧 waiter 的超时路径；新对象内容不得被修改。
6. **多 waiter**：FIFO/PRIO 顺序下均确认每个 task 的 `sched_link` 已从 Event 队列摘除，并进入正确的 ready 状态。
7. **重复创建与删除**：高频循环 create/process/delete，配合堆 canary 或内存检查，确认无链表损坏。
8. **临界区平衡**：所有空队列、非空队列和错误路径结束后，critical nesting 与中断状态必须恢复到调用前值。

## 13. 修复完成条件

满足以下全部条件后，`EVENT-ERR-002` 才可关闭：

- delete 开始禁止新进入后，不再有任务能够加入该 Event 的 `pend_list`；
- Event 被释放前，`pend_list` 必须为空；
- 每个原 waiter 的 `sched_link` 都已从 Event 队列摘除并交回调度器；
- 有限超时路径不会通过 task 节点访问已释放的 Event 内存；
- 删除后的相同 ID 或复用地址不会与旧 waiter 产生关联；
- 修复在当前非 SMP 配置下通过上述交错测试，并对 SMP 构建另行确认跨 CPU 的同步方式。

## 14. 本报告未做的修改

本文只新增源码错误报告，没有修改 `event.c`、`linklist.c`、`ktask.c` 或 Event API。正式修改前需要确认删除语义采用哪一种：

1. 删除时唤醒所有 waiter，并让它们返回统一错误；或
2. 存在 waiter 时拒绝删除并返回 `-EBUSY`。

当前源码更接近方案 1，因此报告把“先撤销发布并在同一外层 critical 中唤醒全部 waiter”作为推荐方向。
