(** 仅检查 C 注解引用的接口类型；不复制函数契约、不证明 C 实现。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import KEventDeleteTrial.lib.KEventDelete.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Import IDNode DLL MonadErr.
Check (event_delete_guard : Z -> addr -> bool -> VarGlobalState -> Prop).
Check (event_delete_gap : Z -> addr -> bool -> VarGlobalState -> VarGlobalState -> Prop).
Check (event_pending_head : addr -> addr).
Check (abs_find_event : Z -> program (VarGlobalState -> Prop) addr).
Check (abs_event_resume_all : Z -> addr -> program (VarGlobalState -> Prop) unit).
Check (abs_event_delete_at : Z -> addr -> program (VarGlobalState -> Prop) unit).
Check (abs_event_delete : Z -> program (VarGlobalState -> Prop) unit).
Check (abs_ktask_assign : program (VarGlobalState -> Prop) unit).
Check (EventRaw : addr -> Assertion).
Check (EventRetired : addr -> Z -> Z -> Assertion).
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (@safeExec : forall Sigma A : Type,
  (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall Sigma A : Type, A -> program Sigma A).
Check (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop).
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager).
Check (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager).
Check (@store_dll : forall A : Type, (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion).
Check (store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion).
Check (store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion).
Check (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop).
Check (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop).
Check (ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (semaphore_pending_nodes : addr -> VarGlobalState -> list(DL_Node addr) -> Prop).
Check (wakeup_semaphore_head : addr -> addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
