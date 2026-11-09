已完成全部 assigned spans：which_implies_wit_2、which_implies_wit_3_split_goal_spatial、which_implies_wit_3、which_implies_wit_4。

通过 Mutex 管理 DLL 中的实际 payload 借出 pending DLL，分空/非空队列建立 head.next 及归还原 os_inv 的 wand。非空时利用独占指针槽冲突证明 next 不等于哨兵。恢复 VC 直接消去 wand。描述符 VC 从 pending 节点的 pure_suspend_sched_link 取得登记和 SUSPEND，并由 task_world_wf 取得对齐；prop_apply_p 保留原 os_inv。

历史复用和 Mutex 适配见 proof_reuse.md。全部新增 helper 使用 __head_view 后缀，seed 未改。禁用 lemma/tactic 扫描无命中。

当前 group-development：exit 0、status passed。当前 group-check：exit 0、status passed（包含本组 wrapper 和依赖编译）。无 annotation gap。
