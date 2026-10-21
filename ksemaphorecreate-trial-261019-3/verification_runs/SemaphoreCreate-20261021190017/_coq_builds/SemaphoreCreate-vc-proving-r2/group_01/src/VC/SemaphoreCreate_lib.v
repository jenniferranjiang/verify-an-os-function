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

Lemma manager_publish__publish : forall sidm st p id value,
  hoffset sidm = 16 ->
  semaphore_manager (semaphore_publish p id value st) =
  idmanager_link sidm (idmanager_add (semaphore_manager st) id) id
    (&(p # "Semaphore" ->ₛ "id")).
Proof.
  intros sidm st p id value Hoff.
  unfold semaphore_manager, semaphore_publish, semaphore_created,
    idmanager_link, idmanager_add, idmanager_insert_bucket, idlist_add.
  cbn [idlist idbuckets]. rewrite Hoff.
  assert (Hr : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  assert (Hcases : id mod 16 = 0 \/ id mod 16 = 1 \/ id mod 16 = 2 \/ id mod 16 = 3 \/ id mod 16 = 4 \/ id mod 16 = 5 \/ id mod 16 = 6 \/ id mod 16 = 7 \/ id mod 16 = 8 \/ id mod 16 = 9 \/ id mod 16 = 10 \/ id mod 16 = 11 \/ id mod 16 = 12 \/ id mod 16 = 13 \/ id mod 16 = 14 \/ id mod 16 = 15) by lia.
  destruct Hcases as [H0|[H1|[H2|[H3|[H4|[H5|[H6|[H7|[H8|[H9|[H10|[H11|[H12|[H13|[H14|H15]]]]]]]]]]]]]]].
  all: cbn [map seq filter semaphore_id semaphore_addr semaphore_idnode].
  all: match goal with H : Z.modulo ?i 16 = ?n |- _ => rewrite H end.
  all: reflexivity.
Qed.

Lemma world_publish__publish : forall sg st p id value,
  os_world_wf sg st ->
  os_world_wf sg (replace_semaphores (semaphore_publish p id value (os_semaphores st)) st).
Proof.
  intros sg st p id value Hwf.
  destruct Hwf as [Hctx Hr Hi Hcover].
  constructor; cbn [replace_semaphores]; auto.
Qed.

Lemma dllseg_last_nonzero__publish : forall {A} (storeA : addr -> A -> Assertion) l x px y py,
  dll_nodes_nonzero l -> px <> 0 ->
  dllseg storeA x px y py l |-- “ py <> 0 ”.
Proof.
  intros A storeA l; induction l as [|a l IH]; intros x px y py Hnodes Hpx.
  - cbn [dllseg]. Intros_p Heq. dump_pre_spatial. destruct Heq; congruence.
  - inversion Hnodes as [|? ? Ha Hl]; subst.
    cbn [dllseg]. Intros z.
    sep_apply_l_atomic (IH z x y py Hl ltac:(congruence)).
    Intros_p Hpy. dump_pre_spatial. exact Hpy.
Qed.

Lemma pending_empty__publish : forall (wait : addr -> addr -> Assertion) p,
  p <> 0 -> store_node_self_linked p |-- store_dll wait p nil.
Proof.
  intros wait p Hp. unfold store_node_self_linked, store_dll.
  Exists p p. cbn [dllseg].
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; repeat split; auto; constructor].
Qed.

Lemma splice__publish : forall {A} (storeA : addr -> A -> Assertion) head first node a l,
  head <> 0 -> node <> 0 -> dll_nodes_nonzero l ->
  DllInsertedCut head first node ** storeA node a ** dllseg_shift_rev storeA first head l
  |-- store_dll storeA head (Build_DL_Node a node :: l).
Proof.
  intros A storeA head first node a l Hhead Hnode Hnodes.
  unfold DllInsertedCut.
  sep_apply_l_atomic (dllseg_shift_rev_to_dllseg storeA first node head l).
  Intros pt.
  prop_apply_p (dllseg_last_nonzero__publish storeA l first node head pt Hnodes Hnode).
  Intros_p Hpt.
  sep_apply_l_atomic (dllseg_head_insert A storeA head node first head pt a l).
  unfold store_dll. Exists node pt.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; repeat split; auto; constructor; auto.

Qed.

Lemma task_frame__publish : forall sg st sems,
  task_inv sg st |-- task_inv sg (replace_semaphores sems st).
Proof.
  intros sg st sems. unfold task_inv. Intros_p Hwf.
  split_pure_spatial.
  - cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores]. cancel.
  - dump_pre_spatial. destruct Hwf. constructor; cbn [replace_semaphores task_id_nodes]; auto.
Qed.

Lemma publish_resources__publish : forall (val_pre: Z) (sg: StableGlobalState) (locked: VarGlobalState) (sem id: Z),
  0 <= val_pre -> val_pre <= 65535 -> sem <> 0 -> addr_aligned sem 4 ->
  (&(sem # "Semaphore" ->ₛ "pend_list")) <> 0 ->
  (&(sem # "Semaphore" ->ₛ "link")) <> 0 ->
  os_world_wf sg locked -> semaphore_context (os_semaphore_stable sg) ->
  dll_nodes_nonzero (map semaphore_link_node (os_semaphores locked)) ->

  (DllInsertedCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ).
Proof.
  intros val_pre sg locked sem id Hv0 Hv1 Hsem Halign Hpend Hlink Hwf Hctx Hnodes.
  pose proof Hctx as Hctx'.
  destruct Hctx' as [Hmanager [_ [Hoffset [_ [_ Hhead]]]]].
  sep_apply_l_atomic (task_frame__publish sg locked (semaphore_publish sem id val_pre (os_semaphores locked))).
  unfold os_inv.
  split_pure_spatial.
  - change (tick_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)) with (tick_inv sg locked).
    change (delay_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)) with (delay_inv sg locked).
    change (assign_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)) with (assign_inv sg locked).
    change (exstatus_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)) with (exstatus_inv sg locked).
    cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
    cancel (task_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)).
    cancel (tick_inv sg locked).
    cancel (delay_inv sg locked).
    cancel (assign_inv sg locked).
    cancel (store_prio_lookup_table).
    cancel (store_zombie_queue (task_desc_map (os_tasks locked)) (os_zombie_head sg) (zombie_queue locked)).
    cancel ((os_recycler_slot sg) # Int |-> (role_id (os_recycle locked))).
    cancel (IntArray.full (os_idle_array sg) CORE_COUNT (map role_id (os_idle locked))).
    cancel (mutex_inv (pure_suspend_sched_link (task_desc_map (os_tasks locked))) (os_mutex_stable sg) (os_mutexes locked)).
    cancel (msgqueue_inv (pure_suspend_sched_link (task_desc_map (os_tasks locked))) (os_msgqueue_stable sg) (os_msgqueues locked)).
    cancel (event_inv (pure_suspend_sched_link (task_desc_map (os_tasks locked))) (os_event_stable sg) (os_events locked)).
    cancel (isrmanager_inv (os_isr_stable sg) (os_isr locked)).
    cancel (exstatus_inv sg locked).
    unfold semaphore_inv.
    split_pure_spatial.
    + rewrite (manager_publish__publish (semaphore_manager_stable (os_semaphore_stable sg)) (os_semaphores locked) sem id val_pre Hoffset).
      rewrite Hmanager, Hhead.
      cancel.
      change (map semaphore_link_node (semaphore_publish sem id val_pre (os_semaphores locked))) with
        (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link")) ::
         map semaphore_link_node (os_semaphores locked)).
      sep_apply_r_atomic (splice__publish (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks locked))))
        (&("k_sem_list")) (semaphore_first_link (os_semaphore_stable sg) (os_semaphores locked))
        (&(sem # "Semaphore" ->ₛ "link")) (semaphore_created sem id val_pre)
        (map semaphore_link_node (os_semaphores locked))
        (addr_of_LE_var_not_zero "k_sem_list") Hlink Hnodes).
      cancel (DllInsertedCut (&("k_sem_list")) (semaphore_first_link (os_semaphore_stable sg) (os_semaphores locked)) (&(sem # "Semaphore" ->ₛ "link"))).
      cancel (dllseg_shift_rev (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks locked))))
        (semaphore_first_link (os_semaphore_stable sg) (os_semaphores locked)) (&("k_sem_list")) (map semaphore_link_node (os_semaphores locked))).
      unfold store_semaphore. cbn [semaphore_created semaphore_addr semaphore_value semaphore_pending_addrs map].
      split_pure_spatial.
      * cancel ((&(sem # "Semaphore" ->ₛ "value")) # UShort |-> val_pre).
        cancel (SemaphorePadding sem).
        sep_apply_l_atomic (pending_empty__publish
          (pure_suspend_sched_link (task_desc_map (os_tasks locked)))
          (&(sem # "Semaphore" ->ₛ "pend_list")) Hpend).
        cancel.
      * split_pures; dump_pre_spatial; repeat split; auto.
    + dump_pre_spatial. exact Hctx.
  - dump_pre_spatial. apply world_publish__publish. exact Hwf.
Qed.
