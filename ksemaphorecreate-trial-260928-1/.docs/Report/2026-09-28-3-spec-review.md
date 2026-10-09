---
kind: spec-review
status: review-passed
function: "KSemaphoreCreate"
source_revision: "source-s2-2adc70fc1afc"
spec_revision: "spec-r25-4ac7a52f6b42"
predicate_review: ".docs/Report/2026-09-28-2-predicate-design.md — predicate-r23-1845f34ef435 — review-passed"
formal_sources:
  rocq_files:
    - "lib/SemaphorePure.v"
    - "lib/CrtosOSPure.v"
    - "lib/CrtosOSProtocol.v"
    - "lib/SemaphoreProtocol.v"
    - "lib/SemaphoreRep.v"
    - "lib/CrtosOSRep.v"
    - "lib/SemaphoreCritical.v"
    - "VC/SemaphoreProofLocal.v"
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
  - "source/config manifest extended with xs_isr.h: 2adc70fc1afc9adc12e575002801d20894672db63764e7fdc7825754648893c2"
  - "predicate r23 manifest: 1845f34ef4351d7cb9e97b241d242c8e5295323530c1428066c2f1f273852bfc"
  - "seven Rocq predicate files rebuilt with Coq 8.20.1/OCaml 4.14.1"
  - "nine slices pass gcc -m32 C99 syntax/ABI checks"
  - "manual source, macro, dispatch, return-path and call-closure scan"
  - "independent full spec review of spec-r5: needs-fix (SPEC-R5-01..03)"
  - "independent affected-only review of spec-r6: needs-fix (SPEC-R5-01/03 fixed; SPEC-R5-02 open)"
  - "independent minimal affected-only review of spec-r7: review-passed"
  - "independent affected-only review of spec-r8: review-passed (SPEC-IMPL-01 fixed)"
  - "independent minimal affected-only review of spec-r9: review-passed (SPEC-IMPL-02 fixed)"
  - "independent affected-only review of spec-r10: needs-fix (SPEC-IMPL-03 import visibility open)"
  - "independent minimal affected-only review of spec-r11: review-passed (SPEC-IMPL-03 fixed)"
  - "independent minimal affected-only review of spec-r12: review-passed (SPEC-IMPL-04 fixed)"
  - "independent affected-only review of spec-r13: review-passed (SPEC-IMPL-05 fixed)"
  - "independent affected-only review of spec-r14: review-passed (SPEC-IMPL-06 fixed)"
  - "independent affected-only review of spec-r15: needs-fix (SPEC-IMPL-07 caller entailment open)"
  - "independent affected-only review of spec-r16: review-passed (SPEC-IMPL-07 fixed; both caller node-nonnull entailments machine-checked)"
  - "independent affected-only review of spec-r17: review-passed (SPEC-IMPL-08 fixed; trusted IRQ enter/exit boundary and protocol transitions checked)"
  - "minimal affected-only review of spec-r18: review-passed (named trusted-call instantiation only; r17 design unchanged)"
  - "minimal affected-only dependency review of spec-r19: review-passed (predicate r21 binding and implement-local focus only; canonical contracts unchanged)"
  - "minimal affected-only dependency review of spec-r22: review-passed (R22-LOCAL-01..05 fixed; canonical contracts unchanged)"
  - "VC helper sha256 2e984277c5f078fd8bad0c07f24337c4b59503b35c2088cb82698c25fead730b; final compile/coqchk/trust scan pass"
review:
  reviewed_revision: "spec-r25-4ac7a52f6b42"
  reviewed_by: "spec_r25_review (affected-only review)"
  conclusion: "review-passed"
approval:
  approved_by: "user (standing approval to continue after proof-discovered spec repair and review)"
  approved_at: "2026-10-09"
  predicate_revision: "predicate-r23-1845f34ef435"
  spec_revision: "spec-r25-4ac7a52f6b42"
---

# Spec 审阅：`KSemaphoreCreate`

> 不复制 Require/Ensure 正文。旧 reviewed revision `spec-r24-4abdd1dcbfd1`
> 已被 proof-discovered `SPEC-IMPL-10` 标记为 invalidated。当前 reviewed revision 为
> `spec-r25-4ac7a52f6b42`；九文件 literal manifest（命令见变更记录）为
> `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`。
> r25 只同步增加当前 32 位 ABI 的 Semaphore size 前提及 wrapper slice 所需的
> layout declaration；abstract effect、ownership、C executable 与 predicate r23 不变。

## 1. 函数契约概述

- 调用者提供当前批准 ABI 的 `sizeof(struct Semaphore) = 32`、`uint16 val`、
  `safeExec(SemaphoreLastSeen(...), abs_ksemaphore_create(...), X)` 与统一 OS
  critical-outside view；该编译期事实在当前配置下恒真，不排除合法运行时调用。
- allocator 失败或 ID manager 已满都返回 `-5`。allocator 失败可取零步 rely；ID-full 路径允许在真正取得 lock 前从 `before` rely 到 `current`，但取得锁后对 OS world stutter。
- 成功返回取得锁时 semaphore state 中的首个空闲 ID，发布一个非空 allocation address、输入 value、空 pending list 的对象。新 world 保持 `current` 的 task 与 scheduler 分量，只把 semaphore 分量更新为 `semaphore_create_state`。
- 所有正常返回路径归还 `SemaphoreCriticalOutside`；成功把 allocation 的 id-link、registry-link 与 body 分别转移给统一 invariant，失败不发布对象。
- `safeExec` 仍建立在 reviewed semaphore abstract command 上；critical contract 则使用 `CrtosOSWorld`，避免把 semaphore-only carrier 与共享 Task critical carrier 组合。
- 本 spec 不承诺 allocator 成功，也不承诺函数入口 snapshot 与取得锁时 world 相等；不把 trusted allocator、IRQ 或输出设施的内部状态纳入 OS invariant。

## 2. Review-ready 条件

