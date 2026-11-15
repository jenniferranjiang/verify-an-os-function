#ifndef INITDATAQUEUE_SEMAPHORE_H
#define INITDATAQUEUE_SEMAPHORE_H
/* Existing C ABI directly reused; no copied unmodified project header. */
#include "../../../annotated_C/src/headers/m_semaphore.h"
/*@ Import Coq Require Import CRTOS_InitDataqueue.KSemaphoreCreate CRTOS_InitDataqueue.KSemaphoreDelete CRTOS_InitDataqueue.DoubleLinkListSpec */
/*@ Import Coq Import IDNode DLL */
/*@ Import Coq From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq addr := Z */
/*@ Extern Coq (DL_Node :: * => *) */
/*@ Extern Coq (option :: * => *) */
/*@ Extern Coq (unit :: *) */
/*@ Extern Coq (TaskStatus :: *) */
/*@ Extern Coq (StableGlobalState :: *) */
/*@ Extern Coq (VarGlobalState :: *) */
/*@ Extern Coq (TaskDescriptorAbs :: *) */
/*@ Extern Coq (TaskSchedMemberAbs :: *) */
/*@ Extern Coq (TaskDelayAbs :: *) */
/*@ Extern Coq (OsAssignReadyVectorAbs :: *) */
/*@ Extern Coq (vSchedView :: *) */
/*@ Extern Coq (vDelayView :: *) */
/*@ Extern Coq (StableIdmanager :: *) */
/*@ Extern Coq (VarIdmanager :: *) */
/*@ Extern Coq (IdNodeAbs :: *) */
/*@ Extern Coq (SemaphoreStable :: *) */
/*@ Extern Coq (SemaphoreAbs :: *) */
/*@ Extern Coq (program :: * => * => *) */
/*@ Extern Coq SemaphoreState := list SemaphoreAbs */
/*@ Extern Coq (TaskStable :: *) */
/*@ Extern Coq (TaskState :: *) */
/*@ Extern Coq (VarAssignAbs :: *) */
/*@ Extern Coq (DelayState :: *) */
/*@ Extern Coq (Some : {A} -> A -> option A) */
/*@ Extern Coq (None : {A} -> option A) */
/*@ Extern Coq (tt : unit) */
/*@ Extern Coq (true : bool) */
/*@ Extern Coq (false : bool) */
/*@ Extern Coq (Build_IdNodeAbs : Z -> addr -> IdNodeAbs) */
/*@ Extern Coq (Build_DL_Node : {A} -> A -> addr -> DL_Node A) */
/*@ Extern Coq (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion) */
/*@ Extern Coq (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion) */
/*@ Extern Coq (store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion) */
/*@ Extern Coq (store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion) */
/*@ Extern Coq (store_idnode : addr -> IdNodeAbs -> Assertion) */
/*@ Extern Coq (idmanager_query : VarIdmanager -> Z -> bool) */
/*@ Extern Coq (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager) */
/*@ Extern Coq (idmanager_add : VarIdmanager -> Z -> VarIdmanager) */
/*@ Extern Coq (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager) */
/*@ Extern Coq (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion) */
/*@ Extern Coq (map : {A} {B} -> (A -> B) -> list A -> list B) */
/*@ Extern Coq (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion) */
/*@ Extern Coq (semaphore_wait_node : addr -> DL_Node addr) */
/*@ Extern Coq (occupy_dll_node : addr -> Assertion) */
/*@ Extern Coq (store_node_self_linked : addr -> Assertion) */
/*@ Extern Coq (store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion) */
/*@ Extern Coq (store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion) */
/*@ Extern Coq (store_ready_dll_tail_view : addr -> list(DL_Node addr) -> addr -> Assertion) */
/*@ Extern Coq (dll_insert_anchor : {A} -> addr -> list(DL_Node A) -> addr -> Prop) */
/*@ Extern Coq (dll_insert_after_dispatch : {A} -> addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)) */
/*@ Extern Coq (dll_insert_before_dispatch : {A} -> addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)) */
/*@ Extern Coq (ALIGN_SIZE : Z) */
/*@ Extern Coq (addr_aligned : addr -> Z -> Prop) */
/*@ Extern Coq (KOK : Z) */
/*@ Extern Coq (KERROR : Z) */
/*@ Extern Coq (PRIORITY_MAX : Z) */
/*@ Extern Coq (TSK_SUSPEND : TaskStatus) */
/*@ Extern Coq (TSK_READY : TaskStatus) */
/*@ Extern Coq (decode_task_status : Z -> TaskStatus) */
/*@ Extern Coq (store_task_status : addr -> TaskStatus -> Assertion) */
/*@ Extern Coq (os_global_context : StableGlobalState -> Prop) */
/*@ Extern Coq (task_world_wf : VarGlobalState -> Prop) */
/*@ Extern Coq (task_fields : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (task_wakeup_inv : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (tasks_ready_with_exstatus : VarGlobalState -> list addr -> Z -> Prop) */
/*@ Extern Coq (delay_inv : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (assign_ready_pending : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (sched_link_of : addr -> addr) */
/*@ Extern Coq (ready_task_node : addr -> DL_Node addr) */
/*@ Extern Coq (task_addr_aligned : addr -> OsAssignReadyVectorAbs -> Prop) */
/*@ Extern Coq (assign_ready_vector_addr : StableGlobalState -> addr) */
/*@ Extern Coq (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop) */
/*@ Extern Coq (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs) */
/*@ Extern Coq (update_task_desc_map : addr -> TaskDescriptorAbs -> (addr -> option TaskDescriptorAbs) -> addr -> option TaskDescriptorAbs) */
/*@ Extern Coq (replace_task_desc_map : (addr -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState) */
/*@ Extern Coq (replace_global_ready_vector : OsAssignReadyVectorAbs -> VarGlobalState -> VarGlobalState) */
/*@ Extern Coq (os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node addr) -> OsAssignReadyVectorAbs) */
/*@ Extern Coq (rrr_bucket_insert : (addr -> option TaskDescriptorAbs) -> TaskSchedMemberAbs -> DL_Node addr -> list(DL_Node addr) -> list(DL_Node addr) -> Prop) */
/*@ Extern Coq (assign_policy_insert_ready_vector : OsAssignReadyVectorAbs -> TaskSchedMemberAbs -> list(DL_Node addr) -> OsAssignReadyVectorAbs) */
/*@ Extern Coq (assign_insert_step_ic : (addr -> option TaskDescriptorAbs) -> addr -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop) */
/*@ Extern Coq (ktask_unset_delay_step : addr -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (unset_linked_delay_step : addr -> TaskDelayAbs -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (In : {A} -> A -> list A -> Prop) */
/*@ Extern Coq (vDelayNull : vDelayView) */
/*@ Extern Coq (vDelayInactive : addr -> TaskDelayAbs -> vDelayView) */
/*@ Extern Coq (vDelayActive : addr -> TaskDelayAbs -> list(DL_Node TaskDelayAbs) -> list(DL_Node TaskDelayAbs) -> vDelayView) */
/*@ Extern Coq (store_ktask_unset_delay_pre : addr -> vDelayView -> Assertion) */
/*@ Extern Coq (store_ktask_unset_delay_post : addr -> vDelayView -> Assertion) */
/*@ Extern Coq (vSchedLinked : addr -> list(DL_Node addr) -> list(DL_Node addr) -> vSchedView) */
/*@ Extern Coq (vSchedDetached : vSchedView) */
/*@ Extern Coq (store_ktask_wakeup_sched_pre : (addr -> option TaskDescriptorAbs) -> addr -> vSchedView -> Assertion) */
/*@ Extern Coq (store_ktask_wakeup_source_post : (addr -> option TaskDescriptorAbs) -> vSchedView -> Assertion) */
/*@ Extern Coq (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop) */
/*@ Extern Coq (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop) */
/*@ Extern Coq (return : {Sigma} {A} -> A -> program Sigma A) */
/*@ Extern Coq (abs_semaphore_delete : StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit) */
/*@ Extern Coq (abs_ktask_assign : program (VarGlobalState -> Prop) unit) */
/*@ Extern Coq (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (os_inv : StableGlobalState -> VarGlobalState -> Assertion) */
/*@ Extern Coq (SemaphoreRaw : addr -> Assertion) */
/*@ Extern Coq (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop) */
/*@ Extern Coq (sched_link_node : addr -> DL_Node addr) */
/*@ Extern Coq (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop) */
/*@ Extern Coq (ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (semaphore_pending_nodes : Z -> VarGlobalState -> list(DL_Node Z) -> Prop) */
/*@ Extern Coq (wakeup_semaphore_head : Z -> Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (semaphore_pending_head : addr -> addr) */
/*@ Extern Coq (semaphore_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop) */
/*@ Extern Coq (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z) */
/*@ Extern Coq (store_idnode_insert_ready : addr -> Assertion) */
/*@ Extern Coq (store_idnode_unlinked : addr -> IdNodeAbs -> Assertion) */
/*@ Extern Coq (CharArray::undef_full : Z -> Z -> Assertion) */
/*@ Extern Coq (CharArray::full : Z -> Z -> list Z -> Assertion) */
/*@ Extern Coq (repeat_Z : {A} -> A -> Z -> list A) */
/*@ Extern Coq (abs_semaphore_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z) */
/*@ Extern Coq (CriticalNest : Z -> Assertion) */
/*@ Extern Coq (os_semaphores : VarGlobalState -> SemaphoreState) */
/*@ Extern Coq (os_semaphore_stable : StableGlobalState -> SemaphoreStable) */
/*@ Extern Coq (semaphore_manager_stable : SemaphoreStable -> StableIdmanager) */
/*@ Extern Coq (semaphore_manager : SemaphoreState -> VarIdmanager) */
/*@ Extern Coq (semaphore_first_link : SemaphoreStable -> SemaphoreState -> Z) */
/*@ Extern Coq (idbucket_first_link : StableIdmanager -> VarIdmanager -> Z -> Z) */
/*@ Extern Coq (semaphore_publish : Z -> Z -> Z -> SemaphoreState -> SemaphoreState) */
/*@ Extern Coq (replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState) */
/*@ Extern Coq (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion) */
/*@ Extern Coq (idmanager_full : StableIdmanager -> VarIdmanager -> Prop) */
/*@ Extern Coq (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop) */
/*@ Extern Coq (ZeroIdNode : Z -> Assertion) */
/*@ Extern Coq (AssignedIdNode : Z -> Z -> Assertion) */
/*@ Extern Coq (NodeStorage : Z -> Assertion) */
/*@ Extern Coq (DllInsertAfterCut : Z -> Z -> Z -> Z -> Z -> Assertion) */
/*@ Extern Coq (DllInsertedCut : Z -> Z -> Z -> Assertion) */
/*@ Extern Coq (SemaphoreZero : Z -> Assertion) */
/*@ Extern Coq
 (semaphore_create_ic_effect : StableGlobalState -> Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
 (semaphore_delete_quiescent : Z -> VarGlobalState -> Prop)
 (semaphore_unreferenced : Z -> VarGlobalState -> Prop)
 (semaphore_delete_ic_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
#endif
