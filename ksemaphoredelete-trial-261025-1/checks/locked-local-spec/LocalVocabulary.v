(* Type checks for the existing definitions newly exposed in logic.h.
   This is not a QCP run or an implementation proof. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import CRTOS_Verify.lib.KSemaphoreDelete.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Import DLL.
Check (@List.map : forall A B : Type, (A -> B) -> list A -> list B).
Check (pure_suspend_sched_link :
  (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion).
Check (semaphore_wait_node : addr -> DL_Node addr).
