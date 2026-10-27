> 已于本轮续跑撤销 B1 停止结论：用户明确按《源代码处理》采用既有适配并修改 skill。下文为修订前的历史审阅，不是当前 blocker。

# KSemaphoreDelete 源码转换与信任边界审阅

本记录是独立、只读的上下文审阅，不是 predicate/spec 的正式通过记录。审阅日期为 2026-10-25；没有运行 QCP、symbolic、VC 或实现证明，没有修改共享库及切片。配置依据是 `annotated_C/src/include/xsconfig.h`：非 SMP、32 位适配、`BOARD_K210_EVB` / `ARCH_RISCV`、32 优先级、`SCHED_POLICY_RR_REMAINSLICE`、启用栈溢出检查。C analysis agent 独立确认了相同配置。

## 调度模型存在项目依据，但不能充当严格真实闭包的实现

根 `源代码处理.md` 和 skill 的 `references/源代码处理.md` 内容一致，均明确给出 `DO_KTASK_ASSIGN` 替换成 `KTASK_ASSIGN()` 的空临界区模型及具体 contract。`lib/KTaskOsAssign.v` 称其为“用户指定的空临界区调度模型”，`annotated_C/src/outside_critical/ktask_assign_oc.c` 称其为 `User-authorized logical model`。因此，不能将此适配描述成 agent 新创的、完全没有项目依据的假设。

但现行主 skill 第 140–142 行明确要求宏展开的真实函数继续入闭包，且不能为源码不存在的宏虚构 canonical 函数；第 153–156 行要求每个真实可达 symbol 有 active canonical body 或明确批准的 trusted 边界。spec writing guide 第 45–60、406–411 行重复此要求。`ktask_assign_oc.c` 自身注明 `not its implementation`，其 header 也明确 `This is not a proof of DO_KTASK_ASSIGN`。这些限制不能被历史注释中的“authorized”抹掉。

真实源码 `_SemaphoreDelete` 在非空 pend list 分支先唤醒任务、摘除信号量并释放，随后执行 `DO_KTASK_ASSIGN`（`kernel/thread/semaphore.c:94–96，宏位于第 95 行`）。当前非 SMP 宏（`kernel/include/xs_assign.h:122–130`）产生 `DisableLocalInterrupt`、`KTaskOsAssign`、`EnableLocalInterrupt`。`KTaskOsAssign`（`kernel/thread/assign.c:40–113`）会改 ready vector、运行任务状态及 `Assign.os_running_task`，并调用 `SwitchKtaskContext`；其栈检查分支还可能不返回。空临界区模型不表达这些具体动作，其宽松 rely 可隐藏环境变化，但现有文件没有给出该模型与真实调用的完整实现对应证明。不能把该模型编译或证明成功计为上述真实函数的完成。

当前 TrustBase 明列 `CriticalAreaLock/UnLock`、`KERNEL_MALLOC/FREE`、CONTAINER_OF 及部分适配，没有列 `KTaskOsAssign`、`DisableLocalInterrupt`、`EnableLocalInterrupt` 或 `SwitchKtaskContext` 的具体 trusted contract。已有模型是具体的历史上下文，却没有解决它与本轮“严格执行完整真实闭包”要求之间的冲突。独立审阅结论：若本轮沿用该模型，必须明确其作为源码抽象特例的范围；不能同时报告“真实闭包完整、没有被排除的未批准函数”。本轮一般性“通过一切人工 review”没有点名这些真实 symbol，也没有明确撤销严格闭包要求，不能据此代替用户选择新的 trusted 截断点。

这不是因调度代码复杂而停止：实际边界是 `arch/risc-v/k210/interrupt.c:50–62` 的 mstatus inline assembly，以及 `arch/risc-v/shared/riscv64_switch.c:187–200` 的 naked 汇编切换。当前 QCP C 切片和现有模型没有给出这些动作的 C 语义实现。32 位适配也不能独自构成真实汇编叶子的机器验证依据。保留真实调用并继续设计，最终仍须解决这些具体叶子的信任或实现语义；删除它们则违反本轮严格闭包门禁。

## 嵌套锁可以局部核对，不应直接作为全局 blocker

真实删除函数在调用 `LinklistResumeAll` 前已持有外层锁。后者、`GetTaskWithIdnodeInfo`、`_KTaskWakeup`、`KTaskUnSetDelay` 内部的锁均可沿源码逐对核对；相关位置为 `linklist.c:110–132`、`ktask.c:64–82,488–516`、`delay.c:97–114`。它们在此调用场景下不会脱离外层临界区。`KTaskInsertToReadyVector` 另有直接 `DISABLE_INTERRUPT/ENABLE_INTERRUPT` 配对（`assign.c:204–224`），需要单独记录，不能把它误称为 `CriticalAreaLock`。

非 SMP `CriticalArea.c:117–138` 是关中断、增加 uint16 层数、相应减少层数并恢复中断。故去掉嵌套配对需要核对：入口已有保护；嵌套保存值对应中断已关闭；没有层数溢出；删去的区间没有依赖被删层数值的读取；退出配对仍保持外层保护。当前局部调用链不含调度入口的层数读取，正常入口最大深度有限，可以具体计算并用已有临界区协议说明。历史 `m_ktask.h:62–103` 提供 nested contract，但自注“新增的待审核 primitive Specs”，不能只见到声明就认作已证明。

这部分可通过局部源码说明或保留正确的 nested trusted primitive contract 修复，不因存在嵌套而必然阻塞。不能把相同删除规则自动推广到任意 caller 或直接位于临界区外的调用。

## 外部访问加锁与 dispatch

“给每个临界区外共享访问包锁”也是历史文档中的具体适配做法，但会改变中断/锁行为，不能仅引用该句就把任意转换称作源码等价。本目标的信号量和唤醒链共享数据操作本来处在外层临界区内；释放后的 `x_free` 对应 TrustBase 已列 `KERNEL_FREE`（`xs_memory.h:52–54` 的精确宏别名），不需要虚构外部共享读写加锁。调度段的变化应按上述调度边界处理。

已检查的 dispatch 并非不可解析：`semaphore.c` 的 static `done.SemaphoreDelete` 指向 `_SemaphoreDelete`；`ktask.c:810–822` 的 `Done.wake` 指向 `_KTaskWakeup`，任务初始化在第 866、1157 行赋该表；`assign.c:30–35,387` 的 ready-vector 表及初始化明确指向插入/删除函数。正式 predicate 仍须保存相应对象与函数表关系，不能把受内存约束的解析当成无条件外部事实。尚未对所有调度 dispatch 作完整 closure review，本报告也不声称已完成该检查。

## 固定依据与结论

SHA-256：

- `/home/xinra/TrustBase.md`：`a2201e7277938c1c45f3570c4224fa26724bc7d4f27027077f00d6d384ad35f7`
- skill 主文：`b544ac6828d7dedb1ca0e451a196e92a61d6796011432c3210196d66519e05d6`
- 根与 skill 的 `源代码处理.md`：`4c3304a3c12297330f5d4793c0e4cb4a31ed3d55ad974b5917d59c951986d1e8`
- `annotated_C/src/include/xsconfig.h`：`e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28`
- `lib/KTaskOsAssign.v`：`c0f041dd54cf9b478bca5e9b96ae934a42b3298b83996ef4a6233614cf02a580`

本报告不批准任何新的 trusted symbol，不改变既有授权。对于当前严格目标，调度模型特例和真实闭包规则的冲突尚未消除，不能据现有证据发出完整 spec `review-passed`。这不是 predicate 本身错误的结论；若后续有明确适配边界或真实叶子语义的新证据，只需复查受影响部分。
