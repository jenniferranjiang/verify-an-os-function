From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Local Open Scope sac.

(** Proof-side reduction of the QCP branch; both normal and error semantics
    are preserved by the existing program equivalence rules. *)
Local Lemma obtain_if_bool {S A} (b : bool) (c1 c2 : program S A) :
  ProgramPO.equiv (IF (b = true) c1 c2) (if b then c1 else c2).
Proof.
  destruct b; [apply if_pure_cond_true; reflexivity |
               apply if_pure_cond_false; discriminate].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1 : _SemaphoreObtain_entail_wit_1_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  change (retval < 2147483647). lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  unfold semaphore_wait_ticks. destruct (Z.eq_dec msec_pre 0); [lia |].
  destruct (Z.eq_dec msec_pre (-1)); lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1 : _SemaphoreObtain_entail_wit_3_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
exfalso. exact (addr_of_LE_var_not_zero "k_sem_id_manager" PreH2).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
unfold abs_semaphore_obtain in PreH15 at 1. rewrite obtain_if_bool in PreH15. prog_nf in PreH15.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH15.
destruct PreH15 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans held) (inl (-1))) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl (-1)) (Crtos_RTrans held)).
{ exists held, held. split; [apply (proj2 (Hstates held)); exact PreH14|]. split; [|reflexivity].
  left. split; [|auto]. intros sm Hin Heq.
  unfold idmanager_query, semaphore_manager in PreH4. cbn in PreH4.
  apply id_in_ids_false_iff in PreH4. apply PreH4. rewrite <- Heq. apply in_map. exact Hin. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans held). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hfind : forall sm st manager ret id,
    0 < sm.(hoffset) ->
    store_idmanager_found sm (semaphore_manager st) manager ret id |--
    “ exists original, In original st /\ semaphore_id original = id /\
      ret = &(((semaphore_addr original)) # "Semaphore" ->ₛ "id") ”).
  { intros sm st manager ret id Hpos.
    unfold store_idmanager_found. Intros bytes prefix suffix bucket.
    dump_pre_spatial.
    destruct H as [Hrange [Hmap [Hb [Hbucket Hsplit]]]].
    assert (Hbin : In bucket (idbuckets (semaphore_manager st))).
    { rewrite Hbucket. apply Znth_In_Zlength.
      destruct Hb as [_ [Hlen _]]. rewrite Hlen.
      apply Z.mod_pos_bound; assumption. }
    assert (Hnode : In (Build_IdNodeAbs id ret) bucket).
    { rewrite Hsplit. apply in_or_app. right. left. reflexivity. }
    cbn [semaphore_manager idbuckets] in Hbin.
    apply in_map_iff in Hbin. destruct Hbin as [i [Heq Hi]].
    rewrite <- Heq in Hnode. apply in_map_iff in Hnode.
    destruct Hnode as [original [Hnode Hmem]].
    apply filter_In in Hmem. destruct Hmem as [Hmem _].
    exists original. split; [assumption|].
    split.
    - exact (f_equal idnode_id Hnode).
    - symmetry. exact (f_equal idnode_addr Hnode). }

  assert (Hbounds : forall wait st x px y py original,
    In original st ->
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node st) |--
    “ semaphore_addr original <> 0 /\ 0 <= semaphore_value original <= 65535 ”).
  { intros wait st. induction st as [|a st IH]; intros x px y py original Hin.
    - contradiction.
    - cbn [map]. unfold dllseg at 1. fold (@dllseg SemaphoreAbs).
      cbn [semaphore_link_node getPtr getData]. Intros z.
      destruct Hin as [Heq|Hin].
      + subst original. unfold store_semaphore. Intros.
        prop_apply_p (store_ushort_range (&(((semaphore_addr a)) # "Semaphore" ->ₛ "value")) (semaphore_value a)).
        Intros. dump_pre_spatial. tauto.
      + prop_apply_p (IH z x y py original Hin). Intros. dump_pre_spatial. assumption. }
  assert (Hobounds : forall sg st original, In original (os_semaphores st) ->
    os_inv sg st |-- “ semaphore_addr original <> 0 /\ 0 <= semaphore_value original <= 65535 ”).
  { intros sg st original Hin. unfold os_inv, semaphore_inv. Intros.
    unfold store_dll. Intros h pt.
    prop_apply_p (Hbounds (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (os_semaphores st) h (semaphore_list_head (os_semaphore_stable sg))
      (semaphore_list_head (os_semaphore_stable sg)) pt original Hin).
    Intros. dump_pre_spatial. assumption. }
  assert (Hctx : forall sg st, InsideCritical sg st |--
    “ 0 < hoffset (semaphore_manager_stable (os_semaphore_stable sg)) ”).
  { intros sg st. unfold InsideCritical. Intros. dump_pre_spatial.
    unfold os_global_context, semaphore_context in *. intuition lia. }
  prop_apply_p (Hctx sg_semaphore_obtain_oc held). Intros_p Hpos.
  prop_apply_p (Hfind (semaphore_manager_stable (os_semaphore_stable sg_semaphore_obtain_oc))
    (os_semaphores held) &("k_sem_id_manager") retval id_pre Hpos).
  Intros.
  match goal with Hx : exists _, _ |- _ => destruct Hx as [original [Hin [Hid Haddr]]] end.
  sep_apply_l_atomic (store_idmanager_found_store_idmanager
    (semaphore_manager_stable (os_semaphore_stable sg_semaphore_obtain_oc))
    (semaphore_manager (os_semaphores held)) &("k_sem_id_manager") retval id_pre).
  sep_apply_l_atomic (derivable1_wand_elim2
    (store_idmanager (semaphore_manager_stable (os_semaphore_stable sg_semaphore_obtain_oc))
      (semaphore_manager (os_semaphores held)) &("k_sem_id_manager"))
    (os_inv sg_semaphore_obtain_oc held)).
  prop_apply_p (Hobounds sg_semaphore_obtain_oc held original Hin). Intros.
  Exists original. split_pure_spatial; [cancel | split_pures; dump_pre_spatial; tauto].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_1 : _SemaphoreObtain_entail_wit_5_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH3. dump_pre_spatial.
unfold abs_semaphore_obtain in PreH22 at 1. rewrite obtain_if_bool in PreH22. prog_nf in PreH22.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH22.
destruct PreH22 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held)) (inl 0)) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl 0) (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held))).
{ exists held, (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held).
  split; [apply (proj2 (Hstates held)); exact PreH21|]. split; [|reflexivity].
  right. exists original. split; [exact PreH15|]. split; [exact PreH16|]. left. repeat split; auto. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held)). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_5_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold abs_semaphore_obtain in PreH23 at 1. rewrite obtain_if_bool in PreH23. prog_nf in PreH23.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH23.
