# Semaphore predicate r11 affected-only review

状态：`superseded before review`（无 review 结论）

Predicate revision：`predicate-r11-c2eeee4115a8`。Manifest 命令 `sha256sum lib/*.v | sort | sha256sum`，完整 hash 为 `c2eeee4115a891001dab15b6e98929b6440e3d3d5de1c3ef1f47ecb8480e05b6`。权威 C、配置、scope 和 trusted 列表均未变。

r11 包含 r9/r10 对 `PRED-R8-01..05` 的全部修复及 dependency closure；历史记录分别见 `2026-09-01-3-predicate-r9-affected-review.md` 和 `2026-09-01-4-predicate-r10-affected-review.md`。r11 额外把 critical C wrapper 内的两个可达瞬态纳入正式 ownership ledger：

- `semaphore_critical_lock_pending saved handlers sg st`：`DisableLocalInterrupt` 已执行 ghost enter 并取得非空层 invariant，但 `KTaskOsAssignLockNest++` 尚未执行；因此 protocol depth 为 `saved :: handlers`，counter 仍精确为 `depth handlers`。
- `semaphore_critical_unlock_pending saved rest sg protocol_state memory_state`：wrapper 已执行 counter decrement，但 `EnableLocalInterrupt` 尚未做 ghost exit；因此 protocol 仍持有 `saved :: rest/protocol_state`，线性 concrete invariant 已是 `memory_state`，counter 为 `depth rest`，两个 state 只由 `SemaphoreGuarantee` 的 identity-or-one-source-step 连接。

稳定 wrapper 边界仍统一使用 `semaphore_critical_interface`，进入前使用 `semaphore_critical_enterable`；两个 pending predicate 只对应 wrapper 中各一条 counter 语句两侧，不引入新业务状态或假设。

## 机械检查

- Rocq 8.20.1 `make clean && make -j2` 全量编译通过，`make -q` 通过。
- forbidden-token 扫描 `Parameter|Axiom|Admitted|admit`：零匹配。
- 未运行 QCP parser/symbolic、closure script、VC 或 proof。

## Affected-only review 记录

r11 未再提交 reviewer。Main 在最终冻结前继续自审，随后补上每条 rely/guarantee 边的 before/after world-wf guard，并将静态 ID buckets 起点收紧回真实 `repeat None 16` BSS 形态。后续候选 revision 见 r13 报告。
