# KSemaphoreCreate 本轮独立源码分析

本分析只读取当前权威 `Ubiquitous/XiZi_IIoT_Macro/`、当前共享 `lib/` 与 skill 指南；未读取任何历史 trial。目标为指定 `board/stm32f103-nano/config` 的 Cortex-M3、32 位 ILP32、非 SMP。分析不是实现证明。源码范围内未发现额外 AGENTS.md。

## 配置、宏与 ABI

`board/stm32f103-nano/config.mk:3` 明确 `-mcpu=cortex-m3 -mthumb`。`config` 开启 KERNEL_SEMAPHORE，关闭 ARCH_SMP，ID_NUM_MAX=128、ID_HTABLE_SIZE=16。使用权威 `tool/hosttools/xsconfig.sh` 从指定 config 生成本 trial `checks/xsconfig.h`，未用其他 board 或历史配置。

端序由选定 Cortex-M3 ARM GCC 默认配置确定为 little endian；config.mk 未启用 `-mbig-endian` / `__ARMEB__`，board `include/cmsis_gcc.h:1930` 按 `__ARMEB__` 区分大小端，`include/arm_math.h:121` 说明默认小端。共享模型若实例化 BigEndian，不能直接声称是此 ABI，须候选修正并类型检查。

实际 `xs_kdbg.h:36` 无条件定义 KERNEL_DEBUG，覆盖 config 中 debug 未开启的表面印象：NULL_PARAM_CHECK 会展开为 NULL 时 KPrintf 再 while(1)。`semaphore.c:24–28` 又局部将 KDEBUG_NOT_IN_INTERRUPT 定义为空；不能由入口推出 task context / ISR counter=0，也不能添加这些 Require。KDBG_IPC=0，成功后的日志预处理为 `do { if (0) { KPrintf(...); KPrintf(...); } } while (0)`，无运行时效果。DISABLE_INTERRUPT 与 ENABLE_INTERRUPT 分别是 DisableLocalInterrupt / EnableLocalInterrupt 的对象宏（xs_isr.h:87–88）。DECLARE_ID_MANAGER 只创建静态存储对象，无函数调用。

ABI 直接引用实际 xs_sem.h、xs_id.h、xs_klist.h、xs_base.h，通过 gcc -m32 的 `_Static_assert` 检查（`checks/abi-check.c`、`abi-check.log`）。环境无 ARM cross compiler；ILP32 宿主布局检查加 Cortex-M3 自然布局审查是此处替代方案，并不声称运行了 ARM 编译器。此组结构仅含 unsigned short 和自然对齐32位指针，所检查布局与指定 ARM32 ABI一致。

| C 对象 | 大小/对齐 | 字段偏移 |
|---|---|---|
| DoubleLinklistType | 8/4 | next=0, prev=4 |
| IdNode | 12/4 | id=0, padding=2..3, link=4 |
| Semaphore | 32/4 | id=0, value=12, padding=14..15, pend_list=16, link=24 |
| IdManager | 12/4 | id_max=0, hoffset=2, id_map=4, htable=8 |

Semaphore 对象有两段共4字节 padding（2..3 和14..15），malloc/memset/free 的完整32字节 ownership 必须覆盖它们。id map为16字节；哈希表16个8字节桶头，共128字节。SemaphoreDoneType有5个32位函数指针，共20字节；create槽固定指向 _SemaphoreCreate。done 为本翻译单元 static，所有引用仅初始化和各 wrapper读取，未取地址或写入，故 dispatch 唯一可解析。

## 完整递归调用闭包

所有位置相对权威树，exact active body、源文件 SHA256、源行号、预处理和等价归一保存在 `checks/source-bodies.json`，由 `checks/extract_source.py` 重新生成。

| 非 trusted symbol | 权威定义 | 直接 callee（宏展开后） |
|---|---|---|
| KSemaphoreCreate | kernel/thread/semaphore.c:246 | _SemaphoreCreate（done dispatch） |
| _SemaphoreCreate | kernel/thread/semaphore.c:33 | x_malloc, memset, CriticalAreaLock, IdInsertObj, x_free, CriticalAreaUnLock, InitDoubleLinkList, DoubleLinkListInsertNodeAfter；KPrintf 仅 if(0) 日志 |
| CriticalAreaLock | kernel/thread/CriticalArea.c:117 | DisableLocalInterrupt |
| CriticalAreaUnLock | kernel/thread/CriticalArea.c:132 | EnableLocalInterrupt |
| IdInsertObj | kernel/thread/id.c:106 | AllocId, InsertObj；NULL诊断KPrintf |
| AllocId | kernel/thread/id.c:24 | NULL诊断KPrintf |
| InsertObj | kernel/thread/id.c:62 | InitDoubleLinkList, DoubleLinkListInsertNodeAfter；NULL诊断KPrintf |
| InitDoubleLinkList | kernel/thread/double_link.c:30 | 无 |
| DoubleLinkListInsertNodeAfter | kernel/thread/double_link.c:42 | 无 |

