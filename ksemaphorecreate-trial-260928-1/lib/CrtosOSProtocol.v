Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Relations.Relation_Operators.
Require Import Coq.Program.Equality.
Require Import Coq.micromega.Lia.
Require Import SetsClass.SetsClass.
Import SetsNotation.

From SimpleC.SL Require Import Mem SeparationLogic ConAssertion.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.libai.TaskProtocolSTS.
Require Import CRTOS_Verify.sem.CrtosOSPure.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope sets.

(**
  每层真实 CriticalAreaLock 对应一个 depth token；Task create reservation 沿用
  现有 [KTaskReservation] 身份。两类线性权限位于同一个 STS carrier。
*)
Inductive CrtosOSToken : Type :=
  | COT_DEPTH (depth : nat)
  | COT_TASK_OWNER (owner : KTaskReservation).

Definition CrtosOSTokenSet : Type := CrtosOSToken -> Prop.
Definition crtos_os_no_tokens : CrtosOSTokenSet := fun _ => False.

Definition crtos_os_token_union
    (left right : CrtosOSTokenSet) : CrtosOSTokenSet :=
  fun token => left token \/ right token.

Definition crtos_os_token_disjoint
    (left right : CrtosOSTokenSet) : Prop :=
  forall token, left token -> ~ right token.

Definition crtos_os_token_equiv
    (left right : CrtosOSTokenSet) : Prop :=
  forall token, left token <-> right token.

Definition crtos_os_depth_token (depth : nat) : CrtosOSTokenSet :=
  fun token => token = COT_DEPTH depth.

Definition crtos_os_depth_tokens (count : nat) : CrtosOSTokenSet :=
  fun token =>
    match token with
    | COT_DEPTH depth => (depth < count)%nat
    | COT_TASK_OWNER _ => False
    end.

Definition crtos_os_owner_token
    (owner : KTaskReservation) : CrtosOSTokenSet :=
  fun token => token = COT_TASK_OWNER owner.

Definition crtos_os_depth_and_owner_token
    (depth : nat) (owner : KTaskReservation) : CrtosOSTokenSet :=
  crtos_os_token_union (crtos_os_depth_token depth)
    (crtos_os_owner_token owner).

Definition crtos_os_depth_and_owner_tokens
    (count : nat) (owner : KTaskReservation) : CrtosOSTokenSet :=
  crtos_os_token_union (crtos_os_depth_tokens count)
    (crtos_os_owner_token owner).

(** STS state 同时保存 IRQ handler 栈、稳定配置和统一 OS world。 *)
Record CrtosOSProtocolState : Type := Build_CrtosOSProtocolState {
  crtos_os_handlers : list Z;
  crtos_os_protocol_stable : CrtosOSStable;
  crtos_os_protocol_world : CrtosOSWorld
}.

(** invariant 持有尚未进入的 depth token，以及尚未 active 的 owner token。 *)
Definition crtos_os_invowned_token
    (state : CrtosOSProtocolState) (token : CrtosOSToken) : Prop :=
  match token with
  | COT_DEPTH depth => (depth >= List.length state.(crtos_os_handlers))%nat
  | COT_TASK_OWNER owner =>
      ~ task_reservation_active owner
          state.(crtos_os_protocol_world).(crtos_task_state)
  end.

Definition crtos_os_world_transition
    (stable_before stable_after : CrtosOSStable)
    (before after : CrtosOSWorld) : Prop :=
  stable_before = stable_after /\
  CrtosOSGTrans stable_before before after.

