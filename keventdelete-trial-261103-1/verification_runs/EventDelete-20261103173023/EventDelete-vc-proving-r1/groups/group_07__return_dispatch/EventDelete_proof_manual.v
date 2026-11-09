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
From CRTOS_Verify.VC Require Import EventDelete_goal.
From CRTOS_Verify.VC Require Import EventDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.EventDelete_lib.
Local Open Scope sac.


Lemma proof_of__EventDelete_safety_wit_1 : _EventDelete_safety_wit_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_2 : _EventDelete_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_3 : _EventDelete_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_4 : _EventDelete_safety_wit_4.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_5 : _EventDelete_safety_wit_5.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_6 : _EventDelete_safety_wit_6.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_7 : _EventDelete_safety_wit_7.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_8 : _EventDelete_safety_wit_8.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_9 : _EventDelete_safety_wit_9.
Proof. Admitted. 

Lemma proof_of__EventDelete_safety_wit_10 : _EventDelete_safety_wit_10.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_1 : _EventDelete_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_2 : _EventDelete_entail_wit_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_3_1 : _EventDelete_entail_wit_3_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_3_2 : _EventDelete_entail_wit_3_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_5_1 : _EventDelete_entail_wit_5_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_5_2 : _EventDelete_entail_wit_5_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_6_1 : _EventDelete_entail_wit_6_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_6_2 : _EventDelete_entail_wit_6_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_return_wit_1 : _EventDelete_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
  all: match goal with
  | |- OutsideCritical ?sg ?s |-- _ =>
      Exists s; split_pure_spatial;
      [ cancel (OutsideCritical sg s) | dump_pre_spatial; assumption ]
  end.
Qed. 

Lemma proof_of__EventDelete_return_wit_2 : _EventDelete_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
  all: match goal with
  | |- OutsideCritical ?sg ?s |-- _ =>
      Exists s; split_pure_spatial;
      [ cancel (OutsideCritical sg s) | dump_pre_spatial; assumption ]
  end.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_1_pure : _EventDelete_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_1 : _EventDelete_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_2_pure : _EventDelete_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_2 : _EventDelete_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_3 : _EventDelete_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_4_pure : _EventDelete_partial_solve_wit_4_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_4 : _EventDelete_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_5_pure : _EventDelete_partial_solve_wit_5_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_5 : _EventDelete_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_6_pure : _EventDelete_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_6 : _EventDelete_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_7_pure : _EventDelete_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_7 : _EventDelete_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_8_pure : _EventDelete_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_8 : _EventDelete_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_9_pure : _EventDelete_partial_solve_wit_9_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_9 : _EventDelete_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_10_pure : _EventDelete_partial_solve_wit_10_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_10 : _EventDelete_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_11_pure : _EventDelete_partial_solve_wit_11_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_11 : _EventDelete_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_12_pure : _EventDelete_partial_solve_wit_12_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_12 : _EventDelete_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_13_pure : _EventDelete_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_13 : _EventDelete_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_14_pure : _EventDelete_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_14 : _EventDelete_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_15_pure : _EventDelete_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_15 : _EventDelete_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_16 : _EventDelete_partial_solve_wit_16.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_17 : _EventDelete_partial_solve_wit_17.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_18_pure : _EventDelete_partial_solve_wit_18_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_18 : _EventDelete_partial_solve_wit_18.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_19_pure : _EventDelete_partial_solve_wit_19_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_19 : _EventDelete_partial_solve_wit_19.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_20 : _EventDelete_partial_solve_wit_20.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_21 : _EventDelete_partial_solve_wit_21.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_22 : _EventDelete_partial_solve_wit_22.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_23 : _EventDelete_partial_solve_wit_23.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_24 : _EventDelete_partial_solve_wit_24.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_25 : _EventDelete_partial_solve_wit_25.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_26_pure : _EventDelete_partial_solve_wit_26_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_26 : _EventDelete_partial_solve_wit_26.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_27_pure : _EventDelete_partial_solve_wit_27_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_27 : _EventDelete_partial_solve_wit_27.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_28 : _EventDelete_partial_solve_wit_28.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_29 : _EventDelete_partial_solve_wit_29.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_30 : _EventDelete_partial_solve_wit_30.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_31 : _EventDelete_partial_solve_wit_31.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_32_pure : _EventDelete_partial_solve_wit_32_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_32 : _EventDelete_partial_solve_wit_32.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_1 : _EventDelete_entail_wit_4_1_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_2 : _EventDelete_entail_wit_4_1_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_spatial : _EventDelete_entail_wit_4_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_1 : _EventDelete_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_1 : _EventDelete_entail_wit_4_2_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_2 : _EventDelete_entail_wit_4_2_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_spatial : _EventDelete_entail_wit_4_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_2 : _EventDelete_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_1 : _EventDelete_entail_wit_4_3_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_2 : _EventDelete_entail_wit_4_3_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_spatial : _EventDelete_entail_wit_4_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_3 : _EventDelete_entail_wit_4_3.
Proof. Admitted. 

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_1 : _EventDelete_entail_wit_4_4_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_2 : _EventDelete_entail_wit_4_4_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_spatial : _EventDelete_entail_wit_4_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_entail_wit_4_4 : _EventDelete_entail_wit_4_4.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1 : _EventDelete_partial_solve_wit_20_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_partial_solve_wit_20_pure : _EventDelete_partial_solve_wit_20_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1 : _EventDelete_partial_solve_wit_21_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_partial_solve_wit_21_pure : _EventDelete_partial_solve_wit_21_pure.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_1 : _EventDelete_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_1 : _EventDelete_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_spatial : _EventDelete_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_2 : _EventDelete_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_1 : _EventDelete_which_implies_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_2 : _EventDelete_which_implies_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_3 : _EventDelete_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_4_split_goal_1 : _EventDelete_which_implies_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_4 : _EventDelete_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_1 : _EventDelete_which_implies_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_2 : _EventDelete_which_implies_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_5 : _EventDelete_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_6 : _EventDelete_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_7_split_goal_spatial : _EventDelete_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_7 : _EventDelete_which_implies_wit_7.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_8_split_goal_spatial : _EventDelete_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_8 : _EventDelete_which_implies_wit_8.
Proof. Admitted. 

Lemma proof_of__EventDelete_which_implies_wit_9_split_goal_spatial : _EventDelete_which_implies_wit_9_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventDelete_which_implies_wit_9 : _EventDelete_which_implies_wit_9.
Proof. Admitted. 

