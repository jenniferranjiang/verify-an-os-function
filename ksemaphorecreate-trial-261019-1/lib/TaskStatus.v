(** xs_ktask.h 中 0..4 的任务状态；根库引用的 libai 已缺失，本次从当前宏重建纯类型。 *)
Inductive TaskStatus := TSK_INIT | TSK_READY | TSK_SUSPEND | TSK_RUNNING | TSK_CLOSE.