(**
  只有六类 core 动作能够改变协议：enter、普通 exit，以及 Task create 的
  publish/rollback/finalize outer exit。任意无关 token frame 在下一层统一处理。
*)
Inductive crtos_os_protocol_action :
    CrtosOSProtocolState -> CrtosOSTokenSet ->
    CrtosOSProtocolState -> CrtosOSTokenSet -> Prop :=
  | COT_ENTER : forall handler handlers stable world,
      crtos_os_protocol_action
        (Build_CrtosOSProtocolState handlers stable world)
        crtos_os_no_tokens
        (Build_CrtosOSProtocolState (handler :: handlers) stable world)
        (crtos_os_depth_token (List.length handlers))
  | COT_EXIT : forall handler handlers stable_before stable_after before after,
      crtos_os_world_transition stable_before stable_after before after ->
      crtos_os_protocol_action
        (Build_CrtosOSProtocolState
          (handler :: handlers) stable_before before)
        (crtos_os_depth_token (List.length handlers))
        (Build_CrtosOSProtocolState handlers stable_after after)
        crtos_os_no_tokens
  | COT_PUBLISH_EXIT : forall handler owner stable before after,
      tmp_task_publish owner
        before.(crtos_task_state) after.(crtos_task_state) ->
      before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_os_protocol_action
        (Build_CrtosOSProtocolState (handler :: nil) stable before)
        (crtos_os_depth_token 0%nat)
        (Build_CrtosOSProtocolState nil stable after)
        (crtos_os_owner_token owner)
  | COT_ROLLBACK_EXIT : forall handler owner stable before after,
      tmp_task_rollback owner
        before.(crtos_task_state) after.(crtos_task_state) ->
      before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_os_protocol_action
        (Build_CrtosOSProtocolState (handler :: nil) stable before)
        (crtos_os_depth_and_owner_token 0%nat owner)
        (Build_CrtosOSProtocolState nil stable after)
        crtos_os_no_tokens
  | COT_FINALIZE_EXIT : forall handler owner desc stable before after,
      tmp_task_finalize owner desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_os_protocol_action
        (Build_CrtosOSProtocolState (handler :: nil) stable before)
        (crtos_os_depth_and_owner_token 0%nat owner)
        (Build_CrtosOSProtocolState nil stable after)
        crtos_os_no_tokens.

(**
  Core action 只有在两端 token 与 invariant 互斥、且 local+invariant 总权限
  完全守恒时才是合法 core transition。这些是可构造的 proof obligations，
  不是公理；下面三项 QCP meta-properties 由它们机器推出。
*)
Definition crtos_os_core_transition
    (source : CrtosOSProtocolState) (source_tokens : CrtosOSTokenSet)
    (target : CrtosOSProtocolState) (target_tokens : CrtosOSTokenSet) : Prop :=
  crtos_os_protocol_action source source_tokens target target_tokens /\
  crtos_os_token_disjoint source_tokens (crtos_os_invowned_token source) /\
  crtos_os_token_disjoint target_tokens (crtos_os_invowned_token target) /\
  forall token,
    (source_tokens token \/ crtos_os_invowned_token source token) <->
    (target_tokens token \/ crtos_os_invowned_token target token).

(** frame closure 显式排除 core/invariant token 冲突，并保持 frame 不变。 *)
Definition crtos_os_protocol_transition
    (source target : CrtosOSProtocolState * CrtosOSTokenSet) : Prop :=
  exists source_core target_core frame,
    crtos_os_core_transition
      (fst source) source_core (fst target) target_core /\
    crtos_os_token_disjoint source_core frame /\
    crtos_os_token_disjoint target_core frame /\
    crtos_os_token_disjoint
      (crtos_os_invowned_token (fst source)) frame /\
    crtos_os_token_disjoint
      (crtos_os_invowned_token (fst target)) frame /\
    crtos_os_token_equiv
      (snd source) (crtos_os_token_union source_core frame) /\
    crtos_os_token_equiv
      (snd target) (crtos_os_token_union target_core frame).

Definition crtos_os_sts : ConAssertion.STS :=
  {| ConAssertion.token := CrtosOSToken;
     ConAssertion.STS_state := CrtosOSProtocolState;
     ConAssertion.Transition := crtos_os_protocol_transition;
     ConAssertion.InvownedToken := crtos_os_invowned_token |}.

Lemma crtos_os_core_disjoint :
  forall source source_tokens target target_tokens,
    crtos_os_core_transition source source_tokens target target_tokens ->
    crtos_os_token_disjoint source_tokens (crtos_os_invowned_token source) /\
    crtos_os_token_disjoint target_tokens (crtos_os_invowned_token target).
Proof.
  intros source source_tokens target target_tokens [_ [Hs [Ht _]]].
  exact (conj Hs Ht).
Qed.

Lemma crtos_os_core_tokens_preserved :
  forall source source_tokens target target_tokens token,
    crtos_os_core_transition source source_tokens target target_tokens ->
    (source_tokens token \/ crtos_os_invowned_token source token) <->
    (target_tokens token \/ crtos_os_invowned_token target token).
Proof.
  intros source source_tokens target target_tokens token [_ [_ [_ Htotal]]].
  apply Htotal.
Qed.

(** 普通 enter core 可构造：depth n 从 invariant 精确转交给当前线程。 *)
Lemma crtos_os_enter_core :
  forall handler handlers stable world,
    crtos_os_core_transition
      (Build_CrtosOSProtocolState handlers stable world)
      crtos_os_no_tokens
      (Build_CrtosOSProtocolState (handler :: handlers) stable world)
      (crtos_os_depth_token (List.length handlers)).
