# KSemaphoreCreate 本次独立源码分析

本报告只依据本次读取的 `Ubiquitous/XiZi_IIoT_Macro` 权威源码和
`board/stm32f103-nano/config`；未读取、检索或依赖任何其他 trial。
当前 trial：`ksemaphorecreate-trial-261019-2`。这是设计阶段源码证据，不是实现证明。

## 配置、类型及可重复证据

board config 启用 KERNEL_SEMAPHORE，未启用 ARCH_SMP；config.mk 指定
`-mcpu=cortex-m3 -mthumb`。ID_NUM_MAX=128，ID_HTABLE_SIZE=16，ENOMEMORY=5。
`xs_base.h` 定义 uint8=unsigned char、uint16=unsigned short、int32=signed int、
x_base=long、x_size_t=unsigned long。目标是 Cortex-M3 ILP32。

`checks/source-hashes.json` 固定本次全部分析源、配置和关键 headers 的 SHA256。
`python3 checks/source_slices.py` 默认只读复核 hashes、types 和9个 active body 的 C token；
忽略注释（含 QCP 注解），不改任何文件。`--initialize` 全部用独占创建，已有文件会失败，
不能覆盖主 agent 已写的注解。无目录遍历、旧 trial 搜索或 trusted body 读取。

`checks/check_abi.py` 从该 board config 生成检查专用 xsconfig.h，对权威 xs_sem.h 和
切片 types.h 使用同一份 `abi_assertions.h` 编译，再对9个切片做 C 语法检查。
结果保存在 `checks/abi-compile.txt`：全部通过 `gcc -m32 -std=c11 -ffreestanding -Wall -Werror`。
这是实际编译的 ILP32 字段布局证据；环境 PATH 无 ARM cross compiler/clang，不声称
已经执行 ARM 目标编译或机器码等价性检查。无 parser/symbolic/VC/orchestrator 执行。

| 对象 | 大小/对齐 | 实际字段偏移 |
|---|---|---|
| DoubleLinklistType | 8 / 4 | node_next 0，node_prev 4 |
| IdNode | 12 / 4 | uint16 id 0，link 4；padding 2..3 |
| IdManager | 12 / 4 | uint16 id_max 0，uint16 hoffset 2，id_map 4，htable 8 |
| Semaphore | 32 / 4 | id 0，uint16 value 12，pend_list 16，link 24；padding 14..15 |

Semaphore 包含两处 padding（id 内 2..3、自身 14..15），memset 触及全部32字节。
不得用仅字段的 ownership 冒充完整 allocator 对象。pending list 与 global list、id hash
list 是三个不同的链表链接，分别位于16、24、4，不能重复占有。

DECLARE_ID_MANAGER 产生 `k_sem_id_manager`、16字节
`__id_map_k_sem_id_manager` 和16个节点/128字节 `__htable_k_sem_id_manager`。
初始 bitmap、hash 数组均静态零初始化，manager 指向这两个数组；hash bucket 初始不是自环。
`k_sem_list` 静态初始化为自环。manager配置和数组地址创建期间不变。

## 全模块对象生命周期和访问

已完整读取 semaphore.c 的5个实现函数、5个公开包装及 done 表。所有 wrapper
`KSemaphore{Create,Delete,Obtain,Abandon,SetValue}` 分别调用唯一对应的下划线实现。
文件内 static done 初始化后无写入，未导出地址，目标 dispatch 唯一。

| 实现 | 分支、返回及对象访问 |
|---|---|
| _SemaphoreCreate | malloc NULL返回-5；否则整块清零、临界区分配id；id失败free后unlock返回-5；成功写value、初始化pend自环、加入全局list、unlock返回id |
| _SemaphoreDelete | id<0直接返回；查不到id则unlock返回；有对象时非空pend被ResumeAll唤醒，删除id/bitmap/hash与全局link，unlock后free；有等待者才调度 |
| _SemaphoreObtain | id<0或查不到返回-ERROR；msec=-1原样，否则换算tick；value>0则减1并成功；value=0且wait_time=0则-ETIMEOUT；否则当前task.exstatus=EOK，按priority插入pend，正timeout设delay，unlock后调度，返回task.exstatus |
| _SemaphoreAbandon | id<0或查不到返回-ERROR；pend非空唤醒第一个task，value不增；否则uint16 value++（65535回绕0）；unlock，有唤醒才调度，返回EOK |
| _SemaphoreSetValue | id<0或查不到返回-ERROR；value相等则直接unlock/EOK；不等时有等待者即全部唤醒，即使新val=0；写value=val、unlock、按需调度，返回EOK |

