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

Lemma list_cut__list_prepare :
  forall f sg ss node,
  semaphore_context sg -> node <> 0 ->
  store_dll (store_semaphore f) &("k_sem_list") (map semaphore_link_node ss) ** NodeZero node |--
  dllseg_shift_rev (store_semaphore f) (semaphore_first_link sg ss) &("k_sem_list") (map semaphore_link_node ss) **
  DllInsertAfterCut &("k_sem_list") (semaphore_first_link sg ss) node 0 0.
Proof.
  intros f sg ss node Hctx Hnode.
  unfold store_dll.
  Intros h pt.
  sep_apply_l_atomic (dllseg_to_dllseg_shift_rev (store_semaphore f) h &("k_sem_list") &("k_sem_list") pt (map semaphore_link_node ss)).
  destruct ss as [|s ss].
  - unfold semaphore_first_link, dllseg_shift_rev. simpl.
    Intros.
    unfold semaphore_context in Hctx.
    assert (Hhead : semaphore_list_head sg = &("k_sem_list")) by tauto.
    rewrite Hhead. subst h.
    unfold DllInsertAfterCut, NodeZero.
    split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
  - unfold semaphore_first_link. simpl map.
    unfold dllseg_shift_rev. simpl.
    Intros z. subst h.
    Exists z.
    unfold DllInsertAfterCut, NodeZero.
    split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
Qed.

Lemma node_zero_storage__list_prepare : forall p, p <> 0 -> NodeZero p |-- NodeStorage p.
Proof.
  intros p Hp. unfold NodeZero, NodeStorage.
  split_pure_spatial.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
    repeat progress cancel.
  - dump_pre_spatial. exact Hp.
Qed.
