(** VRTOS 调用接口到信号量抽象程序的纯逻辑衔接。
    不证明被调用 C 实现，也不改变其规约或底层内存模型。
    Some 分支的归纳证明复用 crtosverify/VC/code_proof/id/IdInsertObj_lib.v
    的证明结构；None 分支补充双向刻画，并处理 idmax 为负的情形。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.DoubleLinkListSpec.

Import IDNode ListNotations.
Local Open Scope Z_scope.

Lemma first_free_from_none_iff :
  forall fuel start m,
    idmanager_first_free_id_from m fuel start = None <->
    forall id, start <= id < start + Z.of_nat fuel ->
      idmanager_query m id = true.
Proof.
  induction fuel; intros start m.
  - simpl. split; intros; try reflexivity; lia.
  - simpl idmanager_first_free_id_from.
    rewrite Nat2Z.inj_succ.
    destruct (idmanager_query m start) eqn:Hquery.
    + rewrite IHfuel. split; intros H id Hid.
      * destruct (Z.eq_dec id start) as [Heq | Hneq].
        -- subst id. exact Hquery.
        -- apply H. lia.
      * apply H. lia.
    + split.
      * discriminate.
      * intro H. specialize (H start ltac:(lia)). congruence.
Qed.

(** 即使 idmax < 0，两边也都表示空搜索区间；不增加接口前提。 *)
Lemma idmanager_first_free_id_none_iff_full :
  forall sidm idm,
    idmanager_first_free_id sidm idm = None <->
    idmanager_full sidm idm.
Proof.
  intros sidm idm.
  unfold idmanager_first_free_id, idmanager_full.
  rewrite first_free_from_none_iff.
  destruct (Z_le_gt_dec 0 sidm.(idmax)) as [Hnonneg | Hneg].
  - rewrite Z2Nat.id by exact Hnonneg.
    split; intros H id Hid; apply H; lia.
  - assert (Hnat : Z.to_nat sidm.(idmax) = O).
    { destruct sidm.(idmax); simpl; try reflexivity; lia. }
    rewrite Hnat. simpl. split; intros H id Hid; lia.
Qed.

Lemma first_free_from_some_min :
  forall fuel start m free,
    idmanager_first_free_id_from m fuel start = Some free ->
    start <= free < start + Z.of_nat fuel /\
    idmanager_query m free = false /\
    forall id, start <= id < free -> idmanager_query m id = true.
Proof.
  induction fuel; intros start m free Hsome.
  - simpl in Hsome. discriminate.
  - simpl in Hsome.
    destruct (idmanager_query m start) eqn:Hquery.
    + specialize (IHfuel (start + 1) m free Hsome)
        as [[Hlower Hupper] [Hfree Hbefore]].
      split; [rewrite Nat2Z.inj_succ; lia |].
      split; [exact Hfree |].
      intros id Hid.
      destruct (Z.eq_dec id start) as [Heq | Hneq].
      * subst id. exact Hquery.
      * apply Hbefore. lia.
    + inversion Hsome; subst free.
      split; [rewrite Nat2Z.inj_succ; lia |].
      split; [exact Hquery |].
      intros id Hid. lia.
Qed.

Lemma idmanager_first_free_id_some_min :
  forall sidm idm id,
    idmanager_first_free_id sidm idm = Some id ->
    idmanager_min_free_id sidm idm id.
Proof.
  intros sidm idm id Hfirst.
  unfold idmanager_first_free_id in Hfirst.
  pose proof (first_free_from_some_min (Z.to_nat sidm.(idmax))
    0 idm id Hfirst) as [[Hlower Hupper] [Hfree Hbefore]].
  unfold idmanager_min_free_id.
  split.
  - destruct (Z_le_gt_dec 0 sidm.(idmax)) as [Hnonneg | Hneg].
    + rewrite Z2Nat.id in Hupper by exact Hnonneg. lia.
    + assert (Hnat : Z.to_nat sidm.(idmax) = O).
      { destruct sidm.(idmax); simpl; try reflexivity; lia. }
      rewrite Hnat in Hupper. simpl in Hupper. lia.
  - split; [exact Hfree |].
    intros id' Hid'. apply Hbefore. exact Hid'.
Qed.

(** 本函数的插入点就是哨兵，通用 dispatch 退化为头插。 *)
Lemma dll_insert_after_dispatch_at_head :
  forall (A : Type) head (nodes : list (DL_Node A)) inserted,
    dll_insert_after_dispatch head nodes head inserted = inserted :: nodes.
Proof.
  intros A head nodes inserted.
  unfold dll_insert_after_dispatch.
  destruct (Z.eq_dec head head); [reflexivity | contradiction].
Qed.
