---
kind: spec-review
status: needs-fix
function: "KSemaphoreCreate"
source_revision: "source-s1-a641419bb17a"
spec_revision: "spec-r1-ae9c60540673"
predicate_review: ".docs/Report/2026-09-01-6-predicate-r13-affected-review.md — predicate-r13-f1cb8f0dcb26 — review-passed"
formal_sources:
  rocq_files:
    - "lib/IdManagerPure.v"
    - "lib/SemaphorePure.v"
    - "lib/SemaphoreCritical.v"
    - "lib/DoublyLinkedList.v"
    - "lib/IdManagerRep.v"
    - "lib/SemaphoreRep.v"
  symbols:
    - "KSemaphoreCreate"
    - "_SemaphoreCreate"
    - "CriticalAreaLock"
    - "CriticalAreaUnLock"
    - "IdInsertObj"
    - "AllocId"
    - "InsertObj"
    - "InitDoubleLinkList"
    - "DoubleLinkListInsertNodeAfter"
  annotated_c_file: "annotated_C/src/KSemaphoreCreate.c"
checks:
  - "Rocq 8.20.1 predicate full build and make-q passed"
  - "gcc -m32 -std=c99 -fsyntax-only -fno-builtin passed for all nine slices"
  - "manual source/macro/dispatch and caller-local callee-contract scan"
approval:
  approved_by:
  approved_at:
  predicate_revision:
  spec_revision:
---

# Spec 审阅：`KSemaphoreCreate`

Spec manifest 命令为 `sha256sum annotated_C/src/*.c | sort | sha256sum`，完整 hash 为 `ae9c60540673e1636c4a59d2b43bcea01cf491a6052ec2b76b8b8c73f6bebda0`。Source revision 使用 4 个 canonical C、5 个相关 layout/macro header 与 `stm32f103-nano/config` 的 checksum manifest，完整 hash `a641419bb17abf4e755a8d6c1792937804dc5554b947b6de360c4ea5f04e6839`。

## 1. 用普通话说明

- 调用者提供 `uint16` value、固定配置/dispatch 上下文、可再进入的 nested-critical 接口、与 atomic create 一致的 `safeExec` continuation，以及 `done` 函数指针表的线性所有权。
- trusted allocator 失败或 ID 耗尽时返回 `-5`，semaphore abstract state 不变；成功时返回 `AllocId` 选择的最小空闲 ID，发布 value 为输入、waiter 为空的新对象。
- 所有路径保持 handler 栈形状并返回 `semaphore_critical_enterable`；wrapper 原样返回 `store_semaphore_done`。成功路径把 heap block 转入 ID manager 与 `k_sem_list`，失败路径释放它。
- Direct callees 只使用 predicate r13 中的明示 spatial/effect predicates；没有用不透明 `*_pre/*_post/*_spec` 隐藏资源。
- 本 spec 不承诺 allocator 必定成功，不把 ID 失败中间发布为稳定 semaphore，不改写 waiter/task 状态，也不将 debug 死分支说成可执行 effect。

## 2. Review-ready 条件

- Predicate：`predicate-r13-f1cb8f0dcb26` 已在 r13 affected-only review 中 `review-passed`。
- 完整可达闭包固定为上述 9 个非 trusted symbol；`KDEBUG_NOT_IN_INTERRUPT` 在 `semaphore.c:24-28` 重定义为空，因此无 ISR guard/GetIsrCounter；`done.SemaphoreCreate` 唯一解析为 `_SemaphoreCreate`；`SYS_KDEBUG_LOG(KDBG_IPC,...)` 展开为 `if (0)` 死分支。
- 用户逐名批准 trusted：`x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`，批准证据见 r1 context report 及用户随后的“批准继续”。
- Trusted contracts 分别表达 32-byte disjoint allocation/null、全零化、精确 free 消耗、IRQ/ghost enter、identity-or-one-step IRQ/ghost exit，以及无 semaphore-memory effect 的死分支/NULL-check 日志。
- 9 个 slice 各只有一个 active function body；static helper 仅在 slice 中 externalize；assignment-in-condition、NULL macro、dispatch 和 debug macro 的 normalization 都在文件头记录。
- Caller-local `CriticalAreaLock/UnLock`、`IdInsertObj`、`AllocId`、`InsertObj`、`InitDoubleLinkList`、`DoubleLinkListInsertNodeAfter`、`_SemaphoreCreate` contracts 与对应 active slice 为 alpha-equivalent；每个 polymorphic/abstract-state call 都有明示 `where`。
- `gcc -m32 -std=c99 -fsyntax-only -fno-builtin` 对 9 个 slice 全部通过；placeholder/opaque-contract 扫描零匹配。依据阶段门限，没有运行 QCP parser/symbolic、closure script、VC 或 proof。
- 作者自审未留 `[OPEN]`；结论：`ready`。

## 3. 路径与 Effect

