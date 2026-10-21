Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSInv CRTOS_Verify.sem.SemaphoreCritical.
Import ListNotations Crtos_C_Rules.
Local Open Scope Z_scope.
Local Open Scope sac.

(** Empty caller stack cannot counterfeit a nonzero acquire-time count. *)
Lemma review_empty_origin_is_zero : forall sg handler before,
 SemaphoreInsideCritical sg [] handler before |--
 “ before.(os_scheduler).(scheduler_lock_nest) = 0 ”.
Proof.
 intros. unfold SemaphoreInsideCritical.
 Intros. entailer!. destruct H as [_ [_ Horigin]]. apply Horigin; reflexivity.
Qed.

(** Actual dataqueue outer lock can lend the unique heap/token to nested create. *)
Lemma review_dataqueue_borrow : forall sg parent_before,
 SemaphoreInsideCritical sg [] 0 parent_before **
 SemaphoreOSInvariant sg (semaphore_nest_increment parent_before) |--
 SemaphoreOutsideCritical sg [0] (semaphore_nest_increment parent_before).
Proof. intros; apply SemaphoreInsideCritical_borrow_for_nested_call. Qed.

(** A nested saved PRIMASK is one; the outer saved PRIMASK may be zero. *)
Lemma review_nested_handler_is_one : forall h,
 semaphore_irq_stack_ok [h;0] -> h=1.
Proof. intros h [_ [[H | H] _]]; [discriminate|exact H]. Qed.

(** Inner environment exclusion plus real heap count equality preserves the full state. *)
Lemma review_nested_rely_preserves_counter : forall before current,
 SemaphoreRely [0] before current -> current=before.
Proof. intros. eapply (SemaphoreRely_nested_identity [0]); [discriminate|exact H]. Qed.

(** The approved largest caller count reaches 65535 internally and returns to 65534. *)
Lemma review_approved_boundary : forall state,
 state.(os_scheduler).(scheduler_lock_nest)=65534 ->
 (semaphore_nest_increment state).(os_scheduler).(scheduler_lock_nest)=65535 /\
 semaphore_nest_decrement (semaphore_nest_increment state)=state.
Proof.
 intros [tasks [nest running priority ready group highest] sems] H.
 cbn in H; subst nest; split; reflexivity.
Qed.

(** The parent acquires its exact resources after nested create preserves scheduler. *)
Lemma review_dataqueue_return : forall sg parent_before after,
 parent_before.(os_scheduler).(scheduler_lock_nest)=0 ->
 SemaphoreGuarantee (semaphore_nest_increment parent_before) after ->
 SemaphoreOutsideCritical sg [0] after |--
 SemaphoreInsideCritical sg [] 0 (semaphore_nest_decrement after) **
 SemaphoreOSInvariant sg after.
Proof.
 intros sg before after Hzero Hguarantee.
 apply SemaphoreOutsideCritical_return_to_caller.
 eapply SemaphoreNestedCall_preserves_caller_origin; [|exact Hguarantee].
 intros _; exact Hzero.
Qed.

(** The approved domain does not accidentally reject the internal largest uint16 value. *)
Lemma review_increment_valid_inside : forall state,
 CrtosOSValid state -> state.(os_scheduler).(scheduler_lock_nest)<65535 ->
 CrtosOSValid (semaphore_nest_increment state).
Proof.
 intros state [Hsem [Htask [Hrange Hrest]]] Hbound.
 unfold CrtosOSValid, semaphore_nest_increment, os_with_scheduler, scheduler_with_nest; cbn.
 split; [exact Hsem|]. split; [exact Htask|]. split; [|exact Hrest].
 rewrite Z.mod_small by lia; lia.
Qed.
