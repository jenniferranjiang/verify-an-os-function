#ifndef KSEMAPHORECREATE_TRIAL_LOGIC_H
#define KSEMAPHORECREATE_TRIAL_LOGIC_H
/* Formal semantic vocabulary only; function contracts remain caller-local. */
/*@ Import Coq Require Import KSemaphoreCreateTrial.KSemaphoreCreate */
/*@ Import Coq Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv */
/*@ Import Coq Require Import TrialShared.DoubleLinkListSpec */
/*@ Import Coq Import IDNode DLL */
/*@ Import Coq From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq Record StableIdmanager {
      idmax: Z;
      hoffset: Z;
      id_map: Z;
      htable: Z;
} */
/*@ Extern Coq
      (StableGlobalState :: *) (VarGlobalState :: *)
      (VarIdmanager :: *)
      (SemaphoreStable :: *) (SemaphoreAbs :: *)
      (program :: * => * => *)
 */
/*@ Extern Coq SemaphoreState := list SemaphoreAbs */
/* VRTOS callee contract vocabulary, interpreted in this trial's memory model. */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
      (DL_Node :: * => *) (IdNodeAbs :: *) (option :: * => *)
*/
/*@ Extern Coq
      (Some : {A} -> A -> option A)
      (None : {A} -> option A)
      (Build_IdNodeAbs : Z -> addr -> IdNodeAbs)
      (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
      (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z)
      (store_idnode_insert_ready : addr -> Assertion)
      (store_idnode_unlinked : addr -> IdNodeAbs -> Assertion)
      (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion)
      (occupy_dll_node : addr -> Assertion)
      (dll_insert_anchor : {A} -> addr -> list(DL_Node A) -> addr -> Prop)
      (dll_insert_after_dispatch : {A} -> addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A))
      (ALIGN_SIZE : Z)
      (addr_aligned : Z -> Z -> Prop)
      (CharArray::undef_full : Z -> Z -> Assertion)
      (CharArray::full : Z -> Z -> list Z -> Assertion)
      (repeat_Z : {A} -> A -> Z -> list A)
*/
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Extern Coq
      (safeExec : {Sigma} {A} ->
        (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_semaphore_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
      (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
      (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
      (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
      (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (CriticalNest : Z -> Assertion)
      (os_semaphores : VarGlobalState -> SemaphoreState)
      (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
      (semaphore_manager_stable : SemaphoreStable -> StableIdmanager)
      (semaphore_manager : SemaphoreState -> VarIdmanager)
      (semaphore_first_link : SemaphoreStable -> SemaphoreState -> Z)
      (idbucket_first_link : StableIdmanager -> VarIdmanager -> Z -> Z)
      (semaphore_publish : Z -> Z -> Z -> SemaphoreState -> SemaphoreState)
      (replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState)
      (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
      (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion)
      (idmanager_full : StableIdmanager -> VarIdmanager -> Prop)
      (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
      (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
      (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
      (ZeroIdNode : Z -> Assertion)
      (AssignedIdNode : Z -> Z -> Assertion)
      (NodeStorage : Z -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (DllInsertAfterCut : Z -> Z -> Z -> Z -> Z -> Assertion)
      (DllInsertedCut : Z -> Z -> Z -> Assertion)
      (SemaphoreRaw : Z -> Assertion)
      (SemaphoreZero : Z -> Assertion)
 */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
#endif
