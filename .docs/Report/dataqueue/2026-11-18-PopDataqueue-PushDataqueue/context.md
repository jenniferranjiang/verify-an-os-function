> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

# PopDataqueue / PushDataqueue 新实验上下文

后续授权更新：用户已在持续实现验证窗口明确要求完成Semaphore后继续DataqueuePeak、PopDataqueue、PushDataqueue及必要调用闭包，不设VC累计证明时限，并预先批准有依据的修改。以下“仅设计”描述保留为本实验最初阶段的历史范围；后续实现仍须核对设计输入、通过实际检查并执行QCP workflow和final-check，不能将本页的设计检查当作实现完成。

接续输入核对：72份全局lib联合摘要仍为`56e798260047a115b5f6ea27db83b8d0c486a32d0f2bc88173b82bc8a7061182`；本实验九份canonical及dataqueue/runtime header逐项匹配review.md末尾更新后的哈希。七份原源码（data_queue、semaphore、linklist、tick、delay、ktask、xs_dataqueue）也逐项匹配。此为版本核对，不是新增实现证明。

本轮仅设计和审阅，终点为 predicate 与完整调用闭包 spec 分别 review-passed。禁止启动 verification-orchestrator、运行 QCP parser/symbolic/closure script、生成 VC 或证明 C 实现；Rocq 编译和类型检查照常进行。旧实验的实现授权不用于本轮。

开始时全局工作树已有大量未提交改动（含 Dataqueue、Semaphore、构建、技能和旧实验报告）；本轮以实际工作树为基线，不以 HEAD 覆盖。开始前保存全部 lib `.v`、annotated C `.c/.h` 和根构建输入快照；基线清单 SHA-256：`bd158c231e839d772781533e8319e9833efc2cb9b256cd602384e7f759776a91`。快照仅供本轮比较，阶段结束后删除。

配置使用 `/home/xinra/crtoslatest`（只读），commit `a07641a0b58469ae3ea19317cce2cf48974989bb`；QCP 库 `/home/xinra/qcp-binary-democases`；Rocq 8.20.1 路径 `/home/xinra/.opam/pv-bench-8.20.1/bin`，与 tools/rocq/toolchain.json 一致。沿用 CRTOS_Verify 逻辑前缀、全局 lib/annotated_C 布局、当前生成式 Makefile 和 _CoqProject 输入配置。

已批准 DQ-02/03 副本修复及共享 ID 读取适配的授权依据见[既有源码错误记录](../2026-11-16-InitDataqueue-DataqueuePeak/source-errors.md)及[修改对照](../2026-11-16-InitDataqueue-DataqueuePeak/source-changes.md)。该记录明确修复授权继续有效且删除分析副本不撤销修复方案；本轮重新核对适用源码并落入 canonical 输入。旧实验的 review-passed/done 不充当本轮结论。

默认白名单001按适用条件处理 assertS 对临界区候选观察的检查，不扩展信任，也不把非真空性写成已证明结论。未配置用户补充白名单或源码处理文件。

| 输入 | SHA-256 |
|---|---|
| `.agents/verify-os.config.json` | `d27d3052c055040f1b88b5f6341a8b65aa66577b814295835a741a85c20fd027` |
| `.agents/skills/verify-an-os-function/references/TrustBase.md` | `a2201e7277938c1c45f3570c4224fa26724bc7d4f27027077f00d6d384ad35f7` |
| `.agents/skills/verify-an-os-function/references/ReviewWhitelist.md` | `936815c7f167b58e50dc3e4332133bea94146b91cc75b47781100743487313b4` |

源码内容版本（本轮读取，原仓库不修改）：

- `thread/data_queue.c`：`a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`
- `thread/semaphore.c`：`dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8`
- `thread/linklist.c`：`53eed893164c56e2eee7c4772eacba3d07cd4f31c71c388e326ed57a30103461`
- `thread/tick.c`：`ddf26d9067e046fc206ea3f15ad117fc23c9bfb0933ada2902a8ada18591771c`
- `include/xs_dataqueue.h`：`fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8`

