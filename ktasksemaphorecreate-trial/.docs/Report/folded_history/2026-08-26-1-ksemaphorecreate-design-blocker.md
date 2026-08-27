# KSemaphoreCreate predicate/spec 设计阶段报告

- 日期：2026-08-26（Asia/Shanghai）
- trial：`/home/xinra/crtos/ktasksemaphorecreate-trial`
- 用户目标名：`ktasksemaphorecreate`
- 权威实现映射：仓库不存在该符号；实际目标为 `KSemaphoreCreate(uint16)`，private callee 为 `_SemaphoreCreate(uint16)`。
- 当前阶段：predicate full review = `needs-fix`；spec = `draft/not-reviewed`
- implement：未进入
- QCP proof/VC：未调用 `qcp.proof`；VC 文件数 0

## 固定上下文

权威目标源码为 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c`，SHA256：
`d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec`。

验证配置是 KD233 派生的 LP64、RISC-V64、非 SMP slice，固定 semaphore、
128 IDs、16 buckets、32 priorities、100 Hz、RR_REMAIN、Event/Mutex/MessageQueue/
SoftTimer、stack overflow check 与 32-byte task name。`config/SOURCES.sha256`
固定了本轮已分析的 26 项 source/config 输入；全部复算成功。

## C 分析结论

semaphore 模块含五个 private 实现和五个 public function-table wrappers。
create 有三条路径：allocator 失败返回 `-ENOMEMORY`；加锁后 ID 耗尽时 free、
unlock 并返回 `-ENOMEMORY`；成功时使用最小空闲 ID，初始化 value/空 pend-list，
把对象插入全局表头并返回 ID。LP64 `struct Semaphore` 为 64 bytes，padding 为
offset 2..7 与 26..31。

其余模块路径决定 predicate 必须覆盖 Task suspend/wake、Task ID registry、
ready vector、Delay、timeout、RR_REMAIN scheduler、ShowSem 和 nested/raw IRQ
协议。源码还存在两个重要事实：`KTaskPrioSet` 接受任意 uint8 priority；
priority>=32 的 suspended task 没有内存安全的 ready wake 路径。Task name 的
`strncpy(..., 32)` 不保证 NUL，不能把 NUL termination 写进全局 invariant。

## 修改文件

- `Makefile`
- `config/verification.config`
- `config/verification_xsconfig.h`
- `config/SOURCES.sha256`
- `lib/dll_abs.v`
- `lib/dll.v`
- `lib/NestedCriticalSTS.v`
- `lib/CrtosTaskSlice.v`
- `lib/SemaphorePure.v`
- `lib/SemaphoreRules.v`
- `lib/SemaphorePredicates.v`
- `annotated_C/src/semaphore_create_internal.c`
- `annotated_C/src/ksemaphore_create.c`

## Predicate/ownership 产物

已完成并经 reviewer 确认的部分：

- Semaphore 64-byte 唯一 ownership、padding、ID/global/pend intrusive links；
- bitmap、lazy ID buckets、精确 bucket flag 更新与 no-free-ID；
- create fresh address、精确 after-state、valid before/after transition；
- waiter embedded sched-link 地址、priority mutation、equal-priority FIFO；
- Delete/Obtain/Abandon/SetValue atomic commands；
- Obtain 的 wait/delay/status 与同一 task identity 绑定；
- uint8 priority 的真实范围，以及 priority>=32 无安全 wake transition；
- 上游 NestedCriticalSTS 通用 transition/STS conversion 在当前依赖下重编译复用；
- Task-ID/ready/Delay/external-container spatial 草案、SEM_WAIT spine 单一委托；
- Delay LP64 padding、Task stack check 字段与 32-byte task name buffer owner。

当前 reviewed predicate revision：
`39212c1fb947c7b491478f1c7d27b8213e231abda3e4ddffe3113b811fd3cf96`。

结论：`needs-fix`，不是 `review-passed`。

## Spec 草案

两份 annotated C 已形成 `_SemaphoreCreate` leaf 与 `KSemaphoreCreate` wrapper
验证闭包。create success result 中的 `sem_addr` 与真实 after-state 绑定；
ID failure 声明 no-free-ID；Task slice resource被显式 frame。

当前 spec revision：
`7dea160304991de3b62df740d74b2d318731f8913619ddfc458289bc30560632`。

由于 predicate 尚未 review-passed，skill 禁止开始 spec review；因此该 revision
只有 draft/symbolic 证据，没有 spec-review 结论。

## Formal checks

- `make lib`：PASS（Rocq 8.20.1）
- C syntax：两份 annotated C PASS
- closure CLI dry-run：两份 PASS
- trust scan：PASS，无未实现逻辑占位
- source/config SHA256：26 项 PASS
- QCP-MCP `_SemaphoreCreate`：`symbolic(342)` success，37 auto / 14 manual，session closed
- QCP-MCP `KSemaphoreCreate`：`symbolic(133)` success，2 auto / 1 manual，session closed
- VC 文件：0

复现：

```sh
cd /home/xinra/crtos/ktasksemaphorecreate-trial
make lib
bash /home/xinra/crtos/.agents/skills/verify-an-os-function/scripts/check-spec-closure.sh /home/xinra/crtos/ktasksemaphorecreate-trial
cd /home/xinra/crtos
sha256sum -c ktasksemaphorecreate-trial/config/SOURCES.sha256
```

机械检查耗时见 `.docs/Report/check-timings.tsv`；最近一次 closure 总耗时
1139 ms。分析与人工 review 未伪造耗时数字。

## 无法消除的当前 blockers

1. `PRED-CRIT-04`：critical STS state 仍只有 `SemaphoreState`，完整 mutable
   `CrtosTaskSlice` 是 invariant 内 existential witness；它可在 STS stutter 时
   更换，因而不是受 transition 约束的唯一 product state。修复要求把完整
   Task/Delay/scheduler state 提升进全局 critical product state，并区分
   READY/RUNNING。
2. `PRED-IRQ-02`：三条 wake/reschedule 路径通过 raw IRQ disable/enable 调用
   scheduler，不经过当前 critical protocol；ISR manager/context-switch resource
   与锁外 Done-table borrow 尚无统一 owner/acquire/return 接口。
3. `PRED-LIFE-03`：KTaskCreate 在 ID/global publish 并 unlock 后才初始化
   stack；真实可见的半初始化 task 与失败回滚/zombie/free 生命周期未进入
   product state。当前安全 stack invariant无法表示该 unlock 点。
4. `PRED-PRIO-02`：`Assign.current_priority` 被错误绑定到 running.cur_prio；
   Startup 和 RUNNING `KTaskPrioSet` 的真实写点不保持该等式。
5. `PRED-INIT-02`：当前 initial resource 实际是 post-SysInit ready state，不是
   注释所称 BSS 初态；需按 `SysInitOsAssign -> CreateKServiceKTask` 建立正式
   初始化转移或接收已审阅外部 Task resource。
6. `PRED-SRC-02`：若继续全局 slice，source manifest 还须加入 ktask_stat、
   bitmap、zombie recycle 以及完整 IRQ/context-switch closure，再做 full review。
7. `PRED-CINT-01`：仍需用户对两个具体 parser normalization 做知情批准：
   强制空 `KDEBUG_NOT_IN_INTERRUPT;` 的删除，以及 designated initializer 最后
   trailing comma 的删除。QCP 对原 trailing comma 的错误为
   `unexpected PT_RBRACE`；删除后整文件 symbolic 成功。

这些 blocker 不能通过加强 target Require、弱化 Ensure、把 owner 写成 `emp`，
或把失败延期到 implement 来消除。最小解锁条件是先独立完成并 review-pass
KD233 LP64 non-SMP 的全局 Task/ready/Delay/raw-IRQ/lifecycle product predicate，
然后使本 predicate revision 失效并重新做 full review。

## 门禁状态

- predicate：`needs-fix`
- spec review：禁止进入
- 用户 revision 确认：尚不可请求
- proof/VC/implement：禁止进入

## 用户继续指令后的决定性复核

用户随后明确批准了两项 C parser normalization，并要求继续到 predicate/spec
完成。因此 `PRED-CINT-01` 的人工批准部分已满足；它不再是停止原因。

继续构造全局 Task product state 时发现权威 C 的不可 refold 路径：

1. `ktask.c:864` 在 critical 内把 `task->link` 插入 `xiaoshan_task_head`；
2. `ktask.c:867` 解锁，使该节点成为全局可见状态；
3. `ktask.c:869` 才调用 `task->Done->init(...)`；priority 非法或 stack malloc
   失败会使 init 返回错误；
4. `ktask.c:888-891` 的失败清理只执行 `IdRemoveObj`、unlock、
   `KERNEL_FREE(task)`，没有执行 `DoubleLinkListRmNode(&task->link)`；
5. 全源码检查确认该失败对象不会进入正常 zombie recycle 清理路径。

结果是 `xiaoshan_task_head` 永久保留指向已释放 TaskDescriptor 内嵌 link 的
dangling node，后续 task-list traversal 会解引用 freed memory。allocator 与
task-list predicate 不可能同时成为该 link 的唯一 owner，因此任何覆盖全部真实
Task lifecycle 的 product invariant 都无法在此路径重建。这不是增加 lifecycle
constructor、隐藏 existential witness 或补 lemma 能解决的问题。

解除该源码级 blocker 只有两个有依据的选择：

- 修复权威 C：在 init 失败分支的 critical 区内，free 前从
  `xiaoshan_task_head` 删除 `task->link`；随后重新做 C 分析、predicate full
  review 和 QCP closure；或
- 用户明确改变验证范围，规定 semaphore 的 Task dependency 只接收已初始化
  runtime Task invariant，并排除并发 `KTaskCreate`/失败生命周期。该选择会改变
  原“整个 semaphore 模块与真实依赖闭包”的审阅含义，不能由 AI 自行假设。

在这两个条件之一满足前，predicate 不能诚实标为 `review-passed`，spec review
仍受硬门禁阻止。
