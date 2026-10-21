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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro m.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp,
      Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty, CrtosHeapBridge.crtos_heap_state.
    simpl. split.
    - intros [Ht [Hs [Hm _]]]. exact (conj Hm (conj Ht Hs)).
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity. }
  prop_apply_p (valid_store_ushort (&(idnode_pre # "IdNode" ->ₛ "id")) id).
  Intros_p Hvalid.
  assert (Hlink : &(idnode_pre # "IdNode" ->ₛ "link") <> 0).
  { destruct Hvalid as [_ [Hlower _]]. simpl in Hlower |- *. let T := type of Hlower in idtac T. match goal with |- ?G => idtac G end. lia. }
  Exists bucket_2 head.
  split_pure_spatial.
  - rewrite PreH12.
    simpl idnodes_to_dll.
    unfold DLL.dllseg_shift_rev.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, Hemp.
    cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
    cancel (OSHeap (store_id_map (id_map sm) (idmax sm) (idlist_add id (idlist before)))).
    cancel (&(idnode_pre # "IdNode" ->ₛ "id") # UShort |-> id).
    cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
    cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
    cancel (OSHeap (store_idbuckets_except (htable sm) (id % hoffset sm) nil (idbuckets before))).
    cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head).
    cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head).
    split_pure_spatial; [cancel | split_pures; dump_pre_spatial; reflexivity].
  - split_pures; dump_pre_spatial; try assumption.
    rewrite PreH12. unfold idnodes_nonzero, idnodes_to_dll, DLL.dll_nodes_nonzero. constructor.
Qed. 

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_1 : InsertObj_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_spatial : InsertObj_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.
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
  prop_apply_p (valid_store_ushort (&(idnode_pre # "IdNode" ->ₛ "id")) id).
  Intros_p Hvalid.
  assert (Hlink : &(idnode_pre # "IdNode" ->ₛ "link") <> 0).
  { destruct Hvalid as [_ [Hlower _]]. simpl in Hlower |- *. let T := type of Hlower in idtac T. match goal with |- ?G => idtac G end. lia. }
  pose proof (CrtosHeapBridge.crtos_heap_lift_entails Crtos_STS.sts _ _
    (DLL.dllseg_to_dllseg_shift_rev store_idnode hn head head hp (idnodes_to_dll bucket_2))) as Hshift.
  change (OSHeap (Task_C_Rules.sepcon
    (DLL.dllseg store_idnode hn head head hp (idnodes_to_dll bucket_2))
    (Task_C_Rules.store_ptr (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev")) hp)) |--
    OSHeap (Task_C_Rules.sepcon
    (DLL.dllseg_shift_rev store_idnode hn head (idnodes_to_dll bucket_2))
    (Task_C_Rules.store_ptr (&(hn # "SysDoubleLinklistNode" ->ₛ "node_prev")) head))) in Hshift.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr in Hshift.
  unfold idnodes_dllseg.
  sep_apply_l_atomic Hshift.
  Exists bucket_2 hn.
  split_pure_spatial.
  -
    cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
    cancel (OSHeap (store_id_map (id_map sm) (idmax sm) (idlist_add id (idlist before)))).
    cancel (&(idnode_pre # "IdNode" ->ₛ "id") # UShort |-> id).
    cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
    cancel (&(idnode_pre # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
    cancel (OSHeap (store_idbuckets_except (htable sm) (id % hoffset sm) bucket_2 (idbuckets before))).
    cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hn).
    cancel (&(hn # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head).
    cancel (OSHeap (DLL.dllseg_shift_rev store_idnode hn head (idnodes_to_dll bucket_2))).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

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
