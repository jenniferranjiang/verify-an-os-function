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

Lemma dllseg_fresh_value__open_id : forall wait sem l x px y py,
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0
  |-- “ ~ In sem (map semaphore_addr l) ”.
Proof.
  intros wait sem l. induction l as [|a l IH]; intros x px y py.
  - simpl. Intros_p Hends. dump_pre_spatial. simpl. tauto.
  - simpl dllseg. Intros z.
    destruct (Z.eq_dec sem (semaphore_addr a)) as [Heq|Hneq].
    + unfold store_semaphore. Intros_p Ha.
      subst sem. unfold store_ushort. Intros_p H1. Intros_p H2.
      sepcon_right_assoc.
      let p := constr:(semaphore_addr a) in
      sep_apply_l_atomic (dup_store_2bytes (&(p # "Semaphore" ->ₛ "value")) (semaphore_value a) 0).
      Intros_p Hfalse. contradiction.
    + sepcon_right_assoc. sep_apply_l_atomic (IH z x y py). Intros_p Hfresh.
      dump_pre_spatial. simpl. intuition.
Qed.
