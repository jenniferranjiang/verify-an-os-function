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
From CRTOS_Verify.VC Require Import MutexCreate_goal.
From CRTOS_Verify.VC Require Import MutexCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.KMutexCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.MutexCreate_lib.
Local Open Scope sac.


Lemma proof_of__MutexCreate_safety_wit_1 : _MutexCreate_safety_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_2 : _MutexCreate_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_3 : _MutexCreate_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_4 : _MutexCreate_safety_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_5 : _MutexCreate_safety_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_6 : _MutexCreate_safety_wit_6.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_7 : _MutexCreate_safety_wit_7.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_8 : _MutexCreate_safety_wit_8.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_9 : _MutexCreate_safety_wit_9.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_10 : _MutexCreate_safety_wit_10.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_11 : _MutexCreate_safety_wit_11.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_12 : _MutexCreate_safety_wit_12.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_13 : _MutexCreate_safety_wit_13.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_14 : _MutexCreate_safety_wit_14.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_15 : _MutexCreate_safety_wit_15.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_16 : _MutexCreate_safety_wit_16.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_17 : _MutexCreate_safety_wit_17.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_18 : _MutexCreate_safety_wit_18.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_19 : _MutexCreate_safety_wit_19.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_20 : _MutexCreate_safety_wit_20.
Proof. Admitted. 

Lemma proof_of__MutexCreate_return_wit_1 : _MutexCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists (replace_mutexes (mutex_publish retval_2 retval (os_mutexes st_lock)) st_lock).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__MutexCreate_return_wit_2 : _MutexCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_1_pure : _MutexCreate_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_1 : _MutexCreate_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_2_pure : _MutexCreate_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_2 : _MutexCreate_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_3_pure : _MutexCreate_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_3 : _MutexCreate_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_4 : _MutexCreate_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_5 : _MutexCreate_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_6 : _MutexCreate_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_7_pure : _MutexCreate_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_7 : _MutexCreate_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_8_pure : _MutexCreate_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_8 : _MutexCreate_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_9 : _MutexCreate_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_10 : _MutexCreate_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_11 : _MutexCreate_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_12_pure : _MutexCreate_partial_solve_wit_12_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_12 : _MutexCreate_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_13 : _MutexCreate_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_14_pure : _MutexCreate_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_14 : _MutexCreate_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_15_pure : _MutexCreate_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_15 : _MutexCreate_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__MutexCreate_entail_wit_1_1 : _MutexCreate_entail_wit_1_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_entail_wit_1_2 : _MutexCreate_entail_wit_1_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_return_wit_3_split_goal_1 : _MutexCreate_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_mutex_create in PreH3 at 1.
  prog_nf in PreH3.
  safe_choice_l PreH3.
  exact PreH3.
Qed.

Lemma proof_of__MutexCreate_return_wit_3 : _MutexCreate_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexCreate_return_wit_3_split_goal_1.
Qed. 

Lemma proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1 : _MutexCreate_partial_solve_wit_13_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_partial_solve_wit_13_pure : _MutexCreate_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_1 : _MutexCreate_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_2 : _MutexCreate_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial : _MutexCreate_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1 : _MutexCreate_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_1 : _MutexCreate_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_2 : _MutexCreate_which_implies_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_3 : _MutexCreate_which_implies_wit_2_split_goal_3.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_4 : _MutexCreate_which_implies_wit_2_split_goal_4.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial : _MutexCreate_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_2 : _MutexCreate_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_1 : _MutexCreate_which_implies_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_2 : _MutexCreate_which_implies_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial : _MutexCreate_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_3 : _MutexCreate_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_4 : _MutexCreate_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial : _MutexCreate_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_5 : _MutexCreate_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_1 : _MutexCreate_which_implies_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_2 : _MutexCreate_which_implies_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_3 : _MutexCreate_which_implies_wit_6_split_goal_3.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_4 : _MutexCreate_which_implies_wit_6_split_goal_4.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial : _MutexCreate_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6 : _MutexCreate_which_implies_wit_6.
Proof. Admitted. 

