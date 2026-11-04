From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete CRTOS_Verify.lib.IdModuleSpec.
From MonadLib.MonadErr Require Import MonadErrHoare monadesafe_lib.
Import DLL IDNode MonadErr.
Local Open Scope string_scope.
Local Open Scope sac.

(** LinklistResumeAll返回后继续执行原helper第二段临界区；这只是bind的
    continuation，不加强函数规格或限制其余环境状态。 *)
Definition mutex_delete_after_resume (p id : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : unit -> (VarGlobalState -> Prop) -> Prop :=
  fun _ states => weakestpre (abs_mutex_retire p id) X states.

(** 读取即将注销对象的ID时只借出该字段；返回同一值即可恢复同一os_inv。
    wand为空间资源，不是可以复制的纯假设。 *)
Definition mutex_delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p id : Z) : Assertion :=
  (&(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 完整ID manager之外的精确frame：沿用已审阅非Mutex资源与Mutex管理DLL。
    管理DLL在ID摘除后仍然由本地持有，可继续完成管理节点摘除。 *)
Definition mutex_delete_manager_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ mutex_context sg.(os_mutex_stable) ” &&
  mutex_create_frame sg st **
  store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes)).
