From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_1 : InitDataqueue_safety_wit_12_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_ushort_range (&("NodeNumber")) NodeNumber_pre).
  Intros_p Hrange.
  dump_pre_spatial.
  lia.
Qed.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_2 : InitDataqueue_safety_wit_12_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_ushort_range (&("NodeNumber")) NodeNumber_pre).
  Intros_p Hrange.
  dump_pre_spatial.
  lia.
Qed.

Lemma proof_of_InitDataqueue_safety_wit_12 : InitDataqueue_safety_wit_12.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_InitDataqueue_safety_wit_12_split_goal_1.
  Goal_apply proof_of_InitDataqueue_safety_wit_12_split_goal_2.
Qed.

Lemma proof_of_InitDataqueue_entail_wit_1 : InitDataqueue_entail_wit_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
prop_apply_p (store_ushort_range (&(p_queue_pre # "DataQueue" ->ₛ "max_len")) NodeNumber_pre).
Intros_p Hn.
pose proof dataqueue_layout_abi as Hlay.
destruct Hlay as [Hqsize [Hesize Hoff]].
unfold KTaskCNotation.sizeof_front_end_type in Hesize.
unfold sizeof_front_end_type in *.
rewrite Hesize in *.
assert (Hn32 : unsigned_last_nbits NodeNumber_pre 32 = NodeNumber_pre) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn32 in *.
assert (Hmul32 : unsigned_last_nbits (NodeNumber_pre*8) 32 = NodeNumber_pre*8) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hmul32 in *.
assert (Hnpos : 0 < NodeNumber_pre) by lia.
assert (Hbytes8 : forall p, addr_aligned p 4 -> (CharArray.undef_full p 8 |-- p # Ptr |->_ ** (p+4) # UInt |->_)).
{ intros p Ha.
unfold CharArray.undef_full, store_undef_array.
cbn [Z.to_nat store_undef_array_rec StoreCharAsElement.undefstoreA].
unfold poly_undef_store, undef_store_char, undef_store_uint, undef_store_ptr, undef_store_integer.
simpl_nonptr_sizeof.
change (Pos.to_nat 8) with 8%nat.
change (sizeof(PTR)) with 4.
change Arch.ptr_align with 4.
cbn [store_undef_array_rec undef_store_bytes].
repeat rewrite Z.add_0_r.
repeat rewrite Z.mul_1_r.
clear - p Ha.
Intros_p bH.
Intros_p bH0.
Intros_p bH1.
Intros_p bH2.
Intros_p bH3.
Intros_p bH4.
Intros_p bH5.
Intros_p bH6.
Intros_p bH7.
change (Z.to_nat 4) with 4%nat.
cbn [undef_store_bytes].
cbn in *.
split_pure_spatial.
- replace (p+1+1+1) with (p+3) by lia.
replace (p+1+1) with (p+2) by lia.
replace (p+4+1+1+1) with (p+7) by lia.
replace (p+4+1+1) with (p+6) by lia.
replace (p+4+1) with (p+5) by lia.
repeat progress cancel.
- split_pures; dump_pre_spatial; unfold valid_object, valid_addr_range, aligned, addr_aligned in *; cbn in *; repeat split; try lia.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
}

assert (Hslot : forall p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) 8 |-- dataqueue_slot p i None)).
{ clear - Hbytes8.
intros p i Ha.
unfold dataqueue_slot.
pose proof (proj2 (proj2 dataqueue_layout_abi) (p+i*8)) as Ho.
destruct Ho as [_ [_ [_ [_ [_ [_ [Hd Hl]]]]]]].
rewrite Hd,Hl.
apply Hbytes8.
unfold addr_aligned in *.
rewrite Z.add_mod,Z.mul_mod by lia.
rewrite Ha.
cbn.
rewrite Z.mul_0_r.
reflexivity.
}
 assert (Halloc : forall k p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) (Z.of_nat k*8) |-- store_array_rec dataqueue_slot p i (i+Z.of_nat k) (repeat None k))).
{ clear - Hslot.
induction k; intros p i Ha.
- cbn [repeat store_array_rec Z.of_nat].
unfold CharArray.undef_full,store_undef_array.
replace (0*8) with 0 by lia.
cbn [Z.to_nat store_undef_array_rec].
Intros.
split_pure_spatial.
+ repeat progress cancel.
+ split_pures; dump_pre_spatial; first [reflexivity | lia].
- cbn [repeat store_array_rec].
sep_apply_l_atomic (CharArray.undef_full_split_to_undef_full (p+i*8) 8 (Z.of_nat (S k)*8) ltac:(lia)).
replace (Z.of_nat (S k)*8-8) with (Z.of_nat k*8) by lia.
sep_apply_l_atomic (Hslot p i Ha).
unfold sizeof_front_end_type.
replace (p+i*8+8*1) with (p+(i+1)*8) by lia.
sep_apply_l_atomic (IHk p (i+1) Ha).
replace (i+Z.of_nat (S k)) with (i+1+Z.of_nat k) by lia.
repeat progress cancel.
}
 assert (Hn16 : unsigned_last_nbits (NodeNumber_pre-1) 16 = NodeNumber_pre-1) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn16 in *.
pose proof (Halloc (Z.to_nat NodeNumber_pre) retval_2 0 PreH13) as Hbuf.
rewrite Z2Nat.id in Hbuf by lia.
replace (retval_2+0*8) with retval_2 in Hbuf by lia.
replace (0+NodeNumber_pre) with NodeNumber_pre in Hbuf by lia.
sep_apply_l_atomic Hbuf.
set (q := dataqueue_constructed NodeNumber_pre retval_2 retval_3 retval_4).
assert (Hfold : (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre)) **
(&(p_queue_pre # "DataQueue" ->ₛ "front")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "rear")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "max_len")) # UShort |-> NodeNumber_pre **
(&(p_queue_pre # "DataQueue" ->ₛ "base")) # Ptr |-> retval_2 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_blank")) # Int |-> retval_3 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_data")) # Int |-> retval_4 **
CharArray.undef_full (p_queue_pre+6) 2) |-- store_dataqueue p_queue_pre q).
{ unfold q,store_dataqueue,dataqueue_fields,dataqueue_buffer,dataqueue_constructed.
cbn [dq_base dq_max_len dq_front dq_rear dq_sem_blank dq_sem_data dq_slots].
destruct (Z.eq_dec retval_2 0); [contradiction |].
split_pure_spatial.
- unfold store_array.
repeat progress cancel.
cancel (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre))).
cancel (CharArray.undef_full (p_queue_pre+6) 2).
repeat progress cancel.

- split_pures; dump_pre_spatial; tauto.
}
replace (p_queue_pre+6*1) with (p_queue_pre+6) by lia.
sep_apply_l_atomic Hfold.
assert (Hfresh : forall sg st p q, os_inv sg st ** store_dataqueue p q |-- “ dataqueue_map (os_dataqueues st) p = None ”).
{ clear.
intros sg st p q.
unfold os_inv, dataqueue_inv.
Intros.
destruct (dataqueue_map (os_dataqueues st) p) as [old|] eqn:Hlookup.
- sep_apply_l_atomic (store_map_split store_dataqueue p old (dataqueue_map (os_dataqueues st)) Hlookup).
unfold store_dataqueue,dataqueue_fields.
Intros.

sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "DataQueue" ->ₛ "front")) (dq_front old)).
sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "DataQueue" ->ₛ "front")) (dq_front q)).
sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(p # "DataQueue" ->ₛ "front")) ltac:(lia)).
Intros_p Hbad.
contradiction.
- dump_pre_spatial.
reflexivity.
}
prop_apply_p (Hfresh sg after_3 p_queue_pre q).
Intros_p Hnone.

