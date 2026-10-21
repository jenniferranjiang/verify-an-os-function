Require Import Coq.ZArith.ZArith Coq.Strings.String Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSProtocolProof CRTOS_Verify.sem.CrtosOSInv.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Import Crtos_C_Rules.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

Lemma review_zero_unlock_view : forall sg s,
  s.(os_scheduler).(scheduler_lock_nest) = 0 ->
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> 0 ** SemaphoreCriticalFrame sg s |--
  SemaphoreOSInvariant sg s.
Proof.
  intros sg s Hzero.
  pose proof (SemaphoreOSInvariant_merge_decrement sg s) as H.
  rewrite Hzero in H; cbn in H.
  assert (Heq: semaphore_nest_decrement s = s).
  { destruct s as [tasks [nest running priority ready group highest] sems].
    cbn in Hzero; subst nest; reflexivity. }
  rewrite Heq in H; exact H.
Qed.

Lemma review_maximum_entry_write_view : forall sg s,
  s.(os_scheduler).(scheduler_lock_nest) = 65534 ->
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> 65535 ** SemaphoreCriticalFrame sg s |--
  SemaphoreOSInvariant sg (semaphore_nest_increment s).
Proof.
  intros sg s Hboundary.
  assert (Hbound: s.(os_scheduler).(scheduler_lock_nest) < 65535) by lia.
  pose proof (SemaphoreOSInvariant_merge_increment sg s Hbound) as H.
  rewrite Hboundary in H; exact H.
Qed.

Lemma review_maximum_internal_unlock_view : forall sg s,
  s.(os_scheduler).(scheduler_lock_nest) = 65535 ->
  “ CrtosOSValid s ” &&
  &("KTaskOsAssignLockNest") # UShort |-> 65534 ** SemaphoreCriticalFrame sg s |--
  SemaphoreOSInvariant sg (semaphore_nest_decrement s).
Proof.
  intros sg s Hboundary.
  pose proof (SemaphoreOSInvariant_merge_decrement sg s) as H.
  rewrite Hboundary in H; exact H.
Qed.

Print Assumptions CrtosIRQ_transition_disjoint_preserved.
Print Assumptions CrtosIRQ_transition_token_preserved.
Print Assumptions CrtosIRQ_closed_transition.
Print Assumptions review_zero_unlock_view.
Print Assumptions review_maximum_entry_write_view.
Print Assumptions review_maximum_internal_unlock_view.
