当前结论：`verified`（相对于已批准的六个 trusted C symbols 和既有 QCP/Rocq 框架信任基础）。九函数的原 controller 终检、全部证明、源码/契约/信任扫描及完整递归 coqchk 均已通过，本次验证完成。范围为 STM32F103-nano / Cortex-M3、ILP32、小端、非 SMP，并严格限定入口 `scheduler_lock_nest < 65535`；更深调用明确不在结论内。

本次 source revision 为 `source-r2-0c50c37013e9`，47 项 source/config manifest 的 SHA-256 为 `0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651`。当前权威文件全部重新匹配。固定 ARM ABI 证据来自本 trial 最初成功的真实 ARM 编译；临时 ARM 编译器现已不存在，终检只重新运行了 native `gcc -m32` 的 C syntax/切片布局检查，不声称重新进行了 ARM 编译。Semaphore 大小32、value偏移12、pending偏移16、registry link偏移24；详情见 evidence/source-check-result.json、source-abi.c/.s 和 final-integrity/c-source/。

采用独立 review-passed 的 `predicate-nonzero-candidate-fe8c4261db5c`（manifest `fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3`）和 `spec-r6-ae22a04e2c95`（manifest `ae22a04e2c951be960fddd724fae8d23a5f2034b8f65765318472ff549c79e18`）。审阅分别见 [predicate review](2026-10-12-6-predicate-review.md) 和 [spec review](2026-10-16-1-spec-review.md)。用户第八节一次性授权及明确的 nesting/controller 授权适用于本次接受过程。

最终带 body 注解的 C 文件整体摘要为 `cd8761bda84bcf8d369226ff2fe4bbfaa0285f91a8ae8bd8968991ae9167cbc4`。它与审阅时整文件摘要不同，因为实现阶段加入/调整了 Assert、Given、Extern 和 module-load 等证明注解；九个函数的全部真实 API spec 与审阅候选及冻结基线逐项相等，全部可执行 tokens 在已记录归一后等于权威预处理结果。机械脚本输出中自动拼接的 `spec-r6-cd8761bda84b` 与 `awaiting-independent-spec-delta-review` 是脚本的通用字段，不代表接受了新语义 revision；本次仍绑定上述已审阅 spec-r6-ae22a04e2c95。

允许的 trusted C 边界仍恰好是六个 symbol，函数体没有冒充已验证：

| Symbol | 本次实际契约 |
|---|---|
| x_malloc | size=32、emp；失败返回0并保持emp，成功交出非零地址的完整32字节未初始化对象 ownership。 |
| memset | value=0、size=32，消费完整allocated ownership，返回dest并交出zeroed-private ownership。 |
| x_free | 消费完整、清零、未发布的私有对象，返回emp。 |
| DisableLocalInterrupt | 真实irq_enter边界：outside经Rely取得合法handler、inside token和当前OS invariant。 |
| EnableLocalInterrupt | 消费合法handler、Guarantee、inside token及after invariant，恢复outside。 |
| KPrintf | emp→emp，不拥有或改变模型中的OS资源。 |

经审阅的可执行归一包括：唯一done dispatch到_SemaphoreCreate、source-static到slice external、空debug宏和配置常量死分支删除、IRQ宏展开、真实四参数KPrintf声明、ILP32 x_size_t等价表示、IdInsertObj中赋值/条件拆句及static全局对象的slice external声明。另经 DCHG-20261016-01 独立审阅，将两次非VLA `sizeof(struct Semaphore)` 调用实参精确折叠为 `(x_size_t)32`；未改真实源码、算法、可达路径、返回值或副作用。所有实际代码路径及六trusted/九body闭包均由最终机械检查重新核对。

本次实际生成的证明计数如下。auto列表示生成器留下的占位义务数量；这些义务均转入manual证明，并非verified-auto证据。

| 函数 | 主VC | auto占位义务转manual | 原direct manual | 额外split Qed |
|---|---:|---:|---:|---:|
| CriticalAreaLock | 3 | 1 | 2 | 2 |
| CriticalAreaUnLock | 7 | 4 | 3 | 4 |
| DoubleLinkListInsertNodeAfter | 1 | 1 | 0 | 0 |
| AllocId | 43 | 31 | 12 | 15 |
| InitDoubleLinkList | 1 | 1 | 0 | 0 |
| InsertObj | 19 | 14 | 5 | 4 |
| IdInsertObj | 25 | 22 | 3 | 4 |
| _SemaphoreCreate | 43 | 35 | 8 | 13 |
| KSemaphoreCreate | 5 | 5 | 0 | 0 |
| 合计 | 147 | 114 | 33 | 42 |

147个主VC全部由manual中的Qed完成；42个split也全部Qed，没有unused Abort。最终共有189个VC及split证明，split不重复计为正式主VC。21个主VC使用aggressive模式，126个使用LLM模式。最终编译的auto模块没有任何占位义务或Admitted；原生成auto中的114个Admitted仍作为工具原始输出保留在canonical/归档证据中，但不进入最终实际编译的proof dependency closure。

