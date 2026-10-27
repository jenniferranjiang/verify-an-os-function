Require Import Coq.ZArith.ZArith.
Require Import KSemaphoreDeleteTrial.KSemaphoreDelete.
(** 纯转换检查：等待链和就绪链使用定义相同的节点，source view 的地址也相同。
    不是 C 实现证明；没有新增公理或假设。 *)
Check (fun task : Z => (eq_refl : semaphore_wait_node task = ready_task_node task)).
Check (fun task : Z => (eq_refl : getPtr (semaphore_wait_node task) = sched_link_of task)).
