# 源码修改前后对照

> 2026-11-17：按用户要求删除Push/Pop/_SemaphoreObtain三个分析副本。下文涉及这些副本的同步与测试是删除前的历史记录；修复及适配代码保留在[source-changes.md](source-changes.md)，不表示当前仍有对应实现文件。七份canonical、lib和VC不受此次删除影响。

更新时间：2026-11-16。说明当前全局annotated C中的验证副本，**没有修改原仓库** `/home/xinra/crtoslatest`。下文代码是关键差异节选，省略处不表示删除原逻辑；完整C见链接。正式副本注释保留已批准缺陷修复的原代码。

本报告分开列出用户批准的缺陷修复、默认规则允许的源码适配，以及本轮上游变化的同步。规格注解不是源码行为修复；设计/测试通过也不代表实现证明完成。证据详见 [source-errors.md](source-errors.md) 和 [source-fix-review.md](source-fix-review.md)。

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

状态：**用户已批准，副本已修复并复核。** 当前批准副本：`Push`、`Pop`，待新spec完成时归入canonical位置。

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

## 6. 按crtoslatest同步Semaphore源码行为

本轮来源为 `/home/xinra/crtoslatest`，commit `a07641a0b58469ae3ea19317cce2cf48974989bb`。下面是上游代码变化的同步，不是新增的本地缺陷补丁。

### 非法ID在查找前拒绝

旧验证输入只检查 `id < 0`。新版SemIdInvalid还拒绝 `id > UINT16_MAX`，因此65536不能再窄化为ID0并操作另一个对象。副本等价内联为：

```c
if (id < 0 || id > 65535)
    return;
```

_Delete使用上面的void返回，_Obtain上下文使用-ERROR返回。合法范围内仍由IdGetObj判断是否登记；例如65535通过表示范围检查，不等于它一定是已分配ID。Lib增加semaphore_id_invalid，并同步OC删除抽象、IC删除效果和quiescent条件；越界ID保持状态，不要求无关队列提供删除资源。

### Obtain直接采用新版等待与失败处理

`_SemaphoreObtain源码上下文`已从新源码刷新，保留非法负timeout拒绝、零timeout不转换、有限等待设置失败后唤醒本任务并返回-ENOMEMORY：

```c
if (msec < 0 && msec != WAITING_FOREVER)
    return -ERROR;
if (msec == 0)
    wait_time = 0;
else if (WAITING_FOREVER == msec)
    wait_time = WAITING_FOREVER;
else
    wait_time = CalculateTickFromTimeMs((uint32)msec);
/* ... 挂入semaphore pending ... */
if (wait_time > 0 && KTaskSetDelay(task, wait_time) != EOK) {
    KTaskWakeup(task->id.id);
    CriticalAreaUnLock(lock);
    return -ENOMEMORY;
}
```

这是实际新源码分支的节选，副本保留原嵌套if写法。新源码已经处理这些路径，当前副本不再把零超时分支标为本地补丁。该文件仍是分析上下文，尚无完整Obtain函数规格或实现证明。

## 7. 新NULL诊断宏的适配

旧验证输入使用NULL_PARAM_CHECK_1及 `Ensure p != 0`，对应旧宏遇NULL死循环的正常返回模型。crtoslatest的NULL_PARAM_CHECK只输出诊断并计数，然后继续执行，不能再由它推出非空。

当前Init/DeInit/Peak已移除旧模型声明与调用，Push/Pop分析副本也按规则注释掉诊断宏：

```c
/* NULL_PARAM_CHECK(p_queue); latest log/count diagnostic omitted. */
```

后续访问权限由真实存储资源承担：Init入口的DataqueueStorage、DeInit的dataqueue_owned，以及Peak加锁后从os_inv取得的队列资源。没有为了移除宏而凭空增加非空假设或trusted函数。

## 8. 调度、生命周期宏及其他工具适配

