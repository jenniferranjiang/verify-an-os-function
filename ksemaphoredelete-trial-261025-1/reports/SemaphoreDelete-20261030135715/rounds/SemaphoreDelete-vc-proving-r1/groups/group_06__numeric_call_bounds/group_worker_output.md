已完成本组 13 个指定 proof spans，均以 Qed 结束。

入口 Int 范围使用 store_int_range；16 位截断上下界使用 unsigned_Lastnbits_range；全局 manager 地址非零使用 CNotation.addr_of_LE_var_not_zero。whole-goal wrapper 保留 manager、delete_manager_frame、InsideCritical 并重建纯事实。未新增 helper，未修改 library seed、语义输入或任何未分配 proof。

禁用 lemma/tactic 扫描无命中。controller coq-check --target-kind group-check --group numeric_call_bounds 实际退出码 0，JSON status 为 passed；本组 manual、library、goal、auto 和 wrapper 均重新编译。
