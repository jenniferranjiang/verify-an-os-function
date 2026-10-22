From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(* Current model imports for proof helpers; no generated-artifact dependency. *)
From Coq Require Import Bool Strings.String Classes.RelationClasses Classes.Morphisms.
From Coq Require Import micromega.Psatz Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import SetsNotation IDNode DLL Monad MonadNotation.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Local Open Scope monad.
Local Open Scope sac.



(* Bridges proved against the frozen VRTOS interfaces and explicit layout premise. *)
Require Import KSemaphoreCreateTrial.SemaphoreByteLayout.
Require Import KSemaphoreCreateTrial.SemaphoreOwnership.
Require Import KSemaphoreCreateTrial.SemaphoreSpecBridge.
Require Import TrialShared.DoubleLinkListSpec.

Lemma atomic_normal_return__returns {A : Type}
    (cmd : program VarGlobalState A)
    (before st after : VarGlobalState) (a : A) X :
  Crtos_RTrans before st ->
  MonadErr.nrm cmd st a after ->
  safeExec (LastSeen before) (task_atomic_cmd cmd) X ->
  safeExec (LastSeen after) (MonadErr.ret a) X.
Proof.
  intros Hrely Hstep Hsafe.
  eapply (highstependret_derive (task_atomic_cmd cmd)
    (LastSeen before) a (fun _ => LastSeen after)); [|exact Hsafe].
  intros states Hstates.
  exists (Crtos_RTrans after).
  split.
  - exists st, after. split.
    + apply (proj2 (Hstates st)). exact Hrely.
    + split; [exact Hstep | reflexivity].
  - unfold LastSeen. reflexivity.
Qed.