当前验证配置为ILP32、非SMP、100Hz，未定义KERNEL_STATIC_OBJECTS和KERNEL_DEFER_IPC_SCHED。因此新版wrapper的生命周期检查宏展开为空，DO_KTASK_ASSIGN_ON_WAKE在本配置展开为DO_KTASK_ASSIGN，继续使用既有KTASK_ASSIGN模型。若以后改变这些配置，须重新核对分支。

固定done分派仍按真实静态表解析；调试打印按TrustBase注释移除；IRQ宏仍展开为已有授权的DisableLocalInterrupt/EnableLocalInterrupt并原样传回保存值；CONTAINER_OF沿用字段偏移模型。全局Semaphore canonical保留OC body及具名IC契约，IC源码适配规则见 [design.md](design.md)。这些是已明确条件的验证适配，不是原宏或硬件实现已获证明。

## 9. Obtain返回exstatus的共享读取适配

新版原代码在调度后直接 `return task->exstatus;`。为按共享访问规则取得该字段，当前分析副本改为：

```c
lock = CriticalAreaLock();
int32 result = task->exstatus;
CriticalAreaUnLock(lock);
return result;
```

只保护读取，不把等待或调度放入锁内；两个出口资源仍需由后续Obtain规格描述。这个最小适配不提供task跨等待期间的生命周期保证，也不表示Obtain实现证明完成。

## 当前基线和检查依据

当前原data_queue.c SHA-256为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`，与之前逐字相同，因此第1–5节的已批准修复/适配仍有同样依据。semaphore.c新SHA-256为 `dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8`。

新源码Delay和Tick行为已在来源复查中确认；本轮未给它们新增canonical或宣称相关函数规格已完成。当前仍存在的源码错误仅列于 [source-errors.md](source-errors.md)，本轮同步及针对性检查见 [source-fix-review.md](source-fix-review.md)。

## 2026-11-17 QCP语法适配

InitDataqueue唯一active body中的 `p_queue->front = p_queue->rear = 0;` 拆为 `p_queue->rear = 0; p_queue->front = 0;`，原表达式保留于注释。两个不同结构字段按原C求值顺序赋相同值，无额外调用或路径变化。这是QCP解析适配，不是新算法修复。header的Extern Coq按kind/term分块，声明内容和顺序不变。新增which-implies及Assert只生成证明义务，不改变C执行。

## LinklistSuspend IC实参读取注解边界

2026-11-19，验证副本将`SuspendKTask(task->id.id)`拆为`int32 suspend_id`局部变量、单次赋值及`SuspendKTask(suspend_id)`。目的为读取ID后将借出的ushort字段归还os_inv再调用callee；不改变读取/调用次数、类型转换值、非法flag提前返回或算法。独立源码等价审阅`dq-suspend-id-evaluate-once-20261119-r1`通过，见[运行时审阅](../2026-11-18-PopDataqueue-PushDataqueue/review.md)。这不是原始源码缺陷修复，不修改source_root。

LinklistSuspend后续等价降级：两个无贯穿switch分支改为if/else-if，保留循环break和全部分支内容；目的是支持当前QCP控制值/Assert组合，非源码缺陷修复。独立行为等价审阅`dq-suspend-switch-lowering-20261119-r1`通过，formal规格不变，见同一运行时review记录。

归因更正：随后发现双spec作为body入口布局导致跨spec状态合并，尚不能将先前局部值错位归因于switch工具缺陷；保留if降级是已审阅的等价适配，不宣称其为唯一必要修复。原始C本身没有因此新增缺陷结论。

Obtain SetDelay失败路径的Wakeup ID实参按同一evaluate-once规则拆为局部int32后调用，行为/规格保持；审阅dq-obtain-wakeup-id-evaluate-once-20261119-r1见运行时review。不是原始源码缺陷修复，不改原仓库。

LinklistResume `dq-resume-id-evaluate-once-20261119-r1`：仅在canonical将KTaskWakeup的task->id.id参数读入int32局部变量再调用，以便字段资源先归还；独立逆变换/类型/严格GCC检查通过，formal注解不变。详见第二阶段review.md；不是算法修复或新增信任。
