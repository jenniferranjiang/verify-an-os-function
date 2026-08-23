# 完成证明与验证指南

本指南只服务 `implement`：对已在项目正式 Rocq/annotated C 源码中写出并批准的 formal spec、
predicate definition 和 lemma statement，
调用 QCP-MCP 与 Rocq-MCP 完成 symbolic execution、VC proof、具体内存变化和抽象语义闭环。它不重新
决定 API 行为、predicate 参数、lemma statement 或 ownership 边界。

## 1. 进入条件

进入实现前确认：

- 权威源码/config、目标模块与依赖、critical/IRQ/atomicity 和可信边界仍与设计时一致；predicate review-passed revision 和 spec review-passed revision 已分别记录，并由用户明确批准这两份 revision；
- 交接信息给出正式 file/symbol，不以 Markdown 代码块作为 statement/spec 来源；
- 源码 revision、非 SMP 配置、目标客户端和允许修改文件仍一致；
- 直接调用依赖图已经固定；
- 每个待验证函数已有批准 spec；spec 与 proof 状态分开记录，不能把 `spec-approved/proof-pending` 当作
  已验证依赖；
- 没有未解决且会改变 state、ownership、函数 spec、trust 或 scope 的 `[OPEN]`。

Predicate/ownership 变化按 predicate review 条件处理；API 行为、Require/Ensure、路径或 effect 变化按 spec review 条件处理。只有相关结论受影响时才使 review 失效；proof-local lemma、strategy 或 tactic 调整不重新走设计审阅。

## 2. 自底向上完成 proof

不要预先给函数分层。直接建立 direct-callee graph，按拓扑顺序从没有未证明依赖的 leaf 向 wrapper 推进。

```text
approved predicates/structural lemmas
  -> 当前缺失的最底层 helper specs/proofs
  -> 它们的 callers
  -> 目标函数
```

常见情况下会从通用内存操作逐步回到对象/容器、模块操作和最外层 API，但不存在的中间层直接跳过，
也不创建仅为满足顺序的 wrapper。Init 也按自己的 direct callees 自底向上证明，再建立初始 invariant。

按确定后的调用图从 leaf 到 wrapper。直接证明正式 lemma-interface `.v` 中已批准的 `..._statement`，
将 `Lemma ... : ..._statement. Proof ... Qed.` 写入项目约定的共享 proof `.v`；不要从 Markdown 重新抄写
statement，不要复制到 client-private proof，也不要更改 statement 迁就 tactic。Helper 尚无已批准接口时，不给 wrapper
虚构整体函数 spec。

对每个函数执行“已批准 spec -> QCP/Rocq proof -> proved”状态转换。Caller 可以在 spec 设计阶段引用
callee spec，但 caller 的最终 proof 只能使用已经完成 implementation proof 的 direct-callee spec；任一
传递 callee 仍为 `proof-pending` 时，最终目标不能报告为验证完成。

## 3. 调用 QCP-MCP 完成 symbolic execution

QCP-MCP 只负责 annotated C、symbolic execution 和 VC 定位/导出；manual Rocq VC 交给 Rocq-MCP。

对每个目标 annotated C 文件执行：

```text
qcp.load_target_file(absolute_file)
qcp.symbolic(last_line)
失败时：qcp.check(line) / qcp.step(steps)
需要 manual VC 时：qcp.proof(function_name, witness_type, number)
结束时：qcp.close()
```

保存具体文件、检查行、function/witness 标识和结果。不得把一次 `check` 或局部 `step` 当成整文件 symbolic
通过；成功标准是目标 symbolic execution 到达文件末尾且无 error，或所有导出的 manual VC 均完成证明。

## 4. 调用 Rocq-MCP 完成 lemma 与 VC proof

优先使用 Rocq-MCP，而不是手写未经检查的 proof：

```text
rocq_toc / rocq_query：理解已有定义、lemma 和 notation
rocq_compile：先编译完整候选文件并获得结构化错误
rocq_step / rocq_step_multi / rocq_auto_solve：交互完成 proof
rocq_compile：再次检查完整最终文件
rocq_verify：核对原 statement、proof 和 assumptions
```