destruct PreH23 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans held) (inl (-2))) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl (-2)) (Crtos_RTrans held)).
{ exists held, held. split; [apply (proj2 (Hstates held)); exact PreH22|]. split; [|reflexivity].
  right. exists original. repeat split; auto. right. split; [exact PreH3|]. left. repeat split; auto; lia. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans held). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_6_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hvalid : orb (semaphore_id_invalid id_pre)
      (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
  { unfold semaphore_id_invalid.
    repeat match goal with |- context [Z.ltb ?x ?y] => destruct (Z.ltb_spec x y) end;
    repeat match goal with |- context [Z.eqb ?x ?y] => destruct (Z.eqb_spec x y) end;
    simpl; try lia; reflexivity. }
  assert (Hentry : semaphore_obtain_entry sg_semaphore_obtain_oc id_pre
      (semaphore_wait_ticks msec_pre) (Crtos_RTrans before_semaphore_obtain_oc)).
  { destruct PreH24 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_semaphore_obtain in Hsafe.
    change (weakestpre (abs_semaphore_obtain sg_semaphore_obtain_oc id_pre msec_pre)
      X_semaphore_obtain_oc states) in Hsafe.
    unfold abs_semaphore_obtain in Hsafe.
    rewrite obtain_if_bool in Hsafe.
    rewrite Hvalid in Hsafe.
    apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
    apply (proj1 (wp_assertS _ _ states)) in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold semaphore_obtain_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry held PreH23) as Hguard.
  prop_apply_p Hguard. Intros_p Hg.
  specialize (Hg original PreH17 PreH18 PreH4).
  assert (Hnz : semaphore_wait_ticks msec_pre <> 0) by lia.
  specialize (Hg Hnz). destruct Hg as [Ha Hfuture].
  split_pure_spatial; [repeat progress cancel |].
  split_pures; dump_pre_spatial; try assumption.
  rewrite PreH10. exact Hfuture.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hmapnew : forall (T : Z -> option TaskDescriptorAbs) p d  q e,
    T p = Some d -> T q = Some e ->
    exists e', update_task_desc_map p (set_task_desc_exstatus d 0) T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d  q e Hp Hq.
    unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne].
    - rewrite Hp in Hq. inversion Hq; subst e.
      exists (set_task_desc_exstatus d 0); simpl; tauto.
    - exists e; tauto. }
  assert (Hmapold : forall (T : Z -> option TaskDescriptorAbs) p d  q e,
    T p = Some d ->
    update_task_desc_map p (set_task_desc_exstatus d 0) T q = Some e ->
    exists e', T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d  q e Hp Hq.
    unfold update_task_desc_map in Hq. destruct (Z.eq_dec q p) as [->|Hne].
    - inversion Hq; subst e. exists d; simpl; tauto.
    - exists e; tauto. }
  assert (Htaskwf : forall st p d  ,
    st.(os_tasks).(task_desc_map) p = Some d -> task_world_wf st ->
    task_world_wf (semaphore_clear_status p d st)).
  { intros st p d   Hlookup Hwf.
    unfold semaphore_clear_status, replace_task_desc_map; cbn.
    constructor; cbn.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_map_present; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      eapply task_wf_init_running_owned; eauto. rewrite Hs'; exact Hs.
    - exact (task_wf_id_nodes _ Hwf).
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' Hb']]].
      pose proof (task_wf_priority _ Hwf q e' He'). rewrite Hs', Hb' in H; exact H.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_aligned; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_running_bitmap; eauto. rewrite Hs'; exact Hs.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_init_close_bitmap; eauto. rewrite Hs'; exact Hs.
  }
  assert (Hassignwf : forall T p d  a,
    T p = Some d -> assign_world_wf T a ->
    assign_world_wf (update_task_desc_map p (set_task_desc_exstatus d 0) T) a).
  { intros T p d  a Hlookup Hwf.
    destruct Hwf as [Hrun Hready]. constructor.
    - destruct Hrun as [Hrun | [e He]]; [left; exact Hrun|right].
      destruct (Hmapnew T p d  _ _ Hlookup He) as [e' [He' _]]. eauto.
    - unfold os_assign_ready_vector_ok in *.
      destruct Hready as [Hb [Hg Hh]]. split; [|tauto].
      unfold priority_ready_buckets_ok in *.
      assert (Hbs : forall bs index,
        priority_ready_buckets_task_ok T index bs ->
        priority_ready_buckets_task_ok (update_task_desc_map p (set_task_desc_exstatus d 0) T) index bs).
      { intro bs; induction bs as [|bucket rest IH]; intros index Hbs; simpl in *; auto.
        destruct Hbs as [Hbucket Hr]. split.
        - rewrite Forall_forall in *. intros n Hn. specialize (Hbucket n Hn).
          unfold ready_node_at_priority_ok, ready_node_task_desc in *.
          destruct Hbucket as [e [[Hnz [Hptr He]] [Hp [Hm Hst]]]].
          destruct (Hmapnew T p d  _ _ Hlookup He) as [e' [He' [Hs' _]]].
          exists e'; rewrite Hs'; repeat split; auto.
        - apply IH; exact Hr. }
      apply Hbs; exact Hb.
  }
  assert (Hworld : forall sg st p d,
    st.(os_tasks).(task_desc_map) p = Some d -> os_world_wf sg st ->
    os_world_wf sg (semaphore_clear_status p d st)).
  { intros sg st p d Hlookup Hwf.
    assert (Hs : forall entry slot, service_slot_wf st entry slot ->
      service_slot_wf (semaphore_clear_status p d st) entry slot).
    { intros entry slot Hs. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| | q]; auto.
      destruct Hs as [e [He Hentry Hdelay Hown Hid]].
      destruct (Z.eq_dec q p) as [->|Hne].
      - rewrite Hlookup in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0). constructor; simpl; try assumption.
        unfold semaphore_clear_status, replace_task_desc_map; simpl.
        unfold update_task_desc_map. destruct (Z.eq_dec p p); congruence.
      - exists e. constructor; try assumption.
        unfold semaphore_clear_status, replace_task_desc_map; simpl.
        unfold update_task_desc_map. destruct (Z.eq_dec q p); congruence. }
    constructor.
    - exact (os_wf_context _ _ Hwf).
    - apply Hs. exact (os_wf_recycler _ _ Hwf).
    - change (Forall (service_slot_wf (semaphore_clear_status p d st)
        (os_idle_entry sg)) (os_idle st)).
      rewrite Forall_forall. intros sl Hsl. apply Hs.
      pose proof (os_wf_idle _ _ Hwf) as Hi. rewrite Forall_forall in Hi; auto.
    - exact (os_wf_sched_nodup _ _ Hwf).
    - intro q. change (In q (os_sched_owners st) <->
        update_task_desc_map p (set_task_desc_exstatus d 0)
          (task_desc_map (os_tasks st)) q <> None).
      rewrite (os_wf_sched_domain _ _ Hwf q).
      unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne]; [rewrite Hlookup|];
        split; intros; discriminate || assumption.
  }
  assert (Hdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) ->
    forall nodes x px y py, dllseg P x px y py nodes |-- dllseg Q x px y py nodes).
  { intros A P Q HP nodes; induction nodes as [|a rest IH]; intros x px y py.
    - cbn [dllseg]; Intros. split_pure_spatial; [cancel|split_pures; dump_pre_spatial; tauto].
    - cbn [dllseg]. fold (@dllseg A P) (@dllseg A Q). Intros z.
      Exists z. split_pure_spatial.
      + sep_apply_l_atomic (HP x (getData a)).
        sep_apply_l_atomic (IH z x y py). cancel.
        change (dllseg Q z x y py rest |-- dllseg Q z x y py rest). cancel.
      + split_pures; dump_pre_spatial; auto.
  }
  assert (Hsdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) -> forall head nodes,
    store_dll P head nodes |-- store_dll Q head nodes).
  { intros A P Q HP head nodes. unfold store_dll. Intros h pt. Exists h pt.
    split_pure_spatial.
    - sep_apply_l_atomic (Hdllmono A P Q HP nodes h head head pt). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hpub : forall T p d  status l q,
    T p = Some d ->
    pure_published_slink T status l q |--
    pure_published_slink (update_task_desc_map p (set_task_desc_exstatus d 0) T) status l q).
  { intros T p d  status l q Hl. unfold pure_published_slink. Intros e.
    assert (He : T q = Some e) by tauto.
    destruct (Hmapnew T p d  q e Hl He) as [e' [He' [Hsch _]]].
    Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto.
  }
  assert (Howned : forall T p d  tasks,
    T p = Some d ->
    store_owned_sched_nodes T tasks |--
    store_owned_sched_nodes (update_task_desc_map p (set_task_desc_exstatus d 0) T) tasks).
  { intros T p d  tasks Hl.
    assert (Hdet : forall q, store_detached_sched_link T q |--
      store_detached_sched_link (update_task_desc_map p (set_task_desc_exstatus d 0) T) q).
    { intro q. unfold store_detached_sched_link. Intros e.
      assert (He : T q = Some e) by tauto.
      destruct (Hmapnew T p d  q e Hl He) as [e' [He' [Hsch _]]].
      Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto. }
    unfold store_owned_sched_nodes.
    induction tasks as [|q tasks IH]; cbn [map]; [cancel|].
    rewrite !logic_equiv_iter_sepcon_cons.
    sep_apply_l_atomic (Hdet q). sep_apply_l_atomic IH. cancel.
  }
  assert (Hsemmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst sems,
    semaphore_inv P sst sems |-- semaphore_inv Q sst sems).
  { intros P Q HP sst sems.
    assert (Hpay : forall l v, store_semaphore P l v |-- store_semaphore Q l v).
    { intros l v. pose (p := semaphore_addr v). unfold store_semaphore. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Semaphore" ->ₛ "pend_list"))
          (map semaphore_wait_node (semaphore_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v)) |-- store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold semaphore_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono SemaphoreAbs (store_semaphore P) (store_semaphore Q)
        Hpay (semaphore_list_head sst) (map semaphore_link_node sems)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hmutexmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    mutex_inv P sst vals |-- mutex_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_mutex P l v |-- store_mutex Q l v).
    { intros l v. pose (p := mutex_addr v). unfold store_mutex. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Mutex" ->ₛ "pend_list"))
          (map mutex_wait_node (mutex_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v)) |-- store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold mutex_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono MutexAbs (store_mutex P) (store_mutex Q)
        Hpay (mutex_list_head sst) (map mutex_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Heventmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    event_inv P sst vals |-- event_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_event P l v |-- store_event Q l v).
    { intros l v. pose (p := event_addr v). unfold store_event. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Event" ->ₛ "pend_list"))
          (map event_wait_node (event_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v)) |-- store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold event_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono EventAbs (store_event P) (store_event Q)
        Hpay (event_list_head sst) (map event_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hzombie : forall T p d  head vals,
    T p = Some d ->
    store_zombie_queue T head vals |--
    store_zombie_queue (update_task_desc_map p (set_task_desc_exstatus d 0) T) head vals).
  { intros T p d  head vals Hl. destruct vals; cbn [store_zombie_queue]; [cancel|].
    apply Hsdllmono. intros l q. apply Hpub; exact Hl.
  }
  assert (Hassign : forall sg st p d  ,
    st.(os_tasks).(task_desc_map) p = Some d ->
    assign_inv sg st |-- assign_inv sg (semaphore_clear_status p d st)).
  { intros sg st p d   Hl.
    unfold assign_inv, semaphore_clear_status, replace_task_desc_map; cbn.
    Intros. split_pure_spatial; [cancel|].
    split_pures; dump_pre_spatial; apply Hassignwf; assumption.
  }

  assert (Hdelay : forall sg st p d,
    task_desc_map (os_tasks st) p = Some d ->
    delay_inv sg st |-- delay_inv sg (semaphore_clear_status p d st)).
  { intros sg st p d Hl. unfold delay_inv. Intros_p Hw.
    split_pure_spatial; [unfold semaphore_clear_status, replace_task_desc_map; cbn; cancel|]. split_pures; dump_pre_spatial.
    change (delay_world_wf (update_task_desc_map p (set_task_desc_exstatus d 0)
      (task_desc_map (os_tasks st))) (delay_inactive_map (os_delays st))
      (delay_active_nodes (os_delays st))).
    destruct Hw as [Hz Hi Ha Hsorted Hstatus]. constructor; auto.
    - intros q e He. unfold update_task_desc_map in He.
      destruct (Z.eq_dec q p) as [->|Hne].
      + inversion He; subst e. exact (Hz p d Hl).
      + exact (Hz q e He).
    - intros a info Hinfo. destruct (Hi a info Hinfo) as [e [He Hd]].
      unfold update_task_desc_map.
      destruct (Z.eq_dec (tdTaskPtr info) p) as [Hq|Hq].
      + rewrite Hq, Hl in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0); simpl; tauto.
      + exists e; tauto.
    - intros node Hnode. destruct (Ha node Hnode) as [e [He Hp]].
      unfold update_task_desc_map.
      destruct (Z.eq_dec (tdTaskPtr (getData node)) p) as [Hq|Hq].
      + rewrite Hq, Hl in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0); simpl; tauto.
      + exists e; tauto.
  }
 set (Drest := fun (p : addr) (d : TaskDescriptorAbs) =>
    “ aligned_reglen d.(tdStackPoint) /\
      d.(tdBaseInfo).(tbStackStart) <= d.(tdStackPoint) /\
      d.(tdStackPoint) + sizeof("StackRegisterContext") <= kss_aligned_top d.(tdBaseInfo) /\
      addr_aligned p ALIGN_SIZE ” &&
    store_task_sched_member (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) d.(tdSchedMember) **
    &(p # "TaskDescriptor" ->ₛ "stack_point") # Ptr |-> d.(tdStackPoint) **
    store_task_base_info p d.(tdBaseInfo) **
    &(p # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt |-> d.(tdEventIdTrigger) **
    &(p # "TaskDescriptor" ->ₛ "event_mode") # UInt |-> d.(tdEventMode) **
    &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> d.(tdDelay) **
    &(p # "TaskDescriptor" ->ₛ "Done") # Ptr |-> d.(tdDone) **
    store_task_descriptor_padding p **
    store_ktask_stack d.(tdBaseInfo).(tbStackStart) d.(tdBaseInfo).(tbStackDepth) d.(tdStackRaw) d.(tdStackContext)).
  assert (Hdescsplit : forall p d, store_published_task p d |--
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> d.(tdExstatus) ** Drest p d).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hdescnew : forall p d,
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> 0 ** Drest p d
    |-- store_published_task p (set_task_desc_exstatus d 0)).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor, set_task_desc_exstatus; cbn.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  destruct PreH16 as [desc [Hlookup Hadm]].
  assert (Hadmiss : linklist_suspend_admissible (assignRunningTask (os_assign held)) 1 held).
  { exists desc; tauto. }
  set (p := assignRunningTask (os_assign held)) in *.
set (R :=
    “ os_world_wf sg_semaphore_obtain_oc held /\ task_world_wf held ” &&
    store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
      held.(os_tasks).(task_idmanager_abs) sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
    store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
      (task_link_nodes held.(os_tasks).(task_ptr_list)) **
    store_map_missing_i store_published_task held.(os_tasks).(task_desc_map) p **
    Drest p desc **
    store_owned_sched_nodes held.(os_tasks).(task_desc_map) held.(os_tasks).(sched_owned_tasks) **
    store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
      sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
    tick_inv sg_semaphore_obtain_oc held **
    delay_inv sg_semaphore_obtain_oc held **
    assign_inv sg_semaphore_obtain_oc held **
    store_prio_lookup_table **
    store_zombie_queue held.(os_tasks).(task_desc_map)
      sg_semaphore_obtain_oc.(os_zombie_head) held.(zombie_queue) **
    sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> held.(os_recycle).(service_id) **
    IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id held.(os_idle)) **
    isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) held.(os_isr) **
    exstatus_inv sg_semaphore_obtain_oc held **
    semaphore_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_semaphore_stable) held.(os_semaphores) **
    mutex_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_mutex_stable) held.(os_mutexes) **
    event_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_event_stable) held.(os_events) **
    dataqueue_inv held.(os_semaphores) held.(os_dataqueues)).
  assert (Hcut : os_inv sg_semaphore_obtain_oc held |--
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus) ** R).
  { unfold R, os_inv, task_inv. Intros.
    sep_apply_l_atomic (store_map_split store_published_task p desc
      (task_desc_map (os_tasks held)) Hlookup).
    sep_apply_l_atomic (Hdescsplit p desc).
    split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hrestore : &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> 0 ** R
    |-- os_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held)).
  { unfold R. Intros.
    assert (How : os_world_wf sg_semaphore_obtain_oc (semaphore_clear_status p desc held)).
    { apply Hworld; auto; tauto. }
    assert (Htw : task_world_wf (semaphore_clear_status p desc held)).
    { apply Htaskwf; auto; tauto. }
      assert (Hlook : update_task_desc_map p (set_task_desc_exstatus desc 0)
        (task_desc_map (os_tasks held)) p = Some (set_task_desc_exstatus desc 0)).
      { unfold update_task_desc_map. destruct (Z.eq_dec p p); congruence. }

      assert (Hmiss : store_map_missing_i store_published_task (task_desc_map (os_tasks held)) p |--
        store_map_missing_i store_published_task
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) p).
      { assert (Heq : forall q, q <> p -> task_desc_map (os_tasks held) q =
          update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)) q).
        { intros q Hq. unfold update_task_desc_map; destruct (Z.eq_dec q p); [contradiction|reflexivity]. }
        exact (proj1 (store_map_missing_i_equiv store_published_task
          (task_desc_map (os_tasks held))
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
          p Heq)). }

      sep_apply_l_atomic Hmiss.


      sep_apply_l_atomic (Hdescnew p desc ).
      sep_apply_l_atomic (store_map_merge store_published_task p (set_task_desc_exstatus desc 0)
        (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) Hlook).

      sep_apply_l_atomic (Howned (task_desc_map (os_tasks held)) p desc 
        (sched_owned_tasks (os_tasks held)) Hlookup).

      sep_apply_l_atomic (Hassign sg_semaphore_obtain_oc held p desc   Hlookup).

      sep_apply_l_atomic (Hzombie (task_desc_map (os_tasks held)) p desc 
        (os_zombie_head sg_semaphore_obtain_oc) (zombie_queue held) Hlookup).

      assert (Hwait : forall l q, pure_suspend_sched_link (task_desc_map (os_tasks held)) l q |--
        pure_suspend_sched_link
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) l q).
      { intros; apply Hpub; exact Hlookup. }
      sep_apply_l_atomic (Hsemmono _ _ Hwait (os_semaphore_stable sg_semaphore_obtain_oc) (os_semaphores held)).
      sep_apply_l_atomic (Hmutexmono _ _ Hwait (os_mutex_stable sg_semaphore_obtain_oc) (os_mutexes held)).
      sep_apply_l_atomic (Heventmono _ _ Hwait (os_event_stable sg_semaphore_obtain_oc) (os_events held)).

      sep_apply_l_atomic (Hdelay sg_semaphore_obtain_oc held p desc Hlookup).
      unfold os_inv, task_inv. cbv beta iota zeta. split_pure_spatial.
      + match goal with |- ?L |-- _ => change (L |--
store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
    held.(os_tasks).(task_idmanager_abs)
    sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
  store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
    (task_link_nodes held.(os_tasks).(task_ptr_list)) **
  store_map store_published_task (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) **
  store_owned_sched_nodes (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
    held.(os_tasks).(sched_owned_tasks) **
  store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
    sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
tick_inv sg_semaphore_obtain_oc held **
  delay_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held) **
  assign_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held) **
  store_prio_lookup_table **
  store_zombie_queue (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
    sg_semaphore_obtain_oc.(os_zombie_head) held.(zombie_queue) **
  sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> held.(os_recycle).(service_id) **
  IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id held.(os_idle)) **
  isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) held.(os_isr) **
  exstatus_inv sg_semaphore_obtain_oc held **
  semaphore_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_semaphore_stable) held.(os_semaphores) **
  mutex_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_mutex_stable) held.(os_mutexes) **
  event_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_event_stable) held.(os_events) **
  dataqueue_inv held.(os_semaphores) held.(os_dataqueues)) end.
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; tauto.
  }
  Exists desc.
  split_pure_spatial.
  - sep_apply_l_atomic Hcut.
    cancel (InsideCritical sg_semaphore_obtain_oc held).
    cancel (&(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc).
    apply_sepcon_adjoint. sep_apply_l_atomic Hrestore. cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.
Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold linklist_suspend_admissible in *.
  destruct PreH17 as [d [Hd Hadm]].
  rewrite <- PreH10 in Hd, Hadm.
  rewrite PreH11 in Hd. inversion Hd; subst d.
  exists (set_task_desc_exstatus desc 0).
  unfold semaphore_clear_status, replace_task_desc_map; simpl.
  split.
  - unfold update_task_desc_map. destruct (Z.eq_dec task task); congruence.
  - intros _. specialize (Hadm ltac:(auto)).
    unfold ktask_not_os_service in *. simpl in *. rewrite <- PreH10. exact Hadm.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold semaphore_pending_nodes.
  exists original. unfold semaphore_clear_status, replace_task_desc_map; simpl.
  repeat split; auto; congruence.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) 0)
    (os_inv sg_semaphore_obtain_oc (semaphore_clear_status task desc held))).
  repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_1.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_2.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_3.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH2 as Hprio.
  unfold linklist_suspend_prio, linklist_suspend_step in Hprio.
  destruct Hprio as [[Hbad _]|[_ [_ [staged [ignored [Hs Henq]]]]]]; [tauto|].
  assert (Hnonzero : task <> 0).
  { unfold ktask_suspend_step in Hs. tauto. }
  unfold linklist_semaphore_enqueue in Henq.
  destruct Henq as [obj [sd [nodes [Hi [Ha [Hlookup [Hstat [Howned [Hins Hafter]]]]]]]]].
  assert (Hlookupafter : task_desc_map (os_tasks after) task = Some sd).
  { rewrite Hafter. unfold replace_sched_owned_tasks, semaphore_enqueue_state,
      replace_semaphores. simpl. exact Hlookup. }
  Exists sd after.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; try assumption.
  rewrite <- PreH10, <- PreH12 in PreH18.
  exact (PreH18 desc after sd PreH11 PreH2 Hlookupafter).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hmapnew : forall (T : Z -> option TaskDescriptorAbs) p d dp q e,
    T p = Some d -> T q = Some e ->
    exists e', update_task_desc_map p (replace_descriptor_delay dp d) T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d dp q e Hp Hq.
    unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne].
    - rewrite Hp in Hq. inversion Hq; subst e.
      exists (replace_descriptor_delay dp d); simpl; tauto.
    - exists e; tauto. }
  assert (Hmapold : forall (T : Z -> option TaskDescriptorAbs) p d dp q e,
    T p = Some d ->
    update_task_desc_map p (replace_descriptor_delay dp d) T q = Some e ->
    exists e', T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d dp q e Hp Hq.
    unfold update_task_desc_map in Hq. destruct (Z.eq_dec q p) as [->|Hne].
    - inversion Hq; subst e. exists d; simpl; tauto.
    - exists e; tauto. }
  assert (Htaskwf : forall st p d dp ticks,
    st.(os_tasks).(task_desc_map) p = Some d -> task_world_wf st ->
    task_world_wf (ktask_set_delay_updated_state p ticks d dp st)).
  { intros st p d dp ticks Hlookup Hwf.
    unfold ktask_set_delay_updated_state, replace_delay_active_nodes,
      replace_delay_inactive_map, replace_task_desc_map; cbn.
    constructor; cbn.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_map_present; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      eapply task_wf_init_running_owned; eauto. rewrite Hs'; exact Hs.
    - exact (task_wf_id_nodes _ Hwf).
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' Hb']]].
      pose proof (task_wf_priority _ Hwf q e' He'). rewrite Hs', Hb' in H; exact H.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_aligned; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_running_bitmap; eauto. rewrite Hs'; exact Hs.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_init_close_bitmap; eauto. rewrite Hs'; exact Hs.
  }
  assert (Hassignwf : forall T p d dp a,
    T p = Some d -> assign_world_wf T a ->
    assign_world_wf (update_task_desc_map p (replace_descriptor_delay dp d) T) a).
  { intros T p d dp a Hlookup Hwf.
    destruct Hwf as [Hrun Hready]. constructor.
    - destruct Hrun as [Hrun | [e He]]; [left; exact Hrun|right].
      destruct (Hmapnew T p d dp _ _ Hlookup He) as [e' [He' _]]. eauto.
    - unfold os_assign_ready_vector_ok in *.
      destruct Hready as [Hb [Hg Hh]]. split; [|tauto].
      unfold priority_ready_buckets_ok in *.
      assert (Hbs : forall bs index,
        priority_ready_buckets_task_ok T index bs ->
        priority_ready_buckets_task_ok (update_task_desc_map p (replace_descriptor_delay dp d) T) index bs).
      { intro bs; induction bs as [|bucket rest IH]; intros index Hbs; simpl in *; auto.
        destruct Hbs as [Hbucket Hr]. split.
        - rewrite Forall_forall in *. intros n Hn. specialize (Hbucket n Hn).
          unfold ready_node_at_priority_ok, ready_node_task_desc in *.
          destruct Hbucket as [e [[Hnz [Hptr He]] [Hp [Hm Hst]]]].
          destruct (Hmapnew T p d dp _ _ Hlookup He) as [e' [He' [Hs' _]]].
          exists e'; rewrite Hs'; repeat split; auto.
        - apply IH; exact Hr. }
      apply Hbs; exact Hb.
  }
  assert (Hworld : forall sg st p d dp ticks,
    st.(os_tasks).(task_desc_map) p = Some d ->
    d.(tdSchedMember).(tsmStat) = TSK_SUSPEND ->
    ~ In p st.(os_tasks).(sched_owned_tasks) ->
    os_world_wf sg st ->
    os_world_wf sg (ktask_set_delay_updated_state p ticks d dp st)).
  { intros sg st p d dp ticks Hlookup Hstat Hnot Hwf.
    assert (Hs : forall entry slot, service_slot_wf st entry slot ->
      service_slot_wf (ktask_set_delay_updated_state p ticks d dp st) entry slot).
    { intros entry slot Hs. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| | q]; auto.
      destruct Hs as [e [He Hentry Hdelay Hown Hid]].
      assert (Hneq : q <> p).
      { intro E; subst q. rewrite Hlookup in He. inversion He; subst e.
        apply Hnot; apply Hown. rewrite Hstat; discriminate. }
      exists e. constructor;
        cbn [ktask_set_delay_updated_state replace_delay_active_nodes
          replace_delay_inactive_map replace_task_desc_map].
      - change (update_task_desc_map p (replace_descriptor_delay dp d)
          (task_desc_map (os_tasks st)) q = Some e).
        unfold update_task_desc_map. destruct (Z.eq_dec q p); [contradiction|exact He].
      - exact Hentry.
      - exact Hdelay.
      - exact Hown.
      - exact Hid.
    }
    constructor.
    - exact (os_wf_context _ _ Hwf).
    - apply Hs. exact (os_wf_recycler _ _ Hwf).
    - change (Forall (service_slot_wf (ktask_set_delay_updated_state p ticks d dp st)
        (os_idle_entry sg)) (os_idle st)).
      rewrite Forall_forall in *. intros sl Hsl. apply Hs.
      pose proof (os_wf_idle _ _ Hwf) as Hi. rewrite Forall_forall in Hi; auto.
    - exact (os_wf_sched_nodup _ _ Hwf).
    - intro q. change (In q (os_sched_owners st) <->
        update_task_desc_map p (replace_descriptor_delay dp d)
          (task_desc_map (os_tasks st)) q <> None).
      rewrite (os_wf_sched_domain _ _ Hwf q).
      unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne]; [rewrite Hlookup|];
        split; intros; discriminate || assumption.
  }
  assert (Hdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) ->
    forall nodes x px y py, dllseg P x px y py nodes |-- dllseg Q x px y py nodes).
  { intros A P Q HP nodes; induction nodes as [|a rest IH]; intros x px y py.
    - cbn [dllseg]; Intros. split_pure_spatial; [cancel|split_pures; dump_pre_spatial; tauto].
    - cbn [dllseg]. fold (@dllseg A P) (@dllseg A Q). Intros z.
      Exists z. split_pure_spatial.
      + sep_apply_l_atomic (HP x (getData a)).
        sep_apply_l_atomic (IH z x y py). cancel.
        change (dllseg Q z x y py rest |-- dllseg Q z x y py rest). cancel.
      + split_pures; dump_pre_spatial; auto.
  }
  assert (Hsdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) -> forall head nodes,
    store_dll P head nodes |-- store_dll Q head nodes).
  { intros A P Q HP head nodes. unfold store_dll. Intros h pt. Exists h pt.
    split_pure_spatial.
    - sep_apply_l_atomic (Hdllmono A P Q HP nodes h head head pt). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hpub : forall T p d dp status l q,
    T p = Some d ->
    pure_published_slink T status l q |--
    pure_published_slink (update_task_desc_map p (replace_descriptor_delay dp d) T) status l q).
  { intros T p d dp status l q Hl. unfold pure_published_slink. Intros e.
    assert (He : T q = Some e) by tauto.
    destruct (Hmapnew T p d dp q e Hl He) as [e' [He' [Hsch _]]].
    Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto.
  }
  assert (Howned : forall T p d dp tasks,
    T p = Some d ->
    store_owned_sched_nodes T tasks |--
    store_owned_sched_nodes (update_task_desc_map p (replace_descriptor_delay dp d) T) tasks).
  { intros T p d dp tasks Hl.
    assert (Hdet : forall q, store_detached_sched_link T q |--
      store_detached_sched_link (update_task_desc_map p (replace_descriptor_delay dp d) T) q).
    { intro q. unfold store_detached_sched_link. Intros e.
      assert (He : T q = Some e) by tauto.
      destruct (Hmapnew T p d dp q e Hl He) as [e' [He' [Hsch _]]].
      Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto. }
    unfold store_owned_sched_nodes.
    induction tasks as [|q tasks IH]; cbn [map]; [cancel|].
    rewrite !logic_equiv_iter_sepcon_cons.
    sep_apply_l_atomic (Hdet q). sep_apply_l_atomic IH. cancel.
  }
  assert (Hsemmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst sems,
    semaphore_inv P sst sems |-- semaphore_inv Q sst sems).
  { intros P Q HP sst sems.
    assert (Hpay : forall l v, store_semaphore P l v |-- store_semaphore Q l v).
    { intros l v. pose (p := semaphore_addr v). unfold store_semaphore. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Semaphore" ->ₛ "pend_list"))
          (map semaphore_wait_node (semaphore_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v)) |-- store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold semaphore_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono SemaphoreAbs (store_semaphore P) (store_semaphore Q)
        Hpay (semaphore_list_head sst) (map semaphore_link_node sems)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hmutexmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    mutex_inv P sst vals |-- mutex_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_mutex P l v |-- store_mutex Q l v).
    { intros l v. pose (p := mutex_addr v). unfold store_mutex. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Mutex" ->ₛ "pend_list"))
          (map mutex_wait_node (mutex_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v)) |-- store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold mutex_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono MutexAbs (store_mutex P) (store_mutex Q)
        Hpay (mutex_list_head sst) (map mutex_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Heventmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    event_inv P sst vals |-- event_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_event P l v |-- store_event Q l v).
    { intros l v. pose (p := event_addr v). unfold store_event. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Event" ->ₛ "pend_list"))
          (map event_wait_node (event_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v)) |-- store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold event_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono EventAbs (store_event P) (store_event Q)
        Hpay (event_list_head sst) (map event_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hzombie : forall T p d dp head vals,
    T p = Some d ->
    store_zombie_queue T head vals |--
    store_zombie_queue (update_task_desc_map p (replace_descriptor_delay dp d) T) head vals).
  { intros T p d dp head vals Hl. destruct vals; cbn [store_zombie_queue]; [cancel|].
    apply Hsdllmono. intros l q. apply Hpub; exact Hl.
  }
  assert (Hassign : forall sg st p d dp ticks,
    st.(os_tasks).(task_desc_map) p = Some d ->
    assign_inv sg st |-- assign_inv sg (ktask_set_delay_updated_state p ticks d dp st)).
  { intros sg st p d dp ticks Hl.
    unfold assign_inv, ktask_set_delay_updated_state, replace_delay_active_nodes,
      replace_delay_inactive_map, replace_task_desc_map; cbn.
    Intros. split_pure_spatial; [cancel|].
    split_pures; dump_pre_spatial; apply Hassignwf; assumption.
  }
  assert (Hnotowned : ~ In task (sched_owned_tasks (os_tasks suspended))).
  { unfold linklist_suspend_prio, linklist_suspend_step in PreH17.
    destruct PreH17 as [[Hbad _] | [_ [_ [stage [ignored [_ Hq]]]]]]; [tauto|].
    unfold linklist_semaphore_enqueue in Hq.
    destruct Hq as [s [d [nodes [_ [_ [_ [_ [_ [_ ->]]]]]]]]].
    cbn [replace_sched_owned_tasks]. apply remove_In. }
 set (Drest := fun (p : addr) (d : TaskDescriptorAbs) =>
    “ aligned_reglen d.(tdStackPoint) /\
      d.(tdBaseInfo).(tbStackStart) <= d.(tdStackPoint) /\
      d.(tdStackPoint) + sizeof("StackRegisterContext") <= kss_aligned_top d.(tdBaseInfo) /\
      addr_aligned p ALIGN_SIZE ” &&
    store_task_sched_member (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) d.(tdSchedMember) **
    &(p # "TaskDescriptor" ->ₛ "stack_point") # Ptr |-> d.(tdStackPoint) **
    store_task_base_info p d.(tdBaseInfo) **
    &(p # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt |-> d.(tdEventIdTrigger) **
    &(p # "TaskDescriptor" ->ₛ "event_mode") # UInt |-> d.(tdEventMode) **
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> d.(tdExstatus) **
    &(p # "TaskDescriptor" ->ₛ "Done") # Ptr |-> d.(tdDone) **
    store_task_descriptor_padding p **
    store_ktask_stack d.(tdBaseInfo).(tbStackStart) d.(tdBaseInfo).(tbStackDepth) d.(tdStackRaw) d.(tdStackContext)).
  assert (Hdescsplit : forall p d, store_published_task p d |--
    &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> d.(tdDelay) ** Drest p d).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hdescsame : forall p d,
    &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> d.(tdDelay) ** Drest p d
    |-- store_published_task p d).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hdescnew : forall p d dp,
    &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> dp ** Drest p d
    |-- store_published_task p (replace_descriptor_delay dp d)).
  { intros p d dp. unfold Drest, store_published_task, store_task_descriptor, replace_descriptor_delay; cbn.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
set (R :=
    “ os_world_wf sg_semaphore_obtain_oc suspended /\ task_world_wf suspended ” &&
    store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
      suspended.(os_tasks).(task_idmanager_abs) sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
    store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
      (task_link_nodes suspended.(os_tasks).(task_ptr_list)) **
    store_map_missing_i store_published_task suspended.(os_tasks).(task_desc_map) task **
    Drest task sd **
    store_owned_sched_nodes suspended.(os_tasks).(task_desc_map) suspended.(os_tasks).(sched_owned_tasks) **
    store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
      sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
    assign_inv sg_semaphore_obtain_oc suspended **
    store_prio_lookup_table **
    store_zombie_queue suspended.(os_tasks).(task_desc_map)
      sg_semaphore_obtain_oc.(os_zombie_head) suspended.(zombie_queue) **
    sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> suspended.(os_recycle).(service_id) **
    IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id suspended.(os_idle)) **
    isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) suspended.(os_isr) **
    exstatus_inv sg_semaphore_obtain_oc suspended **
    semaphore_inv (pure_suspend_sched_link suspended.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_semaphore_stable) suspended.(os_semaphores) **
    mutex_inv (pure_suspend_sched_link suspended.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_mutex_stable) suspended.(os_mutexes) **
    event_inv (pure_suspend_sched_link suspended.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_event_stable) suspended.(os_events) **
    dataqueue_inv suspended.(os_semaphores) suspended.(os_dataqueues)).
  assert (Hcut : os_inv sg_semaphore_obtain_oc suspended |--
    &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> sd.(tdDelay) **
    delay_inv sg_semaphore_obtain_oc suspended ** tick_inv sg_semaphore_obtain_oc suspended ** R).
  { unfold R, os_inv, task_inv. Intros.
    sep_apply_l_atomic (store_map_split store_published_task task sd
      (task_desc_map (os_tasks suspended)) PreH18).
    sep_apply_l_atomic (Hdescsplit task sd).
    split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hrestore : forall delayed dp rc,
    ktask_set_delay_step task sd wait_time dp suspended rc delayed ->
    &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> dp **
    (delay_inv sg_semaphore_obtain_oc delayed ** (tick_inv sg_semaphore_obtain_oc delayed ** R))
    |-- os_inv sg_semaphore_obtain_oc delayed).
  { intros delayed dp rc Hstep. destruct Hstep as [[Hrc [Hd [Hdp ->]]] | [Hrc [Hdp [Hsame ->]]]].
    - subst dp. rewrite <- Hd. unfold R. Intros.
      sep_apply_l_atomic (Hdescsame task sd).
      sep_apply_l_atomic (store_map_merge store_published_task task sd
        (task_desc_map (os_tasks suspended)) PreH18).
      unfold os_inv, task_inv. cbv beta iota zeta. split_pure_spatial; [sepcon_assoc_change; cancel|].
      split_pures; dump_pre_spatial; tauto.
    - unfold R. Intros.
      assert (How : os_world_wf sg_semaphore_obtain_oc
          (ktask_set_delay_updated_state task wait_time sd dp suspended)).
      { apply Hworld; auto; tauto. }
      assert (Htw : task_world_wf (ktask_set_delay_updated_state task wait_time sd dp suspended)).
      { apply Htaskwf; auto; tauto. }
      assert (Hlook : update_task_desc_map task (replace_descriptor_delay dp sd)
        (task_desc_map (os_tasks suspended)) task = Some (replace_descriptor_delay dp sd)).
      { unfold update_task_desc_map. destruct (Z.eq_dec task task); congruence. }

      assert (Hmiss : store_map_missing_i store_published_task (task_desc_map (os_tasks suspended)) task |--
        store_map_missing_i store_published_task
          (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended))) task).
      { assert (Heq : forall q, q <> task -> task_desc_map (os_tasks suspended) q =
          update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)) q).
        { intros q Hq. unfold update_task_desc_map; destruct (Z.eq_dec q task); [contradiction|reflexivity]. }
        exact (proj1 (store_map_missing_i_equiv store_published_task
          (task_desc_map (os_tasks suspended))
          (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))
          task Heq)). }

      sep_apply_l_atomic Hmiss.


      sep_apply_l_atomic (Hdescnew task sd dp).
      sep_apply_l_atomic (store_map_merge store_published_task task (replace_descriptor_delay dp sd)
        (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended))) Hlook).

      sep_apply_l_atomic (Howned (task_desc_map (os_tasks suspended)) task sd dp
        (sched_owned_tasks (os_tasks suspended)) PreH18).

      sep_apply_l_atomic (Hassign sg_semaphore_obtain_oc suspended task sd dp wait_time PreH18).

      sep_apply_l_atomic (Hzombie (task_desc_map (os_tasks suspended)) task sd dp
        (os_zombie_head sg_semaphore_obtain_oc) (zombie_queue suspended) PreH18).

      assert (Hwait : forall l q, pure_suspend_sched_link (task_desc_map (os_tasks suspended)) l q |--
        pure_suspend_sched_link
          (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended))) l q).
      { intros; apply Hpub; exact PreH18. }
      sep_apply_l_atomic (Hsemmono _ _ Hwait (os_semaphore_stable sg_semaphore_obtain_oc) (os_semaphores suspended)).
      sep_apply_l_atomic (Hmutexmono _ _ Hwait (os_mutex_stable sg_semaphore_obtain_oc) (os_mutexes suspended)).
      sep_apply_l_atomic (Heventmono _ _ Hwait (os_event_stable sg_semaphore_obtain_oc) (os_events suspended)).

      unfold os_inv, task_inv. cbv beta iota zeta. split_pure_spatial.
      + match goal with |- ?L |-- _ => change (L |--
store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
    suspended.(os_tasks).(task_idmanager_abs)
    sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
  store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
    (task_link_nodes suspended.(os_tasks).(task_ptr_list)) **
  store_map store_published_task (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended))) **
  store_owned_sched_nodes (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))
    suspended.(os_tasks).(sched_owned_tasks) **
  store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
    sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