本轮与实际基线的核对：已有 lib `.v` 均保持原内容；新增8个库文件。既有正式C体未改，只有 dataqueue.h 增加本轮词汇/import，另新增9个canonical与semaphore_runtime_logic.h。_CoqProject及生成配置登记新输入，lib/index.md更新导航。没有改旧 VC、controller reports或verification_runs；已有审阅/证明未因共享定义语义变化失效，也未被本轮冒称为新证明。

构建检查：根 `make lib/dataqueue/KPopDataqueue.vo lib/dataqueue/KPushDataqueue.vo -j2` 成功，覆盖8新库与所需依赖；9新C使用 `gcc -m32 -std=c11 -fsyntax-only -Wall -Wextra -Iannotated_C/src/headers` 通过。新增17个term词汇（dataqueue.h 5个、runtime header 12个）以 `Check (symbol : signature)` 在相同工程映射下独立coqc通过。未运行QCP解析或symbolic。

阶段收尾：独立审阅两项均通过，版本与冻结哈希见[review.md](review.md)。已复核哈希和本轮报告链接，删除本轮临时基线及新库无需继续使用的辅助编译文件，保留全部8份新 `.vo`；未触碰既有缓存、旧证明或控制器恢复状态。本轮至设计审阅结束，不请求或启动实现阶段。

## 共享header按需启用（第一阶段窗口兼容修复）

第一阶段恢复时将dataqueue.h新增Pop/Push词汇块置于CRTOS_DATAQUEUE_WITH_OPERATIONS条件下，并在PopDataqueue.c/PushDataqueue.c include前定义该宏。两份C经同参数GCC预处理，忽略空白和新增guard结束注释后，包含formal注解的全部预处理文本与修改前完全相同；规格、body及import不变。Init/DeInit/Peak不再引入无关Pop/Push语义模块，保持已有生成前导。此为非语义include适配，不启动第二阶段workflow，也不把设计审阅改称实现证明。更新文件哈希如下（替代上方同文件旧值）：
- `annotated_C/src/headers/dataqueue.h`：`95fc4e87bb93606957b80da5e6796dee98229b51ff26f68ec5271b0cc5934c79`
- `annotated_C/src/kernel/dataqueue/PopDataqueue.c`：`0466f1d8340af4bb0535f65ac6eca45b5f7ab66f30a29b35ffdcf4c23eb9e569`
- `annotated_C/src/kernel/dataqueue/PushDataqueue.c`：`767436057dcae1d30a979210db1c9e2a76d5f0132f1e2695de8f8252a0fc073e`

## 实现阶段已启动

第一阶段七个函数（Init、DeInit、Peak及四Semaphore IC）均已done/final-check。当前[PopDataqueue-20261119021132](../../../../reports/PopDataqueue-20261119021132/controller_state.json)已进入annotation，使用本页记录的r1设计及已批准DQ-02/03修复canonical。Pop本体之后串行验证新增Obtain/Abandon等调用闭包，再Push；本体done不代替callee实现，既有reused-spec边界不扩展。当前尚无Pop实现完成结论。

continuation提取后的72份lib联合摘要：`454bc6b0348bed5356afa3bd20d8c72084fb12be5341499b68b4c64c603e5958`。唯一库变化KPop，review.md记录定义等价及独立审阅；旧摘要保留作为修改前版本。

Pop本体已done/final-check passed；四VC登记根构建并恢复.vo。当前[CalculateTickFromTimeMs-20261119024015](../../../../reports/CalculateTickFromTimeMs-20261119024015/controller_state.json)进入annotation，先完成Pop新增调用闭包再Push。

Tick转换workflow已done/final-check，6manual顶层/6split Qed，15auto，四.vo根构建恢复完成。下一目标LinklistSuspend，先处理已知runtime header formal ALIGN_SIZE与C宏同名的解析冲突，行为/spec不变并独立复核。

