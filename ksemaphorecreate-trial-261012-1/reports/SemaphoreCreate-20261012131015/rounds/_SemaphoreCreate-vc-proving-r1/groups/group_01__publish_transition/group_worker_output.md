publish_transition 已完成。

四个分配目标均以 Qed 闭合；top-level 使用 aggressive_pre_process，并按空间、纯 goal 1、纯 goal 2 的实际生成顺序分别 Goal_apply。

证明从旧 shifted-reverse registry 段与新 value 单元的 separation 推出新地址不在旧对象列表中；未引入 malloc freshness 假设。最小空闲 ID 与 owned UShort 范围建立发布后的有效性，完整 task/scheduler 保持并使用 bounded nesting roundtrip。空间目标折叠空 pending、本体及实际 registry 边界槽，证明节点映射和 tail 非零；对 16 个实际桶下标分情况证明 manager 派生状态等式，最终折叠 OS invariant 并保持原 InsideCritical token。

所有支持断言均在 assigned proof spans 内证明；没有新增 helper、import、库或契约修改，没有访问历史 trial 或依赖 sibling 证明。

验证：group-development 与 group-check 均真实退出 0，JSON status 为 passed。35 项禁用 lemma/tactic 扫描无命中。检查证据由本组 tool_calls.jsonl 保存。

已停止写入，交由 main finalize-delivery。