tick_inv sg_semaphore_obtain_oc (ktask_set_delay_updated_state task wait_time sd dp suspended) **
  delay_inv sg_semaphore_obtain_oc (ktask_set_delay_updated_state task wait_time sd dp suspended) **
  assign_inv sg_semaphore_obtain_oc (ktask_set_delay_updated_state task wait_time sd dp suspended) **
  store_prio_lookup_table **
  store_zombie_queue (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))
    sg_semaphore_obtain_oc.(os_zombie_head) suspended.(zombie_queue) **
  sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> suspended.(os_recycle).(service_id) **
  IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id suspended.(os_idle)) **
  isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) suspended.(os_isr) **
  exstatus_inv sg_semaphore_obtain_oc suspended **
  semaphore_inv (pure_suspend_sched_link (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))) sg_semaphore_obtain_oc.(os_semaphore_stable) suspended.(os_semaphores) **
  mutex_inv (pure_suspend_sched_link (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))) sg_semaphore_obtain_oc.(os_mutex_stable) suspended.(os_mutexes) **
  event_inv (pure_suspend_sched_link (update_task_desc_map task (replace_descriptor_delay dp sd) (task_desc_map (os_tasks suspended)))) sg_semaphore_obtain_oc.(os_event_stable) suspended.(os_events) **
  dataqueue_inv suspended.(os_semaphores) suspended.(os_dataqueues)) end.
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; tauto.
  }
