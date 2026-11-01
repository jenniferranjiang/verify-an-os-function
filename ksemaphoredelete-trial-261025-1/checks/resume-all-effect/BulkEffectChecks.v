(* Focused model checks, not QCP or a C implementation proof. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Import CRTOS_Verify.lib.KSemaphoreDelete.
Import ListNotations DLL.
Local Open Scope Z_scope.
Local Open Scope string.

Check (semaphore_resume_all_effect :
  addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop).
Check (semaphore_resume_all_effect_steps_obligation : Prop).

(* Empty waiting must not clear another same-address ghost entry. *)
Definition empty_test_state (base : VarGlobalState) :=
  replace_semaphores
    [{| semaphore_addr := 100; semaphore_id := 1; semaphore_value := 0;
        semaphore_pending_addrs := [] |};
     {| semaphore_addr := 100; semaphore_id := 2; semaphore_value := 0;
        semaphore_pending_addrs := [11] |}] base.
Example empty_waiting_preserves_state : forall base,
  semaphore_resume_all_effect 100 [] (empty_test_state base) (empty_test_state base).
Proof. reflexivity. Qed.

(* Equal remaining timeslices must retain insertion order (strict < in RRR). *)
Definition equal_slice_desc (template : TaskDescriptorAbs) :=
  update_sched_member template (mkTaskSchedMemberAbs TSK_SUSPEND 0 0 10 5 1).
Definition equal_slice_tasks (template : TaskDescriptorAbs) :=
  fun task => if Z.eq_dec task 11 then Some (equal_slice_desc template)
              else if Z.eq_dec task 22 then Some (equal_slice_desc template)
              else None.
Definition ready_empty := mkOsAssignReadyVectorAbs [[]] 0 0.
Definition ready_first := mkOsAssignReadyVectorAbs [[ready_task_node 11]] 1 0.
Definition ready_both :=
  mkOsAssignReadyVectorAbs [[ready_task_node 11; ready_task_node 22]] 1 0.
Example equal_timeslices_preserve_waiting_order : forall template,
  resume_all_ready (equal_slice_tasks template) [11; 22] ready_empty ready_both.
Proof.
  intro template; unfold resume_all_ready; cbn [fold_left].
  exists ready_first, (equal_slice_desc template); split.
  - exists ready_empty, (equal_slice_desc template); split; [reflexivity|].
    split; [reflexivity|].
    exists [ready_task_node 11]; split; reflexivity.
  - split; [reflexivity|].
    exists [ready_task_node 11; ready_task_node 22]; split; reflexivity.
Qed.

(* Cancelling an active delay moves its payload; another inactive entry stays. *)
Example selected_delay_moves_to_inactive : forall desc,
  desc.(tdDelay) = 20 ->
  let info := mkTaskDelayAbs 11 77 TASK_DELAY_ACTIVE_VALUE in
  let other := mkTaskDelayAbs 22 88 TASK_DELAY_INACTIVE_VALUE in
  let delays :=
    {| delay_active_nodes := [Build_DL_Node info (&(20 # "Delay" ->ₛ "link"))];
       delay_inactive_map := fun p => if Z.eq_dec p 30 then Some other else None |} in
  let after := resume_all_delays (fun _ => Some desc) [11] delays in
  after.(delay_active_nodes) = [] /\
  after.(delay_inactive_map) 20 = Some (mkTaskDelayAbs 11 77 TASK_DELAY_INACTIVE_VALUE) /\
  after.(delay_inactive_map) 30 = Some other.
Proof.
  intros desc Hdelay; cbn zeta.
  unfold resume_all_delays; rewrite Hdelay.
  cbn -[Z.eqb]; rewrite Z.eqb_refl; repeat split; reflexivity.
Qed.