`rocq_verify` 适用于可独立提供 original statement/problem 的目标；工程内组合文件若无法直接使用，至少运行
`rocq_compile`，并用 `Print Assumptions` 或项目等价检查记录可信依赖。不得把 `proof_finished` 前的中间 tactic
状态当成完成。

## 5. Annotated C 与宏

在隔离 annotated C 中，优先把复杂函数式宏改写成带 spec 的 helper；把控制流宏正规化为等价显式
控制流，例如 `First/Next` 加 loop。记录正规化，不擅自修改生产源码。

检查目标配置下宏的真实行为。若某 null-check 宏在当前配置为空，不得给 helper 虚构“正常返回即
non-null”的源码事实；应由 caller 前置条件提供，或记录明确 verification-unit assumption。

开始 proof 前搜索所有 `Definition`、`Extern Coq` 和 C annotation，确保同一 helper 只有一个接口。

## 6. 具体内存闭环

```text
entry invariant
  -> target focus/split
  -> ownership for every load/store
  -> load old values / store new values
  -> link/object/container transfer
  -> local update
  -> preserve memory outside the write footprint
  -> abstract-state local update/refold
  -> required exit invariant
```

常见失败和首要检查：

| 现象 | 优先检查 |
|---|---|
| memory-read 前置缺失 | owner 表、target focus 和 footprint |
| link 无法关联外围 C 对象 | logical/container/link identity |
| separating conjunction 重复 cell | spine/payload 或 missing fragment 重叠 |
| 空表分支失败 | `NULL` 与 sentinel 自环 |
| 删除后无法重建 | segment/focus/frame lemma |
| 更新后无法 fold | predicate 过度整体化或缺 replace |

## 7. Refinement 闭环

```text
public abstract command
  -> module transformer
  -> object/container effects
  -> concrete C updates
  -> result and new abstract state
```

确认合法前态存在允许结果；每条可达 C return 匹配成功/失败语义；失败分支保持规定状态；插入方向和
重复策略与 C 一致；未修改模块通过局部更新/frame 保持；新 validity 成立；返回码、buffer 和
抽象结果对应；必要时证明 termination。

如果具体内存证明通过但该链不成立，只能声称局部内存/shape 证明，不能声称完整功能验证。

## 8. 可信性和工具检查

新 proof 使用 `Qed`。不得引入未经批准的 `Admitted`、新 `Axiom`、作为 proof gap 的未解释
`Parameter`、更弱的对外函数 spec 或绕过已批准 spec 的重复接口。

按项目运行并保存证据，最后统一写入 [final-integrity-template.md](../assets/final-integrity-template.md)：

1. Rocq-MCP compile/verify：语法、类型、递归定义、shared lemma 和 assumptions；
2. predicate unfold/fold、focus、update、refold；
3. QCP-MCP symbolic execution 与 manual VC 导出；
4. Rocq-MCP 完成导出的 VC proof；
5. `goal_check` 或等价功能义务；
6. `Admitted|Axiom|Parameter` 扫描；
7. `*_pre/*_post`、`Extern Coq` 和 helper declaration 重复接口扫描。

报告命令、通过项、失败项，以及未运行检查和原因。

## 9. 诊断顺序和完成条件

失败时按最早可能错误层诊断：

```text
C source/address facts
-> abstract behavior and layer
-> representation/ownership
-> interface lemmas
-> precondition/postcondition encoding
-> proof tactics
```

不要先堆 tactic，也不要通过弱化 abstract operation 迁就 predicate。

`implement` 完成必须说明：本次验证上下文、slice/spec 正式 file/symbol 与 diff 版本、QCP-MCP 会话和
symbolic/VC 结果、Rocq-MCP compile/proof/verify 结果、完成的
lemma 与 C proof、具体内存闭环、抽象语义闭环、trust 检查、实现与批准 statement 的对应、已批准变更和明确延期工作。
