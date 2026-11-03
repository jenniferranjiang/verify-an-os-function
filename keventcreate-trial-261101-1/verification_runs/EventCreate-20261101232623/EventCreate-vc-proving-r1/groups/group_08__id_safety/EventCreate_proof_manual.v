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
From CRTOS_Verify.VC Require Import EventCreate_goal.
From CRTOS_Verify.VC Require Import EventCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.KEventCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.EventCreate_lib.
Local Open Scope sac.


Lemma proof_of__EventCreate_safety_wit_1 : _EventCreate_safety_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_2 : _EventCreate_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_3 : _EventCreate_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_4 : _EventCreate_safety_wit_4.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_5 : _EventCreate_safety_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_6 : _EventCreate_safety_wit_6.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_7 : _EventCreate_safety_wit_7.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_8 : _EventCreate_safety_wit_8.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_9 : _EventCreate_safety_wit_9.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_10 : _EventCreate_safety_wit_10.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_11 : _EventCreate_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_12 : _EventCreate_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_13 : _EventCreate_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_14 : _EventCreate_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (PreH2 PreH7) as Hrange.
  split_pures.
  dump_pre_spatial. lia.
Qed. 

Lemma proof_of__EventCreate_safety_wit_15 : _EventCreate_safety_wit_15.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_16 : _EventCreate_safety_wit_16.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_1 : _EventCreate_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_uint_range (&("options")) options_pre).
  Intros_p Hrange.
  change (0 <= options_pre <= 4294967295) in Hrange.
  split_pure_spatial.
  - cancel ((&("options")) # UInt |-> options_pre).
    cancel (OutsideCritical sg_outside_critical before_outside_critical).
  - split_pures; dump_pre_spatial; try assumption; int_auto.
Qed. 

Lemma proof_of__EventCreate_return_wit_1 : _EventCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_return_wit_2 : _EventCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_1_pure : _EventCreate_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_1 : _EventCreate_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_2_pure : _EventCreate_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_2 : _EventCreate_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_3_pure : _EventCreate_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_3 : _EventCreate_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_4 : _EventCreate_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_5 : _EventCreate_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_6 : _EventCreate_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_7_pure : _EventCreate_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_7 : _EventCreate_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_8_pure : _EventCreate_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_8 : _EventCreate_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_9 : _EventCreate_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_10 : _EventCreate_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_11 : _EventCreate_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_12_pure : _EventCreate_partial_solve_wit_12_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_12 : _EventCreate_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_13 : _EventCreate_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_14_pure : _EventCreate_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_14 : _EventCreate_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_15_pure : _EventCreate_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_15 : _EventCreate_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_2_1 : _EventCreate_entail_wit_2_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_2_2 : _EventCreate_entail_wit_2_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_return_wit_3_split_goal_1 : _EventCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_return_wit_3 : _EventCreate_return_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_13_pure_split_goal_1 : _EventCreate_partial_solve_wit_13_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_partial_solve_wit_13_pure : _EventCreate_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_1 : _EventCreate_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_2 : _EventCreate_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_spatial : _EventCreate_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1 : _EventCreate_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_1 : _EventCreate_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_2 : _EventCreate_which_implies_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_3 : _EventCreate_which_implies_wit_2_split_goal_3.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_4 : _EventCreate_which_implies_wit_2_split_goal_4.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_spatial : _EventCreate_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2 : _EventCreate_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_1 : _EventCreate_which_implies_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_2 : _EventCreate_which_implies_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_spatial : _EventCreate_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_3 : _EventCreate_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_4 : _EventCreate_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_5_split_goal_spatial : _EventCreate_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_5 : _EventCreate_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_1 : _EventCreate_which_implies_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_2 : _EventCreate_which_implies_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_3 : _EventCreate_which_implies_wit_6_split_goal_3.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_4 : _EventCreate_which_implies_wit_6_split_goal_4.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_spatial : _EventCreate_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6 : _EventCreate_which_implies_wit_6.
Proof. Admitted. 

