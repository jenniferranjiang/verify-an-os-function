# 源码修改前后对照

更新时间：2026-11-16。说明当前全局annotated C中的验证副本，**没有修改原仓库** `/home/xinra/crtos`。下文代码是关键差异节选，省略处不表示删除原逻辑；完整C见链接。正式副本注释保留已批准缺陷修复的原代码。

本报告分开列出用户批准的缺陷修复、默认规则允许的源码适配，以及尚未应用的准备项。规格注解不是源码行为修复；设计/测试通过也不代表实现证明完成。证据详见 [source-errors.md](source-errors.md) 和 [source-fix-review.md](source-fix-review.md)。

## 1. InitDataqueue：正确区分有效ID与创建失败

状态：**用户已批准，副本已修复并复核。** [当前C](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c)

原来：memset后两个ID为0；以布尔值判断创建失败。

```c
memset(p_queue, 0, sizeof(DataQueueType));
/* 没有显式设置未创建ID。 */
p_queue->sem_blank = KSemaphoreCreate(p_queue->max_len - 1);
if (!p_queue->sem_blank) { break; }
p_queue->sem_data = KSemaphoreCreate(0);
if (!p_queue->sem_data) { break; }
```

现在：用-1表示尚未取得ID，任何负数表示创建失败，ID0是合法成功结果。

```c
memset(p_queue, 0, sizeof(DataQueueType));
p_queue->sem_blank = -1;
p_queue->sem_data = -1;
/* 其余原初始化代码保留。 */
p_queue->sem_blank = KSemaphoreCreate(p_queue->max_len - 1);
if (p_queue->sem_blank < 0) { break; }
p_queue->sem_data = KSemaphoreCreate(0);
if (p_queue->sem_data < 0) { break; }
```

### 为什么原判断会出错

Semaphore的返回约定是“非负数为有效ID，负数为错误码”。C的 `!id` 判断的是“是否等于0”，与这个约定不同。以第一个信号量创建为例：

| 创建结果 | 原 `if (!id)` | 原代码结果 | 修改后的结果 |
| --- | --- | --- | --- |
| 0，合法ID | 真 | 退出初始化，进入失败清理 | 接受ID0，继续创建另一个信号量 |
| 7，合法ID | 假 | 继续 | 继续 |
| -5，分配/创建失败 | 假 | 继续；若后续条件通过，可能返回EOK | 立即进入失败清理 |

例如Create返回-5，原代码的 `!-5` 为假，队列可能被报告为“初始化成功”，但字段里保存的是错误码。后续Push/Pop再用这个ID调用semaphore时，失败原因已经离开了初始化位置。修复把失败拦在产生错误的地方。

### 为什么还必须增加-1初值

只把创建后的检查改成 `<0` 仍不够。数组分配失败时，两个Create都没执行；第一个Create失败时，第二个也没执行。这些未执行位置在memset之后都是0，而0本身可能是系统里真实有效的semaphore ID。

因此要同时修改初始化与清理：用-1表示“这次初始化尚未取得这个资源”，清理只处理非负ID。如果只修改DeInit为 `>=0`，却仍让未创建字段保持0，清理就可能误删不属于这次初始化的ID0。这也是第1、2项必须配套的原因。

### 修改后保证及检查

成功路径必须实际取得两个非负ID；部分失败路径能区分“已取得”“尚未创建”和“创建返回错误”。不覆盖Create返回的具体负错误码，不改变数组分配及失败解锁后调用DeInit的顺序。

已检查ID0出现在任一创建位置、数组分配失败、首次Create失败、第二次Create失败，以及容量0/1。这里只检查授权副本的控制流，未声称任意并发使用中的队列都可重新初始化。

## 2. DeInitDataqueue：仅删除已取得的ID

状态：**用户已批准，副本已修复并复核。** [当前C](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c)

原来，下面逻辑分别用于sem_blank和sem_data：

```c
if (p_queue->sem_blank) {
    KSemaphoreDelete(p_queue->sem_blank);
    p_queue->sem_blank = NONE;
}
```

现在：

