(* Check the active shared symbol and its exact pure meaning, not a C proof. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem.
Require Import CRTOS_Verify.lib.KSemaphoreDelete.
Local Open Scope Z_scope.
Check (tasks_ready_with_exstatus : VarGlobalState -> list addr -> Z -> Prop).
Check (fun st tasks exstatus =>
  (eq_refl : tasks_ready_with_exstatus st tasks exstatus =
    (forall task, In task tasks -> exists desc,
      st.(os_tasks).(task_desc_map) task = Some desc /\
      desc.(tdSchedMember).(tsmStat) = TSK_READY /\
      desc.(tdExstatus) = exstatus))).