- `KSemaphoreCreate` wrapper，`semaphore.c:246-251`：空 debug guard 无运行时路径；唯一 dispatch 调用 `_SemaphoreCreate`，保留 `store_semaphore_done`，并用同一 `SemaphoreCreateEffect`/`safeExec` 返回。
- allocator 失败，`semaphore.c:39-41`：`x_malloc(32)` 返回 0，直接 `-5`，abstract state、critical 界面与 done table 不变。
- ID 失败，`semaphore.c:43-50`：分配块已清零；进入 critical 后 `IdInsertObj` 返回 `-1/id_manager_full`，manager/registry 重构为原 state，`x_free` 消耗私有 block，unlock 以 identity guarantee 返回，最终 `-5`。
- 成功，`semaphore.c:43-61`：`IdInsertObj` 先产生 ID-registered/unpublished transient；随后写 `value`、建立空 `pend_list`、把 `sem->link` prepend 到 `k_sem_list`。该步与 `SemaphoreCreateSuccess/SemStepCreate` 对应，unlock 做一步 guarantee，返回新 ID。

## 4. Dependencies 与设计检查

- `SemaphoreCreateEffect/Atomic/Visible`：公开 API 的 old/new/result 与 continuation 语义。
- `semaphore_critical_enterable/interface`、lock/unlock pending 和 `SemaphoreGuarantee`：nested IRQ counter、ghost 与 concrete invariant 的进入/退出。
- `store_sem_allocated/zeroed_private/after_id_insert_private/semaphore_id_registered/publish_ready_private`：32-byte heap block 在 create lifecycle 各阶段的唯一 owner ledger。
- `store_id_manager*`、`store_dll*`、`dll_insert_after`：ID bitmap/lazy bucket 与 intrusive list 的 direct-callee 边界。
- `store_semaphore_done`：原 wrapper 函数指针 load 的内存所有权；直接调用归一化不删除该 frame。
- 机械检查范围：predicate Rocq build/freshness，9 个 C slice 语法，formal/spec placeholders，manifest。结果均通过。

## 5. Review Issues

- `SPEC-R1-01 | blocker | open`：`IdInsertObj` 成功 Ensure 没有保留 `AllocId` 建立的 `id_manager_min_free_id(sm,before,id)`。`store_id_manager` 的 wf 不能推出“更小 ID 全已用”，因此 `_SemaphoreCreate` 无法建立 `semaphore_id_registered` 和 `SemaphoreCreateSuccess/SemStepCreate`。最小修复是在 `InsertObj` 与 `IdInsertObj` canonical/caller-local 成功边界保留 min-free，并逐项重审 `IdInsertObj→_SemaphoreCreate→KSemaphoreCreate`。
- `SPEC-R1-02 | blocker | open`：权威 `xs_sem.h:42-48` 为匿名 `SemaphoreDoneType`，predicate r13 却用无 C 载体的 `"SemaphoreDone"` tag 表示 slot，wrapper slice 又没有 ABI-equivalent tagged declaration/layout check/原 field load。结果 `store_semaphore_done` 无法证明覆盖 `done.SemaphoreCreate` load，并使 predicate r13 基础失效。通过条件是新 predicate 以 checked offset/sizeof 关系绑定 tagged ABI normalization，wrapper 保留 field load 与唯一 initializer/dispatch，先完成 predicate affected-only review。
- `SPEC-R1-03 | non-blocker | open`：source manifest 报告没有逐名列出 10 个输入，reviewer 需要带外消息才能复现。修复为在报告记录以下 trial-relative 路径及完整命令（纯报告修复，不产生 spec revision）：
  - `../Ubiquitous/XiZi_IIoT_Macro/kernel/thread/{semaphore.c,CriticalArea.c,id.c,double_link.c}`
  - `../Ubiquitous/XiZi_IIoT_Macro/kernel/include/{xs_id.h,xs_sem.h,xs_klist.h,xs_base.h,xs_kdbg.h}`
  - `../Ubiquitous/XiZi_IIoT_Macro/board/stm32f103-nano/config`
  - 从 trial 根运行 `sha256sum <上述10路径> | sort | sha256sum`，应得 `a641419bb17abf4e755a8d6c1792937804dc5554b947b6de360c4ea5f04e6839`。

## 6. Review-passed 条件

- 验证范围：`pass`。
- Contract 可读性：`pass`。
- 路径、返回值和 abstract effect：`fail`（成功路径 min-free）。
- Require/Ensure 强度：`fail`（`IdInsertObj` success 过弱）。
- Old/new、ownership transfer、frame 与资源返还：`fail`（done-table layout 未锚定）。
- Direct-callee 状态：`fail`（min-free 跨 API 丢失）。
- Rocq predicate checks、annotated C 完整性与 blockers：机械项 `pass`，两个 semantic blocker 为 `fail`。

## 7. Review 记录与重审判断

- Review ID：`SPEC-R1-FULL-01`；对 `spec-r1-ae9c60540673` 的首次 `full` review。
- Predicate revision：`predicate-r13-f1cb8f0dcb26`，因 `SPEC-R1-02` 已 `invalidated`。
- 结论：`needs-fix`。
- Review-passed spec revision：待填。
- 用户批准的 predicate/spec revisions：两者 review-passed 后在暂停报告中由用户确认。
