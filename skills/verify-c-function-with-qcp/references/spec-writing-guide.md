# Spec 编写指南

本指南服务 write-spec。进入前，主 skill 已固定权威源码/config、目标模块、适用的 project knowledge 和用户批准的 trusted symbols，并已有可编译的 predicate 草案。Spec 是待证明的正式目标，不是验证结果；写完或批准 spec 都不能称为函数已验证。

Canonical contract 写在函数自己的 annotated C active definition 上。Caller 可以在当前函数定义前复制 direct-callee contract 作为 declaration-only API，但它必须与 callee canonical spec 一致。Markdown 和手写 Rocq 文件不复制整份函数 contract；它们只记录路径、symbol、证据、revision 和审阅状态。

Predicate 和 spec 分开 review。Spec review 只使用同一份 review-passed predicate revision；此阶段不运行 QCP parser/symbolic、closure script，不生成 VC，也不开始 proof。

## 1. 固定验证闭包

从 target 出发，在当前配置下递归跟随：

- 所有直接 C calls；
- 可由 table initializer、赋值点和配置唯一解析的 function-pointer/table dispatch；
- function-like 宏展开后产生的真实调用。

空宏、常量、sizeof 和纯类型/布局宏不产生函数。宏展开产生的可执行语句可在 caller 切片中作有证据的等价归一，但不为源码中不存在的宏虚构 canonical 函数。

除用户逐名批准的 trusted symbols 外，所有可达函数继续递归。Main agent 可以建议 trusted 边界，不能代替用户决定。无法唯一解析的 dispatch/call 保持 [OPEN] 并阻塞 review。

闭包中每个非 trusted 函数 f 必须满足：

1. 恰好一个 canonical annotated C 文件；
2. 文件中恰好一个真实 active definition 和完整 body；
3. active definition 上有完整 With/Require/Ensure；
4. 每个 direct callee 在定义前有完整 declaration-only API；
5. caller-local callee contract 与 canonical spec alpha/typedef 等价；
6. 切片 body、路径、返回值、副作用和所访问 ABI layout 与权威 C/config 等价。

不集中建立模块级 specs header，不复制整套依赖源码树 或无关 headers。若 body 按字段访问 struct，切片声明必须保持被访问字段的真实 ABI offset；否则把整个字段操作抽成真实具名 API，不得发明错误精简布局。

修改 callee canonical spec 后，所有 caller-local 副本和 transitive callers 都进入 affected closure。

## 2. 先固定模型和函数层次

读取闭包中每个函数的 direct callees、所有 return/blocking path、现有 module/function libraries、annotated C imports 和 Extern Coq。先确定项目实际使用的 Rocq definitions 和 annotation 位置，不因当前工作流阶段另建一套重复接口。

项目常见依赖形状是：

~~~text
memory/container primitives
  -> object/container operations
  -> module consistency operations
  -> public API with arguments, return codes and protocol resources
~~~

这不是必须补齐的分类。源码没有某层就跳过，不为形成层级虚构 wrapper。

Canonical spec 必须处于函数真实抽象层次。底层原语可以暴露必要的最小 concrete shape；对象、容器和模块函数应使用 reviewed object/module predicate、abstract state 和按动作命名的 transition，不把 manager fields、bitmap bytes、array elements 和 list pointers 逐层传给 callers。

## 3. 参数、资源与 effect

对每个函数逐项确定：

- C arguments、handles、buffers、return/error code 与逻辑值的对应；
- caller-owned input/output resources；
- module/global state 的入口和出口；
- project-specific protocol resources（若适用）；
- 每条 path 的 concrete old/new 和 abstract effect；
- ownership transfer；
- write footprint 之外的 frame；
- 是否存在 blocking/non-returning 行为。

逻辑 state 本身不提供内存权限。每个 C load/store 必须由 reviewed data_at、object/module predicate、container view 或 global invariant 支持。Spec 还必须给出 load 所需前态、store 后的新值/结构和未修改资源的保持。

Spec 沿用 reviewed predicate revision 已有的逻辑参数和 update 接口，不另建一套状态组织。

读取型 API 仍需要 ownership，但 abstract state 可以不变。Initialization 从原始 initialization ownership 建立 initial invariant，不能假装入口已有 runtime invariant。

## 4. With/Require/Ensure 的直接可审阅性

Require 写调用前必须持有的具体资源和事实；Ensure 按真实成功、失败、阻塞和 early-return path 写明返回值、状态变化、资源转移与 frame。

Contract 必须让 reviewer 在当前函数注解中直接看见关键义务：

- 直接组合关键 object/module/protocol predicates；
- 显式区分各返回路径及其 result；
- 写出 old/new 或具名 transition；
- 写出转交、消费和返还的 ownership；
- 保留未修改 caller resources 和模块 frame。

不得把整个入口资源或全部出口效果包装进只名为 pre、post、spec 的不透明 helper。共享 helper 必须按对象、动作或可复用语义边界命名，并有真实复用者。Helper 不得抹平成功/失败路径或迫使 reviewer 连续展开多层才能看出函数改变了什么。

不得通过无依据加强 Require、弱化 Ensure、遗漏失败路径或标记 deferred 来取得 review-passed。合法前态必须至少存在一个允许结果，避免 partial-correctness 真空成立。

## 5. Predicate 接口不足

展开闭包时若发现 predicate 层缺少对象 representation、局部 ownership view、生命周期中间态或必要 split/merge：

1. 暂停当前 spec；
2. 返回 slice-design；
3. 增加按对象或动作命名的最小 predicate/lemma interface；
4. 编译/typecheck；
5. predicate 仍为 draft 时继续共同迭代；
6. predicate 已 review-passed 时标记 affected revision invalidated，固定新 revision 并重新 review。

不得用一串 field-level store 代替缺失抽象。

## 6. 覆盖所有路径

对每条成功、失败、阻塞和 early-return path 检查：

- path condition 与 C branch 一致；
- C return/buffer 与 abstract result 对应；
- target module 的 new state/effect 完整；
- 未修改 modules 和 write footprint 外资源保持；
- caller resources 与 protocol resources 正确返还；
- allocation/free/container membership 的 ownership 转移闭合；
- direct callee contract 足以支持路径，且 callee 仍只是 spec-approved 或已 proved 的状态被准确记录。

Spec 设计可以使用尚待证明但已审阅的 callee contract；最终 caller proof 只能依赖已完成 proof 的 direct callee。

## 7. Review-ready 检查

进入 spec review 前完成：

1. 从 target 重扫当前配置的完整 calls/dispatch/macros closure。
2. 核对每个 symbol 恰好是用户批准 trusted，或具有唯一 canonical file、active body、完整 spec 和一致 caller-local contracts。
3. 核对所有切片归一均有权威源码/config 证据并保持控制流、返回值、副作用和 ABI。
4. 核对每条 path 的 arguments、return、old/new、abstract effect、ownership transfer 和 frame。
5. 核对 Require 足以执行但没有无依据加强，Ensure 没有弱化真实义务。
6. 核对所有 load/store 能追溯到同一 review-passed predicate revision。
7. 编译/typecheck predicate formal sources，完成人工 annotated C 结构与源码等价性检查。
8. 确认没有影响 path、effect、ownership、frame 或依赖结论的 [OPEN]。

此阶段不运行 QCP parser/symbolic、closure script、VC 或 proof。条件全部满足后固定 spec revision，使用 [spec review 模板](../assets/spec-review-template.md)记录证据；predicate 与 spec 分别 review-passed 后，请用户确认两份 revision。
