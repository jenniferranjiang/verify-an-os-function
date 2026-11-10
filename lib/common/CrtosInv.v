Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export CRTOS_Verify.lib.common.CrtosRules.
Require Export CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.id.idnode.
Require Export CRTOS_Verify.lib.common.IsrManagerInv.
Require Export CRTOS_Verify.lib.common.SemaphoreInv.
Require Export CRTOS_Verify.lib.common.MutexInv.
Require Export CRTOS_Verify.lib.common.EventInv.
Require Export CRTOS_Verify.lib.list.DoubleLinkListSpec.
Require Export CRTOS_Verify.lib.event.EventLayoutABI.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(** Retained object queues own their list links directly.  No task descriptor,
    scheduler node payload, or task predicate is part of the global invariant. *)
Definition empty_wait_payload (_owner _link : addr) : Assertion := emp.

Definition os_wait_owners (st : VarGlobalState) : list addr :=
  semaphore_waiters st.(os_semaphores) ++
  mutex_waiters st.(os_mutexes) ++
  event_waiters st.(os_events).

Record os_world_wf (sg : StableGlobalState) (st : VarGlobalState) : Prop := {
  os_wf_context : os_global_context sg;
  os_wf_wait_nodup : NoDup (os_wait_owners st)
}.

Definition os_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ os_world_wf sg st ” &&
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) **
  semaphore_inv empty_wait_payload
    sg.(os_semaphore_stable) st.(os_semaphores) **
  mutex_inv empty_wait_payload
    sg.(os_mutex_stable) st.(os_mutexes) **
  event_inv empty_wait_payload
    sg.(os_event_stable) st.(os_events).
