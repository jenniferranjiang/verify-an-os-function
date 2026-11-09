From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete CRTOS_Verify.lib.IdModuleSpec.
From MonadLib.MonadErr Require Import MonadErrHoare.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** IsEmpty检查只借出当前事件的pending DLL；原样归还后恢复同一os_inv。
    wand是实际剩余资源的接口，其构造由which implies产生证明义务。 *)
Definition event_delete_pending_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p : addr) (waiting : list addr) : Assertion :=
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (event_pending_head p) (map event_wait_node waiting) -* os_inv sg st.

(** 删除前只读对象ID，归还同值后再把完整manager交给IdRemoveObj。 *)
Definition event_delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p id : Z) : Assertion :=
  (&(p # "Event" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 对象已经确认排空后的剩余抽象操作：最后一次受限环境加锁完成注销，
    按较早IsEmpty检查记录的resched决定是否调度。复用冻结的注销及调度语义。 *)
Definition event_delete_finish (id p : Z) (resched : bool)
    : program (VarGlobalState -> Prop) unit :=
  MonadErr.bind
    (event_delete_atomic_cmd id p true (abs_event_unpublish_locked id p))
    (fun _ => if resched then abs_ktask_assign else MonadErr.ret tt).

(** ResumeAll的后续continuation：其返回状态还须执行注销和调度；不把
    caller最终X直接当作ResumeAll的X而遗漏后面的真实效果。 *)
Definition event_delete_resume_cont (id p : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : unit -> (VarGlobalState -> Prop) -> Prop :=
  fun _ states => weakestpre (event_delete_finish id p true) X states.