当前[LinklistSuspendSemaphore-20261119031206](../../../../reports/LinklistSuspendSemaphore-20261119031206/controller_state.json)进入annotation。共享header修复审阅见dq-runtime-align-decl-20261119-r1；不增加等待链排序前提，保留非法flag/FIFO/priority路径。

LinklistSuspend当前6组中4组accepted：spec_and_results(5)、suspend_identity(5)、fifo_enqueue(2)、loop_progress(4)，共16/26手工顶层。priority_enqueue与loop_borrows仍在证明，无函数final-check；局部引理编译越过不计整函数完成。

LinklistSuspend已done/final-check，6组26manual顶层/9split全部完成，46auto。当前[SemaphoreObtainRuntime-20261119060206](../../../../reports/SemaphoreObtainRuntime-20261119060206/controller_state.json)进入annotation；使用刚完成的Tick和LinklistSuspend合同，其他已导入任务/ID helper保持原边界。

Obtain具名后续步骤提取后的72库联合摘要`6e14eb3c860716a85bd63a77349d23a8dc6dbbea712ef2df007663404a86f35b`；唯一新增源码差异为KObtain定义等价提取，review见dq-obtain-continuations-20261119-r1，受影响Pop/Suspend当前重编译中。

Obtain continuation提取影响的一致性检查已完成：root make同时重编译Pop/Suspend两套goal、auto、manual、goal_check并exit0，全部.vo保留；三库也已通过。定义等价审阅+当前依赖实际重编译支持原语义结论继续适用，没有修改既有证明或重跑无关workflow。

Obtain当前annotation r3/checking r4已接纳，proving r2十组中九组已接纳，仅immediate_results仍在证明；尚无函数final-check。移除两处过早内部非零Assert后，task_prepare实际证明通过；未修改入口或全局不变量。用户再次确认继续完成Peak/Pop/Push及必要调用闭包，无累计证明时限、合理修复默认授权，实际审阅与证明不得跳过。

Obtain现已done/final-check，36manual顶层+37所需split Qed，107auto，10whole未用split保持Abort；四VC根make至goal_check退出0且.vo保留。当前串行进入KSemaphoreObtainRuntime-20261119084641。下游canonical（wrapper、Resume、Abandon、Push）的SHA仍分别与初始review记录完全一致。

KSemaphoreObtainRuntime-20261119084641已done/final-check，3auto，无manual义务，源码未变，根make及.vo保留完成。当前串行LinklistResumeSemaphore-20261119085215，annotation阶段。

LinklistResumeSemaphore-20261119085215已done/final-check，5顶层+3split Qed，12auto，根make至goal_check及.vo恢复完成。当前串行SemaphoreAbandonRuntime-20261119094155，使用已经完成的semaphore_head_ic callee，保留所有计数/唤醒/锁外调度路径。

## 用户暂停（2026-11-19 09:48:44 北京时间）

用户明确要求暂停验证并暂停计时。controller已将SemaphoreAbandonRuntime-20261119094155置paused，UTC 2026-11-19T01:48:44.065998Z；有效workflow累计00:06:49，后续暂停时段不累计。当前annotation r1已接纳（16manual顶层/19split/68auto），依赖准备通过；vc-checking r1已claim，但尚未spawn agent，无运行中的owner或工具。恢复须用户明确指令，再resume-run/step；该已claim的checker交接见rounds/SemaphoreAbandonRuntime-vc-checking-r1/agent_input.md，需首次派发独立checker，勿重复claim导致误换owner。此前已done共13函数，.vo全部保留。

计时记录见第一阶段proof-timing.md，内含精确暂停区间。供本任务后续更新的临时生成脚本仍保留于/tmp/crtos-verify-dataqueue-timing-RY9uml/update.py；恢复时先在PAUSES补UTC恢复时间，再更新表，不把暂停间隔算入workflow。该脚本仅生成人工可读计时表，不改QCP日志/适配层，任务完成后可清理。
