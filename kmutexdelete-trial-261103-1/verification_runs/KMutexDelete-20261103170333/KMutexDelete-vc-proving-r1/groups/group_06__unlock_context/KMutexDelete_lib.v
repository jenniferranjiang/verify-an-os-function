From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** 查询借出 Mutex manager 后的精确剩余：其他模块由共享frame持有，
    Mutex管理链保留全部payload。它与manager相分离；不是新生命周期假设。 *)
Definition mutex_lookup_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ mutex_context sg.(os_mutex_stable) ” &&
  mutex_create_frame sg st **
  store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_mutex_stable).(mutex_list_head)
    (map mutex_link_node st.(os_mutexes)).