- Predicate：`predicate-r23-1845f34ef435` 已独立 affected-only `review-passed`，并受用户对 proof-discovered 最小设计修复的 standing approval 覆盖；当前七文件 manifest 与批准值完全一致。
- 当前配置闭包：九个 non-trusted active symbols，即 frontmatter 所列九项；每项恰有一个同名文件、一个 active body 和 canonical contract。
- Trusted leaf：用户于2026-10-07批准`x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`。r17未改变symbol集合；allocator/memset/output保证不变。两个IRQ leaf除PRIMASK的0/1保存/恢复外，分别在真实disable/enable原子边界执行ordinary `outside -> inside+invariant` 与 `inside+invariant -> outside` 协议转换；该增强已获用户批准，r18只补齐其call-site parser实例化。
- Wrapper/static/macro：`KDEBUG_NOT_IN_INTERRUPT` 被 semaphore TU 重定义为空；`done.SemaphoreCreate` 由同 TU 唯一 initializer 解析为 `_SemaphoreCreate`；`DISABLE/ENABLE_INTERRUPT` 分别解析为两个批准的 trusted IRQ symbol。`SYS_KDEBUG_LOG(KDBG_IPC, ...)` 因 `KDBG_IPC=0` 为常量死分支；三个 `NULL_PARAM_CHECK` 保留 `KPrintf` 后无限循环路径。
- 路径与 ownership：每个 load/store 可追溯至 r23 predicate 或函数私有 lifecycle view；create 不访问 task/scheduler 字节，成功 world 显式 frame 这两个分量。
- 一函数一文件：所有正文 call 在调用者定义前都有完整 API contract；九个 non-trusted caller-local/canonical contracts 已逐项对照。四个使用 critical 的顶层 contract 统一为 `(CrtosOSStable, CrtosOSWorld)`，ID/DLL helper 只操作 semaphore 投影。
- Formal checks：七个 predicate files 保持 r23 approved manifest；proof-local helper
  当前 hash 为 `2e984277...730b` 且 Coq 8.20.1 compile 通过。九个 annotated C
  通过 `gcc -m32 -std=c99 -fsyntax-only -fno-builtin`，独立 C11
  `_Static_assert` probe 确认 pointer=4、DLL=8、IdNode=12、Semaphore=32 及
  value/pend/link offsets 12/16/24。本次 review 按门禁未运行 QCP/closure。
- `[OPEN]`：无；`SPEC-IMPL-10` 已由 r25 修复并通过独立 affected-only review。
- 结论：`review-passed`；reviewed revision 为 `spec-r25-4ac7a52f6b42`。
  仍只覆盖 ordinary critical calls；用户已明确授权 proof-discovered spec 修复完成
  review 后无需再次等待批准，可直接继续 proof。

## 3. 路径与 Effect

- `KSemaphoreCreate` wrapper（`semaphore.c:246-250`）：空 debug guard 后调用唯一解析的 `_SemaphoreCreate`；返回值、rely/current、抽象 effect 与所有资源完全转发。
- allocator failure（`semaphore.c:39-41`）：`x_malloc(32)` 返回 NULL，未进入 critical，返回 `-5`。以 `current=before` 的 reflexive rely 和 `after=current` 归还原 outside view。
- ID-full failure（`semaphore.c:43-50`）：lock 从 `before` 取得 `current` invariant；`IdInsertObj=-1` 保持 manager/current，私有 zeroed object 重组后交给 `x_free`；identity guarantee 解锁，返回 `-5`，`after=current`。
- success（`semaphore.c:43-61`）：`IdInsertObj` 选择并占用首个空闲 ID，把嵌入 id node 转给 manager；函数写 value、初始化空 pending head、把 registry link 插到 `k_sem_list` 表头；以一步 create guarantee 解锁，返回该 ID。最终 world 仅替换 semaphore 分量。
- `IdInsertObj`（`id.c:106-120`）：NULL 检查失败打印后不返回；否则调用 `AllocId`。无空闲 ID 时返回 `-1` 且资源不变；成功写 id 字段并调用 `InsertObj`，将 id node 转给 manager。
- `AllocId`（`id.c:24-53`）：NULL 路径不返回；外层 bitmap-byte 扫描和内层 bit 扫描分别由正式 pure invariant 约束。失败 iff `semaphore_first_free=None`；成功置首个空闲 bit 并返回其 ID。
- `InsertObj`（`id.c:62-73`）：两个 NULL 路径不返回；按真实 `id % hoffset` 选择 bucket。BSS NULL head 时先 init，随后表头插入；成功由 allocated-id 中间 view 转成 `semaphore_reserve_state` manager。
- `InitDoubleLinkList` / `DoubleLinkListInsertNodeAfter`：前者把已拥有的两个 link 字段写成 sentinel self-loop；后者在分离的 standalone node 与已表示 DLL 之间执行四次真实 pointer 写入并把 payload prepend 到抽象节点序列。
- `CriticalAreaLock`：本目标只证明 ordinary 路径，从 outside view 取得允许 rely 推进后的 current world 与统一 invariant。
- `CriticalAreaUnLock`：本目标只证明 ordinary 路径，要求并提交 `SemaphoreGuarantee(before,after)` 后归还 outside view。Nested protocol definitions仍保留在 predicate，但不属于本 target 的已证明 canonical scope。

## 4. Dependencies 与设计检查

- Predicate dependency：`predicate-r23-1845f34ef435`（affected-only review-passed、standing approval）；保留 r22 的 embedded-node layout closure，并把 ID-manager bucket 纯视图规范化为 addr/id。统一 OS carrier、实际 ownership、公开接口与 abstract effect 不变。
- Source/config dependency：`source-s2-2adc70fc1afc`；17-file manifest `2adc70fc1afc9adc12e575002801d20894672db63764e7fdc7825754648893c2` 新增此前已读取但漏列的 `xs_isr.h`。配置仍为 `board/stm32f103-nano/config`、32-bit Cortex-M3、非 SMP，权威文件内容未变化。
- Spec/annotation manifest：`sha256sum annotated_C/src/*.c | sha256sum` =
  `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`；
  closure path-normalized manifest 为 `d12c0e7f...1a544`。相对 r24 只增加三处
  同步 size 前提和 wrapper 的 layout-only declarations；C executable 不变。
- ABI：独立 `gcc -m32 -std=c11 -fsyntax-only`
  `.tmp/semaphore_abi_r25_check.c` 以 `_Static_assert` 确认 pointer=4、DLL=8、
  IdNode=12、Semaphore=32 及所依赖的 ILP32 形状；权威 `xs_sem.h` 与 wrapper
  standalone declarations 的字段顺序一致。
