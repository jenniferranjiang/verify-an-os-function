当前权威源码中的创建路径与用户批准的功能目标一致，递归闭包只有九个待证明函数和六个已批准 trusted 符号。这里记录的是源码分析和 ABI 检查，不是 predicate/spec 审阅通过或实现已经验证。真实 headers 已由 arm-none-eabi-gcc 13.2.1 使用 `-mcpu=cortex-m3 -mthumb` 编译通过全部静态断言，并通过 ARMv7-M/Thumb 宏检查。无需修改权威源码或请求用户改变目标。

## 当前来源与复现

权威根为 `Ubiquitous/XiZi_IIoT_Macro`，固定 `board/stm32f103-nano/config`。`evidence/source-manifest.json` 对本次实际依赖的源码、配置、headers 及必要跨模块上下文逐一 SHA-256；本次 revision 为 `source-r2-0c50c37013e9`，manifest SHA-256 为 `0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651`（47 个输入文件）；详情见 `evidence/source-check-result.json`。用户给出的历史身份 `source-s2-2adc70fc1afc` 只是历史提示，没有用于判定当前字节相同。本工作没有进入任何旧 trial；检查脚本只接受当前权威根与本新 trial 的明确路径，没有遍历 CRTOS 根目录。

复现：`python3 ksemaphorecreate-trial-261012-1/evidence/source-check.py`。脚本调用权威 `tool/hosttools/xsconfig.sh`，仅在本 trial 的 `evidence/source-config/` 生成 `xsconfig.h`，不修改仓库 board/default 配置。它编译 `source-abi.c`、预处理四个闭包 TU、记录宏、扫描递归闭包并生成 manifest。ABI 编译器默认 `/tmp/crtos-arm-toolchain/root/usr/bin/arm-none-eabi-gcc`，可通过 `ABI_CC`、`ABI_FLAGS` 指定同等 ARM 编译器；目标宏和静态断言必须仍通过。编译止于 `-S` 生成 ARM 汇编，不依赖链接器或目标运行环境。四个 `.i` 使用本机 GCC 的系统 libc headers 进行源级宏展开；这些结果不充当 ARM 类型或 libc ABI 证据，布局来自独立的真实内核 headers 编译。

当前配置启用 semaphore、event、mutex、RR_REMAINSLICE、32 个 task priority、shell、Newlib，禁用 SMP、separate compile 和 task isolation。`config.mk` 明确 `-mcpu=cortex-m3 -mthumb`。`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`，bitmap 为 16 字节，bucket 数 16。配置虽然不启用 KERNEL_DEBUG，真实 `xs_kdbg.h:37` 仍无条件定义它，不能删除 NULL_PARAM_CHECK。源码 `semaphore.c:24–28` 单独取消 `KDEBUG_NOT_IN_INTERRUPT`；`KDBG_IPC=0` 使日志分支为常假。

本次 r2 manifest 仅将独立审阅查明的 `kernel/thread/data_queue.c` 外部嵌套调用者纳入来源集合，原46个文件字节未变；r1 manifest/result保留在 `evidence/source-r1-snapshot/`。InitDataqueue 持外层锁调用 create，因此不能把目标入口无依据限定为 nest=0。当前 predicate review 的 PR-01/PR-03 处理嵌套协议与计数边界，本文开头的源码扫描结论不代表这些 formal 适用范围问题已经解决。

## 布局与字节

静态断言直接包含权威 `xs_sem.h`、`xs_ktask.h`、`xs_assign.h`，不重写任何 struct。

| 对象 | 字段/范围 | ILP32 offset 或大小 |
|---|---|---|
| Semaphore | id.id | 0，2 字节 |
| Semaphore | id 内 padding | 2–3 |
| Semaphore | id.link.node_next / node_prev | 4 / 8，各 4 字节 |
| Semaphore | value | 12，2 字节 |
| Semaphore | padding | 14–15 |
| Semaphore | pend_list.node_next / node_prev | 16 / 20 |
| Semaphore | link.node_next / node_prev | 24 / 28 |
| Semaphore | sizeof | 32 |
| IdManager | id_max / hoffset / id_map / htable | 0 / 2 / 4 / 8，sizeof 12 |
| IdNode | id / link | 0 / 4，sizeof 12 |
| DoubleLinklistType | next / prev | 0 / 4，sizeof 8 |
| TaskDescriptor | cur_prio / sched_link / exstatus / id | 6 / 16 / 88 / 100，sizeof 116 |
| Assign | os_running_task / ready_vector_done / current_priority | 264 / 268 / 272，sizeof 276 |

指针、int、long、x_base 和 x_size_t 均 4 字节；short/uint16 为 2 字节，char/uint8 为 1 字节。`x_size_t = x_ubase = unsigned long`，在本 ILP32 ABI 下可按获准的 unsigned 32-bit 表示正规化。两个 padding 区也是 malloc/memset/free 的完整对象字节，不得从 ownership 中遗失。直接字段切片不能用删掉前置字段的简化 TaskDescriptor 冒充真实 offset。

