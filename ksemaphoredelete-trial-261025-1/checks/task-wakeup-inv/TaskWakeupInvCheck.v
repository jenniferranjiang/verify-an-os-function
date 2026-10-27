(* Check the active shared import and exact resource composition. *)
Require Import CRTOS_Verify.lib.KSemaphoreDelete.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope sac.
Check (task_wakeup_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (fun sg st =>
  (eq_refl : task_wakeup_inv sg st =
    (task_fields sg st ** delay_inv sg st ** assign_ready_pending sg st))).
