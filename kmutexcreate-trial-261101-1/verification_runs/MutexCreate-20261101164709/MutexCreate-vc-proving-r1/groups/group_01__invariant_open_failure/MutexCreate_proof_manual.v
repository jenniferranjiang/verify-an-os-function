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
From CRTOS_Verify.VC Require Import MutexCreate_goal.
From CRTOS_Verify.VC Require Import MutexCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.KMutexCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.MutexCreate_lib.
Local Open Scope sac.


Lemma proof_of__MutexCreate_safety_wit_1 : _MutexCreate_safety_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_2 : _MutexCreate_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_3 : _MutexCreate_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_4 : _MutexCreate_safety_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_5 : _MutexCreate_safety_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_6 : _MutexCreate_safety_wit_6.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_7 : _MutexCreate_safety_wit_7.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_8 : _MutexCreate_safety_wit_8.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_9 : _MutexCreate_safety_wit_9.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_10 : _MutexCreate_safety_wit_10.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_11 : _MutexCreate_safety_wit_11.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_12 : _MutexCreate_safety_wit_12.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_13 : _MutexCreate_safety_wit_13.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_14 : _MutexCreate_safety_wit_14.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_15 : _MutexCreate_safety_wit_15.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_16 : _MutexCreate_safety_wit_16.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_17 : _MutexCreate_safety_wit_17.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_18 : _MutexCreate_safety_wit_18.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_19 : _MutexCreate_safety_wit_19.
Proof. Admitted. 

Lemma proof_of__MutexCreate_safety_wit_20 : _MutexCreate_safety_wit_20.
Proof. Admitted. 

Lemma proof_of__MutexCreate_return_wit_1 : _MutexCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_return_wit_2 : _MutexCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_1_pure : _MutexCreate_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_1 : _MutexCreate_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_2_pure : _MutexCreate_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_2 : _MutexCreate_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_3_pure : _MutexCreate_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_3 : _MutexCreate_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_4 : _MutexCreate_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_5 : _MutexCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexCreate_partial_solve_wit_6 : _MutexCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexCreate_partial_solve_wit_7_pure : _MutexCreate_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexCreate_partial_solve_wit_7 : _MutexCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  clear H.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexCreate_partial_solve_wit_8_pure : _MutexCreate_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_8 : _MutexCreate_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_9 : _MutexCreate_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_10 : _MutexCreate_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_11 : _MutexCreate_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_12_pure : _MutexCreate_partial_solve_wit_12_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_12 : _MutexCreate_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_13 : _MutexCreate_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_14_pure : _MutexCreate_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_14 : _MutexCreate_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_15_pure : _MutexCreate_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_15 : _MutexCreate_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__MutexCreate_entail_wit_1_1 : _MutexCreate_entail_wit_1_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_entail_wit_1_2 : _MutexCreate_entail_wit_1_2.
Proof. Admitted. 

