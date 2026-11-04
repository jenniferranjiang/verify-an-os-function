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
From KMutexDeleteProof.VC Require Import MutexResumeAll_goal.
From KMutexDeleteProof.VC Require Import MutexResumeAll_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import KMutexDeleteProof.VC.MutexResumeAll_lib.
Local Open Scope sac.


Lemma proof_of_LinklistResumeAll_safety_wit_1 : LinklistResumeAll_safety_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_1_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_2_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial : LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial : LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial : LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1 : LinklistResumeAll_which_implies_wit_9_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2 : LinklistResumeAll_which_implies_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3 : LinklistResumeAll_which_implies_wit_9_split_goal_3.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.
Proof. Admitted. 

Lemma proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.
Proof. Admitted. 

Lemma proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.
Proof. Admitted. 

