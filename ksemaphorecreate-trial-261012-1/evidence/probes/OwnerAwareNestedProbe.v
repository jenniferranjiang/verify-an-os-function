Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia.
Require Import Coq.Relations.Relation_Operators.
Require Import SetsClass.SetsClass SL.ConAssertion SL.CriticalSTS.
Require Import CrtosProbeFramework.NestedCriticalAdapter.
Require Import NestedCarrierProbe.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosHeapBridge.
Import ListNotations SetsNotation.
Local Open Scope sets.

(** 仍复用QCP的handler栈与nat-token状态，不另造锁数据类型。
    本文件是evidence中的协议探针，不属于当前r2正式输入。 *)
Definition OwnerNestedState := @nested_critical_state ProbeNested_C_STS.nc_sts.
Definition owner_prefix (hs : list Z) : nat -> Prop :=
  fun n => (n < List.length hs)%nat.

(** 每次进入/退出必须持有全部外层prefix权限，不能让空环境token
    在其他线程已经持锁时又进入一层。所有caller的outer tokens都被保留。 *)
Inductive owner_nested_step :
  (OwnerNestedState * (nat -> Prop)) ->
  (OwnerNestedState * (nat -> Prop)) -> Prop :=
| OwnerEnter : forall handler hs state before_tokens after_tokens,
    before_tokens == owner_prefix hs ->
    after_tokens == owner_prefix (handler :: hs) ->
    owner_nested_step
      (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs state, before_tokens)
      (Build_nested_critical_state ProbeNested_C_STS.nc_sts (handler :: hs) state, after_tokens)
| OwnerExit : forall handler hs before after before_tokens after_tokens,
    CrtosOSTransition before after ->
    before_tokens == owner_prefix (handler :: hs) ->
    after_tokens == owner_prefix hs ->
    owner_nested_step
      (Build_nested_critical_state ProbeNested_C_STS.nc_sts (handler :: hs) before, before_tokens)
      (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs after, after_tokens).

(** 未被当前handler栈取走的nat tokens仍归全局invariant，正好是depth以上后缀。 *)
Definition OwnerNestedSTS : ConAssertion.STS :=
  {| ConAssertion.token := nat;
     ConAssertion.STS_state := OwnerNestedState;
     ConAssertion.Transition := owner_nested_step;
     ConAssertion.InvownedToken := fun state n =>
       (n >= List.length (handlers_of_NCS state))%nat |}.

Definition OwnerNestedHeap := crtos_heap_lift OwnerNestedSTS.

(** 这就是ConAssertion环境可用token：排除caller持有和invariant持有的token。 *)
Definition owner_environment_tokens (held : nat -> Prop) (state : OwnerNestedState)
    : nat -> Prop :=
  fun n => ~ (held n \/ ConAssertion.InvownedToken (STS:=OwnerNestedSTS) state n).
Definition owner_environment_step (held : nat -> Prop)
    (before after : OwnerNestedState) : Prop :=
  owner_nested_step (before, owner_environment_tokens held before)
    (after, owner_environment_tokens held after).

(** 空栈outside显式绑定before到环境闭包的起点，修复官方Critical空栈分支
    未使用state参数的问题。返回的outside观察也必须是空栈。这里使用去掉
    nest局部计数的OS投影，但物理nest仍须由正式heap规则持有，不能因此忽略溢出。 *)
Definition OwnerNestedRely (before after : CrtosOSState) : Prop :=
  @Relation_Operators.clos_refl_trans OwnerNestedState (owner_environment_step Sets.empty)
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts nil (ProbeProtectedOS before))
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts nil (ProbeProtectedOS after)).
Definition OwnerNestedOutsideStates (before : CrtosOSState)
    (current : OwnerNestedState) : Prop :=
  @Relation_Operators.clos_refl_trans OwnerNestedState (owner_environment_step Sets.empty)
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts nil (ProbeProtectedOS before)) current.

(** 一个不可拆分的协议view，同时携带精确栈/状态和完整prefix token。
    不把外层token复制给nested callee，而是整体借出再返还。 *)