assert (Hcontext : os_inv sg_semaphore_obtain_oc suspended |-- “ os_global_context sg_semaphore_obtain_oc ”).
  { unfold os_inv. Intros. dump_pre_spatial.
    eapply os_wf_context; eassumption. }
  prop_apply_p Hcontext. Intros.
  destruct (PreH20 ltac:(lia)) as [[Hz | Hi] Hw].
  - Right. Exists R. sep_apply_l_atomic Hcut.
    split_pure_spatial; [cancel|].
    split_pures; dump_pre_spatial; (assumption || exact Hrestore || lia).
  - Left. Exists R. sep_apply_l_atomic Hcut.
    split_pure_spatial; [cancel|].
    split_pures; dump_pre_spatial; (assumption || exact Hrestore || lia).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1 : _SemaphoreObtain_entail_wit_12_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial : _SemaphoreObtain_entail_wit_12_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 match goal with
 | H : ktask_set_delay_step _ _ _ _ _ _ _ |- _ =>
   pose proof H as Hfailure;
   destruct Hfailure as [[Hrc [Hd [Hdp Hafter]]] | [Hrc Hsuccess]];
   [ | congruence ]
 end.
 subst.
 split_pure_spatial.
 - cancel (InsideCritical sg_semaphore_obtain_oc held).
   exact (PreH23 suspended 0 (-5) PreH2).
 - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1 : _SemaphoreObtain_entail_wit_12_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial : _SemaphoreObtain_entail_wit_12_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 match goal with
 | H : ktask_set_delay_step _ _ _ _ _ _ _ |- _ =>
   pose proof H as Hfailure;
   destruct Hfailure as [[Hrc [Hd [Hdp Hafter]]] | [Hrc Hsuccess]];
   [ | congruence ]
 end.
 subst.
 split_pure_spatial.
 - cancel (InsideCritical sg_semaphore_obtain_oc held).
   exact (PreH23 suspended 0 (-5) PreH2).
 - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1 : _SemaphoreObtain_entail_wit_13_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2 : _SemaphoreObtain_entail_wit_13_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite <- PreH16 in PreH9.
  assert (Hids : task_idmanager_abs (os_tasks after) = task_idmanager_abs (os_tasks suspended)) by (rewrite PreH6; reflexivity).
  assert (Hinfo : os_inv sg_semaphore_obtain_oc after |--
    “ idbuckets_ok (idmax (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)))
       (hoffset (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)))
       (idlist (task_idmanager_abs (os_tasks suspended)))
       (idbuckets (task_idmanager_abs (os_tasks suspended))) ”).
  { unfold os_inv, task_inv, store_idmanager. Intros. dump_pre_spatial.
    rewrite <- Hids. assumption. }
  prop_apply_p Hinfo. Intros_p Hbk.
  destruct Hbk as [Hoff [Hlen [Hidsok [Hnodes [Hindices Hperm]]]]].
  assert (Hnd : NoDup (map idnode_id (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended)))))).
  { eapply Permutation_NoDup; [apply Permutation_sym; exact Hperm|exact (proj2 Hidsok)]. }
  assert (Huniq : forall ns (a b : IdNodeAbs), NoDup (map idnode_id ns) ->
    In a ns -> In b ns -> idnode_id a = idnode_id b -> a = b).
  { induction ns as [|n ns IH]; intros a b Hno Ha Hb Heq; [contradiction|].
    cbn [map] in Hno. inversion Hno as [|nid ids Hnot Htail]; subst.
    destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
    - congruence.
    - subst a. exfalso. apply Hnot. rewrite Heq. apply in_map. exact Hb.
    - subst b. exfalso. apply Hnot. rewrite <- Heq. apply in_map. exact Ha.
    - eapply IH; eauto. }
  assert (Hfound : task_2 = task).
  { destruct PreH2 as [Hr [Hq [p [Hp [Hin Htask]]]]].
    destruct PreH9 as [Hr2 [Hq2 [p2 [Hp2 [Hin2 Htask2]]]]].
    assert (Hidx : 0 <= idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)) rollback_id < Zlength (idbuckets (task_idmanager_abs (os_tasks suspended)))) by
      (unfold idmanager_bucket_index; rewrite Hlen; apply Z.mod_pos_bound; exact Hoff).
    assert (Hbucket : In (Znth (idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)) rollback_id)
      (idbuckets (task_idmanager_abs (os_tasks suspended))) nil)
      (idbuckets (task_idmanager_abs (os_tasks suspended)))) by (apply Znth_In_Zlength; exact Hidx).
    assert (Hina : In (Build_IdNodeAbs rollback_id p) (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin]).
    assert (Hinb : In (Build_IdNodeAbs rollback_id p2) (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin2]).
    pose proof (Huniq _ _ _ Hnd Hina Hinb eq_refl) as Heq.
    injection Heq as Heq. rewrite Hp, Hp2 in Heq. apply addr_of_arrow_field_inv in Heq. injection Heq as Heq. exact Heq. }
  subst task_2.
  assert (desc_2 = sd) by congruence. subst desc_2. exfalso. apply PreH4. exact PreH26.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1 : _SemaphoreObtain_entail_wit_13_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2 : _SemaphoreObtain_entail_wit_13_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite <- PreH16 in PreH9.
  pose proof (wakeup_task_ids _ _ _ _ PreH6) as Hids.
  assert (Hinfo : os_inv sg_semaphore_obtain_oc after |--
    “ idbuckets_ok (idmax (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)))
       (hoffset (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)))
       (idlist (task_idmanager_abs (os_tasks suspended)))
       (idbuckets (task_idmanager_abs (os_tasks suspended))) ”).
  { unfold os_inv, task_inv, store_idmanager. Intros. dump_pre_spatial.
    rewrite <- Hids. assumption. }
  prop_apply_p Hinfo. Intros_p Hbk.
  destruct Hbk as [Hoff [Hlen [Hidsok [Hnodes [Hindices Hperm]]]]].
  assert (Hnd : NoDup (map idnode_id (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended)))))).
  { eapply Permutation_NoDup; [apply Permutation_sym; exact Hperm|exact (proj2 Hidsok)]. }
  assert (Huniq : forall ns (a b : IdNodeAbs), NoDup (map idnode_id ns) ->
    In a ns -> In b ns -> idnode_id a = idnode_id b -> a = b).
  { induction ns as [|n ns IH]; intros a b Hno Ha Hb Heq; [contradiction|].
    cbn [map] in Hno. inversion Hno as [|nid ids Hnot Htail]; subst.
    destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
    - congruence.
    - subst a. exfalso. apply Hnot. rewrite Heq. apply in_map. exact Hb.
    - subst b. exfalso. apply Hnot. rewrite <- Heq. apply in_map. exact Ha.
    - eapply IH; eauto. }
  assert (Hfound : task_2 = task).
  { destruct PreH2 as [Hr [Hq [p [Hp [Hin Htask]]]]].
    destruct PreH9 as [Hr2 [Hq2 [p2 [Hp2 [Hin2 Htask2]]]]].
    assert (Hidx : 0 <= idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)) rollback_id < Zlength (idbuckets (task_idmanager_abs (os_tasks suspended)))) by
      (unfold idmanager_bucket_index; rewrite Hlen; apply Z.mod_pos_bound; exact Hoff).
    assert (Hbucket : In (Znth (idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_obtain_oc)) rollback_id)
      (idbuckets (task_idmanager_abs (os_tasks suspended))) nil)
      (idbuckets (task_idmanager_abs (os_tasks suspended)))) by (apply Znth_In_Zlength; exact Hidx).
    assert (Hina : In (Build_IdNodeAbs rollback_id p) (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin]).
    assert (Hinb : In (Build_IdNodeAbs rollback_id p2) (List.concat (idbuckets (task_idmanager_abs (os_tasks suspended))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin2]).
    pose proof (Huniq _ _ _ Hnd Hina Hinb eq_refl) as Heq.
    injection Heq as Heq. rewrite Hp, Hp2 in Heq. apply addr_of_arrow_field_inv in Heq. injection Heq as Heq. exact Heq. }
  subst task_2.
  assert (desc_2 = sd) by congruence. subst desc_2.
  Exists after. split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity.
    assert (Hstep : semaphore_obtain_effect id_pre wait_time held (inl (-5)) after).
  { right. exists original. split; [exact PreH21|]. split; [exact PreH22|].
    right. split; [exact PreH23|]. right. split; [lia|].
    exists task, desc, suspended. split; [exact PreH16|]. split; [exact PreH17|].
    split; [exact PreH18|]. split; [rewrite <- PreH19; exact PreH24|].
    right. split; [exact PreH14|]. exists sd, suspended, 0, (-5).
    split; [exact PreH25|]. split; [exact PreH27|]. right.
    split; [lia|]. split; [reflexivity|]. exists sd. auto. }
  assert (Hguard : orb (semaphore_id_invalid id_pre)
    (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
  { unfold semaphore_id_invalid.
    assert (Z.ltb id_pre 0 = false) by (apply Z.ltb_ge; lia).
    assert (Z.ltb 65535 id_pre = false) by (apply Z.ltb_ge; lia).
    rewrite H, H0. simpl.
    destruct (Z.eq_dec msec_pre (-1)) as [Heq|Hne].
    - subst msec_pre. reflexivity.
    - assert (Z.ltb msec_pre 0 = false) by (apply Z.ltb_ge; lia).
      rewrite H1. reflexivity. }
  unfold abs_semaphore_obtain in PreH29. rewrite obtain_if_bool in PreH29. rewrite Hguard, <- PreH13 in PreH29.
  destruct PreH29 as [states [Hseen Hwp]].
  unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
  destruct Hwp as [_ Hwp].
  apply (proj1 (wp_bind (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time))
    (semaphore_obtain_after_locked sg_semaphore_obtain_oc) X_semaphore_obtain_oc states)) in Hwp.
  exists (Crtos_RTrans after). split; [unfold LastSeen; reflexivity|].
  unfold safe.
  change (weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc (inl (-5)))
    X_semaphore_obtain_oc (Crtos_RTrans after)).
  eapply (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time)) states
    (Crtos_RTrans after) (inl (-5))) with
    (Q := fun r => weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc r) X_semaphore_obtain_oc);
    [|exact Hwp].
  cbn [task_atomic_cmd abs_semaphore_obtain_locked MonadErr.nrm].
  exists held, after. split; [apply Hseen; exact PreH28|].
  split; [exact Hstep|reflexivity].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists st_after (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc).
  split_pure_spatial.
  - Intros. cancel (InsideCritical sg_semaphore_obtain_oc held).
    exact (PreH23 st_after delay_after retval PreH2).
  - split_pures; dump_pre_spatial; try assumption; try reflexivity.
    + assert (Hstep : semaphore_obtain_effect id_pre wait_time held (inr task) st_after).
      { right. exists original. split; [exact PreH14|]. split; [exact PreH15|].
        right. split; [exact PreH16|]. right. split; [lia|].
        exists task, desc, suspended. split; [exact PreH9|]. split; [exact PreH10|].
        split; [exact PreH11|]. split; [rewrite <- PreH12; exact PreH17|].
        right. split; [exact PreH7|]. exists sd, st_after, delay_after, retval.
        split; [exact PreH18|]. split; [exact PreH2|]. left. auto. }
      assert (Hguard : orb (semaphore_id_invalid id_pre)
        (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
      { unfold semaphore_id_invalid.
        assert (Hb0 : Z.ltb id_pre 0 = false) by (apply Z.ltb_ge; lia).
        assert (Hbhi : Z.ltb 65535 id_pre = false) by (apply Z.ltb_ge; lia).
        rewrite Hb0, Hbhi. simpl.
        destruct (Z.eq_dec msec_pre (-1)) as [Heq|Hne].
        - subst msec_pre. reflexivity.
        - assert (Hbm : Z.ltb msec_pre 0 = false) by (apply Z.ltb_ge; lia).
          rewrite Hbm. reflexivity. }
      unfold abs_semaphore_obtain in PreH25 at 1. rewrite obtain_if_bool in PreH25. prog_nf in PreH25.
      rewrite Hguard, <- PreH6 in PreH25.
      destruct PreH25 as [states [Hseen Hwp]].
      unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      apply (proj1 (wp_bind (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time))
        (semaphore_obtain_after_locked sg_semaphore_obtain_oc) X_semaphore_obtain_oc states)) in Hwp.
      exists (Crtos_RTrans st_after). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc (inr task))
        X_semaphore_obtain_oc (Crtos_RTrans st_after)).
      eapply (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time)) states
        (Crtos_RTrans st_after) (inr task)) with
        (Q := fun r => weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc r) X_semaphore_obtain_oc);
        [|exact Hwp].
      cbn [task_atomic_cmd abs_semaphore_obtain_locked MonadErr.nrm].
      exists held, st_after. split; [apply Hseen; exact PreH24|].
      split; [exact Hstep|reflexivity].
    + intros st [states [Hseen Hwp]]. exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret tt (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc) states) Hwp).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists st_after (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc).
  split_pure_spatial.
  - Intros. cancel (InsideCritical sg_semaphore_obtain_oc held).
    exact (PreH23 st_after delay_after retval PreH2).
  - split_pures; dump_pre_spatial; try assumption; try reflexivity.
    + assert (Hstep : semaphore_obtain_effect id_pre wait_time held (inr task) st_after).
      { right. exists original. split; [exact PreH14|]. split; [exact PreH15|].
        right. split; [exact PreH16|]. right. split; [lia|].
        exists task, desc, suspended. split; [exact PreH9|]. split; [exact PreH10|].
        split; [exact PreH11|]. split; [rewrite <- PreH12; exact PreH17|].
        right. split; [exact PreH7|]. exists sd, st_after, delay_after, retval.
        split; [exact PreH18|]. split; [exact PreH2|]. left. auto. }
      assert (Hguard : orb (semaphore_id_invalid id_pre)
        (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
      { unfold semaphore_id_invalid.
        assert (Hb0 : Z.ltb id_pre 0 = false) by (apply Z.ltb_ge; lia).
        assert (Hbhi : Z.ltb 65535 id_pre = false) by (apply Z.ltb_ge; lia).
        rewrite Hb0, Hbhi. simpl.
        destruct (Z.eq_dec msec_pre (-1)) as [Heq|Hne].
        - subst msec_pre. reflexivity.
        - assert (Hbm : Z.ltb msec_pre 0 = false) by (apply Z.ltb_ge; lia).
          rewrite Hbm. reflexivity. }
      unfold abs_semaphore_obtain in PreH25 at 1. rewrite obtain_if_bool in PreH25. prog_nf in PreH25.
      rewrite Hguard, <- PreH6 in PreH25.
      destruct PreH25 as [states [Hseen Hwp]].
      unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      apply (proj1 (wp_bind (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time))
        (semaphore_obtain_after_locked sg_semaphore_obtain_oc) X_semaphore_obtain_oc states)) in Hwp.
      exists (Crtos_RTrans st_after). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc (inr task))
        X_semaphore_obtain_oc (Crtos_RTrans st_after)).
      eapply (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time)) states
        (Crtos_RTrans st_after) (inr task)) with
        (Q := fun r => weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc r) X_semaphore_obtain_oc);
        [|exact Hwp].
      cbn [task_atomic_cmd abs_semaphore_obtain_locked MonadErr.nrm].
      exists held, st_after. split; [apply Hseen; exact PreH24|].
      split; [exact Hstep|reflexivity].
    + intros st [states [Hseen Hwp]]. exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret tt (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc) states) Hwp).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists suspended (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity.
    + assert (Hstep : semaphore_obtain_effect id_pre wait_time held (inr task) suspended).
      { right. exists original. split; [exact PreH14|]. split; [exact PreH15|].
        right. split; [exact PreH16|]. right. split; [lia|].
        exists task, desc, suspended. split; [exact PreH9|]. split; [exact PreH10|].
        split; [exact PreH11|]. split; [rewrite <- PreH12; exact PreH17|].
        left. repeat split; auto; lia. }
      assert (Hguard : orb (semaphore_id_invalid id_pre)
        (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
      { unfold semaphore_id_invalid.
        assert (Hb0 : Z.ltb id_pre 0 = false) by (apply Z.ltb_ge; lia).
        assert (Hbhi : Z.ltb 65535 id_pre = false) by (apply Z.ltb_ge; lia).
        rewrite Hb0, Hbhi. simpl.
        destruct (Z.eq_dec msec_pre (-1)) as [Heq|Hne].
        - subst msec_pre. reflexivity.
        - assert (Hbm : Z.ltb msec_pre 0 = false) by (apply Z.ltb_ge; lia).
          rewrite Hbm. reflexivity. }
      unfold abs_semaphore_obtain in PreH22 at 1. rewrite obtain_if_bool in PreH22. prog_nf in PreH22.
      rewrite Hguard, <- PreH5 in PreH22.
      destruct PreH22 as [states [Hseen Hwp]].
      unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      apply (proj1 (wp_bind (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time))
        (semaphore_obtain_after_locked sg_semaphore_obtain_oc) X_semaphore_obtain_oc states)) in Hwp.
      exists (Crtos_RTrans suspended). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc (inr task))
        X_semaphore_obtain_oc (Crtos_RTrans suspended)).
      eapply (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre wait_time)) states
        (Crtos_RTrans suspended) (inr task)) with
        (Q := fun r => weakestpre (semaphore_obtain_after_locked sg_semaphore_obtain_oc r) X_semaphore_obtain_oc);
        [|exact Hwp].
      cbn [task_atomic_cmd abs_semaphore_obtain_locked MonadErr.nrm].
      exists held, suspended. split; [apply Hseen; exact PreH21|].
      split; [exact Hstep|reflexivity].
    + intros st [states [Hseen Hwp]]. exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret tt (fun (_ : unit) => weakestpre (semaphore_obtain_after_assign sg_semaphore_obtain_oc task) X_semaphore_obtain_oc) states) Hwp).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_15_split_goal_1 : _SemaphoreObtain_entail_wit_15_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_15_split_goal_1.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.
