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
  unfold store_idmanager_allocated_unlinked, store_sem_id_detached.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq,
    !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !OSHeap_ushort_eq, !Hptr.
  Intros.
  prop_apply (store_ushort_range (&(idnode_pre # "IdNode" ->ₛ "id")) id).
  prop_apply (store_ushort_range (&(manager_pre # "IdManager" ->ₛ "hoffset")) (hoffset sm)).
  Intros.
  sep_apply (store_ptr_undef_store_ptr (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_prev")) previous).
  sep_apply (store_ptr_undef_store_ptr (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_next")) next).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; unfold idbuckets_ok in *; tauto.
Qed. 

Lemma proof_of_InsertObj_entail_wit_2 : InsertObj_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite Z.rem_mod_nonneg by lia.
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
  assert (Horp : forall P Q,
    OSHeap (Task_C_Rules.orp P Q) = OSHeap P || OSHeap Q).
  { intros P Q. apply functional_extensionality; intro m.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.orp, orp.
    tauto. }
  assert (Hindex : 0 <= id mod hoffset sm < Zlength (idbuckets before)).
  { pose proof (Z.mod_pos_bound id (hoffset sm) ltac:(lia)).
    unfold idbuckets_ok in *. lia. }
  sep_apply (SemaphoreCriticalViews.OSHeap_entails _ _
    (store_idbuckets_split (htable sm) (hoffset sm) (id mod hoffset sm)
      (idbuckets before) Hindex)).
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros bucket.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    SemaphoreCriticalViews.OSHeap_sep_eq.
  Intros_p Hbucket.
  sep_apply (SemaphoreCriticalViews.OSHeap_entails _ _
    (store_idbucket_cases
      (htable sm + (id mod hoffset sm) * sizeof("SysDoubleLinklistNode")) bucket)).
  rewrite Horp.
  Split.
  - rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr.
    Intros_p Hcase.
    Left. Exists bucket.
    split_pure_spatial.
    + cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
      cancel (OSHeap (store_id_map (id_map sm) (idmax sm) (idlist_add id (idlist before)))).
      cancel (&(idnode_pre # "IdNode" ->ₛ "id") # UShort |-> id).
      cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
      cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
      cancel (OSHeap (store_idbuckets_except (htable sm) (id mod hoffset sm) bucket (idbuckets before))).
      cancel.
    + split_pures; dump_pre_spatial; tauto.
  - rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
    Intros hp.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
    Intros hn.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr.
    Intros_p Hcase.
    Right. Exists hn hp bucket.
    split_pure_spatial.
    + cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
      cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
      cancel (OSHeap (store_id_map (id_map sm) (idmax sm) (idlist_add id (idlist before)))).
      cancel (&(idnode_pre # "IdNode" ->ₛ "id") # UShort |-> id).
      cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
      cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
      cancel (OSHeap (store_idbuckets_except (htable sm) (id mod hoffset sm) bucket (idbuckets before))).
      cancel.
    + split_pures; dump_pre_spatial; tauto.
Qed. 

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_1 : InsertObj_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_spatial : InsertObj_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1 : InsertObj_entail_wit_3_1.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_spatial : InsertObj_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.
Proof. Admitted. 

Lemma proof_of_InsertObj_return_wit_1_split_goal_spatial : InsertObj_return_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Proof. Admitted.

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
