(** Design-only interface Check. No VC or C proof. Generated from current headers. *)
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import Coq.Lists.List Coq.ZArith.ZArith.
From AUXLib Require Import ListLib.
Require Import CRTOS_Verify.lib.KSemaphoreCreate.
Import DLL IDNode ListNotations.

Check (@MonadErr.M : Type -> Type -> Type).
Check (unit : Type).
Check (@safeExec : forall Sigma A : Type, (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall Sigma A : Type, A -> program Sigma A).
Check (tt : unit).
Check (StableGlobalState : Type).
Check (VarGlobalState : Type).
Check (SemaphoreStable : Type).
Check (SemaphoreState : Type).
Check (StableIdmanager : Type).
Check (VarIdmanager : Type).
Check (IdNodeAbs : Type).
Check (DL_Node : Type -> Type).
Check (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (IRQMask : Z -> Assertion).
Check (slice_OS_inv : StableGlobalState -> VarGlobalState -> Z -> Assertion).
Check (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (ExactSeen : VarGlobalState -> VarGlobalState -> Prop).
Check (abs_semaphore_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z).
Check (abs_semaphore_create_nested : StableGlobalState -> Z -> program VarGlobalState Z).
Check (semaphore_create_nested_result : StableGlobalState -> Z -> VarGlobalState -> Z -> Z -> VarGlobalState -> Z -> Prop).
Check (nest_inc : Z -> Z).
Check (nest_dec : Z -> Z).
Check (nest_roundtrip : Z -> Z).
Check (critical_anchor : Z -> VarGlobalState -> VarGlobalState -> VarGlobalState).
Check (sem_allocated : Z -> Assertion).
Check (sem_zero : Z -> Assertion).
Check (sem_id_registered : Z -> Assertion).
Check (sem_ready_to_publish : Z -> Z -> Assertion).
Check (idnode_private : Z -> Z -> Z -> Z -> Assertion).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion).
Check (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion).
Check (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion).
Check (Build_IdNodeAbs : Z -> Z -> IdNodeAbs).
Check (idmanager_full : StableIdmanager -> VarIdmanager -> Prop).
Check (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
Check (idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager).
Check (occupy_dll_node : Z -> Assertion).
Check (@store_dll : forall A : Type, (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion).
Check (@Build_DL_Node : forall A : Type, A -> Z -> DL_Node A).
Check (store_idnode : Z -> IdNodeAbs -> Assertion).
Check (idnodes_to_dll : list IdNodeAbs -> list (DL_Node IdNodeAbs)).
Check (idbuckets : VarIdmanager -> list (list IdNodeAbs)).
Check (hoffset : StableIdmanager -> Z).
Check (semaphore_idmanager : SemaphoreStable -> SemaphoreState -> VarIdmanager).
Check (os_semaphore_stable : StableGlobalState -> SemaphoreStable).
Check (sem_idmanager_stable : SemaphoreStable -> StableIdmanager).
Check (os_semaphores : VarGlobalState -> SemaphoreState).
Check (sem_ptr_list : SemaphoreState -> list Z).
Check (semaphore_link_nodes : list Z -> list (DL_Node Z)).
Check (pure_semaphore_link_member : Z -> Z -> Assertion).
Check (semaphore_publish : Z -> Z -> Z -> SemaphoreState -> SemaphoreState).
Check (replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState).
Check (@Znth : forall A : Type, Z -> list A -> A -> A).

Check (fun sg val before (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
 safeExec (LastSeen before) (abs_semaphore_create sg val) X).
Check (fun sg val before (Y : Z -> VarGlobalState -> Prop) =>
 safeExec (ExactSeen before) (abs_semaphore_create_nested sg val) Y).
Check (fun (ret : Z) (P : (VarGlobalState -> Prop) -> Prop)
 (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
 safeExec P (MonadErr.ret ret) X).
Check (fun (ret : Z) (P : VarGlobalState -> Prop)
 (Y : Z -> VarGlobalState -> Prop) => safeExec P (MonadErr.ret ret) Y).