模块本身没有迭代所有对象的循环。pend 操作的上下文 `kernel/thread/linklist.c` 已完整读取：
Suspend 先 SuspendKTask，然后通过 task_dync_sched_member.sched_link 按优先级插入；
Resume 用 pend 首个节点恢复 task；ResumeAll 循环读取首节点、给该 task.exstatus=-ERROR，
KTaskWakeup 移出节点直到 pend 空。该循环的进展依赖每次唤醒移除当前首节点。
这些 task 调度/延迟资源属于任务系统，不应让 Semaphore 的 ownership 重复拥有整个 task。
创建新对象时 pend 必为空；既有对象可有等待者，其资源需完整保留。

删除回收和 id 重用说明对象身份不能只靠裸地址或永久固定id；管理集合需要表达有限活动对象、
唯一id、bitmap一致性、每个hash bucket对应 id%16，以及global list中每个活动对象恰一次。
每个bucket须允许 untouched zero 状态或 initialized circular 状态；查询 GetObj 也会把
zero bucket变为空自环。FreeId清bit、RemoveObj移除hash节点，IdRemoveObj最后给uint16 id赋-1
（65535），但对象随后从global list脱链并free，这不是活动对象id范围。

`kernel/thread/data_queue.c` 的 InitDataqueue 在已持有 CriticalAreaLock 时调用
KSemaphoreCreate，因此初始IRQ关闭/临界区嵌套是真实caller情形，不能无据只准IRQ开启。
它以 `!sem_id` 判断创建失败，和合法id=0不符；这是外部caller上下文问题，不改写目标语义，
也不扩大本次目标闭包。已有生命周期函数接受int32 id并隐式转换uint16给IdGetObj，
故超范围正id可能截断；它们不进入本次create闭包，不以其接口说明代替实际实现。

## 从目标重新追踪的完整递归闭包

| 唯一 canonical symbol | 权威定义 | 实际调用（含宏） |
|---|---|---|
| KSemaphoreCreate | semaphore.c:246 | done.SemaphoreCreate唯一解析为_SemaphoreCreate |
| _SemaphoreCreate | semaphore.c:33 | x_malloc，memset，CriticalAreaLock，IdInsertObj，失败时x_free，InitDoubleLinkList，DoubleLinkListInsertNodeAfter，CriticalAreaUnLock；if(0)日志中KPrintf |
| CriticalAreaLock | CriticalArea.c:117（非SMP） | DISABLE_INTERRUPT→DisableLocalInterrupt |
| CriticalAreaUnLock | CriticalArea.c:132（非SMP） | ENABLE_INTERRUPT→EnableLocalInterrupt |
| IdInsertObj | id.c:106 | NULL_PARAM_CHECK→KPrintf/无限loop；AllocId、InsertObj |
| AllocId | id.c:24 | NULL_PARAM_CHECK→KPrintf/无限loop |
| InsertObj | id.c:62 | NULL_PARAM_CHECK→KPrintf/无限loop；InitDoubleLinkList、DoubleLinkListInsertNodeAfter |
| InitDoubleLinkList | double_link.c:30 | 无 |
| DoubleLinkListInsertNodeAfter | double_link.c:42 | 无 |

对应 `annotated_C/src/<symbol>.c` 每项恰有一个完整 active definition。
只停止于用户批准的6个 trusted symbols：x_malloc、x_free、memset、DisableLocalInterrupt、
EnableLocalInterrupt、KPrintf；未读取它们的实现。其调用前声明由 main 补 canonical合同。
未把 CriticalArea wrappers 当作 trusted，也未把空宏虚构成函数。

`xs_kdbg.h` 无条件 `#define KERNEL_DEBUG`，覆盖board config“debug未启用”的直觉：
NULL_PARAM_CHECK 实际先判断NULL，NULL时KPrintf后while(1)无限执行。不能删掉阻塞路径。
目标传的manager/idnode在正常对象前置条件下非空；底层合同应说明该约束对应可访问对象，
而不是把真实源分支删去。semaphore.c 在include后局部undef/redefine
KDEBUG_NOT_IN_INTERRUPT为空，所以wrapper不调用isrManager或IRQ宏。
KDBG_IPC=0，SYS_KDEBUG_LOG虽展开出KPrintf，实际if(0)不可达。

## 创建路径、底层操作与证明边界

1. malloc失败：返回-5，未加锁，未触及全局manager/list/IRQ nest；所有既有资源不变。
2. malloc成功：拿到完整未初始化32字节独占对象，memset后整个32字节零；随后加锁。
3. AllocId失败：map已满时index=end，返回-1；通用manager还存在首个零bit超id_max路径。
   失败前没有bitmap写入，IdInsertObj也不写idnode；因此对象仍完整zero且未发布。
   `_SemaphoreCreate` 在锁内free该对象，再unlock恢复IRQ，返回-5。
