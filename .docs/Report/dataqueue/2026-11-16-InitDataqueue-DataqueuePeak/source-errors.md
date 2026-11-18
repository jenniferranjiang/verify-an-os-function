# crtoslatest 当前源码错误报告

本报告只保留当前源码仍存在的问题。源码根为 `/home/xinra/crtoslatest`，版本 `a07641a0b58469ae3ea19317cce2cf48974989bb`；对象为 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c`，SHA-256 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`。验证采用当前工程的ILP32、非SMP配置。原源码只读，以下修复和适配位于验证工程副本。

| 编号 | 仍存在的问题 | 验证副本状态 |
| --- | --- | --- |
| DQ-01 | Init/DeInit混淆有效ID0、未创建状态和负错误码 | 已获批准并修复，原源码缺陷仍存在 |
| DQ-02 | Push/Pop的有限timeout跳过Obtain | 修复方案已批准并检查；分析副本已按用户要求删除，原源码缺陷仍存在 |
| DQ-03 | Push/Pop无限等待分支忽略Obtain失败 | 同DQ-02 |
| DQ-04 | Peak的非空检查和队首读取不在同一临界区 | 已按源码处理规则适配，原源码问题仍存在 |

## DQ-01：Semaphore ID判断错误

源码位置：[InitDataqueue与DeInitDataqueue](/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c)，第43–59、94–101行。

Create以非负ID表示成功，0也是有效值；失败返回负错误码。原Init却使用 `if (!id)`：合法ID0被判成失败，-5等负数反而继续初始化。原DeInit的 `if (id)`又会跳过有效ID0，造成已创建对象未删除。memset留下的0还无法区分“尚未创建”和“持有ID0”。

原代码关键部分：

```c
memset(p_queue, 0, sizeof(DataQueueType));
p_queue->sem_blank = KSemaphoreCreate(p_queue->max_len - 1);
if (!p_queue->sem_blank) { break; }
/* sem_data同样使用 !id。 */

if (p_queue->sem_blank) {
    KSemaphoreDelete(p_queue->sem_blank);
    p_queue->sem_blank = NONE;
}
```

验证副本改为：

```c
memset(p_queue, 0, sizeof(DataQueueType));
p_queue->sem_blank = -1;
p_queue->sem_data = -1;
/* 每次Create后以 < 0 检查失败。 */
if (p_queue->sem_blank < 0) { break; }

if (p_queue->sem_blank >= 0) {
    KSemaphoreDelete(p_queue->sem_blank);
    p_queue->sem_blank = -1;
}
```

两处必须一起改：只把DeInit改成>=0，而未创建字段仍为0，会错误删除并非本次取得的ID0。副本保留已经为负的创建错误码，回滚后可能是(-1,-1)、(-5,-1)、(-1,-5)，并非统一重置成(-1,-1)。

状态：**验证副本已修复，原源码缺陷仍存在。** 当前文件：[InitDataqueue.c](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c)、[DeInitDataqueue.c](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c)。已有针对性检查覆盖ID0在两位置成功、分配/两次创建失败及重复清理；本轮继续核对新源码差异与这些批准修复的对应关系。

## DQ-02：有限timeout没有取得semaphore

源码位置：[PushDataqueue与PopDataqueue](/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c)，第125–138、172–187行。

原do-while只处理timeout=-1和0。输入17等正值时，两个分支都不进入，完全跳过Obtain，却继续执行ring和Abandon。例如容量2的空队列调用Pop(...,17)：不取到元素、不写输出，却释放blank并返回EOK；无等待者时blank从1增加到2，超过有效容量1。满队列Push有对称问题。

原控制流：

```c
do {
    if (WAITING_FOREVER == timeout) {
        KSemaphoreObtain(id, WAITING_FOREVER);
        break;
    } else if (0 == timeout) {
        if (EOK == KSemaphoreObtain(id, 0)) break;
        else return -ERROR;
    }
} while (0);
```

验证副本统一转发实际timeout：

```c
if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
    return -ERROR;
}
```

失败时不进入ring，也不Abandon。obtain_id取自锁内缓存；后续原ring路径与被忽略的Abandon返回值保持，不能把本项修复解释成已证明完整并发队列正确。

状态：**修复方案已批准并检查，原源码缺陷仍存在。** Push/Pop分析副本已于2026-11-17按用户要求删除；上文保留已检查的修复代码，正式写spec时再落实到canonical文件。已有控制流测试覆盖多种有限timeout的参数传递、成功/失败、索引和输出保持。

