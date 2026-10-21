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
From CRTOS_Verify.VC Require Import KSemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import KSemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_3.
  split_pure_spatial.
  - cancel (OutsideCritical sg after_3).
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_3.
  split_pure_spatial.
  - cancel (OutsideCritical sg after_3).
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.
Proof. Admitted.
