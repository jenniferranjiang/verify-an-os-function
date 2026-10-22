已完成 safety_entry 的 6 个 top-level safety VC。均使用 LLM_pre_process ltac:(lia || int_auto) 证明字面量 0 或 32 的有符号整数边界；没有新增 helper、修改规约或新增假设。

正式 group-check 返回 exit 0、status passed，当前 copied manual 及库重新编译通过。禁用 lemma/tactic 扫描无命中。
