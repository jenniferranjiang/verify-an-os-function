Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Relations.Relation_Operators.
Require Import Coq.Program.Equality.
Require Import SetsClass.SetsClass.
Import SetsNotation.

From SimpleC.SL Require Import Mem SeparationLogic ConAssertion.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.dll_abs.
Require Import CRTOS_Verify.lib.idnode_abs.
Require Import CRTOS_Verify.lib.CrtosGlobState.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sets.

(**
  本文件给出 [KTaskCreate] 使用的最小临时 owner-sensitive R/G 协议。

  该协议只解决一个问题：创建线程第一次解锁后，环境必须保护刚发布的
  Critical reservation；创建线程保留一枚线性 owner token，因而初始化失败后
  可以重新加锁并只回滚自己的 reservation。

*)

(**
  [KTaskReservation] 是一次创建操作的纯身份。

  参数:
  - [reservation_task]：新分配的 [struct TaskDescriptor] 地址；
  - [reservation_id]：第一次临界区内分配的任务 ID。

  该 record 本身不是权限。真正的修改权限是后文 STS 中不可复制的
  [TPT_OWNER reservation] token。
*)
Record KTaskReservation : Type := Build_KTaskReservation {
  reservation_task : addr;
  reservation_id : Z
}.

Arguments Build_KTaskReservation _ _ : assert.

Definition ktask_reservation_eq_dec
    (left right : KTaskReservation) : {left = right} + {left <> right}.
Proof.
  decide equality; apply Z.eq_dec.
Defined.

