# retire_success delivery

已完成本组分配的 8 个 proof spans：4_2、4_4 的三个 split goals 和两个 top-level witnesses。保持 aggressive_pre_process 路线，实际分派顺序为 spatial、safeExec；Crtos_GTrans 的 True 目标由预处理关闭，其单独 split lemma 也已证明。

辅助引理全部位于本组 EventDelete_lib.v，使用 __retire_success 后缀，保留原 seed：

- 由桶成员关系与旧 ID NoDup 唯一定位 idnode；不借用已经拆出的旧 os_inv。
- 利用地址 NoDup 证明 unpublish 精确删除 original，保留 prefix/suffix 顺序。
- 空 pending 删除保持 event_waiters、调度节点归属与 world 条件；从实际 frame 重建 task_world_wf 和 os_inv。
- 使用实际 payload、被移除的 ID 标量和自环链字段构造 EventRetired，保留 options/events/padding。
- 使用 wp_bind 与实际 guarded unpublish nrm 消费 event_delete_finish 的第一步，保留调用者 X，并分别获得 assign/ret continuation。

未使用设计阶段 obligation 作为已证明事实，未增加公理或 annotation/spec 前提。

验证：交接指定 coq-check --target-kind group-check --group retire_success 已返回 exit 0、JSON status passed。开发期间同时使用 controller coq-debug 和显式 state_id 的 Rocq MCP 交互诊断。通用 csimpl 在嵌套地址展开处超时后，已改用明确字段地址等式；最终证明不含该 tactic。

本组已停止写入，交由 main 执行 finalize-delivery。
