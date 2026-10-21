Require Import Coq.Lists.List Coq.micromega.Lia.
Require Import SetsClass.SetsClass SL.ConAssertion.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import SetsNotation.
Local Open Scope sets.

(** actor持有完整caller前缀时，actor与全局invariant精确分区全部token。
    这里保留集合外延等价，不能要求token谓词在语法上完全相同。 *)
Lemma CrtosIRQ_actor_partition : forall hs state held,
  held == CrtosPrefixTokens hs ->
  CrtosNestedState.handlers_of_NCS state = hs ->
  @ConAssertion.TokenSet_join Crtos_STS.sts held
    (ConAssertion.InvownedToken (STS:=Crtos_STS.sts) state) Sets.full.
Proof.
  intros hs state held Hheld Hstack.
  unfold ConAssertion.TokenSet_join.
  split; sets_unfold; intro n; specialize (Hheld n);
    change (held n <-> (n < List.length hs)%nat) in Hheld;
    cbn; rewrite Hstack;
    rewrite Hheld; lia.
Qed.

(** 每个IRQ步骤的前后都拥有同一完整token总量，只有前缀/后缀分工改变。 *)
Lemma CrtosIRQStep_partitions : forall source target before_tokens after_tokens,
  CrtosIRQStep (source, before_tokens) (target, after_tokens) ->
  @ConAssertion.TokenSet_join Crtos_STS.sts before_tokens
    (ConAssertion.InvownedToken (STS:=Crtos_STS.sts) source) Sets.full /\
  @ConAssertion.TokenSet_join Crtos_STS.sts after_tokens
    (ConAssertion.InvownedToken (STS:=Crtos_STS.sts) target) Sets.full.
Proof.
  intros source target before_tokens after_tokens Hstep.
  inversion Hstep; subst; split;
    (eapply CrtosIRQ_actor_partition; [eassumption|reflexivity]).
Qed.

(** QCP要求局部token始终与invariant所持token互斥。 *)
Theorem CrtosIRQ_transition_disjoint_preserved :
  @ConAssertion.transtion_disjoint_preserved Crtos_STS.sts CrtosIRQStep.
Proof.
  intros source target before_tokens after_tokens Hstep.
  destruct (CrtosIRQStep_partitions _ _ _ _ Hstep) as [[_ Hb] [_ Ha]].
  exact (conj Hb Ha).
Qed.

(** IRQ enter/exit不生成或销毁token总量；适用于任意外延等价的总集合。 *)
Theorem CrtosIRQ_transition_token_preserved :
  @ConAssertion.transition_token_preserved Crtos_STS.sts CrtosIRQStep.
Proof.
  intros source target before_tokens after_tokens total Hstep.
  destruct (CrtosIRQStep_partitions _ _ _ _ Hstep)
    as [[Hbefore Dbefore] [Hafter Dafter]].
  unfold ConAssertion.TokenSet_join.
  split; intros [Htotal _]; split; try assumption;
    sets_unfold in Hbefore; sets_unfold in Hafter;
    sets_unfold in Htotal; sets_unfold; intro n;
    specialize (Hbefore n); specialize (Hafter n); specialize (Htotal n); tauto.
Qed.

(** 与actor和invariant同时分离的额外token frame必为空，因此任意合法
    frame均可穿过IRQ步骤。并不丢弃caller外层token；它们本来就在actor前缀内。 *)
Theorem CrtosIRQ_closed_transition :
  @ConAssertion.Closed_transition Crtos_STS.sts CrtosIRQStep.
Proof.
  intros source target before_tokens after_tokens extra Hstep Dactor Dinv.
  destruct (CrtosIRQStep_partitions _ _ _ _ Hstep) as [[Htotal _] _].
  assert (Hextra : forall n, ~ extra n).
  { sets_unfold in Htotal; sets_unfold in Dactor; sets_unfold in Dinv.
    intro n; specialize (Htotal n); specialize (Dactor n); specialize (Dinv n).
    tauto. }
  assert (Hframe : forall tokens : nat -> Prop, tokens ∪ extra == tokens).
  { intro tokens; sets_unfold; intro n; specialize (Hextra n); tauto. }
  inversion Hstep; subst.
  - apply CrtosIRQEnter; [assumption| |];
      (etransitivity; [apply Hframe|eassumption]).
  - apply CrtosIRQExit; [assumption|assumption| |];
      (etransitivity; [apply Hframe|eassumption]).
Qed.
