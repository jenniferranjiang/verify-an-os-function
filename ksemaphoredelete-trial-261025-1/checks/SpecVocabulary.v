(* Standalone type checks for the QCP Extern declarations; this is not QCP parsing or a C proof. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import CRTOS_Verify.lib.KSemaphoreDelete CRTOS_Verify.lib.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Import IDNode DLL.
Local Open Scope Z_scope.
Check (eq_refl : addr = Z).
Check (@DL_Node : Type -> Type).
Check (@option : Type -> Type).
Check (@unit : Type).
Check (@TaskStatus : Type).
Check (@StableGlobalState : Type).
Check (@VarGlobalState : Type).
Check (@TaskDescriptorAbs : Type).
Check (@TaskSchedMemberAbs : Type).
Check (@TaskDelayAbs : Type).
Check (@OsAssignReadyVectorAbs : Type).
Check (@vSchedView : Type).
Check (@vDelayView : Type).
Check (@StableIdmanager : Type).
Check (@VarIdmanager : Type).
Check (@IdNodeAbs : Type).
Check (@SemaphoreStable : Type).
Check (@SemaphoreAbs : Type).
Check (@MonadErr.M : Type -> Type -> Type).
Check (eq_refl : SemaphoreState = list SemaphoreAbs).
Check (@idmax : StableIdmanager -> Z).
Check (@hoffset : StableIdmanager -> Z).
Check (@id_map : StableIdmanager -> Z).
Check (@htable : StableIdmanager -> Z).
Check (@tsmStat : TaskSchedMemberAbs -> TaskStatus).
Check (@tsmAdvanceCnt : TaskSchedMemberAbs -> Z).
Check (@tsmCurPrio : TaskSchedMemberAbs -> Z).
Check (@tsmOriginTimeslice : TaskSchedMemberAbs -> Z).
Check (@tsmRestTimeslice : TaskSchedMemberAbs -> Z).
Check (@tsmBitmapColumn : TaskSchedMemberAbs -> Z).
Check (@tdSchedMember : TaskDescriptorAbs -> TaskSchedMemberAbs).
Check (@tdDelay : TaskDescriptorAbs -> Z).
Check (@tdExstatus : TaskDescriptorAbs -> Z).
Check (@tdTaskPtr : TaskDelayAbs -> Z).
Check (@tdTicks : TaskDelayAbs -> Z).
Check (@tdStatus : TaskDelayAbs -> Z).
Check (@orvBuckets : OsAssignReadyVectorAbs -> list(list(DL_Node Z))).
Check (@orvReadyGroup : OsAssignReadyVectorAbs -> Z).
Check (@orvHighestPrio : OsAssignReadyVectorAbs -> Z).
Check (@TaskStable : Type).
Check (@TaskState : Type).
Check (@VarAssignAbs : Type).
Check (@DelayState : Type).
Check (@semaphore_addr : SemaphoreAbs -> addr).
Check (@semaphore_id : SemaphoreAbs -> Z).
Check (@semaphore_value : SemaphoreAbs -> Z).
Check (@semaphore_pending_addrs : SemaphoreAbs -> list addr).
Check (@task_stable_ids : TaskStable -> StableIdmanager).
Check (@task_idmanager_ptr : TaskStable -> Z).
Check (@task_desc_map : TaskState -> Z -> option TaskDescriptorAbs).
Check (@task_idmanager_abs : TaskState -> VarIdmanager).
Check (@assignReadyVector : VarAssignAbs -> OsAssignReadyVectorAbs).
Check (@os_task_stable : StableGlobalState -> TaskStable).
Check (@delay_head_ptr : StableGlobalState -> Z).
Check (@delay_inactive_map : DelayState -> Z -> option TaskDelayAbs).
Check (@delay_active_nodes : DelayState -> list(DL_Node TaskDelayAbs)).
Check (@os_tasks : VarGlobalState -> TaskState).
Check (@os_assign : VarGlobalState -> VarAssignAbs).
Check (@os_delays : VarGlobalState -> DelayState).
Check (@os_semaphores : VarGlobalState -> SemaphoreState).
Check (@Some : forall A : Type, A -> option A).
Check (@None : forall A : Type, option A).
Check (@tt : unit).
Check (@true : bool).
Check (@false : bool).
Check (@Build_IdNodeAbs : Z -> addr -> IdNodeAbs).
Check (@Build_DL_Node : forall A : Type, A -> addr -> DL_Node A).
Check (@store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (@store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (@store_idnode : addr -> IdNodeAbs -> Assertion).
Check (@idmanager_query : VarIdmanager -> Z -> bool).
Check (@idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager).
Check (@idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (@idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager).
Check (@store_dll : forall A : Type, (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion).
Check (@occupy_dll_node : addr -> Assertion).
Check (@store_node_self_linked : addr -> Assertion).
Check (@store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion).
Check (@store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion).
Check (@store_ready_dll_tail_view : addr -> list(DL_Node addr) -> addr -> Assertion).
Check (@dll_insert_anchor : forall A : Type, addr -> list(DL_Node A) -> addr -> Prop).
Check (@dll_insert_after_dispatch : forall A : Type, addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)).
Check (@dll_insert_before_dispatch : forall A : Type, addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A)).
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
Check (@In : forall A : Type, A -> list A -> Prop).
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
Check (@monadesafe_lib.safeExec : forall Sigma A : Type, (Sigma -> Prop) -> MonadErr.M Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall Sigma A : Type, A -> MonadErr.M Sigma A).
Check (@abs_semaphore_delete : StableGlobalState -> Z -> MonadErr.M (VarGlobalState -> Prop) unit).
Check (@abs_ktask_assign : MonadErr.M (VarGlobalState -> Prop) unit).
Check (@OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (@Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (@os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (@SemaphoreRaw : addr -> Assertion).
Check (@semaphore_pending_head : addr -> addr).
Check (@semaphore_resume_all_steps : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop).