Proof.
  intros. unfold crtos_os_core_transition.
  refine (conj _ (conj _ (conj _ _))).
  - constructor.
  - intros token Hnone. contradiction.
  - intros token Hdepth Hinv.
    unfold crtos_os_depth_token in Hdepth. subst token. cbn in Hinv. lia.
  - intros [depth | owner]; cbn; split; intros H.
    + destruct H as [Hnone | Hge]; [contradiction |].
      destruct (Nat.eq_dec depth (List.length handlers)) as [-> | Hneq].
      * left. reflexivity.
      * right. lia.
    + destruct H as [Heq | Hge].
      * inversion Heq. right. lia.
      * right. lia.
    + destruct H as [Hnone | Hinactive]; [contradiction |].
      right. exact Hinactive.
    + destruct H as [Hdepth | Hinactive]; [discriminate |].
      right. exact Hinactive.
Qed.

(** 普通 exit core 可构造：depth n 归还 invariant，world 按真实 GTrans 提交。 *)
Lemma crtos_os_exit_core :
  forall handler handlers stable before after,
    CrtosOSGTrans stable before after ->
    crtos_os_core_transition
      (Build_CrtosOSProtocolState (handler :: handlers) stable before)
      (crtos_os_depth_token (List.length handlers))
      (Build_CrtosOSProtocolState handlers stable after)
      crtos_os_no_tokens.
Proof.
  intros handler handlers stable before after Hworld.
  unfold crtos_os_core_transition.
  pose proof (CrtosOSGTrans_reservations_stable
    stable before after Hworld) as Hreservations.
  refine (conj _ (conj _ (conj _ _))).
  - apply COT_EXIT. split; [reflexivity | exact Hworld].
  - intros token Hdepth Hinv.
    unfold crtos_os_depth_token in Hdepth. subst token. cbn in Hinv. lia.
  - intros token Hnone. contradiction.
  - intros [depth | owner]; cbn; split; intros H.
    + destruct H as [Heq | Hge].
      * inversion Heq. right. lia.
      * right. lia.
    + destruct H as [Hnone | Hge]; [contradiction |].
      destruct (Nat.eq_dec depth (List.length handlers)) as [-> | Hneq].
      * left. reflexivity.
      * right. lia.
    + destruct H as [Hnone | Hinactive]; [discriminate |].
      right. intro Hafter.
      apply Hinactive. apply (proj2 (Hreservations owner)). exact Hafter.
    + destruct H as [Hnone | Hinactive]; [contradiction |].
      right. intro Hbefore.
      apply Hinactive. apply (proj1 (Hreservations owner)). exact Hbefore.
Qed.

(** publish outer-exit 同时归还 depth 0 并把唯一 owner token 交给 creator。 *)
Lemma crtos_os_publish_core :
  forall handler owner stable before after,
    tmp_task_publish owner
      before.(crtos_task_state) after.(crtos_task_state) ->
    before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
    before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
    crtos_os_core_transition
      (Build_CrtosOSProtocolState (handler :: nil) stable before)
      (crtos_os_depth_token 0%nat)
      (Build_CrtosOSProtocolState nil stable after)
      (crtos_os_owner_token owner).
Proof.
  intros handler owner stable before after Hpublish Hscheduler Hsemaphore.
  destruct Hpublish as [Hbefore [Hafter Hother]].
  unfold crtos_os_core_transition.
  refine (conj _ (conj _ (conj _ _))).
  - apply COT_PUBLISH_EXIT.
    + exact (conj Hbefore (conj Hafter Hother)).
    + exact Hscheduler.
    + exact Hsemaphore.
  - intros token Hdepth Hinv.
    unfold crtos_os_depth_token in Hdepth. subst token. cbn in Hinv. lia.
  - intros token Howner Hinv.
    unfold crtos_os_owner_token in Howner. subst token. cbn in Hinv.
    contradiction.
  - intros [depth | reservation]; cbn; split; intros H.
    + destruct H as [Heq | Hge].
      * inversion Heq. right. lia.
      * right. lia.
    + destruct H as [Howner_token | Hge].
      * discriminate.
      * destruct (Nat.eq_dec depth 0%nat) as [-> | Hneq].
        -- left. reflexivity.
        -- right. lia.
    + destruct (ktask_reservation_eq_dec reservation owner) as [-> | Hneq].
      * left. reflexivity.
      * right. intro Hactive_after.
        destruct H as [Hdepth | Hinactive_before]; [discriminate |].
        apply Hinactive_before.
        apply (proj2 (Hother reservation Hneq)). exact Hactive_after.
    + destruct (ktask_reservation_eq_dec reservation owner) as [-> | Hneq].
      * right. exact Hbefore.
      * destruct H as [Howner_token | Hinactive_after].
        -- exfalso. apply Hneq. inversion Howner_token. reflexivity.
        -- right. intro Hactive_before.
           apply Hinactive_after.
           apply (proj1 (Hother reservation Hneq)). exact Hactive_before.
