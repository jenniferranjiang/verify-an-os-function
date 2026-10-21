# KSemaphoreCreate 本轮 predicate 设计

当前 revision `P-261019-2-r2` 已由独立 reviewer 判为 review-passed；结论及范围见 [predicate-review.md](predicate-review.md)。正式文件已冻结，设计审阅通过不表示 C 实现证明完成。本轮只读取权威 C、本 trial、根共享 lib/annotated_C 与当前 QCP Rocq 源码，未读取任何其他 trial，也未恢复被删除的 SemaphoreInv.v。源码、配置及 ABI 依据见 [source-analysis.md](source-analysis.md)。

`semaphore.v` 是从本轮 C 证据新写的模块表示。`KSemaphoreCreate.v` 定义锁内创建、IRQ 开启创建和 IRQ 已关闭创建三个 program。公共依赖来自根共享库，本 trial 保留实际传递依赖；未用的 Task 内存模块没有纳入候选。

## 唯一模块状态与内存分工

候选 CrtosGlobState 的 `sem_objects` 按真实管理链顺序保存对象的地址、ID、value 和等待节点。ID manager 的 ID 列表与各哈希桶从这一个列表派生，没有保存第二份 VarIdmanager；等待节点复用共享 DL_Node，DLL spine 复用 DLL.store_dll。静态 done 唯一解析为普通直接调用，没有再建函数表内存权限。

| 阶段 | ID 与 ID link | value / padding | pend_list | Semaphore.link |
|---|---|---|---|---|
| malloc 成功 | 整个 `CharArray.undef_full p 32` 唯一拥有，允许未初始化 | 同一完整块 | 同一完整块 | 同一完整块 |
| memset 成功 | `store_private_idnode ... 0 0 0` | value=0；四个 padding 字节=0 | 两个零指针，尚未自环 | 两个零指针 |
| ID 成功，尚未发布 | `semaphore_registered` 的 ID manager | `semaphore_after_id` | `semaphore_after_id` 的两个零指针 | `semaphore_after_id` 的两个零指针 |
| value/pend 初始化后 | ID manager | `semaphore_ready` 的对象主体 | 同一主体内的空 DLL 自环 | ready 的两个零指针 |
| 已发布 | ID manager | 管理 DLL 的 payload | payload 拥有链头及真实等待任务 sched_link | 管理 DLL spine |

所有阶段的 32 字节均恰有一个 owner。QCP 当前 `CommonAssertion.struct_padding` 的实际定义为 emp；它并不生成本例四个实际 padding 字节，所以 whole-object memset/free 所需 padding 必须显式拥有。这与“工具已经拥有 padding 时不要再重复”的规则一致。

`IdInsertObj` 的失败接口必须精确保留输入 ID 与两个指针值；只返还可写但未知的节点无法重新得到全零对象。ID 失败后 `x_free` 消费完整 `semaphore_zero`，共享 manager 不变，之后仍执行 unlock。成功路径由 ID 容器先取走 ID 字段与嵌入 link，再由全局 DLL 取走管理 link 和对象主体。未访问的既有对象、等待任务及其他模块内存都在 heap frame 中原样保留。

## 同一个全局 IRQ 协议

根 CrtosRules 原有两个接口问题在本 trial 候选中修正：采用当前 Cortex-M3 的 LittleEndian；并修正 QCP `at_states ** has_tokens` 会把状态集合交成空集的问题。当前 QCP `has_tokens` 的集合确为 empty，而普通 heap atom 的集合为 full。只改写单个 predicate 还不足以排除恶意 empty frame，故新增通用 `NonemptyCSL` adapter：模型是具有非空状态观察的原 QCP Lstate 子类型，heap、token 和 join 仍复用原定义。单位、交换、结合及三个基础存储引理均有完整证明；不存在新 Axiom、Parameter 或 Admitted。

共享 CrtosRules 唯一实例化这个 carrier；DLL、ID 和 semaphore 全部使用同一个 carrier。没有 semaphore 私有 STS、token 或 Inside/Outside 别名。唯一 global STS 同时保存 OS 纯状态和真实 PRIMASK。显式 IRQEnter/IRQLeave 同时改变 mask 和资源阶段，避免直接套用保持底层 state 不变的默认 CT_enter。

unit token 表示 CPU 排他权限。OutsideCriticalIRQ 0 没有 token，允许环境推进；OutsideCriticalIRQ 1 持有 token，观察是精确状态。InsideCritical 持同一个 token、mask 必须为 1，并记录最初取得投影的 anchor。IRQ 已关闭但尚未取得投影的 outside 状态与真正 nested inside 状态不同。真正 nested 调用保持原 anchor、复用已持投影，不重复取得 owner；退出仍为 inside。outer(saved=1) 则在 outside/inside 间转交投影但保留 token；outer(saved=0) 同时转交 token。

跨 IRQ 操作只适用于稳定 frame。本闭包保留的其他资源是普通 heap assertion（状态集合 full、token empty）；`HeapFrame` 明确描述这个范围。不承诺任意未稳定 ghost observation 也可跨 IRQ 转换。IRQ primitive 的资源转移采用用户批准的 trusted 约定；本轮并未证明汇编实现。