- Caller-local equivalence：wrapper 的 `_SemaphoreCreate` 与 canonical contract 逐项相同；`_SemaphoreCreate` 的 ordinary lock/unlock 与各 canonical ordinary overload 相同；ID 与 DLL helper declarations 与对应 canonical contract alpha/typedef 等价。
- 自包含性：r5 补齐 `store_sem_id_node_insert_ready` 与 `SemDLNode` 的 `Extern Coq` 声明，并把依赖类型置于使用者之前；未改变 Require/Ensure 语义。
- r6 stable context：`AllocId`、`InsertObj`、`IdInsertObj` 的 canonical 与所有 caller-local contract 均要求并返还 `SemaphoreStableContext(stable)`；`AllocId` 两个 loop invariant 也保留该事实，因此 `id_limit=128`、`hoffset=bucket_count=16>0` 可贯穿扫描与 `%` 运算。
- r7 normalization ledger：`_SemaphoreCreate` 的 source-static 外置、debug `if (0)` 死分支删除、`x_size_t` ILP32 typedef 归一均已有准确依据；`CriticalArea.c:117` 的 `CriticalAreaLock` 本来就是非 inline 定义，切片保持其声明/函数体且明确记录“无 inline normalization”。109 行的 inline 只属于未进入闭包的 `ResetCriticalAreaLock`。
- r8 parser normalization：QCP parser 不接受 variadic prototype token `...`。三个 `NULL_PARAM_CHECK` expansion 的实际调用均恰为 `(const char *fmt, const char *function, int line, const char *parameter)`；三个切片把 trusted `KPrintf` declaration 收窄为这四个实际参数类型，仍使用同一个 `emp -> emp` guarantee。Cortex-M3 ILP32 cdecl 的实参顺序、宽度、返回行为和调用副作用不变，权威 variadic symbol 本身仍是同一个 approved trusted leaf。
- r9 annotation-syntax normalization：QCP 的 `With` grammar 至少需要一个逻辑 binder；无 ghost 参数的契约直接以 `Require/Ensure` 开始。三个 KPrintf contract 仅删除空 `With`，其 formal pre/post仍逐字为 `emp`/`emp`。
- r10 QCP kind normalization：九个切片已无 `: Type`，逻辑类型使用 `:: *`，
  `SemDLNode` 使用 `:: * => *`，`program` 使用 `:: * => * => *`，所需文件声明
  `unit :: *`。这些 kind 与正式 Rocq signatures 一致。两个顶层单元的
  `safeExec`、`return` signatures 也与 `StateRelMonad/safeexec_lib` 和
  `MonadNotation` 一致。
- r10 import 检查：每个单元仅加入 `Require Import ...SemaphoreCritical`，这不足以
  暴露全部 `Extern Coq` 名称，而且对 DLL/ID leaf 又过度。Coq 8.20.1 smoke check
  证明仅导入该文件后，`semaphore_irq_handler_ok`、`SemaphoreCriticalOutside/Held`
  可见，但 `SemaphoreStable/State/Object`、`SemDLNode`、`CrtosOSStable/World`、
  `SemaphoreRely/Guarantee`、`crtos_semaphore_os_inv` 等均不可见；原因是
  `SemaphoreCritical.v` 对这些 defining modules 使用 `Require Import` 而非
  `Require Export`。`VarGlobalState` 还必须从 `CRTOS_Verify.lib.CrtosGlobState`
  直接导入。所有 Require/Ensure 正文与 C executable 在 r10 中确实未变化。
- r11 direct imports：ID helpers 直接导入 `SemaphorePure`+`SemaphoreRep`，DLL leaves只导入 `SemaphoreRep`；critical helpers按使用导入 `CrtosOSPure`、`SemaphoreProtocol`、`CrtosOSRep`、`SemaphoreCritical`；两个顶层另直接导入 `CrtosGlobState` 与各自使用的 semaphore/OS modules，并保留 StateRelMonad imports。九个隔离 `.v` smoke checks仅使用对应 import集合，对各文件全部 Extern symbols逐一 `Check`，Coq 8.20.1全部通过。
- r12 Extern-block syntax：QCP 的单个 `Extern Coq` declaration list不能混写 kind entry `(:: ...)` 与 term entry `(: ...)`；九文件现把 kinds和terms放入相邻独立 blocks。entry内容、imports、contracts与C statements均未变化。
- r13 helper safety：`AllocId`要求/返还`manager != 0`并在两个loop invariants保留；`IdInsertObj`、`InsertObj`要求/返还`manager != 0 && idnode != 0`。canonical与 `_SemaphoreCreate -> IdInsertObj -> AllocId/InsertObj` 的全部caller-local副本同步。NULL_PARAM_CHECK debug branches因此在合法调用下不可达，不需要把QCP `GlobalStrings`字面量资源泄漏进公共API；KPrintf仍保留approved trusted declaration覆盖syntactic call。
- r14 critical scope：`KSemaphoreCreate`闭包中所有`CriticalAreaLock/UnLock` call均显式选择`ordinary`，没有nested caller。canonical files现只验证ordinary contract；nested protocol definitions仍保留在approved predicate中，但不在本目标声称已证明。
- r14 parser/proof support：移除QCP不解析的ABI审阅typedef（独立`gcc -m32`仍固定尺寸/offset），其余无binder trusted contracts删除空`With`，DLL空payload lambda改为VC-local已编译definition `semaphore_unit_empty := emp`；`AllocId`新增manager/bitmap focus cut与加强loop annotations。除critical scope外均不改变contract语义或C executable。
- r15 DLL safety：Rocq 展开 r14 return VC 后证明 `store_sem_standalone_node` 不蕴含 `node <> 0`，但 `store_sem_dll` post 的新节点 `Forall` 必须含该事实。Canonical Require 与两个 caller-local copy 已同步增加 node 非空；public target、Ensure、predicate、trusted 列表和 executable C 不变。然而 caller entailment 尚未闭合：现有 predicates 只给对象基址非空与字段 ownership，没有给足地址范围或两个内嵌 link 地址非空。
- r16 caller closure：`store_sem_zeroed_private` 已正式拥有 `semaphore_layout_32_ok`；r16 将该纯 ABI 事实加入并贯穿 `IdInsertObj`/`InsertObj` canonical 与 caller-local pre/post，且 `_SemaphoreCreate` 的 focus 不再丢弃它。结合 `store_ushort` 自带的 `isvalidptr_short`，ID link=`sem+4` 与 registry link=`sem+24` 均可推出非零；没有新增 public footprint 或假设。
- `SemaphoreProofLocal.v` 当前绑定的 SHA-256
  `2e984277c5f078fd8bad0c07f24337c4b59503b35c2088cb82698c25fead730b`；
  `semaphore_unit_empty` 的定义体仍严格为 `emp`，其余新增 definition 仅封装
  implement-local DLL/bucket/object/OS-frame focus，以及由 typed value cell 与已审阅
  layout 推导两个内嵌 list-head 非空的 lemma。Coq 8.20.1 当前 compile 通过；
  `coqchk` 与 final trust scan 留待 r25 重新生成后的最终完整性检查。
- `AllocId` 新增的 manager/bitmap `which implies`、`Given bytes` 与两层 loop
  annotations 只展开已审阅 representation 供 symbolic/VC 使用；canonical
  Require/Ensure 与 r13 相同，没有把裸 store 提升为 helper API 或改变 abstract effect。
- 独立 reviewer 确认这些前提不是无依据强化：`manager` 的唯一 closure 实参是
  真实静态对象 `&k_sem_id_manager`，且与 `SemaphoreStableContext`/manager ownership
  对应；`IdInsertObj` 的 `idnode` 唯一来自非空 malloc 对象 `sem` 的首字段
  `&sem->id`，`store_sem_zeroed_private` 和拆出的 `store_sem_id_node_zeroed` 均给出
  `sem <> 0`；成功后的 `store_sem_id_node_insert_ready` 同样保持该事实。
  `IdInsertObj` 再把两项 non-null facts传给 `AllocId`/`InsertObj`，所有正常出口和
  两个 loops 原样保留。限制只落在内部 helper 的真实调用域，public
  `KSemaphoreCreate` contract 未增加资源或纯前提。
