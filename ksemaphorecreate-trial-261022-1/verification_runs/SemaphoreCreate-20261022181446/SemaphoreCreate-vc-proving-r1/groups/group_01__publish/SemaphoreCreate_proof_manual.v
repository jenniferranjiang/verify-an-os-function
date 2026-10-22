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
Proof.
  LLM_pre_process ltac:(lia || int_auto);
  dump_pre_spatial; exact I.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial : _SemaphoreCreate_entail_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (published_world_wf__publish sg st_lock sem id val_pre PreH14) as Hworld.
  pose proof PreH15 as Hcontext.
  destruct Hcontext as [Hmanager [Hmax [Hoffset [Hmap [Htable Hhead]]]]].
  unfold dll_insert_after_dispatch.
  destruct (Z.eq_dec &("k_sem_list") &("k_sem_list")); [|contradiction].
  sep_apply_l_atomic (task_inv_replace__publish sg st_lock
    (semaphore_publish sem id val_pre (os_semaphores st_lock))).
  unfold os_inv, semaphore_inv.
  cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
  rewrite (published_manager__publish
    (semaphore_manager_stable (os_semaphore_stable sg))
    (os_semaphores st_lock) sem id val_pre Hoffset).
  rewrite Hmanager, Hhead.
  cbn [semaphore_publish semaphore_link_node semaphore_created semaphore_addr map].
  split_pure_spatial.
  - change (tick_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (tick_inv sg st_lock).
    change (delay_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (delay_inv sg st_lock).
    change (assign_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (assign_inv sg st_lock).
    change (exstatus_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (exstatus_inv sg st_lock).
    change (semaphore_link_node (semaphore_created sem id val_pre)) with
      (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link"))).
    cancel (task_inv sg (replace_semaphores
      (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)).
    cancel (store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))))
      (&("k_sem_list"))
      (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link"))
       :: map semaphore_link_node (os_semaphores st_lock))).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_7 : _SemaphoreCreate_entail_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial.
Qed. 

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

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  cbv beta delta [_SemaphoreCreate_partial_solve_wit_9_aux].
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.
