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
From CRTOS_Verify.VC Require Import CriticalAreaUnLock_goal.
From CRTOS_Verify.VC Require Import CriticalAreaUnLock_proof_auto.
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

Lemma proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_1 : CriticalAreaUnLock_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_spatial : CriticalAreaUnLock_entail_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_CriticalAreaUnLock_entail_wit_1 : CriticalAreaUnLock_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial : CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_1 : CriticalAreaUnLock_entail_wit_2_1.
Proof. Admitted. 

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial : CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_2 : CriticalAreaUnLock_entail_wit_2_2.
Proof. Admitted. 