```c
if (p_queue->sem_blank >= 0) {
    KSemaphoreDelete(p_queue->sem_blank);
    p_queue->sem_blank = -1;
}
```

### 原逻辑与资源归属的冲突

`if (id)` 会跳过有效ID0，却进入负错误码的分支。若Init实际创建了ID0，原DeInit不会删除它；数组虽然释放了，那个semaphore仍留在管理结构里，造成资源泄漏。若字段为-5，原DeInit反而调用Delete(-5)；Delete会因负ID早返回，但DeInit随后把字段写回0，丢失错误码，并继续把0当作“未持有资源”。

修改后的 `>=0` 与Create返回约定一致：ID0和其他非负ID都需要删除，负值不代表本次持有的资源。删除后写-1，使再次清理能识别“已经处理过”。sem_data对称修改。

### 为什么不把所有负值都重置成-1

这次修复只在实际删除的分支写-1，原本为负的错误码没有进入该分支。因此真实回滚结果可能是：

| 失败位置 | 清理后的blank/data字段 |
| --- | --- |
| 数组分配失败，两次Create未执行 | (-1, -1) |
| 第一次Create返回-5 | (-5, -1) |
| 第二次Create返回-5，第一次已成功 | (-1, -5) |

这些差异必须保留在spec里，不能为了统一写法把实现说成总是返回(-1,-1)。base仍仅在非空时释放并清空，front/rear/max_len不改，IRQ保存值原样恢复。已检查上述失败分支和再次DeInit没有重复释放/删除。

本轮DeInit规格覆盖的是**初始化失败后尚未发布对象的清理**。修复ID判断不能单独解决正常运行队列的并发销毁、等待者处理或其他线程继续使用旧地址的问题。

## 3. PushDataqueue / PopDataqueue：所有timeout都执行Obtain并检查结果

状态：**用户已批准，副本已修复并复核。** 当前批准副本：[Push](../../../../annotated_C/module_context/dataqueue/PushDataqueue.c)、[Pop](../../../../annotated_C/module_context/dataqueue/PopDataqueue.c)，待新spec完成时归入canonical位置。

原来（以Push为例，Pop对应sem_data）：

```c
do {
    if (WAITING_FOREVER == timeout) {
        KSemaphoreObtain(p_queue->sem_blank, WAITING_FOREVER);
        break; /* 忽略失败结果 */
    } else if (0 == timeout) {
        if (EOK == KSemaphoreObtain(p_queue->sem_blank, 0)) break;
        else return -ERROR;
    }
} while (0);
```

### 有限等待为什么会绕过资源获取

原do-while只执行一次。timeout既不是-1也不是0时，两个if分支都不进入，执行直接落到do-while之后。它并没有等待timeout毫秒，也没有取得任何semaphore额度。

以容量2的空队列为例，它的有效容量为1，初始data计数为0、blank计数为1。调用 `Pop(..., 17)`：

1. 17不匹配原来的两条分支，完全不调用Obtain。
2. 队列为空，ring部分不写输出、不推进front。
3. 仍调用Abandon(blank)，无等待者时blank从1变成2。
4. 返回EOK，但没有取出元素，输出仍为调用前的内容；blank计数还超过了该队列的有效容量。

满队列的 `Push(..., 17)` 对称：没有取得blank、没有插入元素，却增加data并返回EOK。这不只是“没有实现有限等待”，还会制造与队列操作不对应的semaphore计数变化。

### 无限等待分支为什么也要检查返回值

原 `timeout=-1` 路径忽略Obtain返回值。无限等待表示允许等待多久，不表示调用永远不可能失败；例如ID查找失败可以立即返回错误。此时原代码仍执行ring和Abandon。统一检查结果，才能保证失败时不再继续后续操作。

现在统一为：

```c
if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
    return -ERROR;
}
```

### 修改后的行为与仍需区分的保证

`obtain_id`来自下节的锁内缓存。所有timeout原样交给Obtain一次：返回非EOK，Push/Pop统一返回-ERROR，不操作数组/索引，也不Abandon；返回EOK，才进入原ring路径。这修复了上层“跳过Obtain”和“忽略Obtain失败”两个问题。

