---
kind: predicate-design
status: needs-fix
module: "mutex"
source_revision: "source-s1-2d1e8c5a94b7"
predicate_revision: "predicate-r2-838b778f1e41"
formal_sources:
  rocq_files:
    - "lib/MutexPure.v"
    - "lib/MutexProtocol.v"
    - "lib/MutexRep.v"
    - "lib/MutexCritical.v"
  symbols:
    - "MutexStable"
    - "MutexObject"
    - "MutexState"
    - "mutex_atomic_step"
    - "MutexCritical"
    - "mutex_inv"
    - "store_mutex_id_manager"
    - "store_mutex_registry"
review:
  reviewed_revision: "predicate-r2-838b778f1e41"
  reviewed_by: "independent predicate reviewer + main-agent evidence audit"
  conclusion: "needs-fix"
---

# Predicate 设计报告：`mutex`

> 本报告解释跨 definition、跨文件和模块级设计；正式语义以列出的 `.v` 和 revision 为准。

## 1. Scope 与依据

- 验证配置沿用同日 semaphore trial 已记录的用户批准上下文：`board/stm32f103-nano/config`，Cortex-M3、32 位、非 SMP，mutex/small allocator/shell 启用，`ID_NUM_MAX=128`、`ID_HTABLE_SIZE=16`、`TICK_PER_SECOND=1000`。CRTOS 根没有 `.config`，本 trial 明确把该 board config 作为语义配置。
- 模块边界是 `kernel/thread/mutex.c` 当前配置下 8 个 active 函数：四个 `_Mutex*` 实现与四个 `KMutex*` wrapper。
- source manifest 覆盖 mutex、ID/DLL、critical/ISR、linklist/delay/task/tick、allocator、headers、board config/config.mk 共 19 个权威文件，SHA-256 为 `2d1e8c5a94b74979397dac5d180c188ce52856fa0ee69680fe839b25f34e8127`。顶层 `.git` 为空，不能绑定 commit。
- `xs_kdbg.h:31` 无条件定义 `KERNEL_DEBUG`；四个 wrapper 的 context guard、`NULL_PARAM_CHECK`、`CHECK` active。`KDBG_IPC=0` 仅令相应日志分支为常量假。
- `done` 与 ISR done-table 各只有唯一 initializer、无 writer。未来 direct-call normalization 必须绑定 `mutex.c:205-210`、`isr.c:190-211`；本 predicate 不拥有函数指针表。
- 用户未批准任何 trusted symbol。

### C 分析摘要

- `_MutexCreate`：36-byte allocation、整块清零、critical 内分配首个 ID；ID-full unlock/free；成功初始化 pending head及 `val=1/holder=0/origin=255/count=0`，registry 头插。
- `_MutexDelete`：active NULL guard；resume all waiter；进入 critical 删除 ID/bucket 与 registry，unlock 后 free；源码允许删除仍有 holder 的对象。
- `_MutexObtain`：recursive/free/pend 路径；uint8 count 可回绕。当前 1000Hz 下 tick 换算不返回 0，源码 immediate-timeout 分支不可达；`msec=-1` 是很大的有限等待。
- `_MutexAbandon`：非 holder 写 task error；holder 递减；归零时 handoff 首 waiter 或恢复空闲。
- `KMutexCreate` 的 active guard 展开为 IRQ disable、ISR counter dispatch、非零时打印并无限循环、IRQ restore，随后 dispatch `_MutexCreate`。
- 三个按 ID 操作的 wrapper 在 lookup 后先 unlock 再用裸 mutex pointer，形成并发删除窗口。
- timeout 路径 `delay.c:117-145 -> ktask.c:407-429` 可从任意 pending 位置移除 task并转入 ready。

## 2. C 对象与抽象状态

- `MutexStable` 保存 manager、16-byte bitmap、16 个 bucket heads、registry head 地址与固定容量。
- `MutexObject` 以 allocation address 为生命周期身份，保存注册 ID、value、uint8 count/origin、holder task address、pending task address 顺序。
- `MutexState` 只保存 `k_mutex_list` 顺序对象；bitmap/buckets 从该列表派生。
- 空闲态精确为 `value=1, holder=0, count=0, origin=255, pending=[]`。holder 非空时 value=0；不要求 count>0，以保留源码回绕语义。
- `MutexBucket = option (list MutexObject)` 区分 BSS、lazy-init 空桶和非空桶。
- `MutexStepTimeout` 允许从任意 pending prefix/suffix 删除 timeout task；task/ready/delay 的另一半 effect 仍等待 integration invariant。

## 3. Predicate 分层与 Formal Sources