- 独立 reviewer 逐文件复核九组 `Extern Coq`：每个 kind block 只含 `::` entries，
  每个紧邻 term block 只含 `:` entries；没有 mixed block、遗漏 entry 或顺序依赖
  回退。r11 已通过的 direct imports、kinds 与 signatures 均保持。
- 独立 reviewer 以五个相互隔离的 Coq 8.20.1 session 复核九文件的五组
  import environments：ID、DLL、critical、wrapper、implementation 各组全部正式
  Extern symbols 与 type signatures 均可见；`VarGlobalState` 由 direct
  `CrtosGlobState` import 提供，top-level `program/safeExec/return` 由现有
  StateRelMonad imports 提供。未依赖 r10 的传递式 `SemaphoreCritical` 假设。
- r9 syntax evidence：QCP 官方本地示例
  `QCP_examples/QCP_demos_human/bst_insert_rec.c:4-11`、
  `sll_queue.c:6-18` 以及 tutorial `given_mark.c:19-21` 均对无 ghost binder 的
  definition/declaration 直接使用 `Require/Ensure`，不写空 `With`。
- 本阶段实际运行：source/predicate/spec manifest、权威 C 对照、call graph/return path 人工扫描、九文件 GCC syntax/ABI、七文件 Rocq 强制重编、formal trust scan。按流程没有运行 implement-only 工具。
- r6 affected-only reviewer 复算 source/predicate/spec manifest，结果分别为
  `2adc70fc...`、`77f0b1b0...`、`839d744f...`；旧 16-file 子集仍为
  `64a13b...`，`xs_isr.h` 为 `cd7867...`。重跑九文件 GCC syntax/ABI 与 formal
  trust scan 通过。审阅没有运行 closure script、QCP parser/symbolic、VC 或 proof。
- r7 minimal affected-only reviewer 复算 spec manifest 为 `95906a84...a854`，逐行
  对照 `CriticalArea.c:109,117` 与 `CriticalAreaLock.c:1-5`，并重跑九文件 GCC
  syntax/ABI 全部通过；确认此处没有 inline normalization，ledger 不再含虚构项。

## 5. Review Issues

- `SPEC-DRAFT-01` — `blocker` — `fixed`
  - 证据：旧 revision 未获得六个 trusted symbols 的逐名批准。
  - 后果：闭包不能固定。
  - 修复与通过条件：用户已逐名批准并在第 2 节记录受限 contract；六项唯一归类为 trusted。
- `SPEC-DRAFT-02` — `blocker` — `fixed`
  - 证据：旧 spec 绑定 predicate r5 needs-fix，并使用 semaphore-only critical carrier。
  - 后果：不能组合真实共享 critical lock 与 task/scheduler ownership。
  - 修复与通过条件：绑定 review-passed r20；top/critical contracts 全部迁移到统一 OS world，manifest 与批准 revision 一致。
- `SPEC-AUTHOR-01` — `blocker` — `fixed-in-r5`
  - 证据：r4 的 `IdInsertObj.c` 漏声明 `store_sem_id_node_insert_ready`，`InitDoubleLinkList.c` 漏声明 `SemDLNode`；两处依赖类型声明顺序不稳健。
  - 后果：每文件 formal annotation 不能保证自包含，QCP 解析阶段可能出现未绑定符号。
  - 修复与通过条件：四个 `Extern Coq` block 已补齐/重排；GCC 与 formal symbol 人工检查通过。