Qed.

(** rollback/finalize 共用的 owner-return token 证明。 *)
Lemma crtos_os_owner_return_core :
  forall handler owner stable before after,
    crtos_os_protocol_action
      (Build_CrtosOSProtocolState (handler :: nil) stable before)
      (crtos_os_depth_and_owner_token 0%nat owner)
      (Build_CrtosOSProtocolState nil stable after)
      crtos_os_no_tokens ->
    task_reservation_active owner before.(crtos_task_state) ->
    ~ task_reservation_active owner after.(crtos_task_state) ->
    other_reservations_stable owner
      before.(crtos_task_state) after.(crtos_task_state) ->
    crtos_os_core_transition
      (Build_CrtosOSProtocolState (handler :: nil) stable before)
      (crtos_os_depth_and_owner_token 0%nat owner)
      (Build_CrtosOSProtocolState nil stable after)
      crtos_os_no_tokens.
Proof.
  intros handler owner stable before after Haction Hbefore Hafter Hother.
  unfold crtos_os_core_transition.
  refine (conj Haction (conj _ (conj _ _))).
  - intros token [Hdepth | Howner] Hinv.
    + unfold crtos_os_depth_token in Hdepth. subst token. cbn in Hinv. lia.
    + unfold crtos_os_owner_token in Howner. subst token. cbn in Hinv.
      contradiction.
  - intros token Hnone. contradiction.
  - intros [depth | reservation]; cbn; split; intros H.
    + destruct H as [[Heq | Howner] | Hge].
      * inversion Heq. right. lia.
      * discriminate.
      * right. lia.
    + destruct H as [Hnone | Hge]; [contradiction |].
      destruct (Nat.eq_dec depth 0%nat) as [-> | Hneq].
      * left. left. reflexivity.
      * right. lia.
    + destruct (ktask_reservation_eq_dec reservation owner) as [-> | Hneq].
      * right. exact Hafter.
      * destruct H as [[Hdepth | Howner_token] | Hinactive_before].
        -- discriminate.
        -- exfalso. apply Hneq. inversion Howner_token. reflexivity.
        -- right. intro Hactive_after.
           apply Hinactive_before.
           apply (proj2 (Hother reservation Hneq)). exact Hactive_after.
    + destruct (ktask_reservation_eq_dec reservation owner) as [-> | Hneq].
      * left. right. reflexivity.
      * destruct H as [Hnone | Hinactive_after]; [contradiction |].
        right. intro Hactive_before.
        apply Hinactive_after.
        apply (proj1 (Hother reservation Hneq)). exact Hactive_before.
Qed.

Lemma crtos_os_rollback_core :
  forall handler owner stable before after,
    tmp_task_rollback owner
      before.(crtos_task_state) after.(crtos_task_state) ->
    before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
    before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
    crtos_os_core_transition
      (Build_CrtosOSProtocolState (handler :: nil) stable before)
      (crtos_os_depth_and_owner_token 0%nat owner)
      (Build_CrtosOSProtocolState nil stable after)
      crtos_os_no_tokens.
Proof.
  intros handler owner stable before after Hrollback Hscheduler Hsemaphore.
  destruct Hrollback as [Hbefore [Hafter Hother]].
  eapply crtos_os_owner_return_core; eauto.
  apply COT_ROLLBACK_EXIT; auto.
  exact (conj Hbefore (conj Hafter Hother)).
Qed.

Lemma crtos_os_finalize_core :
  forall handler owner desc stable before after,
    tmp_task_finalize owner desc
      before.(crtos_task_state) after.(crtos_task_state) ->
    before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
    before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
    crtos_os_core_transition
      (Build_CrtosOSProtocolState (handler :: nil) stable before)
      (crtos_os_depth_and_owner_token 0%nat owner)
      (Build_CrtosOSProtocolState nil stable after)
      crtos_os_no_tokens.