- `MutexPure.v`：纯状态、validity、ID scan invariants、模块动作、LastSeen、create atomic command。
- `MutexProtocol.v`：mutex-local nested critical STS 与 assertion carrier。
- `MutexRep.v`：DLL、ID manager、registry/body、create/delete transient views、task bridge 与 ISR-counter borrow。
- `MutexCritical.v`：non-SMP nesting counter/PRIMASK handler-stack adapter。
- predicate revision `predicate-r2-838b778f1e41`；manifest `838b778f1e41b835522cb2423326a477df622915e092d310d697cf9993d5e672`。

## 4. Ownership 与 Lifecycle

- manager fields、bitmap、buckets、`id.id/id.link`：`store_mutex_id_manager`。
- registry head 与 `mutex->link`：registry spine；body拥有 value/count/origin/holder 槽与 pending list。
- pending task sched-link 预期由对应 mutex pending DLL拥有；TaskDescriptor其余字段和 ready/delay queues 不属于 mutex invariant。
- create 的 allocated -> zeroed -> ID-reserved -> publish-ready -> invariant 已覆盖；delete 的 ID-removed/registered 与 detached views 已覆盖。
- ISR counter 只由 `store_mutex_debug_isr_counter` 借用，不合入 mutex invariant。
- 当前没有可组合的 task/scheduler spatial integration；纯 `mutex_task_bridge` 不提供权限，所以模块 lifecycle 尚未闭合。

## 5. 关键设计选择

- task-proof DLL/ID predicates固定在 Task carrier，不能与 mutex-local carrier直接 `**`；只复用其组织思路。
- 不复制完整 Task abstract state；holder/pending只保存 task address。
- 不为 immutable done tables建 state；dispatch normalization 留给 spec review。
- 不手写 padding；整块 allocator/memset/free contract在 spec 阶段覆盖36 bytes。
- public API 未禁止 nested critical，未来 spec 必须参数化保留 caller handler stack。

## 6. 检查结果

- Rocq 8.20.1：四个文件按 `_CoqProject` 编译通过；`coqchk CRTOS_Verify.mutex.MutexCritical` 完成并报告 `Modules were successfully checked`。
- trust scan `Parameter|Axiom|Admitted|admit`：零匹配。
- VsRocq 已映射当前 trial 为 `CRTOS_Verify.mutex`，`*.v` 关联 `rocq`。
- create-local ownership覆盖；全模块 task/scheduler/lifetime closure 未通过。

## 7. Review Issues

- `MUTEX-PRED-001` — `blocker` — `open`
  - 证据：`mutex.c:246-256,279-290,311-320`；lookup unlock 后继续用裸 pointer。
  - Mismatch/后果：无可从 C 建立的 lifecycle capability，环境可 delete/free，产生 UAF；让 rely 无条件保活是无依据假设。
  - Required fix/pass condition：源码保持 lock 或 refcount；或提供有源码/客户端依据且 typecheck 的 shared/exclusive capability并证明 delete/borrow 互斥。

- `MUTEX-PRED-002` — `blocker` — `open`
  - 证据：`lib/CrtosInv.v:89-107` 对非 INIT sched-link 为 `emp`；`KTaskDescriptor.v:76-80` 明示 bitfield ABI 不忠实；mutex与timeout路径会访问/转移 task资源。
  - Mismatch/后果：纯 bridge 无法闭合 ready/running -> pending -> ready/timeout 的唯一 owner，也不能授权 priority/exstatus 读写。
  - Required fix/pass condition：提供源码忠实、同一 carrier 可组合的 Task/Scheduler integration，列出各态 owner并通过 typecheck。

- `MUTEX-PRED-003` — `blocker` — `open`
  - 证据：`cmd.c:251,255` 解引用 holder name；`ktask.c:643-666`、`zombierecycle.c:41-75` 可删除/free task；无 mutex-holder cleanup。
  - Mismatch/后果：`holder_is_live` 没有维护者，可能 dangling-holder/UAF。
  - Required fix/pass condition：证明 held-task deletion exclusion/capability，或修改 task delete 清理 mutex 引用；否则必须承认源码缺陷。

- `MUTEX-PRED-004` — `blocker` — `fixed-in-r2`
  - 证据：`delay.c:117-145 -> ktask.c:407-429` 可从 pending 任意位置 timeout/remove。
  - Mismatch/后果：初稿 rely 漏掉真实环境更新。
  - Required fix/pass condition：`MutexStepTimeout` 已加入并编译；跨模块空间转移仍由 `MUTEX-PRED-002` 跟踪。

## 8. Review 记录

- Review ID：`mutex-predicate-full-r2`；revision `predicate-r2-838b778f1e41`；首次 full evidence review。
- Scope：四个 formal files、权威 mutex/ID/DLL/critical/ISR/task/delay/allocator C、配置与现有 task formal。
- 剩余 blocker：`MUTEX-PRED-001`、`002`、`003`。
- 结论：`needs-fix`；不可用加强 Require、纯 Prop bridge 或未经批准 trusted 假设消除。
- Review-passed predicate revision：无。
- 用户确认：不适用；尚未达到 review-passed。