- `SPEC-R5-01` | `blocker` | `annotated_C/src/AllocId.c:21,32-46,60-76`; `IdInsertObj.c:25,36-72`; `InsertObj.c:23,66-77`; `_SemaphoreCreate.c:60,132-145` | r5 的三个 ID helper contract 未固定 manager 配置，允许 `bucket_count=0` 与 modulo-zero 模型 | r6 在三个 canonical、全部 caller-local 副本及 `AllocId` 两个 loop invariant 中加入并返还 `SemaphoreStableContext(stable)`，并补齐 `Extern Coq`；定义 `SemaphoreRep.v:197-203` 直接给出 `id_limit=128`、`bucket_count=16>0` | affected-only review 已确认 canonical/caller-local alpha 等价、两层循环保留事实，且 `InsertObj.c:92` 的 `% manager->hoffset` 具有正除数 | `fixed-in-r6-reviewed`.
- `SPEC-R5-02` | `blocker` | 权威 `kernel/thread/CriticalArea.c:109,117`；`annotated_C/src/CriticalAreaLock.c:1-5`；本报告第 4 节 normalization ledger | r6 虚构 `CriticalAreaLock` inline-removal；权威 117 行从未使用 inline，109 行属于 `ResetCriticalAreaLock` | r7 删除错误陈述并明确记录此处没有 inline normalization；其余已通过的 static/debug/x_size_t 记录不变 | minimal affected-only review 已对照 117 行、复算 r7 manifest并重跑九文件 GCC；ledger无虚构项 | `fixed-in-r7-reviewed`.
- `SPEC-R5-03` | `blocker` | `xs_isr.h:84-88`、s2 17-file manifest、七个 predicate formal manifest | r5 的 IRQ macro 映射依据未进入 drift gate | r6 固定 `source-s2-2adc70fc1afc`，把内容未变化、此前已实际读取的 `xs_isr.h` 加入 17-file manifest；旧 16-file 子集仍精确为 `64a13b...`，七个 formal 文件仍为 `77f0b1...` | affected-only review 已确认 s2 hash、macro 映射，以及该 ledger-only 扩充不改变 predicate 语义、ownership、接口或已审阅 formal revision | `fixed-in-r6-reviewed`.
- `SPEC-IMPL-01` | `blocker` | full closure symbolic dry-run；r7 `annotated_C/src/AllocId.c:16`；同形 declaration 位于 `IdInsertObj.c`、`InsertObj.c` | QCP parser 在 trusted variadic declaration 的 `...` token 报 syntax error，批准 r7 不能完成 parser gate | r8 将三个 trusted declarations 归一为实际使用的固定四参数签名，contract/调用/ABI不变，并在切片头与 normalization ledger记录 | affected-only review确认五个实际调用均恰有 `(const char *, const char *, int, const char *)` 四个参数；pointer/int 在 Cortex-M3 ILP32 上均为 32-bit，variadic default promotion 与固定 prototype 传递的值/顺序一致；仍调用同一 approved trusted `KPrintf` 并使用 `emp -> emp`，九文件 GCC通过 | `fixed-in-r8-reviewed`.
- `SPEC-IMPL-02` | `blocker` | full closure r8 dry-run；r8 `AllocId.c:21` 及另两处同形 contract；QCP examples `bst_insert_rec.c:4-11`、`sll_queue.c:6-18`、tutorial `given_mark.c:19-21` | 零 ghost binder 的 `With Require emp Ensure emp` 不符合 QCP grammar，parser 在 `Require` 报 expected binder | r9 三处改为官方示例采用的直接 `Require emp Ensure emp`；C declarations、五个 calls、trusted symbol/contract、路径及副作用均未改变 | minimal affected-only review确认三处仅删除空关键字，pre/post仍逐字为 `emp`/`emp`；r9 manifest与 source/predicate hashes精确匹配，九文件 GCC通过 | `fixed-in-r9-reviewed`.
- `SPEC-IMPL-03` | `blocker` | full closure r9 dry-run；九个 r10/r11 `Import Coq`/`Extern Coq`；Coq 8.20.1 per-file checks | r10 kind/signatures正确但依赖单一非-re-exporting import，generated identifiers不可见且 leaf 依赖过宽 | r11按 defining modules采用最小 direct imports，未修改 formal 文件；ID/DLL/critical/wrapper/implementation 五组隔离环境逐一 `Check` 各文件全部 Extern symbols | independent affected-only review确认 imports 足够且按层次相关、r10 kind/signature结论保持、九文件无 `: Type`、r11 manifest/GCC和 transitive closure通过 | `fixed-in-r11-reviewed`.
- `SPEC-IMPL-04` | `blocker` | approved r11 full closure；r11 `AllocId.c:26`及全闭包同形 mixed blocks；task-proof `ktask_create.c:17-26` 的分块先例 | QCP在 kind entry 后的首个 term `:` 报 expected `::`，单 block 不能混合 kind 与 term declarations | r12把九文件 kind/term entries分成相邻独立 `Extern Coq` blocks，不改变 entry、imports、contract或C | minimal affected-only review逐文件确认所有 blocks 单类、相邻且完整；r11 import/kind/signature结论保持，r12 manifest/source/predicate hashes和九文件 GCC通过 | `fixed-in-r12-reviewed`.
- `SPEC-IMPL-05` | `blocker` | approved r12 closure；`AllocId.c:60` KPrintf literal；三个 ID helper `NULL_PARAM_CHECK` paths；`_SemaphoreCreate.c:213-223`; `SemaphoreRep.v` symbols `store_sem_zeroed_private`, `store_sem_id_node_zeroed`, `store_sem_id_node_insert_ready` | helper Requires未直接排除 NULL，QCP进入 debug branch并要求 `GlobalStrings` ownership；把字符串全局资源加入 create 公共 API 会无依据扩大 footprint | r13在三个 helper canonical、全部 caller-local 与 AllocId loops显式携带 non-null facts；KPrintf仍作为 approved trusted syntactic callee | affected-only review确认 manager 为真实静态对象地址，idnode来自已证明非空的 sem/id-node ownership；canonical/caller alpha一致，全部成功/失败post与loops保持facts，public API不变，r12 parser环境、manifest/GCC/source/predicate均通过 | `fixed-in-r13-reviewed`.
- `SPEC-IMPL-06` | `blocker` | r13 CriticalAreaLock/UnLock canonical ordinary+nested named specs；r14全部 critical call sites与 caller-local declarations；`VC/SemaphoreProofLocal.v` | body focus cut同时作用于两套命名前态，QCP无法分别打开 Outside/Held；nested overload不是本目标 dependency closure | r14 canonical只保留 ordinary且与 caller-local 一致；nested predicate/protocol接口保留但报告不声称本目标已证明；parser-only ABI/lambda/empty-With 与 AllocId proof-local annotations做等价归一 | affected-only review确认 call graph无 nested、ordinary contract覆盖完整；public target/predicate/C executable不变；ABI probe、unit helper compile/coqchk/trust、r14 manifest/GCC/source/predicate全部通过 | `fixed-in-r14-reviewed`.
- `SPEC-IMPL-07` | `blocker` | r14 generated `DoubleLinkListInsertNodeAfter_return_wit_1`; `SemaphoreRep.v:15-23,52-60,133-138,235-257,333-348`; `InsertObj.c`/`IdInsertObj.c`/`_SemaphoreCreate.c` helper closure | Canonical 缺少 node non-null；r15虽加入最小 C-safety precondition，但 caller closure 未显式贯穿把 typed-store 地址与 embedded-link offset连接起来所需的 `semaphore_layout_32_ok`。先前以裸 `mstore` 否定 typed-store validity 的论证不成立，现已撤回；真正缺口是 layout fact 的接口贯穿 | caller-to-callee node precondition 缺少直接、可审阅的形式依据 | r16 在 `IdInsertObj`/`InsertObj` canonical与caller-local pre/post贯穿既有 layout fact，并在 `_SemaphoreCreate` 从 `store_sem_zeroed_private` 导出后保留；不修改 approved predicate/public API | 两个实际 caller 的 node expression可由正式 high-level resources机器证明非空，canonical/caller-local alpha等价，hash/GCC/helper checks通过 | `fixed-in-r16-reviewed`.
- `SPEC-IMPL-07-R16` | `blocker` | `CommonAssertion.v:289-299,471-476`; `SemaphoreRep.v:15-23,85-101,235-257,333-348`; r16 `IdInsertObj`/`InsertObj`/`_SemaphoreCreate` contracts；`.tmp/SemaphoreNonnullReview.v` | r16 显式保留 allocation predicate 已有的 `semaphore_layout_32_ok` 并跨两个 helper pre/post传递；typed `store_ushort` 提供 address validity | Coq 8.20.1 已检查：ID path从 `store_sem_id_node_insert_ready` 展开得到 `isvalidptr_short sem`，结合 id-link=`sem+4`推出非零；registry path从 `store_sem_after_id_insert_private` 展开得到 `isvalidptr_short(sem+12)`，结合 registry-link=`sem+24`推出非零。对应的高层 payload entailments也通过 | 无需继续修复；保持 predicate/public footprint不变 | 两条 caller assertion entailment compile通过，三组 canonical/caller-local contracts同步；r16/spec/predicate/helper/source hashes、九文件GCC及helper compile/coqchk/trust均通过 | `fixed-in-r16-reviewed`.
- `SPEC-IMPL-08` | `blocker` | r16 generated `CriticalAreaLock_return_wit_1`/`CriticalAreaUnLock_return_wit_1`; `CrtosOSProtocol.v:CrtosOSProtocolView`; `TaskFinalizeCriticalRule.v` integration boundary；两个critical slices的trusted IRQ declarations；`.tmp/IRQTransitionReview.v` | r16让普通entailment自行把outside STS view改成inside并取得depth token，反向退出也缺少协议动作；普通entailment在同一low state上判断，不能改变精确的STS state set/token，也不能凭空取得或归还`crtos_semaphore_os_inv` | critical proof无法建立，任何proof-local假设都会扩大trust并违反门禁 | r17把既有`crtos_os_enter_core/exit_core`对应的view-shift放到真实IRQ disable/enable trusted原子边界；acquire以`SemaphoreRely(before,current)`允许线性化前环境推进并进入同一`current` world，release以`SemaphoreGuarantee(before,after)`提交world；handler使用实际PRIMASK返回值。counter仍完全由两个non-trusted wrappers frame和更新，所有non-trusted canonical contracts/public API不变 | affected-only review对照`CriticalArea.c`、`xs_isr.h`和Cortex-M3 PRIMASK实现，确认trusted边界与真实屏蔽/恢复原子点匹配；无frame ordinary enter/exit transition由正式core lemmas构造并经Coq 8.20.1 compile/coqchk/trust scan；manifest/GCC/formal checks通过，增强的trusted guarantee仍须用户批准r17 | `fixed-in-r17-reviewed`.
- `SPEC-IMPL-09` | `blocker` | r17 implement parser feedback；`CriticalAreaLock.c:61-63`; `CriticalAreaUnLock.c:63-64`; closure run `20261008T143604-2` | named declaration-only contracts `irq_enter`/`irq_exit` 的call annotations仅写裸标签，parser要求`where (name)`并显式实例化`With` binders；Lock还需`Given handler current`接收post existential | r17设计正确但不能完成parser/symbolic门禁 | r18分别写成`where (irq_enter) stable=stable,before=before`与`where (irq_exit) stable=stable,before=before,after=after`，并在Lock call后加入`Given handler current`；contracts、trust、C executable和资源语义完全不变 | 两处name与全部binder一一匹配，Given只命名既有existentials；literal manifest精确，作者记录的full closure 9/9 syntax+symbolic通过 | `fixed-in-r18-reviewed`.