它**不自动保证Obtain自身正确处理timeout**。第6项正是继续检查真实callee后发现的另一个独立缺陷：虽然上层正确传入0，callee却把0变成了1tick。因此两项修复不能相互代替。

此外，当前实现仍检查Push是否满、Pop是否空；条件不满足时不更新ring，但仍执行Abandon并返回EOK，且不检查Abandon结果。本次没有改这部分算法。不能从“Obtain返回成功”就凭空推出ring一定能操作，尤其当前共享模型没有建立覆盖所有进行中操作的额度对应关系。新spec必须保留真实分支并明确适用条件。

已用可观察Obtain/Abandon stub检查多种timeout的参数转发、成功/失败、输出和索引变化。该测试支持上层修复，不证明semaphore本身的等待行为。

## 4. PushDataqueue / PopDataqueue：共享ID在锁内读取

状态：**按源码处理规则已适配并独立复核。** 这不是用户额外批准的算法修复，也不自动解决对象并发销毁问题。

### 为什么函数参数也算共享读取

原来代码形如 `KSemaphoreObtain(p_queue->sem_blank, timeout)`。虽然Obtain内部会加锁，但C先求值实参，再进入被调用函数：读取 `p_queue->sem_blank` 发生在Obtain取得锁之前。同理，`KSemaphoreAbandon(p_queue->sem_data)` 的实参读取发生在caller已经释放ring锁之后。

当前模型把已发布queue结构和字段交给共享os_inv管理，只有取得临界区资源时才能按该协议读取。即使字段恰好是一个机器字，也不能仅凭其地址推导读取权限或对象生命周期。为落实当前共享访问规则，把真正的字段读取移到caller持锁的位置。

现在（Push；Pop交换blank/data）：

```c
lock = CriticalAreaLock();
obtain_id = p_queue->sem_blank;
CriticalAreaUnLock(lock);
if (EOK != KSemaphoreObtain(obtain_id, timeout)) return -ERROR;

lock = CriticalAreaLock();
/* 原ring操作。 */
abandon_id = p_queue->sem_data;
CriticalAreaUnLock(lock);
KSemaphoreAbandon(abandon_id);
```

### 为什么只锁读取，不把Obtain整个包在锁里

Obtain可能挂起任务并触发调度；Abandon也可能唤醒任务并请求调度。两者当前采用临界区外调用接口。因此适配只增加读Obtain ID所需的短临界区；Abandon ID直接在原有ring临界区内读出，避免额外展开锁范围。调用本身仍在锁外，timeout原样传递，每次解锁恢复对应保存值。

### 这项适配能解决什么、不能解决什么

它解决的是“取这个字段时是否持有共享访问权限”。它没有使“读取ID、Obtain、ring操作、Abandon”成为一个原子操作。

例如线程A锁内读到ID5并解锁，线程B随后销毁queue关联的semaphore，甚至将ID5分配给另一个对象，A再调用Obtain(5)仍可能针对错误的生命周期。缓存并没有保活对象，也没有给ID附加世代号。后续spec必须明确对象存在和身份保持的条件；不能把本项写成已经解决并发销毁或ABA问题。

已检查字段读取处于相应锁内、两个semaphore调用仍在锁外，以及成功/失败路径的锁成对恢复。该适配依赖当前源码处理规则，不宣称对所有原程序调度轨迹都无条件等价。

## 5. DataqueuePeak：检查和读取放在同一临界区

状态：**按源码处理规则已适配并独立复核。** [当前C](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c)

原来：

```c
if (p_queue->front != p_queue->rear) {
    lock = CriticalAreaLock();
    /* 读取base[front]，写输出。 */
    CriticalAreaUnLock(lock);
    return EOK;
} else {
    return -ERROR;
}
```

现在：

```c
lock = CriticalAreaLock();
if (p_queue->front != p_queue->rear) {
    /* 读取base[front]，写输出。 */
    CriticalAreaUnLock(lock);
    return EOK;
} else {
    CriticalAreaUnLock(lock);
    return -ERROR;
}
```

### 原代码的具体交错问题

假设队列仅有一个元素，front=0、rear=1：

