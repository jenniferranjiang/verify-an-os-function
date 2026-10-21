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
From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import _SemaphoreCreate_proof_auto.
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

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1 : _SemaphoreCreate_entail_wit_2_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_2_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  unfold store_sem_registered_private, store_sem_link_detached.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq,
    !SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq,
    !OSHeap_ushort_eq, !Hptr.
  Intros.
  set (pending := &(sem # "Semaphore" ->ₛ "pend_list")).
  set (newlink := &(sem # "Semaphore" ->ₛ "link")).
  replace &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") with
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  replace &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") with
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((pending) # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  replace &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") with
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold pending, newlink; apply eval_addr_expr_congr; etransitivity;
       [apply RE_addr_of_congr; apply LE_arrow_field_congr;
        [apply eval_addr | reflexivity]
       |symmetry; apply addr_of_arrow_field]).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    &((newlink) # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; unfold semaphore_object_addresses in *; tauto.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  unfold SemaphoreInsideCritical.
  Intros_p Hcritical.
  assert (Hregistry : semaphore_registry_addr (os_sem_stable sg) = &("k_sem_list")).
  { destruct Hcritical as [Hstable _]. unfold SemaphoreStableContext in Hstable. tauto. }
  unfold store_sem_registry, DLL.store_dll.
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros successor.
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros tail.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr, Hregistry.
  Intros_p Hnodes.
  set (nodes := map (fun obj => let p := semaphore_addr obj in
    Build_DL_Node obj (&(p # "Semaphore" ->ₛ "link"))) (os_semaphores current)).
  pose proof (SemaphoreCriticalViews.OSHeap_entails _ _
    (DLL.dllseg_to_dllseg_shift_rev (Basics.const store_semaphore_body)
      successor &("k_sem_list") &("k_sem_list") tail nodes)) as Hmove.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq, !Hptr in Hmove.
  change (fun (_ : addr) (obj : SemaphoreObject) => store_semaphore_body obj)
    with (Basics.const (B := addr) store_semaphore_body).
  sep_apply_l_atomic Hmove.
  Exists successor nodes.
  split_pure_spatial.
  - set (head := &("k_sem_list")).
    replace &((&("k_sem_list"))->ₛ "node_next") with
      &(head # "SysDoubleLinklistNode" ->ₛ "node_next") by
      (unfold head; apply eval_addr_expr_congr; apply RE_addr_of_congr;
       apply LE_arrow_field_congr; [apply eval_addr | reflexivity]).
    cancel (CrtosInsideProtocol (lock :: hs) current).
    cancel (OSHeap (CrtosBorrowedRep.store_task_semaphore_views (os_tasks current))).
    cancel (OSHeap (CrtosBorrowedRep.store_scheduler_view
      (os_scheduler (semaphore_nest_increment current)))).
    cancel (OSHeap (store_idmanager (semaphore_manager_abs (os_sem_stable sg))
      (idmanager_link (semaphore_manager_abs (os_sem_stable sg))
        (idmanager_add (semaphore_manager_state (os_sem_stable sg)
          (os_semaphores current)) id) id &(sem # "Semaphore" ->ₛ "id"))
      &("k_sem_id_manager"))).
    cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> successor).
    cancel (&(successor # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head).
    cancel (OSHeap (DLL.dllseg_shift_rev (Basics.const store_semaphore_body)
      successor head nodes)).
    cancel (&(sem # "Semaphore" ->ₛ "value") # UShort |-> val_pre).
    cancel (&(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")
      # Ptr |-> &(sem # "Semaphore" ->ₛ "pend_list")).
    cancel (&(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")
      # Ptr |-> &(sem # "Semaphore" ->ₛ "pend_list")).
    cancel (&(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |->_).
    cancel (&(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |->_).
    cancel.
  - split_pures; dump_pre_spatial; try tauto.
    + unfold nodes. rewrite map_map.
      change (map (fun obj : SemaphoreObject => obj) (os_semaphores current) =
        os_semaphores current). apply map_id.
    + intros node Hin. unfold nodes in Hin. apply in_map_iff in Hin.
      destruct Hin as [obj [<- Hin]]. reflexivity.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_1 : _SemaphoreCreate_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_2 : _SemaphoreCreate_entail_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial : _SemaphoreCreate_entail_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
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


Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3_pure : _SemaphoreCreate_partial_solve_wit_3_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7_pure : _SemaphoreCreate_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_7_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_8_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof. Admitted.
