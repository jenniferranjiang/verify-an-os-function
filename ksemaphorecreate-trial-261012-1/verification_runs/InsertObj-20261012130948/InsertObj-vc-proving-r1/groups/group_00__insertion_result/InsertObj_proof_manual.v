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
From CRTOS_Verify.VC Require Import InsertObj_goal.
From CRTOS_Verify.VC Require Import InsertObj_proof_auto.
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
Local Open Scope sac.

Lemma proof_of_InsertObj_entail_wit_1 : InsertObj_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_2 : InsertObj_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_1 : InsertObj_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_2 : InsertObj_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_spatial : InsertObj_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1 : InsertObj_entail_wit_3_1.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_1 : InsertObj_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_spatial : InsertObj_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.
Proof. Admitted. 

Lemma proof_of_InsertObj_return_wit_1_split_goal_spatial : InsertObj_return_wit_1_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
  rewrite Z.rem_mod_nonneg in * by lia.
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros; unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, !SemaphoreCriticalViews.OSHeap_sep_eq, !SemaphoreCriticalViews.OSHeap_byte_eq; reflexivity. }
  assert (Hlift : forall P Q, Task_C_Rules.derivable1 P Q -> OSHeap P |-- OSHeap Q).
  { intros P Q Hpq. exact (CrtosHeapBridge.crtos_heap_lift_entails Crtos_STS.sts P Q Hpq). }
  assert (Hrange : 0 <= id < idmax sm) by (destruct PreH9; assumption).
  assert (Hfresh : ~ In id (idlist before)).
  { destruct PreH9 as [_ [Hq _]]. apply id_in_ids_false_iff; exact Hq. }
  destruct PreH10 as [Hpos [Hlen [Hids [Hnodes [Hindices Hperm]]]]].
  assert (Hk : 0 <= id mod hoffset sm < Zlength (idbuckets before)).
  { rewrite Hlen; apply Z.mod_pos_bound; exact Hpos. }
  assert (Hb : idnodes_ok (idmax sm) bucket).
  { rewrite PreH5. exact (@IDNode.Forall_Znth_Zlength _ (idnodes_ok (idmax sm)) (idbuckets before) nil (id mod hoffset sm) Hnodes Hk). }
  assert (Hbfresh : ~ In id (idnode_ids bucket)).
  { intro Hin. apply Hfresh. apply (Permutation_in id Hperm).
    unfold idnode_ids in *. apply in_map_iff in Hin.
    destruct Hin as [n [Heq Hin]]. apply in_map_iff.
    exists n; split; [exact Heq|]. apply in_concat.
    exists bucket; split; [rewrite PreH5; apply Znth_In_Zlength; exact Hk|exact Hin]. }
  assert (Hnewb : idnodes_ok (idmax sm) (Build_IdNodeAbs id idnode_pre :: bucket)).
  { destruct Hb as [[Hr Hnd] Hnz]. split.
    - split; simpl; constructor; assumption.
    - constructor; simpl; assumption. }
  assert (Hidxadd : forall bs start k,
      0 <= k < Zlength bs ->
      idbuckets_index_ok (hoffset sm) start bs ->
      id mod hoffset sm = start + k ->
      idbuckets_index_ok (hoffset sm) start
        (replace_Znth k (Build_IdNodeAbs id idnode_pre :: Znth k bs nil) bs)).
  { intros bs; induction bs as [|b bs IH]; intros start k Hkr Hi Heq.
    - rewrite Zlength_nil in Hkr; lia.
    - destruct Hi as [Hb0 Hbs].
      destruct (Z.eq_dec k 0) as [->|Hne].
      + cbn [replace_Znth replace_nth Znth idbuckets_index_ok].
        split; [constructor; [simpl; lia|exact Hb0]|exact Hbs].
      + rewrite replace_Znth_cons by lia. rewrite Znth_cons by lia.
        simpl. split; [exact Hb0|]. apply IH.
        * rewrite Zlength_cons in Hkr; lia.
        * exact Hbs.
        * lia. }
  assert (Hpermadd : forall bs k,
      0 <= k < Zlength bs ->
      Permutation
        (idnode_ids (concat (replace_Znth k
          (Build_IdNodeAbs id idnode_pre :: Znth k bs nil) bs)))
        (id :: idnode_ids (concat bs))).
  { intros bs; induction bs as [|b bs IH]; intros k Hkr.
    - rewrite Zlength_nil in Hkr; lia.
    - destruct (Z.eq_dec k 0) as [->|Hne].
      + cbn [replace_Znth replace_nth Znth concat idnode_ids].
        reflexivity.
      + rewrite replace_Znth_cons by lia. rewrite Znth_cons by lia.
        change (Permutation (idnode_ids (b ++ concat
          (replace_Znth (k-1) (Build_IdNodeAbs id idnode_pre :: Znth (k-1) bs nil) bs)))
          (id :: idnode_ids (b ++ concat bs))).
        unfold idnode_ids. rewrite !map_app.
        eapply Permutation_trans.
        * apply Permutation_app_head. apply IH. rewrite Zlength_cons in Hkr; lia.
        * apply Permutation_sym. apply Permutation_middle. }
  assert (Hnewok : idbuckets_ok (idmax sm) (hoffset sm)
      (idlist_add id (idlist before))
      (replace_Znth (id mod hoffset sm) (Build_IdNodeAbs id idnode_pre :: bucket)
        (idbuckets before))).
  { unfold idbuckets_ok. repeat split.
    - exact Hpos.
    - rewrite Zlength_replace_Znth; exact Hlen.
    - unfold idlist_add. constructor; [exact Hrange|exact (proj1 Hids)].
    - unfold idlist_add. constructor; [exact Hfresh|exact (proj2 Hids)].
    - apply Forall_replace_Znth; assumption.
    - rewrite PreH5. apply Hidxadd; [exact Hk|exact Hindices|lia].
    - rewrite PreH5. eapply Permutation_trans; [apply Hpermadd; exact Hk|].
      apply perm_skip; exact Hperm. }
  assert (Hstore : OSHeap (store_idnode
      &((idnode_pre) # "IdNode" ->ₛ "link") (Build_IdNodeAbs id idnode_pre)) =
      &((idnode_pre) # "IdNode" ->ₛ "id") # UShort |-> id).
  { unfold store_idnode.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, OSHeap_ushort_eq.
    apply functional_extensionality; intro st; apply propositional_extensionality.
    unfold andp, coq_prop; cbn [idnode_addr idnode_id idnode_link].
    split; [tauto|intro Hst; split; [split; [exact PreH8|reflexivity]|exact Hst]]. }
  pose proof (Hlift _ _
    (DLL.dllseg_shift_rev_contact_a store_idnode head successor
      &((idnode_pre) # "IdNode" ->ₛ "link") (Build_IdNodeAbs id idnode_pre)
      (idnodes_to_dll bucket))) as Hcontact.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, Hstore, !Hptr in Hcontact.
  set (newlink := &((idnode_pre) # "IdNode" ->ₛ "link")) in *.
  replace &((idnode_pre) # "IdNode" ->ₛ "link" .ₛ "node_next") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  replace &((idnode_pre) # "IdNode" ->ₛ "link" .ₛ "node_prev") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply Hcontact.
  change (Build_DL_Node (Build_IdNodeAbs id idnode_pre) newlink :: idnodes_to_dll bucket)
    with (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket)).
  pose proof (Hlift _ _
    (DLL.dllseg_shift_rev_to_dllseg store_idnode
      newlink head head
      (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket)))) as Hconvert.
  rewrite SemaphoreCriticalViews.OSHeap_sep_eq, Hptr,
    SemaphoreCriticalViews.OSHeap_exp_eq in Hconvert.
  assert (HconvertOS :
    OSHeap (DLL.dllseg_shift_rev store_idnode newlink head
      (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket))) **
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head |--
    EX py, OSHeap (DLL.dllseg store_idnode newlink head head py
      (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket))) **
      &((head) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py).
  { intros st Hst. destruct (Hconvert st Hst) as [py Hpy].
    exists py. rewrite SemaphoreCriticalViews.OSHeap_sep_eq, Hptr in Hpy.
    exact Hpy. }
  sep_apply HconvertOS. Intros tail.
  assert (Hnz : DLL.dll_nodes_nonzero
      (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket))).
  { constructor; [exact PreH4|exact PreH6]. }
  assert (Htail : forall (l : list (DL_Node IdNodeAbs)) x px y py,
    DLL.dll_nodes_nonzero l -> px <> 0 ->
    Task_C_Rules.derivable1 (DLL.dllseg store_idnode x px y py l)
      (Task_C_Rules.coq_prop (py <> 0))).
  { intros l; induction l as [|a l IH]; intros x px y py Hnon Hpx st Hseg.
    - destruct Hseg as [[_ Heq] _]. congruence.
    - inversion Hnon as [|a' l' Ha Hl]; subst.
      destruct Hseg as [z [Hx [s1 [s2 [Hj [Hprefix Hrest]]]]]].
      change (x = a.(ptr)) in Hx.
      exact (IH z x y py Hl ltac:(congruence) s2 Hrest). }
  assert (HtailOS : OSHeap (DLL.dllseg store_idnode
    newlink head head tail
    (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket))) |-- “ tail <> 0 ”).
  { intros st [_ [_ Hseg]].
    exact (Htail _ _ _ _ _ Hnz PreH2 _ Hseg). }
  prop_apply_p HtailOS. Intros_p Htailnz.
  assert (Hfold :
    &((head) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> tail **
    &((head) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->
      newlink **
    OSHeap (DLL.dllseg store_idnode newlink
      head head tail (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket))) |--
    OSHeap (store_idnodes head (Build_IdNodeAbs id idnode_pre :: bucket))).
  { unfold store_idnodes, DLL.store_dll.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
    Exists newlink.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. Exists tail.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr.
    split_pure_spatial.
    - cancel (OSHeap (DLL.dllseg store_idnode
        newlink head head tail
        (idnodes_to_dll (Build_IdNodeAbs id idnode_pre :: bucket)))).
      cancel (&((head) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> tail).
      cancel (&((head) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> newlink).
    - dump_pre_spatial. repeat split; assumption. }
  sep_apply Hfold.
  pose proof (Hlift _ _
    (store_idbuckets_replace (htable sm) (hoffset sm) (id mod hoffset sm)
      bucket (Build_IdNodeAbs id idnode_pre :: bucket) (idbuckets before)
      (proj1 Hk) PreH5)) as Hreplace.
  rewrite SemaphoreCriticalViews.OSHeap_sep_eq in Hreplace.
  subst head. sep_apply Hreplace.
  unfold store_idmanager, idmanager_link, idmanager_add, idmanager_insert_bucket.
  cbn [idlist idbuckets].
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq,
    !OSHeap_ushort_eq, !Hptr, SemaphoreCriticalViews.OSHeap_pure_and_eq.
  split_pure_spatial.
  - rewrite <- PreH5.
    cancel (OSHeap (store_idbuckets (htable sm) (hoffset sm)
      (replace_Znth (id mod hoffset sm) (Build_IdNodeAbs id idnode_pre :: bucket)
        (idbuckets before)))).
    cancel (OSHeap (store_id_map (id_map sm) (idmax sm) (idlist_add id (idlist before)))).
    cancel (&((manager_pre) # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
    cancel (&((manager_pre) # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
    cancel (&((manager_pre) # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
    cancel (&((manager_pre) # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
  - dump_pre_spatial. rewrite <- PreH5. exact Hnewok.


Qed.

Lemma proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_InsertObj_return_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_safety_wit_1 : InsertObj_safety_wit_1.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_2 : InsertObj_safety_wit_2.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_3 : InsertObj_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_4 : InsertObj_safety_wit_4.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_6 : InsertObj_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_7 : InsertObj_safety_wit_7.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_8 : InsertObj_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_9 : InsertObj_safety_wit_9.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_10 : InsertObj_safety_wit_10.
Proof. Admitted. 


Lemma proof_of_InsertObj_partial_solve_wit_1_pure : InsertObj_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of_InsertObj_partial_solve_wit_1 : InsertObj_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of_InsertObj_partial_solve_wit_2_pure : InsertObj_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of_InsertObj_partial_solve_wit_2 : InsertObj_partial_solve_wit_2.
Proof. Admitted.
