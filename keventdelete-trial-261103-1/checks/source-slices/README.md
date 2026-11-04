# 只读切片素材与接口适用性

这些文件仅是机械摘录，不是正式annotated_C输入，不含新设计合同。`manifest.json`固定权威正文位置、来源hash及合同声明位置。四份`*.original.c`完整保留真实函数正文；没有采用未应用修复候选。

## 建议记录的适配

- KEventDelete：删除TrustBase授权的KDEBUG_NOT_IN_INTERRUPT；`done.EventDelete(event)`唯一解析为`_EventDelete(event)`，不得改为id入参。保留查找和NULL返回分支。
- FindEventById：static→slice external；CONTAINER_OF转具名`CONTAINER_OF_EVENT_ID`模型API；原有Lock/Unlock及负数检查保留。公开设计输入获批0<=id<65536，但不能因此删除源码中的负数分支，也不能把范围扩大为任意int32。
- _EventDelete：static→slice external；NULL_PARAM_CHECK按当前debug配置展开NULL死循环并删打印，或使用既有具名检查API并计入闭包。源代码处理允许对锁外共享读取`IsDoubleLinkListEmpty`的执行添加局部临界区（实际读取在被调辅助函数中）；其结果须先保存再原样if分支，且记录新增锁配对。该局部锁不能延长到后续整个删除事务。LinklistResumeAll在原控制流中是外部调用，须保留自己的真实锁。DO_KTASK_ASSIGN转规定的KTASK_ASSIGN模型。
- LinklistResumeAll：保留真实Lock/Unlock（此调用不是nested）；for(;;)可等价变成while(1)；SYS_DOUBLE_LINKLIST_ENTRY转CONTAINER_OF_TASK_SCHED；NULL宏按同规则处理。KTaskWakeup是在其锁内执行，导入该函数的inside-critical合同。不得从根Semaphore专用slice直接复制“删除内部锁”的正文而不改回真实外部调用形态。
- 单独包装`IsDoubleLinkListEmpty`内部读取或在调用周围加锁的具体边界需正式设计审阅确认。无论采用何者，D1/D2的排除依赖本轮批准环境条件，不归功于该单语句锁适配。

## 可以原样复用的合同

所有下述可复用部分还须与caller-local文本保持一致，类型和导入按当前trial调整，原语义不改。

| symbol / spec | 原始位置 | 本轮用途 |
|---|---|---|
| IdGetObj | src/headers/id_module_spec.h:70；src/IdGetObj.c canonical | 原样reused-spec边界。容量之外ID未命中；同一合法值转uint16不截断。 |
| IdRemoveObj high_level_spec / low_level_spec | src/headers/id_module_spec.h:104/127；src/IdRemoveObj.c | 原样reused-spec边界。选择对应合同，不能凭Delete context私自删掉失败分支。 |
| IsDoubleLinkListEmpty dll | src/IsDoubleLinkListEmpty.c:7的第二个spec | 泛型DLL合同，实例化event等待节点；保留已有ready_dll合同。 |
| DoubleLinkListRmNode remove_member | src/headers/m_double_linklist.h:205 | 泛型管理DLL摘除，返还payload与自环节点；保留原其他具名spec。 |
| KTaskWakeup wakeup_by_id_ic | src/headers/ktask_wakeup.h:17 | 原样reused-spec边界。已包含event_remove_waiter_step；event pending/task ID关联须由调用点导出。 |
| CriticalAreaLock ordinary / Unlock stable | src/_SemaphoreDelete.c caller声明；也见headers/m_ktask.h:72/90 | TrustBase API合同，原样资源协议；若引入批准环境限制，须由正式设计说明如何跨真实Lock/Unlock保存该限制，而非修改原primitive保证。 |
| KTASK_ASSIGN outside_critical | src/_SemaphoreDelete.c caller声明及源代码处理文档 | 规定模型API合同。 |
| CONTAINER_OF_TASK_SCHED | src/LinklistResumeAll.c:17 | 现有类型化CONTAINER_OF模型，地址对应与对齐；不提供对象生命周期。 |

`*.contracts.txt`按以上来源抽取，签名与annotation字面不变，只移除了外围imports、函数体和实现证明注解。它们是检查素材，不是模块级specs.h，不应被C include。

## 必须新增或额外确认的接口

1. KEventDelete、FindEventById、_EventDelete：当前根目录无对应有效合同，需要本轮设计。不能把Semaphore的统一锁事务contract挪给原Event实现。
2. LinklistResumeAll：根文件只有`semaphore_waiters`，纯效果直接写os_semaphores，且是锁内调用形态。**不能用事件地址替换sem参数就当作event特化，也不能标作已覆盖事件的reused-spec。** 应保留该原合同，新增event相关合同，说明outside调用/内部临界区、批量任务效果及资源交接；新合同的函数体义务属于本轮新增设计目标。是否额外提供内部专用合同由设计决定，不能凭原Semaphore证明自动通过。
3. KTaskWakeup的event队首专用spec若需要，应从通用wakeup_by_id_ic推出并保留原spec；已有semaphore_pending_head_ic只适用于semaphore，不可原样用于event。泛型合同本身可直接使用，无必须新增特化的要求。
4. CONTAINER_OF_EVENT_ID：本轮尚无根Event专用API声明，按已授权CONTAINER_OF规则提供类型化对应，不能顺便授予存活资源。
5. x_free：素材来自SemaphoreDelete的`Require SemaphoreRaw(ptr)`，**不是可用于Event的合同**。只能作为已授权KERNEL_FREE/x_free边界的用法参考；本轮须给出适用于完整Event模型内存的释放合同，并检查36字节资源及padding回收。不把SemaphoreRaw改名当作已有事件证明。

## 避免导入已归档的实现证明辅助库

当前根目录没有`VC/`。`annotated_C/src/LinklistResumeAll.c:4`引用`CRTOS_Verify.VC.LinklistResumeAll_lib`，`_SemaphoreDelete.c:3`引用`CRTOS_Verify.VC.SemaphoreDelete_lib`，它们是旧实现证明的辅助依赖，不能照搬进新trial再声称导入可用。

可以仅提取原canonical With/Require/Ensure及本轮需要的实际body，使用共享lib中的语义定义；不要复制源slice的循环Inv、which implies、proof-only Extern和VC导入。原LinklistResumeAll公开合同依赖的`semaphore_pending_head`和`semaphore_resume_all_effect`位于lib/KSemaphoreDelete.v，`semaphore_pending_nodes`在lib/KTaskWakeup.v，均不依赖上述VC辅助库。`set_task_desc_exstatus`也在共享KTaskWakeup。`resume_remaining_effect`、`resume_next_restore`、`resume_exstatus_restore`、`resume_id_restore`只是旧函数体证明注解使用，不是原canonical合同所需；新设计阶段不需要把它们迁入共享库。

根include/logic.h仅导入共享lib，没有CRTOS_Verify.VC，但混入大量Semaphore语义，建议只带本轮所需声明并加入经审阅的Event语义。IdGetObj、IdRemoveObj、IsDoubleLinkListEmpty及泛型链表/ID/KTaskWakeup headers没有缺失VC导入问题。不要修改根旧证明状态或删除原合同来简化新trial。