## 创建递归闭包

`evidence/source-closure.json` 保存由当前预处理函数体重新扫描的直接调用图，`source-bodies.json` 保存九个源函数体。静态 done table 只有一个 `.SemaphoreCreate = _SemaphoreCreate` 初始化，TU 没有后续赋值或地址逃逸；宏清空后 KSemaphoreCreate 仅调用该唯一实现。

| 非 trusted 函数 | 当前调用及访问 |
|---|---|
| KSemaphoreCreate | 空 KDEBUG 宏；唯一 `_SemaphoreCreate(val)` dispatch |
| _SemaphoreCreate | malloc 32；清零 32；进入临界；ID 插入；失败 free 然后退出并返回 -5；成功写 value、初始化 pending head、插入 registry、退出、返回 ID |
| CriticalAreaLock | DisableLocalInterrupt；读写 uint16 静态 KTaskOsAssignLockNest，递增；返回 IRQ handler |
| CriticalAreaUnLock | 读 nest；若 >=1 则递减；EnableLocalInterrupt(handler) |
| IdInsertObj | 对 manager/idnode 的检查；AllocId；失败不写 idnode；成功写 idnode.id、InsertObj 并返回 ID |
| AllocId | 检查 manager；读 id_max/id_map；先扫非满 bitmap 字节，再扫其低位零；ID 越界/满时不写；成功置该位 |
| InsertObj | 检查 manager/idnode；读 htable、hoffset、idnode.id；若 bucket.prev==0 则初始化 bucket；插入 idnode.link |
| InitDoubleLinkList | 两次 store，将 next/prev 都设为自身 |
| DoubleLinkListInsertNodeAfter | 更新原 next.prev、新节点 next、head.next、新节点 prev；不调用其他函数 |

六个截止点严格为 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf。未新增 trusted。KPrintf 在 ID 函数空指针检查的失败分支中可达，之后是真实 `while (1)`，不能删掉无限路径。caller 的有效 manager/node ownership 足以排除该路径；低层函数本体仍应保留该语句。源中的 DEBUG 日志虽产生 KPrintf 调用，但 KDBG_IPC=0 分支可按本次批准删除。

AllocId 外循环保持 `[0,index)` 字节全为 255、未修改 bitmap、index<=end；找到字节后内循环保持 `id=index*8+k`、已越过 k 个 1 位、`entry=原字节>>k`，非满字节保证 k<=7 并终止。本配置 128 整除 8，id>=id_max 分支仍保留以忠实反映源码；泛化 manager 时它承担末尾 padding bit 的失败保护。ID 首空闲性是按字节升序、位从低到高的源码结论。

malloc 失败尚未关中断，返回 -5。ID 失败发生在临界区，且 AllocId/IdInsertObj 没改 bitmap 或对象，故对象仍是完整清零私有对象，满足批准 free 语义；free 后再 unlock。成功有一个在临界区内的中间阶段：ID 已进入 bitmap/bucket，但 value、pending、registry 尚未完成；设计必须表达该暂态，而不能提前断言对象完整发布。注册完成后才可闭合稳定 invariant。创建函数自身不读写 task/scheduler 资源；关中断前环境可能推进统一 OS state，应由批准 rely contract 表达。

非 SMP 的 critical wrapper 不是空包装：它拥有并修改全局 nest。Cortex-M3 `arch/arm/cortex-m3/interrupt.c:25–36` 使用 PRIMASK 的 MRS/CPSID/MSR，返回旧屏蔽位，恢复原位。IRQ trusted contract 必须在真实原子边界取得/释放 invariant；不能把原子边界挪到 CriticalAreaLock 外层。uint16 nest 递增具有模 65536 行为；要求 nest 保持非溢出须由真实协议可达状态论证，不能无依据加调用前提。

## semaphore 模块全部函数与生命周期

模块为 `kernel/thread/semaphore.c` 的五个 static 实现与五个 KSemaphore 公共 wrapper。五个 wrapper 各自只做空 debug 宏及唯一 done 调用，没有独立字段访问或生命周期。done 表由本 TU 静态初始化且不修改。以下删除、obtain、abandon、set-value 是为设计模块完整状态读取的上下文；本次证明入口仍只有 create，不把它们的 callee 作为 trusted 或冒充已验证。

