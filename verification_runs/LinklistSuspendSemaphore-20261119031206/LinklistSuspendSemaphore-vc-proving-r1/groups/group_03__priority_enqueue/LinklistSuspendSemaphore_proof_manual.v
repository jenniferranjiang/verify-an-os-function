From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
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
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  assert (Hwaiting : waiting_semaphore_ic = prefix_loop).
  { rewrite PreH14, app_nil_r in PreH12. exact PreH12. }
  set (newwaiting := waiting_semaphore_ic ++ [task_pre]).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node waiting_semaphore_ic), [].
    repeat split; try assumption; try rewrite app_nil_r; try reflexivity.
    - unfold newnodes, newwaiting. rewrite map_app. reflexivity.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH13. rewrite <- Hwaiting; exact Hin. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. apply Permutation_sym.
    replace (task_pre::waiting_semaphore_ic) with (task_pre::waiting_semaphore_ic++[]) by (rewrite app_nil_r; reflexivity).
    apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH7 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH7 PreH8 PreH9 PreH10 PreH11 Hperm).
  Intros_p Hnz.
  Exists after newnodes waiting_semaphore_ic (@nil Z).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH6. unfold sched_link_of. sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; try assumption; try rewrite app_nil_r; try reflexivity;
      try (unfold newnodes, newwaiting; reflexivity); try congruence.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }
  assert (Hlift : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) (a:DL_Node A) (P:Prop),
    In a l -> (forall link, storeA link (getData a) |-- “ P ”) ->
    forall x px y py, dllseg storeA x px y py l |-- “ P ”).
  { clear. intros A storeA l; induction l as [|b rest IH]; intros a P Hin Hpayload x px y py.
    - contradiction.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. fold (@dllseg A storeA).
      destruct Hin as [Heq|Hin].
      + subst b. sep_apply_l_atomic (Hpayload x). Intros_p HP. dump_pre_spatial; exact HP.
      + sep_apply_l_atomic (IH a P Hin Hpayload z x y py). Intros_p HP. dump_pre_spatial; exact HP. }
  destruct PreH7 as [obj [Hin [Haddr Hwaiting]]].
  assert (Hnodeseq : semaphore_pending_addrs obj = waiting_semaphore_ic).
  { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
    change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting_semaphore_ic) in Hwaiting.
    rewrite !map_id in Hwaiting. exact Hwaiting. }
  assert (Hstore : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) (a:DL_Node A) (P:Prop),
    In a l -> (forall link, storeA link (getData a) |-- “ P ”) ->
    forall h, store_dll storeA h l |-- “ P ”).
  { clear - Hlift. intros A storeA l a P Hin HP h.
    unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ P ”).
    sep_apply_l_atomic (Hlift A storeA l a P Hin HP hd h h pt).
    Intros_p Hpure. dump_pre_spatial; exact Hpure. }
  assert (Hpayload : forall link, store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))) link obj |-- “ False ”).
  { intros link. unfold store_semaphore. Intros_p Hp.
    prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))). Intros_p Hdistinct.
    dump_pre_spatial. destruct Hdistinct as [_ Hnot]. apply Hnot.
    rewrite Hnodeseq, PreH12, PreH14, !map_app. apply in_or_app; right.
    simpl. left. unfold semaphore_wait_node, getPtr, object_wait_link_of.
    rewrite Haddr. change (sched_link_of first_task = semaphore_pending_head sem_semaphore_ic).
    congruence. }
  assert (Hbad : os_inv sg_semaphore_ic staged |-- “ False ”).
  { unfold os_inv, semaphore_inv. Intros_p Hworld. Intros_p Hcontext.
    sep_apply_l_atomic (Hstore SemaphoreAbs (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))))
       (map semaphore_link_node (os_semaphores staged)) (semaphore_link_node obj) False
       (in_map semaphore_link_node _ _ Hin) Hpayload (semaphore_list_head (os_semaphore_stable sg_semaphore_ic))).
    Intros_p Hfalse. contradiction. }
  unfold derivable1, coq_prop in Hbad |- *. intros m Hm. exfalso. exact (Hbad m Hm).
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
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
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  rewrite PreH2.
  assert (Hrestore : forall A B C Q : Assertion,
      B ** A ** C ** ((A ** (B ** C)) -* Q) |-- Q).
  { clear. intros A B C Q.
    sep_apply_r_atomic (derivable1_wand_elim1 (A ** (B ** C)) Q).
    sepcon_assoc_change. cancel A. cancel B. cancel C. cancel. }
  sepcon_assoc_change.
  match goal with |- context [wand (?A ** (?B ** ?C)) (os_inv sg_semaphore_ic staged)] =>
    pose proof (Hrestore A B C (os_inv sg_semaphore_ic staged)) as Hrestore_now
  end.
  sepcon_assoc_change_in Hrestore_now.
  rewrite Hrestore_now.
  set (newwaiting := prefix_loop ++ task_pre::current_task::rest_tasks_2).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node prefix_loop), (map sched_link_node (current_task::rest_tasks_2)).
    split; [exact PreH11|]. split; [rewrite PreH15, map_app; reflexivity|].
    split; [unfold newnodes, newwaiting; rewrite map_app; reflexivity|]. split.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH16; exact Hin.
    - simpl. exists current_desc; split; [exact PreH20|lia]. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. rewrite PreH15. apply Permutation_sym. apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH10 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH10 PreH11 PreH12 PreH13 PreH14 Hperm).
  Intros_p Hnz.
  prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
     (semaphore_pending_head sem_semaphore_ic) (map sched_link_node waiting_semaphore_ic)).
  Intros_p Hnodeswf.
  assert (Hdispatch : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
      (sched_link_of current_task) (sched_link_node task_pre) = newnodes).
  { unfold dll_insert_before_dispatch.
    destruct (Z.eq_dec (sched_link_of current_task) list_pre); [congruence|].
    destruct Hnodeswf as [Hnd Hsent]. rewrite PreH15 in Hnd |- *.
    unfold newnodes, newwaiting. rewrite !map_app in *.
    clear - Hnd. induction prefix_loop as [|a prefix IH].
    - simpl. destruct (Z.eq_dec (sched_link_of current_task) (sched_link_of current_task)); congruence.
    - simpl in Hnd |- *. inversion Hnd as [|x xs Hnot Htail]; subst.
      destruct (Z.eq_dec (sched_link_of a) (sched_link_of current_task)) as [Heq|Hne].
      + exfalso. apply Hnot. apply in_or_app; right. simpl. left; congruence.
      + f_equal. apply IH. exact Htail. }
  assert (Hanchor : dll_insert_anchor list_pre (map sched_link_node waiting_semaphore_ic) (sched_link_of current_task)).
  { left. rewrite PreH15, map_app, map_app. apply in_or_app; right. simpl; auto. }
  Exists rest_tasks_2 after newnodes prefix_loop (current_task::rest_tasks_2).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH9. unfold sched_link_of. sepcon_assoc_change; cancel.
    match goal with |- ?P |-- _ => change (P |-- P); cancel P end.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try congruence;
      try (unfold newnodes, newwaiting; reflexivity).
    intros _. split; [exact Hanchor|exact Hdispatch].
