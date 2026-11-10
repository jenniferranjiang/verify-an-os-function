#ifndef KMUTEXDELETE_TRIAL_LOGIC_H
#define KMUTEXDELETE_TRIAL_LOGIC_H
/* Types/imports only: every API contract is caller-local. */
/*@ Import Coq Require Import Coq.ZArith.ZArith Coq.Lists.List */
/*@ Import Coq From SimpleC.SL Require Import Mem */
/*@ Import Coq Require Import KMutexDeleteTrial.lib.KMutexDelete */
/*@ Import Coq Import IDNode DLL Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
 (StableGlobalState :: *) (VarGlobalState :: *) (TaskDescriptorAbs :: *)
 (TaskSchedMemberAbs :: *) (TaskStatus :: *) (TaskState :: *)
 (MutexAbs :: *) (StableIdmanager :: *) (VarIdmanager :: *)
 (DL_Node :: * => *) (option :: * => *) (unit :: *) (program :: * => * => *)
 */
/*@ Extern Coq MutexState := list MutexAbs */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq Record TaskSchedMemberAbs { tsmStat: TaskStatus; } */
/*@ Extern Coq Record TaskDescriptorAbs { tdSchedMember: TaskSchedMemberAbs; } */
/*@ Extern Coq Record TaskState { task_desc_map: addr -> option TaskDescriptorAbs; } */
/*@ Extern Coq Record VarGlobalState { os_tasks: TaskState; os_mutexes: MutexState; } */
/*@ Extern Coq
 (Some : {A} -> A -> option A) (None : {A} -> option A) (tt : unit)
 (nil : {A} -> list A) (cons : {A} -> A -> list A -> list A)
 (app : {A} -> list A -> list A -> list A)
 (true : bool) (false : bool)
 (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
 (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion)
 (store_node_self_linked : addr -> Assertion)
 (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
 (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
 (idmanager_query : VarIdmanager -> Z -> bool)
 (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> addr -> Prop)
 (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
 (ALIGN_SIZE : Z) (addr_aligned : addr -> Z -> Prop)
 (TSK_SUSPEND : TaskStatus)
 (sched_link_of : addr -> addr)
 (mutex_pending_head : addr -> addr)
 (MutexRaw : addr -> Assertion)
 (mutex_delete_find_addr : addr -> MutexState -> option MutexAbs)
 (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop)
 (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
 (return : {Sigma} {A} -> A -> program Sigma A)
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (abs_linklist_resume_all : StableGlobalState -> addr -> program (VarGlobalState -> Prop) Z)
 (abs_mutex_delete : StableGlobalState -> addr -> program (VarGlobalState -> Prop) unit)
 (abs_kmutex_delete : StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit)
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
#endif
