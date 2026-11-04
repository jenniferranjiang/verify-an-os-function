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
From CRTOS_Verify.VC Require Import KEventDelete_goal.
From CRTOS_Verify.VC Require Import KEventDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.KEventDelete_lib.
Local Open Scope sac.


Lemma proof_of_KEventDelete_safety_wit_1 : KEventDelete_safety_wit_1.
Proof. Admitted. 

Lemma proof_of_KEventDelete_safety_wit_2 : KEventDelete_safety_wit_2.
Proof. Admitted. 

Lemma proof_of_KEventDelete_safety_wit_3 : KEventDelete_safety_wit_3.
Proof. Admitted. 

Lemma proof_of_KEventDelete_safety_wit_4 : KEventDelete_safety_wit_4.
Proof. Admitted. 

Lemma proof_of_KEventDelete_return_wit_2 : KEventDelete_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_2.
  split_pure_spatial.
  - cancel (OutsideCritical sg_event_delete_oc after_2).
  - dump_pre_spatial. exact PreH1.
Qed.

Lemma proof_of_KEventDelete_partial_solve_wit_1_pure : KEventDelete_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_1 : KEventDelete_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_2_pure : KEventDelete_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_2 : KEventDelete_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_3_pure : KEventDelete_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_3 : KEventDelete_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_4_pure : KEventDelete_partial_solve_wit_4_pure.
Proof. Admitted. 

Lemma proof_of_KEventDelete_partial_solve_wit_4 : KEventDelete_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of_KEventDelete_return_wit_1_split_goal_1 : KEventDelete_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_KEventDelete_return_wit_1 : KEventDelete_return_wit_1.
Proof. Admitted. 

Lemma proof_of_KEventDelete_which_implies_wit_1_split_goal_1 : KEventDelete_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_KEventDelete_which_implies_wit_1 : KEventDelete_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_KEventDelete_which_implies_wit_2_split_goal_1 : KEventDelete_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_KEventDelete_which_implies_wit_2 : KEventDelete_which_implies_wit_2.
Proof. Admitted. 

