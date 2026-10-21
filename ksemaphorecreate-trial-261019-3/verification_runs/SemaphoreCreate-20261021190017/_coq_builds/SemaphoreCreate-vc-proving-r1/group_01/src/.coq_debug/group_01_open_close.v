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
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct (in_dec Z.eq_dec retval (map semaphore_addr (os_semaphores locked))) as [Hin|Hout].
  - apply in_map_iff in Hin as [s [Heq Hin]].
    apply in_split in Hin as [l [r Hlist]].
    unfold os_inv, semaphore_inv, SemaphoreZero.
    Intros_p Hwf. Intros_p Hctx. Intros_p Hzero.
    rewrite Hlist, map_app. simpl map.
    unfold store_dll at 1.
    Intros h pt.
    sep_apply_l_atomic (dllseg_split (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks locked)))) h (semaphore_list_head (os_semaphore_stable sg)) (semaphore_list_head (os_semaphore_stable sg)) pt (map semaphore_link_node l) (semaphore_link_node s :: map semaphore_link_node r)).
    Intros y py.
    cbn [dllseg].
    Intros z.
    unfold store_semaphore.
    Intros_p Hsem.
    cbn [semaphore_link_node getData getPtr].
    rewrite Heq.
    unfold store_ushort.
    Intros.
    prop_apply_p (dup_store_2bytes (&(retval # "Semaphore" ->ₛ "value")) (semaphore_value s) 0).
    Intros_p Hfalse.
    contradiction.
  - dump_pre_spatial. exact Hout.
Show.
Abort.
