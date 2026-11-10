# P4 combined critical carrier 类型冲突

日期：2026-11-10。状态：`superseded`，不是当前 blocker。

以下是已撤回的独立 STS 草案的历史诊断，不是 CRTOS 源码错误。
用户已要求直接复用既有全局 critical、mutex_inv 和 os_inv；当前设计不再实例化
这里描述的第二套 carrier，因此不需要执行下文旧方案中的迁移或新增锁授权。
当前状态以 [predicate-design.md](predicate-design.md) 及新的独立审阅为准。

按第二次复审要求，`MutexDeleteRules.v` 已正式实例化唯一 trial-local
`critical_STS`，其 state 为 `MutexDeleteState`，transition 沿用当前一般模型的
`True`。该 combined token 的 `Inside/Outside/R/G` 与 atomic lifting 均可编译。

阻塞发生在把现有空间 invariant 放入 combined token carrier 时。最小复现为：

```coq
Require Import KMutexDeleteTrial.MutexDeleteRules.

Definition p4_carrier_probe (sg : MutexDeleteStable) (st : MutexDeleteState)
    : MutexDelete_C_Rules.expr :=
  mutex_delete_inv sg st.
```

从 trial 根使用 `_CoqProject` 的全部映射执行 `coqc`，稳定得到：

```text
The term "mutex_delete_inv sg st" has type "Assertion"
while it is expected to have type "MutexDelete_C_Rules.expr"
(cannot unify "MutexDelete_C_Rules.model" and "model").
```

原因是根 `os_inv`、Mutex/ID/DLL 等 predicate 已编译到根
`Crtos_C_Rules` 的生成式 `model`；trial-local combined `ConAssertion.CSL`
产生另一个 `MutexDelete_C_Rules.model`。Rocq 不允许把两者视为同一 assertion
carrier。combined token 本身编译成功并不能让既有空间 predicate 自动迁移。

本轮没有退回根 token 投影，也没有新增 trusted Lock/Unlock contract。
要关闭 P4，必须把根共享空间库统一重新实例化到 combined STS carrier，或提供
经证明的 assertion-carrier 同构/迁移层；两者都会超出“仅修 P3/P4 局部接口”的
增量范围。该阻塞未获解决前，predicate 不能标为 `review-passed`。