Qed.


Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
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
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  rewrite PreH5 in *.
  rewrite PreH2.
  assert (Hrestore : forall A B C Q F : Assertion,
      B ** F ** A ** C ** ((A ** (B ** C)) -* Q) |-- F ** Q).
  { clear. intros A B C Q F.
    sep_apply_r_atomic (derivable1_wand_elim1 (A ** (B ** C)) Q).
    sepcon_assoc_change. cancel F. cancel A. cancel B. cancel C. cancel. }
  sepcon_assoc_change.
  match goal with |- context [wand (?A ** (?B ** ?C)) (os_inv sg_semaphore_ic staged)] =>
    pose proof (Hrestore A B C (os_inv sg_semaphore_ic staged) (&("list") # Ptr |-> list_pre)) as Hrestore_now
  end.
  sepcon_assoc_change_in Hrestore_now.
  rewrite Hrestore_now.
  set (newwaiting := prefix_loop ++ task_pre::current_task::rest_tasks_2).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node prefix_loop), (map sched_link_node (current_task::rest_tasks_2)).
    split; [exact PreH12|]. split; [rewrite PreH16, map_app; reflexivity|].
    split; [unfold newnodes, newwaiting; rewrite map_app; reflexivity|]. split.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH17; exact Hin.
    - simpl. exists current_desc; split; [exact PreH21|lia]. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. rewrite PreH16. apply Permutation_sym. apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH11 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH11 PreH12 PreH13 PreH14 PreH15 Hperm).
  Intros_p Hnz.
  prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
     (semaphore_pending_head sem_semaphore_ic) (map sched_link_node waiting_semaphore_ic)).
  Intros_p Hnodeswf.
  assert (Hdispatch : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
      (sched_link_of current_task) (sched_link_node task_pre) = newnodes).
  { unfold dll_insert_before_dispatch.
    destruct (Z.eq_dec (sched_link_of current_task) list_pre); [congruence|].
    destruct Hnodeswf as [Hnd Hsent]. rewrite PreH16 in Hnd |- *.
    unfold newnodes, newwaiting. rewrite !map_app in *.
    clear - Hnd. induction prefix_loop as [|a prefix IH].
    - simpl. destruct (Z.eq_dec (sched_link_of current_task) (sched_link_of current_task)); congruence.
    - simpl in Hnd |- *. inversion Hnd as [|x xs Hnot Htail]; subst.
      destruct (Z.eq_dec (sched_link_of a) (sched_link_of current_task)) as [Heq|Hne].
      + exfalso. apply Hnot. apply in_or_app; right. simpl. left; congruence.
      + f_equal. apply IH. exact Htail. }
  assert (Hanchor : dll_insert_anchor list_pre (map sched_link_node waiting_semaphore_ic) (sched_link_of current_task)).
  { left. rewrite PreH16, map_app, map_app. apply in_or_app; right. simpl; auto. }
  Exists rest_tasks_2 after newnodes prefix_loop (current_task::rest_tasks_2).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH10. unfold sched_link_of. sepcon_assoc_change; cancel.
    match goal with |- ?P |-- _ => change (P |-- P); cancel P end.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try congruence;
      try (unfold newnodes, newwaiting; reflexivity).
    intros _. split; [exact Hanchor|exact Hdispatch].
Qed.



Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst new_nodes.
  match goal with
  | |- ?P ** wand ?P ?Q |-- ?Q => sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel
  end.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst new_nodes.
  match goal with
  | |- ?P ** wand ?P ?Q |-- ?Q => sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel
  end.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

