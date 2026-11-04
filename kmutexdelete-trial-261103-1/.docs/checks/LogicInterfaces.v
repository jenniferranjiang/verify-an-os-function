Require Import Coq.ZArith.ZArith Coq.Lists.List.
(** QCP logical vocabulary typecheck; no C parser or proof generation. *)
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Require Import CRTOS_Verify.lib.KMutexDelete.
From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
Import IDNode DLL.
Check (@Some : forall {A : Type}, A -> option A).
Check (@None : forall {A : Type}, option A).
Check (@tt : unit).
Check (@true : bool).
Check (@false : bool).
Check (@Build_IdNodeAbs : Z -> addr -> IdNodeAbs).
Check (@Build_DL_Node : forall {A : Type}, A -> addr -> DL_Node A).
Check (@store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (@store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idnode : addr -> IdNodeAbs -> Assertion).
Check (@idmanager_query : VarIdmanager -> Z -> bool).
Check (@idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager).
Check (@idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (@idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager).
Check (@store_dll : forall {A : Type}, (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion).
Check (@map : forall {A B : Type}, (A -> B) -> list A -> list B).
Check (@pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion).
Check (@semaphore_wait_node : addr -> DL_Node addr).
Check (@occupy_dll_node : addr -> Assertion).
Check (@store_node_self_linked : addr -> Assertion).
Check (@store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion).
Check (@store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion).
Check (@store_ready_dll_tail_view : addr -> list(DL_Node addr) -> addr -> Assertion).
Check (@dll_insert_anchor : forall {A : Type}, addr -> list(DL_Node A) -> addr -> Prop).
Check (@dll_insert_after_dispatch : forall {A : Type}, addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)).
Check (@dll_insert_before_dispatch : forall {A : Type}, addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)).
Check (@ALIGN_SIZE : Z).
Check (@addr_aligned : addr -> Z -> Prop).
Check (@KOK : Z).
Check (@KERROR : Z).
Check (@PRIORITY_MAX : Z).
Check (@TSK_SUSPEND : TaskStatus).
Check (@TSK_READY : TaskStatus).
Check (@decode_task_status : Z -> TaskStatus).
Check (@store_task_status : addr -> TaskStatus -> Assertion).
Check (@os_global_context : StableGlobalState -> Prop).
Check (@task_world_wf : VarGlobalState -> Prop).
Check (@task_fields : StableGlobalState -> VarGlobalState -> Assertion).
Check (@task_wakeup_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (@tasks_ready_with_exstatus : VarGlobalState -> list addr -> Z -> Prop).
Check (@delay_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (@assign_ready_pending : StableGlobalState -> VarGlobalState -> Assertion).
Check (@sched_link_of : addr -> addr).
Check (@ready_task_node : addr -> DL_Node addr).
Check (@task_addr_aligned : addr -> OsAssignReadyVectorAbs -> Prop).
Check (@assign_ready_vector_addr : StableGlobalState -> addr).
Check (@get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop).
Check (@set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs).
Check (@update_task_desc_map : addr -> TaskDescriptorAbs -> (addr -> option TaskDescriptorAbs) -> addr -> option TaskDescriptorAbs).
Check (@replace_task_desc_map : (addr -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState).
Check (@replace_global_ready_vector : OsAssignReadyVectorAbs -> VarGlobalState -> VarGlobalState).
Check (@os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node addr) -> OsAssignReadyVectorAbs).
Check (@rrr_bucket_insert : (addr -> option TaskDescriptorAbs) -> TaskSchedMemberAbs -> DL_Node addr -> list(DL_Node addr) -> list(DL_Node addr) -> Prop).
Check (@assign_policy_insert_ready_vector : OsAssignReadyVectorAbs -> TaskSchedMemberAbs -> list(DL_Node addr) -> OsAssignReadyVectorAbs).
Check (@assign_insert_step_ic : (addr -> option TaskDescriptorAbs) -> addr -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop).
Check (@ktask_unset_delay_step : addr -> VarGlobalState -> VarGlobalState -> Prop).
Check (@unset_linked_delay_step : addr -> TaskDelayAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (@In : forall {A : Type}, A -> list A -> Prop).
Check (@vDelayNull : vDelayView).
Check (@vDelayInactive : addr -> TaskDelayAbs -> vDelayView).
Check (@vDelayActive : addr -> TaskDelayAbs -> list(DL_Node TaskDelayAbs) -> list(DL_Node TaskDelayAbs) -> vDelayView).
Check (@store_ktask_unset_delay_pre : addr -> vDelayView -> Assertion).
Check (@store_ktask_unset_delay_post : addr -> vDelayView -> Assertion).
Check (@vSchedLinked : addr -> list(DL_Node addr) -> list(DL_Node addr) -> vSchedView).
Check (@vSchedDetached : vSchedView).
Check (@store_ktask_wakeup_sched_pre : (addr -> option TaskDescriptorAbs) -> addr -> vSchedView -> Assertion).
Check (@store_ktask_wakeup_source_post : (addr -> option TaskDescriptorAbs) -> vSchedView -> Assertion).
Check (@LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (@monadesafe_lib.safeExec : forall {Sigma A : Type}, (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall {Sigma A : Type}, A -> program Sigma A).
Check (@OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (@SemaphoreRaw : addr -> Assertion).
Check (@idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop).
Check (@sched_link_node : addr -> DL_Node addr).
Check (@ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (@ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop).
Check (@ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (@semaphore_pending_nodes : Z -> VarGlobalState -> list(DL_Node Z) -> Prop).
Check (@wakeup_semaphore_head : Z -> Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (@os_mutex_stable : StableGlobalState -> MutexStable).
Check (@os_mutexes : VarGlobalState -> MutexState).
Check (@mutex_manager_stable : MutexStable -> StableIdmanager).
Check (@mutex_manager : MutexState -> VarIdmanager).
Check (@MutexRaw : addr -> Assertion).
Check (@MutexRetired : MutexAbs -> Assertion).
Check (@mutex_pending_head : addr -> addr).
Check (@mutex_delete_live : addr -> Z -> VarGlobalState -> Prop).
Check (@mutex_delete_drained : addr -> Z -> VarGlobalState -> Prop).
Check (@mutex_pending_nodes : addr -> VarGlobalState -> list(DL_Node addr) -> Prop).
Check (@mutex_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop).
Check (@abs_mutex_resume_all : addr -> Z -> program (VarGlobalState -> Prop) unit).
Check (@abs_mutex_retire : addr -> Z -> program (VarGlobalState -> Prop) unit).
Check (@abs_mutex_delete_object : addr -> Z -> program (VarGlobalState -> Prop) unit).
Check (@abs_mutex_delete : Z -> program (VarGlobalState -> Prop) unit).
Check (eq_refl : KOK = 0%Z).
