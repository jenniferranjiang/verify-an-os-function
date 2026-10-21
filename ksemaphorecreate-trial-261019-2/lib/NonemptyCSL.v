Require Import Coq.Logic.ProofIrrelevance Coq.ZArith.ZArith.
From SimpleC.SL Require Import Mem ConAssertion CommonAssertion.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SetsClass.SetsClass.
Import SetsNotation.
Local Open Scope sets.

(** QCP 原 carrier 允许 s_STS 为空；与不相容 frame 求交会抹掉IRQ观察。
    这是全局 carrier 的最小限制：每个资源状态有至少一个可能的真实状态。
    heap/token 的原始 join 完全复用；结合律的中间交集由结果见证非空。 *)
Module Type NonemptyCSL (S : ConAssertion.STS_def) <: SeparationLogicSig.
  Module Base.
    Include S.
    Include ConAssertion.CSL.
  End Base.
  Definition inhabited (m : @ConAssertion.Lstate S.sts) : Prop :=
    exists cs, ConAssertion.s_STS m cs.
  Definition model := { m : @ConAssertion.Lstate S.sts | inhabited m }.
  Definition raw (m : model) := proj1_sig m.
  Definition expr := model -> Prop.
  Definition join (x y z : model) : Prop := Base.join (raw x) (raw y) (raw z).
  Definition is_unit (x : model) : Prop := Base.is_unit (raw x).
  Include DerivedNamesSig.

  Lemma unit_join : forall n : model, exists u : model, is_unit u /\ join n u n.
  Proof.
    intros [n Hn]. destruct (Base.unit_join n) as [u [Hu Hj]].
    assert (inhabited u) as Hnonempty.
    { destruct Hn as [cs Hcs]. exists cs.
      destruct Hu as [_ [_ Hall]]. apply (proj2 (Hall cs)); exact I. }
    exists (exist _ u Hnonempty). split; assumption.
  Qed.
  Lemma unit_spec : forall n m u : model, is_unit u -> join n u m -> n = m.
  Proof.
    intros [n Hn] [m Hm] [u Hu] Hunit Hjoin.
    assert (n = m) by (eapply Base.unit_spec; eauto).
    subst m. f_equal. apply proof_irrelevance.
  Qed.
  Lemma join_comm : forall x y z : model, join x y z -> join y x z.
  Proof. intros; apply Base.join_comm; assumption. Qed.
  Lemma join_assoc : forall x y z xy xyz : model,
    join x y xy -> join xy z xyz ->
    exists yz : model, join y z yz /\ join x yz xyz.
  Proof.
    intros x y z xy xyz Hxy Hxyz.
    destruct (Base.join_assoc _ _ _ _ _ Hxy Hxyz) as [yz [Hyz Hfinal]].
    assert (inhabited yz) as Hnonempty.
    { destruct (proj2_sig xyz) as [cs Hcs]. exists cs.
      destruct Hfinal as [_ [_ Hinter]].
      apply (proj1 (Hinter cs)) in Hcs. exact (proj2 Hcs). }
    exists (exist _ yz Hnonempty). split; assumption.
  Qed.
  Include LogicTheoremSig'.
  Arguments exp {A}.
  Definition mstore (p : addr) (v : Z) : expr := fun m => Base.mstore p v (raw m).
  Definition mstore_noninit (p : addr) : expr := fun m => Base.mstore_noninit p (raw m).
  Lemma mstore_mstore_noninit : forall p v m, mstore p v m -> mstore_noninit p m.
  Proof. intros; eapply Base.mstore_mstore_noninit; eauto. Qed.
  Lemma mstore_eqm : forall p v v', Byte.eqm v v' ->
    derivable1 (mstore p v) (mstore p v').
  Proof. intros p v v' H m Hm; eapply Base.mstore_eqm; eauto. Qed.
  Lemma dup_mstore_noninit : forall p,
    derivable1 (sepcon (mstore_noninit p) (mstore_noninit p)) (coq_prop False).
  Proof.
    intros p m [m1 [m2 [Hjoin [H1 H2]]]].
    apply (Base.dup_mstore_noninit p (raw m)).
    exists (raw m1), (raw m2); split; [exact Hjoin | split; assumption].
  Qed.
End NonemptyCSL.
