# allocation_frames

完成分配的 6 个 witnesses：partial_solve_wit_1/2/3 及各自 pure witness。所有证明均以指定的 LLM_pre_process route 开始，并逐个通过 Rocq MCP 交互 Qed。

sizeof 边界使用现有 mutex_size_axiom，经同架构 notation 的定义转换得到 sizeof("Mutex") = 36。memset 前后保持原始字节数组与 OutsideCritical，复制 VC 已有的地址范围、对齐和 safeExec 前提；未增加任何假设、helper 或修改 spec/predicate/C。

controller group-development 通过；最终 exact group-check 真实退出码 0、JSON status passed，编译包含本组 wrapper。禁止 lemma/tactic 扫描通过。仅修改本组指定 proof spans。
