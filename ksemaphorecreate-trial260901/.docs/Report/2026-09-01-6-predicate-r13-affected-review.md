# Semaphore predicate r13 affected-only review

状态：`invalidated`

Predicate revision：`predicate-r13-f1cb8f0dcb26`。Manifest 命令为 `sha256sum lib/*.v | sort | sha256sum`，完整 hash 为 `f1cb8f0dcb26a65926b3b910f606d686454f5deaac47fc0c97b29a83dd527afb`。权威 C、`stm32f103-nano/config`、模块/target scope 和用户批准的 trusted 函数列表未变。

r13 累计包含 r8 full review 中 `PRED-R8-01..05` 的全部修复：

- semaphore pending invariant 只拥有 `sched_link` spine，不持有 task `id/cur_prio/name/exstatus`，不要求会被 `_KTaskPrioSet` 破坏的持久 Sorted。
- `SemaphoreTaskView` 及其唯一 spatial 解释作为 task-owned、critical-scoped 线性 borrow，正式连接 `(task,id)`、当前 `uint8` priority、32-byte name 与 exstatus；`semaphore_with_task_borrows` 组合 `ShowSem/GetSuspendedTask` 需要的全部 owner。
- waiter 变化仅由源码对应的 create/delete、decrement、当次 priority scan insert、head wake、指定 timeout remove、uint16 increment、same-value identity 和 changed-value wake-all action 表示。`SemaphoreStep` 另要求 before/after 都满足 `semaphore_world_wf`，所以 rely 闭包不能通过非法中间状态；本地 guarantee 仅为 identity 或一条 step。
- `semaphore_critical_interface`、`semaphore_critical_enterable`、lock/unlock pending 中间态与 `SemaphoreCanEnter`-guarded STS enter 共同覆盖 ghost stack、真实 uint16 counter、conditional invariant 和两条 wrapper counter 语句。
- 生命周期起点精确拥有 `repeat None 16` 的真实 BSS ID buckets、静态 self-linked `k_sem_list`、counter 0 与 dispatch；正式 phase step 连接到 installed outside/depth-0 运行时接口。
- 全局 waiter-task `NoDup` 防止同一 `sched_link` 跨 semaphore 重复 owner；task view 同时对 task 地址和 task ID 要求唯一。

详细历史修复与自审依赖见本日 r3-r5 报告。r9/r10 的 affected-only review 都在出结论前由 main 中止；r11/r12 没有提交 review；因此 r8 仍是唯一已有正式结论的历史 revision（`needs-fix`）。

## 机械检查

- Rocq 8.20.1：`make clean && make -j2` 全量编译通过，`make -q` 通过。
- 六个 formal `.v` 的 checksum 行已记录，manifest 精确复现为上述 hash。
- `Parameter|Axiom|Admitted|admit` forbidden-token 扫描零匹配。
- 未运行 QCP parser/symbolic、closure script、VC 生成或 proof。

## Affected-only review 记录

原独立 reviewer 已仅检查 `PRED-R8-01..05`、r9-r13 修改处及 dependency closure，结论为 `review-passed`。五个 blocker 状态均为 `fixed`：

- `PRED-R8-01`：address-only waiter、task-owned current-priority view 与 call-local scan relation使 `_KTaskPrioSet` 后 semaphore 物理顺序 invariant 仍可 refold，且 `cur_prio` load 只有一个 owner。
- `PRED-R8-02`：唯一 addr/ID 约束、lookup/cover 与 task view 的唯一 spatial 解释将真实 `task->id.id` 与 `(task,id)` 绑定，semaphore invariant 不拥有该字节。
- `PRED-R8-03`：`semaphore_task_borrow_view/semaphore_with_task_borrows` 为 Linklist 与 `ShowSem/GetSuspendedTask` 的 ID、priority、name、exstatus loads 提供唯一 owner，全局 waiter-task `NoDup` 防止 sched-link 重叠。
- `PRED-R8-04`：全部 action 与真实 C 路径对应，`SemaphoreStep` 保证两端 wf，仅 rely 做闭包，local/nested exit 只能 identity 或单步。
- `PRED-R8-05`：combined/enterable/pending critical predicates、STS `CanEnter`、identity-or-one-step exit、精确 static/BSS source 与 lifecycle install step 闭合 counter/handler/shared-memory 生命周期。

Reviewer 精确复现 manifest `f1cb8f0dcb26a65926b3b910f606d686454f5deaac47fc0c97b29a83dd527afb`；Rocq 8.20.1 产物全部新于源文件，`make -q -f Makefile real-all` 与 target make-q 均返回 0，forbidden-token 零匹配。未运行 QCP parser/symbolic、closure、VC 或 proof。

Review-passed predicate revision：`predicate-r13-f1cb8f0dcb26`。

## 后续失效记录

Spec `SPEC-R1-FULL-01` 在对 wrapper 原始 field load 做 source-faithfulness 检查时发现：权威 `xs_sem.h:42-48` 是无 tag 的匿名 `SemaphoreDoneType`，而 r13 `store_semaphore_done` 使用了没有 C 载体和 layout relation 的 `"SemaphoreDone"` tag。这使五个 slot ownership 无法绑定真实 C ABI，属于上游 formal basis 变化；因此 r13 原 `review-passed` 结论失效，不得再作 spec/implement 依据。