## DQ-03：无限等待被误当成必定成功

源码位置：[PushDataqueue与PopDataqueue](/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c)，第128、175行。

原代码在timeout=-1时丢弃Obtain返回值并继续。无限等待只描述允许等待多久，不排除ID查找失败等错误。若Obtain返回错误，原代码仍可能改变ring或Abandon对偶semaphore。

原代码的无限等待分支如下（分别摘自两个函数）：

```c
/* PushDataqueue：申请一个空槽。 */
if (WAITING_FOREVER == timeout) {
    KSemaphoreObtain(p_queue->sem_blank, WAITING_FOREVER);
    break;
}

/* PopDataqueue：申请一个已有元素。 */
if (WAITING_FOREVER == timeout) {
    KSemaphoreObtain(p_queue->sem_data, WAITING_FOREVER);
    break;
}
```

这里的 `break` 只退出外层 `do { ... } while (0)`，并不退出函数。两个调用都没有检查返回值，因此即使Obtain因ID无效或查找失败返回错误，函数仍会继续执行后面的队列操作、调用对偶semaphore的Abandon，最后返回EOK。即使队列的空/满判断阻止了读写，后面的Abandon和成功返回仍会执行。

验证副本取消按timeout分开的这段控制流，统一检查Obtain结果：

```c
/* PushDataqueue：锁内取得实际要申请的sem_blank。 */
lock = CriticalAreaLock();
obtain_id = p_queue->sem_blank;
CriticalAreaUnLock(lock);
if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
    return -ERROR;
}

/* PopDataqueue：对应申请sem_data。 */
lock = CriticalAreaLock();
obtain_id = p_queue->sem_data;
CriticalAreaUnLock(lock);
if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
    return -ERROR;
}
```

当timeout为WAITING_FOREVER（-1）时，副本仍原样传入-1，保留无限等待语义；只有Obtain返回EOK才进入后续队列操作。若返回错误，立即退出函数，不改槽内容、索引或Pop输出，也不Abandon对偶semaphore。锁内缓存ID是已有的共享访问适配，本项错误的关键修复是检查返回值并用 `return` 结束失败路径。

例如Pop使用的sem_data已无对应对象，而sem_blank仍有效：原代码在Obtain失败后仍可能取走元素，并释放sem_blank、返回EOK；副本直接返回-ERROR，保持队列和输出不变。本项与DQ-02共用同一补丁，但原因不同：DQ-02根本没有调用Obtain，DQ-03调用了却忽略失败。

状态：**修复方案已批准并检查，原源码缺陷仍存在；分析副本已删除，当前无对应实现文件。** 同DQ-02，修复代码保留在本报告；已有失败路径检查确认未进入ring或Abandon。

## DQ-04：Peak检查结果可能在读取前失效

源码位置：[DataqueuePeak](/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c)，第222–225行。

队列只剩一个元素时，线程A先在锁外看到front!=rear；线程B随后Pop取走唯一元素并推进front；A才加锁，却直接读取新的base[front]。该槽可能未知或陈旧，已经不是A判断时的有效队首，A仍写输出并成功返回。

原来：

```c
if (p_queue->front != p_queue->rear) {
    lock = CriticalAreaLock();
    /* 读取队首，写输出。 */
    CriticalAreaUnLock(lock);
    return EOK;
} else {
    return -ERROR;
}
```

验证副本改为：

```c
lock = CriticalAreaLock();
if (p_queue->front != p_queue->rear) {
    /* 在同一次锁内读取队首，写输出。 */
    CriticalAreaUnLock(lock);
    return EOK;
} else {
    CriticalAreaUnLock(lock);
    return -ERROR;
}
```

检查和读取共享同一观察，空/非空两出口均解锁。函数仍不推进front、不操作semaphore。此适配按当前源码处理规则保护实际共享访问，仍需要调用期间对象有效的前提。

状态：**验证副本已按规则适配，原源码问题仍存在。** 当前文件：[DataqueuePeak.c](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c)。已有空/非空与锁平衡检查通过，本轮继续核对新版宏处理。

这些问题的修复授权继续有效；Push/Pop副本删除不撤销修复方案，当前文件状态以上述各项为准。具体适配与检查结果见 [source-changes.md](source-changes.md) 和 [source-fix-review.md](source-fix-review.md)；它们支持所述源码处理结论，不等于完成函数实现证明。
