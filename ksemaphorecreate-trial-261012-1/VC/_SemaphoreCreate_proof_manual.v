Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import _SemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSInv.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Import IDNode.
Import Crtos_C_Rules.
Require Coq.Program.Basics.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold SemaphoreOSInvariant. Intros_p Hvalid.
  dump_pre_spatial. exact Hvalid.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_sem_zeroed_private.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq.
  Intros_p Haddresses.
  dump_pre_spatial. exact (proj1 (proj2 Haddresses)).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. apply CNotation.addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold SemaphoreInsideCritical, SemaphoreOSInvariant,
    store_semaphore, store_sem_manager, store_sem_zeroed_private,
    store_sem_registered_private.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq.
  Intros_p Hinside. Intros_p Hvalid. Intros_p Haddresses. Intros_p Hsem.
  destruct Hinside as [Hstable Hinside].
  destruct Hstable as [Hmanager Hstable].
  rewrite Hmanager.
  replace (os_tasks (semaphore_nest_increment current)) with (os_tasks current) by reflexivity.
  replace (os_semaphores (semaphore_nest_increment current)) with (os_semaphores current) by reflexivity.
  LLM_pre_process ltac:(unfold SemaphoreStableContext in *; tauto).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1 : _SemaphoreCreate_entail_wit_2_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH9 as [_ [Hvalid [Hnest _]]].
  pose proof Hvalid as Hbounds.
  unfold CrtosOSValid in Hbounds.
  destruct Hbounds as [_ [_ [Hbounds _]]].
  rewrite semaphore_nesting_roundtrip_bounded by lia.
  unfold SemaphoreGuarantee; auto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Esep : forall P Q, OSHeap (Task_C_Rules.sepcon P Q) = OSHeap P ** OSHeap Q).
  { intros; apply functional_extensionality; intro m.
    apply propositional_extensionality; apply CrtosHeapBridge.crtos_heap_lift_sep. }
  assert (Epure : forall P Q, OSHeap (Task_C_Rules.andp (Task_C_Rules.coq_prop P) Q) = “ P ” && OSHeap Q).
  { intros; apply functional_extensionality; intro m.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.andp, Task_C_Rules.coq_prop, andp, coq_prop; tauto. }
  unfold SemaphoreInsideCritical.
  Intros_p Hinside.
  destruct Hinside as [Hstable [Hstack Hzero]].
  pose proof Hstable as Hmanager.
  unfold SemaphoreStableContext in Hmanager.
  destruct Hmanager as [Hmanager _].
  pose proof (proj1 PreH11) as Hsemvalid.
  unfold SemaphoreOSInvariant, store_semaphore, store_sem_manager,
    store_sem_zeroed_private, store_sem_registered_private.
  repeat rewrite Epure.
  repeat rewrite Esep.
  replace (os_tasks (semaphore_nest_increment current)) with (os_tasks current) by reflexivity.
  replace (os_semaphores (semaphore_nest_increment current)) with (os_semaphores current) by reflexivity.
  rewrite Hmanager.
  LLM_pre_process ltac:(tauto || lia || int_auto).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_2_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  unfold store_sem_registered_private, store_sem_link_detached.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq,
    !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq,
    !OSHeap_ushort_eq, !Hptr.
  Intros.
  set (pending := &(sem # "Semaphore" ->ₛ "pend_list")).
  set (newlink := &(sem # "Semaphore" ->ₛ "link")).
  replace &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") with
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  replace &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") with
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; unfold semaphore_object_addresses in *; tauto.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  unfold SemaphoreInsideCritical.
  Intros_p Hcritical.
  assert (Hregistry : semaphore_registry_addr (os_sem_stable sg) = &("k_sem_list")).
  { destruct Hcritical as [Hstable _]. unfold SemaphoreStableContext in Hstable. tauto. }
  unfold store_sem_registry, DLL.store_dll.
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros successor.
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros tail.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr, Hregistry.
  Intros_p Hnodes.
  set (nodes := map (fun obj => let p := semaphore_addr obj in
    Build_DL_Node obj (&(p # "Semaphore" ->ₛ "link"))) (os_semaphores current)).
  pose proof (SemaphoreCriticalViews.OSHeap_entails _ _
    (DLL.dllseg_to_dllseg_shift_rev (Basics.const store_semaphore_body)
      successor &("k_sem_list") &("k_sem_list") tail nodes)) as Hmove.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr in Hmove.
  change (fun (_ : addr) (obj : SemaphoreObject) => store_semaphore_body obj)
    with (Basics.const (B := addr) store_semaphore_body).
  sep_apply_l_atomic Hmove.
  Exists successor nodes.
  split_pure_spatial.
  - set (head := &("k_sem_list")).
    replace &((&("k_sem_list"))->ₛ "node_next") with
      &(head # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold head; apply eval_addr_expr_congr; apply RE_addr_of_congr;
       apply LE_arrow_field_congr; [apply eval_addr | reflexivity]).
    cancel (CrtosInsideProtocol (lock :: hs) current).
    cancel (OSHeap (CrtosBorrowedRep.store_task_semaphore_views (os_tasks current))).
    cancel (OSHeap (CrtosBorrowedRep.store_scheduler_view
      (os_scheduler (semaphore_nest_increment current)))).
    cancel (OSHeap (store_idmanager (semaphore_manager_abs (os_sem_stable sg))
      (idmanager_link (semaphore_manager_abs (os_sem_stable sg))
        (idmanager_add (semaphore_manager_state (os_sem_stable sg)
          (os_semaphores current)) id) id &(sem # "Semaphore" ->ₛ "id"))
      &("k_sem_id_manager"))).
    cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> successor).
    cancel (&(successor # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head).
    cancel (OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body)
      successor head nodes)).
    cancel (&(sem # "Semaphore" ->ₛ "value") # UShort |-> val_pre).
    cancel (&(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")
      # Ptr |-> &(sem # "Semaphore" ->ₛ "pend_list")).
    cancel (&(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")
      # Ptr |-> &(sem # "Semaphore" ->ₛ "pend_list")).
    cancel (&(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
    cancel (&(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
    cancel.
  - split_pures; dump_pre_spatial; try tauto.
    + unfold nodes. rewrite map_map.
      change (map (fun obj : SemaphoreObject => obj) (os_semaphores current) =
        os_semaphores current). apply map_id.
    + intros node Hin. unfold nodes in Hin. apply in_map_iff in Hin.
      destruct Hin as [obj [<- Hin]]. reflexivity.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_1 : _SemaphoreCreate_entail_wit_5_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hinsidefacts : SemaphoreInsideCritical sg hs lock current |--
    “ SemaphoreStableContext sg ”).
  { unfold SemaphoreInsideCritical. Intros_p Hinside.
    dump_pre_spatial. tauto. }
  prop_apply_p Hinsidefacts. Intros_p Hstable.
  destruct Hstable as [Hmanager [Hregistry [Hmax [Hoffset Hstable]]]].
  destruct PreH11 as [Hbefore [Hcurrent [Hnest Hrely]]].
  prop_apply_p (store_ushort_range (&(sem # "Semaphore" ->ₛ "value")) val_pre).
  Intros_p Hvalue.
  assert (Hfreshseg : forall (ns : list (DL_Node SemaphoreObject)) x y p v,
    OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body) x y ns) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr (map getData ns)) ”).
  { induction ns as [|a ns IH]; intros x y p v.
    - dump_pre_spatial. simpl. tauto.
    - cbn [DLL.dllseg_shift_rev].
      rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
      Intros z.
      rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
        !SemaphoreCriticalViews.OSHeap_sep_eq.
      Intros_p Hx.
      unfold Basics.const at 1. unfold store_semaphore_body at 1.
      rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, OSHeap_ushort_eq.
      destruct (Z.eq_dec p (semaphore_addr (getData a))) as [Heq|Hneq].
      + subst p. unfold store_ushort. Intros.
        prop_apply_p (dup_store_2bytes
          (&(((semaphore_addr (getData a))) # "Semaphore" ->ₛ "value"))
          (semaphore_value (getData a)) v).
        Intros_p Hfalse. contradiction.
      + pose proof (IH z y p v) as Hrec.
        unfold DLL.dllseg_shift_rev in Hrec.
        prop_apply_p Hrec. Intros_p Htail.
        dump_pre_spatial. cbn. intuition congruence. }
  prop_apply_p (Hfreshseg nodes successor (&("k_sem_list")) sem val_pre).
  Intros_p Hfresh.
  rewrite PreH1 in Hfresh.
  assert (Hid : 0 <= id < 128).
  { destruct PreH14 as [Hr _]. rewrite Hmax in Hr. exact Hr. }
  assert (Hidfresh : ~ In id (map semaphore_id (os_semaphores current))).
  { destruct PreH14 as [_ [Hq _]]. apply id_in_ids_false_iff. exact Hq. }
  assert (Hvalid : CrtosOSValid (semaphore_os_publish sem id val_pre current)).
  { destruct Hcurrent as [Hsem Hrest].
    destruct Hsem as [Ha [Hi [Hp Hr]]].
    unfold CrtosOSValid, semaphore_os_publish, os_with_semaphores,
      semaphore_publish; cbn.
    split.
    - unfold semaphore_valid; cbn. split; [constructor; assumption|].
      split; [constructor; assumption|]. split; [exact Hp|].
      constructor; [cbn; repeat split; try assumption; lia|exact Hr].
    - exact Hrest. }
  assert (Hguarantee : SemaphoreGuarantee current
    (semaphore_os_publish sem id val_pre current)).
  { unfold SemaphoreGuarantee. split; [exact Hcurrent|].
    split; [exact Hvalid|]. split; reflexivity. }
  rewrite semaphore_nesting_roundtrip_bounded.
  - dump_pre_spatial. exact Hguarantee.
  - cbn. destruct Hcurrent as [_ [_ [Hbounds _]]]. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_2 : _SemaphoreCreate_entail_wit_5_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hinsidefacts : SemaphoreInsideCritical sg hs lock current |--
    “ SemaphoreStableContext sg ”).
  { unfold SemaphoreInsideCritical. Intros_p Hinside.
    dump_pre_spatial. tauto. }
  prop_apply_p Hinsidefacts. Intros_p Hstable.
  destruct Hstable as [Hmanager [Hregistry [Hmax [Hoffset Hstable]]]].
  destruct PreH11 as [Hbefore [Hcurrent [Hnest Hrely]]].
  prop_apply_p (store_ushort_range (&(sem # "Semaphore" ->ₛ "value")) val_pre).
  Intros_p Hvalue.
  assert (Hfreshseg : forall (ns : list (DL_Node SemaphoreObject)) x y p v,
    OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body) x y ns) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr (map getData ns)) ”).
  { induction ns as [|a ns IH]; intros x y p v.
    - dump_pre_spatial. simpl. tauto.
    - cbn [DLL.dllseg_shift_rev].
      rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
      Intros z.
      rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
        !SemaphoreCriticalViews.OSHeap_sep_eq.
      Intros_p Hx.
      unfold Basics.const at 1. unfold store_semaphore_body at 1.
      rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, OSHeap_ushort_eq.
      destruct (Z.eq_dec p (semaphore_addr (getData a))) as [Heq|Hneq].
      + subst p. unfold store_ushort. Intros.
        prop_apply_p (dup_store_2bytes
          (&(((semaphore_addr (getData a))) # "Semaphore" ->ₛ "value"))
          (semaphore_value (getData a)) v).
        Intros_p Hfalse. contradiction.
      + pose proof (IH z y p v) as Hrec.
        unfold DLL.dllseg_shift_rev in Hrec.
        prop_apply_p Hrec. Intros_p Htail.
        dump_pre_spatial. cbn. intuition congruence. }
  prop_apply_p (Hfreshseg nodes successor (&("k_sem_list")) sem val_pre).
  Intros_p Hfresh.
  rewrite PreH1 in Hfresh.
  assert (Hid : 0 <= id < 128).
  { destruct PreH14 as [Hr _]. rewrite Hmax in Hr. exact Hr. }
  assert (Hidfresh : ~ In id (map semaphore_id (os_semaphores current))).
  { destruct PreH14 as [_ [Hq _]]. apply id_in_ids_false_iff. exact Hq. }
  assert (Hvalid : CrtosOSValid (semaphore_os_publish sem id val_pre current)).
  { destruct Hcurrent as [Hsem Hrest].
    destruct Hsem as [Ha [Hi [Hp Hr]]].
    unfold CrtosOSValid, semaphore_os_publish, os_with_semaphores,
      semaphore_publish; cbn.
    split.
    - unfold semaphore_valid; cbn. split; [constructor; assumption|].
      split; [constructor; assumption|]. split; [exact Hp|].
      constructor; [cbn; repeat split; try assumption; lia|exact Hr].
    - exact Hrest. }
  assert (Hguarantee : SemaphoreGuarantee current
    (semaphore_os_publish sem id val_pre current)).
  { unfold SemaphoreGuarantee. split; [exact Hcurrent|].
    split; [exact Hvalid|]. split; reflexivity. }
  dump_pre_spatial. exact Hguarantee.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial : _SemaphoreCreate_entail_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hinsidefacts : SemaphoreInsideCritical sg hs lock current |--
    “ SemaphoreStableContext sg ”).
  { unfold SemaphoreInsideCritical. Intros_p Hinside.
    dump_pre_spatial. tauto. }
  prop_apply_p Hinsidefacts. Intros_p Hstable.
  destruct Hstable as [Hmanager [Hregistry [Hmax [Hoffset Hstable]]]].
  destruct PreH11 as [Hbefore [Hcurrent [Hnest Hrely]]].
  prop_apply_p (store_ushort_range (&(sem # "Semaphore" ->ₛ "value")) val_pre).
  Intros_p Hvalue.
  assert (Hfreshseg : forall (ns : list (DL_Node SemaphoreObject)) x y p v,
    OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body) x y ns) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr (map getData ns)) ”).
  { induction ns as [|a ns IH]; intros x y p v.
    - dump_pre_spatial. simpl. tauto.
    - cbn [DLL.dllseg_shift_rev].
      rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
      Intros z.
      rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
        !SemaphoreCriticalViews.OSHeap_sep_eq.
      Intros_p Hx.
      unfold Basics.const at 1. unfold store_semaphore_body at 1.
      rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, OSHeap_ushort_eq.
      destruct (Z.eq_dec p (semaphore_addr (getData a))) as [Heq|Hneq].
      + subst p. unfold store_ushort. Intros.
        prop_apply_p (dup_store_2bytes
          (&(((semaphore_addr (getData a))) # "Semaphore" ->ₛ "value"))
          (semaphore_value (getData a)) v).
        Intros_p Hfalse. contradiction.
      + pose proof (IH z y p v) as Hrec.
        unfold DLL.dllseg_shift_rev in Hrec.
        prop_apply_p Hrec. Intros_p Htail.
        dump_pre_spatial. cbn. intuition congruence. }
  prop_apply_p (Hfreshseg nodes successor (&("k_sem_list")) sem val_pre).
  Intros_p Hfresh.
  rewrite PreH1 in Hfresh.
  assert (Hid : 0 <= id < 128).
  { destruct PreH14 as [Hr _]. rewrite Hmax in Hr. exact Hr. }
  assert (Hidfresh : ~ In id (map semaphore_id (os_semaphores current))).
  { destruct PreH14 as [_ [Hq _]]. apply id_in_ids_false_iff. exact Hq. }
  assert (Hvalid : CrtosOSValid (semaphore_os_publish sem id val_pre current)).
  { destruct Hcurrent as [Hsem Hrest].
    destruct Hsem as [Ha [Hi [Hp Hr]]].
    unfold CrtosOSValid, semaphore_os_publish, os_with_semaphores,
      semaphore_publish; cbn.
    split.
    - unfold semaphore_valid; cbn. split; [constructor; assumption|].
      split; [constructor; assumption|]. split; [exact Hp|].
      constructor; [cbn; repeat split; try assumption; lia|exact Hr].
    - exact Hrest. }
  assert (Hguarantee : SemaphoreGuarantee current
    (semaphore_os_publish sem id val_pre current)).
  { unfold SemaphoreGuarantee. split; [exact Hcurrent|].
    split; [exact Hvalid|]. split; reflexivity. }
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros; unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    do 4 (rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal;
      apply functional_extensionality; intro).
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro st.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp,
      CrtosHeapBridge.crtos_heap_state; simpl.
    unfold Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty; simpl.
    split.
    - tauto.
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity. }
  set (obj := Build_SemaphoreObject sem id val_pre nil).
  set (newlink := &(sem # "Semaphore" ->ₛ "link")).
  set (pending := &(sem # "Semaphore" ->ₛ "pend_list")).
  set (head := &("k_sem_list")).
  assert (Hbody :
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> val_pre **
    &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> pending **
    &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> pending **
    OSHeap (store_sem_padding sem) |-- OSHeap (store_semaphore_body obj)).
  { unfold obj, store_semaphore_body; cbn [semaphore_addr semaphore_value semaphore_pending_addrs map].
    rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, OSHeap_ushort_eq.
    unfold DLL.store_dll.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. Exists pending.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. Exists pending.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr.
    cbn [DLL.dllseg].
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, Hemp.
    subst pending. csimpl.
    split_pure_spatial.
    - cancel (&(sem # "Semaphore" ->ₛ "value") # UShort |-> val_pre).
      cancel (OSHeap (store_sem_padding sem)).
      repeat match goal with
      | |- context [store_ptr ?a ?v] => progress cancel (store_ptr a v)
      end.
    - split_pures; dump_pre_spatial; repeat split; try assumption; constructor. }
  sepcon_assoc_change.
  sep_apply_l_atomic Hbody.
  assert (Hnodes : nodes = map (fun o =>
    Build_DL_Node o (&(((semaphore_addr o)) # "Semaphore" ->ₛ "link")))
    (os_semaphores current)).
  { rewrite <- PreH1. clear -PreH2. revert PreH2.
    induction nodes as [|[o ptr] ns IH]; intros Hptrs; [reflexivity|].
    cbn [map getData]. f_equal.
    - specialize (Hptrs (Build_DL_Node o ptr) (or_introl eq_refl)).
      cbn [getPtr getData] in Hptrs. subst ptr. reflexivity.
    - apply IH. intros node Hin. apply Hptrs. right; exact Hin. }
  pose proof (SemaphoreCriticalViews.OSHeap_entails _ _
    (DLL.dllseg_shift_rev_contact_a (Basics.const store_semaphore_body)
      head successor newlink obj nodes)) as Hcontact.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr in Hcontact.
  change (Basics.const store_semaphore_body newlink obj) with (store_semaphore_body obj) in Hcontact.
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") with
    &(newlink # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") with
    &(newlink # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sepcon_assoc_change.
  sep_apply_l_atomic Hcontact.
  pose proof (SemaphoreCriticalViews.OSHeap_entails _ _
    (DLL.dllseg_shift_rev_to_dllseg (Basics.const store_semaphore_body)
      newlink head head (Build_DL_Node obj newlink :: nodes))) as Hconvert.
  rewrite SemaphoreCriticalViews.OSHeap_sep_eq, Hptr,
    SemaphoreCriticalViews.OSHeap_exp_eq in Hconvert.
  assert (HconvertOS :
    OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body)
      newlink head (Build_DL_Node obj newlink :: nodes)) **
    &(newlink # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head |--
    EX py, OSHeap (DLL.dllseg (Basics.const store_semaphore_body)
      newlink head head py (Build_DL_Node obj newlink :: nodes)) **
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py).
  { intros st Hst. destruct (Hconvert st Hst) as [py Hpy].
    exists py. rewrite SemaphoreCriticalViews.OSHeap_sep_eq, Hptr in Hpy. exact Hpy. }
  sepcon_assoc_change.
  sep_apply_l_atomic HconvertOS. Intros tail.
  assert (Hnz : DLL.dll_nodes_nonzero (Build_DL_Node obj newlink :: nodes)).
  { constructor; [exact PreH9|exact PreH3]. }
  assert (Htail : forall (l : list (DL_Node SemaphoreObject)) x px y py,
    DLL.dll_nodes_nonzero l -> px <> 0 ->
    Task_C_Rules.derivable1
      (DLL.dllseg (Basics.const store_semaphore_body) x px y py l)
      (Task_C_Rules.coq_prop (py <> 0))).
  { intros l; induction l as [|a l IH]; intros x px y py Hnon Hpx st Hseg.
    - destruct Hseg as [[_ Heq] _]. congruence.
    - inversion Hnon as [|a' l' Ha Hl]; subst.
      destruct Hseg as [z [Hx [s1 [s2 [Hj [Hprefix Hrest]]]]]].
      change (x = a.(ptr)) in Hx.
      exact (IH z x y py Hl ltac:(congruence) s2 Hrest). }
  assert (HtailOS : OSHeap (DLL.dllseg (Basics.const store_semaphore_body)
    newlink head head tail (Build_DL_Node obj newlink :: nodes)) |-- “ tail <> 0 ”).
  { intros st [_ [_ Hseg]]. exact (Htail _ _ _ _ _ Hnz PreH4 _ Hseg). }
  prop_apply_p HtailOS. Intros_p Htailnz.
  assert (Hfold :
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> tail **
    &(&("k_sem_list") ->ₛ "node_next") # Ptr |-> newlink **
    OSHeap (DLL.dllseg (Basics.const store_semaphore_body)
      newlink head head tail (Build_DL_Node obj newlink :: nodes)) |--
    OSHeap (store_sem_registry (os_sem_stable sg) (obj :: os_semaphores current))).
  { unfold store_sem_registry.
    change (fun (_ : addr) (o : SemaphoreObject) => store_semaphore_body o)
      with (Basics.const store_semaphore_body : addr -> SemaphoreObject -> Task_C_Rules.expr).
    unfold DLL.store_dll.
    rewrite Hregistry. fold head. cbn [map].
    change (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) with newlink.
    rewrite <- Hnodes.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. Exists newlink.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. Exists tail.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr.
    split_pure_spatial.
    - cancel (OSHeap (DLL.dllseg (Basics.const store_semaphore_body)
        newlink head head tail (Build_DL_Node obj newlink :: nodes))).
      subst head. csimpl.
      repeat match goal with
      | |- context [store_ptr ?a ?v] => progress cancel (store_ptr a v)
      end.
    - dump_pre_spatial. repeat split; assumption. }
  sepcon_assoc_change.
  sep_apply_l_atomic Hfold.
  assert (Hmanagerstate : semaphore_manager_state (os_sem_stable sg)
      (obj :: os_semaphores current) =
    idmanager_link (semaphore_manager_abs (os_sem_stable sg))
      (idmanager_add (semaphore_manager_state (os_sem_stable sg)
        (os_semaphores current)) id) id (&(sem # "Semaphore" ->ₛ "id"))).
  { unfold semaphore_manager_state, idmanager_link, idmanager_add,
      idmanager_insert_bucket, idlist_add, obj; cbn [idlist idbuckets map filter semaphore_id].
    rewrite Hoffset. f_equal.
    assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    assert (Hcases : id mod 16 = 0 \/ id mod 16 = 1 \/ id mod 16 = 2 \/ id mod 16 = 3 \/ id mod 16 = 4 \/ id mod 16 = 5 \/ id mod 16 = 6 \/ id mod 16 = 7 \/ id mod 16 = 8 \/ id mod 16 = 9 \/ id mod 16 = 10 \/ id mod 16 = 11 \/ id mod 16 = 12 \/ id mod 16 = 13 \/ id mod 16 = 14 \/ id mod 16 = 15) by lia.
    destruct Hcases as [Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|[Hcases|Hcases]]]]]]]]]]]]]]];
      rewrite Hcases; reflexivity. }
  assert (Hinc : CrtosOSValid
    (semaphore_nest_increment (semaphore_os_publish sem id val_pre current))).
  { apply CrtosOSValid_with_nest; [exact Hvalid|].
    pose proof (Z.mod_pos_bound (scheduler_lock_nest (os_scheduler current) + 1) 65536 ltac:(lia)).
    cbn. lia. }
  unfold SemaphoreOSInvariant.
  split_pure_spatial.
  - cancel (SemaphoreInsideCritical sg hs lock current).
    change (os_tasks (semaphore_nest_increment (semaphore_os_publish sem id val_pre current)))
      with (os_tasks current).
    change (os_scheduler (semaphore_nest_increment (semaphore_os_publish sem id val_pre current)))
      with (os_scheduler (semaphore_nest_increment current)).
    cancel (OSHeap (CrtosBorrowedRep.store_task_semaphore_views (os_tasks current))).
    cancel (OSHeap (CrtosBorrowedRep.store_scheduler_view (os_scheduler (semaphore_nest_increment current)))).
    change (os_semaphores (semaphore_nest_increment (semaphore_os_publish sem id val_pre current)))
      with (obj :: os_semaphores current).
    unfold store_semaphore, store_sem_manager.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      SemaphoreCriticalViews.OSHeap_sep_eq, Hmanagerstate, Hmanager.
    split_pure_spatial.
    + cancel (OSHeap (store_sem_registry (os_sem_stable sg) (obj :: os_semaphores current))).
      cancel (OSHeap (store_idmanager (semaphore_manager_abs (os_sem_stable sg))
        (idmanager_link (semaphore_manager_abs (os_sem_stable sg))
          (idmanager_add (semaphore_manager_state (os_sem_stable sg) (os_semaphores current)) id)
          id (&(sem # "Semaphore" ->ₛ "id"))) (&("k_sem_id_manager")))).
    + dump_pre_spatial. exact (proj1 Hvalid).
  - dump_pre_spatial. exact Hinc.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_5_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_5_split_goal_2.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hrestore : semaphore_nest_decrement (semaphore_nest_increment (semaphore_os_publish sem id val_pre current_3)) = semaphore_os_publish sem id val_pre current_3).
  { pose proof (proj2 (proj2 (proj2 PreH6))) as Hsched.
    destruct current_3.
    unfold semaphore_nest_decrement, semaphore_nest_increment, semaphore_os_publish, os_with_scheduler, os_with_semaphores, scheduler_with_nest in Hsched |- *.
    cbn in Hsched |- *. f_equal. exact Hsched. }
  rewrite Hrestore.
  Right. Exists current_3 sem.
  split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs (semaphore_os_publish sem id val_pre current_3)).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hrestore : semaphore_nest_decrement (semaphore_nest_increment current_3) = current_3).
  { pose proof (proj2 (proj2 (proj2 PreH6))) as Hsched.
    destruct current_3.
    unfold semaphore_nest_decrement, semaphore_nest_increment, os_with_scheduler, scheduler_with_nest in Hsched |- *.
    cbn in Hsched |- *. f_equal. exact Hsched. }
  rewrite Hrestore.
  Left. Right. Exists current_3.
  split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs current_3).
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Left. split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs before).
  - dump_pre_spatial. reflexivity.
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_1_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_2_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3_pure : _SemaphoreCreate_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_3_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_4_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_6_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7_pure : _SemaphoreCreate_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_7_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_8_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(assumption).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_9_aux.
  LLM_pre_process ltac:(assumption).
Qed.
