Require Import OwnerAwareNestedProbe.

(** 本线程持有非空caller栈的全部prefix token时，环境不但不能执行一步，
    也不能通过任意有限步改变协议状态；因此nested IRQ entry不需要额外
    假设环境保持，而可由所有权排他性推出。 *)
Lemma owner_nested_environment_reachable_identity : forall hs state current,
  hs <> nil ->
  Relation_Operators.clos_refl_trans OwnerNestedState
    (owner_environment_step (owner_prefix hs))
    (CrtosProbeFramework.NestedCriticalAdapter.Build_nested_critical_state
      NestedCarrierProbe.ProbeNested_C_STS.nc_sts hs state) current ->
  current =
    CrtosProbeFramework.NestedCriticalAdapter.Build_nested_critical_state
      NestedCarrierProbe.ProbeNested_C_STS.nc_sts hs state.
Proof.
  intros hs state current Hnonempty Hreach.
  set (origin := CrtosProbeFramework.NestedCriticalAdapter.Build_nested_critical_state
      NestedCarrierProbe.ProbeNested_C_STS.nc_sts hs state) in *.
  assert (Hblocked : forall next,
    ~ owner_environment_step (owner_prefix hs) origin next).
  { intros next; apply owner_nested_excludes_environment; exact Hnonempty. }
  assert (Hidentity : forall x y,
    Relation_Operators.clos_refl_trans OwnerNestedState
      (owner_environment_step (owner_prefix hs)) x y ->
    x = origin -> y = origin).
  { intros x y Hsteps; induction Hsteps; intro Horigin.
    - subst x. exfalso. eapply Hblocked; exact H.
    - exact Horigin.
    - apply IHHsteps2. apply IHHsteps1. exact Horigin. }
  exact (Hidentity _ _ Hreach eq_refl).
Qed.

Print Assumptions owner_nested_environment_reachable_identity.