Proof.
  intros handler owner desc stable before after Hfinalize Hscheduler Hsemaphore.
  destruct Hfinalize as [Hbefore [Hpublication [Hafter Hother]]].
  eapply crtos_os_owner_return_core; eauto.
  apply (COT_FINALIZE_EXIT handler owner desc stable before after).
  - exact (conj Hbefore (conj Hpublication (conj Hafter Hother))).
  - exact Hscheduler.
  - exact Hsemaphore.
Qed.

(** QCP meta-property 1：任意 framed transition 两端都保持 local/invariant 互斥。 *)
Theorem crtos_os_transition_disjoint_preserved :
  @ConAssertion.transtion_disjoint_preserved crtos_os_sts
    crtos_os_protocol_transition.
Proof.
  intros source target source_tokens target_tokens Hstep.
  destruct Hstep as
      (source_core & target_core & frame & Hcore & Hsource_core &
       Htarget_core & Hsource_inv & Htarget_inv & Hsource & Htarget).
  pose proof (crtos_os_core_disjoint _ _ _ _ Hcore) as [Hcs Hct].
  split; sets_unfold; intro token; split; intros Hpair; try contradiction.
  - destruct Hpair as [Hlocal Hinv].
    apply Hsource in Hlocal. destruct Hlocal as [Hlocal | Hlocal].
    + exact (Hcs token Hlocal Hinv).
    + exact (Hsource_inv token Hinv Hlocal).
  - destruct Hpair as [Hlocal Hinv].
    apply Htarget in Hlocal. destruct Hlocal as [Hlocal | Hlocal].
    + exact (Hct token Hlocal Hinv).
    + exact (Htarget_inv token Hinv Hlocal).
Qed.

(** QCP meta-property 2：local 与 invariant token 的总集合在 transition 前后相同。 *)
Theorem crtos_os_transition_token_preserved :
  @ConAssertion.transition_token_preserved crtos_os_sts
    crtos_os_protocol_transition.
Proof.
  intros source target source_tokens target_tokens total Hstep.
  pose proof Hstep as Hdisjoint_step.
  apply crtos_os_transition_disjoint_preserved in Hdisjoint_step.
  destruct Hdisjoint_step as [Hsource_disjoint Htarget_disjoint].
  destruct Hstep as
      (source_core & target_core & frame & Hcore & _ & _ & _ & _ &
       Hsource & Htarget).
  split; intros [Htotal Hdisjoint]; split.
  - sets_unfold in Htotal. sets_unfold. intro token.
    specialize (Htotal token); specialize (Hsource token);
      specialize (Htarget token).
    pose proof (crtos_os_core_tokens_preserved
      _ _ _ _ token Hcore) as Hcore_total.
    split; intro Htoken.
    + destruct (proj1 Htotal Htoken) as [Hlocal | Hinv].
      * destruct (proj1 Hsource Hlocal) as [Hlocal_core | Hframe].
        -- destruct (proj1 Hcore_total (or_introl Hlocal_core)) as
             [Htarget_core | Htarget_inv].
           ++ left. apply (proj2 Htarget). left. exact Htarget_core.
           ++ right. exact Htarget_inv.
        -- left. apply (proj2 Htarget). right. exact Hframe.
      * destruct (proj1 Hcore_total (or_intror Hinv)) as
           [Htarget_core | Htarget_inv].
        -- left. apply (proj2 Htarget). left. exact Htarget_core.
        -- right. exact Htarget_inv.
    + apply (proj2 Htotal).
      destruct Htoken as [Hlocal | Hinv].
      * destruct (proj1 Htarget Hlocal) as [Hlocal_core | Hframe].
        -- destruct (proj2 Hcore_total (or_introl Hlocal_core)) as
             [Hsource_core | Hsource_inv].
           ++ left. apply (proj2 Hsource). left. exact Hsource_core.
           ++ right. exact Hsource_inv.
        -- left. apply (proj2 Hsource). right. exact Hframe.
      * destruct (proj2 Hcore_total (or_intror Hinv)) as
           [Hsource_core | Hsource_inv].
        -- left. apply (proj2 Hsource). left. exact Hsource_core.
        -- right. exact Hsource_inv.
  - exact Htarget_disjoint.
  - sets_unfold in Htotal. sets_unfold. intro token.
    specialize (Htotal token); specialize (Hsource token);
      specialize (Htarget token).
    pose proof (crtos_os_core_tokens_preserved
      _ _ _ _ token Hcore) as Hcore_total.
    split; intro Htoken.
    + destruct (proj1 Htotal Htoken) as [Hlocal | Hinv].
      * destruct (proj1 Htarget Hlocal) as [Hlocal_core | Hframe].
        -- destruct (proj2 Hcore_total (or_introl Hlocal_core)) as
             [Hsource_core | Hsource_inv].
           ++ left. apply (proj2 Hsource). left. exact Hsource_core.
           ++ right. exact Hsource_inv.
        -- left. apply (proj2 Hsource). right. exact Hframe.
      * destruct (proj2 Hcore_total (or_intror Hinv)) as
           [Hsource_core | Hsource_inv].
        -- left. apply (proj2 Hsource). left. exact Hsource_core.
        -- right. exact Hsource_inv.
    + apply (proj2 Htotal).
      destruct Htoken as [Hlocal | Hinv].
      * destruct (proj1 Hsource Hlocal) as [Hlocal_core | Hframe].
        -- destruct (proj1 Hcore_total (or_introl Hlocal_core)) as
             [Htarget_core | Htarget_inv].
           ++ left. apply (proj2 Htarget). left. exact Htarget_core.
           ++ right. exact Htarget_inv.
        -- left. apply (proj2 Htarget). right. exact Hframe.
      * destruct (proj1 Hcore_total (or_intror Hinv)) as
           [Htarget_core | Htarget_inv].
        -- left. apply (proj2 Htarget). left. exact Htarget_core.
        -- right. exact Htarget_inv.
  - exact Hsource_disjoint.
