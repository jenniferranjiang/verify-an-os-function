# insertion_result 完成说明

已完成 `proof_of_InsertObj_return_wit_1_split_goal_spatial`，并通过 `aggressive_pre_process` / `Goal_apply` 完成对应 top-level witness。仅修改获分配的两个 proof spans；未新增 helper、import 或库，也未修改 accepted predicate sources。

证明在现有非负 ID 与正桶数前提下将 C 余数转换为数学模，证明新桶的范围、不重复、索引与全局 ID 排列性质。通过已验证的 OSHeap 单元转换与 heap entailment bridge，在同一具体 heap 上接入新节点、恢复双向链表，再使用 `store_idbuckets_replace` 与更新后的纯不变量恢复 `store_idmanager`。尾指针非空由链表段归纳得到；字段表达式同义关系使用现有 CNotation 规则，不假设具体结构偏移，也不引入协议状态迁移。

验证：assigned proof 禁用 token 扫描无命中；最终 exact `coq-check --target-kind group-check --group insertion_result` 返回进程退出码 0、JSON `status: passed` / `returncode: 0`（128.580872 秒）。

交付后停止写入，由 main 执行 finalize-delivery。