`critical_projection` 只拥有本闭包访问的 semaphore 模块，并通过同一个 task map 给等待节点提供纯对应；`critical_nest` 拥有真实 `KTaskOsAssignLockNest` 的 UShort 槽。它们是全局协议的具体内存投影，不声称已得到整个 Cortex-M3 OS 不变量。未访问的 Task 栈表示含根库的 RISC-V 历史布局，因此本轮不直接采用根 CrtosInv 的全部空间定义，也不重做 Task 栈证明；未访问模块的纯状态由 `semaphore_publish` 逐项原样复制，物理资源由 frame 保留。

## 返回路径和 program

- malloc=NULL：返回 -5，没有 critical 操作，状态及 nested 计数原样保留。
- malloc 成功且 ID 满：全零对象释放，manager 不变，仍进行 lock/unlock，返回 -5。
- ID 未满：返回最小空闲 ID，新对象 value 等于 uint16 参数，pend_list 为空；对象加入管理链和对应哈希桶表头。

`abs_semaphore_create_locked` 是准确的锁内关系；`abs_semaphore_create` 通过共享原子提升选择加锁时观察，malloc 失败分支不凭空执行一次原子操作；`abs_semaphore_create_masked` 使用精确状态、没有环境推进。外层地址通过存在量词隐藏，fresh 来自 malloc 与既有 owner 分离而非用户输入假设。

计数不是逻辑嵌套深度，不要求初值为零。uint16 的 ++ 可使 65535 回绕到 0，随后条件 -- 不执行，最终仍为 0。`semaphore_create_nest_result` 将这个变化与具体 malloc/锁内路径关联，不能任意混合分支。

## 编译和 revision

只使用本 trial `_CoqProject` 的显式 loadpath；不得映射其他 trial。根库只作只读来源，候选未晋升。编译命令、日志和选用依赖由 checks 保存；固定 revision 时另生成 SHA-256 清单。设计编译与类型检查不是 C 实现证明；本轮没有启动 parser、symbolic、VC 或 verification-orchestrator。

根 `.vscode/settings.json` 中历史trial的loadpath已由main替换为本trial `_CoqProject` 的完全一致映射（只读写根配置，没有访问历史trial）。编辑器配置preimage保存在 checks/editor-settings-before.json。QCP Monad/FP 当前源目录缺可用 `.vo`，另一白名单已编译库的 OCaml 版本不匹配，故只把八个必要源文件原样复制 vendor 并在当前工具链重编；来源hash与编译记录见 checks/vendor-source-hashes.json、vendor-compile.log。

协议反例回归见 checks/ProtocolSanityCheck.v：已证明 outside0 与 outside1 不能分离合取、inside 与 outside 不能分离合取、outside1持排他token且观察精确，以及四种 IRQEnter/IRQLeave 构造确实存在。该检查不是 C 实现证明。

## 静态初始化与首次接管（r2补齐）

独立审阅 r1 指出：虽然创建对象的 malloc/zero 生命周期完整，模块自己的静态初始化入口尚未形式化。r2 在 `semaphore.v` 新增 `semaphore_initial_state` 和 `semaphore_static_resources`。后者准确拥有 manager 的 128/16 配置及两个数组地址、16字节全零 bitmap、16个各含两个零指针的BSS bucket，以及 `k_sem_list` 的自环头。数组使用 QCP `store_array`，没有把初始 bucket 误写成自环。

`semaphore_static_initialization_obligation` 是具体静态资源折成空模块 invariant 的**待证命题陈述**；`critical_projection_initialization_obligation` 是同一折叠到本闭包投影并保留 `critical_nest 0` 的待证陈述。两者不是 Axiom/Parameter、不是已证 lemma，也未被任何目标契约作为成立的假设使用。按设计阶段范围，它们为后续初始化证明保留明确接口；本轮不声称验证启动代码。

`critical_bootstrap_package initial_mask sg st` 将真实启动IRQ上下文与静态heap owner一起交给初始化者。系统级逻辑安装动作随后把模块和计数槽登记到**同一个全局协议 invariant**中，运行时的 Disable/Enable 才按约定取出/归还它们。这个逻辑安装不同于普通heap entailment：静态零字节不能凭空创造PRIMASK观察或CPU token，初始mask由实际启动上下文给出，可以为0或1。`KTaskOsAssignLockNest` 的BSS初值0也已显式拥有。


r2另按main的实际依赖检查移除了候选 `StructFieldOffsetAxiom.v` 的27个未使用ABI Axiom。根文件中的Task/RISC-V布局不适用于当前板；即使未被本次证明调用，也不应作为假设带入逻辑环境。保留下来的常量和布局Prop只是未断言的纯定义，供既有纯类型引用，不声明布局成立。本轮相关布局以真实headers的编译断言为证据；未用假设删除后重新编译全部传递依赖，并重跑header/协议类型检查。根共享文件不变。
