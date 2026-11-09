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

(** 将一次具体查询观察提交到同一个 continuation；不需要额外堆权限，
    不改变环境关系，也不重新构造 bind 或增加规格前提。 *)
Lemma find_event_atomic_commit__atomic_commit : forall (id p : Z) before st X,
  0 <= id -> Crtos_RTrans before st -> event_lookup_result id p st ->
  safeExec (LastSeen before) (abs_find_event id) X ->
  safeExec (LastSeen st) (MonadErr.ret p) X.
Proof.
  intros id p before st X Hid Hstep Hlookup Hexec.
  unfold abs_find_event in Hexec at 1.
  prog_nf in Hexec.
  assert (Hnegative : Z.ltb id 0 = false) by (apply Z.ltb_ge; exact Hid).
  rewrite Hnegative in Hexec.
  unfold safeExec, safe in Hexec.
  destruct Hexec as [states [Hseen Hsafe]].
  unfold LastSeen in Hseen.
  unfold MonadErrHoare.weakestpre in Hsafe.
  cbn in Hsafe.
  destruct Hsafe as [Herror Hnormal].
  unfold safeExec.
  exists (Crtos_RTrans st).
  split.
  - unfold LastSeen. intro observed.
    change (Crtos_RTrans st observed <-> Crtos_RTrans st observed). tauto.
  - unfold safe, MonadErrHoare.weakestpre. cbn.
    split.
    + change (~ False). tauto.
    + intros result next [Hr Hnext]. subst result next.
      apply Hnormal.
      exists st, st. split.
      * apply (proj2 (Hseen st)). exact Hstep.
      * split.
        -- cbn. split; [reflexivity|exact Hlookup].
        -- intro observed.
    change (Crtos_RTrans st observed <-> Crtos_RTrans st observed). tauto.
Qed.