Qed.

(** QCP meta-property 3：任意与 core/invariant 不冲突的额外 token frame 可穿过。 *)
Theorem crtos_os_closed_transition :
  @ConAssertion.Closed_transition crtos_os_sts
    crtos_os_protocol_transition.
Proof.
  intros source target source_tokens target_tokens extra Hstep
    Hsource_extra Hextra_source_inv.
  assert (Hsource_extra_disjoint :
      crtos_os_token_disjoint source_tokens extra).
  { intros token Hsource_token Hextra_token.
    sets_unfold in Hsource_extra. specialize (Hsource_extra token).
    exact (proj1 Hsource_extra (conj Hsource_token Hextra_token)). }
  assert (Hextra_source_inv_disjoint :
      crtos_os_token_disjoint extra (crtos_os_invowned_token source)).
  { intros token Hextra_token Hinv_token.
    sets_unfold in Hextra_source_inv. specialize (Hextra_source_inv token).
    exact (proj1 Hextra_source_inv (conj Hextra_token Hinv_token)). }
  destruct Hstep as
      (source_core & target_core & frame & Hcore & Hsource_core_frame &
       Htarget_core_frame & Hsource_inv_frame & Htarget_inv_frame &
       Hsource & Htarget).
  exists source_core, target_core, (crtos_os_token_union frame extra).
  refine (conj Hcore _).
  repeat split.
  - intros token Htoken [Hframe | Hextra].
    + exact (Hsource_core_frame token Htoken Hframe).
    + apply (Hsource_extra_disjoint token).
      * apply Hsource. left. exact Htoken.
      * exact Hextra.
  - intros token Htoken [Hframe | Hextra].
    + exact (Htarget_core_frame token Htoken Hframe).
    + pose proof (crtos_os_core_tokens_preserved
        _ _ _ _ token Hcore) as Hcore_total.
      destruct (proj2 Hcore_total (or_introl Htoken)) as
          [Hsource_core | Hsource_inv].
      * apply (Hsource_extra_disjoint token).
        -- apply Hsource. left. exact Hsource_core.
        -- exact Hextra.
      * exact (Hextra_source_inv_disjoint token Hextra Hsource_inv).
  - intros token Hinv [Hframe | Hextra].
    + exact (Hsource_inv_frame token Hinv Hframe).
    + exact (Hextra_source_inv_disjoint token Hextra Hinv).
  - intros token Hinv [Hframe | Hextra].
    + exact (Htarget_inv_frame token Hinv Hframe).
    + pose proof (crtos_os_core_tokens_preserved
        _ _ _ _ token Hcore) as Hcore_total.
      destruct (proj2 Hcore_total (or_intror Hinv)) as
          [Hsource_core | Hsource_inv].
      * apply (Hsource_extra_disjoint token).
        -- apply Hsource. left. exact Hsource_core.
        -- exact Hextra.
      * exact (Hextra_source_inv_disjoint token Hextra Hsource_inv).
  - specialize (Hsource token). unfold crtos_os_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal | Hextra].
    + destruct (proj1 Hsource Hlocal) as [Hcore_token | Hframe].
      * left. exact Hcore_token.
      * right. left. exact Hframe.
    + right. right. exact Hextra.
  - specialize (Hsource token). unfold crtos_os_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal_core | [Hframe | Hextra]].
    + left. apply Hsource. left. exact Hlocal_core.
    + left. apply Hsource. right. exact Hframe.
    + right. exact Hextra.
  - specialize (Htarget token). unfold crtos_os_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal | Hextra].
    + destruct (proj1 Htarget Hlocal) as [Hcore_token | Hframe].
      * left. exact Hcore_token.
      * right. left. exact Hframe.
    + right. right. exact Hextra.
  - specialize (Htarget token). unfold crtos_os_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal_core | [Hframe | Hextra]].
    + left. apply Htarget. left. exact Hlocal_core.
    + left. apply Htarget. right. exact Hframe.
    + right. exact Hextra.
