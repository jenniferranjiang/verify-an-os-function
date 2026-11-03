# E2 延时分配失败的最小源码修复审阅

**修复位置更正：仅修改trial。** 按用户最新要求，权威 `event.c` 已恢复原样（SHA256 `1351dfb28f28413e50790fd4390777e647c6d60f1fe9debf850367c902841d64`）；E2修复保存在 [source_fixes/_EventProcess.c](../../source_fixes/_EventProcess.c)，在文件头和修改分支加入中文注释。它是trial修复候选，未加入本轮Create的QCP调用闭包，不能据此声称权威OS源码已经修复。候选修复与此前已审函数仅注释和存放位置不同；迁移后重新运行回归，原版仍检出缺陷，trial候选16场景通过。

以下为迁移前的独立审阅记录，所述整文件修后哈希属于当时的临时版本。当前位置与哈希见[repair.json](../../checks/e2-delay-failure/repair.json)；迁移检查确认函数去注释后的正文相同，不产生新的设计revision。

结论：**源码修复 review-passed；KEventCreate predicate/spec 不需要语义修改。** 审阅者未实现此补丁或测试。此次仅检查用户授权的 `_EventProcess` 在合法输入下忽略 `KTaskSetDelay` 失败的问题，未修改其他源码或formal文件，未运行QCP、symbolic、VC或实现证明。

审阅源码是 `event.c` SHA256 `1816cddc807d26e10cfbc1016b4e33a3f2486bc57ac007ae3773cfb54435ed86`；修前快照为 `checks/e2-delay-failure/before-event.c`，SHA256 `1351dfb28f28413e50790fd4390777e647c6d60f1fe9debf850367c902841d64`。实际diff仅把原来的timeout>0单次调用改成检查返回值、失败记录exstatus并调用KTaskWakeup，没有新增提前返回，也未更改创建、查找、输入校验或删除算法。

## 回滚与调度

在当前非SMP、合法等待策略、正常任务上下文和已确认对象生命周期条件下，LinklistSuspend先将当前任务置SUSPEND并加入事件pending。KTaskSetDelay唯一失败路径是任务原delay为NULL且分配失败；该返回发生在保存delay指针和登记延时节点之前，所以没有新Delay需要释放。

新增失败分支仍持有原外层临界区，保存真实错误码到task.exstatus，然后KTaskWakeup通过真实任务ID找到该SUSPEND任务。_KTaskWakeup摘除sched_link、调用UnSetDelay（本失败路径delay为NULL，故为空操作）、插入ready并置READY，且不覆盖exstatus；该清理路径不再分配内存。既有任务身份和状态保证唤醒在本回滚场景可用，不能将此结论推广到非法task/ID或其他任意调用。

复用公共CriticalAreaUnLock和DO_KTASK_ASSIGN是必要的：非SMP解锁仅减少nest并恢复中断，不会自动调度；Wakeup只恢复READY，调度器才会在选中当前任务时移出ready并恢复RUNNING。现有调度后的exstatus检查返回-ENOMEMORY，避免在仍挂起或仅READY的状态直接返回。嵌套锁在外锁保护下配对恢复，没有持外锁执行DO_KTASK_ASSIGN。

失败路径不修改事件位或processed；等待字段保留本次请求值，与现有其他等待结果路径一致。当前任务退出pending，其他等待任务的链关系和状态保持。成功建立延时、复用已有Delay、触发/超时恢复及立即满足分支的原有控制流没有被改动。

## 故障注入证据的独立核对

检查了harness.c、run.py、results.json及before/after生成输入。run.py抽取的是**18个**权威函数：5个DLL操作、2个临界区函数、2个Delay操作、5个任务挂起/唤醒/超时函数、LinklistSuspend、时间换算、_EventTrigger、_EventProcess。独立重做只读提取比较，两个extracted.inc均逐字匹配对应源码，两个harness副本与主fixture一致，results记录的所有源文件哈希与当前输入一致。