- `SPEC-IMPL-10` | `blocker` | generated
  `VC/_SemaphoreCreate_goal.v:_SemaphoreCreate_partial_solve_wit_1_pure`；
  `_SemaphoreCreate.c` 首个 `x_malloc(sizeof(struct Semaphore))`；
  `SemaphoreRep.v:semaphore_layout_32_ok` | r24 entry contract 没有提供
  `sizeof("Semaphore") = 32`，该事实只在 allocator post 中出现，因而调用 allocator
  前无法证明其 `size == 32` precondition；QCP auto `Admitted` 曾掩盖该缺口 |
  无占位 auto proof 无法完成，不能把 opaque front-end layout interpretation 当作
  新假设 | r25 在 `_SemaphoreCreate` canonical、wrapper 的 caller-local declaration
  与 `KSemaphoreCreate` canonical 三处同步加入当前 ABI size fact，并在 standalone
  wrapper slice 保留权威 struct layout；predicate/effect/ownership/C executable 不变 |
  affected-only reviewer 必须确认 ABI probe、三处 alpha 同步、caller closure、合法调用
  集合、source/config/trusted/predicate dependency 与九文件 C syntax；随后 implement
  重跑 full closure/QCP 并以 `Qed` 闭合新生成 size obligations |
  `fixed-and-passed-in-r25`。

## 6. Review-passed 条件

- 验证范围：`pass`；s2 manifest 已覆盖 IRQ macro header，九个 non-trusted 与六个 approved trusted 分类不变。
- Contract 可读性：`pass`；按 object/action 命名，无整包 `*_pre/*_post/*_spec` 隐藏义务。
- 路径、返回值和 abstract effect：`pass`；目标与各 helper 的返回/non-returning 路径、create success/failure effect 与源码一致。
- Require/Ensure 强度：`pass`；r16/r17 结论保持。r25 新增 size Require 是
  当前批准 ABI 下对所有调用恒真的编译期事实；在不改变既有 trusted allocator/memset
  contracts 的条件下，它是 callee 到 wrapper 的最小传播，不排除合法运行时调用。
- Old/new、ownership transfer、frame：`pass`；成功显式 frame task/scheduler，失败 stutter，allocation/ID-link/registry-link transfer 闭合。
- Direct-callee 状态：`pass`；受影响的 `_SemaphoreCreate` canonical/caller-local
  contract 已同步，wrapper canonical 传递同一前提；其余 non-trusted contracts 与两个
  trusted IRQ declaration-only contracts 不变。
- Rocq predicate checks、annotated C 完整性与 blockers：`pass`；candidate mechanical checks和review-only transition checks通过，无open blocker。

## 7. Review 记录与重审判断

- 作者候选：`spec-r5-12221b9fe490`，准备首次 `full` spec review。
- 触发原因：predicate r20 已 review-passed/获批，trusted closure 已获批，critical contracts 完成统一 carrier 迁移，并修复 r4 annotation 自包含问题。
- 审阅开始时门禁：正式七文件 manifest 仍为批准值 `77f0b1b09bbd...`，既有
  16-file source/config manifest 也未变化；full review 随后发现该 source manifest
  对 IRQ macro 依据覆盖不完整，见 SPEC-R5-03。
