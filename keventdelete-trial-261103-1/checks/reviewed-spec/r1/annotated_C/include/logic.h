#ifndef KEVENTDELETE_LOGIC_H
#define KEVENTDELETE_LOGIC_H
/* Semantic declarations only. All function contracts are canonical in src/
 * and copied before direct calls; there is no module-wide contract header. */
/*@ Import Coq Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import KEventDeleteTrial.lib.KEventDelete */
/*@ Import Coq Import IDNode DLL MonadErr */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
  (DL_Node :: * => *) (option :: * => *) (unit :: *)
  (StableGlobalState :: *) (VarGlobalState :: *)
  (StableIdmanager :: *) (VarIdmanager :: *) (IdNodeAbs :: *)
  (TaskStatus :: *) (TaskState :: *)
  (TaskDescriptorAbs :: *) (TaskSchedMemberAbs :: *)
  (program :: * => * => *)
 */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq Record TaskSchedMemberAbs { tsmStat: TaskStatus; } */
/*@ Extern Coq Record TaskDescriptorAbs { tdSchedMember: TaskSchedMemberAbs; tdDelay: Z; } */
/*@ Extern Coq Record TaskState { task_desc_map: addr -> option TaskDescriptorAbs; } */
/*@ Extern Coq Record VarGlobalState { os_tasks: TaskState; } */
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
  (tt : unit) (true : bool) (false : bool)
  (Build_IdNodeAbs : Z -> addr -> IdNodeAbs)
  (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
  (nil : {A} -> list A) (cons : {A} -> A -> list A -> list A)
  (app : {A} -> list A -> list A -> list A)
  (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idnode_insert_ready : addr -> Assertion)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion)
  (store_node_self_linked : addr -> Assertion)
  (store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion)
  (store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion)
  (sched_link_of : addr -> addr) (sched_link_node : addr -> DL_Node addr)
  (ALIGN_SIZE : Z) (addr_aligned : addr -> Z -> Prop)
  (TSK_SUSPEND : TaskStatus)
  (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop)
  (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop)
  (ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (semaphore_pending_nodes : addr -> VarGlobalState -> list(DL_Node addr) -> Prop)
  (wakeup_semaphore_head : addr -> addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (EventRaw : addr -> Assertion)
  (event_delete_guard : Z -> addr -> bool -> VarGlobalState -> Prop)
  (event_delete_gap : Z -> addr -> bool -> VarGlobalState -> VarGlobalState -> Prop)
  (event_pending_head : addr -> addr)
  (abs_find_event : Z -> program (VarGlobalState -> Prop) addr)
  (abs_event_resume_all : Z -> addr -> program (VarGlobalState -> Prop) unit)
  (abs_event_delete_at : Z -> addr -> program (VarGlobalState -> Prop) unit)
  (abs_event_delete : Z -> program (VarGlobalState -> Prop) unit)
  (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
#endif