1. 线程A在锁外判断 `front != rear` 为真。
2. A尚未加锁，线程B执行Pop，把唯一元素取走并令front=1，此时队列已空。
3. A随后加锁，但没有重新判断非空，而是读取**当前**的 `base[front]`，即base[1]。
4. 这个槽不再是A最初观察到的队首，可能从未初始化，也可能是上一次使用留下的旧值；A却把它当作有效元素写到输出并返回成功。

因此只有“元素读取有锁”不够。问题在于允许读取的依据来自更早、未受保护的观察。

### 为什么把条件和读取一起移入锁内

修改后，front/rear判断、选择front槽、读取两个字段都在同一次临界区内，判断成立的那一刻到读取完成之间不允许其他受同一协议约束的队列操作插入。只给条件单独加锁再解锁，随后重新加锁读取，仍会保留上述窗口，不能解决问题。

因为锁现在在if之前取得，空分支也必须增加Unlock；否则空队列返回时会遗留临界区状态。两条出口都恢复同一次保存值。函数仍只读，不推进front、不修改数组、不调用semaphore；空分支仍返回-ERROR并保持输出。

已检查空/非空路径与保存值恢复。此修改解决检查和读取的时序一致性，仍要求调用期间目标对象满足共享对象的生命周期前提。

## 6. _SemaphoreObtain：零超时不转换成1tick

状态：**用户本次已批准，副本已应用且main独立复核通过；尚未据此宣称新spec完成。** [修复副本](../../../../annotated_C/module_context/semaphore/_SemaphoreObtain.c)

原来：

```c
if (WAITING_FOREVER == msec)
    wait_time = WAITING_FOREVER;
else
    wait_time = CalculateTickFromTimeMs(msec);
```

批准后的修改：

```c
if (msec == 0)
    wait_time = 0;
else if (WAITING_FOREVER == msec)
    wait_time = WAITING_FOREVER;
else
    wait_time = CalculateTickFromTimeMs(msec);
```

### 原代码为什么有“零等待分支”却仍然等待

_Obtain后面原本就有这段控制流：先看semaphore计数是否大于0，有额度就递减并返回EOK；没有额度，再检查 `wait_time == 0`，为零就返回-ETIMEOUT。这个分支本身没有缺失，问题发生在更早的单位转换。

真实CalculateTickFromTimeMs会把计算结果为0的情况提升到MIN_TICKS=1，输入0也如此。当前配置TICK_PER_SECOND=100，于是 `msec=0 → converter(0)=1 → wait_time=1`。资源不足时，`wait_time==0` 为假，继续将任务加入等待链，调用 `KTaskSetDelay(task, 1)`，解锁并请求调度。这里能确定的是进入等待分支并请求1tick延时，不能把它表述成一定恰好等待某个墙钟时长。

### 为什么修复Obtain，而不修改时间转换函数

“0表示只尝试一次、不能等待”是Obtain调用接口的特殊含义。时间转换函数本身采用最少1tick的规则，其他caller可能依赖该行为。修改converter会扩大影响范围，并改变已有可复用规格。本次最小修复是在Obtain里先识别这个特殊值，其余输入继续使用原转换。

修复后资源有额度时仍递减成功，**不会因为timeout=0就直接拒绝获取**；只有资源不足时，wait_time保持0，命中已有立即超时分支，不进入挂起/延时/调度。-1仍保留无限等待语义；其他timeout仍原样转换，未另外修正舍入规则或改变负值输入的原处理。

### 反例和实际副本检查说明了什么

测试直接使用实际converter和Obtain函数体，只替换锁、ID查询、等待链、delay、scheduler等外围依赖以记录调用。对有效ID、value=0、timeout=0：

| 观察项 | 原版 | 已应用副本 |
| --- | --- | --- |
| Suspend | 1次 | 0次 |
| SetDelay | 1次，参数1tick | 0次 |
| Assign | 1次 | 0次 |
| 返回来源 | 调度stub模拟唤醒后的task->exstatus | 原有立即-ETIMEOUT分支 |

