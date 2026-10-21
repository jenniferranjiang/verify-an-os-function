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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH7 as [[Hidlo Hidhi] _].
  destruct PreH8 as [Hm0 [Hmmax _]].
  assert (end <= 8192) as Hend.
  { rewrite PreH2, Z.quot_div_nonneg by lia.
    apply Z.div_le_upper_bound; lia. }
  unfold INT_MAX. lia.
Qed.

Lemma proof_of_AllocId_safety_wit_22_split_goal_2 : AllocId_safety_wit_22_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH7 as [[Hidlo Hidhi] _].
  unfold INT_MIN. lia.
Qed.

Lemma proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_safety_wit_22_split_goal_1.
  Goal_apply proof_of_AllocId_safety_wit_22_split_goal_2.
Qed. 

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range (idmax sm) (idlist before) bytes index PreH11 ltac:(lia)) as Hb.
  unfold allocid_entry_scan_inv.
  split; [lia|]. split; [exact Hb|].
  exists 0. rewrite Z.shiftr_0_r.
  repeat split; try lia.
  intros bit Hbit. lia.
Qed.

Lemma proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_entail_wit_5_split_goal_1.
Qed. 

Lemma proof_of_AllocId_entail_wit_6_split_goal_1 : AllocId_entail_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range (idmax sm) (idlist before) bytes index PreH8 ltac:(lia)) as Hb.
  destruct PreH7 as [Hid [He [offset [Hiddef [Hoffset [Hentry Hprefix]]]]]].
  assert (offset < 8) as Hoffsetlt.
  { destruct (Z.eq_dec offset 8) as [Heq | Hneq]; [|lia].
    exfalso. apply PreH5. apply byte_eq_255_of_low_bits; [exact Hb|].
    intros bit Hbit. apply Hprefix. lia. }
  assert (Z.testbit entry 0 = true) as Hcurrent.
  { rewrite Z.bit0_odd.
    replace 1 with (Z.ones 1) in PreH10 by reflexivity.
    rewrite Z.land_ones in PreH10 by lia.
    change (entry mod 2 <> 0) in PreH10.
    rewrite Zmod_odd in PreH10.
    destruct (Z.odd entry); congruence. }
  assert (Z.testbit (Znth index bytes 0) offset = true) as Hnextbit.
  { rewrite Hentry, Z.shiftr_spec in Hcurrent by lia.
    exact Hcurrent. }
  assert (0 <= Z.shiftr entry 1 <= 255) as Hshift.
  { rewrite Z.shiftr_div_pow2 by lia. change (0 <= entry / 2 <= 255).
    split; [apply Z.div_pos; lia|apply Z.div_le_upper_bound; lia]. }
  assert (unsigned_last_nbits (Z.shiftr entry 1) 8 = Z.shiftr entry 1) as Hcast.
  { unfold unsigned_last_nbits. rewrite Z.mod_small; lia. }
  rewrite Hcast.
  unfold allocid_entry_scan_inv.
  split; [lia|]. split; [exact Hshift|].
  exists (offset + 1). repeat split; try lia.
  - rewrite Hentry, Z.shiftr_shiftr by lia. reflexivity.
  - intros bit Hbit. destruct (Z.eq_dec bit offset) as [->|Hneq].
    + exact Hnextbit.
    + apply Hprefix. lia.
Qed.

Lemma proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_entail_wit_6_split_goal_1.
Qed. 

Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Proof. Admitted. 

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