Proof.
LLM_pre_process ltac:(lia || int_auto).
assert (Hentry : semaphore_status_entry sg_semaphore_obtain_oc task (Crtos_RTrans scheduled)).
{ destruct PreH6 as [states [Hstates Hsafe]].
  unfold LastSeen in Hstates.
  unfold safe, semaphore_obtain_after_assign in Hsafe.
  rewrite wp_bind, wp_assertS in Hsafe.
  destruct Hsafe as [Hentry _].
  unfold semaphore_status_entry in Hentry |- *.
  intros obs Hobs. apply Hentry.
  apply (proj2 (Hstates obs)). exact Hobs. }
pose proof (Hentry st_lock PreH1) as Hguard.
prop_apply_p Hguard. Intros_p Hg. destruct Hg as [d Hd].
Exists d st_lock.
split_pure_spatial.
- cancel (InsideCritical sg_semaphore_obtain_oc st_lock).
  remember (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) (tdExstatus d) -* os_inv sg_semaphore_obtain_oc st_lock) as W eqn:HW.
  unfold os_inv at 1. unfold task_inv at 1. Intros.
  sep_apply_l_atomic (store_map_split store_published_task task d
    (task_desc_map (os_tasks st_lock)) Hd).
  unfold store_published_task at 2. unfold store_task_descriptor. Intros.
  cancel (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) (tdExstatus d)).
  subst W. apply_sepcon_adjoint.
  unfold os_inv, task_inv.
  split_pure_spatial.
  + sepcon_assoc_change. cancel. sep_apply_r_atomic (store_map_merge store_published_task task d
      (task_desc_map (os_tasks st_lock)) Hd).
    unfold store_published_task, store_task_descriptor.
    split_pure_spatial.
    * sepcon_assoc_change; cancel.
    * split_pures; dump_pre_spatial; assumption.
  + split_pures; dump_pre_spatial; assumption.