Qed.

Theorem crtos_os_protocol_meta_properties :
  @ConAssertion.transtion_disjoint_preserved crtos_os_sts
      crtos_os_protocol_transition /\
  @ConAssertion.transition_token_preserved crtos_os_sts
      crtos_os_protocol_transition /\
  @ConAssertion.Closed_transition crtos_os_sts
      crtos_os_protocol_transition.
Proof.
  exact (conj crtos_os_transition_disjoint_preserved
    (conj crtos_os_transition_token_preserved crtos_os_closed_transition)).
Qed.

(** 当前线程 held tokens 固定时，environment 使用其与 invariant 的补集。 *)
Definition crtos_os_environment_tokens
    (held : CrtosOSTokenSet) (state : CrtosOSProtocolState) : CrtosOSTokenSet :=
  fun token => ~ held token /\ ~ crtos_os_invowned_token state token.

Definition crtos_os_environment_step
    (held : CrtosOSTokenSet)
    (before after : CrtosOSProtocolState) : Prop :=
  crtos_os_protocol_transition
    (before, crtos_os_environment_tokens held before)
    (after, crtos_os_environment_tokens held after).

(** owner token 被当前线程保留时，任何真实 environment step 都不能解除它。 *)
Lemma crtos_os_environment_step_preserves_owner :
  forall owner before after,
    task_reservation_active owner
      before.(crtos_os_protocol_world).(crtos_task_state) ->
    crtos_os_environment_step (crtos_os_owner_token owner) before after ->
    task_reservation_active owner
      after.(crtos_os_protocol_world).(crtos_task_state).
Proof.
  intros owner before after Hactive Hstep.
  unfold crtos_os_environment_step, crtos_os_protocol_transition in Hstep.
  destruct Hstep as
      (source_core & target_core & frame & Hcore & _ & _ & _ & _ &
       Hsource & _).
  destruct Hcore as [Haction _].
  dependent destruction Haction.
  all: cbn in x0, x; subst before; subst after.
  - exact Hactive.
  - destruct H as [Hstable Hworld]. subst stable_after.
    pose proof (CrtosOSGTrans_reservations_stable _ _ _ Hworld owner) as Hkeep.
    apply (proj1 Hkeep). exact Hactive.
  - destruct H as [Hinactive [Hafter Hother]].
    destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. contradiction.
    + apply (proj1 (Hother owner Hneq)). exact Hactive.
  - destruct H as [Hbefore [Hafter Hother]].
    destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. exfalso.
      assert (Hcore_owner :
        crtos_os_depth_and_owner_token 0%nat owner
          (COT_TASK_OWNER owner)).
      { right. reflexivity. }
      pose proof (proj2 (Hsource (COT_TASK_OWNER owner))
        (or_introl Hcore_owner)) as Henv_owner.
      exact ((proj1 Henv_owner) eq_refl).
    + apply (proj1 (Hother owner Hneq)). exact Hactive.
  - destruct H as [Hbefore [Hpublication [Hafter Hother]]].
    destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. exfalso.
      assert (Hcore_owner :
        crtos_os_depth_and_owner_token 0%nat owner
          (COT_TASK_OWNER owner)).
      { right. reflexivity. }
      pose proof (proj2 (Hsource (COT_TASK_OWNER owner))
        (or_introl Hcore_owner)) as Henv_owner.
      exact ((proj1 Henv_owner) eq_refl).
    + apply (proj1 (Hother owner Hneq)). exact Hactive.
Qed.

Definition CrtosOSProtocolRReachable
    (held : CrtosOSTokenSet)
    (before after : CrtosOSProtocolState) : Prop :=
  @Relation_Operators.clos_refl_trans CrtosOSProtocolState
    (crtos_os_environment_step held) before after.

