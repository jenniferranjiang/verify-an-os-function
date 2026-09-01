# Semaphore predicate r9 affected-only review

状态：`review interrupted`（无结论，已由 r10 取代）

Predicate revision：`predicate-r9-5b9181d852e7`。在 trial 根运行 `sha256sum lib/*.v | sort | sha256sum` 得到 manifest hash `5b9181d852e7cc38f8af3380ecd9da08771029409d9f2a9b33c15a60525f2068`。权威 C、配置、scope 和用户批准的 trusted 列表均未变；本 revision 只修复 r8 full review 报告的 `PRED-R8-01..05`、直接修改处及 dependency closure。

## 修复记录

- `PRED-R8-01`：`SemaphoreWaiter` 只保留 task 地址；`semaphore_inv` 不再拥有 `cur_prio`，也删除不可保持的持久 `Sorted`。`SemaphoreTaskView` 把真实 `uint8` priority 作为 task-owned critical-scope 分片，范围按 `_KTaskPrioSet` 真实参数保留为 `0..255`。按优先级插入关系只表达当次 C 扫描，不对后续 priority 修改做虚假承诺。
- `PRED-R8-02`：删除 semaphore ghost `waiter_id`。`SemaphoreTaskView` + `semaphore_task_lookup` + `store_semaphore_task_view` 把唯一 task 地址、唯一 ID 与真实 `task->id.id` 单元连接；task ID field 仅在线性转交的 task-owned view 中有一个 spatial owner。
- `PRED-R8-03`：`store_semaphore_task_view` 同时提供 32-byte task name 分片；`semaphore_with_task_borrows` 把 registry/pending spine 与所有 waiter 的 task-owned view 显式组合，覆盖 `ShowSem/GetSuspendedTask` 的链表与 name loads，且不将这些字段并入 semaphore invariant。
- `PRED-R8-04`：删除任意 `SemStepWaiters`。`SemaphoreStep` 现在只有 create/delete、obtain decrement、当次 priority-scan insert、head wake、指定 timeout remove、无 waiter 时 uint16 increment、same-value 不变与 changed-value wake-all 这些源码构造子。`SemaphoreRTrans` 仅供环境有限闭包；`SemaphoreOneCallGTrans`/nested exit/`SemaphoreGuarantee` 仅允许恒等或单步本地提交。
- `PRED-R8-05`：`semaphore_critical_interface` 统一组合 `SemaphoreCritical`、值精确等于 handler depth 的 `KTaskOsAssignLockNest`、以及非空 handler 时的 shared invariant；`semaphore_critical_enterable` 另加 `SemaphoreCanEnter`。`semaphore_static_initialized` 与 `semaphore_critical_lifecycle` 明示给出真实静态/BSS 端点、协议安装消耗以及 outside/depth-0 运行时端点。
- 依赖闭包：全局 `NoDup (semaphore_all_waiter_tasks ...)` 排除同一 `sched_link` 跨 semaphore 重复 ownership；`SemStepDelete/ResumeAll`、head wake 与 timeout remove 都显式要求 task views cover。`StableIdManager` 注释的“三个外部地址”已更正为“两个”。

## 机械检查

- `PATH=/home/xinra/.opam/default/bin:/usr/bin:/bin make clean && PATH=/home/xinra/.opam/default/bin:/usr/bin:/bin make -j2`：Rocq 8.20.1 全量编译通过。
- `PATH=/home/xinra/.opam/default/bin:/usr/bin:/bin make -q`：通过，无过期产物。
- `rg -n '\b(Parameter|Axiom|Admitted|admit)\b' lib --glob '*.v'`：零匹配。
- 未运行 QCP parser/symbolic、closure script、VC 生成或 proof。

## Affected-only review 记录

独立 reviewer 开始后，main 自审发现 `SemaphoreEnterCritical` 本身仍缺 `SemaphoreCanEnter handlers`，协议可表示真实 `uint16` counter 无法 refold 的 65535→65536 进入。复审在给出任何结论前被中止；r9 不是 `review-passed` revision。
