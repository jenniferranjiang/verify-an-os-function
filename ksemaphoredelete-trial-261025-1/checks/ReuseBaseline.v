(** 仅核对共享定义可导入；不是 KSemaphoreDelete 的正式 predicate revision。 *)
Require Import CRTOS_Verify.lib.SemaphoreState.
Require Import CRTOS_Verify.lib.SemaphoreInv.
Require Import CRTOS_Verify.lib.CrtosInv.
Require Import CRTOS_Verify.lib.KTaskOsAssign.
Check semaphore_inv.
Check SemaphoreRaw.
Check IDNode.store_idmanager_removeobj_post.
Check pure_suspend_sched_link.
Check delay_inv.
Check assign_inv.
Check os_inv.
Check InsideCritical.
Check OutsideCritical.
Check abs_ktask_assign.
