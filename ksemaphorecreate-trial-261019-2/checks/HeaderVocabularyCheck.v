(* Generated only from current monad.h/logic.h by checks/check_headers.py. *)
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
(* monad.h: program *)
Check (MonadErr.M : Type -> Type -> Type).
(* monad.h: unit *)
Check (unit : Type).
(* monad.h: safeExec *)
Check (@monadesafe_lib.safeExec : forall (Sigma : Type) (A : Type), (Sigma -> Prop) -> MonadErr.M Sigma A -> (A -> Sigma -> Prop) -> Prop).
(* monad.h: return *)
Check (@MonadErr.ret : forall (Sigma : Type) (A : Type), A -> MonadErr.M Sigma A).
(* monad.h: tt *)
Check (tt : unit).
Require Import Coq.ZArith.ZArith Coq.Lists.List.
From AUXLib Require Import ListLib.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.KSemaphoreCreate.
Import DLL IDNode ListNotations.
(* logic.h: StableGlobalState *)
Check (StableGlobalState : Type).
(* logic.h: VarGlobalState *)
Check (VarGlobalState : Type).
(* logic.h: SemaphoreStable *)
Check (SemaphoreStable : Type).
(* logic.h: SemaphoreState *)
Check (SemaphoreState : Type).
(* logic.h: SemaphoreObject *)
Check (SemaphoreObject : Type).
(* logic.h: SemaphoreAbs *)
Check (SemaphoreAbs : Type).
(* logic.h: TaskState *)
Check (TaskState : Type).
(* logic.h: TaskDescriptorAbs *)
Check (TaskDescriptorAbs : Type).
(* logic.h: StableIdmanager *)
Check (StableIdmanager : Type).
(* logic.h: VarIdmanager *)
Check (VarIdmanager : Type).
(* logic.h: IdNodeAbs *)
Check (IdNodeAbs : Type).
(* logic.h: DL_Node *)
Check (DL_Node : Type -> Type).
(* logic.h: option *)
Check (option : Type -> Type).
(* logic.h: true *)
Check (true : bool).
(* logic.h: false *)
Check (false : bool).
(* logic.h: InsideCritical *)
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
(* logic.h: OutsideCriticalIRQ *)
Check (OutsideCriticalIRQ : Z -> StableGlobalState -> VarGlobalState -> Assertion).
(* logic.h: critical_projection *)
Check (critical_projection : StableGlobalState -> VarGlobalState -> Assertion).
(* logic.h: critical_nest *)
Check (critical_nest : Z -> Assertion).
(* logic.h: critical_nest_inc *)
Check (critical_nest_inc : Z -> Z).
(* logic.h: critical_nest_dec *)
Check (critical_nest_dec : Z -> Z).
(* logic.h: critical_nest_roundtrip *)
Check (critical_nest_roundtrip : Z -> Z).
(* logic.h: critical_anchor *)
Check (critical_anchor : bool -> VarGlobalState -> VarGlobalState -> VarGlobalState).
(* logic.h: Crtos_RTrans *)
Check (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
(* logic.h: Crtos_GTrans *)
Check (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
(* logic.h: LastSeen *)
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
(* logic.h: ExactSeen *)
Check (ExactSeen : VarGlobalState -> VarGlobalState -> Prop).
(* logic.h: abs_semaphore_create *)
Check (abs_semaphore_create : StableGlobalState -> Z -> MonadErr.M (VarGlobalState -> Prop) Z).
(* logic.h: abs_semaphore_create_masked *)
Check (abs_semaphore_create_masked : StableGlobalState -> Z -> MonadErr.M VarGlobalState Z).
(* logic.h: semaphore_create_nest_result *)
Check (semaphore_create_nest_result : StableGlobalState -> Z -> VarGlobalState -> Z -> Z -> VarGlobalState -> Z -> Prop).
(* logic.h: semaphore_allocated *)
Check (semaphore_allocated : Z -> Assertion).
(* logic.h: semaphore_zero *)
Check (semaphore_zero : Z -> Assertion).
(* logic.h: semaphore_after_id *)
Check (semaphore_after_id : Z -> Assertion).
(* logic.h: store_private_idnode *)
Check (store_private_idnode : Z -> Z -> Z -> Z -> Assertion).
(* logic.h: store_uninit_dlnode *)
Check (store_uninit_dlnode : Z -> Assertion).
(* logic.h: store_dll *)
Check (@store_dll : forall (A : Type), (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion).
(* logic.h: Build_DL_Node *)
Check (@Build_DL_Node : forall (A : Type), A -> Z -> DL_Node A).
(* logic.h: store_idmanager *)
Check (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion).
(* logic.h: store_idmanager_allocated_unlinked *)
Check (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion).
(* logic.h: store_idnode_unlinked *)
Check (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion).
(* logic.h: store_idnode *)
Check (store_idnode : Z -> IdNodeAbs -> Assertion).
(* logic.h: Build_IdNodeAbs *)
Check (Build_IdNodeAbs : Z -> Z -> IdNodeAbs).
(* logic.h: idmanager_full *)
Check (idmanager_full : StableIdmanager -> VarIdmanager -> Prop).
(* logic.h: idmanager_min_free_id *)
Check (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
(* logic.h: idmanager_add *)
Check (idmanager_add : VarIdmanager -> Z -> VarIdmanager).
(* logic.h: idmanager_link *)
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager).
(* logic.h: idnodes_to_dll *)
Check (idnodes_to_dll : list IdNodeAbs -> list (DL_Node IdNodeAbs)).
(* logic.h: idbuckets *)
Check (idbuckets : VarIdmanager -> list (list IdNodeAbs)).
(* logic.h: hoffset *)
Check (hoffset : StableIdmanager -> Z).
(* logic.h: sem_idmanager_abs *)
Check (sem_idmanager_abs : SemaphoreState -> VarIdmanager).
(* logic.h: sem_idmanager_stable *)
Check (sem_idmanager_stable : SemaphoreStable -> StableIdmanager).
(* logic.h: os_semaphore_stable *)
Check (os_semaphore_stable : StableGlobalState -> SemaphoreStable).
(* logic.h: os_semaphores *)
Check (os_semaphores : VarGlobalState -> SemaphoreState).
(* logic.h: os_tasks *)
Check (os_tasks : VarGlobalState -> TaskState).
(* logic.h: task_desc_map *)
Check (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs).
(* logic.h: pure_suspend_sched_link *)
Check (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion).
(* logic.h: sem_objects *)
Check (sem_objects : SemaphoreState -> list SemaphoreObject).
(* logic.h: Build_SemaphoreObject *)
Check (Build_SemaphoreObject : Z -> Z -> SemaphoreAbs -> SemaphoreObject).
(* logic.h: Build_SemaphoreAbs *)
Check (Build_SemaphoreAbs : Z -> list (DL_Node Z) -> SemaphoreAbs).
(* logic.h: semaphore_node *)
Check (semaphore_node : SemaphoreObject -> DL_Node SemaphoreObject).
(* logic.h: store_semaphore_member *)
Check (store_semaphore_member : (Z -> Z -> Assertion) -> Z -> SemaphoreObject -> Assertion).
(* logic.h: semaphore_publish *)
Check (semaphore_publish : VarGlobalState -> Z -> Z -> Z -> VarGlobalState).
(* logic.h: map *)
Check (@map : forall (A : Type) (B : Type), (A -> B) -> list A -> list B).
(* logic.h: Znth *)
Check (@Znth : forall (A : Type), Z -> list A -> A -> A).

(* Exact state parameters used by the outer create and return continuations. *)
Check (fun (sg : StableGlobalState) (value : Z) (before : VarGlobalState)
           (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
  monadesafe_lib.safeExec (LastSeen before) (abs_semaphore_create sg value) X).
Check (fun (sg : StableGlobalState) (value : Z) (before : VarGlobalState)
           (Y : Z -> VarGlobalState -> Prop) =>
  monadesafe_lib.safeExec (ExactSeen before) (abs_semaphore_create_masked sg value) Y).
Check (fun (after : VarGlobalState) (result : Z)
           (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
  monadesafe_lib.safeExec (LastSeen after) (MonadErr.ret result) X).
Check (fun (after : VarGlobalState) (result : Z)
           (Y : Z -> VarGlobalState -> Prop) =>
  monadesafe_lib.safeExec (ExactSeen after) (MonadErr.ret result) Y).