用户提供的历史172/124 verified-auto/48 direct-manual仅为诊断基线，本次主VC少25，分类差为114对124、33对48。差异已定位到当前九函数实际生成的goal interfaces和上表，而非删除路径/VC：本次独立重建的predicate与断言切点决定生成义务粒度，当前生成器的auto占位项又被完整提升为manual worklist。与历史的proof route也不同，本次verified-auto计数为0、manual主证明为147。因用户禁止读取历史trial，无法声称逐一对应那25个旧义务的消失原因；未以匹配历史总数为目标调整任何VC。每个函数最终都重新symbolic并通过原controller的VC/statement/scope比较，保证当前所有正式义务没有被删、弱化或隐藏。

21个正式predicate/framework candidate文件的当前编译证据为 evidence/predicate-recheck.json；九个函数均完成原controller的dependency、parent goal-check、final-apply和final-check，且final-check记录全部绑定同一source/predicate/spec/_CoqProject摘要。最终核对和每函数计数见 evidence/final-integrity/closure-audit.json。完整proof closure由各自最后final-check的实际规范化源文件及对象文件组成，包含21个formal模块和36个VC-family模块，共57个本地模块；没有从raw auto archive选择编译对象。

完整递归coqchk状态：**passed，退出码0，机械耗时703.432秒**。命令见 evidence/final-integrity/coqchk-command.json；显式检查21个formal模块（包括SemaphoreInitialization）和9个goal-check，递归检查全部导入依赖，未使用 `-admit` 或 `-norec`。结果记录于 coqchk-result.json；stdout/stderr保存在同目录。内核摘要没有type-in-type、unsafe (co)fixpoint或假定positivity。

源码扫描和147个具体主证明的Print Assumptions均已通过。实际最终manual/auto中没有本实验新增的Axiom、Parameter、Admitted、admit、Abort或占位证明；生成goal里的147个Axiom只是VC_Correct的Module Type接口，由相应已编译goal-check实现。字节一致的官方NestedCriticalSTS仅有既有Module Type参数nc_sts，实际协议使用具体定义实例化。

完整依赖树并非无公理：实际假设共17个，清单和来源在 evidence/final-integrity/assumptions-result.json。除标准库外延性及QCP地址/sizeof接口外，明确依赖上游CNotation.v:360–370以Admitted提供的 `rvalue_expr_equiv_refl/sym/trans` 三条规则；它们是用户第十三节允许的既有框架信任基础，不是本实验新增、也不是generated-auto witness。`CrtosOSProtocol.Crtos_C_Rules.eval_addr/addr_of_arrow_field` 两个带trial模块前缀的名字，来自官方DerivedPredSig→CNotationSig接口展开，分别对应CNotation.v:524/553，并非新增用户公理。不能将本结论表述为完全消除了框架假设。

最终输入复核确认18对根共享源码/对象文件、286个外部框架source/object摘要以及30个上游controller文件保持原哈希。本地controller适配有用户明确授权，原action/claim/owner/accept/merge/final流程保留；source、formal或skill未因工具适配而替换语义。复现当前证据可运行 tools/final-integrity.py、tools/final-inputs-audit.py、tools/final-assumptions-audit.py；首项包含完整递归coqchk，可能耗时较长。

当前trial、实际load paths、规范化proof closure及manifest均不含历史trial输入；隔离证据见 evidence/session-constraints.json、final-integrity/frozen-inputs-audit.json 和 coqchk-command.json。初始一次根目录rg文件枚举没有显式排除旧trial，未返回旧trial文件；另一次git status仅显示旧目录名。这两次过程偏差如实保留，不声称全过程零枚举偏差。没有读取、导入、复制或依赖旧trial文件内容。

相关设计决定为 [入口域](design-changes/2026-10-12-1-nesting-domain.md)、[字节序/工具链](design-changes/2026-10-12-2-byte-order.md)、[完整对象地址有效性](design-changes/2026-10-12-3-object-address-validity.md)、[固定sizeof归一](design-changes/2026-10-16-1-sizeof-normalization.md)。均已获明确授权或经语义保持独立审阅后按第八节接受；现有九函数结果已全部在最终修订下重验。没有与当前已批准域冲突的未解决源码错误或未批准设计变更。nest=65535的计数回绕仍在明确排除范围，未修改真实C，也未证明板级可达性排除该状态。

编辑器和交互工具另有环境限制：当前VsRocq/Rocq MCP后端为OCaml4.14.1，不能读取本次4.14.2对象；CLI/controller使用兼容pv-bench-8.20.1。2026-10-16 live MCP诊断见 evidence/rocq-mcp-live-probe-20261016.json。所有机器证明结论来自已记录的兼容工具真实退出结果，不声称IDE/MCP兼容问题已修复。
