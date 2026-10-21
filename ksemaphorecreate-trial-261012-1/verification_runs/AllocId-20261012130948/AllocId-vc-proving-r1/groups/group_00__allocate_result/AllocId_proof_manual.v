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

Lemma proof_of_AllocId_safety_wit_9_split_goal_1 : AllocId_safety_wit_9_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_9_split_goal_2 : AllocId_safety_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_AllocId_safety_wit_19_split_goal_1 : AllocId_safety_wit_19_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_19_split_goal_2 : AllocId_safety_wit_19_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.
Proof. Admitted. 

Lemma proof_of_AllocId_safety_wit_22_split_goal_1 : AllocId_safety_wit_22_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_22_split_goal_2 : AllocId_safety_wit_22_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Proof. Admitted. 

Lemma proof_of_AllocId_safety_wit_27_split_goal_1 : AllocId_safety_wit_27_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_2 : AllocId_safety_wit_27_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_3 : AllocId_safety_wit_27_split_goal_3.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_4 : AllocId_safety_wit_27_split_goal_4.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_3_split_goal_1 : AllocId_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_3_split_goal_2 : AllocId_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_4_split_goal_1 : AllocId_entail_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_5_split_goal_1 : AllocId_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_6_split_goal_1 : AllocId_entail_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range _ _ _ _ PreH9 ltac:(lia)) as Hb.
  destruct PreH8 as [Hidrange [Hentry [offset [Hid [Hoffset [Hshift Hlow]]]]]].
  assert (Hoff : 0 <= offset < 8).
  { split; [lia|]. destruct (Z.eq_dec offset 8); [|lia].
    exfalso; apply PreH6; apply byte_eq_255_of_low_bits; [exact Hb|].
    intros bit Hbit; apply Hlow; lia. }
  assert (Hnonneg : 0 <= id) by lia.
  assert (Hdiv : id / 8 = index) by (rewrite Hid; apply div8_add_offset; exact Hoff).
  assert (Hmod : id mod 8 = offset) by (rewrite Hid; apply mod8_add_offset; exact Hoff).
  assert (Hfreebit : Z.testbit (Znth index bytes 0) offset = false).
  { pose proof (f_equal (fun z => Z.testbit z 0) PreH11) as Hbit.
    rewrite Z.land_spec, Hshift, Z.shiftr_spec in Hbit by lia.
    simpl in Hbit. rewrite Bool.andb_true_r in Hbit. exact Hbit. }
  assert (Hfree : idmanager_query before id = false).
  { rewrite (id_map_bytes_ok_query_eq sm before bytes id PreH9 ltac:(lia)).
    rewrite Hdiv, Hmod; exact Hfreebit. }
  assert (Hmin : idmanager_min_free_id sm before id).
  { split; [lia|]. split; [exact Hfree|]. intros query Hquery.
    rewrite (id_map_bytes_ok_query_eq sm before bytes query PreH9 ltac:(lia)).
    pose proof (Z.mod_pos_bound query 8 ltac:(lia)) as Hqr.
    pose proof (Z.div_mod query 8 ltac:(lia)) as Hrepr.
    assert (Hqnonneg : 0 <= query / 8) by (apply Z.div_pos; lia).
    destruct (Z_lt_ge_dec (query / 8) index) as [Hbefore|Hsame].
    - rewrite (proj2 PreH7 (query / 8) ltac:(lia)). apply Ztestbit_255_low; exact Hqr.
    - assert (Hqi : query / 8 = index) by lia.
      rewrite Hqi. apply Hlow; lia. }
  Right.
Qed.

Lemma proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Proof. Admitted.

Lemma proof_of_AllocId_safety_wit_1 : AllocId_safety_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_14 : AllocId_safety_wit_14.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_15 : AllocId_safety_wit_15.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_30 : AllocId_safety_wit_30.
Proof. Admitted. 


Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.
Proof. Admitted.
