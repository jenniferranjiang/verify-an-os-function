Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Lia.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Program.Equality.
From AUXLib Require Import ListLib.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem CNotation IntLib SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSRep.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.

Import ListNotations Monad MonadNotation.
Import CrtosOS_C_Rules.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.
Local Open Scope monad.

(** QCP 注解不接受内联 lambda；空 payload 的语义仍严格是 [emp]。 *)
Definition semaphore_unit_empty (_ : Z) (_ : unit) : Assertion := emp.

(** 有限首空闲-ID 扫描返回 [Some id] 时，[id] 必定位于本次扫描区间内。
    该反演事实供 [IdInsertObj] 从 [AllocId] 的成功结果恢复 API 范围。 *)
Lemma semaphore_first_free_from_some_bound_local :
  forall state fuel start id,
    semaphore_first_free_from state fuel start = Some id ->
    start <= id < start + Z.of_nat fuel.
Proof.
  intros state fuel. induction fuel as [| fuel IH];
    intros start id Hresult.
  - simpl in Hresult. discriminate.
  - simpl in Hresult.
    destruct (semaphore_id_used state start) eqn:Hused.
    + specialize (IH (start + 1) id Hresult).
      rewrite Nat2Z.inj_succ. unfold Z.succ. lia.
    + inversion Hresult. subst id.
      rewrite Nat2Z.inj_succ. unfold Z.succ.
      pose proof (Nat2Z.is_nonneg fuel). lia.
Qed.

Lemma semaphore_first_free_some_bound_local :
  forall stable state id,
    SemaphoreStableContext stable ->
    semaphore_first_free stable state = Some id ->
    0 <= id < stable.(semaphore_id_limit).
Proof.
  intros stable state id Hstable Hresult.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold semaphore_first_free in Hresult.
  pose proof (semaphore_first_free_from_some_bound_local
    state (Z.to_nat stable.(semaphore_id_limit)) 0 id Hresult) as Hbound.
  rewrite Z2Nat.id in Hbound.
  - exact Hbound.
  - rewrite Hil. unfold SEM_ID_MAX. lia.
Qed.

Lemma semaphore_first_free_from_some_unused_local :
  forall state fuel start id,
    semaphore_first_free_from state fuel start = Some id ->
    semaphore_id_used state id = false.
Proof.
  intros state fuel. induction fuel as [| fuel IH];
    intros start id Hresult.
  - simpl in Hresult. discriminate.
  - simpl in Hresult.
    destruct (semaphore_id_used state start) eqn:Hused.
    + exact (IH (start + 1) id Hresult).
    + inversion Hresult. subst id. exact Hused.
Qed.

Lemma semaphore_first_free_some_unused_local :
  forall stable state id,
    semaphore_first_free stable state = Some id ->
    ~ In id (semaphore_ids state.(semaphore_objects)).
Proof.
  intros stable state id Hresult Hin.
  unfold semaphore_first_free in Hresult.
  pose proof (semaphore_first_free_from_some_unused_local
    state (Z.to_nat stable.(semaphore_id_limit)) 0 id Hresult) as Hunused.
  unfold semaphore_id_used in Hunused.
  destruct (in_dec Z.eq_dec id
    (semaphore_ids state.(semaphore_objects))) as [Hmember | Hnot].
  - discriminate.
  - contradiction.
Qed.

Lemma semaphore_find_addr_none_not_in_local :
  forall p objects,
    semaphore_find_addr p objects = None ->
    ~ In p (semaphore_addresses objects).
Proof.
  intros p objects. induction objects as [| object rest IH]; intros Hfind.
  - simpl. tauto.
  - simpl in Hfind |- *.
    destruct (Z.eq_dec (semaphore_addr object) p) as [Heq | Hneq].
    + discriminate.
    + intros [Hhead | Htail].
      * apply Hneq. exact Hhead.
      * exact (IH Hfind Htail).
Qed.

Lemma semaphore_not_in_addresses_find_none_local :
  forall p objects,
    ~ In p (semaphore_addresses objects) ->
    semaphore_find_addr p objects = None.
Proof.
  intros p objects. induction objects as [| object rest IH]; intros Hnot.
  - reflexivity.
  - simpl in Hnot |- *.
    destruct (Z.eq_dec (semaphore_addr object) p) as [Heq | Hneq].
    + exfalso. apply Hnot. left. exact Heq.
    + apply IH. intro Hin. apply Hnot. right. exact Hin.
Qed.

(** create 在地址和 ID 均新鲜、value 位于 uint16 范围时保持 semaphore
    抽象状态合法性；新对象的 pending list 为空，因此 pending NoDup 不变。 *)
Lemma semaphore_state_wf_create_local :
  forall stable before sem id value,
    semaphore_state_wf stable before ->
    semaphore_find_addr sem before.(semaphore_objects) = None ->
    semaphore_first_free stable before = Some id ->
    sem <> 0 ->
    0 <= value <= 65535 ->
    semaphore_state_wf stable
      (semaphore_create_state before sem id value).
Proof.
  intros stable before sem id value Hwf Hfresh Hfirst Hsem Hvalue.
  pose proof Hfirst as Hfirst_bound.
  unfold semaphore_first_free in Hfirst_bound.
  pose proof (semaphore_first_free_from_some_bound_local
    before (Z.to_nat stable.(semaphore_id_limit)) 0 id Hfirst_bound)
    as Hbound.
  pose proof (semaphore_first_free_some_unused_local
    stable before id Hfirst) as Hidfresh.
  pose proof (semaphore_find_addr_none_not_in_local
    sem before.(semaphore_objects) Hfresh) as Haddrfresh.
  unfold semaphore_state_wf in Hwf |- *.
  destruct Hwf as (Hil & Hbc & Hobjects & Haddrs & Hids & Hpending).
  rewrite Z2Nat.id in Hbound by
    (rewrite Hil; unfold SEM_ID_MAX; lia).
  unfold semaphore_create_state, semaphore_addresses, semaphore_ids,
    semaphore_all_pending in *. simpl in *.
  repeat split; try assumption.
  - constructor.
    + unfold semaphore_object_wf. simpl.
      split; [exact Hsem |].
      split; [exact Hbound |].
      split; [exact Hvalue |].
      split; constructor.
    + exact Hobjects.
  - constructor; assumption.
  - constructor; assumption.
Qed.

(** 两个完整 semaphore body 若基址相同，就会重复拥有同一个 [value]
    单元；分离性因此给出对象地址与新分配块地址不同。 *)
