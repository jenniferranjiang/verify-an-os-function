---
file_or_slice: "lib/SemaphoreRep.v — store_sem_uninitialized_bucket"
approved_version: "predicate-r21-ff08c5d6b28a"
status: review-passed
change_kind: breaking
approved_by: "user standing approval for proof-discovered design corrections"
approved_at: "2026-10-08"
---

# 设计变更：未初始化 semaphore bucket head 非空

- Change kind：`breaking`。r20 的同名 assertion 被加强，因此旧 predicate revision 失效；函数签名、heap footprint、abstract state/command 与 public API 不变。
- 原批准设计：`predicate-r20-77f0b1b09bbd` 中 None bucket 只拥有 `head.prev |-> 0 ** head.next |-> 0`。
- 新源码/proof 证据：`xs_id.h:50,55` 由 `DECLARE_ID_MANAGER` 创建真实连续 bucket-head 数组并让 manager 指向该数组；`semaphore.c:30` 实例化该宏；`id.c:67-70` 形成范围内数组元素地址后立即读取 `head->node_prev`。生成的 `InsertObj_which_implies_wit_3` 因旧表示缺少 `head <> 0` 无法建立首次解引用安全。
- 拟议修改：`store_sem_uninitialized_bucket head := “ head <> 0 ” && head.prev |-> 0 ** head.next |-> 0`。
- 对 abstract state/command 的影响：无；`SemBucket=None` 仍表示 BSS 双 NULL，状态转换与 ID/bucket 抽象函数不变。
- 对 ownership/predicate/spec 的影响：不增加或移动任何 byte ownership；只显式保存真实数组元素地址的纯事实。None/Some 分支、lazy init与 remainder 可由 `store_semaphore_buckets_focus_local` 无损拆封/回封。canonical Require/Ensure、public effect与trusted contracts不变；spec只需重新绑定 predicate dependency。
- 对 trust/scope 和已完成工作的影响：trusted symbol集合仍为 `x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`；源码/config manifest仍为 `source-s2-2adc70fc1afc`。已完成 leaf/AllocId proofs不使用弱化方向，待最终全量重编确认。
- 保持不变的 formal types/statements/interfaces：全部 record/command/protocol类型、canonical function contracts、`store_sem_uninitialized_bucket` 的参数与返回类型以及所有 public lifecycle predicate签名。
- 受影响文件和已批准内容：正式 delta 仅 `lib/SemaphoreRep.v:140-145`；proof-local helper为 `VC/SemaphoreProofLocal.v`。其余六个 formal 文件与 r20逐字相同。
- 已考虑但拒绝的方案：从 points-to 猜测 base 非零不成立；在生成 VC 中手工假设非空违反 trust 与 generated-file 门禁；把非空仅塞进 C focus cut 会失去 representation 依据。故选择在真实数组 representation 中保存事实。
- 可独立继续的工作：predicate/spec dependency review通过后，可重新运行 closure/QCP并继续 `InsertObj` 及其 callers；不得跳过受影响生成物与最终全量检查。
- 审阅决定和新版本：独立 reviewer `predicate_r21_review` 复算 source17、r20 reconstruction、r21 formal/helper hashes，检查源码/ownership/path closure，并以 Coq 8.20.1/OCaml 4.14.1 独立完成七 formal+helper `coqchk` 与 trust scan。结论 `review-passed`；新 revision `predicate-r21-ff08c5d6b28a`，完整 manifest `ff08c5d6b28a62b3e96c307fb1561c38c2525c12523095d7693652f3b16d8b9e`；spec dependency `spec-r19-6a7d5aac3bea` affected-only review-passed。

用户已在 implement 中明确授权 proof-discovered 的设计问题完成回退、修复与 review 后无需再次等待批准，可直接继续证明；本 revision 据此恢复 implement。

本 revision 后续已被 `predicate-r22-5b808e69a733` supersede；bucket-head nonnull结论保持不变。