- split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_1 : _SemaphoreObtain_entail_wit_17_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_2 : _SemaphoreObtain_entail_wit_17_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
assert (Hstep : hs_eval (task_atomic_cmd (semaphore_read_status task)) (LastSeen scheduled) (LastSeen observed) (tdExstatus status_desc)).
{ intros states Hseen. exists (Crtos_RTrans observed). split.
  - cbn [task_atomic_cmd os_atomic_cmd semaphore_read_status MonadErr.nrm].
    exists observed, observed. split.
    + apply Hseen. exact PreH7.
    + split.
      * split; [reflexivity|]. exists status_desc. auto.
      * reflexivity.
  - unfold LastSeen. reflexivity. }
eapply (highstependret_derive _ _ (tdExstatus status_desc) (fun _ => LastSeen observed) Hstep).
unfold semaphore_obtain_after_assign in PreH8 at 1.
prog_nf in PreH8.
destruct PreH8 as [states [Hseen Hwp]].
exists states. split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind, wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial : _SemaphoreObtain_entail_wit_17_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cancel (InsideCritical sg_semaphore_obtain_oc observed).
sep_apply_r_atomic (derivable1_wand_elim1
  (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) (tdExstatus status_desc))
  (os_inv sg_semaphore_obtain_oc observed)).
