Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia Coq.Strings.String.
From SimpleC.SL Require Import CNotation.
Require Import CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.lib.CrtosGlobState CRTOS_Verify.lib.idnode_abs.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
(* A pending task's descriptor is completely arbitrary under candidate r1. *)
Definition review_state (desc : TaskDescriptorAbs) : CrtosOSState :=
 Build_CrtosOSState
   (Build_VarGlobalState (fun _ => VTS_NORMAL)
     (Build_VarIdmanager [0]
       ([Build_IdNodeAbs 0 (&(1000 # "TaskDescriptor" ->ₛ "id"))] :: repeat [] 15)) [1000]
     (fun p => if Z.eq_dec p 1000 then Some desc else None))
   (Build_SchedulerState 0 0 0 (repeat [] 32) 0 0)
   [Build_SemaphoreObject 2000 0 0 [1000]].
Lemma review_pending_accepts_arbitrary_descriptor : forall desc,
  CrtosOSValid (review_state desc).
Proof.
 intros desc. unfold CrtosOSValid, review_state, semaphore_valid; cbn.
 repeat split; try (repeat constructor; simpl; intuition lia).
 destruct H as [<- | H]; [exists desc; reflexivity | contradiction].
Qed.

(* The ordinary nested caller is compatible with actual counter updates. *)
Lemma review_nest_one_roundtrip : forall s,
 s.(os_scheduler).(scheduler_lock_nest)=1 ->
 semaphore_nest_decrement (semaphore_nest_increment s)=s.
Proof.
 intros [tasks [nest running priority ready bitmap highest] sems] H.
 cbn in H; subst nest; reflexivity.
Qed.

(* Arithmetic issue only: reachability of such a caller is not claimed. *)
Lemma review_max_nest_does_not_roundtrip : forall s,
 s.(os_scheduler).(scheduler_lock_nest)=65535 ->
 scheduler_lock_nest (os_scheduler (semaphore_nest_decrement (semaphore_nest_increment s)))=0.
Proof.
 intros [tasks [nest running priority ready bitmap highest] sems] H.
 cbn in H; subst nest; reflexivity.
Qed.
