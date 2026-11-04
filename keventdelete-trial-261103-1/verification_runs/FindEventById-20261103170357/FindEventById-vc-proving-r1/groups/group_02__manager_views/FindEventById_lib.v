From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

From Coq Require Import String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete CRTOS_Verify.lib.IdModuleSpec.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** 查询暂借事件ID manager时保留的其余资源：系统其余模块与完整事件
    管理链/payload。此view不拥有ID manager，也不增加新的前提或协议。 *)
Definition find_event_manager_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  event_create_frame sg st **
  store_dll (store_event (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_event_stable).(event_list_head)
    (map event_link_node st.(os_events)).