- 独立 full review：`spec-r5-12221b9fe490`，reviewer `spec_reviewer`，2026-10-07；检查九个 annotated C、16-file 权威 manifest 及补充的 `xs_isr.h` 证据、七个 predicate formal sources、全部 return/non-return 路径、caller-local/canonical 等价、critical OS-world carrier、trusted 边界与 extraction normalization。
- r6 作者修复：`spec-r6-839d744faf65`（manifest `839d744f...40a1`），绑定 `source-s2-2adc70fc1afc`。修改范围仅为三个 helper contract及其 callers/loop invariants、切片 normalization 注释与 source ledger；predicate formal manifest仍为批准值。
- r6 affected-only review：reviewer `spec_reviewer`，2026-10-07；检查 SPEC-R5-01..03、三个 helper canonical/全部 caller-local/两个 loop invariant、四项 normalization 记录及 s2/predicate dependency closure。SPEC-R5-01、03 已关闭；SPEC-R5-02 仍 open。
- r7 作者修复：`spec-r7-95906a84e197`（manifest `95906a84...a854`）；仅纠正 `CriticalAreaLock.c` 与报告中的 inline 事实，GCC 复查通过。
- r7 minimal affected-only review：reviewer `spec_reviewer`，2026-10-07；只检查 SPEC-R5-02、`CriticalAreaLock.c:1-5`、normalization ledger、r7 manifest 与九文件 GCC。全部通过，SPEC-R5-02 关闭。
- r7 获用户批准后进入 implement；full closure 的 32-bit C syntax阶段通过，首个 QCP dry-run在 `AllocId.c:16` 因 variadic `...` parser syntax error停止。未生成 VC、未开始 proof。
- r8 作者修复：`spec-r8-1dfffe83daed`（manifest `1dfffe83...6665`）；只修改三个 KPrintf declaration及紧邻 normalization注释，source/predicate/trusted symbol与contract均不变，九文件 GCC复查通过。
- r8 affected-only review：reviewer `spec_reviewer`，2026-10-07；只检查 SPEC-IMPL-01、三个 declaration、五个四参数调用、相邻 normalization 注释、ABI/路径/副作用、r8 manifest 与 transitive closure。manifest 精确为 `1dfffe83...6665`，九文件 GCC 通过；SPEC-IMPL-01 关闭。
- r8 获用户批准后恢复 implement；full closure 在 `AllocId.c:21` 对零 binder 的 `With Require` 报 annotation syntax error，未继续其他文件、未生成 VC。
- r9 作者修复：`spec-r9-c20955d5ddcf`（manifest `c20955d5...2e62`）；只删除三个 KPrintf contract的空 `With` 关键字，pre/post与C declaration均不变，九文件 GCC复查通过。
- r9 minimal affected-only review：reviewer `spec_reviewer`，2026-10-07；只检查 SPEC-IMPL-02、三处 KPrintf contract、QCP 官方无-binder syntax evidence、C declarations/calls、r9 manifest/GCC 与 transitive closure。全部通过，SPEC-IMPL-02 关闭。
- r9 获用户批准后恢复 implement；full closure 在 `AllocId.c:23` 对 `SemaphoreStable : Type` 报 `Undefined identifier Type`，未继续其他文件、未生成 VC。
- r10 作者修复：`spec-r10-54b5cf1977a8`（manifest `54b5cf19...2810`）；按现有 task-proof/QCP syntax统一修正九文件 kind/import/parser declarations，所有函数 contract正文与C executable statements不变，九文件GCC复查通过。
- r10 affected-only review：reviewer `spec_reviewer`，2026-10-07；检查 SPEC-IMPL-03、九文件 imports/kinds、正式 symbol signatures、顶层 StateRelMonad、manifest/GCC 与 transitive closure。kind/signature、无遗留 `: Type`、C/contract不变及 mechanical checks通过；direct import visibility失败，SPEC-IMPL-03 保持 open。
- r11 作者修复：`spec-r11-0bb710af2a83`（manifest `0bb710af...3d36`）；仅把九文件imports按defining modules最小化/补全。九个隔离Coq 8.20.1 symbol-visibility checks与九文件GCC均通过。
- r11 minimal affected-only review：reviewer `spec_reviewer`，2026-10-07；只检查 SPEC-IMPL-03、direct imports、每文件 Extern visibility、r10 已通过 kinds/signatures、r11 manifest/GCC 与 transitive closure。独立隔离 `Check` 全通过，SPEC-IMPL-03 关闭。
- r11 获用户批准后恢复 implement；full closure在 `AllocId.c:26` 的首个term declaration `:` 报 expected `::`，证明mixed kind/term block不合法，未继续其他文件、未生成VC。
- r12 作者修复：`spec-r12-c71efd3bcf5d`（manifest `c71efd3b...99a6`）；仅把九文件的kind与term entries分到相邻独立Extern blocks，内容与语义不变，九文件GCC通过。
- r12 minimal affected-only review：reviewer `spec_reviewer`，2026-10-08；只检查 SPEC-IMPL-04、九文件 Extern block grouping、r11 已通过 imports/kinds/signatures、r12 manifest/GCC 与 transitive closure。全部通过，SPEC-IMPL-04 关闭。
- r12获用户批准后恢复implement；full closure解析到`AllocId`函数体，在NULL debug分支的KPrintf字面量处缺`GlobalStrings`资源而停止，未继续其他文件、未生成VC。
- r13作者修复：`spec-r13-ed393b13c2c7`（manifest `ed393b13...70a7`）；同步加强三个ID helper canonical/caller contracts与AllocId loops的nonnull facts，public KSemaphoreCreate contract、predicate与C executable不变，九文件GCC通过。
- r13 affected-only review：reviewer `spec_reviewer`，2026-10-08；只检查 SPEC-IMPL-05、non-null contract/caller/post/loop closure、真实 caller/global/owner依据、public API不变、r12 parser environment、r13 manifest/GCC/source/predicate。全部通过，SPEC-IMPL-05 关闭。
- r13获用户批准后恢复implement；AllocId已symbolic到文件末尾并产生manual VCs；InitDoubleLinkList symbolic成功。critical canonical的ordinary+nested命名前态使body focus cut互相冲突，另发现QCP不解析inline lambda与ABI审阅typedef。
- r14作者修复：`spec-r14-a7439a0e7451`（manifest `a7439a0e...8526`）；critical canonical只保留本闭包可达ordinary overload；完成等价parser normalizations并新增已编译VC-local `semaphore_unit_empty`；public target contract/predicate/C executable不变。
- r14 affected-only review：reviewer `spec_reviewer`，2026-10-08；只检查 SPEC-IMPL-06、critical scope/call graph/caller equivalence、parser/proof-local normalizations、VC helper与r14 manifest/GCC/source/predicate closure。全部通过，SPEC-IMPL-06 关闭。
- r14 用户于 2026-10-08 明确批准后进入 implement；完整九文件 closure/symbolic 通过。采用统一 carrier 生成 VC 后，Rocq 展开 DLL return goal 暴露 SPEC-IMPL-07，implement 随即停止；全部 r14 generated goal/auto/manual/check 已移入 `.tmp/stale-r14-generated-vc-20261008/`。
- r15 作者修复：`spec-r15-66bfb378225e`（manifest `66bfb378...f027`）；只加强 DLL helper node 非空 Require 及两个 caller-local副本，另保留已通过 symbolic 的 proof-local annotations、`CrtosOS_C_Rules`生成环境与局部变量 `end -> scan_end` 等价重命名。七文件 predicate manifest仍为批准值，九文件 GCC与当前formal build/trust scan通过。
- r15 affected-only review：reviewer `spec_reviewer`，2026-10-08；检查 SPEC-IMPL-07、两个真实 callers、canonical/caller equivalence、public effect、proof-local helper/import/rename 与三份 hashes/mechanical checks。Canonical strengthening与机械项通过，但 caller entailment失败；结论 `needs-fix`。
- r16 作者修复：`spec-r16-b7a98f34d4b9`（manifest `b7a98f34...37c65`）；在 `IdInsertObj`/`InsertObj` canonical及caller-local contracts显式传递既有 `semaphore_layout_32_ok`，并在 `_SemaphoreCreate` focus保留该事实。predicate/helper/source/trusted/public API不变，九文件 GCC与formal build/trust scan通过。
- r16 affected-only review：reviewer `spec_reviewer`，2026-10-08；检查 SPEC-IMPL-07、formal typed-store/layout展开、三组 helper canonical/caller-local同步、两个真实 callers、public footprint 与 source/predicate/spec/helper dependency closure。Coq 8.20.1 对两条 caller assertion entailment及两条 payload entailment编译通过并经 `coqchk`；全部 mechanical checks通过，SPEC-IMPL-07关闭。
- r16于2026-10-08获用户明确批准并恢复implement；full closure run `20261008T135417-2`与九个逐文件QCP symbolic均通过，r16共生成48个manual obligations。leaf proof中`CriticalAreaLock_return_wit_1`暴露outside/inside STS view-shift不能由普通entailment执行，implement立即停止，r16 generated files移入`.tmp/stale-r16-generated-vc-20261008/`。
- r17作者修复：`spec-r17-3cd0c5e3e9ba`（manifest `3cd0c5e3...36f8`）；只增强两个既有trusted IRQ contracts并移动lock focus到真实disable调用前，所有non-trusted canonical contracts、predicate、public API和executable C不变；九文件GCC及当前formal build通过。
- r17 affected-only review：reviewer `spec_reviewer`，2026-10-08；检查`SPEC-IMPL-08`、r16 failure、两个trusted IRQ contracts、critical dependency closure、权威macro/非SMP C/Cortex-M3 PRIMASK原子边界、正式protocol/OS invariant/counter frame以及全部hash/GCC/formal trust checks。`.tmp/IRQTransitionReview.v`（SHA-256 `8662f4aa47526daf18892e0c73fc4e024df74f31c0e015b585cfe941f7961f0f`）由正式core lemmas构造ordinary enter/exit transitions，compile/coqchk/trust scan通过；结论`review-passed`。
- r17获用户明确批准后恢复implement；named trusted call的裸`/*@ irq_enter */`在parser处要求`where (name)`，因此立即退回等价parser修复。用户同时明确授权此类不改变设计的回退修复完成review后无需再次等待批准，可直接继续proof。
- r18作者修复及最小affected-only review：`spec-r18-4fda6049bd92`（manifest `4fda6049...38c1c`）；仅为Disable/Enable call补齐named `where`及全部`With`实例，并在Disable post后加入`Given handler current`。reviewer确认name/binder/existential精确对应，contracts、trusted guarantee、non-trusted API、C executable与formal依赖均不变；作者记录的full closure run `20261008T143604-2` 9/9 syntax+symbolic dry-run通过，未由reviewer重跑。
- r19 作者绑定：implement 中的必要 focus/binding annotations与 helper signature形成当前 annotated manifest `6a7d5aac...e98`；canonical Require/Ensure、C executable、trusted symbols及public effect均与 r18 相同。predicate dependency更新为 `predicate-r21-ff08c5d6b28a`。
- r19 独立 minimal affected-only dependency review：reviewer `predicate_r21_review`，2026-10-08；确认 bucket-head nonnull 是合法数组元素的既有事实，不增加 caller前提或 ownership，不需修改 canonical contracts；source17、formal7、helper hashes、Coq 8.20.1 `coqchk` 与 trust scan均通过。结论 `review-passed`。
- r22 implement-local closure修复：`InsertObj`、`IdInsertObj`、`_SemaphoreCreate` 的局部focus只保留caller上下文中已有的layout、StableContext、nonnull、ID range与first-free事实；未改canonical contract或executable C。最终manifest `32f53a4a...7e4e`。
- r22 minimal affected-only review：reviewer `predicate_r21_review`，2026-10-08；实际新generated VC确认所有所需PreH出现，独立Qed `IdInsertObj`两条、rollback、registry focus/standalone共五条spatial obligations，并核查publish生命周期前提。R22-LOCAL-01..05全部关闭，结论`review-passed`。
- Predicate revision 是否仍有效：是；当前绑定 `predicate-r23-1845f34ef435`。r23 只把 ID-manager bucket 纯视图规范化为 addr/id，统一 carrier、实际 ownership、公开接口与 abstract effect 不变。
- r23 proof-discovered success closure：旧 success return VC 缺少构造
  `abs_semaphore_create` 成功步所必需的 fresh address、uint16 value range 与
  old/new world-wf，逻辑上不可由 r22 PreH 推出。r23 仅在 `_SemaphoreCreate`
  局部 cuts 中显式保留这些已有事实；freshness 由 registry body 与 zeroed block
  的分离 ownership 推出，value range 来自 typed `UShort` store，world-wf 来自
  已打开/重建的 OS invariant。public/canonical contracts、C executable、predicate
  r22 与 trusted symbols 均不变。独立 reviewer `spec_r23_review` 检查
  R23-01..07、九切片 GCC 与 formal-support compile/coqchk/trust，结论
  `review-passed`。