Definition OwnerNestedInside (hs : list Z) (state : CrtosOSState)
    : @ConAssertion.Lstate OwnerNestedSTS -> Prop :=
  fun low =>
    low.(ConAssertion.s_mem) = Mem.empty_mem /\
    low.(ConAssertion.s_STS) ==
      Sets.singleton (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs (ProbeProtectedOS state)) /\
    low.(ConAssertion.s_token) == owner_prefix hs.

Lemma owner_step_requires_source_prefix : forall source target before_tokens after_tokens,
  owner_nested_step (source, before_tokens) (target, after_tokens) ->
  forall n, (n < List.length (handlers_of_NCS source))%nat -> before_tokens n.
Proof.
  intros source target before_tokens after_tokens Hstep n Hn.
  inversion Hstep; subst; cbn in Hn;
    match goal with H : before_tokens == _ |- _ => apply (proj2 (H n)); exact Hn end.
Qed.

(** 栈非空且本线程持全prefix时，环境不能执行任何enter或exit一步。
    这是IRQ内环境排他的核心事实，而不是仅编译成功的推测。 *)
Lemma owner_nested_excludes_environment : forall hs state next,
  hs <> nil ->
  ~ owner_environment_step (owner_prefix hs)
      (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs state) next.
Proof.
  intros hs state next Hnonempty Hstep.
  assert (Hdepth : (0 < List.length hs)%nat).
  { destruct hs; cbn in *; [contradiction|lia]. }
  pose proof (owner_step_requires_source_prefix _ _ _ _ Hstep 0 Hdepth) as Htoken.
  unfold owner_environment_tokens in Htoken.
  apply Htoken. left. exact Hdepth.
Qed.

(** prefix与invariant的后缀不相交且并为全部nat token，所有权总量不变。 *)
Lemma owner_prefix_partition : forall hs state,
  handlers_of_NCS state = hs ->
  @ConAssertion.TokenSet_join OwnerNestedSTS
    (owner_prefix hs) (ConAssertion.InvownedToken (STS:=OwnerNestedSTS) state) Sets.full.
Proof.
  intros hs state Hstack.
  unfold ConAssertion.TokenSet_join, owner_prefix; cbn.
  rewrite Hstack. split; sets_unfold; intros; lia.
Qed.

(** 非空caller token不能在分离组合中复制两份。 *)
Lemma owner_prefix_not_duplicable : forall hs all_tokens,
  hs <> nil ->
  ~ @ConAssertion.TokenSet_join OwnerNestedSTS
       (owner_prefix hs) (owner_prefix hs) all_tokens.
Proof.
  intros hs all_tokens Hnonempty [_ Hdisjoint].
  assert (Hdepth : (0 < List.length hs)%nat).
  { destruct hs; cbn in *; [contradiction|lia]. }
  specialize (Hdisjoint 0%nat).
  sets_unfold in Hdisjoint. unfold owner_prefix in Hdisjoint. tauto.
Qed.

(** 进入恰好压入handler并取得下一枚token；退出恰好弹出同一handler，
    保持原hs及其prefix，而不是遗失caller已有层。这不是nest uint16恢复定理。 *)
Lemma owner_enter_exit_restores_stack : forall hs handler before after,
  CrtosOSTransition before after ->
  owner_nested_step
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs before, owner_prefix hs)
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts (handler :: hs) before,
      owner_prefix (handler :: hs)) /\
  owner_nested_step
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts (handler :: hs) before,
      owner_prefix (handler :: hs))
    (Build_nested_critical_state ProbeNested_C_STS.nc_sts hs after, owner_prefix hs).
Proof.
  intros hs handler before after Htransition; split.
  - constructor; reflexivity.
  - constructor; [exact Htransition|reflexivity|reflexivity].
Qed.

Lemma owner_nested_rely_refl : forall state, OwnerNestedRely state state.
Proof. intro state; apply Relation_Operators.rt_refl. Qed.
