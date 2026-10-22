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
From CRTOS_Verify.VC Require Import SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import SemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Require Import TrialShared.DoubleLinkListSpec.
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.SemaphoreCreate_lib.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_1 : _SemaphoreCreate_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_2 : _SemaphoreCreate_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_3 : _SemaphoreCreate_entail_wit_3_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial : _SemaphoreCreate_entail_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1 : _SemaphoreCreate_entail_wit_4_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial : _SemaphoreCreate_entail_wit_4_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1 : _SemaphoreCreate_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1 : _SemaphoreCreate_entail_wit_4_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2 : _SemaphoreCreate_entail_wit_4_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial : _SemaphoreCreate_entail_wit_4_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2 : _SemaphoreCreate_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial : _SemaphoreCreate_entail_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_1 : _SemaphoreCreate_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial : _SemaphoreCreate_entail_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_7 : _SemaphoreCreate_entail_wit_7.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof. Admitted. 

