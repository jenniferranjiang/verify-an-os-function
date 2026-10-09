---
file_or_slice: "lib/SemaphorePure.v / store_semaphore_id_manager"
approved_version: "predicate-r23-1845f34ef435"
status: review-passed
change_kind: breaking
approved_by: "user (standing approval for proof-discovered design fixes)"
approved_at: "2026-10-09"
---

# 设计变更请求：ID manager 的对象视图

- 原批准设计：`SemBucket` 与 `semaphore_buckets_ok` 直接保存完整
  `SemaphoreObject`。因此 bucket 的纯相等性同时依赖 `addr/id/value/pending`，
  虽然 `store_semaphore_id_payload` 实际只拥有 `id.id`、`id.link` 与 padding。
- 新 proof 证据：`_SemaphoreCreate` 在 ID 登记后持有
  `store_semaphore_id_manager ... (semaphore_reserve_state ... sem id)`；publish 时
  目标 invariant 要求同一 manager 表示
  `semaphore_create_state ... sem id val`。两状态只在新对象 value 从 0 变为
  `val`，但旧 predicate 仍把该 registry/body 字段纳入 bucket 纯相等性，导致
  manager ownership 无法重封装。这不是 tactic 缺口，也不能用假设绕过。
- 修改：新增 `semaphore_id_view`，保留对象 allocation address 与 ID，并把
  value/pending 规范化为 `0/nil`；`semaphore_objects_in_bucket` 对过滤结果应用
  该视图。filter 条件、bucket 顺序、ID link 地址、bitmap 与 None/Some lazy-init
  状态均不变。
- ownership 依据：权威 `id.c`/`xs_id.h` 的 manager 只访问 ID、bitmap、bucket
  link；value 与 pend list 由 registry/body 和 task bridge 唯一拥有。修改使纯模型
  与既有空间 footprint 对齐，没有删除任何实际 owned byte 或安全条件。
- abstract effect：`SemaphoreState`、registry 顺序、value、pending、R/G 与
  `abs_ksemaphore_create` 均不变；只改变 ID-manager 内部的派生纯视图。
- spec 影响：annotated C 与全部 Require/Ensure 未修改，manifest 仍为
  `4abdd1dcbfd1ec22ad68f77c764da7e6c1850643919acb613aeeb017760315d9`。
  `spec-r24` 只需 dependency rebind，不改变 contract 强度或 trusted 边界。
- formal closure：`SemaphoreProofLocal.v` 新增 value-insensitivity 与
  reserve-to-create manager entailment，并修复两处受新规范化定义影响的 bucket
  递归证明。未新增 `Axiom`、`Parameter`、`Admitted` 或 `admit`。
- candidate：七 formal 文件 manifest
  `1845f34ef4351d7cb9e97b241d242c8e5295323530c1428066c2f1f273852bfc`；
  helper hash
  `9e3f0a2625a0abe9235618ef028d7b9900eadc0d36d3c7819a259b07069cf482`。
- 审阅范围：新视图是否恰好对应 manager footprint、是否保持 filter/order/link
  与 lazy-init 语义、受影响 representation/proof closure、trust scan，以及
  `spec-r24` dependency 是否继续有效。
- 审阅决定：独立 reviewer `predicate_id_view_review` 检查权威 `id.c`/`xs_id.h`、
  manager 空间 footprint、受影响 goal→auto→manual→goal_check 重编与 trust scan，
  结论 `review-passed`，无剩余 blocker。`spec-r24-4abdd1dcbfd1` 的 annotated
  内容与 contract 强度未变，只需 dependency rebind 到 predicate r23。