- r24 minimal follow-up：r23 的局部 typed-store range cut 被 QCP 拆成无条件
  `forall val : Z` goal；r24 删除该错误 cut，并在 `_SemaphoreCreate` canonical、
  KSemaphoreCreate caller-local 与 canonical 三处同步加入 `0 <= val <= 65535`。
  该条件精确等于当前 ABI 的 `uint16` 值域，不排除任何合法 C 调用。独立
  reviewer 检查 R24-01..05，结论 `review-passed`。
- r24 当时的结论：`review-passed`，随后因 `SPEC-IMPL-10` invalidated；其 ordinary-only
  critical scope 仍不变，不声称 nested overload 已验证。
- r23 predicate dependency review：独立 reviewer `predicate_id_view_review` 曾确认
  r24 可继续有效；该 predicate 结论仍有效，但不能覆盖后来发现的 size spec 缺口。
- r24 历史 reviewed revision：`spec-r24-4abdd1dcbfd1`（annotated manifest
  `4abdd1dcbfd1ec22ad68f77c764da7e6c1850643919acb613aeeb017760315d9`）。
- 用户批准：r20/r18 已明确批准；用户随后对 proof 中发现的设计问题授予完成回退、
  review 后无需再次等待的 standing approval。
- r25 proof-discovered spec rollback：无占位 auto-proof audit 暴露
  `SPEC-IMPL-10`。作者在三处同步 contract 中加入当前 32 位 ABI 的 Semaphore size
  fact，并仅为 wrapper standalone parsing 补齐权威 struct layout declaration；九文件
  C99/ILP32 syntax check 与独立 `_Static_assert` ABI probe 通过。candidate revision 为
  `spec-r25-4ac7a52f6b42`，literal manifest
  `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`，
  closure path-normalized manifest
  `d12c0e7f7ff0c8dbcfe254237a0c681295999035ddd9ed6fef0c543a6471a544`。
- r25 independent affected-only review：reviewer `spec_r25_review` 检查三处 size
  contract、canonical/caller-local alpha 等价、权威 struct layout、public Require
  最小性、success/failure/effect/ownership、九函数 closure、六个 trusted symbols、
  source/predicate manifests 与九文件 GCC；`SPEC-IMPL-10` 状态为
  `fixed-and-passed-in-r25`，无 open blocker。
- 当前结论：`review-passed`；reviewed revision `spec-r25-4ac7a52f6b42`，完整
  annotated manifest
  `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`；
  predicate `predicate-r23-1845f34ef435`，source `source-s2-2adc70fc1afc`，当前
  helper hash `2e984277...730b`。按用户 2026-10-09 standing approval 直接恢复
  implement，无需再次等待批准。