(** owner-held 的多步 environment reachability 同样保持 reservation active。 *)
Lemma crtos_os_owner_reachable_preserves :
  forall owner before after,
    task_reservation_active owner
      before.(crtos_os_protocol_world).(crtos_task_state) ->
    CrtosOSProtocolRReachable (crtos_os_owner_token owner) before after ->
    task_reservation_active owner
      after.(crtos_os_protocol_world).(crtos_task_state).
Proof.
  intros owner before after Hactive Hreachable.
  induction Hreachable.
  - eapply crtos_os_environment_step_preserves_owner; eauto.
  - exact Hactive.
  - apply IHHreachable2. apply IHHreachable1. exact Hactive.
Qed.

Module CrtosOSSTS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS := crtos_os_sts.
End CrtosOSSTS.

(** Task、scheduler、delay 与 semaphore predicate 唯一共享的 assertion carrier。 *)
Module CrtosOS_C_Rules.
  Include CrtosOSSTS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
  Include MapLibSig.
  Include StringLibSig.
End CrtosOS_C_Rules.

Export CrtosOS_C_Rules.
Local Open Scope sac.

(** 精确绑定一个 STS state set 与当前线程 token set 的不可拆分 protocol view。 *)
Definition CrtosOSProtocolView
    (states : CrtosOSProtocolState -> Prop)
    (held : CrtosOSTokenSet) : Assertion :=
  fun low_state =>
    low_state.(ConAssertion.s_mem) = empty_mem /\
    states == low_state.(ConAssertion.s_STS) /\
    held == low_state.(ConAssertion.s_token).

(** 空 handler 栈是公开 API 的临界区外 view，状态集合按真实 STS environment 闭包。 *)
Definition CrtosOSOutsideCritical
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  let start := Build_CrtosOSProtocolState nil stable world in
  CrtosOSProtocolView
    (fun current =>
      CrtosOSProtocolRReachable crtos_os_no_tokens start current)
    crtos_os_no_tokens.

(** 非空 handler 栈精确描述当前线程持有的全部 nested depth tokens。 *)
Definition CrtosOSInsideCritical
    (handlers : list Z)
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  “ handlers <> nil ” &&
  CrtosOSProtocolView
    (Sets.singleton (Build_CrtosOSProtocolState handlers stable world))
    (crtos_os_depth_tokens (List.length handlers)).

(** publish 后的 creator 在 Outside 持唯一 owner token；reachable state 仍须 active。 *)
Definition CrtosOSOutsideCriticalOwner
    (owner : KTaskReservation)
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  let start := Build_CrtosOSProtocolState nil stable world in
  “ task_reservation_active owner world.(crtos_task_state) ” &&
  CrtosOSProtocolView
    (fun current =>
      CrtosOSProtocolRReachable (crtos_os_owner_token owner) start current /\
      task_reservation_active owner
        current.(crtos_os_protocol_world).(crtos_task_state))
    (crtos_os_owner_token owner).

(** 第二次进入后同时持有全部 nested depth token 与相同 owner token。 *)
Definition CrtosOSInsideCriticalOwner
    (owner : KTaskReservation) (handlers : list Z)
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  “ handlers <> nil /\
    task_reservation_active owner world.(crtos_task_state) ” &&
  CrtosOSProtocolView
    (Sets.singleton (Build_CrtosOSProtocolState handlers stable world))
    (crtos_os_depth_and_owner_tokens (List.length handlers) owner).

(**
  公开 API 的 rely 是真实 STS environment 从 Outside 到 Outside 的投影，
  因而包含其他线程的 Task owner publish/rollback/finalize；guarantee 是当前
  线程持锁时提交的普通 OS world 动作闭包。
*)
Definition CrtosOSRely
    (stable : CrtosOSStable) (before current : CrtosOSWorld) : Prop :=
  CrtosOSProtocolRReachable crtos_os_no_tokens
    (Build_CrtosOSProtocolState nil stable before)
    (Build_CrtosOSProtocolState nil stable current).

Definition CrtosOSGuarantee
    (stable : CrtosOSStable) (before after : CrtosOSWorld) : Prop :=
  CrtosOSGTrans stable before after.

Lemma CrtosOSRely_refl :
  forall stable world, CrtosOSRely stable world world.
Proof. intros. apply Relation_Operators.rt_refl. Qed.

Lemma CrtosOSGuarantee_refl :
  forall stable world, CrtosOSGuarantee stable world world.
Proof. intros. apply CrtosOSGTrans_refl. Qed.
