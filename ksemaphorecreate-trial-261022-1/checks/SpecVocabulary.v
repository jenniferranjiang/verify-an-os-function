(* Typechecking of declared vocabulary only. No function contracts or proofs. *)
Require Import Coq.ZArith.ZArith.
From SimpleC.SL Require Import Mem.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Require Import TrialShared.DoubleLinkListSpec.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import IDNode DLL.
Check (@StableGlobalState : Type).
Check (@VarGlobalState : Type).
Check (@VarIdmanager : Type).
Check (@SemaphoreStable : Type).
Check (@SemaphoreAbs : Type).
Check (@MonadErr.M : Type -> Type -> Type).
Check (@DL_Node : Type -> Type).
Check (@IdNodeAbs : Type).
Check (@option : Type -> Type).
Check (@Some : forall (A : Type),  A -> option A).
Check (@None : forall (A : Type),  option A).
Check (@Build_IdNodeAbs : Z -> addr -> IdNodeAbs).
Check (@Build_DL_Node : forall (A : Type),  A -> addr -> DL_Node A).
Check (@idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z).
Check (@store_idnode_insert_ready : addr -> Assertion).
Check (@store_idnode_unlinked : addr -> IdNodeAbs -> Assertion).
Check (@store_dll : forall (A : Type),  (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion).
Check (@occupy_dll_node : addr -> Assertion).
Check (@dll_insert_anchor : forall (A : Type),  addr -> list(DL_Node A) -> addr -> Prop).
Check (@dll_insert_after_dispatch : forall (A : Type),  addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)).
Check (@ALIGN_SIZE : Z).
Check (@addr_aligned : Z -> Z -> Prop).
Check (@CharArray.undef_full : Z -> Z -> Assertion).
Check (@CharArray.full : Z -> Z -> list Z -> Assertion).
Check (@repeat_Z : forall (A : Type),  A -> Z -> list A).
Check (@monadesafe_lib.safeExec : forall (Sigma A : Type), 
        (Sigma -> Prop) -> MonadErr.M Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall (Sigma A : Type),  A -> MonadErr.M Sigma A).
Check (@LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (@abs_semaphore_create : StableGlobalState -> Z -> MonadErr.M (VarGlobalState -> Prop) Z).
Check (@OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (@CriticalNest : Z -> Assertion).
Check (@os_semaphores : VarGlobalState -> SemaphoreState).
Check (@os_semaphore_stable : StableGlobalState -> SemaphoreStable).
Check (@semaphore_manager_stable : SemaphoreStable -> StableIdmanager).
Check (@semaphore_manager : SemaphoreState -> VarIdmanager).
Check (@semaphore_first_link : SemaphoreStable -> SemaphoreState -> Z).
Check (@idbucket_first_link : StableIdmanager -> VarIdmanager -> Z -> Z).
Check (@semaphore_publish : Z -> Z -> Z -> SemaphoreState -> SemaphoreState).
Check (@replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState).
Check (@store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion).
Check (@store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion).
Check (@idmanager_full : StableIdmanager -> VarIdmanager -> Prop).
Check (@idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
Check (@idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (@idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager).
Check (@ZeroIdNode : Z -> Assertion).
Check (@AssignedIdNode : Z -> Z -> Assertion).
Check (@NodeStorage : Z -> Assertion).
Check (@store_node_self_linked : Z -> Assertion).
Check (@DllInsertAfterCut : Z -> Z -> Z -> Z -> Z -> Assertion).
Check (@DllInsertedCut : Z -> Z -> Z -> Assertion).
Check (@SemaphoreRaw : Z -> Assertion).
Check (@SemaphoreZero : Z -> Assertion).