测试中两次返回值均为-2，但返回前经历的过程完全不同；只比返回码会漏掉问题。另检查计数可用、负ID、有限等待、无限等待。Main核对实际副本与批准diff逐token一致，并重新编译运行测试通过。这证明所述分支修复，不是完整scheduler、等待时间或并发行为证明。

## 7. 其余已应用的切片与工具适配

| 项目 | 原来 | 验证副本 | 依据及限制 |
| --- | --- | --- | --- |
| 固定done分派 | done.SemaphoreCreate/Delete(...) | 调用_SemaphoreCreate/Delete(...) | 原静态表目标确定；不改变算法 |
| 内部嵌套锁 | _SemaphoreCreate/Delete自己Lock/Unlock | 当前IC副本注释去掉嵌套锁，caller持锁 | 只适用于当前锁内调用场景，不改全局OC版本 |
| IRQ宏 | DISABLE_INTERRUPT/ENABLE_INTERRUPT | DisableLocalInterrupt/EnableLocalInterrupt | 精确宏目标；资源交接使用用户已批准信任，不证明硬件mstatus |
| 旧NULL检查 | 空指针循环的NULL_PARAM_CHECK宏 | NULL_PARAM_CHECK_1正常返回模型 | 仅描述正常返回条件，不把空指针行为改写为成功 |
| 调试 | KPrintf、SYS_KDEBUG_LOG、KDEBUG_NOT_IN_INTERRUPT | 按规则注释移除 | TrustBase允许的调试适配 |
| CONTAINER_OF | 从id节点取Semaphore指针的宏 | CONTAINER_OF_SEMAPHORE_ID模型 | 保持字段偏移对应，沿用已允许模型 |
| 调度宏 | DO_KTASK_ASSIGN | KTASK_ASSIGN模型调用 | 沿用项目规则与完整callee契约 |
| 类型和头文件 | 原编译单元类型/匿名结构、配置 | 一函数一文件，模块header，具名tag；ILP32非SMP | 保持字段次序与选定32位布局；不是修改原硬件工程配置 |

### 这些适配为什么需要单独记录

固定done目标是把源码中可唯一确定的间接调用写成直接调用，方便检查调用边界；如果函数表可能运行时改变，就不能据此随意替换。这里依据实际静态表，而不是按函数名猜测。

嵌套锁适配只用于Init已持锁、DeInit已进入IRQ临界区的调用场景。外层仍负责取得和归还共享资源，内部C的分配、ID、链表操作与返回分支保留。不能拿这个IC副本代表外部任意调用的OC版本，也不能因此删掉真实新Obtain/Abandon所需的锁。

旧NULL宏、CONTAINER_OF和调度宏采用的是项目允许的模型边界，后续证明依赖这些模型；调试移除也依赖TrustBase。它们不同于“证明原宏/硬件实现正确”。IRQ宏展开保留同一个保存值，用户信任的是资源交接约定，不是把硬件中断实现验证了一遍。

一函数一文件与具名结构tag是输入组织；ILP32选择则是本轮验证配置，已核对DataQueue结构20字节、DataElem结构8字节及字段偏移。不能据此声称64位硬件部署也被当前布局证明覆盖。

## 8. 已识别但尚未应用的适配

_SemaphoreObtain在等待路径调度后直接 `return task->exstatus;`。task指针是在先前临界区取得的，但解锁和调度之后，先前的共享内存读取权限不能一直保留在caller手中。exstatus又是唤醒/超时路径可更新的共享字段，后续读取需要重新按协议取得资源。

拟按规则改为“加锁→读取exstatus到局部变量→解锁→返回局部变量”。这只保护返回值读取，不把等待和调度放进锁，也不证明task在等待期间永不退役。当前尚未应用，不能算入已完成修改；它与第6节零超时算法修复是两个独立事项。应用后还须检查新锁成对恢复、返回值一致及task生命周期前提。

当前没有修复或假定解决Push/Pop跨锁对象退役/ID复用、Obtain成功后的ring条件，以及Abandon失败被忽略问题。设计须如实表达实际行为和适用前提，不能将未发生的修改写成已修复。

## 9. 后续依赖中新发现的问题：尚未修改

