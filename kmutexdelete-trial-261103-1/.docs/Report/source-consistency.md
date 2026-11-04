# KMutexDelete：设计前源码与切片结构核对

日期：2026-11-03。检查者：`/root/c_analysis`。检查对象是下表固定版本的 7 个 trial C 文件及两个 include 文件。**源码适配与结构核对未发现未解决问题；本记录不是 spec review，也不赋予 predicate/spec `review-passed`。** 尚需在固定的 review-passed predicate revision 上开展正式 spec 审阅。

本次按用户批准的 A1/A2 排除两条已确认交错，不修改权威 C，不应用拟议修复补丁。A1/A2 的范围和原反例见 `c-analysis.md`、`source-review.md` 的当前有效段。未执行 QCP parser、closure 脚本、symbolic、VC 或 C 实现证明；可达关系由逐文件人工阅读重新列出，下面的哈希仅固定读过的文件。

## 源码、配置与路径保持

对照 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c:62–75,235–257`、`linklist.c:110–132`、`id.c:122–142`、`double_link.c:71–78`、`ktask.c:1066–1075`，以及 `annotated_C/src/include/xsconfig.h`：非 SMP、32 优先级、RR_REMAINSLICE，Mutex 模块启用，ID 容量 128、16 个桶。验证 ABI 采用 TrustBase 的 32 位及 event 位域展开适配，不声称是原生 K210 二进制布局。

目标命中路径的 **三个临界区全部保留原边界**：

1. `KMutexDelete` 加锁查询、CONTAINER_OF、解锁。负 ID 不加锁直接返回；查询失败仍先解锁再返回。
2. `LinklistResumeAll` 自身加锁，循环写 exstatus/调用 KTaskWakeup，解锁后返回。没有沿用旧 semaphore 切片删除该函数自身锁的转换。
3. `_MutexDelete` 在 ResumeAll 返回后才加锁，读取当前 `mutex->id.id`，执行 IdRemoveObj 和管理链摘除，解锁后 x_free。

没有移动锁、合并这些区间、添加等待链复查，或插入 KTASK_ASSIGN/DO_KTASK_ASSIGN。原删除源码没有主动调度调用，trial 同样没有。A1/A2 约束原来的开放窗口；未把原窗口消除后再声称等价。

`KMutexDelete` 保留 `int32 id` 和唯一 `id<0` 早返回条件；IdGetObj 声明仍为 `uint16 id`，因此非负值按低 16 位转换（65536 查询 ID 0）。没有增加 `id<65536` 的入口限制。目标程序定义的 `unsigned_last_nbits id 16` 与此 C 转换相符；本处只检查源码映射，不审查其整体 predicate 正确性。

`NULL_PARAM_CHECK` 在 `_MutexDelete`、`LinklistResumeAll`、导入的 IdRemoveObj 及 KTaskWakeup 中均保留非返回 NULL 分支。当前权威 xs_kdbg.h 开启 KERNEL_DEBUG；KPrintf 调试输出按 TrustBase 移除，`while (1) { }` 不改为 return 或 assume。顶层 KDEBUG_NOT_IN_INTERRUPT 按 TrustBase 删除。

`done.MutexDelete` 静态表 (`mutex.c:205–210`) 唯一指向 `_MutexDelete`，切片直接调用它；helper static→切片外部链接只改变组织。KTaskWakeup 的 `task->Done->wake` 在导入版本中解析为 `_KTaskWakeup`：权威 `ktask.c:810–822` 的 Done.wake 初始化与 `:866,:1157` 的 task->Done 赋值提供依据。该函数及其内部查询/唤醒属于既有锁内 reused-spec 边界，不另新增实现证明目标。

## 从目标重新列出的完整边界闭包

下表恰有 12 个 symbol，每项只有一种分类。前 7 项均有同名 `annotated_C/src/f.c`，其中恰有一个 active 定义和直接写在定义上的 canonical With/Require/Ensure；末 5 项是 declaration-only 模型接口，不能计作本轮已证明 C 函数。

| Symbol | 分类 | 直接调用 / 采用接口 |
|---|---|---|
| KMutexDelete | 新设计 | CriticalAreaLock(ordinary)、IdGetObj、CONTAINER_OF_MUTEX_ID、CriticalAreaUnLock(stable)、_MutexDelete(assumed_environment) |
| _MutexDelete | 新设计 | LinklistResumeAll(mutex_waiters_oc)、CriticalAreaLock(mutex_drained)、IdRemoveObj(low_level_spec)、DoubleLinkListRmNode(remove_member)、CriticalAreaUnLock(stable)、x_free |
| LinklistResumeAll | 新设计 | CriticalAreaLock(mutex_live)、CONTAINER_OF_TASK_SCHED、KTaskWakeup(wakeup_by_id_ic)、CriticalAreaUnLock(stable) |
| IdGetObj | reused-spec | 根 `annotated_C/src/IdGetObj.c`；内部 GetObj 由该边界覆盖，保留完整本地 GetObj 合同 |
| IdRemoveObj | reused-spec | 根 `annotated_C/src/IdRemoveObj.c`；内部 IdGetObj/FreeId/RemoveObj 由该边界覆盖，保留完整本地合同 |
| DoubleLinkListRmNode | reused-spec | 根 `headers/m_double_linklist.h` 的全部 5 个合同 + `kernel/thread/double_link_remove_member.c` 真实 body；无内部 call |
| KTaskWakeup | reused-spec | 根 `headers/ktask_wakeup.h` 的全部 3 个合同 + `kernel/thread/ktask_wakeup.c` 中的唯一该函数 body；内部 GetTaskWithIdnodeInfo/_KTaskWakeup 由复用边界覆盖并保留完整本地合同 |
| CriticalAreaLock | TrustBase + 本次 A1/A2 限定模型 | ordinary 及两个调用链限定的 mutex_live/mutex_drained；不是新增实际 C symbol |
| CriticalAreaUnLock | TrustBase | 三个新设计单元都采用同一 stable contract |
| CONTAINER_OF_MUTEX_ID | TrustBase CONTAINER_OF API | 对应 Mutex.id；纯地址关系，不拥有对象字节 |
| CONTAINER_OF_TASK_SCHED | TrustBase CONTAINER_OF API | 对应 TaskDescriptor.task_dync_sched_member.sched_link；纯地址/对齐关系 |
| x_free | TrustBase allocator 模型 | MutexRaw 原分配基址的释放接口；权威 `xs_memory.h:52–53` 明确 KERNEL_FREE(ptr)→x_free(ptr)，不递归 allocator body |

NULL_PARAM_CHECK、调试宏已经按规则展开/移除，不是闭包中的未解析调用；`for`、`if`、字段表达式和逻辑词汇不是 C calls。本轮不从 reused-spec 的内部调用继续安排 canonical 实现文件；因此 GetObj、FreeId、RemoveObj、GetTaskWithIdnodeInfo、_KTaskWakeup 等不是漏项。没有未解析 function pointer 或保留的裸宏调用。

**LinklistResumeAll 是独立的新 mutex/outside contract。** 原 semaphore_waiters 只适用于 semaphore 锁内场景，与本次真实 lock body 不兼容；本 trial 没有冒充从它派生的新特化，也没有改变根文件的原合同。正式审阅需要检查新效果关系本身，而不能援引 semaphore contract 已通过替代。

## 声明端与实现端合同一致性

逐项对照了 caller-local 与对应 canonical 的完整合同，变量名和排版不参与语义差异：

- KMutexDelete 中 `_MutexDelete/assumed_environment` 与 `_MutexDelete.c` canonical 相同。
- `_MutexDelete` 中 `LinklistResumeAll/mutex_waiters_oc` 与 `LinklistResumeAll.c` canonical 相同。
- KMutexDelete/IdRemoveObj 中 IdGetObj 的全部 Require/三个 Ensure 分支与 IdGetObj.c 相同。
- `_MutexDelete` 的 IdRemoveObj high_level_spec/low_level_spec 两项均与 canonical 相同，实际选 low_level_spec。
- `_MutexDelete` 的 DoubleLinkListRmNode 全部 5 项与 canonical 相同，实际选 remove_member；canonical 又保持根 header 的全部原具名规格。
- LinklistResumeAll 的 KTaskWakeup 全部 3 项与 canonical 相同，实际选 wakeup_by_id_ic；canonical 保持根 header 的三个原合同。
- 四个 reused 单元的内部 caller-local 合同与根来源一致；没有为了适配 mutex 偷改原 Require/Ensure。
- stable Unlock 在三个新设计单元中相同。Lock 的 ordinary、mutex_live、mutex_drained 是三个明确不同名称的模型合同；后两项注释明确仅凭本次 A1/A2 才可选，未声称是 ordinary 的无条件后果。它们的形式化适用性交正式 predicate/spec 审阅，不在此作通过结论。
- 两个 container API 与所采用的 TrustBase 地址转换接口形状相符；x_free 只出现一个 MutexRaw 模型 contract。

所有真实 callee 声明都位于 caller 定义前并带完整 With/Require/Ensure，没有只靠裸 prototype。两个头文件仅提供类型、全局声明、逻辑导入与 Extern vocabulary，没有集中保存模块级函数 specs。

## 类型与布局人工核对

`slice_types.h` 保留真实成员顺序及影响所访问字段偏移的所有前置字段。`int32` 为 signed int，`uint16` 为 unsigned short，`x_base/x_err_t` 为 signed long；在本次 Arch32/ILP32 模型下与已有库匹配。此处没有以宿主 LP64 编译结果替代目标 ABI 检查。

| 对象/访问 | 32 位适配后的偏移 | 对照依据 |
|---|---|---|
| Mutex.id / id.id / id.link | 0 / 0 / 4 | xs_mutex.h、xs_id.h、共享 mutex_field_offset_ok |
| Mutex.val / recursive_cnt / origin_prio / holder | 12 / 14 / 15 / 16 | 完整 IdNode 和 uint8/uint16 布局 |
| Mutex.pend_list / link / sizeof | 20 / 28 / 36 | 共享 mutex_field_offset_ok、size axiom；未去掉2字节padding |
| SysDoubleLinklistNode.next / prev | 0 / 4 | xs_klist.h，与链表四条赋值一致 |
| TaskDescriptor.task_dync_sched_member.sched_link | 4+12=16 | 非 SMP、无 SEPARATE_COMPILE、32 优先级 TaskDyncSchedMember |
| TaskDescriptor.exstatus / id.id | 92 / 104 | 两个 event 位域按 TrustBase 展开为独立 uint32 后的布局；与 ktask_descriptor_field_offset_wf 一致 |
| IdManager.id_max / hoffset / id_map / htable | 0 / 2 / 4 / 8 | xs_id.h 原成员顺序和完整指针槽 |

头文件有 Mutex、TaskDescriptor、IdNode、IdManager 和必要链表声明；无错误精简结构。`logic.h` 已声明保留合同所用 task_world_wf、TaskStable.task_stable_ids，以及 semaphore/detached 原特化词汇；旧 KNONE 已等价规范为零指针 `0`；去掉的旧 libai/VC imports 只服务旧实现证明注解，新切片没有遗留这些旧 proof 符号。

## 当前结论及后续界限

当前观察未发现漏调用、重复 active 定义、caller/canonical 不一致、错误布局、丢失返回路径或擅改锁边界。该结论限于源码适配、结构与导入合同一致性；不替代 Rocq 编译/类型检查，不证明 A1/A2，也不预先通过 predicate 或 spec。实际实现证明仍未启动。

原源码/配置哈希沿用 c-analysis.md（本次重新读取 mutex.c/linklist.c/id.c/double_link.c/ktask.c/xsconfig.h，均与先前值相同）。被核对的 trial 文件 SHA-256 如下；后续语义变更需只复查受影响部分。

- `annotated_C/src/DoubleLinkListRmNode.c`: `fecaae1c64e5dbbb603a9fd6f4940820a97051664c507786e243a7321865fb2a`

- `annotated_C/src/IdGetObj.c`: `e3c81f38bc18cd95671d64d50bc5454c0b506a8c85a7aff4034c1f52da44e3d8`

- `annotated_C/src/IdRemoveObj.c`: `690d8789967fa4f704153597ea79f0741e839dc47dbe39c0869ee44a2c1bbbe3`

- `annotated_C/src/KMutexDelete.c`: `6f0749195f4268c0c02acaddcfa640c24aa9886d5239938883c145689549e612`

- `annotated_C/src/KTaskWakeup.c`: `5c409959aa0acde2c0ef3e32d9518f111928e74b0fdedc6eed39300880c35f49`

- `annotated_C/src/LinklistResumeAll.c`: `e2ad5e4189eae99df68be3be9cb6c216caa68d09d9b1266f0efb7355be027dd8`

- `annotated_C/src/_MutexDelete.c`: `330befaa712a15afc9bbf6c7895019c4f57eba5c3e3525443c8e8d87d6259c2f`

- `annotated_C/include/logic.h`: `0e83c269ef9cd2993f4ce423dd46e85398670a763fc95695354ba749ae5e2774`

- `annotated_C/include/slice_types.h`: `def1394936c884bca21b83beca8f8bb3d59f5a2e793909173b40c015e1b6902b`

接口适配补记：GetTaskWithIdnodeInfo 本地合同的旧 KNONE 已规范为零指针 `0`，logic.h 不再声明 KNONE。LinklistResumeAll 两份同名合同的返回常量由 C 宏名 EOK 规范为已有 Rocq KOK=0，C正文不变；常量适配不改变源码/合同语义或闭包。最终spec文件hash以 spec-revision.json 为准。