主机fixture明确模型化中断硬件、ID查找、就绪队列实现、状态辅助操作和上下文调度；使用简化TaskDescriptor及主机指针布局，不能用作目标板或ILP32 ABI执行证据。真实Event位域仍在fixture中。模型在调度入口检查外锁已释放，并把原版“仍SUSPEND且没有Delay”作为故障退出；这是失去有限超时保障的可复现模型轨迹，不是实际等待到永久的目标板实验。正常触发路径调用抽取的真实_EventTrigger；超时场景模型移除Delay后调用真实KTaskTimeout，没有执行真实时钟ISR/全局调度器。

已运行记录显示：修前编译成功、运行exit20，提示任务在没有超时登记时仍挂起；修后编译成功、运行exit0，16个场景全部通过，构建启用UBSan。16个场景由8次失败调用（FIFO/PRIO × 有/无既有waiter × 连续两次）、每种策略各4次正常路径构成，覆盖触发、复用Delay、立即满足并自动清位、超时。检查包含错误码、exstatus、processed未写、事件位不变、等待邻居保持、sched节点自环、ready/Delay队列清理、锁深度与中断恢复。该范围足以支持本次最小回滚修复，未覆盖完整调度策略和所有并发交错。

整份event.c的主机GCC语法检查有空诊断成功记录；整TU的-m32尝试因缺少32位libc头 `bits/libc-header-start.h` 未完成，应明确记录此环境限制，不能称整TU已通过32位编译。已有权威与适配ABI静态fixture仍用于各自结构布局检查。未因此安装环境或扩大测试范围。

## 对创建设计与源码问题分类的影响

独立比较修前修后提取结果，KEventCreate和_EventCreate两个函数体逐字未变。它们仍只有原10-symbol调用闭包和三条返回路径；位域截断、初始化字段、ID登记、失败回收、锁调用顺序均未改变。新增代码只调用已有KTaskWakeup，在模块状态上执行已有event_remove_waiter_step所描述的摘除操作，不需要新增Event字段、生命周期状态、资源或接口。修复不会改变Create参数范围或引入新的Create返回值。

因此已审predicate revision `bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca`、spec revision `1c4a7b5920e164a40891b6d64dc6f18be0debede36a1c79946dd82dad5138f00`的语义结论可保留，不必为了同一设计重复编译。必须更新源码revision/manifest对应关系和报告中的风险处置结论；当前event.c文件级哈希已变，旧的“全文件未变化”检查结果不能原样沿用。新代码不是Create证明闭包成员，也没有因此完成Process或整个Event模块的实现证明。

用户确认的范围应明确记录为：

- E1的无效ID/失效handle使用，以及E2非法等待策略路径，按本轮接口调用前提排除；这是调用环境的输入约束，不是已经修好的防御性参数检查。相关源码行为仍然存在，本轮未改动。
- 此处应将“Create接受的输入域”和“允许后续等待操作的调用场景”分开说明。KEventCreate仍接受整个uint32域，成功时保存低3位；不能偷偷把其Require加强为0/1或小于8。调用环境选择可用于等待的FIFO/PRIO策略，属于后续操作的适用条件。
- E3按用户确认：事件在使用期间不会被删除，因此查找到后续访问之间的删除交错不属于本轮运行环境。该约束来自用户，不是新增引用计数/锁保护、不是源码已消除生命周期竞争，也不能宣传支持任意并发删除。今后放宽该运行约束时需重新检查。
- 合法参数仍可能遇到分配失败，不能按输入约束排除。E2本次修复的正是该独立路径；故障注入和实际控制流检查支持其错误返回与可运行状态恢复。

在上述明确范围及已审信任边界下，可以继续并完成KEventCreate设计审阅的收尾。不能仅说“错误在闭包外所以无关”，也不能把本次小范围回归或trusted Lock解释成整个运行环境已获证明。其余定义/字节转换与C实现证明仍保持原有未证明状态。