(** reservation 在 ID bucket 中对应的精确嵌入节点。 *)
Definition reservation_id_node
    (reservation : KTaskReservation) : IdNodeAbs :=
  let task := reservation.(reservation_task) in
  Build_IdNodeAbs
    reservation.(reservation_id)
    &(task # "TaskDescriptor" ->ₛ "id").

(** reservation 在全局 task list 中对应的精确嵌入节点。 *)
Definition reservation_link_node
    (reservation : KTaskReservation) : DL_Node unit :=
  let task := reservation.(reservation_task) in
  Build_DL_Node tt &(task # "TaskDescriptor" ->ₛ "link").

(**
  [task_reservation_active reservation state] 同时记录 publish 后必须受保护的
  地址权威事实：任务地址处于 Critical、descriptor map 缺项、任务地址已在
  注册表中、ID 已分配，并且 ID manager 中存在精确的 [(id,&task->id)] 节点。

  这里不再用派生的 [task_link_list] 节点 membership 代替原始任务地址
  membership。descriptor 的其余字段在临界区外初始化期间继续由创建线程的
  separation-logic 私有资源线性拥有。
*)
Definition task_reservation_active
    (reservation : KTaskReservation)
    (state : VarGlobalState) : Prop :=
  state.(task_virtual_status) reservation.(reservation_task) = VTS_CRITICAL /\
  state.(task_desc_map) reservation.(reservation_task) = None /\
  In reservation.(reservation_task) state.(task_ptr_list) /\
  In reservation.(reservation_id)
    state.(task_idmanager_abs).(idlist) /\
  In (reservation_id_node reservation)
    (List.concat state.(task_idmanager_abs).(idbuckets)).

(** 普通共享动作不得激活或解除任何已有 reservation。 *)
Definition all_reservations_stable
    (before after : VarGlobalState) : Prop :=
  forall reservation,
    task_reservation_active reservation before <->
    task_reservation_active reservation after.

(** owner 动作只能改变自己的 reservation，其他 reservation 必须保持。 *)
Definition other_reservations_stable
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  forall reservation,
    reservation <> owner ->
    (task_reservation_active reservation before <->
     task_reservation_active reservation after).

(**
  publish 是第一次解锁时的协议效果：owner 从 inactive 变为 active，其他
  Critical reservation 保持。第一次临界区内的 ID 选择和节点准备统称
  reserve，它们在 publish 前对环境不可见，因而不单独定义 STS 动作。

  精确的 ID bucket 插入和 task-list 表头插入仍由 [KTaskCreate.v] 的功能关系
  约束；本定义只规定并发权限边界。
*)
Definition tmp_task_publish
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  ~ task_reservation_active owner before /\
  task_reservation_active owner after /\
  other_reservations_stable owner before after.

(**
  rollback 是初始化失败后的 owner 动作：从第二次加锁实际观察到的状态中
  解除自己的 reservation，并保护其他所有 Critical reservation。

  “删除哪个 bucket/list 位置”的精确功能关系不在此重复实现；它必须由
  [KTaskCreate.v] 相对于第二次观察状态给出，并与本权限关系同时成立。
*)
Definition tmp_task_rollback
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  task_reservation_active owner before /\
  ~ task_reservation_active owner after /\
  other_reservations_stable owner before after.

(**
  owner finalize 的状态构造器直接复用正式 Global State 中同时更新
  virtual status 与 descriptor map 的 [task_finalize_state]。
*)
Definition tmp_task_finalize_state
    (owner : KTaskReservation)
    (desc : TaskDescriptorAbs)
    (before : VarGlobalState) : VarGlobalState :=
  task_finalize_state owner.(reservation_task) desc before.

(**
  finalize 是初始化成功后、owner 持锁退出时的协议效果：不删除
  ID-node/task node，只把 owner status 改为 Normal，并保护其他 Critical
  reservation。

  该纯关系本身不打开共享 invariant。它只能作为后文
  [TPCT_FINALIZE_EXIT] 的状态侧条件使用；物理 descriptor/stack 所有权必须在
  owner enter 取得 [crtos_inv] 后并入更新后的 invariant，再随 exit 一起归还。
*)
Definition tmp_task_finalize
    (owner : KTaskReservation)
    (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop :=
  task_reservation_active owner before /\
  task_finalize_publication
    owner.(reservation_task) desc before after /\
  ~ task_reservation_active owner after /\
  other_reservations_stable owner before after.

(**
  [task_reservation_finalized owner desc state] 是成功返回给客户时使用的纯
  Normal 视图。仅检查 [VTS_NORMAL] 不足以说明任务已经注册，因为注册表外
  地址的默认虚拟状态也可能为 Normal；本谓词同时固定 task-list、ID manager
  和 descriptor map 中的完整发布事实。
*)
Definition task_reservation_finalized
    (owner : KTaskReservation)
    (desc : TaskDescriptorAbs)
    (state : VarGlobalState) : Prop :=
  task_world_wf state /\
  task_create_finalize_ready desc /\
  In owner.(reservation_task) state.(task_ptr_list) /\
  In owner.(reservation_id) state.(task_idmanager_abs).(idlist) /\
  In (reservation_id_node owner)
    (List.concat state.(task_idmanager_abs).(idbuckets)) /\
  state.(task_virtual_status) owner.(reservation_task) = VTS_NORMAL /\
  state.(task_desc_map) owner.(reservation_task) = Some desc.

(**
  以下两个关系是给 Spec 阅读者使用的纯 R/G 投影。

  [TmpTaskRTrans owner] 允许环境修改无关任务，但禁止解除 owner；
  [TmpTaskGTrans owner] 允许当前线程 publish/rollback/finalize 自己的
  reservation。纯投影本身不提供权限，不能脱离后文线性 STS 单独使用。
*)
Definition TmpTaskRTrans
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  task_reservation_active owner before ->
  task_reservation_active owner after.

Definition TmpTaskGTrans
    (owner : KTaskReservation)
    (before after : VarGlobalState) : Prop :=
  before = after \/
  tmp_task_publish owner before after \/
  tmp_task_rollback owner before after \/
  exists desc, tmp_task_finalize owner desc before after.

(** lock token 位于 invariant（Outside）还是当前临界区执行者（Inside）。 *)
Inductive TaskProtocolPhase : Type :=
  | TPP_OUTSIDE
  | TPP_INSIDE.

Record TaskProtocolState : Type := Build_TaskProtocolState {
  task_protocol_phase : TaskProtocolPhase;
  task_protocol_world : VarGlobalState
}.

Arguments Build_TaskProtocolState _ _ : assert.

(**
  协议只有两类线性 token：临界区 lock 与某个 reservation 的 owner 权限。
  owner token 使用完整 [(task,id)] 身份，不会授权修改另一个 Critical task。
*)
Inductive TaskProtocolToken : Type :=
  | TPT_LOCK
  | TPT_OWNER (reservation : KTaskReservation).

Definition TaskProtocolTokenSet : Type := TaskProtocolToken -> Prop.

Definition task_no_tokens : TaskProtocolTokenSet :=
  fun _ => False.

Definition task_lock_token : TaskProtocolTokenSet :=
  fun token => token = TPT_LOCK.

Definition task_owner_token
    (owner : KTaskReservation) : TaskProtocolTokenSet :=
  fun token => token = TPT_OWNER owner.

Definition task_lock_and_owner
    (owner : KTaskReservation) : TaskProtocolTokenSet :=
  fun token => token = TPT_LOCK \/ token = TPT_OWNER owner.

Definition task_token_union
    (left right : TaskProtocolTokenSet) : TaskProtocolTokenSet :=
  fun token => left token \/ right token.

Definition task_token_disjoint
    (left right : TaskProtocolTokenSet) : Prop :=
  forall token, left token -> ~ right token.

Definition task_token_equiv
    (left right : TaskProtocolTokenSet) : Prop :=
  forall token, left token <-> right token.

(**
  Outside 时 invariant 持 lock token；reservation 尚未 active 时 invariant 持
  对应 owner token。publish 使 reservation active 并把 owner token 交给创建者；
  rollback/finalize 使它 inactive 并把 token 归还 invariant。
*)
Definition task_protocol_invowned_token
    (state : TaskProtocolState) : TaskProtocolTokenSet :=
  fun token =>
    match token with
    | TPT_LOCK => state.(task_protocol_phase) = TPP_OUTSIDE
    | TPT_OWNER reservation =>
        ~ task_reservation_active reservation state.(task_protocol_world)
    end.

(** core token 与 invariant token 的总和；每个 core 动作只搬运该总和。 *)
Definition task_core_inv_tokens
    (state : TaskProtocolState)
    (core : TaskProtocolTokenSet) : TaskProtocolTokenSet :=
  task_token_union core (task_protocol_invowned_token state).

(**
  五个必要的原子动作：进入、普通保护性退出、publish 退出、owner rollback
  退出，以及 owner finalize 退出。owner 第二次进入时，[TPT_OWNER] 作为
  frame 保留，只额外取得 [TPT_LOCK]；finalize 退出时同时归还两枚 token。

  finalize 刻意不是 Outside-to-Outside ghost 动作。只有 Inside 源状态才表示
  创建者已经通过锁规则打开 [crtos_inv]，因此才能把局部 descriptor/stack
  资源转入共享 invariant。
*)
Inductive task_protocol_core_transition :
    TaskProtocolState -> TaskProtocolTokenSet ->
    TaskProtocolState -> TaskProtocolTokenSet -> Prop :=
  | TPCT_ENTER :
      forall world,
        task_protocol_core_transition
          (Build_TaskProtocolState TPP_OUTSIDE world)
          task_no_tokens
          (Build_TaskProtocolState TPP_INSIDE world)
          task_lock_token

  | TPCT_EXIT_STABLE :
      forall before after,
        all_reservations_stable before after ->
        task_protocol_core_transition
          (Build_TaskProtocolState TPP_INSIDE before)
          task_lock_token
          (Build_TaskProtocolState TPP_OUTSIDE after)
          task_no_tokens

  | TPCT_PUBLISH_EXIT :
      forall owner before after,
        tmp_task_publish owner before after ->
        task_protocol_core_transition
          (Build_TaskProtocolState TPP_INSIDE before)
          task_lock_token
          (Build_TaskProtocolState TPP_OUTSIDE after)
          (task_owner_token owner)

  | TPCT_ROLLBACK_EXIT :
      forall owner before after,
        tmp_task_rollback owner before after ->
        task_protocol_core_transition
          (Build_TaskProtocolState TPP_INSIDE before)
          (task_lock_and_owner owner)
          (Build_TaskProtocolState TPP_OUTSIDE after)
          task_no_tokens

  | TPCT_FINALIZE_EXIT :
      forall owner desc before after,
        tmp_task_finalize owner desc before after ->
        task_protocol_core_transition
          (Build_TaskProtocolState TPP_INSIDE before)
          (task_lock_and_owner owner)
          (Build_TaskProtocolState TPP_OUTSIDE after)
          task_no_tokens.

(**
  统一 frame closure：与动作无关的 token 必须原样穿过，且不得与动作核心
  token 或 invariant token 冲突。该定义使 owner token 能跨 [_InitKTask]
  以及第二次 [ENTER] 保留，同时保持其线性、不可复制。
*)
Definition task_protocol_transition
    (source target : TaskProtocolState * TaskProtocolTokenSet) : Prop :=
  exists source_core target_core frame,
    task_protocol_core_transition
      (fst source) source_core (fst target) target_core /\
    task_token_disjoint source_core frame /\
    task_token_disjoint target_core frame /\
    task_token_disjoint
      (task_protocol_invowned_token (fst source)) frame /\
    task_token_disjoint
      (task_protocol_invowned_token (fst target)) frame /\
    task_token_equiv
      (snd source) (task_token_union source_core frame) /\
    task_token_equiv
      (snd target) (task_token_union target_core frame).

(**
  每个 core 动作两端，线程持有的 core token 都与 invariant token 互斥。
  这是把协议接入 QCP 唯一 assertion carrier 所需的第一个元性质。
*)
Lemma task_protocol_core_disjoint :
  forall source source_core target target_core,
    task_protocol_core_transition
      source source_core target target_core ->
    task_token_disjoint
      source_core (task_protocol_invowned_token source) /\
    task_token_disjoint
      target_core (task_protocol_invowned_token target).
Proof.
  intros source source_core target target_core Hstep.
  destruct Hstep.
  - split.
    + intros token Hnone _. exact Hnone.
    + intros token Hlock Hinv. unfold task_lock_token in Hlock.
      subst token. discriminate.
  - split.
    + intros token Hlock Hinv. unfold task_lock_token in Hlock.
      subst token. discriminate.
    + intros token Hnone _. exact Hnone.
  - destruct H as [Hbefore [Hafter Hother]].
    split.
    + intros token Hlock Hinv. unfold task_lock_token in Hlock.
      subst token. discriminate.
    + intros token Howner Hinv. unfold task_owner_token in Howner.
      subst token. apply Hinv. exact Hafter.
  - destruct H as [Hbefore [Hafter Hother]].
    split.
    + intros token Htoken Hinv.
      unfold task_lock_and_owner in Htoken.
      destruct Htoken as [Hlock | Howner].
      * subst token. discriminate.
      * subst token. apply Hinv. exact Hbefore.
    + intros token Hnone _. exact Hnone.
  - destruct H as [Hbefore [Hpublication [Hafter Hother]]].
    split.
    + intros token Htoken Hinv.
      unfold task_lock_and_owner in Htoken.
      destruct Htoken as [Hlock | Howner].
      * subst token. discriminate.
      * subst token. apply Hinv. exact Hbefore.
    + intros token Hnone _. exact Hnone.
Qed.

(**
  core 动作不创建或销毁 token：它只在当前线程与 invariant 之间搬运 lock
  或某个 owner token。对 owner token 的证明分别使用 active 的翻转及
  “其他 reservation 保持”条件。
*)
Lemma task_protocol_core_tokens_preserved :
  forall source source_core target target_core,
    task_protocol_core_transition
      source source_core target target_core ->
    task_token_equiv
      (task_core_inv_tokens source source_core)
      (task_core_inv_tokens target target_core).
Proof.
  intros source source_core target target_core Hstep token.
  destruct Hstep; destruct token as [| reservation]; simpl;
    unfold task_core_inv_tokens, task_token_union, task_no_tokens,
      task_lock_token, task_owner_token, task_lock_and_owner;
    simpl.
  - tauto.
  - split; intros [Hnone | Hinactive].
    + contradiction.
    + right. exact Hinactive.
    + discriminate.
    + right. exact Hinactive.
  - tauto.
  - specialize (H reservation).
    split; intros [Hlock | Hinactive].
    + discriminate.
    + right. intro Hactive. apply Hinactive. apply (proj2 H). exact Hactive.
    + contradiction.
    + right. intro Hactive. apply Hinactive. apply (proj1 H). exact Hactive.
  - tauto.
  - destruct (ktask_reservation_eq_dec reservation owner) as [Heq | Hneq].
    + subst reservation.
      split; intros _.
      * left. reflexivity.
      * right. exact (proj1 H).
    + pose proof (proj2 (proj2 H) reservation Hneq) as Hstable.
      split; intros [Hlock | Hinactive].
      * discriminate.
      * right. intro Hactive. apply Hinactive.
        apply (proj2 Hstable). exact Hactive.
      * exfalso. apply Hneq. inversion Hlock. reflexivity.
      * right. intro Hactive. apply Hinactive.
        apply (proj1 Hstable). exact Hactive.
  - tauto.
  - destruct (ktask_reservation_eq_dec reservation owner) as [Heq | Hneq].
    + subst reservation.
      split; intros _.
      * right. exact (proj1 (proj2 H)).
      * left. right. reflexivity.
    + pose proof (proj2 (proj2 H) reservation Hneq) as Hstable.
      split; intros [Hcore | Hinactive].
      * destruct Hcore as [Hlock | Howner].
        -- discriminate.
        -- exfalso. apply Hneq. inversion Howner. reflexivity.
      * right. intro Hactive. apply Hinactive.
        apply (proj2 Hstable). exact Hactive.
      * contradiction.
      * right. intro Hactive. apply Hinactive.
        apply (proj1 Hstable). exact Hactive.
  - tauto.
  - destruct (ktask_reservation_eq_dec reservation owner) as [Heq | Hneq].
    + subst reservation.
      split; intros _.
      * right. exact (proj1 (proj2 (proj2 H))).
      * left. right. reflexivity.
    + pose proof (proj2 (proj2 (proj2 H)) reservation Hneq) as Hstable.
      split; intros [Hcore | Hinactive].
      * destruct Hcore as [Hlock | Howner].
        -- discriminate.
        -- exfalso. apply Hneq. inversion Howner. reflexivity.
      * right. intro Hactive. apply Hinactive.
        apply (proj2 Hstable). exact Hactive.
      * contradiction.
      * right. intro Hactive. apply Hinactive.
        apply (proj1 Hstable). exact Hactive.
Qed.

(** 可供后续 [CrtosRules] 人工审核后实例化的最小线性 STS。 *)
Definition tmp_task_protocol_STS : ConAssertion.STS :=
  {| ConAssertion.token := TaskProtocolToken;
     ConAssertion.STS_state := TaskProtocolState;
     ConAssertion.Transition := task_protocol_transition;
     ConAssertion.InvownedToken := task_protocol_invowned_token |}.

(** 单点 finalize 同时更新 status/map，保持 task-list、ID manager 与其余
    descriptor cell，因此保持 [task_world_wf]。 *)
Lemma task_world_wf_finalize_state :
  forall task desc before,
    task_world_wf before ->
    In task before.(task_ptr_list) ->
    task_world_wf (task_finalize_state task desc before).
Proof.
  intros task desc before Hwf Hin_task.
  unfold task_world_wf in Hwf |- *.
  destruct Hwf as [Hregistered [Hunregistered Hids]].
  repeat split.
  - intros current Hin_current.
    change
      (match update_task_virtual_status
               task VTS_NORMAL before.(task_virtual_status) current with
       | VTS_CRITICAL =>
           update_task_desc_map
             task (Some desc) before.(task_desc_map) current = None
       | VTS_NORMAL =>
           exists current_desc,
             update_task_desc_map
               task (Some desc) before.(task_desc_map) current =
               Some current_desc
       end).
    unfold update_task_virtual_status, update_task_desc_map.
    destruct (Z.eq_dec current task) as [Heq | Hneq].
    + subst current.
      destruct (Z.eq_dec task task) as [_ | Hcontra].
      * exists desc. reflexivity.
      * exfalso. apply Hcontra. reflexivity.
    + destruct (Z.eq_dec current task) as [Hcontra | _].
      * contradiction.
      * exact (Hregistered current Hin_current).
  - intros current Hnotin.
    change
      (update_task_desc_map
        task (Some desc) before.(task_desc_map) current = None).
    unfold update_task_desc_map.
    destruct (Z.eq_dec current task) as [Heq | Hneq].
    + subst current. contradiction.
    + apply Hunregistered. exact Hnotin.
  - exact Hids.
Qed.

(** 构造 finalize publication 时，目标 world-wf 不再作为独立猜测；它由
    旧 world-wf 和 task-list membership 机器推出。 *)
Lemma task_finalize_publication_intro :
  forall task desc before,
    task_world_wf before ->
    task_create_finalize_ready desc ->
    In task before.(task_ptr_list) ->
    before.(task_virtual_status) task = VTS_CRITICAL ->
    before.(task_desc_map) task = None ->
    task_finalize_publication
      task desc before (task_finalize_state task desc before).
Proof.
  intros task desc before Hwf Hready Hin Hcritical Hnone.
  unfold task_finalize_publication.
  refine (conj Hwf _).
  refine (conj Hready _).
  refine (conj Hin _).
  refine (conj Hcritical _).
  refine (conj Hnone _).
  refine (conj eq_refl _).
  apply task_world_wf_finalize_state; assumption.
Qed.

(** finalize guarantee 的目标状态必然是已注册且带完整 descriptor 的 Normal
    task；该投影不需要额外公理或空间资源。 *)
Lemma tmp_task_finalize_establishes_finalized :
  forall owner desc before after,
    tmp_task_finalize owner desc before after ->
    task_reservation_finalized owner desc after.
Proof.
  intros owner desc before after Hfinalize.
  unfold tmp_task_finalize in Hfinalize.
  destruct Hfinalize as [Hactive [Hpublication [_ _]]].
  unfold task_reservation_active in Hactive.
  destruct Hactive as [Hcritical [Hnone [Hin [Hid Hnode]]]].
  unfold task_finalize_publication in Hpublication.
  destruct Hpublication as
    [Hwf_before [Hready [_ [_ [_ [Hafter Hwf_after]]]]]].
  subst after.
  unfold task_reservation_finalized.
  split; [exact Hwf_after |].
  split; [exact Hready |].
  split; [cbn [task_finalize_state]; exact Hin |].
  split; [cbn [task_finalize_state]; exact Hid |].
  split; [cbn [task_finalize_state]; exact Hnode |].
  split.
  - change
      (update_task_virtual_status
        owner.(reservation_task) VTS_NORMAL before.(task_virtual_status)
        owner.(reservation_task) = VTS_NORMAL).
    unfold update_task_virtual_status.
    destruct (Z.eq_dec owner.(reservation_task) owner.(reservation_task))
      as [_ | Hneq].
    + reflexivity.
    + exfalso. apply Hneq. reflexivity.
  - change
      (update_task_desc_map
        owner.(reservation_task) (Some desc) before.(task_desc_map)
        owner.(reservation_task) = Some desc).
    unfold update_task_desc_map.
    destruct (Z.eq_dec owner.(reservation_task) owner.(reservation_task))
      as [_ | Hneq].
    + reflexivity.
    + exfalso. apply Hneq. reflexivity.
Qed.

(** framed transition 两端的全部局部 token 都与 invariant token 互斥。 *)
Theorem task_protocol_transition_disjoint_preserved :
  @ConAssertion.transtion_disjoint_preserved tmp_task_protocol_STS
    task_protocol_transition.
Proof.
  intros source target source_tokens target_tokens Hstep.
  destruct Hstep as
      (source_core & target_core & frame & Hcore & Hsource_core &
       Htarget_core & Hsource_inv & Htarget_inv & Hsource & Htarget).
  pose proof (task_protocol_core_disjoint _ _ _ _ Hcore)
    as [Hcore_source_inv Hcore_target_inv].
  split; sets_unfold; intro token; split; intros Hpair; try contradiction.
  - destruct Hpair as [Hlocal Hinv].
    apply Hsource in Hlocal. destruct Hlocal as [Hlocal | Hlocal].
    + exact (Hcore_source_inv token Hlocal Hinv).
    + exact (Hsource_inv token Hinv Hlocal).
  - destruct Hpair as [Hlocal Hinv].
    apply Htarget in Hlocal. destruct Hlocal as [Hlocal | Hlocal].
    + exact (Hcore_target_inv token Hlocal Hinv).
    + exact (Htarget_inv token Hinv Hlocal).
Qed.

(** framed transition 保持“局部 token 与 invariant token”的总集合。 *)
Theorem task_protocol_transition_token_preserved :
  @ConAssertion.transition_token_preserved tmp_task_protocol_STS
    task_protocol_transition.
Proof.
  intros source target source_tokens target_tokens total Hstep.
  pose proof Hstep as Hdisjoint_step.
  apply task_protocol_transition_disjoint_preserved in Hdisjoint_step.
  destruct Hdisjoint_step as [Hsource_disjoint Htarget_disjoint].
  destruct Hstep as
      (source_core & target_core & frame & Hcore & _ & _ & _ & _ &
       Hsource & Htarget).
  pose proof (task_protocol_core_tokens_preserved _ _ _ _ Hcore)
    as Hcore_total.
  unfold task_token_equiv, task_token_union, task_core_inv_tokens
    in Hsource, Htarget, Hcore_total.
  unfold ConAssertion.TokenSet_join.
  split; intros [Htotal Hdisjoint]; split.
  - sets_unfold in Htotal. sets_unfold. intro token.
    specialize (Htotal token).
    specialize (Hsource token).
    specialize (Htarget token).
    specialize (Hcore_total token).
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
    specialize (Htotal token).
    specialize (Hsource token).
    specialize (Htarget token).
    specialize (Hcore_total token).
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

(**
  任意与动作及 invariant 不冲突的 token frame 都能原样穿过 transition。
  这条性质尤其保证 owner token 可以穿过第二次 ENTER。
*)
Theorem task_protocol_closed_transition :
  @ConAssertion.Closed_transition tmp_task_protocol_STS
    task_protocol_transition.
Proof.
  intros source target source_tokens target_tokens extra Hstep
    Hsource_extra Hextra_source_inv.
  assert (Hsource_extra_disjoint :
      task_token_disjoint source_tokens extra).
  { intros token Hsource_token Hextra_token.
    sets_unfold in Hsource_extra.
    specialize (Hsource_extra token).
    exact (proj1 Hsource_extra (conj Hsource_token Hextra_token)). }
  assert (Hextra_source_inv_disjoint :
      task_token_disjoint extra (task_protocol_invowned_token source)).
  { intros token Hextra_token Hinv_token.
    sets_unfold in Hextra_source_inv.
    specialize (Hextra_source_inv token).
    exact (proj1 Hextra_source_inv (conj Hextra_token Hinv_token)). }
  destruct Hstep as
      (source_core & target_core & frame & Hcore & Hsource_core_frame &
       Htarget_core_frame & Hsource_inv_frame & Htarget_inv_frame &
       Hsource & Htarget).
  pose proof (task_protocol_core_tokens_preserved _ _ _ _ Hcore)
    as Hcore_total.
  exists source_core, target_core, (task_token_union frame extra).
  repeat split; try exact Hcore.
  - intros token Htoken [Hframe | Hextra].
    + exact (Hsource_core_frame token Htoken Hframe).
    + apply (Hsource_extra_disjoint token).
      * apply Hsource. left. exact Htoken.
      * exact Hextra.
  - intros token Htoken [Hframe | Hextra].
    + exact (Htarget_core_frame token Htoken Hframe).
    + specialize (Hcore_total token).
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
    + specialize (Hcore_total token).
      destruct (proj2 Hcore_total (or_intror Hinv)) as
          [Hsource_core | Hsource_inv].
      * apply (Hsource_extra_disjoint token).
        -- apply Hsource. left. exact Hsource_core.
        -- exact Hextra.
      * exact (Hextra_source_inv_disjoint token Hextra Hsource_inv).
  - unfold task_token_equiv, task_token_union in Hsource.
    specialize (Hsource token). unfold task_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal | Hextra].
    + apply Hsource in Hlocal. tauto.
    + tauto.
  - unfold task_token_equiv, task_token_union in Hsource.
    specialize (Hsource token). unfold task_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal_core | [Hframe | Hextra]].
    + left. apply Hsource. left. exact Hlocal_core.
    + left. apply Hsource. right. exact Hframe.
    + right. exact Hextra.
  - unfold task_token_equiv, task_token_union in Htarget.
    specialize (Htarget token). unfold task_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal | Hextra].
    + apply Htarget in Hlocal. tauto.
    + tauto.
  - unfold task_token_equiv, task_token_union in Htarget.
    specialize (Htarget token). unfold task_token_union. sets_unfold.
    intro Hlocal. destruct Hlocal as [Hlocal_core | [Hframe | Hextra]].
    + left. apply Htarget. left. exact Hlocal_core.
    + left. apply Htarget. right. exact Hframe.
    + right. exact Hextra.
