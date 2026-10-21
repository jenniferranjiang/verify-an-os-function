# KSemaphoreCreate 本次源码分析

分析日期：2026-10-19。唯一源码根为 `/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/`，配置为 `board/stm32f103-nano/config`。分析依据限定该源码、当前 skill 与根 `lib/`；未读取或复用历史 trial 文件内容。后续查找缺失 ARM 标准头时曾误用一次 `rg --files /home/xinra` 进行路径枚举，匹配结果为空；该命令未打开文件内容，但范围不符合隔离要求。该偏差已报告主作者，后续仅使用明确白名单路径。下文相对源码路径均以唯一源码根为基准。trusted 函数体未读取。

## 配置、ABI 与宏证据

`board/stm32f103-nano/config.mk:3` 明确 `-mcpu=cortex-m3 -mthumb`；config 启用 KERNEL_SEMAPHORE、ID_NUM_MAX=128、ID_HTABLE_SIZE=16，关闭 ARCH_SMP，类型由 `kernel/include/xs_base.h` 定义，`uint16` 为 unsigned short、`int32` 为 signed int、`x_base` 为 long。当前环境没有 ARM cross compiler 或 clang，因此用 gcc 的 `-m32 -ffreestanding -fsyntax-only` 对实际 headers 做 ILP32 自然布局的 compile-time assertions，未声称运行 ARM 编译。涉及的结构只含 16-bit 整数、32-bit 指针，无导致 ARM 与 i386 ILP32 布局分歧的 wider members。

可复现检查为 `checks/layout.c`，编译命令与结果在 `checks/layout-check.log`；`checks/config/xsconfig.h` 从本配置中每个 CONFIG_KEY=y/数值/字符串直接转换生成。`checks/source_evidence.py` 记录生成方法和 source hashes；该脚本默认只重验冻结源码/配置的 hashes、配置生成结果和 ABI，且不修改任何文件。只有显式提供 `--extract-unannotated` 才覆盖未注解切片；本次没有调用该选项。

| C 对象 | 大小/对齐 | 字段 offsets / ownership |
|---|---|---|
| SysDoubleLinklistNode | 8 / 4 | node_next=0, node_prev=4 |
| IdNode | 12 / 4 | id=0 (2 bytes), padding [2,4), link=4 |
| IdManager | 12 / 4 | id_max=0, hoffset=2, id_map=4, htable=8 |
| Semaphore | 32 / 4 | id=0, value=12 (2 bytes), padding [14,16), pend_list=16, link=24 |
| SemaphoreDoneType | 20 / 4 | 五个函数指针依序 offsets 0,4,8,12,16 |
| k_sem_id_manager 位图 | 16 | uint8[16], 覆盖 IDs 0..127 |
| k_sem_id_manager 哈希表 | 128 | 16 个 8-byte head；全局零初始化，按需初始化空链表 |

`DECLARE_ID_MANAGER` 来自 `xs_id.h:48`，展开为两个数组和 manager initializer：id_max=128、hoffset=16、id_map/htable 指向对应数组。`k_sem_list` 在 semaphore.c 显式初始化为 self-linked empty list。

虽然 board config 写了 KERNEL_DEBUG 未启用，`xs_kdbg.h:32` **无条件 `#define KERNEL_DEBUG`**，所以 NULL_PARAM_CHECK 必须保留。其 NULL 分支先 KPrintf，再 `while (1)` 不返回。`SYS_KDEBUG_LOG(KDBG_IPC,...)` 展开为 `do { if (0) { KPrintf(...); KPrintf(...); } } while (0)`，两次调用语法保留但运行不可达。检查输出见 `checks/macros.log`。`semaphore.c:24-28` 又独立 undef/redefine `KDEBUG_NOT_IN_INTERRUPT` 为空，故 KSemaphoreCreate 无 ISR 检查、无隐藏 getCounter dispatch，不可增加非 ISR Require。

