# KEventCreate 验证上下文与生命周期 blocker

> 2026-10-06 状态更新：EVENT-PRED-B01 已由用户批准为环境假设；EVENT-PRED-B02 仍待源码修改，候选修复见 `2026-10-06-1-event-delete-fix-analysis.md`。

状态：`blocked-before-predicate-review-ready`

本记录固定本轮上下文、C 分析和停止依据。没有 predicate/spec revision 达到 review-ready 或 review-passed；没有运行 QCP parser、symbolic、closure script、VC 或 proof。

## 1. 固定上下文

- 目标：按 whole-module predicate scope 分析 `event`，目标函数 spec 从 `KEventCreate` 展开。
- 权威输入 manifest revision：`source-s1-830483391cb0`（报告所列 C/header/config 共 17 个文件按 `sha256sum files | sort | sha256sum` 计算）。
- 权威模块：`Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c`；active 函数为 `_EventCreate`、`_EventDelete`、`_EventTrigger`、`_EventProcess`、`FindEventById`、`KEventCreate`、`KEventDelete`、`KEventTrigger`、`KEventProcess`。
- 候选非 SMP 配置证据：`board/stm32f103-nano/config:5-6,68-70,81-93,160-167`；启用 Cortex-M3、small allocator、event、RR-remainslice，禁用 debug 和 SMP，`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`。
- 配置限制 `[OPEN]`：项目根没有生成 `.config`/`xsconfig.h`；该 board config 可作为明确指定的验证配置，但不能称为仓库当前 build 的自动激活配置。继续实验前须由用户明确批准该配置，或提供实际根配置。
- `event.c:205-210` 的静态 `done` 只有唯一 initializer，无 writer；目标 dispatch `event.c:244` 可等价归一为直接调用 `_EventCreate`，但该归一尚未写入 annotated C。
- 当前配置关闭 `KERNEL_DEBUG`，所以 `KDEBUG_*`、`NULL_PARAM_CHECK`、`CHECK` 按 `xs_kdbg.h:145-155` 展开为空。

## 2. 模块 C 分析摘要

- `_EventCreate` (`event.c:27-53`)：分配失败返回 `-ENOMEMORY`；成功后整块清零，进入 critical，调用 `IdInsertObj`。ID 满时先解锁、释放私有对象并返回 `-ENOMEMORY`；成功时把 `options` 截断写入 3-bit 字段、初始化 pend head、把 registry link 插入 `k_event_list`、解锁并返回首个空闲 ID。无循环。
- `_EventDelete` (`event.c:55-77`)：检查 pend list，必要时 `LinklistResumeAll`；随后另行进入 critical，移除 ID 与 registry node，解锁、释放对象，并可能调度。
- `_EventTrigger` (`event.c:79-135`)：critical 内 OR 入 29-bit events，遍历 pending tasks，按 AND/OR 条件决定唤醒，OR 路径可收窄 task trigger，AUTOCLEAN 可清除事件位；`KTaskWakeup` 会转移 task sched-link ownership。循环不变量必须同时追踪当前 node、剩余 waiter、task event fields 和逐步减少的 event bits。
- `_EventProcess` (`event.c:137-203`)：读取当前 task，计算 tick，critical 内检查 AND/OR；即时成功可写 `processed` 并 AUTOCLEAN。否则设置 task event fields 并调用 `LinklistSuspend`，可设置 delay、解锁并调度，恢复后再读 exstatus/processed。
- `FindEventById` (`event.c:212-231`)：只拒绝负 ID；进入 critical 查询 manager，取得 `Event *` 后在返回前解锁。
- 四个 public wrapper (`event.c:240-301`)：debug guard 为空；delete/trigger/process 先用 `FindEventById` 取得裸指针，再在临界区外交给内部实现。
- `IdInsertObj` 闭包：`id.c:24-53` 的 `AllocId` 扫 bitmap；`id.c:62-73` 的 `InsertObj` lazy-init bucket 并头插；`id.c:106-120` 写 `idnode->id` 后组合二者。
- DLL helpers：`double_link.c:30-49` 初始化或头插 intrusive node。
- critical：非 SMP `CriticalArea.c:98-138` 用 TU-static `uint16 KTaskOsAssignLockNest` 与 PRIMASK save/restore；nested depth 必须小于 65535。

## 3. ABI 与表示结论

