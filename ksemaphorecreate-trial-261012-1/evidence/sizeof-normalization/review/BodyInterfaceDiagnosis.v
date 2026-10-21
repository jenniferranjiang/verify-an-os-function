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
Require Coq.Program.Basics.
Local Open Scope sac.


Fail Check data.
Fail Check ptr.
Check (@getData : forall A : Type, DL_Node A -> A).
Check (@getPtr : forall A : Type, DL_Node A -> Z).
Check (@Basics.const (SemaphoreObject -> Task_C_Rules.expr) Z : (SemaphoreObject -> Task_C_Rules.expr) -> Z -> SemaphoreObject -> Task_C_Rules.expr).
Check (@List.map (DL_Node SemaphoreObject) SemaphoreObject : (DL_Node SemaphoreObject -> SemaphoreObject) -> list (DL_Node SemaphoreObject) -> SemaphoreState).
Example const_payload_reduces : forall (p : Z) (obj : SemaphoreObject), Basics.const store_semaphore_body p obj = store_semaphore_body obj.
Proof. reflexivity. Qed.
Print Assumptions const_payload_reduces.
