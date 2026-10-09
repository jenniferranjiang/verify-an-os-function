---
file_or_slice: "annotated_C/src/_SemaphoreCreate.c"
approved_version: "spec-r22-32f53a4a4114"
status: review-passed
change_kind: breaking
approved_by: "user (standing approval for proof-discovered design fixes)"
approved_at: "2026-10-08"
---

# 设计变更请求：`_SemaphoreCreate` success closure

- 原批准设计：spec r22 在 publish 后直接把 concrete/abstract heap 封装成新
  `crtos_semaphore_os_inv`，但没有把成功抽象步所需的 old/new world validity、
  allocation address freshness 与 `uint16 val` 范围保留到 return witness。
- 新源码/proof 证据：生成的
  `_SemaphoreCreate_return_wit_1_split_goal_1` 只含 `first_free = Some id`、rely
  和入口 `safeExec`，目标却是成功 world 上的 `safeExec(return id)`。
  `abs_semaphore_create` 的 success constructor 还要求 fresh address、value range、
  old/new `semaphore_state_wf`。如果 value 越界或 old state 非法，入口
  `safeExec` 只约束始终存在的 `-5` failure transition，不能推出 success return；
  因而旧 VC 在逻辑上不可证明，不能用 tactic 或假设绕过。
- 拟议修改：在 lock-open focus 中从已有
  `crtos_semaphore_os_inv * store_sem_zeroed_private` 导出 current world-wf 与
  `semaphore_find_addr sem objects = None`；从局部 `UShort` store 导出
  `0 <= val <= 65535`；publish focus 显式消费这些已有事实并同时导出新 world-wf
  与新 invariant。r23 annotated manifest 为
  `746c1060259c9d860638448c9fa577df84ac7c29f464ae8246aef371a8822478`。
  r23 的局部 typed-store cut 经 QCP 拆分后产生无条件 Z-range goal，因此 r24
  删除该 cut，并在 `_SemaphoreCreate` canonical、wrapper caller-local 与
  `KSemaphoreCreate` canonical 三处同步显式写出 `uint16` 参数值域。最终候选为
  `spec-r24-4abdd1dcbfd1`，manifest
  `4abdd1dcbfd1ec22ad68f77c764da7e6c1850643919acb613aeeb017760315d9`。
- 对 abstract state/command 的影响：无。成功仍是同一个
  `semaphore_create_state current sem id val`；失败仍 stutter。修改只把构造既有
  `abs_semaphore_create` success step 所需的真实不变量显式带到局部 VC。
- 对 ownership/predicate/spec 的影响：predicate r22 的 definition、owner 与
  footprint 不变。freshness 由旧 registry 中每个 body 的 `value` ownership 与
  新 zeroed block 的 `value` ownership 的分离性推出；world-wf 来自已打开 OS
  invariant；value range 来自 typed `UShort` store。public/canonical
  Require/Ensure 文本不变，只修改 `_SemaphoreCreate` 的 implement-local
  `which implies` annotations。
- 对 trust/scope 和已完成工作的影响：trusted 六个 C symbols 与 contract 不变；
  九函数闭包不变。InsertObj 与 IdInsertObj 已完成的 proofs 不受 spec annotation
  修改影响，但 helper 增加可机器检查的 proof-local lemmas。
- 保持不变的 formal types/statements/interfaces：`SemaphoreState`、
  `semaphore_state_wf`、`abs_semaphore_create`、`SemaphoreRely/Guarantee`、
  所有 canonical function contracts 与 predicate r22。
- 受影响文件和已批准内容：仅 `annotated_C/src/_SemaphoreCreate.c` 的 Extern 与
  局部 cut；重新生成后影响 `_SemaphoreCreate` 及 caller `KSemaphoreCreate` VC。
- 已考虑但拒绝的方案：不把 freshness 加到 trusted `x_malloc` 的无状态 contract，
  因为那会对任意 ghost object list 作无依据保证；不弱化
  `abs_semaphore_create`/`semaphore_state_wf`；不在 manual proof 中加入假设。
- 可独立继续的工作：leaf、InsertObj、IdInsertObj 已闭合；proof-local semantic
  lemmas已由 Rocq MCP 编译，checkpoint helper hash
  `b17ab589ca85f933622897c506e02cff8b89de822ac0403e93d1a122a80ee23e`，trust scan 0。
- 审阅决定和新版本：独立 reviewer `spec_r23_review` 先对 r23 完成
  affected-only review；随后对仅显式化 `uint16` 参数域的 r24 完成 minimal
  affected-only review，结论 `review-passed`。R23-01..07 与 R24-01..05
  全部 closed；九切片 GCC、helper compile/coqchk/trust scan 通过。
  用户既有 standing approval 允许该 proof-discovered 修复直接恢复 implement。