Lemma proof_of__MutexCreate_return_wit_3_split_goal_1 : _MutexCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_return_wit_3 : _MutexCreate_return_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1 : _MutexCreate_partial_solve_wit_13_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_partial_solve_wit_13_pure : _MutexCreate_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_1 : _MutexCreate_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_2 : _MutexCreate_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial : _MutexCreate_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_1 : _MutexCreate_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_1 : _MutexCreate_which_implies_wit_2_split_goal_1.
Proof. LLM_pre_process ltac:(lia || int_auto).
destruct (in_dec Z.eq_dec mutex (map mutex_addr (os_mutexes st_lock))) as [Hin|Hfresh].
2: { dump_pre_spatial. exact Hfresh. }
apply in_map_iff in Hin. destruct Hin as [m [Heq Hin]].
apply in_split in Hin. destruct Hin as [l1 [l2 Hlist]].
unfold os_inv, mutex_inv. rewrite Hlist, map_app. unfold store_dll at 1.
Intros h pt.
sep_apply_l_atomic (dllseg_split (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) h (mutex_list_head (os_mutex_stable sg_outside_critical)) (mutex_list_head (os_mutex_stable sg_outside_critical)) pt (map mutex_link_node l1) (map mutex_link_node (m::l2))).
Intros y py.
cbn [map dllseg mutex_link_node]. Intros z.
change (mutex_link_node m).(data) with m.
prop_apply_p (mutex_payload_conflict__invariant_open_failure (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) y m mutex Heq).
Intros_p Hfalse. contradiction.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_2 : _MutexCreate_which_implies_wit_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, mutex_inv.
  Intros_p H.
  Intros_p Hctx.
  dump_pre_spatial.
  exact Hctx.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_3 : _MutexCreate_which_implies_wit_2_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold MutexZero.
  Intros_p H.
  dump_pre_spatial.
  tauto.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_4 : _MutexCreate_which_implies_wit_2_split_goal_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold MutexZero.
  Intros_p H.
  dump_pre_spatial.
  tauto.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial : _MutexCreate_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, mutex_inv, mutex_create_frame, MutexZero.
  Intros_p Hwf.
  Intros_p Hctx.
  Intros_p Hp.
  unfold mutex_context in Hctx.
  unfold mutex_context in Hp.
  destruct Hp as [Hm [_ [_ [_ [_ Hl]]]]].
  rewrite Hm, Hl.
  sep_apply_l_atomic (zero_idnode_insert_ready (&(mutex # "Mutex" ->ₛ "id"))).
  split_pure_spatial.
  - cancel.
  - dump_pre_spatial.
  exact Hwf.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_2 : _MutexCreate_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_2_split_goal_1.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_2_split_goal_2.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_2_split_goal_3.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_2_split_goal_4.
Qed. 

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_1 : _MutexCreate_which_implies_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_2 : _MutexCreate_which_implies_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold abs_mutex_create in PreH5 at 1.
  prog_nf in PreH5.
  apply safeExec_choice_r in PreH5.
  unfold task_atomic_cmd in PreH5 at 1.
  prog_nf in PreH5.
  unfold safeExec, safe, weakestpre in PreH5.
  cbn in PreH5.
  destruct PreH5 as [states [Hstates [Hnrm Herr]]].
  exists (Crtos_RTrans st_lock).
  split.
  - unfold LastSeen.
  reflexivity.
  - unfold safe, weakestpre.
  cbn.
  split; [tauto|].
  intros r final [Hr Hfinal].
  subst r final.
  apply Herr.
  exists st_lock, st_lock.
  split.
  + apply (proj2 (Hstates st_lock)).
  exact PreH6.
  + split; [left; auto|reflexivity].
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial : _MutexCreate_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_create_frame.
  Intros_p Hwf.
  pose proof (proj1 (os_wf_context _ _ Hwf)) as Hctx.
  pose proof Hctx as Hroots.
  unfold mutex_context in Hroots.
  destruct Hroots as [Hm [_ [_ [_ [_ Hl]]]]].
  unfold os_inv, mutex_inv, MutexRaw.
  rewrite Hm, Hl.
  split_pure_spatial.
  - unfold NodeZero, NodeStorage, MutexPadding.
  split_pure_spatial.
  + cancel (task_inv sg_outside_critical st_lock).
  repeat match goal with |- ?P ** _ |-- ?P ** _ => cancel P end.
  sep_apply_l_atomic (store_ushort_undef_store_ushort (&(mutex # "Mutex" ->ₛ "val")) 0).
  sep_apply_l_atomic (store_uchar_undef_store_uchar (&(mutex # "Mutex" ->ₛ "recursive_cnt")) 0).
  sep_apply_l_atomic (store_uchar_undef_store_uchar (&(mutex # "Mutex" ->ₛ "origin_prio")) 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(mutex # "Mutex" ->ₛ "holder")) 0).
  let p := constr:(&(mutex # "Mutex" ->ₛ "pend_list")) in sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  let p := constr:(&(mutex # "Mutex" ->ₛ "pend_list")) in sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  let p := constr:(&(mutex # "Mutex" ->ₛ "link")) in sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  let p := constr:(&(mutex # "Mutex" ->ₛ "link")) in sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  sep_apply_l_atomic (CharArray.full_to_undef_full (mutex+2) 2 (repeat_Z 0 2)).
  cancel.
  + split_pures; dump_pre_spatial; auto.
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__MutexCreate_which_implies_wit_3 : _MutexCreate_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial.
  - Goal_apply proof_of__MutexCreate_which_implies_wit_3_split_goal_2.
Qed. 

Lemma proof_of__MutexCreate_which_implies_wit_4 : _MutexCreate_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial : _MutexCreate_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_5 : _MutexCreate_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_1 : _MutexCreate_which_implies_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_2 : _MutexCreate_which_implies_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_3 : _MutexCreate_which_implies_wit_6_split_goal_3.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_4 : _MutexCreate_which_implies_wit_6_split_goal_4.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial : _MutexCreate_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexCreate_which_implies_wit_6 : _MutexCreate_which_implies_wit_6.
Proof. Admitted. 