4. AllocId成功：取扫描到的第一个非255byte的最低零bit，置该bit；IdInsertObj写uint16 id，
   InsertObj取htable[id%hoffset]，node_prev为NULL则先自环初始化，再头后插入idnode.link。
   此时是“已分配id/hash可见、尚未global list发布”的中间状态，不能要求完整稳态不变量
   在每个store后成立。caller仍持有critical资源，最后value=val、pend自环、global list
   头后插入完成统一发布；unlock后返回原id。对128配置成功id恰最低空位0..127。

AllocId第一循环：0<=index<=ceil(id_max/8)，所有先前byte=255，bitmap未改；id_max uint16
使(id_max+7)在32位int范围内。第二循环：entry由首个非255byte逐次右移，已跳过位均为1，
id=index*8+已移位数；最多7次后见零，不溢出int。最后只改对应一个bitmap字节。
hash取模要求hoffset>0且table足够，实际manager固定16满足。支持通用manager的spec若写
弱于真实capacity需另行审查；不得将目标128/16事实泛化为所有manager。

InitDoubleLinkList写head.next=head和head.prev=head，独占两个指针字段即可；
DoubleLinkListInsertNodeAfter按源码顺序先改旧next.prev，再设置新node.next、head.next、
新node.prev。head与旧next允许同一节点（空自环），不能无据要求三地址全异；新node须
独立未入链。只展开局部view时必须保留其余节点、对象与padding。

非SMP CriticalAreaLock先DisableLocalInterrupt保存真实IRQ状态，再uint16 nest++；
CriticalAreaUnLock仅当nest>=1时减1，随后EnableLocalInterrupt(lock)恢复保存状态。
nest=65535时lock发生模65536回绕0；接着unlock不减，最终nest为0而非65535。
这不是实现中的检查或失败路径，不能把它误写成总是nest原值恢复。设计须表达该真实状态转移，
或由已审阅全局协议解释合法nest范围，不能仅为通过spec排除边界。
IRQ已关的嵌套加锁不得再次复制全局资源；IRQ开启首次关闭才取出受保护资源，恢复开启时归还；
这部分trusted合同依据用户明确语义及全局协议，非该C源码独立证明。

## 已实施切片归一及限制

仅9个函数由本次权威源码提取，不复制整个内核或libc。types.h保留完整真实字段顺序，
没有删去影响offset的字段。memset声明来自xizi.h包含的string.h；xs_base.h的size_t定义在
`#if 0`内不能作为依据。切片通过标准stddef.h使用当前目标编译器size_t，不猜newlib具体typedef；
ILP32编译检查只确认当前编译模式，未确认缺席的ARM工具链头文件。局部static函数改slice external，以便分文件契约调用；
KTaskOsAssignLockNest也以统一extern表示同一个真实static对象，不为每slice创建副本。
done唯一dispatch归一成直接调用。IRQ宏展开成真实批准函数；空KDEBUG宏归一为空语句。
NULL_PARAM_CHECK展开成原控制流，KPrintf中的原函数名/行号/参数字符串固定为原源信息。
KDBG_IPC日志保留if(0)展开及两次KPrintf，原__func__/__LINE__固定为_SemaphoreCreate/59。
没有改算法、分支、返回值、字段操作、位运算、释放顺序或critical计数溢出语义。

提取时没有添加spec。main负责canonical与caller-local完整合同；其后只读token重验可检查
注解添加没有改变C body。source hashes和token检查只支持已列出的归一，不能取代独立spec审阅。

## 根共享库缺失依赖的本轮补建依据

按main和predicate作者的额外委派，当前trial新建 `libai/TaskStatus.v`、`TickOrder.v`、
`NodeSelfLinked.v`，只提供根库当前引用的最小透明定义。没有读取旧trial或补公理。
TaskStatus的五构造来自当前xs_ktask.h和ktask_stat.c的0..4状态；该类型不包含stat高五位。
NodeSelfLinked使用candidate CrtosRules同一assertion carrier拥有两个self指针槽，
对应double_link.c初始化/脱链结果，没有重新实例化空间逻辑。
TickOrder依据当前delay.c:74的普通unsigned `<`插入，tick_not_after定义为数学`<=`；
这与根KTaskDelay中“回绕排序”旧注释不一致，已通知predicate作者同步候选注释。
delay.c:134的模差值过期检查是另一比较，不能据此推断插入也采用回绕序。
补充源码hash见`checks/dependency-source-hashes.json`。纯两文件已coqc通过，记录见
`checks/pure-dependency-compile.txt`；NodeSelfLinked由predicate作者随共享carrier编译。
