# manager_selection 证明交付

已完成本组唯一 assigned witness `proof_of__SemaphoreDelete_which_implies_wit_7`，采用规定的 `LLM_pre_process` route，结尾为 Qed。未修改 statement、prelude、seed 或其他 witness。

三个带 `__manager_selection` 后缀的完整 helper 分别证明：批量唤醒保留原对象地址/ID/value 并清空其等待序列；完整 ID manager 的 idbuckets_ok/idlist_ok 给出 ID NoDup；os_inv 可以在保持所有其余资源的同时拆为 manager 与 delete_manager_frame。主证明从实际成员关系选择 current/prefix/suffix，证明该 ID 查询命中，再组合全部原有纯事实和资源。

NoDup 是从现有 manager 资源推出的结论，没有添加新输入假设、Axiom 或占位证明。未复用历史 proof，也未读取当前 sibling 输出。

最终 controller `coq-check --target-kind group-development --group manager_selection` 退出码为 0，status=passed，耗时 89.895504 秒，实际重编译本组 lib/goal/auto/manual，复用 201 个 base 产物。首次编译仅暴露纯合取尚需 split_pures 的 tactic 问题，修复后通过。assigned span 与新增 helper 的禁用项扫描通过。

终态报告写入后停止全部修改，由 main 执行 finalize-delivery 做最终组接纳。