Qed.

(**
  QCP 并发分离逻辑要求的三个 STS 元性质已经全部证明；该定理只是把三个
  独立证明打包，便于 [CrtosRules] 或后续锁规则一次性引用。
*)
Theorem tmp_task_protocol_meta_properties :
  @ConAssertion.transtion_disjoint_preserved tmp_task_protocol_STS
      task_protocol_transition /\
  @ConAssertion.transition_token_preserved tmp_task_protocol_STS
      task_protocol_transition /\
  @ConAssertion.Closed_transition tmp_task_protocol_STS
      task_protocol_transition.
Proof.
  exact
    (conj task_protocol_transition_disjoint_preserved
      (conj task_protocol_transition_token_preserved
        task_protocol_closed_transition)).
Qed.

(** 当前线程持有 [held] 时，环境只能使用其与 invariant token 的补集。 *)
Definition task_environment_tokens
    (held : TaskProtocolTokenSet)
    (state : TaskProtocolState) : TaskProtocolTokenSet :=
  fun token =>
    ~ held token /\
    ~ task_protocol_invowned_token state token.

Definition task_environment_step
    (held : TaskProtocolTokenSet)
    (before after : TaskProtocolState) : Prop :=
  task_protocol_transition
    (before, task_environment_tokens held before)
    (after, task_environment_tokens held after).