| 实现 | 真实路径、访问和副作用 |
|---|---|
| _SemaphoreDelete | id<0 直接返回；临界内 IdGetObj 不存在则 unlock；存在则从 idnode 得 sem；读 pending 空性；非空时 LinklistResumeAll；IdRemoveObj 清 bitmap、摘 ID link、写 id=65535；摘 registry；unlock；free 整个已摘除对象；必要时调度 |
| _SemaphoreObtain | id<0 返回 -1；msec==-1 保留无限等待，否则转 ticks；临界内 lookup；不存在返回 -1；value>0 则减一并返回0；wait_time==0 返回-2；否则取当前 task、写 exstatus=0、按优先级挂起到 pend_list；正等待调用 KTaskSetDelay；unlock、调度，再返回 task.exstatus |
| _SemaphoreAbandon | id<0/lookup 失败返回-1；有等待者则 LinklistResume 第一个；否则 uint16 value++（65535 之后按 C 转换变0）；unlock；有唤醒则调度；返回0 |
| _SemaphoreSetValue | id<0/lookup 失败返回-1；value==val 时只 unlock 返回0；不等且有等待者时 ResumeAll，不管 val 是否为0；写 value=val；unlock；必要时调度；返回0 |

初始 globals：manager 指向 16-byte 零 bitmap 和 16 个全零 bucket；registry head 自环。bucket 是 lazy init：GetObj/InsertObj 看到 prev==NULL 才自环初始化，故稳定状态既可含零 bucket，也可含初始化空 bucket。对象 lifecycle 包含未初始化私有、清零私有、ID 已安置但尚未完整发布、完整发布、删除摘链后私有、释放；成功发布不能遗留第二份同一字节 ownership，失败必须返还全部32字节。

模块没有直接循环；ID helper 扫 bitmap/桶、pending helper 扫 task 链。Init/Get/Remove/Free ID 的非 create 路径也已读取：GetObj 可初始化空 bucket，循环按 id 查找；RemoveObj 摘环；IdRemoveObj 先释放位再摘节点并将 id 字段赋 -1。合法稳定状态应确保 registry 与 ID/bitmap 一致、每个 id 唯一、桶内 id%hoffset 对应、双链互指、未初始化 bucket 为空。删除后表/registry 不得保留已释放对象指针。

跨模块状态不能并入 semaphore 私有所有权：

- `linklist.c` 的 pending 元素是 TaskDescriptor 内 `task_dync_sched_member.sched_link`，不是另外分配的 sem 节点。SuspendKTask 经 task Done dispatch 从 ready vector 移走、改 stat、撤 delay，再由 LinklistSuspend 将同一节点接到 sem pending list，按 cur_prio 排序。需要同一节点在 ready/pending 生命周期之间移交，不能两侧同时 owns。
- Resume/ResumeAll 经 KTaskWakeup 摘 sched_link、取消 delay、插回 ready vector；ResumeAll 先写 exstatus=-1。timeout 路径由 delay.c/ktask.c 使 exstatus=-2、摘 pending 后重新 ready。task id、exstatus、cur_prio、delay、stat、task name 以及 scheduler 结构仍归统一 task/scheduler 表示；semaphore 只通过所需接口借用/转移关联节点。
- GetKTaskDescriptor 读取 `Assign.os_running_task`，自身会嵌套 critical。KTaskSetDelay 可能分配 Delay 并失败；当前 Obtain 忽略其返回值。CalculateTickFromTimeMs(0) 返回至少1，因此不得只凭文档把 msec=0 建模为必定 nonblocking。SetValue 的“新值正才唤醒”注释也不等于其实际无条件唤醒路径。这里记录实际上下文，不把这些非 create 行为假定成用户尚未要求证明的加强语义。
- 当前配置 shell 的 `ShowSem` 在临界内遍历 registry，读 id/value/pending；`GetSuspendedTask` 遍历任务 sched_link 读 task name。它借用现有共享状态，不形成另一份 owner。这是源码中除 semaphore 模块外直接引用 sem 对象的客户端。

创建只需六份已批准 trusted contracts。删除的 free 对象未必清零，其他模块 malloc 大小也不同；本次 x_free/x_malloc 的 create 专用批准合同不能被冒用为这些上下文函数的通用合同。

## 正规化边界和当前结论

源级依据允许：唯一 done dispatch 直接化、static 函数切片 externalize、空 KDEBUG 删除、KDBG_IPC=0 死分支删除、IRQ 宏展开、真实四参数 NULL_PARAM_CHECK KPrintf 声明正规化、ILP32 x_size_t 等价表示，以及将 IdInsertObj 的赋值条件等价拆句。NULL_PARAM_CHECK 的 KPrintf 参数中 __FUNCTION__/__LINE__ 必须保留权威展开后的值；不能因切片换文件而悄悄改变参数。if-null 后无限循环和所有失败返回都应保留。

目前源码扫描没有发现会强制更改用户 create 语义或增加第七个 trusted 的冲突。ARM ABI 检查已通过；predicate 中的生命周期、全局 critical nest、pending task 借用和每字节唯一 owner 是否真正成立，应由独立 formal review 判定。此报告不替代该门禁。
