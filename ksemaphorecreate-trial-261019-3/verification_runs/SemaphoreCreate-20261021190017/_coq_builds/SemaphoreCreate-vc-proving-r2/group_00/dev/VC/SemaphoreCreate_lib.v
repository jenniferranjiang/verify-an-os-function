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

Lemma fresh_semaphore__raw_open : forall wait head ss sem,
  store_dll (store_semaphore wait) head (map semaphore_link_node ss) **
  SemaphoreZero sem |-- “ ~ In sem (map semaphore_addr ss) ”.
Proof.
  intros wait head ss sem.
  destruct (in_dec Z.eq_dec sem (map semaphore_addr ss)) as [Hin|Hout].
  - apply in_map_iff in Hin as [s [Heq Hin]].
    apply in_split in Hin as [l [r Hlist]].
    unfold SemaphoreZero.
    Intros_p Hzero.
    rewrite Hlist, map_app. simpl map.
    unfold store_dll at 1.
    Intros h pt.
    sep_apply_l_atomic (dllseg_split (store_semaphore wait) h head head pt
      (map semaphore_link_node l) (semaphore_link_node s :: map semaphore_link_node r)).
    Intros y py.
    cbn [dllseg].
    Intros z.
    unfold store_semaphore.
    Intros_p Hsem.
    cbn [semaphore_link_node getData getPtr].
    rewrite Heq.
    unfold store_ushort.
    Intros.
    prop_apply_p (dup_store_2bytes (&(sem # "Semaphore" ->ₛ "value")) (semaphore_value s) 0).
    Intros_p Hfalse.
    contradiction.
  - dump_pre_spatial. exact Hout.
Qed.
