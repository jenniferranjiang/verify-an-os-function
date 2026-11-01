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
From CRTOS_Verify.VC Require Import KSemaphoreDelete_goal.
From CRTOS_Verify.VC Require Import KSemaphoreDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KSemaphoreDelete CRTOS_Verify.lib.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_KSemaphoreDelete_return_wit_1 : KSemaphoreDelete_return_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  Exists after_2.
  split_pure_spatial.
  - cancel.
  - dump_pre_spatial. exact PreH1.
Qed. 


Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1_pure : KSemaphoreDelete_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1 : KSemaphoreDelete_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  unfold KSemaphoreDelete_partial_solve_wit_1_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.
