# atomic_exit 交付

已完成全部 9 个 assigned proof spans，包括 which_implies_wit_9 的三个 split goals。

新增并证明 guarded_resume_commit__atomic_exit：由原 gap 的实际 locked 观察、locked 等待序列和完整批量效果，实例化原受限原子程序的正常转换，并从原 weakest-precondition 推出 current 的返回 continuation。未增加环境、堆或转换假设。

空剩余队列通过 event_resume_remaining_effect 完成批量效果；原 gap 提供 p 非零，current 的空 pending 提供退出 guard。partial_solve 与 return 保留现有临界区及 os_inv 资源。

aggressive_pre_process 自动关闭恒真的 GTrans 目标；顶层仅用 Goal_apply 分派实际剩余的 split_goal_1 和 split_goal_3。split_goal_2 自身仍完整证明。

禁止 lemma/tactic 扫描通过。严格 coq-check --target-kind group-check --group atomic_exit 返回 exit 0、JSON status passed，耗时 48.363202 秒，重新编译本组 lib、goal、auto、manual 和 group wrapper。

无 annotation blocker。交付后停止全部文件写入，等待 main finalize-delivery。