cancel.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_17_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_6_split_goal_1 : _SemaphoreObtain_return_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with
  | H : safeExec _ (abs_semaphore_obtain ?sg ?id ?ms) _ |- _ =>
    assert (E : orb (semaphore_id_invalid id)
      (andb (Z.ltb ms 0) (negb (Z.eqb ms (-1)))) = true);
    [ unfold semaphore_id_invalid;
      repeat rewrite Bool.orb_true_iff;
      repeat rewrite Bool.andb_true_iff;
      rewrite Bool.negb_true_iff;
      repeat rewrite Z.ltb_lt;
      rewrite Z.eqb_neq; lia
    | unfold abs_semaphore_obtain in H; rewrite obtain_if_bool in H; prog_nf in H;
      rewrite E in H; exact H ]
  end.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_return_wit_6_split_goal_1.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_7_split_goal_1 : _SemaphoreObtain_return_wit_7_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with
  | H : safeExec _ (abs_semaphore_obtain ?sg ?id ?ms) _ |- _ =>
    assert (E : orb (semaphore_id_invalid id)
      (andb (Z.ltb ms 0) (negb (Z.eqb ms (-1)))) = true);
    [ unfold semaphore_id_invalid;
      repeat rewrite Bool.orb_true_iff;
      repeat rewrite Bool.andb_true_iff;
      rewrite Bool.negb_true_iff;
      repeat rewrite Z.ltb_lt;
      rewrite Z.eqb_neq; lia
    | unfold abs_semaphore_obtain in H; rewrite obtain_if_bool in H; prog_nf in H;
      rewrite E in H; exact H ]
  end.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_return_wit_7_split_goal_1.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_8_split_goal_1 : _SemaphoreObtain_return_wit_8_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with
  | H : safeExec _ (abs_semaphore_obtain ?sg ?id ?ms) _ |- _ =>
    assert (E : orb (semaphore_id_invalid id)
      (andb (Z.ltb ms 0) (negb (Z.eqb ms (-1)))) = true);
    [ unfold semaphore_id_invalid;
      repeat rewrite Bool.orb_true_iff;
      repeat rewrite Bool.andb_true_iff;
      rewrite Bool.negb_true_iff;
      repeat rewrite Z.ltb_lt;
      rewrite Z.eqb_neq; lia
    | unfold abs_semaphore_obtain in H; rewrite obtain_if_bool in H; prog_nf in H;
      rewrite E in H; exact H ]
  end.
Qed.

