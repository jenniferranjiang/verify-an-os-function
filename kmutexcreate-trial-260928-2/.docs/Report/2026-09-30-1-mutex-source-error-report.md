# Mutex 源代码错误报告（任务生命周期、递归计数与等待时间）

状态：`source-review / open`

## 1. 报告范围

本文只整理能够从当前 C 源码直接说明的三个问题：

- `MUTEX-ERR-002`：持有 mutex 的任务被删除后，`holder` 变成无效引用；
- `MUTEX-ERR-004`：8 位递归计数回绕，可能过早释放 mutex；
- `MUTEX-ERR-006`：零等待和永久等待没有按参数语义执行。

按要求，本文明确不把 `MUTEX-ERR-001` 和 `MUTEX-ERR-005` 列为错误。本文也不讨论 predicate、STS、ownership、ABI 镜像或证明闭包等验证问题。

本报告以 `board/stm32f103-nano/config` 为复现配置；该配置的 `CONFIG_TICK_PER_SECOND=1000`。

## 2. 摘要

| ID | 直接问题 | 典型后果 | 建议优先级 |
|---|---|---|---|
| MUTEX-ERR-002 | 删除任务时不检查它是否仍是 mutex holder | 永久锁死、悬空指针、错误认主、非法内存访问 | 高 |
| MUTEX-ERR-004 | `recursive_cnt` 只有 8 位且递增无上限检查 | 超过 255 层后可能过早把锁交给别的任务 | 中；触发少见但后果严重 |
| MUTEX-ERR-006 | `0` 和 `WAITING_FOREVER(-1)` 都先进入无符号毫秒换算 | 非阻塞调用实际阻塞；永久等待约 71 分 35 秒后超时 | 高 |

---

## 3. MUTEX-ERR-002：删除持锁任务后遗留 `holder` 指针

### 3.1 错误位置

