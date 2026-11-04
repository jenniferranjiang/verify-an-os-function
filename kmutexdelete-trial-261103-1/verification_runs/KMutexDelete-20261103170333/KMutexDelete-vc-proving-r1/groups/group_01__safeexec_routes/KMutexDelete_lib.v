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

From Coq Require Import Lia.

(** 查询命中后沿已观察的普通加锁转移进入删除剩余程序。
    仅分解既有 weakestpre，不引入新的寿命假设或空间权限。 *)
Lemma mutex_delete_found_continuation__safeexec_routes : forall id before observed p key X,
  0 <= id -> key = unsigned_last_nbits id 16 ->
  mutex_delete_live p key observed -> Crtos_RTrans before observed ->
  safeExec (LastSeen before) (abs_mutex_delete id) X ->
  safeExec (LastSeen observed) (abs_mutex_delete_object p key) X.
Proof.
  intros id before observed p key X Hnonneg Hkey Hlive Hr Hexec.
  unfold abs_mutex_delete in Hexec at 1. prog_nf in Hexec.
  assert (Htest : (Z.ltb id 0) = false) by (apply Z.ltb_ge; lia).
  rewrite Htest in Hexec.
  destruct Hexec as [states [Hseen Hwp]].
  unfold safe in Hwp.
  pose proof (proj1 (MonadErrHoare.wp_bind (task_atomic_cmd (abs_mutex_delete_lookup_locked id))
    (fun found => match found with Some (p0,key0) => abs_mutex_delete_object p0 key0
      | None => ret tt end) X states) Hwp) as Hstep.
  exists (Crtos_RTrans observed). split.
  - unfold LastSeen. intros current. change (True <-> True). tauto.
  - unfold safe. destruct Hstep as [Herr Hnormal].
    apply (Hnormal (Some (p, key)) (Crtos_RTrans observed)).
    exists observed, observed. split.
    + apply (proj2 (Hseen observed)). exact Hr.
    + split.
      * split; [reflexivity|]. split; assumption.
      * intros current. change (True <-> True). tauto.
Qed.

(** 当前冻结协议的rely是全关系，故空Mutex观察允许查询未命中分支。
    用该实际正常执行取得void返回的continuation；不添加manager非空假设，
    也不将这一抽象性质解释成原C发生了空manager执行。 *)
Lemma mutex_delete_void_continuation__safeexec_routes : forall id before observed X,
  0 <= id -> safeExec (LastSeen before) (abs_mutex_delete id) X ->
  safeExec (LastSeen observed) (ret tt) X.
Proof.
  intros id before observed X Hnonneg Hexec.
  unfold abs_mutex_delete in Hexec at 1. prog_nf in Hexec.
  assert (Htest : (Z.ltb id 0) = false) by (apply Z.ltb_ge; lia).
  rewrite Htest in Hexec.
  destruct Hexec as [states [Hseen Hwp]]. unfold safe in Hwp.
  pose proof (proj1 (MonadErrHoare.wp_bind (task_atomic_cmd (abs_mutex_delete_lookup_locked id))
    (fun found => match found with Some (p0,key0) => abs_mutex_delete_object p0 key0
      | None => ret tt end) X states) Hwp) as Hstep.
  exists (Crtos_RTrans observed). split.
  - unfold LastSeen. intros current. change (True <-> True). tauto.
  - unfold safe. destruct Hstep as [Herr Hnormal].
    apply (Hnormal None (Crtos_RTrans observed)).
    exists (replace_mutexes nil observed), (replace_mutexes nil observed). split.
    + apply (proj2 (Hseen (replace_mutexes nil observed))). exact I.
    + split.
      * split; [reflexivity|]. intros m Hm. inversion Hm.
      * intros current. change (True <-> True). tauto.
Qed.