destruct PreH8 as [[Hfail Hsame]|[blankp [Hbp [Hbpa [Hbfresh [Hbmin Hfirst]]]]]]; [lia|].
destruct PreH4 as [[Hfail Hsame]|[datap [Hdp [Hdpa [Hdfresh [Hdmin Hsecond]]]]]]; [lia|].
assert (Hblankref : dataqueue_sem_ref retval_3 (Some blankp) (os_semaphores after_2)).
{ split; [lia|].
exists (semaphore_created blankp retval_3 (NodeNumber_pre-1)).
rewrite Hfirst.
cbn [replace_semaphores semaphore_publish os_semaphores semaphore_created semaphore_addr semaphore_id semaphore_pending_addrs].
split; [left; reflexivity|].
repeat split; reflexivity.
}
assert (Hdataref : dataqueue_sem_ref retval_4 (Some datap) (os_semaphores after_3)).
{ split; [lia|].
exists (semaphore_created datap retval_4 0).
rewrite Hsecond.
cbn [replace_semaphores semaphore_publish os_semaphores semaphore_created semaphore_addr semaphore_id semaphore_pending_addrs].
split; [left; reflexivity|].
repeat split; reflexivity.
}

assert (Hdistinct : retval_3 <> retval_4).
{ intro Heq.
pose proof (proj1 (proj2 Hdmin)) as Hquery.
rewrite Hfirst in Hquery.
unfold semaphore_manager,IDNode.idmanager_query in Hquery.
cbn [replace_semaphores os_semaphores semaphore_publish map semaphore_created semaphore_id idlist IDNode.id_in_ids] in Hquery.
rewrite Heq in Hquery.
unfold IDNode.id_in_ids in Hquery.
cbn in Hquery.

destruct (Z.eq_dec retval_4 retval_4); [discriminate|contradiction].
}
assert (Hassoc : dataqueue_semaphores (os_semaphores after_3) q).
{ unfold dataqueue_semaphores,q,dataqueue_constructed.
cbn [dq_sem_blank dq_sem_data].
split.
- exists (semaphore_created blankp retval_3 (NodeNumber_pre-1)).
rewrite Hsecond,Hfirst.
cbn [replace_semaphores os_semaphores semaphore_publish].
split; [right;left;reflexivity|reflexivity].
- destruct Hdataref as [_ [s [Hs [_ [Hid _]]]]].
exists s.
auto.
}
assert (Hready : dataqueue_ready q).
{ unfold dataqueue_ready,q,dataqueue_constructed.
cbn [dq_base dq_max_len dq_front dq_rear dq_sem_blank dq_sem_data dq_slots].
destruct (Z.eq_dec retval_2 0); [contradiction|].
repeat split; try lia; try assumption.
- rewrite repeat_length,Z2Nat.id by lia.
reflexivity.
- unfold dataqueue_contents,dataqueue_count.
cbn [dq_base dq_max_len dq_front dq_rear dq_sem_blank dq_sem_data dq_slots].
rewrite Z.mod_same by lia.
constructor.
}
assert (Hpub : forall sg st p q,
dataqueue_map (os_dataqueues st) p = None -> dataqueue_ready q -> dataqueue_semaphores (os_semaphores st) q ->
os_inv sg st ** store_dataqueue p q |-- os_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)).
{ clear.
intros sg st p q Hnone Hready Hassoc.
unfold os_inv,dataqueue_inv.
cbn [replace_dataqueues].
Intros.
split_pure_spatial.
- assert (Htf : forall sg st qs, task_inv sg st |-- task_inv sg (replace_dataqueues qs st)).
{ clear.
intros sg st qs.
unfold task_inv.
Intros_p Htw.
split_pure_spatial.
- cbn [replace_dataqueues].
repeat progress cancel.

unfold replace_dataqueues.
cbn.
cancel (store_map store_published_task (task_desc_map (os_tasks st))).
repeat progress cancel.
- dump_pre_spatial.
destruct Htw.
constructor; cbn; assumption.
}

sep_apply_l_atomic (Htf sg st (dataqueue_publish p q (os_dataqueues st))).
cancel (task_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)).
change (tick_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (tick_inv sg st).
change (delay_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (delay_inv sg st).
change (assign_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (assign_inv sg st).
change (exstatus_inv sg (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (exstatus_inv sg st).
cbv beta iota zeta delta [replace_dataqueues os_tasks zombie_queue os_recycle os_idle os_isr os_semaphores os_mutexes os_events os_dataqueues].
cancel (tick_inv sg st).
cancel (delay_inv sg st).
cancel (assign_inv sg st).
cancel store_prio_lookup_table.
cancel (store_zombie_queue (task_desc_map (os_tasks st)) (os_zombie_head sg) (zombie_queue st)).
cancel (os_recycler_slot sg # Int |-> service_id (os_recycle st)).
cancel (IntArray.full (os_idle_array sg) CORE_COUNT (map service_id (os_idle st))).
cancel (isrmanager_inv (os_isr_stable sg) (os_isr st)).
cancel (exstatus_inv sg st).
cancel (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)).
cancel (mutex_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_mutex_stable sg) (os_mutexes st)).
cancel (event_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_event_stable sg) (os_events st)).

fold (os_dataqueues st).
set (oldm := dataqueue_map (os_dataqueues st)).
set (newm := dataqueue_map (dataqueue_publish p q (os_dataqueues st))).
assert (Hnew : newm p = Some q).
{ unfold newm,dataqueue_publish.
cbn [dataqueue_map].
destruct (Z.eq_dec p p); [reflexivity|contradiction].
}
assert (Hmaps : forall key, key <> p -> oldm key = newm key).
{ intros key Hneq.
unfold oldm,newm,dataqueue_publish.
cbn [dataqueue_map].
destruct (Z.eq_dec key p); [contradiction|reflexivity].
}
sep_apply_l_atomic (store_map_equiv_store_map_missing store_dataqueue oldm p Hnone).
rewrite (store_map_missing_i_equiv store_dataqueue oldm newm p Hmaps).
sep_apply_l_atomic (store_map_merge store_dataqueue p q newm Hnew).
repeat progress cancel.
- split_pures; dump_pre_spatial.
+ destruct H.
assert (Hsf : forall st qs entry slot, service_slot_wf st entry slot -> service_slot_wf (replace_dataqueues qs st) entry slot).
{ clear.
intros st qs entry slot Hw.
unfold service_slot_wf in *.
destruct (service_phase slot); try assumption.
destruct Hw as [desc Hw].
exists desc.
destruct Hw.
constructor; assumption.
}
constructor.
* exact os_wf_context.
* change (os_recycle (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (os_recycle st).
apply Hsf.
exact os_wf_recycler.
* change (os_idle (replace_dataqueues (dataqueue_publish p q (os_dataqueues st)) st)) with (os_idle st).
eapply Forall_impl; [|exact os_wf_idle].
intros slot Hw.
apply Hsf.
exact Hw.
* change (NoDup (os_sched_owners st)).
exact os_wf_sched_nodup.
* change (forall task, In task (os_sched_owners st) <-> task_desc_map (os_tasks st) task <> None).
exact os_wf_sched_domain.
+ intros key v Hlook.
change (dataqueue_map (dataqueue_publish p q (os_dataqueues st)) key = Some v) in Hlook.
unfold dataqueue_publish in Hlook.
cbn [dataqueue_map] in Hlook.
destruct (Z.eq_dec key p).
* inversion Hlook; subst.
auto.
* eapply H0; eauto.
}

set (post := replace_dataqueues (dataqueue_publish p_queue_pre q (os_dataqueues after_3)) after_3).
sep_apply_l_atomic (Hpub sg after_3 p_queue_pre q Hnone Hready Hassoc).
Exists q post.
split_pure_spatial.
- cancel (InsideCritical sg observed).
repeat progress cancel.
fold post.
cancel (os_inv sg post).
- split_pures; dump_pre_spatial.
+ unfold post,replace_dataqueues,dataqueue_publish.
cbn [os_dataqueues dataqueue_map].
destruct (Z.eq_dec p_queue_pre p_queue_pre); [reflexivity|contradiction].
+ reflexivity.
+ reflexivity.
+ reflexivity.
+ exact PreH9.
+ exact PreH6.
+ exact PreH2.
+ exact Hdistinct.
+ unfold abs_init_dataqueue in PreH25 at 1.
prog_nf in PreH25.

set (a := {| dq_attempt_object := q; dq_attempt_refs := (Some blankp,Some datap) |}).
assert (Hsucc : dataqueue_attempt_succeeded a = true).
{ unfold dataqueue_attempt_succeeded,a,q,dataqueue_constructed.
cbn [dq_attempt_object dq_sem_blank dq_sem_data].
apply andb_true_iff.
split; apply Z.leb_le; lia.
}
assert (Hcreate1 : semaphore_create_ic_effect sg (NodeNumber_pre-1) observed retval_3 after_2).
{ right.
exists blankp.
tauto.
}
assert (Hcreate2 : semaphore_create_ic_effect sg 0 after_2 retval_4 after_3).
{ right.
exists datap.
tauto.
}
assert (Hphase : dataqueue_init_phase_effect sg p_queue_pre NodeNumber_pre observed a post).
{ right.
exists retval_2,retval_3,after_2.
split; [exact Hnpos|].
split; [exact PreH9|].
split; [exact PreH13|].
split; [exact Hcreate1|].
right.
split; [exact PreH6|].
exists blankp,retval_4,after_3.
split; [exact Hblankref|].
split; [exact Hcreate2|].
right.
split; [exact PreH2|].
exists datap.
split; [exact Hdataref|].
split; [reflexivity|].
split; [exact Hnone|].
reflexivity.
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_init_dataqueue_phase sg p_queue_pre NodeNumber_pre)) (LastSeen before) (LastSeen post) a).
{ intros states Hseen.
exists (Crtos_RTrans post).
split.
- cbn [os_atomic_cmd abs_init_dataqueue_phase MonadErr.nrm].
exists observed,post.
split.
+ apply Hseen.
exact PreH22.
+ split; [exact Hphase|].
reflexivity.
- unfold LastSeen.
reflexivity.
}
pose proof (highstepbind_derive _ _ _ a (LastSeen post) Hstep X PreH25) as Hnext.
cbv beta in Hnext.
rewrite Hsucc in Hnext.
exact Hnext.
Qed.

Lemma proof_of_InitDataqueue_entail_wit_2_1 : InitDataqueue_entail_wit_2_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Right.
subst retval_2.
set (q := dataqueue_constructed NodeNumber_pre 0 (-1) (-1)).
Exists observed observed ((None,None):DataqueueSemRefs) (fun (_:unit) states => X (-1) states) q.
split_pure_spatial.
- unfold store_dataqueue, dataqueue_fields, dataqueue_buffer, q, dataqueue_constructed.
cbn [dq_base dq_slots dq_front dq_rear dq_max_len dq_sem_blank dq_sem_data].
split_pure_spatial.
+ repeat progress cancel.
destruct (Z.eq_dec 0 0); [|contradiction].
change (6 * sizeof(CHAR)) with 6.
split_pure_spatial.
* repeat progress cancel.
* split_pures; dump_pre_spatial; reflexivity.
+ split_pures; dump_pre_spatial; auto.
- split_pures; dump_pre_spatial.
all: try reflexivity.
set (a := {| dq_attempt_object := q; dq_attempt_refs := ((None,None):DataqueueSemRefs) |}).
assert (Hstep : hs_eval (os_atomic_cmd (abs_init_dataqueue_phase sg p_queue_pre NodeNumber_pre)) (LastSeen before) (LastSeen observed) a).
{ intros states Hseen.
exists (Crtos_RTrans observed).
split.
- cbn [os_atomic_cmd abs_init_dataqueue_phase MonadErr.nrm].
exists observed, observed.
split; [apply Hseen; exact PreH12|].
split; [left; split; reflexivity|reflexivity].
- unfold LastSeen.
reflexivity.
}
unfold abs_init_dataqueue in PreH15 at 1.
prog_nf in PreH15.
pose proof (highstepbind_derive _ _ _ a (LastSeen observed) Hstep X PreH15) as Hnext.
cbn [a q dataqueue_constructed dataqueue_attempt_succeeded dq_attempt_object dq_attempt_refs dq_sem_blank dq_sem_data] in Hnext.
assert (Hfail : dataqueue_attempt_succeeded a = false) by reflexivity.
rewrite Hfail in Hnext.
unfold safeExec, safe in Hnext |- *.
destruct Hnext as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
rewrite wp_bind in Hwp.
destruct Hwp as [Herr Hnormal].
split; [exact Herr|].
intros u st Hu.
specialize (Hnormal u st Hu).
apply (proj1 (wp_ret (-1) X st)).
exact Hnormal.
intros final Hret.
unfold safeExec, safe in Hret |- *.
destruct Hret as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
apply (proj2 (wp_ret (-1) X states)).
apply (proj1 (wp_ret tt (fun (_:unit) states => X (-1) states) states)).
exact Hwp.
Qed.

Lemma proof_of_InitDataqueue_entail_wit_2_2 : InitDataqueue_entail_wit_2_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Right.
subst retval_2.
set (q := dataqueue_constructed NodeNumber_pre 0 (-1) (-1)).
Exists observed observed ((None,None):DataqueueSemRefs) (fun (_:unit) states => X (-1) states) q.
split_pure_spatial.
- unfold store_dataqueue, dataqueue_fields, dataqueue_buffer, q, dataqueue_constructed.
cbn [dq_base dq_slots dq_front dq_rear dq_max_len dq_sem_blank dq_sem_data].
split_pure_spatial.
+ repeat progress cancel.
destruct (Z.eq_dec 0 0); [|contradiction].
change (6 * sizeof(CHAR)) with 6.
split_pure_spatial.
* repeat progress cancel.
* split_pures; dump_pre_spatial; reflexivity.
+ split_pures; dump_pre_spatial; auto.
- split_pures; dump_pre_spatial.
all: try reflexivity.
set (a := {| dq_attempt_object := q; dq_attempt_refs := ((None,None):DataqueueSemRefs) |}).
assert (Hstep : hs_eval (os_atomic_cmd (abs_init_dataqueue_phase sg p_queue_pre NodeNumber_pre)) (LastSeen before) (LastSeen observed) a).
{ intros states Hseen.
exists (Crtos_RTrans observed).
split.
- cbn [os_atomic_cmd abs_init_dataqueue_phase MonadErr.nrm].
exists observed, observed.
split; [apply Hseen; exact PreH12|].
split; [left; split; reflexivity|reflexivity].
- unfold LastSeen.
reflexivity.
}
unfold abs_init_dataqueue in PreH15 at 1.
prog_nf in PreH15.
pose proof (highstepbind_derive _ _ _ a (LastSeen observed) Hstep X PreH15) as Hnext.
cbn [a q dataqueue_constructed dataqueue_attempt_succeeded dq_attempt_object dq_attempt_refs dq_sem_blank dq_sem_data] in Hnext.
assert (Hfail : dataqueue_attempt_succeeded a = false) by reflexivity.
rewrite Hfail in Hnext.
unfold safeExec, safe in Hnext |- *.
destruct Hnext as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
rewrite wp_bind in Hwp.
destruct Hwp as [Herr Hnormal].
split; [exact Herr|].
intros u st Hu.
specialize (Hnormal u st Hu).
apply (proj1 (wp_ret (-1) X st)).
exact Hnormal.
intros final Hret.
unfold safeExec, safe in Hret |- *.
destruct Hret as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
apply (proj2 (wp_ret (-1) X states)).
apply (proj1 (wp_ret tt (fun (_:unit) states => X (-1) states) states)).
exact Hwp.
Qed.

Lemma proof_of_InitDataqueue_entail_wit_2_3 : InitDataqueue_entail_wit_2_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
prop_apply_p (store_ushort_range (&(p_queue_pre # "DataQueue" ->ₛ "max_len")) NodeNumber_pre).
Intros_p Hn.
pose proof dataqueue_layout_abi as Hlay.
destruct Hlay as [Hqsize [Hesize Hoff]].
unfold KTaskCNotation.sizeof_front_end_type in Hesize.
unfold sizeof_front_end_type in *.
rewrite Hesize in *.
assert (Hn32 : unsigned_last_nbits NodeNumber_pre 32 = NodeNumber_pre) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn32 in *.
assert (Hmul32 : unsigned_last_nbits (NodeNumber_pre*8) 32 = NodeNumber_pre*8) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hmul32 in *.
assert (Hnpos : 0 < NodeNumber_pre) by lia.
assert (Hbytes8 : forall p, addr_aligned p 4 -> (CharArray.undef_full p 8 |-- p # Ptr |->_ ** (p+4) # UInt |->_)).
{ intros p Ha.
unfold CharArray.undef_full, store_undef_array.
cbn [Z.to_nat store_undef_array_rec StoreCharAsElement.undefstoreA].
unfold poly_undef_store, undef_store_char, undef_store_uint, undef_store_ptr, undef_store_integer.
simpl_nonptr_sizeof.
change (Pos.to_nat 8) with 8%nat.
change (sizeof(PTR)) with 4.
change Arch.ptr_align with 4.
cbn [store_undef_array_rec undef_store_bytes].
repeat rewrite Z.add_0_r.
repeat rewrite Z.mul_1_r.
clear - p Ha.
Intros_p bH.
Intros_p bH0.
Intros_p bH1.
Intros_p bH2.
Intros_p bH3.
Intros_p bH4.
Intros_p bH5.
Intros_p bH6.
Intros_p bH7.
change (Z.to_nat 4) with 4%nat.
cbn [undef_store_bytes].
cbn in *.
split_pure_spatial.
- replace (p+1+1+1) with (p+3) by lia.
replace (p+1+1) with (p+2) by lia.
replace (p+4+1+1+1) with (p+7) by lia.
replace (p+4+1+1) with (p+6) by lia.
replace (p+4+1) with (p+5) by lia.
repeat progress cancel.
- split_pures; dump_pre_spatial; unfold valid_object, valid_addr_range, aligned, addr_aligned in *; cbn in *; repeat split; try lia.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
}

assert (Hslot : forall p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) 8 |-- dataqueue_slot p i None)).
{ clear - Hbytes8.
intros p i Ha.
unfold dataqueue_slot.
pose proof (proj2 (proj2 dataqueue_layout_abi) (p+i*8)) as Ho.
destruct Ho as [_ [_ [_ [_ [_ [_ [Hd Hl]]]]]]].
rewrite Hd,Hl.
apply Hbytes8.
unfold addr_aligned in *.
rewrite Z.add_mod,Z.mul_mod by lia.
rewrite Ha.
cbn.
rewrite Z.mul_0_r.
reflexivity.
}
 assert (Halloc : forall k p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) (Z.of_nat k*8) |-- store_array_rec dataqueue_slot p i (i+Z.of_nat k) (repeat None k))).
{ clear - Hslot.
induction k; intros p i Ha.
- cbn [repeat store_array_rec Z.of_nat].
unfold CharArray.undef_full,store_undef_array.
replace (0*8) with 0 by lia.
cbn [Z.to_nat store_undef_array_rec].
Intros.
split_pure_spatial.
+ repeat progress cancel.
+ split_pures; dump_pre_spatial; first [reflexivity | lia].
- cbn [repeat store_array_rec].
sep_apply_l_atomic (CharArray.undef_full_split_to_undef_full (p+i*8) 8 (Z.of_nat (S k)*8) ltac:(lia)).
replace (Z.of_nat (S k)*8-8) with (Z.of_nat k*8) by lia.
sep_apply_l_atomic (Hslot p i Ha).
unfold sizeof_front_end_type.
replace (p+i*8+8*1) with (p+(i+1)*8) by lia.
sep_apply_l_atomic (IHk p (i+1) Ha).
replace (i+Z.of_nat (S k)) with (i+1+Z.of_nat k) by lia.
repeat progress cancel.
}
 assert (Hn16 : unsigned_last_nbits (NodeNumber_pre-1) 16 = NodeNumber_pre-1) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn16 in *.
pose proof (Halloc (Z.to_nat NodeNumber_pre) retval_2 0 PreH8) as Hbuf.
rewrite Z2Nat.id in Hbuf by lia.
replace (retval_2+0*8) with retval_2 in Hbuf by lia.
replace (0+NodeNumber_pre) with NodeNumber_pre in Hbuf by lia.
sep_apply_l_atomic Hbuf.

set (q := dataqueue_constructed NodeNumber_pre retval_2 retval_3 (-1)).
assert (Hfold : (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre)) **
(&(p_queue_pre # "DataQueue" ->ₛ "front")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "rear")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "max_len")) # UShort |-> NodeNumber_pre **
(&(p_queue_pre # "DataQueue" ->ₛ "base")) # Ptr |-> retval_2 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_blank")) # Int |-> retval_3 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_data")) # Int |-> (-1) **
CharArray.undef_full (p_queue_pre+6) 2) |-- store_dataqueue p_queue_pre q).
{ unfold q,store_dataqueue,dataqueue_fields,dataqueue_buffer,dataqueue_constructed.
cbn [dq_base dq_max_len dq_front dq_rear dq_sem_blank dq_sem_data dq_slots].
destruct (Z.eq_dec retval_2 0); [contradiction |].
split_pure_spatial.
- unfold store_array.
repeat progress cancel.
cancel (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre))).
cancel (CharArray.undef_full (p_queue_pre+6) 2).
repeat progress cancel.

- split_pures; dump_pre_spatial; tauto.
}
replace (p_queue_pre+6*1) with (p_queue_pre+6) by lia.
sep_apply_l_atomic Hfold.

Left.
Right.
Exists observed after_2 ((None,None):DataqueueSemRefs) (fun (_:unit) states => X (-1) states) q.
split_pure_spatial.
- repeat progress cancel.
- split_pures; dump_pre_spatial.
all: try reflexivity.
exact PreH2.
set (a := {| dq_attempt_object := q; dq_attempt_refs := ((None,None):DataqueueSemRefs) |}).
assert (Hphase : dataqueue_init_phase_effect sg p_queue_pre NodeNumber_pre observed a after_2).
{ right. exists retval_2,retval_3,after_2.
split; [exact Hnpos|].
split; [exact PreH4|].
split; [exact PreH8|].
split; [exact PreH3|].
left. split; [exact PreH2|]. split; reflexivity.
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_init_dataqueue_phase sg p_queue_pre NodeNumber_pre)) (LastSeen before) (LastSeen after_2) a).
{ intros states Hseen.
exists (Crtos_RTrans after_2).
split.
- cbn [os_atomic_cmd abs_init_dataqueue_phase MonadErr.nrm].
exists observed,after_2.
split; [apply Hseen; exact PreH17|].
split; [exact Hphase|reflexivity].
- unfold LastSeen. reflexivity.
}
unfold abs_init_dataqueue in PreH20 at 1.
prog_nf in PreH20.
pose proof (highstepbind_derive _ _ _ a (LastSeen after_2) Hstep X PreH20) as Hnext.
cbv beta in Hnext.
assert (Hfail : dataqueue_attempt_succeeded a = false).
{ unfold a,q,dataqueue_attempt_succeeded,dataqueue_constructed.
cbn [dq_attempt_object dq_sem_blank dq_sem_data].
rewrite PreH2. reflexivity.
}
rewrite Hfail in Hnext.
unfold safeExec, safe in Hnext |- *.
destruct Hnext as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
rewrite wp_bind in Hwp.
destruct Hwp as [Herr Hnormal].
split; [exact Herr|].
intros u st Hu.
specialize (Hnormal u st Hu).
apply (proj1 (wp_ret (-1) X st)).
exact Hnormal.
intros final Hret.
unfold safeExec, safe in Hret |- *.
destruct Hret as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
apply (proj2 (wp_ret (-1) X states)).
apply (proj1 (wp_ret tt (fun (_:unit) states => X (-1) states) states)).
exact Hwp.
Qed.

Lemma proof_of_InitDataqueue_entail_wit_2_4 : InitDataqueue_entail_wit_2_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
prop_apply_p (store_ushort_range (&(p_queue_pre # "DataQueue" ->ₛ "max_len")) NodeNumber_pre).
Intros_p Hn.
pose proof dataqueue_layout_abi as Hlay.
destruct Hlay as [Hqsize [Hesize Hoff]].
unfold KTaskCNotation.sizeof_front_end_type in Hesize.
unfold sizeof_front_end_type in *.
rewrite Hesize in *.
assert (Hn32 : unsigned_last_nbits NodeNumber_pre 32 = NodeNumber_pre) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn32 in *.
assert (Hmul32 : unsigned_last_nbits (NodeNumber_pre*8) 32 = NodeNumber_pre*8) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hmul32 in *.
assert (Hnpos : 0 < NodeNumber_pre) by lia.
assert (Hbytes8 : forall p, addr_aligned p 4 -> (CharArray.undef_full p 8 |-- p # Ptr |->_ ** (p+4) # UInt |->_)).
{ intros p Ha.
unfold CharArray.undef_full, store_undef_array.
cbn [Z.to_nat store_undef_array_rec StoreCharAsElement.undefstoreA].
unfold poly_undef_store, undef_store_char, undef_store_uint, undef_store_ptr, undef_store_integer.
simpl_nonptr_sizeof.
change (Pos.to_nat 8) with 8%nat.
change (sizeof(PTR)) with 4.
change Arch.ptr_align with 4.
cbn [store_undef_array_rec undef_store_bytes].
repeat rewrite Z.add_0_r.
repeat rewrite Z.mul_1_r.
clear - p Ha.
Intros_p bH.
Intros_p bH0.
Intros_p bH1.
Intros_p bH2.
Intros_p bH3.
Intros_p bH4.
Intros_p bH5.
Intros_p bH6.
Intros_p bH7.
change (Z.to_nat 4) with 4%nat.
cbn [undef_store_bytes].
cbn in *.
split_pure_spatial.
- replace (p+1+1+1) with (p+3) by lia.
replace (p+1+1) with (p+2) by lia.
replace (p+4+1+1+1) with (p+7) by lia.
replace (p+4+1+1) with (p+6) by lia.
replace (p+4+1) with (p+5) by lia.
repeat progress cancel.
- split_pures; dump_pre_spatial; unfold valid_object, valid_addr_range, aligned, addr_aligned in *; cbn in *; repeat split; try lia.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
}

assert (Hslot : forall p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) 8 |-- dataqueue_slot p i None)).
{ clear - Hbytes8.
intros p i Ha.
unfold dataqueue_slot.
pose proof (proj2 (proj2 dataqueue_layout_abi) (p+i*8)) as Ho.
destruct Ho as [_ [_ [_ [_ [_ [_ [Hd Hl]]]]]]].
rewrite Hd,Hl.
apply Hbytes8.
unfold addr_aligned in *.
rewrite Z.add_mod,Z.mul_mod by lia.
rewrite Ha.
cbn.
rewrite Z.mul_0_r.
reflexivity.
}
 assert (Halloc : forall k p i, addr_aligned p 4 -> (CharArray.undef_full (p+i*8) (Z.of_nat k*8) |-- store_array_rec dataqueue_slot p i (i+Z.of_nat k) (repeat None k))).
{ clear - Hslot.
induction k; intros p i Ha.
- cbn [repeat store_array_rec Z.of_nat].
unfold CharArray.undef_full,store_undef_array.
replace (0*8) with 0 by lia.
cbn [Z.to_nat store_undef_array_rec].
Intros.
split_pure_spatial.
+ repeat progress cancel.
+ split_pures; dump_pre_spatial; first [reflexivity | lia].
- cbn [repeat store_array_rec].
sep_apply_l_atomic (CharArray.undef_full_split_to_undef_full (p+i*8) 8 (Z.of_nat (S k)*8) ltac:(lia)).
replace (Z.of_nat (S k)*8-8) with (Z.of_nat k*8) by lia.
sep_apply_l_atomic (Hslot p i Ha).
unfold sizeof_front_end_type.
replace (p+i*8+8*1) with (p+(i+1)*8) by lia.
sep_apply_l_atomic (IHk p (i+1) Ha).
replace (i+Z.of_nat (S k)) with (i+1+Z.of_nat k) by lia.
repeat progress cancel.
}
 assert (Hn16 : unsigned_last_nbits (NodeNumber_pre-1) 16 = NodeNumber_pre-1) by (apply unsigned_last_nbits_eq; cbn; lia).
rewrite Hn16 in *.
pose proof (Halloc (Z.to_nat NodeNumber_pre) retval_2 0 PreH12) as Hbuf.
rewrite Z2Nat.id in Hbuf by lia.
replace (retval_2+0*8) with retval_2 in Hbuf by lia.
replace (0+NodeNumber_pre) with NodeNumber_pre in Hbuf by lia.
sep_apply_l_atomic Hbuf.

set (q := dataqueue_constructed NodeNumber_pre retval_2 retval_3 retval_4).
assert (Hfold : (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre)) **
(&(p_queue_pre # "DataQueue" ->ₛ "front")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "rear")) # UShort |-> 0 **
(&(p_queue_pre # "DataQueue" ->ₛ "max_len")) # UShort |-> NodeNumber_pre **
(&(p_queue_pre # "DataQueue" ->ₛ "base")) # Ptr |-> retval_2 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_blank")) # Int |-> retval_3 **
(&(p_queue_pre # "DataQueue" ->ₛ "sem_data")) # Int |-> retval_4 **
CharArray.undef_full (p_queue_pre+6) 2) |-- store_dataqueue p_queue_pre q).
{ unfold q,store_dataqueue,dataqueue_fields,dataqueue_buffer,dataqueue_constructed.
cbn [dq_base dq_max_len dq_front dq_rear dq_sem_blank dq_sem_data dq_slots].
destruct (Z.eq_dec retval_2 0); [contradiction |].
split_pure_spatial.
- unfold store_array.
repeat progress cancel.
cancel (store_array_rec dataqueue_slot retval_2 0 NodeNumber_pre (repeat None (Z.to_nat NodeNumber_pre))).
cancel (CharArray.undef_full (p_queue_pre+6) 2).
repeat progress cancel.

- split_pures; dump_pre_spatial; tauto.
}
replace (p_queue_pre+6*1) with (p_queue_pre+6) by lia.
sep_apply_l_atomic Hfold.

pose proof PreH7 as Hcreate1.
destruct PreH7 as [[Hfail Hsame]|[blankp [Hbp [Hbpa [Hbfresh [Hbmin Hfirst]]]]]]; [lia|].
assert (Hblankref : dataqueue_sem_ref retval_3 (Some blankp) (os_semaphores after_2)).
{ split; [lia|].
exists (semaphore_created blankp retval_3 (NodeNumber_pre-1)).
rewrite Hfirst.
cbn [replace_semaphores semaphore_publish os_semaphores semaphore_created semaphore_addr semaphore_id semaphore_pending_addrs].
split; [left; reflexivity|].
repeat split; reflexivity.
}
Left. Left.
Exists observed after_3 ((Some blankp,None):DataqueueSemRefs) (fun (_:unit) states => X (-1) states) q.
split_pure_spatial.
- repeat progress cancel.
- split_pures; dump_pre_spatial.
all: try reflexivity.
exact PreH5.
exact PreH2.
set (a := {| dq_attempt_object := q; dq_attempt_refs := ((Some blankp,None):DataqueueSemRefs) |}).
assert (Hphase : dataqueue_init_phase_effect sg p_queue_pre NodeNumber_pre observed a after_3).
{ right. exists retval_2,retval_3,after_2.
split; [exact Hnpos|].
split; [exact PreH8|].
split; [exact PreH12|].
split; [exact Hcreate1|].
right. split; [exact PreH5|].
exists blankp,retval_4,after_3.
split; [exact Hblankref|].
split; [exact PreH3|].
left. split; [exact PreH2|]. split; reflexivity.
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_init_dataqueue_phase sg p_queue_pre NodeNumber_pre)) (LastSeen before) (LastSeen after_3) a).
{ intros states Hseen.
exists (Crtos_RTrans after_3).
split.
- cbn [os_atomic_cmd abs_init_dataqueue_phase MonadErr.nrm].
exists observed,after_3.
split; [apply Hseen; exact PreH21|].
split; [exact Hphase|reflexivity].
- unfold LastSeen. reflexivity.
}
unfold abs_init_dataqueue in PreH24 at 1.
prog_nf in PreH24.
pose proof (highstepbind_derive _ _ _ a (LastSeen after_3) Hstep X PreH24) as Hnext.
cbv beta in Hnext.
assert (Hfail : dataqueue_attempt_succeeded a = false).
{ unfold a,q,dataqueue_attempt_succeeded,dataqueue_constructed.
cbn [dq_attempt_object dq_sem_blank dq_sem_data].
rewrite PreH2. apply andb_false_iff. right. reflexivity.
}
rewrite Hfail in Hnext.
unfold safeExec, safe in Hnext |- *.
destruct Hnext as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
rewrite wp_bind in Hwp.
destruct Hwp as [Herr Hnormal].
split; [exact Herr|].
intros u st Hu.
specialize (Hnormal u st Hu).
apply (proj1 (wp_ret (-1) X st)).
exact Hnormal.
intros final Hret.
unfold safeExec, safe in Hret |- *.
destruct Hret as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
apply (proj2 (wp_ret (-1) X states)).
apply (proj1 (wp_ret tt (fun (_:unit) states => X (-1) states) states)).
exact Hwp.
Qed.

Lemma proof_of_InitDataqueue_return_wit_1 : InitDataqueue_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Left.
  Exists after_4 (dataqueue_retired q_3).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial;
      cbn [dataqueue_retired dq_max_len dq_front dq_rear dq_base dq_sem_blank dq_sem_data];
      try assumption; try reflexivity; try (apply PreH8; exact PreH1).
    + rewrite (proj2 (Z.leb_le 0 (dq_sem_blank q_3)) PreH5). reflexivity.
    + rewrite PreH6. reflexivity.
Qed.

Lemma proof_of_InitDataqueue_return_wit_2 : InitDataqueue_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Right.
  Exists after_4 (dataqueue_retired q_3).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial;
      cbn [dataqueue_retired dq_max_len dq_front dq_rear dq_base dq_sem_blank dq_sem_data];
      try assumption; try reflexivity; try (apply PreH8; exact PreH1); rewrite ?PreH5, ?PreH6; reflexivity.
Qed.

Lemma proof_of_InitDataqueue_return_wit_3 : InitDataqueue_return_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Right.
  Exists after_4 (dataqueue_retired q_3).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial;
      cbn [dataqueue_retired dq_max_len dq_front dq_rear dq_base dq_sem_blank dq_sem_data];
      try assumption; try reflexivity; try (apply PreH8; exact PreH1); rewrite ?PreH5, ?PreH6; reflexivity.
Qed.

Lemma proof_of_InitDataqueue_return_wit_4 : InitDataqueue_return_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists q_3 after_3.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_1 : InitDataqueue_which_implies_wit_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_2 : InitDataqueue_which_implies_wit_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial : InitDataqueue_which_implies_wit_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. pose proof (proj1 dataqueue_layout_abi) as Hsize. unfold KTaskCNotation.sizeof_front_end_type, sizeof_front_end_type in *. rewrite Hsize. cancel.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1 : InitDataqueue_which_implies_wit_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_1.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial : InitDataqueue_which_implies_wit_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
pose proof (proj1 dataqueue_layout_abi) as Hsize.
pose proof (proj2 (proj2 dataqueue_layout_abi) p_queue) as Ho.
destruct Ho as [Hf [Hr [Hm [Hb [Hs [Ht _]]]]]].
unfold KTaskCNotation.sizeof_front_end_type, sizeof_front_end_type in *.
rewrite Hsize. rewrite Hf,Hr,Hm,Hb,Hs,Ht. simpl_nonptr_sizeof.
rename p_queue into p.
assert (H2 : addr_aligned p 2).
{ unfold addr_aligned in *. apply Z.mod_divide; try lia.
  apply Z.mod_divide in PreH1; try lia. destruct PreH1 as [k Hk].
  exists (2*k). lia. }
assert (Ha : forall k, addr_aligned (p+4*k) 4).
{ intro k. unfold addr_aligned in *. rewrite Z.add_mod,Z.mul_mod by lia.
  rewrite PreH1. cbn. reflexivity. }
assert (Ha2 : forall k, addr_aligned (p+2*k) 2).
{ intro k. unfold addr_aligned in *. rewrite Z.add_mod,Z.mul_mod by lia.
  rewrite H2. cbn. reflexivity. }
sep_apply_l_atomic (CharArray.full_split_to_full p 2 20 (repeat_Z 0 20) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 20)) with (repeat_Z 0 2).
change (sublist 2 20 (repeat_Z 0 20)) with (repeat_Z 0 18).
change (20-2) with 18.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace (p+2*1) with (p+2) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+2) 2 18 (repeat_Z 0 18) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 18)) with (repeat_Z 0 2).
change (sublist 2 18 (repeat_Z 0 18)) with (repeat_Z 0 16).
change (18-2) with 16.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+2)+2*1) with (p+4) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+4) 2 16 (repeat_Z 0 16) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 16)) with (repeat_Z 0 2).
change (sublist 2 16 (repeat_Z 0 16)) with (repeat_Z 0 14).
change (16-2) with 14.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+4)+2*1) with (p+6) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+6) 2 14 (repeat_Z 0 14) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 14)) with (repeat_Z 0 2).
change (sublist 2 14 (repeat_Z 0 14)) with (repeat_Z 0 12).
change (14-2) with 12.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+6)+2*1) with (p+8) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+8) 4 12 (repeat_Z 0 12) ltac:(lia)).
change (sublist 0 4 (repeat_Z 0 12)) with (repeat_Z 0 4).
change (sublist 4 12 (repeat_Z 0 12)) with (repeat_Z 0 8).
change (12-4) with 8.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+8)+4*1) with (p+12) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+12) 4 8 (repeat_Z 0 8) ltac:(lia)).
change (sublist 0 4 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (sublist 4 8 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (8-4) with 4.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+12)+4*1) with (p+16) by lia.
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort p H2).
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort (p+2) (Ha2 1)).
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort (p+4) (Ha2 2)).
sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+8) (Ha 2)).
sep_apply_l_atomic (four_zero_uint__zero_layout (p+12) (Ha 3)).
sep_apply_l_atomic (four_zero_uint__zero_layout (p+16) (Ha 4)).
sep_apply_l_atomic (store_uint_cast (p+12) 0).
sep_apply_l_atomic (store_uint_cast (p+16) 0).
change (signed_last_nbits 0 32) with 0.
sep_apply_l_atomic (CharArray.full_to_undef_full (p+6) 2 (repeat_Z 0 2)).
replace (p+6*1) with (p+6) by lia.
repeat progress cancel.

Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_2 : InitDataqueue_which_implies_wit_2.
Proof.
aggressive_pre_process. Goal_apply proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial.
Qed.