1. [`struct Mutex::holder`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h#L38) 直接保存 `TaskDescriptor *`，没有引用计数、任务代号或 owner-death 状态。
2. 首次取得 mutex 时，[`_MutexObtain`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L100) 把当前任务地址写入 `mutex->holder`。
3. 向等待者交接 mutex 时，[`_MutexAbandon`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L178) 再次把等待任务地址写入 `holder`。
4. [`_KTaskResourceDelete`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L98) 只把任务从 ready vector 移除并标为 close，没有检查或清理任何 mutex。
5. [`_DeleteKTask`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L643) 允许删除普通任务，也没有检查任务是否持锁。
6. zombie recycler 最终在 [`zombierecycle.c`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/zombierecycle.c#L64) 释放任务栈，并在第 74 行释放 `TaskDescriptor` 本身。
7. shell 命令 [`ShowMutex`](../../../Ubiquitous/XiZi_IIoT_Macro/tool/shell/letter-shell/cmd.c#L246) 会在 `holder != NONE` 时解引用 `holder->task_base_info.name`。

全树中，`holder` 的写入和清除只出现在 mutex 自身的 obtain/abandon 路径；任务删除路径没有反向通知 mutex。

### 3.2 人能直接理解的触发过程

假设任务 A 的描述符地址为 `0x1000`：

```text
1. A 取得 mutex M
   M->val    = 0
   M->holder = 0x1000

2. 任务 B 调用 KTaskDelete(A)
   A 被标记为 close，并放入 zombie 队列
   M->holder 仍然是 0x1000

3. zombie recycler 回收 A
   地址 0x1000 对应的 TaskDescriptor 已经被释放
   M->holder 仍然是 0x1000
```

从第 2 步开始，原 holder 已经不会继续运行，也就不可能正常调用 `KMutexAbandon`。从第 3 步开始，`M->holder` 还是一个非零地址，但这个地址已经不再代表存活的任务，这就是悬空指针。

任务主动退出的 [`KTaskQuit`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c#L569) 也走同样的资源删除和 zombie 回收方向，因此“任务自己持锁退出”同样需要处理。

### 3.3 会导致什么问题

#### 后果 A：mutex 永久保持占用

删除 A 后：

```text
M->val == 0
M->holder != NONE
```

其他任务取得 M 时只能进入等待队列。有限等待者最终超时；永久等待者会一直等待。由于 A 已经不能运行，没有正常路径把递归计数减到零并唤醒等待者。

这会表现为功能卡死、文件系统或设备访问线程不再前进，而不一定立刻崩溃，因此现场可能很难定位。

#### 后果 B：调试命令可能访问已释放内存

`ShowMutex` 会读取：

```c
mutex->holder->task_base_info.name
```

如果 holder 对应的 `TaskDescriptor` 已经被回收，这次读取属于 use-after-free。可能出现乱码任务名，也可能读到不可访问地址并触发异常。

#### 后果 C：地址复用后，新任务可能被误认为旧 holder

如果分配器后来把 `0x1000` 分给新任务 C，那么指针比较会出现：

```text
M->holder == C 的 TaskDescriptor 地址
```

此时 C 调用 `KMutexObtain(M, ...)`，源码第 95 行的 `mutex->holder == task` 可能错误成立。C 会被当作递归取得 mutex，而实际上它从未取得过 M。

C 调用 `KMutexAbandon(M)` 时也可能通过 holder 检查，进而修改计数、释放锁或把锁交给等待者。这属于错误的所有者识别。

### 3.4 根本原因

Task 和 Mutex 的生命周期是单向关联：Mutex 记住了 Task，但 Task 删除时不知道自己仍被哪些 Mutex 引用。源码没有规定或执行以下任何一种策略：

- 禁止删除仍持有 mutex 的任务；
- 延迟释放仍被 mutex 引用的任务；
- 自动释放任务持有的 mutex；
- 使用 robust mutex 的“owner died”状态通知下一位取得者。

### 3.5 可能的解决方式

#### 推荐方案：任务维护持有的 mutex 集合，并禁止带锁删除

给 `TaskDescriptor` 增加 `held_mutex_list` 或至少 `held_mutex_count`：

- mutex 从空闲变为持有时，把 mutex 登记到任务；
- 同一任务递归取得时只增加 mutex 的递归计数，不重复登记；
- 最后一层 abandon 时，从任务的持有集合移除 mutex；
- `_DeleteKTask` 在同一临界区内检查该集合，非空则返回明确错误，例如 `-EBUSY`；
- `KTaskQuit` 必须执行相同检查。由于它没有普通的错误返回路径，可以选择打印致命诊断并拒绝回收，或者把“任务不得持锁退出”变成明确的内核契约和断言。

这种方案不会在受保护数据可能处于半更新状态时悄悄把锁交给别人，语义最容易理解。

只遍历全局 `k_mutex_list` 查找 `holder == task` 也能作为改动较小的补丁，但删除成本为 O(mutex 数量)，而且所有任务退出入口都必须统一调用该检查。

#### 可选方案：实现 robust mutex

如果系统要求任务即使异常退出也必须继续运行，可在删除 holder 时：

- 将 mutex 标记为 `OWNER_DEAD`；
- 让下一位等待者取得 mutex；
- 向下一位持有者返回专门的 `owner-dead` 错误；
- 由调用者检查并修复受保护数据，再把 mutex 标记为一致。

这比“删除任务时直接把 `holder` 清零”安全。直接清零或无条件自动释放会让其他任务看到可能只更新了一半的共享数据。

### 3.6 验收测试

至少增加以下测试：

1. A 持有 M，B 删除 A：删除应被拒绝，A 和 M 的状态不变。
2. A 递归持有 M 多层，B 删除 A：同样应被拒绝。
3. A 持有多个 mutex，删除 A：不得漏检其中任何一个。
4. A 释放最后一层后再删除：删除应成功。
5. A 持锁执行 `KTaskQuit`：应触发定义好的拒绝或 owner-dead 行为，不能留下悬空 `holder`。
6. 删除失败后运行 `ShowMutex`：输出应正常，不能读取已释放任务。
7. 若采用 robust mutex，测试下一位持有者收到 owner-dead 状态，并完成一致性恢复。

修复完成的最低条件是：任何 `mutex->holder != NONE` 的稳定状态下，holder 必须对应尚未被回收的任务；任务描述符不得在仍被 mutex 引用时释放。

---

## 4. MUTEX-ERR-004：递归计数回绕会造成过早释放

### 4.1 错误位置

- [`recursive_cnt`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h#L36) 的类型是 `uint8`，取值范围只有 0～255。
- 同一 holder 再次 obtain 时，[`mutex.c:95-96`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L95) 直接执行 `mutex->recursive_cnt++`，没有上限检查。
- abandon 时，[`mutex.c:171-172`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L171) 先执行 `recursive_cnt--`，结果为 0 就释放或交接 mutex。

`uint8` 的加减会按模 256 回绕：255 加 1 变成 0，0 减 1 变成 255。

### 4.2 准确的触发过程

第一次取得后计数为 1。任务 A 总共取得同一个 mutex 257 次：

```text
取得总次数       recursive_cnt
1               1
255             255
256             0      // 发生回绕
257             1
```

此时 A 在逻辑上仍有 257 层持有，但内核只记录了 1。

随后 A 只调用一次 `KMutexAbandon`：

```text
recursive_cnt: 1 -> 0
```

源码看到结果为 0，就会在第 178～194 行释放 mutex，或者直接把 mutex 交给等待任务 B。然而 A 在逻辑上还有 256 层尚未释放。

需要特别说明：恰好取得 256 次后，计数显示为 0；第一次 abandon 会回绕到 255，并不会立即释放。真正明显的“过早释放”例子是 257 次取得后只释放一次。更一般地说，只要递归深度超过 255，内核就不能再正确表示剩余层数。

### 4.3 会导致什么问题

- 等待任务 B 可能过早进入临界区，与仍认为自己持锁的 A 同时操作共享数据。
- 受 mutex 保护的链表、缓冲区、设备状态或文件系统结构可能发生并发破坏。
- A 后续继续 abandon 时，可能得到“不是 holder”的错误；应用看到的 obtain/abandon 配对关系被破坏。
- `ShowMutex` 可能显示“holder 非空但递归计数为 0”，增加排障难度。

虽然 256 层递归在正常程序中少见，但一旦由递归函数、重复回调或错误重入触发，后果不是普通返回值错误，而是互斥保护失效。

### 4.4 可能的解决方式

#### 推荐方案：在递增前检查上限并返回溢出错误

在 `mutex->holder == task` 分支中执行：

```c
if (mutex->recursive_cnt == UINT8_SIZE_MAX) {
    CriticalAreaUnLock(lock);
    return -EOVERFLOW; /* 或项目约定的其他明确错误 */
}
mutex->recursive_cnt++;
```

当前错误码集合没有 `EOVERFLOW`。可以新增专用错误码；如果不扩展错误码，至少应选择并文档化一个不会被误解为超时的现有错误码。发生溢出时，mutex 的 holder、计数、value 和等待队列都必须保持不变。

不要采用“计数到 255 后继续饱和但仍返回成功”的办法，因为那仍会丢失真实递归层数，最终无法知道何时应该释放。

#### 备选方案：扩大计数类型

可以把 `recursive_cnt` 改为 `uint16` 或 `uint32`，但扩大类型只是推迟溢出，仍建议保留显式上限检查。同时要评估 `struct Mutex` 的布局变化和所有打印格式。

### 4.5 验收测试

若保留 `uint8` 并把最大合法深度定义为 255：

1. 前 255 次 obtain 全部成功，计数为 255。
2. 第 256 次 obtain 返回溢出错误，计数仍为 255，holder 不变。
3. 前 254 次 abandon 均不得释放或交接 mutex。
4. 第 255 次 abandon 才释放 mutex，或交给第一个等待者。
5. 在边界处加入等待任务，确认溢出失败不会意外唤醒等待者。
6. 重复执行边界测试，确认没有 `holder != NONE && recursive_cnt == 0` 的稳定状态。

---

## 5. MUTEX-ERR-006：零等待和永久等待被错误换算

### 5.1 错误位置

1. `_MutexObtain` 的参数 `msec` 是有符号 `int32`，见 [`mutex.c:77`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L77)。
2. 函数不区分 `0`、正数和 `WAITING_FOREVER`，直接在 [`mutex.c:86`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L86) 调用 `CalculateTickFromTimeMs(msec)`。
3. `CalculateTickFromTimeMs` 的参数却是无符号 `uint32`，见 [`tick.c:99`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c#L99)。
4. 换算函数在结果为 0 时强制改成 `MIN_TICKS(1)`，见 [`tick.c:104-107`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/tick.c#L104)。
5. `WAITING_FOREVER` 定义为 `-1`，见 [`xs_base.h:125`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_base.h#L125)。
6. `_MutexObtain` 原本有 `wait_time == 0` 的立即超时分支，见 [`mutex.c:104`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c#L104)，但经过上述换算后，0 已经被强制变成 1。

同一代码库里的 semaphore 已经在 [`semaphore.c:109-112`](../../../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c#L109) 对 `WAITING_FOREVER` 做了单独处理，说明 `-1` 的预期语义确实是不设置超时，而不是一个很大的毫秒数。

### 5.2 子问题 A：`msec == 0` 不是非阻塞取得

调用：

```c
KMutexObtain(id, 0);
```

经过换算：

```text
CalculateTickFromTimeMs(0) -> 1 tick
```

如果 mutex 正忙，源码不会进入 `wait_time == 0` 的立即返回分支，而是：

1. 把当前任务插入 mutex 等待队列；
2. 设置 1 tick 的 delay；
3. 触发调度；
4. 等超时处理把任务唤醒；
5. 最后返回 `-ETIMEOUT`。

在当前 1000 Hz 配置中，1 tick 名义上约为 1 ms；实际返回还受调度时机影响。对调用者来说，原本应当“不阻塞地尝试一次”的接口却真的挂起了当前任务。

这可能导致：

- 不能在不允许睡眠的路径中安全使用零等待；
- 循环轮询代码产生额外的调度和 delay 对象操作；
- 调用延迟明显高于预期；
- `wait_time == 0` 分支实际上成为死分支。

### 5.3 子问题 B：`WAITING_FOREVER` 变成有限等待

调用：

```c
KMutexObtain(id, WAITING_FOREVER); /* WAITING_FOREVER == -1 */
```

`-1` 传给 `uint32 ms` 后变成 `0xffffffff`，即 4,294,967,295。当前换算表达式又是：

```c
(uint64)(ms * TICK_PER_SECOND)
```

强制转换发生在乘法之后，所以 `ms * 1000` 先按 32 位无符号整数回绕：

```text
(0xffffffff * 1000) mod 2^32 = 4,294,966,296
4,294,966,296 / 1000          = 4,294,966 ticks
```

在 1000 Hz 下：

```text
4,294,966 ticks = 4,294.966 秒 ≈ 71 分 35 秒
```

因此，当 mutex 持续忙超过约 71 分 35 秒时，一个声称 `WAITING_FOREVER` 的调用会被 delay/timeout 路径唤醒并返回 `-ETIMEOUT`。

仓库中确实有多个调用者依赖永久等待，例如文件系统的 `mnt_list_lock`、`fdtable_lock`、`working_dir_lock`，总线锁、SPI flash 锁以及 lwIP mutex 适配层。因此这不是只有构造测试才能出现的参数。

### 5.4 子问题 C：其他负数没有明确拒绝

`msec` 是有符号类型，但除了约定的 `-1`，源码没有拒绝 `-2`、`-3` 等值。它们同样会转换成很大的 `uint32`，最后得到与调用者输入无直观关系的有限等待时间。

### 5.5 可能的解决方式

#### 推荐的 mutex 入口处理

在调用通用毫秒换算函数前，先处理 API 特殊值：

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

这样现有后续控制流就能表达三种情况：

- mutex 空闲时，无论 `msec` 是 0 还是其他合法值，都立即取得；
- mutex 忙且 `wait_time == 0` 时，立即返回 `-ETIMEOUT`，不挂入等待队列；
- `wait_time > 0` 时设置有限 delay；
- `wait_time == WAITING_FOREVER(-1)` 时挂入等待队列，但不设置 delay。

#### 同时修正通用换算函数

当前代码把强制转换写在乘法外面，无法防止 32 位乘法先溢出。应至少改为：

```c
uint64 product = (uint64)ms * (uint64)TICK_PER_SECOND;
```

对于正的有限等待，通常还应采用向上取整，避免实际等待短于请求时间：

```c
ticks = (product + 999U) / 1000U;
```

随后检查结果是否能安全放入 `x_ticks_t`，并考虑 delay 比较算法只适合小于半个 tick 环的期限。特殊值 `WAITING_FOREVER` 不应进入这个通用无符号换算函数。

### 5.6 验收测试

1. mutex 空闲，`msec=0`：立即成功。
2. mutex 忙，`msec=0`：立即返回 `-ETIMEOUT`；任务不进入 pending list，也不创建或激活 delay。
3. mutex 忙，`msec=1`：在当前 1000 Hz 配置下按有限等待处理。
4. mutex 忙，`msec=WAITING_FOREVER`：等待时间超过原来的 4,294,966 tick 后仍不得超时；只能由 mutex 释放、删除或明确取消来唤醒。
5. `msec=-2`：立即返回 `-EINVALED`，不改变 mutex 和任务状态。
6. 测试有限正值的换算边界及大值溢出，确认实际等待不会早于接口承诺。
7. 对现有文件系统、总线、SPI flash 和 lwIP 的永久等待调用做长时间或加速 tick 回归测试。

---

## 6. 建议修复顺序

1. 先修复 `MUTEX-ERR-002`。它涉及任务对象释放后的悬空引用，并可能让锁永久不可用。
2. 再修复 `MUTEX-ERR-006`。仓库已有多个真实的 `WAITING_FOREVER` 调用者，修改点也相对集中。
3. 最后修复 `MUTEX-ERR-004`，并用边界测试固定最大递归深度和溢出返回值。

三项修复都应在同一个临界区策略下保持以下基本状态关系：

```text
空闲：  val == 1, holder == NONE, recursive_cnt == 0
持有：  val == 0, holder 指向存活任务, recursive_cnt >= 1
```

任何失败返回都不应部分修改 holder、计数、pending list 或任务 delay 状态。

## 7. 本报告未做的修改

本文只报告和解释问题，没有修改 mutex、task、tick 或 delay 的 C 实现。具体补丁需要先确定两项 API 政策：

1. 持锁任务退出时采用“拒绝删除”还是 robust mutex 的 owner-dead 语义；
2. 递归计数溢出使用新错误码还是复用现有错误码。