Lemma semaphore_value_cells_distinct_local :
  forall p q v1 v2,
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v1 **
    &(q # "Semaphore" ->ₛ "value") # UShort |-> v2 |--
    “ p <> q ”.
Proof.
  intros p q v1 v2.
  destruct (Z.eq_dec p q) as [Heq | Hneq].
  - subst q.
    unfold store_ushort. Intros.
    prop_apply (dup_store_2bytes
      (&(p # "Semaphore" ->ₛ "value")) v1 v2).
    Intros_p Hfalse. contradiction.
  - dump_pre_spatial. exact Hneq.
Qed.

Lemma semaphore_value_cells_distinct_keep_local :
  forall p q v1 v2,
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v1 **
    &(q # "Semaphore" ->ₛ "value") # UShort |-> v2 |--
    “ p <> q ” &&
    (&(p # "Semaphore" ->ₛ "value") # UShort |-> v1 **
     &(q # "Semaphore" ->ₛ "value") # UShort |-> v2).
Proof.
  intros p q v1 v2.
  pose proof (prop_add_left
    (&(p # "Semaphore" ->ₛ "value") # UShort |-> v1 **
     &(q # "Semaphore" ->ₛ "value") # UShort |-> v2)
    (p <> q) (semaphore_value_cells_distinct_local p q v1 v2)) as Hequiv.
  apply (proj1 Hequiv).
Qed.

(** 在批准的 32 位布局下，[value] 字段单元的有效性推出同一对象内
    [pend_list] 头地址非空。 *)
Lemma semaphore_value_cell_pend_head_nonzero_local :
  forall sem value,
    semaphore_layout_32_ok sem ->
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ &(sem # "Semaphore" ->ₛ "pend_list") <> 0 ”.
Proof.
  intros sem value Hlayout.
  unfold store_ushort. Intros. dump_pre_spatial.
  unfold semaphore_layout_32_ok in Hlayout.
  destruct Hlayout as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  destruct H as (Hvalid & Hnonneg & Hupper).
  unfold isvalidptr_short in Hvalid.
  rewrite Hvalue in Hvalid. rewrite Hpend. lia.
Qed.

(** 保留字段 ownership 的版本，供需要显式重排 spatial frame 的证明使用。 *)
Lemma semaphore_value_cell_pend_head_nonzero_keep_local :
  forall sem value,
    semaphore_layout_32_ok sem ->
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ &(sem # "Semaphore" ->ₛ "pend_list") <> 0 ” &&
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value.
Proof.
  intros sem value Hlayout.
  pose proof (prop_add_left
    (&(sem # "Semaphore" ->ₛ "value") # UShort |-> value)
    (&(sem # "Semaphore" ->ₛ "pend_list") <> 0)
    (semaphore_value_cell_pend_head_nonzero_local sem value Hlayout))
    as Hequiv.
  apply (proj1 Hequiv).
Qed.

(** 同一有效 [value] 单元还保证对象内 registry [link] 头非空；这里使用
    reviewed 32 位字段 offset，而不把该地址事实提升为新的模块假设。 *)
Lemma semaphore_value_cell_registry_head_nonzero_local :
  forall sem value,
    semaphore_layout_32_ok sem ->
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ &(sem # "Semaphore" ->ₛ "link") <> 0 ”.
Proof.
  intros sem value Hlayout.
  unfold store_ushort. Intros. dump_pre_spatial.
  unfold semaphore_layout_32_ok in Hlayout.
  destruct Hlayout as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  destruct H as (Hvalid & Hnonneg & Hupper).
  unfold isvalidptr_short in Hvalid.
  rewrite Hvalue in Hvalid. rewrite Hreg. lia.
Qed.

Lemma semaphore_value_cell_registry_head_nonzero_keep_local :
  forall sem value,
    semaphore_layout_32_ok sem ->
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ &(sem # "Semaphore" ->ₛ "link") <> 0 ” &&
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value.
Proof.
  intros sem value Hlayout.
  pose proof (prop_add_left
    (&(sem # "Semaphore" ->ₛ "value") # UShort |-> value)
    (&(sem # "Semaphore" ->ₛ "link") <> 0)
    (semaphore_value_cell_registry_head_nonzero_local sem value Hlayout))
    as Hequiv.
  apply (proj1 Hequiv).
Qed.

Lemma sem_registry_seg_value_not_in_local :
  forall objects sem value first previous stop last,
    sem_dllseg store_semaphore_body first previous stop last
      (map semaphore_registry_node objects) **
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ ~ In sem (semaphore_addresses objects) ”.
Proof.
  induction objects as [| object rest IH];
    intros sem value first previous stop last; simpl.
  - dump_pre_spatial. tauto.
  - Intros next.
    unfold store_semaphore_body at 1. Intros.
    remember (semaphore_addr object) as object_sem eqn:Hobject_sem.
    subst first.
    destruct (Z.eq_dec sem object_sem) as [Heq | Hneq].
    + subst object_sem. rewrite <- Heq. unfold store_ushort. Intros.
      prop_apply (dup_store_2bytes
        (&(sem # "Semaphore" ->ₛ "value")) value
        object.(semaphore_value)).
      Intros_p Hfalse. contradiction.
    + lazymatch goal with
      | |- context [sem_dllseg store_semaphore_body next ?tail_previous
            stop last (map semaphore_registry_node rest)] =>
          sep_apply_l_atomic
            (IH sem value next tail_previous stop last)
      end.
      Intros. dump_pre_spatial.
      intros [Heq | Hin].
      * apply Hneq. symmetry. exact Heq.
      * contradiction.
Qed.

Lemma store_semaphore_registry_value_not_in_local :
  forall stable state sem value,
    store_semaphore_registry stable state **
    &(sem # "Semaphore" ->ₛ "value") # UShort |-> value |--
    “ ~ In sem (semaphore_addresses state.(semaphore_objects)) ”.
Proof.
  intros stable state sem value.
  unfold store_semaphore_registry, store_sem_dll.
  Intros first last.
  prop_apply (sem_registry_seg_value_not_in_local
    state.(semaphore_objects) sem value first
    stable.(semaphore_registry_addr) stable.(semaphore_registry_addr) last).
  Intros. dump_pre_spatial. exact H0.
Qed.

Lemma store_semaphore_registry_zeroed_fresh_local :
  forall stable state sem,
    store_semaphore_registry stable state ** store_sem_zeroed_private sem |--
    “ semaphore_find_addr sem state.(semaphore_objects) = None ” &&
    store_semaphore_registry stable state ** store_sem_zeroed_private sem.
Proof.
  intros stable state sem.
  assert (Hpure :
    store_semaphore_registry stable state ** store_sem_zeroed_private sem |--
    “ semaphore_find_addr sem state.(semaphore_objects) = None ”).
  { unfold store_sem_zeroed_private. Intros.
    prop_apply (store_semaphore_registry_value_not_in_local
      stable state sem 0). Intros.
    dump_pre_spatial.
    apply semaphore_not_in_addresses_find_none_local. assumption. }
  pose proof (prop_add_left
    (store_semaphore_registry stable state ** store_sem_zeroed_private sem)
    (semaphore_find_addr sem state.(semaphore_objects) = None) Hpure)
    as Hequiv.
  apply (proj1 Hequiv).
Qed.

(** 向 semaphore 状态表头加入 pending 为空的新对象不会改变任何 task 的
    scheduler placement；task 与 scheduler 两个投影保持原样。 *)
Lemma crtos_task_placement_create_empty_local :
  forall world sem id value task placement,
    crtos_task_placement world task placement ->
    crtos_task_placement
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)) task placement.
Proof.
  intros world sem id value task placement Hplacement.
  inversion Hplacement; subst; simpl in *.
  - econstructor; eauto.
  - econstructor; eauto.
  - econstructor; eauto.
  - eapply PlaceSemaphorePending with (object := object); eauto.
    simpl. right. assumption.
  - eapply PlaceSuspendDetached; eauto.
  - eapply PlaceExternalWaiting; eauto.
  - eapply PlaceZombie; eauto.
Qed.

Lemma crtos_task_placement_create_empty_back_local :
  forall world sem id value task placement,
    crtos_task_placement
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)) task placement ->
    crtos_task_placement world task placement.
Proof.
  intros world sem id value task placement Hplacement.
  inversion Hplacement; subst; simpl in *.
  - econstructor; eauto.
  - econstructor; eauto.
  - econstructor; eauto.
  - destruct H1 as [Hnew | Hold].
    + subst object. simpl in H2. contradiction.
    + eapply PlaceSemaphorePending with (object := object); eauto.
  - eapply PlaceSuspendDetached; eauto.
  - eapply PlaceExternalWaiting; eauto.
  - eapply PlaceZombie; eauto.
Qed.

Lemma iter_sepcon_single_left_local :
  forall P : Assertion, iter_sepcon [P] |-- P.
Proof. intros P. simpl. apply (proj1 (sepcon_emp_logic_equiv' P)). Qed.

Lemma iter_sepcon_single_right_local :
  forall P : Assertion, P |-- iter_sepcon [P].
Proof. intros P. simpl. apply (proj2 (sepcon_emp_logic_equiv' P)). Qed.

Lemma store_map_pred_mono_local :
  forall {A B : Type} (P Q : A -> B -> Assertion) m,
    (forall a b, m a = Some b -> P a b |-- Q a b) ->
    store_map P m |-- store_map Q m.
Proof.
  intros A B P Q m Hmono.
  unfold store_map. Intros keys. Exists keys.
  assert (Hiter : forall xs,
    iter_sepcon
      (map (fun a => match m a with Some b => P a b | None => emp end) xs)
    |-- iter_sepcon
      (map (fun a => match m a with Some b => Q a b | None => emp end) xs)).
  { intros xs. induction xs as [| key rest IH]; simpl.
    - entailer!.
    - destruct (m key) eqn:Hkey.
      + change
          (iter_sepcon
            ([P key b] ++
              map (fun a => match m a with
                | Some item => P a item | None => emp end) rest) |--
           iter_sepcon
            ([Q key b] ++
              map (fun a => match m a with
                | Some item => Q a item | None => emp end) rest)).
        eapply derivable1_trans.
        * apply derivable1_sepcon_iter_sepcon2.
        * eapply derivable1_trans.
          -- apply derivable1_sepcon_mono.
             ++ eapply derivable1_trans.
                ** apply iter_sepcon_single_left_local.
                ** eapply derivable1_trans.
                   --- apply Hmono. exact Hkey.
                   --- apply iter_sepcon_single_right_local.
             ++ exact IH.
          -- apply derivable1_sepcon_iter_sepcon1.
      + change
          (iter_sepcon
            ([emp] ++
              map (fun a => match m a with
                | Some item => P a item | None => emp end) rest) |--
           iter_sepcon
            ([emp] ++
              map (fun a => match m a with
                | Some item => Q a item | None => emp end) rest)).
        eapply derivable1_trans.
        * apply derivable1_sepcon_iter_sepcon2.
        * eapply derivable1_trans.
          -- apply derivable1_sepcon_mono.
             ++ apply derivable1_refl.
             ++ exact IH.
          -- apply derivable1_sepcon_iter_sepcon1. }
  sep_apply (Hiter keys). entailer!.
Qed.

Lemma store_crtos_task_desc_map_create_empty_local :
  forall world sem id value,
    store_crtos_task_desc_map world |--
    store_crtos_task_desc_map
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)).
Proof.
  intros world sem id value.
  unfold store_crtos_task_desc_map.
  apply store_map_pred_mono_local.
  intros task desc Hlookup.
  unfold store_crtos_published_task. Intros placement.
  Exists placement. entailer!.
  exact (crtos_task_placement_create_empty_local
    world sem id value task placement H).
Qed.

Lemma semaphore_task_bridge_create_empty_local :
  forall stable world sem id value,
    semaphore_task_bridge stable world ->
    semaphore_task_bridge stable
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)).
Proof.
  intros stable world sem id value Hbridge object task Hobject Htask.
  simpl in Hobject.
  destruct Hobject as [Hnew | Hold].
  - subst object. simpl in Htask. contradiction.
  - specialize (Hbridge object task Hold Htask).
    destruct Hbridge as [desc [Hreg [Hstatus [Hdone [Hmeta Hplace]]]]].
    exists desc.
    refine (conj Hreg _).
    refine (conj Hstatus _).
    refine (conj Hdone _).
    refine (conj Hmeta _).
    exact (crtos_task_placement_create_empty_local world sem id value
      task (CSP_SEMAPHORE_PENDING (semaphore_addr object)) Hplace).
Qed.

Lemma crtos_scheduler_wf_create_empty_local :
  forall stable world sem id value,
    crtos_scheduler_wf stable world ->
    crtos_scheduler_wf stable
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)).
Proof.
  intros stable world sem id value Hwf.
  unfold crtos_scheduler_wf in Hwf |- *. simpl in *.
  destruct Hwf as
    (Hqueues & Hgroup & Hhighest & Hcurrent & Hdone & Hmetadata &
     Hordered & Hlocations & Hheads & Hwaits & Hdelayaddrs &
     Hdelaytasks & Hdelaywf & Hdelayregistered & Htaskmetadata &
     Hplacements & Hready & Hrunning & Hexternal & Hzombies & Hdelays).
  refine (conj Hqueues _).
  refine (conj Hgroup _).
  refine (conj Hhighest _).
  refine (conj Hcurrent _).
  refine (conj Hdone _).
  refine (conj Hmetadata _).
  refine (conj Hordered _).
  refine (conj Hlocations _).
  refine (conj Hheads _).
  refine (conj Hwaits _).
  refine (conj Hdelayaddrs _).
  refine (conj Hdelaytasks _).
  refine (conj Hdelaywf _).
  refine (conj Hdelayregistered _).
  refine (conj Htaskmetadata _).
  refine (conj _ _).
  - intros task desc Hregistered.
    specialize (Hplacements task desc Hregistered).
    destruct Hplacements as [placement Hplacement].
    exists placement.
    exact (crtos_task_placement_create_empty_local
      world sem id value task placement Hplacement).
  - refine (conj Hready _).
    refine (conj Hrunning _).
    refine (conj Hexternal _).
    refine (conj Hzombies Hdelays).
Qed.

Lemma crtos_os_world_wf_create_local :
  forall stable world sem id value,
    crtos_os_world_wf stable world ->
    semaphore_find_addr sem
      world.(crtos_semaphore_state).(semaphore_objects) = None ->
    semaphore_first_free stable.(crtos_semaphore_stable)
      world.(crtos_semaphore_state) = Some id ->
    sem <> 0 ->
    0 <= value <= 65535 ->
    crtos_os_world_wf stable
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)).
Proof.
  intros stable world sem id value Hwf Hfresh Hfirst Hsem Hvalue.
  unfold crtos_os_world_wf in Hwf |- *. simpl in *.
  destruct Hwf as (Htask & Hsemaphore & Hbridge & Hscheduler).
  refine (conj Htask _).
  refine (conj _ _).
  - apply semaphore_state_wf_create_local; assumption.
  - refine (conj _ _).
    + apply semaphore_task_bridge_create_empty_local. exact Hbridge.
    + apply crtos_scheduler_wf_create_empty_local. exact Hscheduler.
Qed.

Lemma SemaphoreGuarantee_create_local :
  forall stable world sem id value,
    crtos_os_world_wf stable world ->
    crtos_os_world_wf stable
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)) ->
    semaphore_find_addr sem
      world.(crtos_semaphore_state).(semaphore_objects) = None ->
    semaphore_first_free stable.(crtos_semaphore_stable)
      world.(crtos_semaphore_state) = Some id ->
    SemaphoreGuarantee stable world
      (Build_CrtosOSWorld world.(crtos_task_state)
        world.(crtos_scheduler_state)
        (semaphore_create_state world.(crtos_semaphore_state)
          sem id value)).
Proof.
  intros stable world sem id value Hbefore Hafter Hfresh Hfirst.
  unfold SemaphoreGuarantee, CrtosOSGuarantee, CrtosOSGTrans.
  apply Relation_Operators.rt_step. constructor.
  - intros reservation. tauto.
  - right. eapply SemStepCreate.
    + exact Hfresh.
    + exact Hfirst.
    + reflexivity.
    + unfold crtos_os_world_wf in Hbefore. tauto.
    + unfold crtos_os_world_wf in Hafter. simpl in Hafter. tauto.
  - apply CrtosRuntimeFrame; reflexivity.
  - apply PendingUnchanged. reflexivity.
  - exact Hbefore.
  - exact Hafter.
Qed.

Lemma CrtosOSGTrans_semaphore_projection_local :
  forall stable before after,
    CrtosOSGTrans stable before after ->
    SemaphoreRTrans stable.(crtos_semaphore_stable)
      before.(crtos_semaphore_state) after.(crtos_semaphore_state).
Proof.
  intros stable before after Hsteps.
  induction Hsteps.
  - inversion H; subst.
    match goal with
    | Hsem : crtos_semaphore_single_step _ _ _ |- _ =>
        destruct Hsem as [Hsame | Hstep]
    end.
    + rewrite Hsame. apply Relation_Operators.rt_refl.
    + apply Relation_Operators.rt_step. exact Hstep.
  - apply Relation_Operators.rt_refl.
  - eapply Relation_Operators.rt_trans; eauto.
Qed.

Lemma crtos_os_environment_step_semaphore_projection_local :
  forall held before after,
    crtos_os_environment_step held before after ->
    before.(crtos_os_protocol_stable) = after.(crtos_os_protocol_stable) /\
    SemaphoreRTrans
      before.(crtos_os_protocol_stable).(crtos_semaphore_stable)
      before.(crtos_os_protocol_world).(crtos_semaphore_state)
      after.(crtos_os_protocol_world).(crtos_semaphore_state).
Proof.
  intros held before after Hstep.
  unfold crtos_os_environment_step, crtos_os_protocol_transition in Hstep.
  destruct Hstep as
    (source_core & target_core & frame & Hcore & _ & _ & _ & _ & _ & _).
  destruct Hcore as [Haction _].
  dependent destruction Haction.
  all: cbn in x0, x; subst before; subst after; simpl.
  - split; [reflexivity | apply Relation_Operators.rt_refl].
  - destruct H as [Hstable Hworld]. subst stable_after.
    split; [reflexivity |].
    eapply CrtosOSGTrans_semaphore_projection_local. exact Hworld.
  - split; [reflexivity |]. rewrite H1.
    apply Relation_Operators.rt_refl.
  - split; [reflexivity |]. rewrite H1.
    apply Relation_Operators.rt_refl.
  - split; [reflexivity |]. rewrite H1.
    apply Relation_Operators.rt_refl.
Qed.

Lemma CrtosOSProtocolRReachable_semaphore_projection_local :
  forall held before after,
    CrtosOSProtocolRReachable held before after ->
    before.(crtos_os_protocol_stable) = after.(crtos_os_protocol_stable) /\
    SemaphoreRTrans
      before.(crtos_os_protocol_stable).(crtos_semaphore_stable)
      before.(crtos_os_protocol_world).(crtos_semaphore_state)
      after.(crtos_os_protocol_world).(crtos_semaphore_state).
Proof.
  intros held before after Hreachable.
  induction Hreachable.
  - exact (crtos_os_environment_step_semaphore_projection_local
      held x y H).
  - split; [reflexivity | apply Relation_Operators.rt_refl].
  - destruct IHHreachable1 as [Hstable1 Hsem1].
    destruct IHHreachable2 as [Hstable2 Hsem2].
    split.
    + etransitivity; eauto.
    + rewrite <- Hstable1 in Hsem2.
      eapply Relation_Operators.rt_trans; eauto.
Qed.

Lemma SemaphoreRely_semaphore_projection_local :
  forall stable before current,
    SemaphoreRely stable before current ->
    SemaphoreRTrans stable.(crtos_semaphore_stable)
      before.(crtos_semaphore_state) current.(crtos_semaphore_state).
Proof.
  intros stable before current Hrely.
  unfold SemaphoreRely, CrtosOSRely in Hrely.
  pose proof (CrtosOSProtocolRReachable_semaphore_projection_local
    crtos_os_no_tokens _ _ Hrely) as [_ Hsem].
  simpl in Hsem. exact Hsem.
Qed.

Lemma safeExec_abs_create_success_local :
  forall val X stable before current sem id,
    SemaphoreRely stable before current ->
    crtos_os_world_wf stable current ->
    crtos_os_world_wf stable
      (Build_CrtosOSWorld current.(crtos_task_state)
        current.(crtos_scheduler_state)
        (semaphore_create_state current.(crtos_semaphore_state)
          sem id val)) ->
    semaphore_find_addr sem
      current.(crtos_semaphore_state).(semaphore_objects) = None ->
    semaphore_first_free stable.(crtos_semaphore_stable)
      current.(crtos_semaphore_state) = Some id ->
    sem <> 0 ->
    0 <= val <= 65535 ->
    safeExec
      (SemaphoreLastSeen stable.(crtos_semaphore_stable)
        before.(crtos_semaphore_state))
      (abs_ksemaphore_create stable.(crtos_semaphore_stable) val) X ->
    safeExec
      (SemaphoreLastSeen stable.(crtos_semaphore_stable)
        (semaphore_create_state current.(crtos_semaphore_state)
          sem id val))
      (return id) X.
Proof.
  intros val X stable before current sem id Hrely Hcurrent Hafter
    Hfresh Hfirst Hsem Hval Hsafe.
  unfold safeExec, safe, StateRelHoare.weakestpre in Hsafe |- *.
  unfold SemaphoreLastSeen, abs_ksemaphore_create,
    semaphore_atomic_cmd in Hsafe |- *.
  destruct Hsafe as [states [Hstates Hsafe]].
  exists (SemaphoreRTrans stable.(crtos_semaphore_stable)
    (semaphore_create_state current.(crtos_semaphore_state) sem id val)).
  split; [sets_unfold; reflexivity |].
  intros result states_after Hreturn.
  cbn in Hreturn. destruct Hreturn as [Hresult Hstate].
  subst result. subst states_after.
  apply Hsafe.
  exists current.(crtos_semaphore_state),
    (semaphore_create_state current.(crtos_semaphore_state) sem id val).
  split.
  - apply (proj2 (Hstates current.(crtos_semaphore_state))).
    exact (SemaphoreRely_semaphore_projection_local
      stable before current Hrely).
  - split.
    + right. exists sem, id.
      refine (conj Hsem _).
      refine (conj Hval _).
      refine (conj Hfresh _).
      refine (conj Hfirst _).
      refine (conj eq_refl _).
      refine (conj eq_refl _).
      split.
      * unfold crtos_os_world_wf in Hcurrent. tauto.
      * unfold crtos_os_world_wf in Hafter. simpl in Hafter. tauto.
    + sets_unfold; reflexivity.
Qed.

Lemma safeExec_abs_create_failure_local :
  forall val X stable before current,
    SemaphoreRely stable before current ->
    safeExec
      (SemaphoreLastSeen stable.(crtos_semaphore_stable)
        before.(crtos_semaphore_state))
      (abs_ksemaphore_create stable.(crtos_semaphore_stable) val) X ->
    safeExec
      (SemaphoreLastSeen stable.(crtos_semaphore_stable)
        current.(crtos_semaphore_state))
      (return SEM_NO_MEMORY) X.
Proof.
  intros val X stable before current Hrely Hsafe.
  unfold safeExec, safe, StateRelHoare.weakestpre in Hsafe |- *.
  unfold SemaphoreLastSeen, abs_ksemaphore_create,
    semaphore_atomic_cmd in Hsafe |- *.
  destruct Hsafe as [states [Hstates Hsafe]].
  exists (SemaphoreRTrans stable.(crtos_semaphore_stable)
    current.(crtos_semaphore_state)).
  split; [sets_unfold; reflexivity |].
  intros result states_after Hreturn.
  cbn in Hreturn. destruct Hreturn as [Hresult Hstate].
  subst result. subst states_after.
  apply Hsafe.
  exists current.(crtos_semaphore_state), current.(crtos_semaphore_state).
  split.
  - apply (proj2 (Hstates current.(crtos_semaphore_state))).
    exact (SemaphoreRely_semaphore_projection_local
      stable before current Hrely).
  - split.
    + left. split; reflexivity.
    + sets_unfold; reflexivity.
Qed.

(** [DoubleLinkListInsertNodeAfter] 在写入前只需暴露环形链表的首节点边界；
    空链表时首节点就是哨兵本身。这个纯函数不改变批准的 DLL 表示。 *)
Definition sem_dll_front {A : Type}
    (head : addr) (nodes : list (SemDLNode A)) : addr :=
  match nodes with
  | nil => head
  | node :: _ => node.(sem_node_ptr)
  end.

(** DLL 首节点 focus 后保留的其余 ownership。空链表没有 remainder；
    非空链表保留 head.prev、首节点 payload/next 和后续 segment。 *)
Definition store_sem_dll_insert_rest {A : Type}
    (store_payload : addr -> A -> Assertion)
    (head : addr) (nodes : list (SemDLNode A)) : Assertion :=
  match nodes with
  | nil => emp
  | node :: rest =>
      let node_ptr := node.(sem_node_ptr) in
      EX next last : addr,
        “ head <> 0 /\ node_ptr <> 0 /\ last <> 0 /\
          Forall (fun item => item.(sem_node_ptr) <> 0) (node :: rest) ” &&
        &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
        store_payload node_ptr node.(sem_node_data) **
        &(node_ptr # "SysDoubleLinklistNode" ->ₛ "node_next")
          # Ptr |-> next **
        sem_dllseg store_payload next node_ptr head last rest
  end.

(** [IdInsertObj] 写 ID 时保留的 padding 与 intrusive-link ownership。 *)
Definition store_sem_id_node_zeroed_rest (sem : addr) : Assertion :=
  “ sem <> 0 ” &&
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |-> 0.

(** [InsertObj] 读取 id 时保留的 id padding 与 link ownership。 *)
Definition store_sem_id_node_insert_ready_rest
    (sem id : addr) : Assertion :=
  “ sem <> 0 /\ 0 <= id < SEM_ID_MAX ” &&
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |->_.

(** 完整 DLL 去掉 [head.prev] 后的 remainder；显式参数 [last] 绑定被读出的
    尾指针值，使 [head.prev |-> last] 能与 remainder 无损重组。 *)
Definition store_sem_dll_without_prev {A : Type}
    (store_payload : addr -> A -> Assertion)
    (head : addr) (nodes : list (SemDLNode A)) (last : addr) : Assertion :=
  EX first : addr,
    “ head <> 0 /\ first <> 0 /\ last <> 0 /\
      Forall (fun node => node.(sem_node_ptr) <> 0) nodes ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> first **
    sem_dllseg store_payload first head head last nodes.

Lemma store_sem_dll_without_prev_merge_local :
  forall {A : Type} (store_payload : addr -> A -> Assertion)
      head nodes last,
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
    store_sem_dll_without_prev store_payload head nodes last |--
    store_sem_dll store_payload head nodes.
Proof.
  intros A store_payload head nodes last.
  unfold store_sem_dll_without_prev, store_sem_dll.
  Intros first. Exists first last. entailer!.
Qed.

Lemma store_sem_dll_empty_change_payload_local :
  forall {A B : Type} (storeA : addr -> A -> Assertion)
      (storeB : addr -> B -> Assertion) head,
    store_sem_dll storeA head nil |-- store_sem_dll storeB head nil.
Proof.
  intros A B storeA storeB head.
  unfold store_sem_dll. Intros first last.
  Exists first last. entailer!.
Qed.

(** 选中 bucket 为尚未初始化的 [None] 时，其余 bucket 的精确 frame。 *)
Definition store_sem_buckets_none_rest
    (stable : SemaphoreStable) (state : SemaphoreState) (index : Z)
    : Assertion :=
  EX prefix suffix : list SemBucket,
    “ 0 <= index < stable.(semaphore_bucket_count) /\
      Zlength prefix = index /\
      semaphore_buckets_ok stable state (prefix ++ None :: suffix) ” &&
    store_sem_buckets_from stable 0 prefix **
    store_sem_buckets_from stable (index + 1) suffix.

(** 选中 bucket 已初始化时，其余 bucket 的精确 frame。选中节点序列直接
    绑定抽象 state 在该 index 的对象过滤结果。 *)
Definition store_sem_buckets_some_rest
    (stable : SemaphoreStable) (state : SemaphoreState) (index : Z)
    : Assertion :=
  let objects := semaphore_objects_in_bucket stable index
      state.(semaphore_objects) in
  EX prefix suffix : list SemBucket,
    “ 0 <= index < stable.(semaphore_bucket_count) /\
      Zlength prefix = index /\
      semaphore_buckets_ok stable state (prefix ++ Some objects :: suffix) ” &&
    store_sem_buckets_from stable 0 prefix **
    store_sem_buckets_from stable (index + 1) suffix.

Lemma store_sem_buckets_from_app_local :
  forall stable start (l1 l2 : list SemBucket),
    store_sem_buckets_from stable start l1 **
    store_sem_buckets_from stable (start + Zlength l1) l2 |--
    store_sem_buckets_from stable start (l1 ++ l2).
Proof.
  intros stable start l1; revert start.
  induction l1 as [| bucket rest IH]; intros start l2; simpl.
  - rewrite Zlength_nil. replace (start + 0) with start by lia. entailer!.
  - rewrite Zlength_cons.
    replace (start + Z.succ (Zlength rest))
      with (start + 1 + Zlength rest) by lia.
    sep_apply (IH (start + 1) l2). entailer!.
Qed.

Lemma store_sem_buckets_from_bucket_local :
  forall stable start bucket rest,
    store_sem_buckets_from stable (start + 1) rest **
    store_sem_bucket
      (stable.(semaphore_buckets_addr) +
        start * sizeof("SysDoubleLinklistNode")) bucket |--
    store_sem_buckets_from stable start (bucket :: rest).
Proof.
  intros stable start bucket rest. simpl. entailer!.
Qed.

Lemma store_sem_buckets_from_split_local :
  forall stable start index buckets,
    0 <= index < Zlength buckets ->
    store_sem_buckets_from stable start buckets |--
    EX bucket : SemBucket, EX prefix suffix : list SemBucket,
      “ bucket = Znth index buckets None /\
        buckets = app prefix (bucket :: suffix) /\
        Zlength prefix = index ” &&
      store_sem_bucket
        (stable.(semaphore_buckets_addr) +
          (start + index) * sizeof("SysDoubleLinklistNode")) bucket **
      store_sem_buckets_from stable start prefix **
      store_sem_buckets_from stable (start + index + 1) suffix.
Proof.
  intros stable start index buckets Hrange.
  revert start index Hrange.
  induction buckets as [| bucket rest IH]; intros start index Hrange.
  - unfold derivable1. intros m Hm. rewrite Zlength_nil in Hrange. lia.
  - destruct (Z.eq_dec index 0) as [Hindex | Hindex].
    + subst index. simpl.
      Exists bucket (@nil SemBucket) rest.
      replace (start + 0) with start by lia.
      replace (start + 0 + 1) with (start + 1) by lia.
      entailer!.
    + assert (0 <= index - 1 < Zlength rest) as Htail
        by (rewrite Zlength_cons in Hrange; lia).
      specialize (IH (start + 1) (index - 1) Htail).
      simpl. sep_apply IH. Intros selected prefix suffix.
      Exists selected (bucket :: prefix) suffix.
      simpl.
      replace (Zlength prefix + 1) with (1 + Zlength prefix) by lia.
      replace (start + index) with (start + 1 + (index - 1)) by lia.
      replace (start + index + 1)
        with (start + 1 + (index - 1) + 1) by lia.
      entailer!.
      all: destruct H as [Hz [Happ Hlen]].
      all: try (rewrite Znth_cons by lia; exact Hz).
      all: try (rewrite Happ; reflexivity).
      all: try (rewrite Zlength_cons; lia).
Qed.

Lemma semaphore_buckets_match_from_Znth_local :
  forall stable start buckets objects index,
    0 <= index < Zlength buckets ->
    semaphore_buckets_match_from stable start buckets objects ->
    match Znth index buckets None with
    | None =>
        semaphore_objects_in_bucket stable (start + index) objects = nil
    | Some bucket_objects =>
        bucket_objects =
          semaphore_objects_in_bucket stable (start + index) objects
    end.
Proof.
  intros stable start buckets; revert start.
  induction buckets as [| bucket rest IH]; intros start objects index Hrange Hmatch.
  - rewrite Zlength_nil in Hrange. lia.
  - simpl in Hmatch. destruct Hmatch as [Hhead Htail].
    destruct (Z.eq_dec index 0) as [-> | Hneq].
    + simpl. replace (start + 0) with start by lia. exact Hhead.
    + rewrite Znth_cons by lia.
      replace (start + index) with (start + 1 + (index - 1)) by lia.
      apply IH; [rewrite Zlength_cons in Hrange; lia | exact Htail].
Qed.

Lemma store_sem_dll_take_prev_local :
  forall {A : Type} (store_payload : addr -> A -> Assertion) head nodes,
    store_sem_dll store_payload head nodes |--
    EX last : addr,
      “ head <> 0 /\ last <> 0 ” &&
      &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
      store_sem_dll_without_prev store_payload head nodes last.
Proof.
  intros A store_payload head nodes.
  unfold store_sem_dll. Intros first last.
  Exists last. unfold store_sem_dll_without_prev. Exists first. entailer!.
Qed.

Lemma store_sem_dll_take_prev_frame_local :
  forall {A : Type} (store_payload : addr -> A -> Assertion)
      head nodes (frame : Assertion),
    store_sem_dll store_payload head nodes ** frame |--
    EX last : addr,
      “ head <> 0 ” && “ last <> 0 ” &&
      ((&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
        store_sem_dll_without_prev store_payload head nodes last) ** frame).
Proof.
  intros A store_payload head nodes frame.
  sep_apply (store_sem_dll_take_prev_local store_payload head nodes).
  Intros last. Exists last. entailer!.
Qed.

Lemma store_sem_uninitialized_bucket_nonzero_frame_local :
  forall head (frame : Assertion),
    store_sem_uninitialized_bucket head ** frame |--
    “ head <> 0 ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
    (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0 **
      frame).
Proof.
  intros head frame. unfold store_sem_uninitialized_bucket. entailer!.
Qed.

Lemma sem_andp_sepcon_assoc_local :
  forall (P : Prop) (A B C : Assertion),
    “ P ” && A ** (B ** C) |-- “ P ” && (A ** B) ** C.
Proof.
  intros P A B C. entailer!.
Qed.

Lemma sem_andp_sepcon_assoc_rev_local :
  forall (P : Prop) (A B C : Assertion),
    “ P ” && (A ** B) ** C |-- “ P ” && A ** (B ** C).
Proof.
  intros P A B C. entailer!.
Qed.

Lemma store_sem_buckets_frames_none_local :
  forall stable state index prefix suffix,
    0 <= index < stable.(semaphore_bucket_count) ->
    Zlength prefix = index ->
    semaphore_buckets_ok stable state (app prefix (None :: suffix)) ->
    store_sem_buckets_from stable 0 prefix **
    store_sem_buckets_from stable (index + 1) suffix |--
    store_sem_buckets_none_rest stable state index.
Proof.
  intros stable state index prefix suffix Hrange Hprefix Hbucket.
  unfold store_sem_buckets_none_rest. Exists prefix suffix. entailer!.
Qed.

Lemma store_sem_buckets_frames_some_local :
  forall stable state index objects prefix suffix,
    0 <= index < stable.(semaphore_bucket_count) ->
    Zlength prefix = index ->
    semaphore_buckets_ok stable state (app prefix (Some objects :: suffix)) ->
    objects = semaphore_objects_in_bucket stable index state.(semaphore_objects) ->
    store_sem_buckets_from stable 0 prefix **
    store_sem_buckets_from stable (index + 1) suffix |--
    store_sem_buckets_some_rest stable state index.
Proof.
  intros stable state index objects prefix suffix
    Hrange Hprefix Hbucket Hobjects.
  unfold store_sem_buckets_some_rest. Exists prefix suffix. entailer!.
  rewrite <- Hobjects. exact Hbucket.
Qed.

(** [InsertObj] 按 ID 聚焦一个 bucket；None 暴露 BSS 双 NULL，Some 暴露
    [head.prev] 与携带同一 [last] 的 remainder，因此之后可无损回封 DLL。 *)
Lemma store_semaphore_buckets_focus_local :
  forall stable state id,
    SemaphoreStableContext stable ->
    0 <= id < stable.(semaphore_id_limit) ->
    store_semaphore_buckets stable state |--
    let head := stable.(semaphore_buckets_addr) +
      (id mod stable.(semaphore_bucket_count)) *
        sizeof("SysDoubleLinklistNode") in
    (“ head <> 0 ” &&
      ((&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
        &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0) **
        store_sem_buckets_none_rest stable state (id mod 16))) ||
    (EX last : addr,
      “ head <> 0 ” && “ last <> 0 ” &&
      ((&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
        store_sem_dll_without_prev store_semaphore_id_payload head
          (map semaphore_id_node
            (semaphore_objects_in_bucket stable (id mod 16)
              state.(semaphore_objects))) last) **
        store_sem_buckets_some_rest stable state (id mod 16))).
Proof.
  intros stable state id Hstable Hid.
  cbn.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as
    (Hmanager & Hbitmap & Hbuckets & Hregistry & Hidlimit & Hstable_count).
  assert (Hcount16 : semaphore_bucket_count stable = 16).
  { unfold SEM_BUCKET_COUNT in Hstable_count. exact Hstable_count. }
  assert (Hindex : 0 <= id mod semaphore_bucket_count stable <
      semaphore_bucket_count stable).
  { apply Z.mod_pos_bound. rewrite Hcount16. lia. }
  rewrite Hcount16.
  unfold store_semaphore_buckets.
  eapply derivable1s_exp_l; intro buckets.
  eapply coq_prop_andp_left; intro Hbucket_ok.
  unfold semaphore_buckets_ok in Hbucket_ok.
  destruct Hbucket_ok as [Hlength Hstore].
  assert (Hrange : 0 <= id mod semaphore_bucket_count stable < Zlength buckets).
  { rewrite Hlength. exact Hindex. }
  sep_apply (store_sem_buckets_from_split_local stable 0
    (id mod semaphore_bucket_count stable) buckets Hrange).
  Intros bucket prefix suffix.
  destruct H as [Hselected [Hsplit Hprefix]].
  assert (Hselected_match := semaphore_buckets_match_from_Znth_local
    stable 0 buckets state.(semaphore_objects)
    (id mod semaphore_bucket_count stable) Hrange Hstore).
  rewrite <- Hselected in Hselected_match.
  assert (Hbucket_all : semaphore_buckets_ok stable state buckets).
  { unfold semaphore_buckets_ok. split; [exact Hlength | exact Hstore]. }
  rewrite Hsplit in Hbucket_all.
  destruct bucket as [objects |].
  - right. unfold store_sem_bucket, store_sem_initialized_bucket in H.
    replace (0 + id mod semaphore_bucket_count stable)
      with (id mod semaphore_bucket_count stable) in Hselected_match by lia.
    rewrite Hcount16 in Hprefix, Hselected_match, H.
    rewrite Hselected_match in H.
    assert (Hrest :
      store_sem_buckets_from stable 0 prefix **
      store_sem_buckets_from stable (id mod 16 + 1) suffix |--
      store_sem_buckets_some_rest stable state (id mod 16)).
    { apply store_sem_buckets_frames_some_local with
        (objects := objects) (prefix := prefix) (suffix := suffix).
      - rewrite Hcount16. apply Z.mod_pos_bound. lia.
      - exact Hprefix.
      - exact Hbucket_all.
      - exact Hselected_match. }
    assert (Hmono :
      store_sem_dll store_semaphore_id_payload
        (semaphore_buckets_addr stable +
          (id mod 16) * sizeof("SysDoubleLinklistNode"))
        (map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            state.(semaphore_objects))) **
      (store_sem_buckets_from stable 0 prefix **
        store_sem_buckets_from stable (id mod 16 + 1) suffix) |--
      store_sem_dll store_semaphore_id_payload
        (semaphore_buckets_addr stable +
          (id mod 16) * sizeof("SysDoubleLinklistNode"))
        (map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            state.(semaphore_objects))) **
      store_sem_buckets_some_rest stable state (id mod 16)).
    { apply derivable1_sepcon_mono; [apply derivable1_refl | exact Hrest]. }
    specialize (Hmono m H).
    exact ((store_sem_dll_take_prev_frame_local
      store_semaphore_id_payload
      (semaphore_buckets_addr stable +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (map semaphore_id_node
        (semaphore_objects_in_bucket stable (id mod 16)
          state.(semaphore_objects)))
      (store_sem_buckets_some_rest stable state (id mod 16))) m Hmono).
  - left. unfold store_sem_bucket, store_sem_uninitialized_bucket in H.
    rewrite Hcount16 in Hprefix, H.
    assert (Hrest :
      store_sem_buckets_from stable 0 prefix **
      store_sem_buckets_from stable (id mod 16 + 1) suffix |--
      store_sem_buckets_none_rest stable state (id mod 16)).
    { apply store_sem_buckets_frames_none_local with
        (prefix := prefix) (suffix := suffix).
      - rewrite Hcount16. apply Z.mod_pos_bound. lia.
      - exact Hprefix.
      - exact Hbucket_all. }
    assert (Hmono :
      store_sem_uninitialized_bucket
        (semaphore_buckets_addr stable +
          (id mod 16) * sizeof("SysDoubleLinklistNode")) **
      (store_sem_buckets_from stable 0 prefix **
        store_sem_buckets_from stable (id mod 16 + 1) suffix) |--
      store_sem_uninitialized_bucket
        (semaphore_buckets_addr stable +
          (id mod 16) * sizeof("SysDoubleLinklistNode")) **
      store_sem_buckets_none_rest stable state (id mod 16)).
    { apply derivable1_sepcon_mono; [apply derivable1_refl | exact Hrest]. }
    specialize (Hmono m H).
    exact ((store_sem_uninitialized_bucket_nonzero_frame_local
      (semaphore_buckets_addr stable +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (store_sem_buckets_none_rest stable state (id mod 16))) m Hmono).
Qed.

(** 向 semaphore object list 表头加入新对象时，只有其 ID 对应 bucket 的
    filter 结果发生变化。 *)
Lemma semaphore_objects_in_bucket_reserve_local :
  forall stable before sem id index,
    stable.(semaphore_bucket_count) = 16 ->
    semaphore_objects_in_bucket stable index
      (semaphore_reserve_state before sem id).(semaphore_objects) =
    if Z.eq_dec (id mod 16) index
    then Build_SemaphoreObject sem id 0 nil ::
      semaphore_objects_in_bucket stable index before.(semaphore_objects)
    else semaphore_objects_in_bucket stable index before.(semaphore_objects).
Proof.
  intros stable before sem id index Hcount.
  unfold semaphore_reserve_state, semaphore_create_state.
  unfold semaphore_objects_in_bucket. simpl.
  rewrite Hcount. destruct (Z.eq_dec (id mod 16) index); reflexivity.
Qed.

Lemma semaphore_buckets_match_from_app_split_local :
  forall stable start prefix suffix objects,
    semaphore_buckets_match_from stable start (prefix ++ suffix) objects ->
    semaphore_buckets_match_from stable start prefix objects /\
    semaphore_buckets_match_from stable (start + Zlength prefix) suffix objects.
Proof.
  intros stable start prefix; revert start.
  induction prefix as [| bucket rest IH]; intros start suffix objects Hmatch.
  - simpl in *. rewrite Zlength_nil. replace (start + 0) with start by lia.
    split; [exact I | exact Hmatch].
  - simpl in Hmatch. destruct Hmatch as [Hhead Htail].
    specialize (IH (start + 1) suffix objects Htail).
    destruct IH as [Hrest Hsuffix]. split.
    + simpl. split; assumption.
    + rewrite Zlength_cons.
      replace (start + Z.succ (Zlength rest))
        with (start + 1 + Zlength rest) by lia.
      exact Hsuffix.
Qed.

Lemma semaphore_buckets_match_from_app_merge_local :
  forall stable start prefix suffix objects,
    semaphore_buckets_match_from stable start prefix objects ->
    semaphore_buckets_match_from stable (start + Zlength prefix) suffix objects ->
    semaphore_buckets_match_from stable start (prefix ++ suffix) objects.
Proof.
  intros stable start prefix; revert start.
  induction prefix as [| bucket rest IH]; intros start suffix objects Hprefix Hsuffix.
  - simpl in *. rewrite Zlength_nil in Hsuffix.
    replace (start + 0) with start in Hsuffix by lia. exact Hsuffix.
  - simpl in Hprefix. destruct Hprefix as [Hhead Hrest]. simpl. split.
    + exact Hhead.
    + apply IH; [exact Hrest |].
      rewrite Zlength_cons in Hsuffix.
      replace (start + Z.succ (Zlength rest))
        with (start + 1 + Zlength rest) in Hsuffix by lia.
      exact Hsuffix.
Qed.

Lemma semaphore_buckets_match_from_cons_other_local :
  forall stable start buckets objects sem id target,
    stable.(semaphore_bucket_count) = 16 ->
    target = id mod 16 ->
    (start + Zlength buckets <= target \/ target < start) ->
    semaphore_buckets_match_from stable start buckets objects ->
    semaphore_buckets_match_from stable start buckets
      (Build_SemaphoreObject sem id 0 nil :: objects).
Proof.
  intros stable start buckets; revert start.
  induction buckets as [| bucket rest IH];
    intros start objects sem id target Hcount Htarget Houtside Hmatch.
  - simpl. exact I.
  - simpl in Hmatch. destruct Hmatch as [Hhead Htail]. simpl. split.
    + assert (Hneq : target <> start).
      { pose proof (Zlength_nonneg rest).
        rewrite Zlength_cons in Houtside. destruct Houtside; lia. }
      unfold semaphore_objects_in_bucket in Hhead |- *. simpl.
      rewrite Hcount in Hhead |- *.
      destruct (Z.eq_dec (id mod 16) start) as [Heq | Heq]; simpl.
      * rewrite <- Htarget in Heq. contradiction.
      * exact Hhead.
    + apply IH with (target := target); try assumption.
      pose proof (Zlength_nonneg rest).
      rewrite Zlength_cons in Houtside. destruct Houtside; [left | right]; lia.
Qed.

Lemma semaphore_buckets_ok_reserve_none_local :
  forall stable before sem id prefix suffix,
    stable.(semaphore_bucket_count) = 16 ->
    Zlength prefix = id mod 16 ->
    semaphore_buckets_ok stable before (prefix ++ None :: suffix) ->
    semaphore_buckets_ok stable (semaphore_reserve_state before sem id)
      (prefix ++ Some (Build_SemaphoreObject sem id 0 nil :: nil) :: suffix).
Proof.
  intros stable before sem id prefix suffix Hcount Hprefix Hok.
  unfold semaphore_buckets_ok in Hok |- *. destruct Hok as [Hlength Hmatch].
  split.
  - repeat rewrite Zlength_app in *. repeat rewrite Zlength_cons in *.
    repeat rewrite Zlength_nil in *. lia.
  - pose proof (semaphore_buckets_match_from_app_split_local
      stable 0 prefix (None :: suffix) before.(semaphore_objects) Hmatch)
      as [Hpre Htail].
    replace (0 + Zlength prefix) with (id mod 16) in Htail by lia.
    simpl in Htail. destruct Htail as [Hselected Hsuf].
    assert (Hpre' : semaphore_buckets_match_from stable 0 prefix
      (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects))).
    { apply semaphore_buckets_match_from_cons_other_local with
        (target := id mod 16).
      - exact Hcount.
      - reflexivity.
      - left. rewrite <- Hprefix. apply Z.le_refl.
      - exact Hpre. }
    assert (Hsuf' : semaphore_buckets_match_from stable (id mod 16 + 1) suffix
      (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects))).
    { apply semaphore_buckets_match_from_cons_other_local with
        (target := id mod 16).
      - exact Hcount.
      - reflexivity.
      - right. rewrite <- Hprefix. apply Z.lt_succ_diag_r.
      - rewrite <- Hprefix. exact Hsuf. }
    apply semaphore_buckets_match_from_app_merge_local.
    + exact Hpre'.
    + replace (0 + Zlength prefix) with (id mod 16) by lia.
      simpl. split.
      * change (Build_SemaphoreObject sem id 0 nil :: nil =
          semaphore_objects_in_bucket stable (Zlength prefix)
            (semaphore_reserve_state before sem id).(semaphore_objects)).
        rewrite semaphore_objects_in_bucket_reserve_local by exact Hcount.
        destruct (Z.eq_dec (id mod 16) (Zlength prefix))
          as [Heq | Hneq].
        -- simpl. f_equal. symmetry. exact Hselected.
        -- exfalso. apply Hneq. symmetry. exact Hprefix.
      * exact (eq_ind_r
          (fun z => semaphore_buckets_match_from stable (z + 1) suffix
            (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects)))
          Hsuf' Hprefix).
Qed.

Lemma semaphore_buckets_none_selected_empty_local :
  forall stable state index prefix suffix,
    Zlength prefix = index ->
    semaphore_buckets_ok stable state (prefix ++ None :: suffix) ->
    semaphore_objects_in_bucket stable index state.(semaphore_objects) = nil.
Proof.
  intros stable state index prefix suffix Hprefix Hok.
  unfold semaphore_buckets_ok in Hok. destruct Hok as [Hlength Hmatch].
  pose proof (semaphore_buckets_match_from_app_split_local
    stable 0 prefix (None :: suffix) state.(semaphore_objects) Hmatch)
    as [Hpre Htail].
  simpl in Htail. destruct Htail as [Hselected Hsuffix].
  exact (eq_ind (Zlength prefix)
    (fun z => semaphore_objects_in_bucket stable z
      state.(semaphore_objects) = nil) Hselected index Hprefix).
Qed.

Lemma semaphore_buckets_ok_reserve_some_local :
  forall stable before sem id objects prefix suffix,
    stable.(semaphore_bucket_count) = 16 ->
    Zlength prefix = id mod 16 ->
    objects = semaphore_objects_in_bucket stable (id mod 16)
      before.(semaphore_objects) ->
    semaphore_buckets_ok stable before (prefix ++ Some objects :: suffix) ->
    semaphore_buckets_ok stable (semaphore_reserve_state before sem id)
      (prefix ++ Some (Build_SemaphoreObject sem id 0 nil :: objects) :: suffix).
Proof.
  intros stable before sem id objects prefix suffix Hcount Hprefix Hobjects Hok.
  unfold semaphore_buckets_ok in Hok |- *. destruct Hok as [Hlength Hmatch].
  split.
  - repeat rewrite Zlength_app in *. repeat rewrite Zlength_cons in *.
    repeat rewrite Zlength_nil in *. lia.
  - pose proof (semaphore_buckets_match_from_app_split_local
      stable 0 prefix (Some objects :: suffix) before.(semaphore_objects) Hmatch)
      as [Hpre Htail].
    replace (0 + Zlength prefix) with (id mod 16) in Htail by lia.
    simpl in Htail. destruct Htail as [Hselected Hsuf].
    assert (Hpre' : semaphore_buckets_match_from stable 0 prefix
      (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects))).
    { apply semaphore_buckets_match_from_cons_other_local with
        (target := id mod 16).
      - exact Hcount.
      - reflexivity.
      - left. rewrite <- Hprefix. apply Z.le_refl.
      - exact Hpre. }
    assert (Hsuf' : semaphore_buckets_match_from stable (id mod 16 + 1) suffix
      (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects))).
    { apply semaphore_buckets_match_from_cons_other_local with
        (target := id mod 16).
      - exact Hcount.
      - reflexivity.
      - right. rewrite <- Hprefix. apply Z.lt_succ_diag_r.
      - rewrite <- Hprefix. exact Hsuf. }
    apply semaphore_buckets_match_from_app_merge_local.
    + exact Hpre'.
    + replace (0 + Zlength prefix) with (id mod 16) by lia.
      simpl. split.
      * change (Build_SemaphoreObject sem id 0 nil :: objects =
          semaphore_objects_in_bucket stable (Zlength prefix)
            (semaphore_reserve_state before sem id).(semaphore_objects)).
        rewrite semaphore_objects_in_bucket_reserve_local by exact Hcount.
        destruct (Z.eq_dec (id mod 16) (Zlength prefix))
          as [Heq | Hneq].
        -- simpl. f_equal. exact Hselected.
        -- exfalso. apply Hneq. symmetry. exact Hprefix.
      * exact (eq_ind_r
          (fun z => semaphore_buckets_match_from stable (z + 1) suffix
            (Build_SemaphoreObject sem id 0 nil :: before.(semaphore_objects)))
          Hsuf' Hprefix).
Qed.

Lemma store_sem_buckets_rebuild_local :
  forall stable index bucket prefix suffix,
    Zlength prefix = index ->
    store_sem_bucket
      (stable.(semaphore_buckets_addr) +
        index * sizeof("SysDoubleLinklistNode")) bucket **
    store_sem_buckets_from stable 0 prefix **
    store_sem_buckets_from stable (index + 1) suffix |--
    store_sem_buckets_from stable 0 (prefix ++ bucket :: suffix).
Proof.
  intros stable index bucket prefix suffix Hprefix.
  sep_apply (store_sem_buckets_from_bucket_local stable index bucket suffix).
  pose proof (store_sem_buckets_from_app_local stable 0 prefix
    (bucket :: suffix)) as Happ.
  replace (0 + Zlength prefix) with index in Happ by lia.
  sep_apply Happ. entailer!.
Qed.

Lemma store_semaphore_buckets_reserve_none_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (map semaphore_id_node
        (Build_SemaphoreObject sem id 0 nil ::
          semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_none_rest stable before (id mod 16) |--
    store_semaphore_buckets stable (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  unfold store_sem_buckets_none_rest. Intros prefix suffix.
  destruct H as (Hrange & Hprefix & Hok).
  assert (Hempty := semaphore_buckets_none_selected_empty_local
    stable before (id mod 16) prefix suffix Hprefix Hok).
  rewrite Hempty.
  assert (Hok' := semaphore_buckets_ok_reserve_none_local
    stable before sem id prefix suffix Hcount Hprefix Hok).
  pose proof (store_sem_buckets_rebuild_local stable (id mod 16)
    (Some (Build_SemaphoreObject sem id 0 nil :: nil)) prefix suffix Hprefix)
    as Hrebuild.
  unfold store_sem_bucket, store_sem_initialized_bucket in Hrebuild.
  sep_apply Hrebuild.
  unfold store_semaphore_buckets.
  Exists (app prefix (Some (Build_SemaphoreObject sem id 0 nil :: nil) :: suffix)).
  entailer!.
Qed.

Lemma store_semaphore_buckets_reserve_some_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (map semaphore_id_node
        (Build_SemaphoreObject sem id 0 nil ::
          semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_some_rest stable before (id mod 16) |--
    store_semaphore_buckets stable (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  unfold store_sem_buckets_some_rest. Intros prefix suffix.
  destruct H as (Hrange & Hprefix & Hok).
  assert (Hok' := semaphore_buckets_ok_reserve_some_local
    stable before sem id
    (semaphore_objects_in_bucket stable (id mod 16) before.(semaphore_objects))
    prefix suffix Hcount Hprefix eq_refl Hok).
  pose proof (store_sem_buckets_rebuild_local stable (id mod 16)
    (Some (Build_SemaphoreObject sem id 0 nil ::
      semaphore_objects_in_bucket stable (id mod 16) before.(semaphore_objects)))
    prefix suffix Hprefix)
    as Hrebuild.
  unfold store_sem_bucket, store_sem_initialized_bucket in Hrebuild.
  sep_apply Hrebuild.
  unfold store_semaphore_buckets.
  Exists (app prefix
    (Some (Build_SemaphoreObject sem id 0 nil ::
      semaphore_objects_in_bucket stable (id mod 16) before.(semaphore_objects)) ::
      suffix)).
  entailer!.
Qed.

(** QCP 会把 [map semaphore_id_node (new_object :: objects)] 的表头化简成
    显式 [Build_SemDLNode]。下面两个桥接 lemma 只把该定义相等形态暴露给
    [sep_apply]，不改变 bucket 更新语义或 ownership。 *)
Lemma store_semaphore_buckets_reserve_none_insert_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (Build_SemDLNode (Build_SemaphoreObject sem id 0 nil)
          (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")) ::
        map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_none_rest stable before (id mod 16) |--
    store_semaphore_buckets stable (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  change
    (store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (map semaphore_id_node
        (Build_SemaphoreObject sem id 0 nil ::
          semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
     store_sem_buckets_none_rest stable before (id mod 16) |--
     store_semaphore_buckets stable (semaphore_reserve_state before sem id)).
  apply store_semaphore_buckets_reserve_none_local. exact Hcount.
Qed.

Lemma store_semaphore_buckets_reserve_some_insert_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (Build_SemDLNode (Build_SemaphoreObject sem id 0 nil)
          (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")) ::
        map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_some_rest stable before (id mod 16) |--
    store_semaphore_buckets stable (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  change
    (store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (map semaphore_id_node
        (Build_SemaphoreObject sem id 0 nil ::
          semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
     store_sem_buckets_some_rest stable before (id mod 16) |--
     store_semaphore_buckets stable (semaphore_reserve_state before sem id)).
  apply store_semaphore_buckets_reserve_some_local. exact Hcount.
Qed.

(** [InsertObj] 返回点的 manager frame：bucket 更新与已经由 [AllocId]
    更新的 bitmap/manager 字段重新组合成稳定 ID manager。 *)
Lemma store_semaphore_id_manager_reserve_none_insert_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    let manager := stable.(semaphore_manager_addr) in
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (Build_SemDLNode (Build_SemaphoreObject sem id 0 nil)
          (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")) ::
        map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_none_rest stable before (id mod 16) **
    &(manager # "IdManager" ->ₛ "id_max")
      # UShort |-> stable.(semaphore_id_limit) **
    &(manager # "IdManager" ->ₛ "hoffset")
      # UShort |-> 16 **
    &(manager # "IdManager" ->ₛ "id_map")
      # Ptr |-> stable.(semaphore_bitmap_addr) **
    &(manager # "IdManager" ->ₛ "htable")
      # Ptr |-> stable.(semaphore_buckets_addr) **
    store_semaphore_bitmap_ids stable
      (id :: semaphore_ids before.(semaphore_objects)) |--
    store_semaphore_id_manager stable
      (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  simpl.
  sep_apply (store_semaphore_buckets_reserve_none_insert_local
    stable before sem id Hcount).
  unfold store_semaphore_id_manager. rewrite Hcount. entailer!.
Qed.

Lemma store_semaphore_id_manager_reserve_some_insert_local :
  forall stable before sem id,
    stable.(semaphore_bucket_count) = 16 ->
    let manager := stable.(semaphore_manager_addr) in
    store_sem_dll store_semaphore_id_payload
      (stable.(semaphore_buckets_addr) +
        (id mod 16) * sizeof("SysDoubleLinklistNode"))
      (Build_SemDLNode (Build_SemaphoreObject sem id 0 nil)
          (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")) ::
        map semaphore_id_node
          (semaphore_objects_in_bucket stable (id mod 16)
            before.(semaphore_objects))) **
    store_sem_buckets_some_rest stable before (id mod 16) **
    &(manager # "IdManager" ->ₛ "id_max")
      # UShort |-> stable.(semaphore_id_limit) **
    &(manager # "IdManager" ->ₛ "hoffset")
      # UShort |-> 16 **
    &(manager # "IdManager" ->ₛ "id_map")
      # Ptr |-> stable.(semaphore_bitmap_addr) **
    &(manager # "IdManager" ->ₛ "htable")
      # Ptr |-> stable.(semaphore_buckets_addr) **
    store_semaphore_bitmap_ids stable
      (id :: semaphore_ids before.(semaphore_objects)) |--
    store_semaphore_id_manager stable
      (semaphore_reserve_state before sem id).
Proof.
  intros stable before sem id Hcount.
  simpl.
  sep_apply (store_semaphore_buckets_reserve_some_insert_local
    stable before sem id Hcount).
  unfold store_semaphore_id_manager. rewrite Hcount. entailer!.
Qed.

Lemma store_sem_dll_empty_none_rest_local :
  forall stable state index head,
    store_sem_dll semaphore_unit_empty head nil **
    store_sem_buckets_none_rest stable state index |--
    store_sem_dll store_semaphore_id_payload head
      (map semaphore_id_node
        (semaphore_objects_in_bucket stable index state.(semaphore_objects))) **
    store_sem_buckets_none_rest stable state index.
Proof.
  intros stable state index head.
  unfold store_sem_buckets_none_rest. Intros prefix suffix.
  destruct H as (Hrange & Hprefix & Hok).
  assert (Hempty := semaphore_buckets_none_selected_empty_local
    stable state index prefix suffix Hprefix Hok).
  rewrite Hempty. simpl.
  sep_apply (store_sem_dll_empty_change_payload_local
    semaphore_unit_empty store_semaphore_id_payload head).
  unfold store_sem_buckets_none_rest. Exists prefix suffix. entailer!.
Qed.

(** 统一 OS invariant 中除 semaphore manager/registry 之外的精确 frame。
    create 只更新 semaphore state，task 与 scheduler ownership 原样保留。 *)
Definition crtos_semaphore_nonsem_frame
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  “ CrtosTaskStableContext stable.(crtos_task_stable) /\
    CrtosSchedulerStableContext world.(crtos_scheduler_state) /\
    crtos_os_world_wf stable world /\
    SemaphoreStableContext stable.(crtos_semaphore_stable) /\
    semaphore_state_wf stable.(crtos_semaphore_stable)
      world.(crtos_semaphore_state) ” &&
  store_crtos_task_done stable.(crtos_task_stable) **
  store_crtos_ready_vector_done world.(crtos_scheduler_state) **
  store_crtos_task_id_manager stable.(crtos_task_stable)
    world.(crtos_task_state) **
  store_crtos_task_registry stable.(crtos_task_stable)
    world.(crtos_task_state) **
  store_crtos_task_desc_map world **
  store_crtos_scheduler world.(crtos_scheduler_state) **
  store_crtos_external_wait_queues
    world.(crtos_scheduler_state).(crtos_external_wait_queues) **
  store_crtos_zombie_queue
    world.(crtos_scheduler_state).(crtos_zombie_tasks) **
  store_crtos_delays world.(crtos_scheduler_state).

(** create 中不访问的两段 2-byte zero padding，单独命名以便 QCP frame。 *)
Definition store_sem_id_padding_zero (sem : addr) : Assertion :=
  CharArray.full (sem + 2) 2 (repeat_Z 0 2).

Definition store_sem_body_padding_zero (sem : addr) : Assertion :=
  CharArray.full (sem + 14) 2 (repeat_Z 0 2).

(** 下列纯 lemma 只服务 [AllocId] 生成 VC：它们展开已批准的 bitmap/扫描
    定义，不改变模块抽象状态或函数契约。 *)
Lemma sem_testbit_255_low :
  forall bit, 0 <= bit < 8 -> Z.testbit 255 bit = true.
Proof.
  intros bit Hbit.
  assert (bit = 0 \/ bit = 1 \/ bit = 2 \/ bit = 3 \/
          bit = 4 \/ bit = 5 \/ bit = 6 \/ bit = 7) by lia.
  destruct H as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]];
    reflexivity.
Qed.

Lemma sem_div8_eq_of_range :
  forall index id,
    index * 8 <= id < (index + 1) * 8 -> id / 8 = index.
Proof.
  intros index id Hid.
  replace id with (index * 8 + (id - index * 8)) by lia.
  rewrite Z.add_comm, Z.div_add by lia.
  rewrite Z.div_small by lia.
  lia.
Qed.

Lemma sem_mod8_eq_of_range :
  forall index id,
    index * 8 <= id < (index + 1) * 8 ->
    id mod 8 = id - index * 8.
Proof.
  intros index id Hid.
  assert (exists offset,
      id = index * 8 + offset /\ 0 <= offset < 8) as Hoff.
  { exists (id - index * 8). split; lia. }
  destruct Hoff as [offset [Hid_eq Hoff]]. subst id.
  replace (index * 8 + offset - index * 8) with offset by lia.
  rewrite Z.add_comm.
  rewrite Z.add_mod by lia.
  replace (8 * index) with (index * 8) by lia.
  rewrite Z_mod_mult by lia.
  rewrite Z.add_0_r.
  replace (offset mod 8) with offset
    by (symmetry; apply Z.mod_small; lia).
  apply Z.mod_small; lia.
Qed.

Lemma sem_Forall_Znth_Zlength :
  forall {A : Type} (P : A -> Prop) (l : list A) (d : A) (i : Z),
    Forall P l -> 0 <= i < Zlength l -> P (Znth i l d).
Proof.
  intros A P l d i HForall Hrange.
  apply Forall_forall with (x := Znth i l d) in HForall; auto.
  unfold Znth. apply nth_In. apply Nat2Z.inj_lt.
  rewrite Z2Nat.id by lia.
  rewrite <- Zlength_correct. lia.
Qed.

Lemma semaphore_bitmap_ok_Znth_range_local :
  forall stable state bytes index,
    semaphore_bitmap_ok stable state bytes ->
    0 <= index < (stable.(semaphore_id_limit) + 7) / 8 ->
    0 <= Znth index bytes 0 <= 255.
Proof.
  intros stable state bytes index Hbitmap Hindex.
  unfold semaphore_bitmap_ok, semaphore_bitmap_ids_ok in Hbitmap.
  destruct Hbitmap as [Hlength [Hbytes _]].
  apply sem_Forall_Znth_Zlength; [exact Hbytes |].
  rewrite Hlength. exact Hindex.
Qed.

Lemma semaphore_bitmap_ok_byte_bits_local :
  forall stable state bytes index,
    semaphore_bitmap_ok stable state bytes ->
    0 <= index ->
    (index + 1) * 8 <= stable.(semaphore_id_limit) ->
    forall bit, 0 <= bit < 8 ->
      Z.testbit (Znth index bytes 0) bit =
      semaphore_id_used state (index * 8 + bit).
Proof.
  intros stable state bytes index Hbitmap Hindex Hcovered bit Hbit.
  unfold semaphore_bitmap_ok, semaphore_bitmap_ids_ok in Hbitmap.
  destruct Hbitmap as [_ [_ Hbits]].
  specialize (Hbits (index * 8 + bit) ltac:(lia)).
  assert (Hcell :
      index * 8 <= index * 8 + bit < (index + 1) * 8) by lia.
  rewrite (sem_div8_eq_of_range index (index * 8 + bit) Hcell) in Hbits.
  rewrite (sem_mod8_eq_of_range index (index * 8 + bit) Hcell) in Hbits.
  replace (index * 8 + bit - index * 8) with bit in Hbits by lia.
  unfold semaphore_id_used, semaphore_id_in. exact Hbits.
Qed.

Lemma sem_land_one_nonzero_testbit :
  forall entry, Z.land entry 1 <> 0 -> Z.testbit entry 0 = true.
Proof.
  intros entry Hland.
  destruct (Z.testbit entry 0) eqn:Hbit; [reflexivity |].
  exfalso. apply Hland.
  replace 1 with (Z.ones 1) by reflexivity.
  rewrite Z.land_ones by lia.
  change (entry mod 2 = 0).
  pose proof (Z.bit0_mod entry) as Hmod.
  rewrite Hbit in Hmod. cbn in Hmod. symmetry. exact Hmod.
Qed.

Lemma sem_land_one_zero_testbit :
  forall entry, Z.land entry 1 = 0 -> Z.testbit entry 0 = false.
Proof.
  intros entry Hland.
  destruct (Z.testbit entry 0) eqn:Hbit; [| reflexivity].
  exfalso.
  replace 1 with (Z.ones 1) in Hland by reflexivity.
  rewrite Z.land_ones in Hland by lia.
  pose proof (Z.bit0_mod entry) as Hmod.
  rewrite Hbit in Hmod. cbn in Hland, Hmod. lia.
Qed.

Lemma sem_shiftr_one_range :
  forall entry,
    0 <= entry <= 255 -> 0 <= Z.shiftr entry 1 <= 255.
Proof.
  intros entry Hentry.
  split.
  - apply (proj2 (Z.shiftr_nonneg entry 1)). lia.
  - rewrite Z.shiftr_div_pow2 by lia. cbn.
    apply Z.le_trans with entry; [| lia].
    apply Z.div_le_upper_bound; lia.
Qed.

Lemma semaphore_alloc_index_inv_init_local :
  forall stable state,
    0 <= stable.(semaphore_id_limit) ->
    semaphore_alloc_index_inv stable state 0.
Proof.
  intros stable state Hlimit.
  unfold semaphore_alloc_index_inv.
  split.
  - split; [lia |]. apply Z.div_pos; lia.
  - intros id Hid. simpl in Hid. lia.
Qed.

Lemma semaphore_alloc_index_inv_step_local :
  forall stable state bytes index,
    semaphore_bitmap_ok stable state bytes ->
    semaphore_alloc_index_inv stable state index ->
    0 <= index < (stable.(semaphore_id_limit) + 7) / 8 ->
    Znth index bytes 0 = 255 ->
    semaphore_alloc_index_inv stable state (index + 1).
Proof.
  intros stable state bytes index Hbitmap Hindex Hrange Hbyte.
  unfold semaphore_alloc_index_inv in Hindex |- *.
  destruct Hindex as [Hindex_range Hprefix].
  split.
  - lia.
  - intros id Hid.
    destruct (Z_lt_ge_dec id (index * 8)) as [Hbefore | Hcurrent].
    + apply Hprefix. split; [lia |].
      apply Z.min_glb_lt; lia.
    + unfold semaphore_bitmap_ok, semaphore_bitmap_ids_ok in Hbitmap.
      destruct Hbitmap as [_ [_ Hbits]].
      specialize (Hbits id).
      assert (Hid_limit : 0 <= id < semaphore_id_limit stable) by
        (destruct Hid; pose proof (Z.min_glb_lt_iff
          ((index + 1) * 8) (semaphore_id_limit stable) id); lia).
      specialize (Hbits Hid_limit).
      assert (Hcell : index * 8 <= id < (index + 1) * 8) by
        (destruct Hid; pose proof (Z.min_glb_lt_iff
          ((index + 1) * 8) (semaphore_id_limit stable) id); lia).
      rewrite (sem_div8_eq_of_range index id Hcell) in Hbits.
      rewrite Hbyte in Hbits.
      rewrite sem_testbit_255_low in Hbits.
      * unfold semaphore_id_used, semaphore_id_in. symmetry. exact Hbits.
      * pose proof (Z.mod_pos_bound id 8 ltac:(lia)). lia.
Qed.

Lemma semaphore_first_free_from_none_local :
  forall state fuel start,
    (forall id,
      start <= id < start + Z.of_nat fuel ->
      semaphore_id_used state id = true) ->
    semaphore_first_free_from state fuel start = None.
Proof.
  intros state fuel. induction fuel as [| fuel IH]; intros start Hall.
  - reflexivity.
  - simpl.
    rewrite Hall.
    + apply IH. intros id Hid. apply Hall.
      rewrite Nat2Z.inj_succ in *. unfold Z.succ in *. lia.
    + rewrite Nat2Z.inj_succ. unfold Z.succ. lia.
Qed.

Lemma semaphore_first_free_none_all_used_local :
  forall stable state,
    0 <= stable.(semaphore_id_limit) ->
    (forall id, 0 <= id < stable.(semaphore_id_limit) ->
      semaphore_id_used state id = true) ->
    semaphore_first_free stable state = None.
Proof.
  intros stable state Hlimit Hall.
  unfold semaphore_first_free.
  apply semaphore_first_free_from_none_local.
  intros id Hid. apply Hall.
  rewrite Z2Nat.id in Hid by lia. lia.
Qed.

Lemma semaphore_alloc_index_inv_no_free_local :
  forall stable state index,
    0 <= stable.(semaphore_id_limit) ->
    semaphore_alloc_index_inv stable state index ->
    stable.(semaphore_id_limit) <= index * 8 ->
    semaphore_first_free stable state = None.
Proof.
  intros stable state index Hlimit Hindex Hcovered.
  apply semaphore_first_free_none_all_used_local; [exact Hlimit |].
  unfold semaphore_alloc_index_inv in Hindex.
  destruct Hindex as [_ Hprefix].
  intros id Hid. apply Hprefix.
  split; [lia |]. apply Z.min_glb_lt; lia.
Qed.

Lemma semaphore_alloc_entry_inv_no_free_local :
  forall stable state index id entry,
    0 <= stable.(semaphore_id_limit) ->
    semaphore_alloc_index_inv stable state index ->
    semaphore_alloc_entry_inv stable state index id entry ->
    stable.(semaphore_id_limit) <= id ->
    semaphore_first_free stable state = None.
Proof.
  intros stable state index id entry Hlimit Hindex Hentry Hpast.
  apply semaphore_first_free_none_all_used_local; [exact Hlimit |].
  unfold semaphore_alloc_index_inv in Hindex.
  destruct Hindex as [_ Houter].
  unfold semaphore_alloc_entry_inv in Hentry.
  destruct Hentry as
    (offset & Hid & Hoff & _ & Hinner & _ & _ & _).
  intros candidate Hcandidate.
  destruct (Z_lt_ge_dec candidate (index * 8)) as [Hbefore | Hwithin].
  - apply Houter. split; [lia |]. apply Z.min_glb_lt; lia.
  - specialize (Hinner (candidate - index * 8)).
    replace (index * 8 + (candidate - index * 8)) with candidate in Hinner
      by lia.
    apply Hinner. lia.
Qed.

(** [replace_Znth] 保持逐元素 byte 范围；用于重建更新后的 bitmap 表示。 *)
Lemma sem_Forall_replace_Znth :
  forall {A : Type} (P : A -> Prop) (i : Z) (l : list A) (a : A),
    Forall P l -> P a -> Forall P (replace_Znth i a l).
Proof.
  intros A P i l a HForall Ha.
  assert (forall n,
      Forall P l -> P a -> Forall P (replace_nth n l a)) as Hreplace.
  { clear i HForall Ha. intros n HForall Ha. revert n.
    induction HForall; intros n; destruct n; simpl; constructor; auto. }
  unfold replace_Znth. apply Hreplace; assumption.
Qed.

Lemma sem_lor_byte_range :
  forall a b,
    0 <= a <= 255 -> 0 <= b <= 255 ->
    0 <= Z.lor a b <= 255.
Proof.
  intros a b Ha Hb.
  assert (Hnonneg : 0 <= Z.lor a b).
  { apply (proj2 (Z.lor_nonneg a b)). tauto. }
  split; [exact Hnonneg |].
  destruct (Z.eq_dec (Z.lor a b) 0) as [Hzero | Hnonzero]; [lia |].
  assert (Hpos : 0 < Z.lor a b) by lia.
  assert (Ha_log : Z.log2 a < 8).
  { destruct (Z.eq_dec a 0) as [Ha0 | Haneq].
    - subst a. vm_compute. reflexivity.
    - apply (proj1 (Z.log2_lt_pow2 a 8 ltac:(lia))).
      change (a < 256). lia. }
  assert (Hb_log : Z.log2 b < 8).
  { destruct (Z.eq_dec b 0) as [Hb0 | Hbneq].
    - subst b. vm_compute. reflexivity.
    - apply (proj1 (Z.log2_lt_pow2 b 8 ltac:(lia))).
      change (b < 256). lia. }
  assert (Hlt : Z.lor a b < 2 ^ 8).
  { apply (proj2 (Z.log2_lt_pow2 (Z.lor a b) 8 Hpos)).
    rewrite Z.log2_lor by lia. apply Z.max_lub_lt; assumption. }
  change (Z.lor a b < 256) in Hlt. lia.
Qed.

Lemma sem_same_div8_mod8_neq :
  forall x y index,
    0 <= x -> 0 <= y ->
    x / 8 = index -> y / 8 = index -> x <> y ->
    x mod 8 <> y mod 8.
Proof.
  intros x y index Hx Hy Hxdiv Hydiv Hneq Hmod.
  apply Hneq.
  pose proof (Z.div_mod x 8 ltac:(lia)) as Hxrepr.
  pose proof (Z.div_mod y 8 ltac:(lia)) as Hyrepr.
  lia.
Qed.

Lemma sem_testbit_one_neq0 :
  forall bit, bit <> 0 -> Z.testbit 1 bit = false.
Proof.
  intros bit Hneq.
  destruct (Z_lt_ge_dec bit 0) as [Hneg | Hnonneg].
  - apply Z.testbit_neg_r; lia.
  - assert (0 < bit) by lia.
    apply Z.bits_above_log2; [lia |].
    apply (proj1 (Z.log2_lt_pow2 1 bit ltac:(lia))).
    apply Zpow_facts.Zpower_gt_1; lia.
Qed.

Lemma sem_id_in_cons_eq :
  forall id ids, semaphore_id_in (id :: ids) id = true.
Proof.
  intros id ids. unfold semaphore_id_in.
  destruct (in_dec Z.eq_dec id (id :: ids)); [reflexivity |].
  exfalso. apply n. left. reflexivity.
Qed.

Lemma sem_id_in_cons_neq :
  forall query id ids,
    query <> id ->
    semaphore_id_in (id :: ids) query = semaphore_id_in ids query.
Proof.
  intros query id ids Hneq. unfold semaphore_id_in.
  destruct (in_dec Z.eq_dec query (id :: ids)) as [Hin_cons | Hnotin_cons];
    destruct (in_dec Z.eq_dec query ids) as [Hin | Hnotin]; auto.
  - destruct Hin_cons as [Heq | Hin']; [congruence | contradiction].
  - exfalso. apply Hnotin_cons. right. exact Hin.
Qed.

(** [AllocId] 对首个空闲 ID 置位后，更新的 byte list 精确表示
    [id :: ids]。该 lemma 只封装 QCP 生成的 byte/bit 运算，不改变模块抽象。 *)
Lemma semaphore_bitmap_ids_ok_add_local :
  forall stable ids bytes index id,
    stable.(semaphore_id_limit) = SEM_ID_MAX ->
    semaphore_bitmap_ids_ok stable ids bytes ->
    0 <= id < stable.(semaphore_id_limit) ->
    index = id / 8 ->
    semaphore_bitmap_ids_ok stable (id :: ids)
      (replace_Znth index
        (Z.lor (unsigned_last_nbits (Znth index bytes 0) 8)
          (unsigned_last_nbits (Z.shiftl 1 (Z.rem id 8)) 8)) bytes).
Proof.
  intros stable ids bytes index id Hlimit Hbitmap Hid Hindex.
  subst index.
  unfold semaphore_bitmap_ids_ok in Hbitmap |- *.
  destruct Hbitmap as [Hlength [Hbytes Hbits]].
  assert (Hid128 : 0 <= id < 128).
  { rewrite Hlimit in Hid. exact Hid. }
  assert (Hindex_range : 0 <= id / 8 < Zlength bytes).
  { rewrite Hlength, Hlimit. change (0 <= id / 8 < 16).
    split.
    - exact (Z.div_pos id 8 ltac:(lia) ltac:(lia)).
    - exact (Z.div_lt_upper_bound id 8 16 ltac:(lia) ltac:(lia)). }
  assert (Hold_range : 0 <= Znth (id / 8) bytes 0 <= 255).
  { eapply sem_Forall_Znth_Zlength; eauto. }
  assert (Hrem : 0 <= id mod 8 < 8) by
    (apply Z.mod_pos_bound; lia).
  assert (Hshift_range : 0 <= Z.shiftl 1 (id mod 8) < 256).
  { rewrite Z.shiftl_1_l.
    split; [apply Z.pow_nonneg; lia |].
    change (2 ^ (id mod 8) < 2 ^ 8).
    apply Z.pow_lt_mono_r; lia. }
  assert (Hnew_range :
      0 <= Z.lor (unsigned_last_nbits (Znth (id / 8) bytes 0) 8)
        (unsigned_last_nbits (Z.shiftl 1 (Z.rem id 8)) 8) <= 255).
  { apply sem_lor_byte_range.
    - pose proof (unsigned_Lastnbits_range (Znth (id / 8) bytes 0) 8
        ltac:(lia)). lia.
    - pose proof (unsigned_Lastnbits_range (Z.shiftl 1 (Z.rem id 8)) 8
        ltac:(lia)). lia. }
  split.
  - rewrite Zlength_replace_Znth. exact Hlength.
  - split.
    + apply sem_Forall_replace_Znth; assumption.
    + intros query Hquery.
      assert (Hquery_index : 0 <= query / 8 < Zlength bytes).
      { pose proof Hquery as Hquery128.
        rewrite Hlength, Hlimit. change (0 <= query / 8 < 16).
        rewrite Hlimit in Hquery128.
        unfold SEM_ID_MAX in Hquery128.
        split.
        - exact (Z.div_pos query 8 ltac:(lia) ltac:(lia)).
        - exact (Z.div_lt_upper_bound query 8 16 ltac:(lia) ltac:(lia)). }
      specialize (Hbits query Hquery).
      destruct (Z.eq_dec (query / 8) (id / 8)) as [Hsame | Hdiff].
      * rewrite Hsame.
        rewrite Hsame in Hbits.
        rewrite Znth_replace_Znth_Same by exact Hindex_range.
        rewrite Z.rem_mod_nonneg by lia.
        rewrite (unsigned_last_nbits_eq (Znth (id / 8) bytes 0) 8)
          by (change (0 <= Znth (id / 8) bytes 0 < 256); lia).
        rewrite (unsigned_last_nbits_eq (Z.shiftl 1 (id mod 8)) 8)
          by exact Hshift_range.
        rewrite Z.lor_spec.
        destruct (Z.eq_dec query id) as [-> | Hneq].
        -- rewrite Z.shiftl_spec by lia.
           replace (id mod 8 - id mod 8) with 0 by lia.
           cbn. rewrite Bool.orb_true_r. symmetry. apply sem_id_in_cons_eq.
        -- assert (Hmods : query mod 8 <> id mod 8).
           { eapply sem_same_div8_mod8_neq; eauto; lia. }
           rewrite Z.shiftl_spec by
             (pose proof (Z.mod_pos_bound query 8 ltac:(lia)); lia).
           rewrite sem_testbit_one_neq0 by lia.
           rewrite Bool.orb_false_r, Hbits. symmetry.
           apply sem_id_in_cons_neq. exact Hneq.
      * rewrite Znth_replace_Znth_Diff by (try exact Hindex_range;
          try exact Hquery_index; congruence).
        rewrite Hbits. symmetry. apply sem_id_in_cons_neq.
        intro Heq. subst query. apply Hdiff. reflexivity.
Qed.

(** 已证明 byte list 与 ID 集合一致时，把具体数组重新封装为 bitmap owner。 *)
Lemma store_semaphore_bitmap_ids_intro_local :
  forall stable ids bytes,
    semaphore_bitmap_ids_ok stable ids bytes ->
    UCharArray.full stable.(semaphore_bitmap_addr)
      ((stable.(semaphore_id_limit) + 7) / 8) bytes |--
    store_semaphore_bitmap_ids stable ids.
Proof.
  intros stable ids bytes Hbitmap.
  unfold store_semaphore_bitmap_ids.
  Exists bytes. entailer!.
Qed.

Lemma store_semaphore_bitmap_intro_local :
  forall stable state bytes,
    semaphore_bitmap_ok stable state bytes ->
    UCharArray.full stable.(semaphore_bitmap_addr)
      ((stable.(semaphore_id_limit) + 7) / 8) bytes |--
    store_semaphore_bitmap stable state.
Proof.
  intros stable state bytes Hbitmap.
  unfold store_semaphore_bitmap.
  Exists bytes. entailer!.
Qed.

Lemma store_semaphore_id_manager_from_parts_local :
  forall stable state manager,
    manager = stable.(semaphore_manager_addr) ->
    &(manager # "IdManager" ->ₛ "id_max") # UShort
      |-> stable.(semaphore_id_limit) **
    &(manager # "IdManager" ->ₛ "hoffset") # UShort
      |-> stable.(semaphore_bucket_count) **
    &(manager # "IdManager" ->ₛ "id_map") # Ptr
      |-> stable.(semaphore_bitmap_addr) **
    &(manager # "IdManager" ->ₛ "htable") # Ptr
      |-> stable.(semaphore_buckets_addr) **
    store_semaphore_bitmap stable state **
    store_semaphore_buckets stable state |--
    store_semaphore_id_manager stable state.
Proof.
  intros stable state manager Hmanager.
  subst manager. unfold store_semaphore_id_manager. entailer!.
Qed.

Lemma semaphore_objects_in_bucket_create_value_irrelevant_local :
  forall stable before sem id value index,
    semaphore_objects_in_bucket stable index
      (semaphore_create_state before sem id 0).(semaphore_objects) =
    semaphore_objects_in_bucket stable index
      (semaphore_create_state before sem id value).(semaphore_objects).
Proof.
  intros stable before sem id value index.
  unfold semaphore_create_state, semaphore_objects_in_bucket. simpl.
  destruct (Z.eq_dec
    (id mod semaphore_bucket_count stable) index); reflexivity.
Qed.

Lemma semaphore_buckets_match_from_ext_local :
  forall stable buckets start objects1 objects2,
    (forall index,
      semaphore_objects_in_bucket stable index objects1 =
      semaphore_objects_in_bucket stable index objects2) ->
    semaphore_buckets_match_from stable start buckets objects1 ->
    semaphore_buckets_match_from stable start buckets objects2.
Proof.
  intros stable buckets. induction buckets as [| bucket rest IH];
    intros start objects1 objects2 Hviews Hmatch; simpl in *.
  - exact I.
  - destruct Hmatch as [Hhead Htail]. split.
    + destruct bucket as [bucket_objects |];
        rewrite <- (Hviews start); exact Hhead.
    + eapply IH; eauto.
Qed.

(** ID manager 只拥有对象的 ID node 与 bitmap membership；同一 reserved
    object 在 publish 时写入 value，不改变这部分 ownership。 *)
Lemma store_semaphore_id_manager_reserve_create_local :
  forall stable before sem id value,
    store_semaphore_id_manager stable
      (semaphore_reserve_state before sem id) |--
    store_semaphore_id_manager stable
      (semaphore_create_state before sem id value).
Proof.
  intros stable before sem id value.
  unfold store_semaphore_id_manager, semaphore_reserve_state,
    semaphore_create_state. simpl.
  entailer!.
  unfold store_semaphore_bitmap, semaphore_bitmap_ok,
    store_semaphore_buckets, semaphore_buckets_ok.
  Intros bytes buckets. Exists bytes buckets. simpl in *. entailer!.
  eapply semaphore_buckets_match_from_ext_local.
  - intros index.
    apply semaphore_objects_in_bucket_create_value_irrelevant_local.
  - exact (proj2 H0).
Qed.

(** 成功路径把已更新 bitmap 与未变 manager 字段、bucket frame 重新封装。 *)
Lemma store_sem_manager_id_allocated_from_parts_local :
  forall stable before id manager,
    manager = stable.(semaphore_manager_addr) ->
    semaphore_first_free stable before = Some id ->
    store_semaphore_bitmap_ids stable
      (id :: semaphore_ids before.(semaphore_objects)) **
    &(manager # "IdManager" ->ₛ "id_max") # UShort
      |-> stable.(semaphore_id_limit) **
    &(manager # "IdManager" ->ₛ "hoffset") # UShort
      |-> stable.(semaphore_bucket_count) **
    &(manager # "IdManager" ->ₛ "id_map") # Ptr
      |-> stable.(semaphore_bitmap_addr) **
    &(manager # "IdManager" ->ₛ "htable") # Ptr
      |-> stable.(semaphore_buckets_addr) **
    store_semaphore_buckets stable before |--
    store_sem_manager_id_allocated stable before id.
Proof.
  intros stable before id manager Hmanager Hfirst.
  subst manager. unfold store_sem_manager_id_allocated. entailer!.
Qed.