Lemma proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_return_wit_8_split_goal_1.
Qed.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 : _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Proof.
  aggressive_pre_process. Goal_apply proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Proof.
  aggressive_pre_process. Goal_apply proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial : _SemaphoreObtain_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with |- _ |-- _ ** ?W => remember W as R eqn:HR end.
  unfold os_inv at 1, semaphore_inv at 1. Intros.
  match goal with H : semaphore_context _ |- _ => pose proof H as Hctx; destruct H as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp. cancel.
  subst R. apply_sepcon_adjoint.
  unfold os_inv, semaphore_inv. rewrite Hp.
  split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; tauto].
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3 : _SemaphoreObtain_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_4 : _SemaphoreObtain_which_implies_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  assert (Hfresh : forall wait l x px y py p v,
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr l) ”).
  { clear. intros wait l. induction l as [|a l IH]; intros x px y py p v.
    - cbn [map]. dump_pre_spatial. simpl. tauto.
    - cbn [map dllseg]. Intros z.
      destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
      + unfold store_semaphore. Intros. rewrite Heq.
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) v).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
        Intros_p Hbad. contradiction.
      + change (store_semaphore wait x a **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
          &(p # "Semaphore" ->ₛ "value") # UShort |-> v))) |--
          “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
        sep_apply (IH z x y py p v). Intros_p Htail. dump_pre_spatial. simpl. intuition congruence. }
  assert (Hinfo : forall wait l x px y py,
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) |--
    “ NoDup (map semaphore_addr l) /\ Forall (fun s => 0 <= semaphore_value s <= 65535) l ”).
  { intros wait l. induction l as [|a l IH]; intros x px y py.
    - cbn [map]. dump_pre_spatial. split; constructor.
    - cbn [map]. unfold dllseg at 1. fold (@dllseg SemaphoreAbs).
      cbn [semaphore_link_node getPtr getData]. Intros z.
      unfold store_semaphore at 1. Intros.
      fold (@dllseg SemaphoreAbs (store_semaphore wait)).
      prop_apply_p (IH z x y py). Intros_p Htail.
      let p := constr:(semaphore_addr a) in
      prop_apply_p (store_ushort_range (&(p # "Semaphore" ->ₛ "value")) (semaphore_value a)).
      Intros_p Hvalue.
      sep_apply_l_atomic (Hfresh wait l z x y py (semaphore_addr a) (semaphore_value a)). Intros_p Hnot.
      dump_pre_spatial. destruct Htail as [Hnd Hvals].
      split; constructor; assumption. }
  assert (Hosinfo : forall sg st, os_inv sg st |--
    “ NoDup (map semaphore_addr (os_semaphores st)) /\
      Forall (fun s => 0 <= semaphore_value s <= 65535) (os_semaphores st) ”).
  { intros sg st. unfold os_inv, semaphore_inv. Intros.
    unfold store_dll. Intros h pt.
    prop_apply_p (Hinfo (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphores st)
      h (semaphore_list_head (os_semaphore_stable sg)) (semaphore_list_head (os_semaphore_stable sg)) pt).
    Intros. dump_pre_spatial. assumption. }
  assert (Hcut : forall (A:Type) (storeA:Z -> A -> Assertion) head prefix suffix ptr (data newdata:A),
    store_dll storeA head (prefix ++ Build_DL_Node data ptr :: suffix)
    |-- storeA ptr data **
      (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix))).
  { clear. intros A storeA head prefix suffix ptr data newdata.
    remember (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix)) as W eqn:HW.
    unfold store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (@dllseg_split A storeA hd head head pt prefix (Build_DL_Node data ptr :: suffix)).
    Intros cut beforeptr.
    cbn [dllseg]. Intros nxt. subst cut.
    fold (@dllseg A storeA).
    sepcon_assoc_change.
    cancel (storeA ptr data). subst W. apply_sepcon_adjoint.
    unfold store_dll at 1. Exists hd pt.
    split_pure_spatial.
    - cbn [getPtr getData].
      change ((&(ptr # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> beforeptr **
        (&(ptr # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> nxt **
        (dllseg storeA nxt ptr head pt suffix **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
        dllseg storeA hd head ptr beforeptr prefix))))) ** storeA ptr newdata
        |-- &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
            &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
            dllseg storeA hd head head pt (prefix ++ Build_DL_Node newdata ptr :: suffix)).
      sep_apply_l_atomic (dllseg_head_insert A storeA beforeptr ptr nxt head pt newdata suffix).
      sep_apply_l_atomic (@dllseg_concat A storeA hd head ptr beforeptr head pt prefix (Build_DL_Node newdata ptr :: suffix)).
      sepcon_assoc_change; cancel.
    - dump_pre_spatial.
      destruct H as [Hhead [Hpt [Hhd Hnodes]]].
      repeat split; try assumption.
      unfold dll_nodes_nonzero in *. rewrite Forall_app in *.
      destruct Hnodes as [Hp Hs]. split; [exact Hp|]. inversion Hs; subst. constructor; assumption.
  }

  assert (Hsemvalue : forall wait sg pre obj post value,
    semaphore_inv wait sg (pre ++ obj::post) |--
      &(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj **
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> value -*
       semaphore_inv wait sg (pre ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=value; semaphore_pending_addrs:=semaphore_pending_addrs obj |}::post))).
  { clear - Hcut. intros wait sg pre obj post value.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=value; semaphore_pending_addrs:=semaphore_pending_addrs obj |}).
    assert (Hmanager : semaphore_manager (pre ++ newobj::post) = semaphore_manager (pre ++ obj::post)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> value -*
       semaphore_inv wait sg (pre ++ newobj::post)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node pre) (map semaphore_link_node post)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (pre ++ obj::post)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node pre ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node post))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node pre ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node post)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }
  assert (Hglobal : forall sg st pre obj post value,
    os_semaphores st = pre ++ obj::post ->
    os_inv sg st |--
      &(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj **
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> value -*
       os_inv sg (replace_semaphores (pre ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=value; semaphore_pending_addrs:=semaphore_pending_addrs obj |}::post) st))).
  { clear - Hsemvalue. intros sg st pre obj post value Hss.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=value; semaphore_pending_addrs:=semaphore_pending_addrs obj |}).
    set (after := replace_semaphores (pre ++ newobj::post) st).
    assert (Howners : os_sched_owners after = os_sched_owners st).
    { unfold os_sched_owners, after, replace_semaphores. cbn. rewrite Hss.
      unfold semaphore_waiters. rewrite !map_app. cbn [map newobj semaphore_pending_addrs]. reflexivity. }
    assert (Hsvc : forall entry slot, service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hs. unfold service_slot_wf in *. destruct (service_phase slot); try assumption.
      destruct Hs as [d Hd]. exists d. destruct Hd; constructor; assumption. }
    assert (Hworld : os_world_wf sg st -> os_world_wf sg after).
    { intro Hw. constructor.
      - exact (os_wf_context sg st Hw).
      - apply Hsvc. exact (os_wf_recycler sg st Hw).
      - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
        apply Forall_forall. intros slot Hin. apply Hsvc.
        pose proof (os_wf_idle sg st Hw) as Hi. rewrite Forall_forall in Hi. apply Hi; exact Hin.
      - rewrite Howners. exact (os_wf_sched_nodup sg st Hw).
      - intro t. rewrite Howners. exact (os_wf_sched_domain sg st Hw t). }
    assert (Hqueues : dataqueue_inv (pre ++ obj::post) (os_dataqueues st) |-- dataqueue_inv (pre ++ newobj::post) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (pre ++ obj::post) /\ semaphore_id s = id) ->
          exists s, In s (pre ++ newobj::post) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
    unfold os_inv at 1. Intros_p Hw.
    unfold task_inv at 1. Intros_p Htask.
    assert (Htaskafter : task_world_wf after).
    { destruct Htask; constructor; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hsemvalue (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) pre obj post value).
    cancel (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj).
    subst W. apply_sepcon_adjoint.
    fold newobj.
    sep_apply_l_atomic (derivable1_wand_elim2
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> value)
      (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (pre ++ newobj::post))).
    sep_apply_l_atomic Hqueues.
    unfold os_inv, task_inv. unfold after, replace_semaphores.
    cbn [os_tasks os_semaphores os_dataqueues os_recycle os_idle os_isr os_mutexes os_events zombie_queue].
    fold after.
    change (tick_inv sg after) with (tick_inv sg st).
    change (delay_inv sg after) with (delay_inv sg st).
    change (assign_inv sg after) with (assign_inv sg st).
    change (exstatus_inv sg after) with (exstatus_inv sg st).
    split_pure_spatial.
    - sepcon_assoc_change; repeat progress cancel.
      match goal with |- ?P |-- _ => change (P |-- P) end. cancel.
    - split_pures; dump_pre_spatial; first [exact Htaskafter | apply Hworld; exact Hw]. }
  prop_apply_p (Hosinfo sg_semaphore_obtain_oc held). Intros_p Hinfoheld.
  destruct Hinfoheld as [Hnd Hvals].
  pose proof (proj1 (Forall_forall _ _) Hvals original PreH1) as Hv.
  destruct (in_split original (os_semaphores held) PreH1) as [pre [post Hss]].
  destruct (Z.eq_dec (semaphore_value original) 0) as [Hz|Hnz].
  - Left.
    assert (Heqobj : {| semaphore_addr:=semaphore_addr original; semaphore_id:=semaphore_id original;
       semaphore_value:=0; semaphore_pending_addrs:=semaphore_pending_addrs original |}=original).
    { destruct original; cbn in *; subst; reflexivity. }
    assert (Heqstate : replace_semaphores (pre ++ {| semaphore_addr:=semaphore_addr original; semaphore_id:=semaphore_id original;
       semaphore_value:=0; semaphore_pending_addrs:=semaphore_pending_addrs original |}::post) held = held).
    { rewrite Heqobj, <-Hss. destruct held; reflexivity. }
    pose proof (Hglobal sg_semaphore_obtain_oc held pre original post 0 Hss) as Hview.
    rewrite Heqstate, Hz in Hview.
    split_pure_spatial; [exact Hview|split_pures; dump_pre_spatial; auto].
  - Right.
    assert (Hnot : ~ In (semaphore_addr original) (map semaphore_addr pre ++ map semaphore_addr post)).
    { rewrite Hss, map_app in Hnd. cbn [map] in Hnd. exact (NoDup_remove_2 _ _ _ Hnd). }
    assert (Hident : forall xs, ~ In (semaphore_addr original) (map semaphore_addr xs) ->
      semaphore_set_value (semaphore_addr original) (semaphore_value original-1) xs = xs).
    { intros xs Hnotin. unfold semaphore_set_value. rewrite <- (map_id xs) at 2. apply map_ext_in. intros a Hin.
      destruct (Z.eq_dec (semaphore_addr a) (semaphore_addr original)); [exfalso;apply Hnotin;rewrite <- e;apply in_map;exact Hin|reflexivity]. }
    assert (Hset : semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held) =
       pre ++ {| semaphore_addr:=semaphore_addr original; semaphore_id:=semaphore_id original;
        semaphore_value:=semaphore_value original-1; semaphore_pending_addrs:=semaphore_pending_addrs original |}::post).
    { rewrite Hss. unfold semaphore_set_value at 1. rewrite map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr original) (semaphore_addr original)); [|contradiction].
      fold (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) pre).
      fold (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) post).
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    rewrite Hset.
    split_pure_spatial.
    + exact (Hglobal sg_semaphore_obtain_oc held pre original post (semaphore_value original-1) Hss).
    + split_pures; dump_pre_spatial. all: cbn in Hv; intuition lia.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial : _SemaphoreObtain_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem_value. apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6 : _SemaphoreObtain_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial : _SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros_p Hworld.
  assert (Hassign : assign_ptr (os_assign_stable sg_semaphore_obtain_oc) = &("Assign")).
  { pose proof (os_wf_context _ _ Hworld) as Hctx.
    unfold os_global_context, assign_context in Hctx; tauto. }
  unfold assign_inv. Intros_p Hawf. rewrite Hassign.
  csimpl. cancel (store_ptr (&(&("Assign") ->ₛ "os_running_task")) (assignRunningTask (os_assign held))). apply_sepcon_adjoint.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_ptr (&(&("Assign") ->ₛ "os_running_task")) task)
    (os_inv sg_semaphore_obtain_oc held)).
  cancel.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hseg : forall ns x px y py n, In n ns ->
    dllseg store_idnode x px y py (idnodes_to_dll ns) |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -*
      dllseg store_idnode x px y py (idnodes_to_dll ns))).
  { induction ns as [|a ns IH]; intros x px y py n Hin; [contradiction|].
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -*
      dllseg store_idnode x px y py (idnodes_to_dll (a::ns))) as W eqn:HW.
    cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Intros z.
    fold (dllseg store_idnode z x y py (idnodes_to_dll ns)).
    destruct Hin as [Heq|Hin].
    - subst n. unfold store_idnode at 1. Intros.
      cancel (store_ushort (&(((idnode_addr a)) # "IdNode" ->ₛ "id")) (idnode_id a)).
      subst W. apply_sepcon_adjoint.
      cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Exists z.
      unfold store_idnode. split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; tauto].
      all: cbn [idnode_to_dll getData getPtr]; cancel.
    - sep_apply_l_atomic (IH z x y py n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (dllseg store_idnode z x y py (idnodes_to_dll ns))).
      cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Exists z.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
      change (dllseg store_idnode z x y py (idnodes_to_dll ns) |-- dllseg store_idnode z x y py (idnodes_to_dll ns)). cancel.
  }
  assert (Hnodes : forall ns h n, In n ns ->
    store_idnodes h ns |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idnodes h ns)).
  { intros ns h n Hin.
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idnodes h ns) as W eqn:HW.
    unfold store_idnodes, store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (Hseg ns hd h h pt n Hin).
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    subst W. apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (dllseg store_idnode hd h h pt (idnodes_to_dll ns))).
    unfold store_idnodes, store_dll. Exists hd pt.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  }
  assert (Hbucket : forall ns h n, In n ns ->
    store_idbucket h ns |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket h ns)).
  { intros ns h n Hin. destruct ns as [|a ns]; [contradiction|].
    cbn [store_idbucket]. apply Hnodes. exact Hin. }
  assert (Hbuckets : forall bs ht idx n, In n (List.concat bs) ->
    store_idbucket_list ht idx bs |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket_list ht idx bs)).
  { induction bs as [|b bs IH]; intros ht idx n Hin; [contradiction|].
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket_list ht idx (b::bs)) as W eqn:HW.
    cbn [store_idbucket_list]. cbn [List.concat] in Hin. apply in_app_iff in Hin.
    destruct Hin as [Hin|Hin].
    - sep_apply_l_atomic (Hbucket b (ht + idx * sizeof("SysDoubleLinklistNode")) n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (store_idbucket (ht + idx * sizeof("SysDoubleLinklistNode")) b)).
      cbn [store_idbucket_list]. sepcon_assoc_change. cancel.
    - sep_apply_l_atomic (IH ht (idx+1) n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (store_idbucket_list ht (idx+1) bs)).
      cbn [store_idbucket_list]. sepcon_assoc_change. cancel.
  }
  assert (Hindexed : forall off bs start n,
    idbuckets_index_ok off start bs -> In n (List.concat bs) ->
    0 <= idnode_id n mod off - start < Zlength bs /\
    In n (Znth (idnode_id n mod off - start) bs nil)).
  { intros off bs; induction bs as [|b bs IH]; intros start n Hidx Hin; [contradiction|].
    cbn [idbuckets_index_ok] in Hidx. destruct Hidx as [Hb Hbs].
    cbn [List.concat] in Hin. apply in_app_iff in Hin. destruct Hin as [Hin|Hin].
    - apply Forall_forall with (x:=n) in Hb; [|exact Hin].
      rewrite Hb, Z.sub_diag. split.
      + rewrite Zlength_cons. pose proof (Zlength_nonneg bs); lia.
      + exact Hin.
    - specialize (IH (start+1) n Hbs Hin). destruct IH as [Hrange Hmem].
      split.
      + rewrite Zlength_cons. lia.
      + rewrite Znth_cons by lia.
        replace (idnode_id n mod off - start - 1) with (idnode_id n mod off - (start+1)) by lia. exact Hmem.
  }
  unfold os_inv at 1. unfold task_inv at 1. unfold store_idmanager at 1. Intros.
  assert (Ht : In task (task_ptr_list (os_tasks suspended))) by (eapply task_wf_map_present; eauto).
  assert (Hnodeaddr : In (&(task # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes suspended))).
  { eapply Permutation_in.
    - apply Permutation_sym. exact (task_wf_id_nodes suspended H0).
    - apply in_map_iff. exists task. split; [reflexivity|exact Ht]. }
  apply in_map_iff in Hnodeaddr. destruct Hnodeaddr as [n [Haddrn Hinn]].
  unfold task_id_nodes in Hinn.
  pose proof H1 as Hbok.
  destruct Hbok as [Hoff [Hlen [Hids [Hnodesok [Hindices Hperm]]]]].
  pose proof (Hindexed _ _ 0 n Hindices Hinn) as [_ Hmember].
  rewrite Z.sub_0_r in Hmember.
  assert (Hidin : In (idnode_id n) (idlist (task_idmanager_abs (os_tasks suspended)))).
  { eapply Permutation_in; [exact Hperm|]. unfold idnode_ids. apply in_map. exact Hinn. }
  assert (Hidrange : 0 <= idnode_id n < idmax (task_stable_ids (os_task_stable sg_semaphore_obtain_oc))).
  { pose proof (proj1 Hids) as Hrange. apply Forall_forall with (x:=idnode_id n) in Hrange; [exact Hrange|exact Hidin]. }
  assert (Hquery : get_task_with_idnode_success sg_semaphore_obtain_oc suspended (idnode_id n) task).
  { unfold get_task_with_idnode_success. split; [exact Hidrange|]. split.
    - apply id_in_ids_true_iff. exact Hidin.
    - exists (idnode_addr n). split; [exact Haddrn|]. split; [|exact Ht].
      destruct n; exact Hmember. }
  assert (Haddr : &(((idnode_addr n)) # "IdNode" ->ₛ "id") = &(task # "TaskDescriptor" ->ₛ "id" .ₛ "id")).
  { rewrite Haddrn. csimpl. reflexivity. }
  unfold store_idbuckets.
  sep_apply_l_atomic (Hbuckets (idbuckets (task_idmanager_abs (os_tasks suspended))) (htable (task_stable_ids (os_task_stable sg_semaphore_obtain_oc))) 0 n Hinn).
  prop_apply_p (valid_store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)). Intros.
  Exists (idnode_id n). split_pure_spatial.
  - rewrite <- Haddr.
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_obtain_oc))) 0
        (idbuckets (task_idmanager_abs (os_tasks suspended))))).
    unfold os_inv, task_inv, store_idmanager, store_idbuckets.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; lia.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (derivable1_wand_elim1 (store_ushort (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id")) rollback_id) (os_inv sg_semaphore_obtain_oc suspended)).
  cancel.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Qed.