唯一 trusted 集合是 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf，未读或递归处理其函数体。KPrintf即使在正常入口不可达也需 caller-local emp→emp contract。无 bitmap.c 函数调用，无调度器调用，无其他 done-table dispatch。宏不是新 canonical 函数。低层的 NULL 分支在实际创建闭包中由有效 manager/address 与 malloc-success对象资源排除；需保留真实 body，以资源依据说明不可达，不能用空宏替换调试检查。

## 每条实际路径及读写

1. x_malloc(32)失败：返回 -ENOMEMORY=-5；未进入临界区，没有对象 ownership，协议外状态和真实 IRQ 原状返回。
2. malloc成功：32字节未初始化私有对象经 memset(sem,0,32) 成为完整全零私有对象。进入临界区前对象未发布，不借用受保护全局资源。
3. CriticalAreaLock：先 DisableLocalInterrupt 保存旧硬件状态并关中断、按照协议取得全局资源，再 KTaskOsAssignLockNest++。入口协议外的 nest=0，因此进入后是1；无整数溢出要求。硬件初始状态可以已关闭，不能将协议外解释为 IRQ enabled。
4. IdInsertObj失败：AllocId扫描16字节均0xff返回 -1，或者一般代码的 id>=id_max 分支返回 -1。当前128上界整除8，后一检查不会在第一个非ff字节后失败，但保留源body；不加容量未满 Require。失败未写 bitmap、idnode或桶。x_free 在临界区内消费完整全零且未发布对象，然后 CriticalAreaUnLock将nest1降为0，EnableLocalInterrupt恢复保存状态并交还全局资源，返回 -5。
5. IdInsertObj成功：AllocId 找第一个非0xff字节与其中最低零位，恰好最小空闲ID（0..127），仅将该位设1；IdInsertObj写 sem.id.id（16位写，不修改padding），InsertObj按 id%16 选择桶，若桶prev==NULL则初始化该全零桶头自环，再将 sem.id.link 插到桶头后。此阶段 manager 中已有新ID和哈希节点，但 semaphore 的 value/pend/global link 尚未最终建立，需局部 pending/partial publication 状态。
6. 创建成功继续：写 sem.value=val，初始化 sem.pend_list 自环，将 sem.link 插入 k_sem_list 头后；完成全部双索引和完整对象不变量。CriticalAreaUnLock恢复nest和IRQ并归还共享对象，最后返回ID。外部环境在解锁后可以继续运行，不能在顶层 Ensure 给调用者已经归还的对象所有权，亦不能无协议根据保证返回时该 ID 永远仍存在。

AllocId 循环：第一循环不变量为已检查字节全0xff且0≤index≤16；第二循环entry为原字节右移次数，已经经过的低位均1，当前位置为首个0、最多7次。位移id%8∈[0,7]，整型提升安全。Canonical可按128/16实际实例写，不需假设任意不受支持尺寸。InsertObj的hoffset=16保证取模非零，bucket 允许全零懒初始化或有效双向环。DoubleLinkListInsertNodeAfter对空链时 `head->next=head` 的合法别名必须支持，不能机械要求head与successor分离。

非SMP CriticalAreaUnLock 的 C 本体含 `if (nest>=1) nest--`；当前创建路径的调用前已知nest=1，不能将这一调用状态错误替换为协议外。低层ID/list函数运行于inside，Require由其接收局部资源描述；无需也不应统一附加OutsideCritical。

## 模块生命周期背景

已读取 semaphore.c 全部实现以理解持久状态：delete在临界区查ID，唤醒pend链表中的任务，移除ID索引与global list，解锁后free；obtain在value>0时减1，否则可能挂起任务并建立delay；abandon优先唤醒等待者，无等待者时value++；set-value可唤醒等待者并修改value。它们仅提供状态设计依据，不是本次创建闭包。已读取 id.c 的查询/删除实现：桶头按需初始化，remove先清bitmap再移除链节点。此事实支持全局bitmap、桶、对象列表之间一致性与对象生命周期，不允许将所有既存sem都假设为空等待链。

## 等价归一边界

提取器从真实源中选择非SMP active CriticalArea定义，使用当前实际headers宏展开；static helper仅移除static以适配独立切片，KSemaphoreCreate唯一解析dispatch为直接 _SemaphoreCreate。JSON中 raw/preprocessed/normalized 并存以供spec审阅。若spec另做 parser 拆句、typedef同义替换、删除纯空语句、或常量if简化，需要在spec等价检查中逐项说明；这里未对算法、条件、返回值、writes作替换。

所有构建输入仅权威header和当前trial checks，不含任何历史trial load path/产物。此阶段未运行symbolic、VC或verification-orchestrator。