以下问题是在继续设计Push/Pop的等待调用链时发现的，**不属于已批准、已应用的源码修改**。单独列在这里，是为了说明为什么零超时修好后，仍不能立即把完整等待路径标为设计完成。详细证据及状态见 [source-errors.md](source-errors.md)。

### 9.1 延时链排序与tick回绕不一致

KTaskSetDelay原来使用普通无符号数值比较决定插入位置：

```c
if (delay->ticks < dnode->ticks) {
    DoubleLinkListInsertNodeBefore(nodelink, &delay->link);
    break;
}
```

32位tick达到最大值后回到0，所以数值更小不一定表示更早到期。具体例子：

1. 当前tick是 `0xfffffffe`，已有任务A在 `0xffffffff` 到期，即再过1tick。
2. 新任务B请求3ticks，deadline回绕成1，实际应比A晚2ticks到期。
3. 原比较器看到 `1 < 0xffffffff`，把B插在A前面。
4. tick达到 `0xffffffff`，CheckTaskDelay先看队首B。它使用回绕差值判断，正确认定deadline=1还未到期，于是break，不再检查后面的A。
5. A已经到期，却被B挡住；反例中直到tick=1，B和A才被依次处理，A晚了2ticks。

这不是仅与参考证明的定义不同，而是插入顺序与实际检查顺序不一致。已用实际SetDelay、UnSetDelay、CheckTaskDelay和DLL函数体构造可运行反例，只替换外围系统依赖，观察到上述结果。

最小比较器提案为：

```c
if (delay->ticks != dnode->ticks &&
    (uint32)(dnode->ticks - delay->ticks) < TICK_SIZE_MAX / 2) {
    DoubleLinkListInsertNodeBefore(nodelink, &delay->link);
    break;
}
```

同一反例中，提案让A在B前面，A在原deadline被处理，B仍等到tick=1。这仍依赖半周期内可比较的deadline窗口；不能把一个反例修复说成通用任意跨度延时都正确。**提案未批准、未应用**，当前不声称KTaskSetDelay已有可直接适用的spec。

### 9.2 有限等待时Delay分配失败，但Obtain忽略错误

当前真实调用顺序是：

```c
LinklistSuspend(&sem->pend_list, task, LINKLIST_FLAG_PRIO);
if (wait_time > 0) {
    KTaskSetDelay(task, wait_time); /* 返回值未检查 */
}
CriticalAreaUnLock(lock);
DO_KTASK_ASSIGN;
```

如果task此前没有Delay对象，SetDelay需要分配内存。分配失败会返回-ENOMEMORY，而且没有创建超时节点。但此时task已经挂起并进入semaphore等待链，Obtain又丢弃错误继续调度。

在之后没有Abandon/Delete或其他显式唤醒的执行里，CheckTaskDelay找不到这个任务的超时节点，所请求的有限timeout不会触发它的唤醒。与第6项相反，这里不是本应不等待却等待，而是请求有限等待却没有建立结束等待的机制。

仅添加“SetDelay失败就return”也不够：任务已被挂起并链接到pending，必须先撤销这次加入、恢复任务可运行状态，并保证临界区正确退出。具体回滚实现需要核对任务/ready/pending资源后再提出可应用补丁。**目前仅完成源码路径分析，没有实现修复，也没有声称已用完整调度测试证明非终止。**

这两项不影响已完成的Init/初始化回滚/Peak设计路径，但会阻塞新的完整Push/Pop等待路径。没有用隐含“永不回绕”或“分配必成功”条件把它们排除。

## 源码基线与检查范围

原data_queue.c SHA-256：`a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`；semaphore.c：`d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec`；tick.c：`4db5cceacbf0f7a6c4d72151c9e66cdf30bdfa0eb455820cdf5048365456323d`。

Init/DeInit已检查ID0、分配与两次创建失败、重复清理及n=0/1；Peak检查空/非空；Push/Pop已检查多种timeout下成功/失败及ID锁内缓存。早期Push/Pop测试用semaphore stub，不能覆盖第6节真实Obtain缺陷。所有测试仅支持所述控制流与布局结论，不是完整并发证明；本trial尚未完成C实现证明。
