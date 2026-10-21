Require Import Coq.ZArith.ZArith.
From SimpleC.SL Require Import Mem ConAssertion CriticalSTS.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import SetsClass.SetsClass.
Import SetsNotation.
Local Open Scope Z_scope.
Local Open Scope sets.

(** Regression for the former empty-intersection mask counterexample. *)
Lemma outside_distinct_masks_incompatible : forall sg0 sg1 st0 st1,
  derivable1
    (sepcon (OutsideCriticalIRQ 0 sg0 st0) (OutsideCriticalIRQ 1 sg1 st1))
    (coq_prop False).
Proof.
  intros sg0 sg1 st0 st1 m [m0 [m1 [Hjoin [H0 H1]]]].
  destruct (proj2_sig m) as [cs Hcs].
  destruct Hjoin as [_ [_ Hinter]].
  apply (proj1 (Hinter cs)) in Hcs. destruct Hcs as [HC0 HC1].
  destruct H0 as [_ [_ [_ [HS0 _]]]].
  destruct H1 as [_ [_ [_ [HS1 _]]]].
  apply (proj1 (HS0 cs)) in HC0. apply (proj1 (HS1 cs)) in HC1.
  destruct HC0 as [a [Ha _]], HC1 as [b [Hb _]].
  rewrite Ha in Hb. discriminate Hb.
Qed.

Lemma inside_outside_incompatible : forall mask sg0 sg1 st0 st1,
  derivable1
    (sepcon (InsideCritical sg0 st0) (OutsideCriticalIRQ mask sg1 st1))
    (coq_prop False).
Proof.
  intros mask sg0 sg1 st0 st1 m [m0 [m1 [Hjoin [H0 H1]]]].
  destruct (proj2_sig m) as [cs Hcs].
  destruct Hjoin as [_ [_ Hinter]].
  apply (proj1 (Hinter cs)) in Hcs. destruct Hcs as [HC0 HC1].
  destruct H0 as [_ [_ [HS0 _]]].
  destruct H1 as [_ [_ [_ [HS1 _]]]].
  apply (proj1 (HS0 cs)) in HC0. apply (proj1 (HS1 cs)) in HC1.
  destruct HC1 as [a [Ha _]].
  rewrite Ha in HC0. discriminate HC0.
Qed.

(** IRQ-off outside retains the same exclusive CPU token. *)
Lemma outside_masked_has_full_token : forall sg st m,
  OutsideCriticalIRQ 1 sg st m ->
  Sets.equiv (ConAssertion.s_token (raw m)) Sets.full.
Proof. intros sg st m [_ [_ [_ [_ Htoken]]]]. exact Htoken. Qed.

Lemma outside_masked_exact_state : forall sg st m cs,
  OutsideCriticalIRQ 1 sg st m -> ConAssertion.s_STS (raw m) cs ->
  cs = @outside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |}.
Proof.
  intros sg st m cs [_ [_ [_ [HS _]]]] HC.
  apply (proj1 (HS cs)) in HC. destruct HC as [current [Heq [Hbad|Heqst]]].
  - discriminate Hbad.
  - subst current. exact Heq.
Qed.

Lemma irq_enter_zero_exists : forall st,
  CrtosIRQTransition
    (@outside_state Crtos_CS {| irq_shared := st; irq_mask := 0 |}, Sets.empty)
    (@inside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |}, Sets.full).
Proof. intros; apply (IRQEnter st 0); auto. Qed.
Lemma irq_enter_one_exists : forall st,
  CrtosIRQTransition
    (@outside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |}, Sets.full)
    (@inside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |}, Sets.full).
Proof. intros; apply (IRQEnter st 1); auto. Qed.
Lemma irq_leave_zero_exists : forall anchor after,
  CrtosIRQTransition
    (@inside_state Crtos_CS {| irq_shared := anchor; irq_mask := 1 |}, Sets.full)
    (@outside_state Crtos_CS {| irq_shared := after; irq_mask := 0 |}, Sets.empty).
Proof. intros; apply (IRQLeave anchor after 0); auto. Qed.
Lemma irq_leave_one_exists : forall anchor after,
  CrtosIRQTransition
    (@inside_state Crtos_CS {| irq_shared := anchor; irq_mask := 1 |}, Sets.full)
    (@outside_state Crtos_CS {| irq_shared := after; irq_mask := 1 |}, Sets.full).
Proof. intros; apply (IRQLeave anchor after 1); auto. Qed.

Print Assumptions outside_distinct_masks_incompatible.
Print Assumptions inside_outside_incompatible.
Print Assumptions outside_masked_has_full_token.
Print Assumptions outside_masked_exact_state.
Print Assumptions irq_enter_zero_exists.
Print Assumptions irq_enter_one_exists.
Print Assumptions irq_leave_zero_exists.
Print Assumptions irq_leave_one_exists.
