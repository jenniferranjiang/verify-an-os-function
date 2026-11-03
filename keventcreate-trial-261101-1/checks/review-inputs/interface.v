(** 设计阶段接口类型检查；只检查 annotated_C 引用的类型，不证明 C。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import KEventTrial.lib.KEventCreate KEventTrial.lib.DoubleLinkListSpec.
Require Import KEventTrial.lib.KTaskWakeup.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import DLL IDNode MonadErr.
Check (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (abs_event_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z).
Check (addr_aligned : Z -> Z -> Prop).
Check (EventRaw : addr -> Assertion).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (store_idnode_insert_ready : addr -> Assertion).
Check (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
Check (idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager).
Check (CharArray.undef_full : Z -> Z -> Assertion).
Check (CharArray.full : Z -> Z -> list Z -> Assertion).
Check (@repeat_Z : forall A, A -> Z -> list A).
Check (store_node_self_linked : addr -> Assertion).
Check (@store_dll : forall A, (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion).
Check (occupy_dll_node : addr -> Assertion).
Check (@Build_DL_Node : forall A, A -> addr -> DL_Node A).
Check (@dll_insert_anchor : forall A, addr -> list (DL_Node A) -> addr -> Prop).
Check (@dll_insert_after_dispatch : forall A, addr -> list (DL_Node A) -> addr -> DL_Node A -> list (DL_Node A)).
Check (sched_link_of : addr -> addr).
Check (store_ready_dll_tail_view : addr -> list (DL_Node Z) -> addr -> Assertion).
Check (store_priority_ready_bucket : addr -> list (DL_Node Z) -> Assertion).
Check (@nil : forall A, list A).
Check (@cons : forall A, A -> list A -> list A).
Check (@app : forall A, list A -> list A -> list A).
Check (@map : forall A B, (A -> B) -> list A -> list B).
Check (os_event_stable : StableGlobalState -> EventStable).
Check (os_events : VarGlobalState -> EventState).
Check (event_manager_stable : EventStable -> StableIdmanager).
Check (event_manager : EventState -> VarIdmanager).
Check (event_created : Z -> Z -> Z -> EventAbs).
Check (event_publish : Z -> Z -> Z -> EventState -> EventState).
Check (event_link_node : EventAbs -> DL_Node EventAbs).
Check (store_event : (addr -> addr -> Assertion) -> addr -> EventAbs -> Assertion).
Check (replace_events : EventState -> VarGlobalState -> VarGlobalState).
Check (os_tasks : VarGlobalState -> TaskState).
Check (task_desc_map : TaskState -> addr -> option TaskDescriptorAbs).
Check (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion).
Check (@safeExec : forall S A, (S -> Prop) -> program S A -> (A -> S -> Prop) -> Prop).
Check (@MonadErr.ret : forall S A, A -> program S A).
Check (tt : unit).
