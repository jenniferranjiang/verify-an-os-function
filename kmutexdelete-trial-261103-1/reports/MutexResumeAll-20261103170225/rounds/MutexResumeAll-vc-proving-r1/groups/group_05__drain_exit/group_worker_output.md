# drain_exit 完成记录

本组完成两个 parent witness 与四个 split，共六个分配证明区域，均以 Qed 结束。保持声明、顺序、prelude、seed 与未分配区域不变。未修改 C、冻结规格、predicate 或共享库；未读取当前 sibling 输出。

新增两个带 __drain_exit 后缀的完整 helper：

- resume_effect_keeps_drained_identity__drain_exit：按原 pending 的空/非空情形展开真实 aggregate effect；非空情形选择原对象在清空 pending map 中的像，从而保留地址和 ID，不新增唯一性假设。
- scoped_resume_safe_continuation__drain_exit：使用具体 locked/current 状态构造 scoped 操作的 normal execution，经已有 highstependret_derive 保持原 continuation；未重建 bind，未假设待证 safeExec。

剩余队列为空时，以反身的空 steps 特化 remaining_effect，得到本次真实批量效果。GTrans/CS 分支直接化为 True。返回值分支为 0=KOK。所有 split 使用 LLM_pre_process ltac:(lia || int_auto)；两个 parent 使用 aggressive_pre_process 后接对应 Goal_apply。which_implies_wit_9 的 True 分支由 parent 预处理关闭，显式 Goal_apply 对应 split 1 和 split 3。

验证结果：

- 两个 helper 均已通过当前 Rocq MCP 交互至 Qed（完成状态 27、52）。
- 六个 assigned span 均已在 controller 生成的本组 dev 工作区交互至 Qed：return split 86、return parent 61、which split 1/2/3 分别 67/71/77、which parent 82。
- group-development：exit 0，JSON status passed，45.072921 秒；编译本组 lib/goal/auto/manual，复用 201 个 base vo。
- group-check：exit 0，JSON status passed，47.605746 秒；编译本组 lib/goal/auto/manual 及 MutexResumeAll_group_05_drain_exit_check.v，复用 201 个 base vo。
- 完整 copied manual/lib 的 forbidden-lemma 与禁用 tactic 扫描零命中；本组新增 helper 无 Admitted/Axiom/Parameter，本组六个区域均 Qed。未分配模板保留原状。

无新增环境假设，无 spec/predicate 变更，无 annotation gap。开发期间修复过 proof 文本的反斜杠转义排版错误，最终文件已由上述检查验证。
