# KMutexCreate：C 分析（2026-11-01，全新设计实验）

范围：权威 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c` 全部八个函数用于对象/生命周期分析；本次目标调用闭包仅 KMutexCreate 可达代码。分析不执行 QCP、symbolic、VC 或 C 实现证明。已读 TrustBase、技能 Predicate 指南第1节和源代码处理规则。

## 配置与 ABI

采用项目 `annotated_C/src/include/xsconfig.h` 的既有验证配置：KERNEL_MUTEX、ID_NUM_MAX=128、ID_HTABLE_SIZE=16、KTASK_PRIORITY_MAX=32、RR_REMAINSLICE；无 ARCH_SMP、ARCH_CPU_64BIT。TrustBase 授权的 32 位适配是本结论的配置限制，不声称与 64 位构建无条件等价。

真实 xs_mutex.h 的 Mutex 字段布局（ILP32）：id@0（12字节，uint16 id@0、padding@[2,4)、IdNode.link@4）、val@12（uint16）、recursive_cnt@14（uint8）、origin_prio@15（uint8）、holder@16（pointer）、pend_list@20（DLL8）、link@28（DLL8）；总长36、对齐4。DLL 中 node_next@0、node_prev@4。IdManager 总长12，id_max@0/hoffset@2/id_map@4/htable@8。

`checks/abi_authoritative.c` 直接包含权威 xs_mutex.h 与 xs_memory.h，并静态断言上述布局、32位指针与x_base、配置常量。命令：

```
gcc -m32 -std=c11 -ffreestanding -fsyntax-only -I Ubiquitous/XiZi_IIoT_Macro/kernel/include -I annotated_C/src/include kmutexcreate-trial-261101-1/checks/abi_authoritative.c
```

结果 exit 0。头文件搜索顺序保证类型来源是权威头，xsconfig 来自已有验证配置。共享 `StructFieldOffsetAxiom.v:261,389,391` 已有对应 mutex_field_offset_ok / mutex_size_axiom / mutex_field_offset_axiom，后者有 ALIGN_SIZE 前提；不需要新加布局公理。

## 对象和所有权

DECLARE_ID_MANAGER 展开为静态 manager、16字节零初始化 bitmap、16个零初始化哈希桶（128字节）；容量和桶数固定。哈希桶由 ID 库懒初始化。`k_mutex_list` 静态自环。manager 的 ID 字段和 ID 链节点由公共 ID predicate 拥有；管理链 link 的 next/prev 由公共 DLL 拥有；mutex payload 拥有 val/recursive_cnt/origin_prio/holder、padding、pend_list 与等待任务的 sched_link 节点。等待任务完整 descriptor 仍属于 Task 模块，不能在 mutex 中重复拥有。

可用最小模块逻辑状态为按管理链顺序保存的对象序列，每个对象保存地址、ID、val、recursive_cnt、origin_prio、holder、等待任务地址序列。ID bitmap/哈希桶从对象序列及插入顺序派生，避免第二份权威 mutable manager state；固定地址/容量属于 stable。holder 即使非零只是引用，不在 mutex 中取得 task descriptor ownership。origin_prio 当前写入而恢复优先级代码注释，仍需按实际字段保存；不应因只验证 create 就删掉模块字段。

## 全模块控制流与生命周期

- `_MutexCreate`（27–60）：先分配36字节；null直接 -5，未进入临界区。memset全零后 Lock。IdInsertObj失败（id<0）先 Unlock，再 free 原分配基址，返回 -5。成功先初始化pend自环，再 val=1、holder=0、origin_prio=255、recursive_cnt=0，管理链头插，Unlock，返回ID。没有循环或阻塞路径。malloc前和失败free后的外部时段允许系统环境演进，不能把返回时全局状态强行等同调用前状态。
- `_MutexDelete`（62–75）：非空检查；LinklistResumeAll 唤醒全部等待者（task.exstatus=-ERROR）；进入锁，IdRemoveObj 与管理链移除，解锁，释放对象。涉及等待节点和Task跨模块资源转移。不会检查 holder。
- `_MutexObtain`（77–148）：当前task、等待tick数，然后锁内 task.exstatus=0；相同holder时 uint8递归计数++；可用时 val--、holder=current、origin_prio=task.cur_prio、递归++；不可用且wait_time=0时 task.exstatus=-ETIMEOUT，Unlock返回-2；否则按优先级挂等待链、必要时设delay，Unlock并yield，恢复后若exstatus非0直接返回该值，否则重新Lock，最终Unlock返回0。由恢复方 `_MutexAbandon` 负责转移holder。递归计数为 uint8，源码无溢出保护，不能添加无来源的非零/不溢出模块不变量。
- `_MutexAbandon`（150–203）：Lock后非holder返回-1并写task.exstatus；holder递归计数--，非0仅解锁返回0；变0且有waiter时取pend首task，写holder/origin_prio/递归++，LinklistResume，解锁后yield；无waiter时 val++、holder0、origin_prio255，解锁返回0。现有源码优先级继承/恢复均为注释，不能把它们写成实际效果。
- `KMutexCreate`（222–227）：移除获准 debug 宏后直接调用静态 done.MutexCreate。done 仅205–210初始化，此翻译单元无任何改写/地址逃逸，解析目标唯一 `_MutexCreate`。
- `KMutexDelete`（235–257）：负ID空操作；Lock查询ID，不存在Unlock返回；存在CONTAINER_OF，Unlock后done.Delete。潜在与生命周期相关的竞争需以后验证delete时分析，不用于加强create前置条件。
- `KMutexObtain`（268–291）：负ID/查询失败返回-1；否则解析mutex，Unlock，调用done.Obtain。
- `KMutexAbandon`（300–321）：同上查询流程，最终done.Abandon。

模块上述八个函数均无本地循环；等待与批量唤醒循环在外部 `linklist.c`。这些上下文函数不是 create 可达实现目标。LinklistSuspend 的 priority 分支使用 TaskDescriptor.task_dync_sched_member.sched_link 和 cur_prio；LinklistResume/All 调用 KTaskWakeup，后者转移等待节点。跨模块 invariant 应沿用已有 Task wait/source-view 关系。

## 适配后的完整 KMutexCreate 调用闭包

| Symbol | 分类 | 来源与采用接口 |
|---|---|---|
| KMutexCreate | 本轮 active canonical | debug宏删除；done dispatch唯一解析到_MutexCreate |
| _MutexCreate | 本轮 active canonical | 保留所有三个return分支；static改切片external，无行为变化 |
| x_malloc | trusted模型/API | xs_memory.h:48–49：KERNEL_MALLOC(sz)逐字展开为x_malloc(sz)；TrustBase的具体宏别名覆盖此symbol。复用m_ktask.h:579 delay_object：null或正、有界、ALIGN_SIZE对齐、CharArray.undef_full |
| memset | 标准库API | TrustBase C stdlib；m_ktask.h:590已有字节数组contract，c=0,n=36满足参数域，返回原指针+全零数组 |
| CriticalAreaLock | trusted primitive | TrustBase明确symbol；普通Outside→Inside+os_inv，复用共享CrtosRules协议 |
| IdInsertObj | reused-spec | 根annotated_C/src/headers/id_module_spec.h:89，原来源crtosverify-id commit12378745b310bfcefb150a6c0e5a5fbfdd95787c；精确导入两个分支contract |
| InitDoubleLinkList | reused-spec | 根annotated_C/src/InitDoubleLinkList.c，两个未初始化pointer slot→非零且self-linked |
| DoubleLinkListInsertNodeAfter | reused-spec | 根annotated_C/src/DoubleLinkListInsertNodeAfter.c；采用通用dispatch_case，A实例化为MutexAbs，head锚点产生头插；保留原rrr_ready_insert_after具名spec |
| CriticalAreaUnLock | trusted primitive | TrustBase明确symbol；Inside+os_inv且GTrans→Outside |
| x_free | trusted模型/API | xs_memory.h:52–53：KERNEL_FREE(ptr)逐字展开为x_free(ptr)，原基址的完整36字节未知值资源→emp；可参照_SemaphoreDelete.c的SemaphoreRaw专用释放接口，但MutexRaw是新实例，不能称它已被原Semaphore contract证明 |

闭包到这些边界停止。不把 IdInsertObj 内部 AllocId/InsertObj/NULL_PARAM_CHECK/DLL 调用递归安排实现证明；malloc/free原实现内部分配器/锁/dispatch同理。没有未解析function pointer。

两个宏别名经过真实头预处理：`void *allocation_alias(unsigned long n) { return x_malloc(n); }` 与 `void free_alias(void *p) { x_free(p); }`，证据保存在checks源文件，调用形式只是检查用，不成为验证切片API。

## 设计必须保留的细节

1. IdInsertObj现有失败contract只保证返回-1、原manager资源与未知值insert_ready归还；它没有“manager已满”的纯结论。不得在create锁内抽象失败分支凭空要求full，除非新增独立具名spec及推导义务。原源码确实在 AllocId 满时失败，但采用复用边界后此事实不是已导入保证。最终返回-5本来也合并了malloc失败，不能从它反推满。
2. ID成功分支把整个嵌入IdNode移交manager；payload/global DLL绝不能重复拥有它。失败保留ID字段所有权但不再保证其值仍为0；回收谓词应为完整raw而非全零。唯一padding [2,4) 必须随对象保留，不能仿Semaphore误加[14,16) padding。
3. manager只在锁内更新。对象在加入manager到管理DLL完成前是私有+共享的中间资源拆分，不必为该阶段建立完整os_inv；Unlock前必须恢复全模块一致性。
4. 整个目标不读取task内部字段；Mutex holder不解引用。初始化等待链为空，不能据此把已有所有mutex等待链也限制为空。
5. 根目录目前无MutexState/MutexInv，IDE标签不构成文件存在证据。建议增补模块并接入CrtosGlobState/CrtosInv、所有全局record构造与CrtosRules复用链；不要另造mutex critical协议。

## 输入 revision

- `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c` SHA256 `f78f31912d12ec76ff34823102d586aef574176377e1fce3c323d670c0f0f645`
- `Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_mutex.h` SHA256 `714bf24131f29d3f7b0f480525007b90d1f9e5ff63e8bf2526840e5e8f08c43f`
- `Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_memory.h` SHA256 `b899d05d63944144be3c4d6d42aed0b659bb6f65a0655d23f315fd1fe166edab`
- `Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_id.h` SHA256 `a44025ae2113ce756ddfb659556ba2211140284ba324907255e60fd515f8f42d`
- `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c` SHA256 `189a94e7dc17d6c9da6f7992a232e4422c9dc11dea539b40452b0041546a9fca`
- `annotated_C/src/include/xsconfig.h` SHA256 `e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28`
- `annotated_C/src/headers/id_module_spec.h` SHA256 `cc688388f779c493f303f8347019b74d21ca0c1c51c1d09d2f1627ac48c5a025`
- `annotated_C/src/InitDoubleLinkList.c` SHA256 `9b64aea58b40fef8b205772844d978ed5fbfee73892198fd8dcb91f37db0c1ac`
- `annotated_C/src/DoubleLinkListInsertNodeAfter.c` SHA256 `66c9654dfb4faea731ccdf647a1b6fed57ef0acd2acf5c1ef5b746f618f0d0dd`

## 切片 ABI 与结构检查

生成后的 `annotated_C/include/slice_types.h` 经同一 `abi_assertions.h` 全部断言：`gcc -m32 -std=c11 -ffreestanding -fsyntax-only kmutexcreate-trial-261101-1/checks/abi_slice.c` exit 0。`x_base=long` 与权威 xs_base.h:66 一致，ILP32下sizeof=4；x_size_t=unsigned long同真实x_ubase。Mutex/IdNode/IdManager和DLL布局与权威头断言相同。

`gcc -m32 -std=c11 -ffreestanding -Wall -Wextra -fsyntax-only kmutexcreate-trial-261101-1/annotated_C/src/*.c` exit 0，无诊断。这里只检查C结构和调用类型；QCP注解被C编译器视为注释，不由此声称QCP parser/typecheck通过。未运行symbolic或生成VC。
