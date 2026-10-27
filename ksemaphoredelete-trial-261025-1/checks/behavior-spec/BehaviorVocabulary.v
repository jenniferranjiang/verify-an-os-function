(* Type checks of the result summary and empty queue expression only;
   this file neither states the whole C contract nor proves the implementation. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import CRTOS_Verify.lib.KSemaphoreDelete.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Import DLL.
Local Open Scope Z_scope.
Check (fun (after : VarGlobalState) (waiting : list addr) =>
  forall task, In task waiting -> exists desc,
    after.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_READY /\ desc.(tdExstatus) = -1).
Check (fun (after : VarGlobalState) (head : addr) =>
  store_dll (pure_suspend_sched_link after.(os_tasks).(task_desc_map)) head nil).
