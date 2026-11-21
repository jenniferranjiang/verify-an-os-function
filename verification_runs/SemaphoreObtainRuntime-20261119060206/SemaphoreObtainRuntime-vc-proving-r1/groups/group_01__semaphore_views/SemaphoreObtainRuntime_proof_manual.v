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

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1 : _SemaphoreObtain_entail_wit_1_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1 : _SemaphoreObtain_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1 : _SemaphoreObtain_entail_wit_12_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial : _SemaphoreObtain_entail_wit_12_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1 : _SemaphoreObtain_entail_wit_12_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial : _SemaphoreObtain_entail_wit_12_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1 : _SemaphoreObtain_entail_wit_13_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2 : _SemaphoreObtain_entail_wit_13_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1 : _SemaphoreObtain_entail_wit_13_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2 : _SemaphoreObtain_entail_wit_13_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_15_split_goal_1 : _SemaphoreObtain_entail_wit_15_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_1 : _SemaphoreObtain_entail_wit_17_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_2 : _SemaphoreObtain_entail_wit_17_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial : _SemaphoreObtain_entail_wit_17_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_6_split_goal_1 : _SemaphoreObtain_return_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_7_split_goal_1 : _SemaphoreObtain_return_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_8_split_goal_1 : _SemaphoreObtain_return_wit_8_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 : _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Proof. Admitted.

