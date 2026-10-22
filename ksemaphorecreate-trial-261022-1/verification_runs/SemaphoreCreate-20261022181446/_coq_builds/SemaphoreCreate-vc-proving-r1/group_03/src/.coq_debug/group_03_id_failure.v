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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply (proj1 (KSemaphoreCreateTrial.SemaphoreSpecBridge.idmanager_first_free_id_none_iff_full _ _)).
  assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial : _SemaphoreCreate_entail_wit_4_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (KSemaphoreCreateTrial.SemaphoreOwnership.semaphore_insert_failure_raw sem ltac:(assumption) ltac:(assumption) ltac:(assumption) ltac:(assumption)).
  unfold os_inv, semaphore_inv.
  assert (Hcontext := PreH16).
  unfold semaphore_context in Hcontext.
  destruct Hcontext as [Hmanager [_ [_ [_ [_ Hlist]]]]].
  rewrite Hmanager, Hlist.
  split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; assumption].
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1 : _SemaphoreCreate_entail_wit_4_1.
Proof.
  aggressive_pre_process.
  Show.
Abort.
