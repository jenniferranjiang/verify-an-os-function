# Semaphore predicate review

状态：`needs-fix`（历史 revision，已由 r9 取代）

Predicate revision：`predicate-r8-fc7b60d78977`。该 revision 是在 trial 根运行 `sha256sum lib/*.v | sort | sha256sum` 得到的 SHA-256 manifest hash `fc7b60d789776be0339d471b276425e48b7f0516d55c9b71e4668868b816ca33`；其中 `sort` 对 hash-first 的完整 checksum 行做字典序排序。早先 r1-r7 都在 reviewer 给出结论前被草案联动检查中止，未产生 review 结论。最终自检依次补齐通用 ID-manager/critical helper、消除 task ID 重复 ownership、加入 priority 排序和所有 DLL node 非零条件、把 layout relation 纳入 published body、补强 ID-manager 容量/地址合法性、把 Cortex-M3 PRIMASK handler 限制为 0/1，并公开 `uint16` critical nesting counter 的 `depth<65535` 再进入前提。r8 同时固定 abstract value、concrete address 与 ownership 三张图。

固定依据：非 SMP `stm32f103-nano/config`；semaphore module 的十个 active 函数；用户批准 trusted leaf 为 `x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`。

正式文件：`IdManagerPure.v`、`SemaphorePure.v`、`SemaphoreCritical.v`、`DoublyLinkedList.v`、`IdManagerRep.v`、`SemaphoreRep.v`。

## C 与 lifecycle 结论

- `DECLARE_ID_MANAGER` 展开为 16-byte bitmap、16 个连续 bucket heads 和固定 manager；bucket 允许 BSS `(NULL,NULL)`、已初始化空 DLL、已初始化非空 DLL 三类源码形态。
- 每个 published semaphore 同时进入 ID bucket 与 `k_sem_list`，其 `pend_list` 管理从 task 模块临时转入的 sched-link。create 覆盖 allocation → zeroed → ID-registered/unpublished → publish；delete 覆盖 published → waiters returned → detached → free。
- `_SemaphoreObtain/_SemaphoreAbandon/_SemaphoreSetValue/_SemaphoreDelete` 的 waiter membership、value 更新、wake/timeout ownership 接口均由 module state 与 waiter-transfer predicates 覆盖。
- semaphore TU 在 include 后显式 `#undef KDEBUG_NOT_IN_INTERRUPT` 并重定义为空，因此五个 public wrapper 不进入 ISR-manager 闭包；先前只读 C-analysis 对该点的相反推断已由 `semaphore.c:24-28` 否决。
- `k_sem_list` 的外部 `ShowSem` 读取只在 critical 内临时展开并 refold `semaphore_inv`，不另建重复 owner。

## Unique-owner ledger

- Manager 四字段、bitmap、bucket-head 数组、每个 `sem->id.id` 与 `sem->id.link`：`store_id_manager`，经 `store_sem_id_manager` 接入 module invariant。
- `k_sem_list` head、每个 `sem->link`、published object body：`store_sem_registry`。
- `sem->value`、`sem->pend_list` head、padding：`store_semaphore_body`。
- Pending task 的 sched-link 与转入 semaphore 的 priority/exstatus：`store_dll store_semaphore_waiter_payload`；插入前或 wake/timeout 后由 `store_semaphore_waiter_transfer` 交还 task/scheduler。`task->id.id` 始终由 task ID manager 唯一拥有；`LinklistResume/ResumeAll` 在同一 critical 内通过 task-module lookup view 借用，不在 semaphore payload 复制。
- 新分配对象：`store_sem_allocated`；清零后：`store_sem_zeroed_private`；ID 登记后 remainder：`store_sem_after_id_insert_private`；发布前：`store_sem_publish_ready_private`；删除后：`store_sem_detached`。这些状态互斥且各自覆盖当时仍属创建者/删除者的所有 32 bytes。
- 静态 dispatch：`store_semaphore_done`，由 wrapper 线性借用并原样返还。critical nesting counter 属于 critical interface 的 `store_critical_nest`，不混入 semaphore invariant。

## Formal checks

- Coq 8.20.1：`PATH=/home/xinra/.opam/default/bin:/usr/bin:/bin make -f Makefile lib/SemaphoreRep.vo`，通过。
- `rg -n '\b(Parameter|Axiom|Admitted|admit)\b' lib --glob '*.v'`，零匹配。
- `/usr/bin/coqc` 是 8.18，不能读取 QCP 8.20 `.vo`；正式检查固定使用 `/home/xinra/.opam/default/bin`。QCP 的 `NestedCriticalSTS.vo` 与 `ArrayLib.vo` 另有 inconsistent-assumptions 错误，因此 `SemaphoreCritical.v` 按该公开 source 的同型协议建立当前 CRTOS 专用最小 nested STS，并成功 typecheck；未引入项目公理或 token record。

## Full-review 记录

独立 reviewer 完成首次 full review，结论为 `needs-fix`。Manifest 精确复现为 `fc7b60d789776be0339d471b276425e48b7f0516d55c9b71e4668868b816ca33`，Rocq 8.20.1 全量编译、`make -q` 与 forbidden-token 扫描通过；未运行 QCP parser/symbolic、closure、VC 或 proof。

- `PRED-R8-01 | blocker | open`：pending payload 持有 `cur_prio` 且要求持久 `Sorted`，与 `_KTaskPrioSet` 对 suspended task 原地改写 priority 冲突。
- `PRED-R8-02 | blocker | open`：`waiter_id` 没有与 task ID manager 的正式 `(task,id)` lookup/consistency 关系。
- `PRED-R8-03 | blocker | open`：`ShowSem/GetSuspendedTask` 读 task name，但没有 task-owned name borrow 与 semaphore 遍历的组合视图。
- `PRED-R8-04 | blocker | open`：`SemStepWaiters` 允许任意 well-formed waiter rewrite，guarantee 又使用有限步闭包，超出源码操作。
- `PRED-R8-05 | blocker | open`：critical protocol、`KTaskOsAssignLockNest`、条件化 invariant 与 BSS 初始端点没有闭合空间接口。

r8 不是 `review-passed` revision。后续必须仅复审上述 issue、修改处及其 dependency closure。