- `xs_event.h:42-50` 的 `options:3` 与 `events:29` 共用一个 32-bit container，不能表示成两个可分别取址的字段。
- 所选 AAPCS32 下 pointer/unsigned word 均为 4 bytes；little-endian bit-field 依声明顺序从 container 的低位开始。因此 event backing word 为 `options + 8 * events`，options 范围 `0..7`，events 范围 `0..0x1fffffff`；`IdNode` 之后该 word 在 offset 12，`pend_list` 在 16，`link` 在 24，总大小 32。
- 权威 ABI：https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst 的 Fundamental Data Types、Structure Layout 与 8.1.7 Bit-fields。
- `lib/KTaskDescriptor.v` 不能作为本模块 task borrow 的已审阅依据：其注释明确使用两个独立 UInt event 字段并记录与真实 29/3 bitfield 不等价，偏移和总大小也随之不同。

## 4. Review blocker

### EVENT-PRED-B01 — blocker — open

- 证据：`event.c:220-230` 在 `FindEventById` 返回前解锁；`event.c:258-263,277-282,299-301` 随后才使用裸 `Event *`。`CriticalArea.c:132-138` 恢复中断；Cortex-M3 `arch/arm/cortex-m3/interrupt.c:25-35,48-59` 表明恢复 PRIMASK 后 IRQ 可执行 `KTaskOsAssignAfterIrq`；`assign.c:115-196` 可选择另一任务并调用 `HwInterruptcontextSwitch`；`arch/arm/shared/arm32_switch.c:22-65` 触发 PendSV；`arch/arm/shared/pendsv.S:40-115` 完成任务上下文切换。
- Mismatch：lookup 临界区只保护 manager 查询，不保护返回对象从 lookup 到最后一次使用的生命周期。源码没有引用计数、hazard/borrow token、删除等待或 public API 外层串行化约束。
- 具体后果：任务 A 解锁并持有 event 裸指针后可被抢占；任务 B 可执行 `KEventDelete`，从 manager/registry 移除并 `x_free`；任务 A 恢复后在 `_EventTrigger`、`_EventProcess` 或 `_EventDelete` 解引用已释放内存。任何宣称对象仍存在的 Require 都会是源码未保证的加强假设。
- required fix：在权威 C 中建立可观察的生命周期保护。最小可接受方案之一是让 public API 在取得对象前持有外层 critical，并保持到内部实现不再使用对象；删除须在同一保护下先 unpublish、处理 waiter 并完成 free，嵌套 helper 只能保持该外层保护。另一可接受方案是加入引用计数/borrow acquire-release，且 delete 在最后一个 borrower 释放前不得 free。
- pass condition：源码与当前配置可证明从 ID lookup 到最后一次 dereference 存在同一个有效 lifetime guard；delete 不能与该 guard 并发 free；重新扫描全部 public wrapper、delete/waiter 路径后，无裸指针跨 guard，Rocq predicate 能给每个稳定/借用状态唯一 owner。

### EVENT-PRED-B02 — blocker — open

- 证据：`event.c:62-67` 先调用 `LinklistResumeAll`，该函数在 `linklist.c:110-131` 内部 lock/unlock 后返回；`_EventDelete` 返回后才重新 lock。`event.c:182` 的 process 路径可再次向同一 `pend_list` 挂 task。
- Mismatch：删除在“唤醒全部 waiter”和“unpublish/free”之间重新开放调度窗口，没有 delete-in-progress 状态或禁止新 waiter 的标志。
- 具体后果：另一个 task 可在窗口中查到仍 published 的 event 并挂入新 waiter；删除随后不再清空 pending list 便移除并释放对象，破坏 pend-list/sched-link ownership 与任务可唤醒性。
- required fix：把检查/清空 waiter、阻止新 borrower、unpublish 和 free 放在同一外层 lifetime guard 下，或增加受同一 guard 保护的 deleting 状态，使 process 无法再挂入。
- pass condition：对所有 interleaving，delete 开始后无法新增 waiter；free 前 pend-list 为空且每个 sched-link 已唯一转回 task/scheduler owner。

## 5. 停止结论

- Predicate 生命周期：`draft -> blocked-before-review-ready`；没有可报告的 predicate revision。
- Spec 生命周期：未进入 `write-spec`。Predicate 未 review-passed，按 skill 禁止开始 spec review；没有 spec revision。
- 未批准 trusted symbols：无。
- 未运行：QCP parser/symbolic、`check-spec-closure.sh`、VC、proof。
- 两个 blocker 都来自权威 C 的 lifetime/atomicity，而非 proof-local 缺口。未修改权威 C，也未用无依据 exclusive Require 或“API 串行调用”假设强行通过。