(** owner 跨临界区外初始化时允许的任意多步环境执行。 *)
Definition TmpTaskRReachable
    (owner : KTaskReservation)
    (before after : TaskProtocolState) : Prop :=
  @Relation_Operators.clos_refl_trans
    TaskProtocolState
    (task_environment_step (task_owner_token owner))
    before after.

(**
  中心安全性质：当前线程持有 [TPT_OWNER owner] 时，任意一步环境执行都不能
  解除该 active reservation。环境仍可修改 Normal task，或使用自己的 owner
  token publish/resolve 其他 Critical reservation。
*)
Lemma task_environment_step_preserves_owner :
  forall owner before after,
    task_reservation_active owner before.(task_protocol_world) ->
    task_environment_step (task_owner_token owner) before after ->
    task_reservation_active owner after.(task_protocol_world).
Proof.
  intros owner before after Hactive Hstep.
  unfold task_environment_step, task_protocol_transition in Hstep.
  destruct Hstep as
      (source_core & target_core & frame & Hcore & _ & _ & _ & _ &
       Hsource & _).
  cbn in Hcore, Hsource.
  dependent destruction Hcore.
  - exact Hactive.
  - apply (proj1 (H owner)); exact Hactive.
  - destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. exfalso; apply (proj1 H); exact Hactive.
    + apply (proj1 (proj2 (proj2 H) owner Hneq)); exact Hactive.
  - destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. exfalso.
      assert (Hcore_owner :
        task_token_union (task_lock_and_owner owner) frame
          (TPT_OWNER owner)).
      { left; right; reflexivity. }
      pose proof (proj2 (Hsource (TPT_OWNER owner)) Hcore_owner)
        as Howner_environment.
      apply (proj1 Howner_environment); reflexivity.
    + apply (proj1 (proj2 (proj2 H) owner Hneq)); exact Hactive.
  - destruct (ktask_reservation_eq_dec owner owner0) as [Heq | Hneq].
    + subst owner0. exfalso.
      assert (Hcore_owner :
        task_token_union (task_lock_and_owner owner) frame
          (TPT_OWNER owner)).
      { left; right; reflexivity. }
      pose proof (proj2 (Hsource (TPT_OWNER owner)) Hcore_owner)
        as Howner_environment.
      apply (proj1 Howner_environment); reflexivity.
    + apply (proj1 (proj2 (proj2 (proj2 H)) owner Hneq)); exact Hactive.
Qed.

(** owner-held 的真实环境步骤蕴含前述纯 rely 投影。 *)
Corollary task_environment_step_satisfies_rely :
  forall owner before after,
    task_environment_step (task_owner_token owner) before after ->
    TmpTaskRTrans
      owner before.(task_protocol_world) after.(task_protocol_world).
Proof.
  intros owner before after Hstep Hactive.
  eapply task_environment_step_preserves_owner; eauto.
Qed.

(** 多步环境闭包同样始终保护 owner reservation。 *)
Corollary tmp_task_rely_reachable_preserves_owner :
  forall owner before after,
    task_reservation_active owner before.(task_protocol_world) ->
    TmpTaskRReachable owner before after ->
    task_reservation_active owner after.(task_protocol_world).
Proof.
  intros owner before after Hactive Hreachable.
  induction Hreachable.
  - eapply task_environment_step_preserves_owner; eauto.
  - exact Hactive.
  - apply IHHreachable2.
    apply IHHreachable1.
    exact Hactive.
Qed.