`memset` 的声明由 `kernel/include/xizi.h:38` 的 `<string.h>` 引入，本配置采用 LIB_NEWLIB。`xs_base.h` 内自己的 size_t typedef 位于 `#if 0`，不参与编译；kernel 的 `x_size_t` 则是另外的 unsigned long typedef。caller-local prototype 应使用 `<stddef.h>` 的 `size_t`，保持标准库原型，不替换成 x_size_t。当前 gcc -m32 检查下 size_t 为32位；缺失 ARM/newlib 安装，未声称已检查本地 ARM 标准头。[newlib string.h](https://raw.githubusercontent.com/mirror/newlib-cygwin/master/newlib/libc/include/string.h) 可交叉核对标准原型；[GCC ARM target 定义](https://raw.githubusercontent.com/gcc-mirror/gcc/master/gcc/config/arm/arm.h) 的 AAPCS SIZE_TYPE 为 unsigned int，但该线上来源仅作 ABI 背景，不替代本地指定工具链检查。

`xs_isr.h:87-88` 将 DISABLE_INTERRUPT / ENABLE_INTERRUPT 分别映射到 DisableLocalInterrupt / EnableLocalInterrupt。它们是用户批准的 trusted 边界，无函数体分析。

## 唯一 dispatch 与完整递归调用闭包

`semaphore.c:232-238` 的文件静态 done initializer 将 SemaphoreCreate 唯一设为 `_SemaphoreCreate`。本文件所有 done 引用均为 initializer 或五个公开 wrapper 的读取，没有赋值和地址逃逸；直接解析该 dispatch 有源码依据。

| 非 trusted canonical symbol | 源码 | 直接调用（含宏） |
|---|---|---|
| KSemaphoreCreate | semaphore.c:246 | _SemaphoreCreate |
| _SemaphoreCreate | semaphore.c:33 | x_malloc, memset, CriticalAreaLock, IdInsertObj, x_free, CriticalAreaUnLock, InitDoubleLinkList, DoubleLinkListInsertNodeAfter, KPrintf (if(0)) |
| CriticalAreaLock | CriticalArea.c:117, 非 SMP | DisableLocalInterrupt |
| CriticalAreaUnLock | CriticalArea.c:132, 非 SMP | EnableLocalInterrupt |
| IdInsertObj | id.c:106 | KPrintf(NULL guard), AllocId, InsertObj |
| AllocId | id.c:24 | KPrintf(NULL guard) |
| InsertObj | id.c:62 | KPrintf(NULL guard), InitDoubleLinkList, DoubleLinkListInsertNodeAfter |
| InitDoubleLinkList | double_link.c:30 | 无 |
| DoubleLinkListInsertNodeAfter | double_link.c:42 | 无 |

完整闭包为 **9 个 nontrusted + 6 个 trusted**。trusted 恰为 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf。`FreeId/GetObj/RemoveObj` 以及 scheduler/task operations 仅生命周期上下文，不在创建闭包。不存在未解析调用或另外批准的边界。

## 创建路径、状态转移及真实边界

1. x_malloc(32) 返回 NULL：返回 -ENOMEMORY=-5，尚未锁临界区，manager/list 均未访问。
2. 分配成功：获取完整未初始化私有 32-byte object。memset(sem,0,32) 返回 sem 并使包括两处 padding 在内的完整对象为零。
3. CriticalAreaLock 保存真实 IRQ state 并关闭 IRQ，取得/保持全局临界区资源；`KTaskOsAssignLockNest` 是 static uint16，执行 ++。其算术是 `(old+1) mod 65536`，不得人为排除 old=65535。
4. IdInsertObj 调 AllocId。AllocId 扫描位图 byte，选择首个非 255 byte，再从最低位扫描首个 0 bit。如果所有 byte 为255，返回-1且不写入；一般 manager 还存在尾部非法位导致 `id>=id_max` 的失败路径，同样不写入。固定128配置该尾部失败不可达，但 canonical helper body 保留。
5. IdInsertObj失败：idnode 完全未写，sem 仍完整清零且未发布。x_free 消费该私有对象；CriticalAreaUnLock 后返回-5。没有泄漏 manager 位图位。
6. IdInsertObj成功：选中 id bit置1，写 sem->id.id，InsertObj 选择 htable[id % 16]。若 bucket head->prev==NULL，先初始化 self-cycle；将 sem->id.link 插入 bucket 头后。此时必须允许“只登记 ID、尚未加入 semaphore 全局链”的临界区内部阶段，不能提前要求外部全局一致性。
7. 写 value=val；初始化 pend_list 为 self-cycle；把 sem->link 加到 k_sem_list 头后。至此完整对象由 manager ID-chain、semaphore list 与 object payload/padding 分工拥有，不能重复拥有同一 link slots。
8. CriticalAreaUnLock 的真实操作为：若 nest>=1 则 --，否则保持0；然后 EnableLocalInterrupt(lock) 恢复保存的真实状态。若原 nest=65535，则 lock后0、unlock后仍0；其他原 nest 恢复原值。应区分 IRQ restored 与 arithmetic nest restored。
9. 成功解锁后只有 if(0) 日志和 `return id`，不再 load sem；不存在对已经交回全局 invariant 的对象额外取值。成功返回0..127，创建位置为全局和对应 bucket 的头后；输入 val 覆盖所有 uint16 值。

底层链表 insertion 原顺序严格保持：写 old-next->prev，写新节点next，写head-next，写新节点prev。empty-list 时 old-next==head 是合法 alias，不可要求 head 与旧next分离。新节点与已拥有链独立；InitDoubleLinkList 只要求完整两个指针槽，不依赖旧值。

AllocId 第一个循环 invariant 应描述已扫描 byte 全满、未扫描部分保留；第二个循环描述临时 entry 的右移视图、已经经过的 low bits为1、原位图尚未改变。随后恰好 OR 一个位；其他15 byte以及选中byte其余位不变。没有阻塞等待；唯一无限路径是 helper 的 NULL debug guard。

## 模块全体函数与生命周期

已读取 semaphore.c 全部实现；公开五个 wrapper 都只含空 KDEBUG 宏和唯一对应 done dispatch。

| 内部实现 / wrapper | 分支、读写、资源与副作用 |
|---|---|
| _SemaphoreCreate / KSemaphoreCreate | 如上：uninitialized private → zero private → ID staged → fully published；失败前不发布，失败后回收 |
| _SemaphoreDelete / KSemaphoreDelete | id<0直接返回；临界区内IdGetObj失败则解锁返回；找到后依据pend_list是否空唤醒全部waiters，IdRemoveObj清bitmap并摘ID链，摘全局link；解锁后free；有waiter则DO_KTASK_ASSIGN。对象只能在从两个管理容器移除后回收 |
| _SemaphoreObtain / KSemaphoreObtain | id<0或无对象返回-ERROR；先换算msec为ticks；value>0则--后解锁返回EOK；value=0且wait_time=0解锁返回-ETIMEOUT；否则记录当前task->exstatus=EOK、按优先级挂pend_list、正wait_time设delay，解锁调度后返回task->exstatus。等待链 payload 对应真实task资源，不是裸地址集 |
| _SemaphoreAbandon / KSemaphoreAbandon | id<0/无对象失败；有pending时唤醒首个waiter，不增value；无pending时uint16 value++（包括65535→0）；解锁后按需调度，返回EOK |
| _SemaphoreSetValue / KSemaphoreSetValue | id<0/无对象失败；旧value==val解锁直接EOK，保留waiters；不等时若pending非空则全部唤醒，然后value=val（即使val=0也执行），解锁后按需调度 |

因此模块抽象状态应保留 value、ID映射、全局对象次序、bucket次序/未初始化状态、pending任务次序与关联任务资源，另有stable manager/done配置和 padding ownership。并非只有创建所涉及的value与指针。

跨模块必要上下文读取 `kernel/thread/data_queue.c:33-70` 的 InitDataqueue：它在自己 CriticalAreaLock 之后调用两次 KSemaphoreCreate，最后统一解锁。这是当前源码真实 nested caller，足以排除“初始必须IRQ enabled / nest=0”的未经依据限制。它本身不加入创建闭包，也不归 semaphore predicate 拥有。

## 切片归一与当前设计交付

九个 nontrusted 已各有唯一 `annotated_C/src/<symbol>.c`，各保留完整active body；`annotated_C/include/types.h` 是完整相关 struct 字段的 ABI 保持声明，没有 unrelated kernel tree。

- `_SemaphoreCreate`、AllocId、InsertObj 的 static 转 slice external；非 SMP 两个 critical 函数选取条件编译后的真实定义。
- `done.SemaphoreCreate` 唯一 dispatch 直接解析为 `_SemaphoreCreate`；不改变调用参数/结果。
- 空 KDEBUG 替为空语句；IRQ宏变为真实callee；NULL guard 与debug日志宏逐项展开，诊断字符串/function/原始line保持。宏的 do/while(0)、while(1)、if(0) 及 helper 各 return 均保留。
- 未运行 symbolic、VC、verification-orchestrator，也未证明 C 实现。切片初始只提供 C body，正式 canonical/caller-local specs 由主作者补全；源码分析本身不代表审阅通过。

根共享库现有 `SemaphoreInv.v`、`CrtosGlobState.v`、`CrtosInv.v`、`CrtosRules.v`、`idnode.v`、`dll.v`、`StructFieldOffsetAxiom.v` 可供正式作者逐项复用检查；本分析不把存在于库中的声明或公理当作已经证明的结论。
