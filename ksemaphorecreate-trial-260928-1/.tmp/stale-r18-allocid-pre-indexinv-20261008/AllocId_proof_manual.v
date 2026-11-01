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
From CRTOS_Verify.VC Require Import AllocId_goal.
From CRTOS_Verify.VC Require Import AllocId_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Local Open Scope sac.

Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Proof.
  unfold AllocId_safety_wit_8. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH4;
    destruct PreH4 as (_ & _ & _ & _ & Hidlimit & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Proof.
  unfold AllocId_safety_wit_18. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH5;
    destruct PreH5 as (_ & _ & _ & _ & Hidlimit & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit in PreH6;
    vm_compute in PreH6; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Proof.
  unfold AllocId_safety_wit_21. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH2;
    destruct PreH2 as (_ & _ & _ & _ & Hidlimit & _);
    unfold semaphore_alloc_entry_inv in PreH6;
    destruct PreH6 as (offset & Hid & Hoff & _ & _ & _ & _ & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit in *.
  all: vm_compute in PreH3; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Proof.
  unfold AllocId_safety_wit_26. left. intros.
  pose proof PreH7 as Hentry.
  unfold semaphore_alloc_entry_inv in Hentry.
  destruct Hentry as
    (offset & Hid & Hoff & _ & _ & _ & _ & _).
  assert (Hid_nonneg : 0 <= id) by nia.
  entailer!.
  - pose proof
      (Z.rem_bound_pos_pos id 8 ltac:(lia) Hid_nonneg) as Hrem.
    lia.
  - pose proof
      (Z.rem_bound_pos_pos id 8 ltac:(lia) Hid_nonneg) as Hrem.
    lia.
  - pose proof (signed_Lastnbits_range
      (1 * 2 ^ (Z.rem id 8)) 32 ltac:(lia)) as Hsigned.
    change (-2147483648 <= signed_last_nbits
      (1 * 2 ^ (Z.rem id 8)) 32 < 2147483648) in Hsigned.
    lia.
  - pose proof (signed_Lastnbits_range
      (1 * 2 ^ (Z.rem id 8)) 32 ltac:(lia)) as Hsigned.
    change (-2147483648 <= signed_last_nbits
      (1 * 2 ^ (Z.rem id 8)) 32 < 2147483648) in Hsigned.
    lia.
Qed.

Lemma proof_of_AllocId_entail_wit_1_split_goal_1 : AllocId_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_1_split_goal_2 : AllocId_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_2_split_goal_1 : AllocId_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_3_split_goal_1 : AllocId_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_4_split_goal_1 : AllocId_entail_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_2_split_goal_1 : AllocId_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_return_wit_2_split_goal_spatial : AllocId_return_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_3_split_goal_1 : AllocId_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_return_wit_3_split_goal_spatial : AllocId_return_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Proof. Admitted. 

Lemma proof_of_AllocId_which_implies_wit_1 : AllocId_which_implies_wit_1.
Proof. Admitted. 
