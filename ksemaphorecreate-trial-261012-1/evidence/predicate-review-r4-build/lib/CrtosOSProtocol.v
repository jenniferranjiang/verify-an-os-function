Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia.
Require Import Coq.Relations.Relation_Operators.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Import SetsClass.SetsClass Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosHeapBridge.
Require Import CRTOS_Verify.sem.CrtosNestedState.
Import ListNotations SetsNotation.
Local Open Scope Z_scope.
Local Open Scope sets.

(** Cortex-M3 PRIMASK仅bit0；最外层可保存0或1。 *)
Definition semaphore_irq_handler_ok (handler : Z) : Prop := handler = 0 \/ handler = 1.

(** handler栈记录实际IRQ保存值，不等同于调度nest计数：裸IRQ屏蔽不递增nest。
    已有屏蔽层时MRS读到1，故内层保存值为1；最外层可为0或1。
    这是interrupt.c的MRS/CPSID/MSR含义，不是仅从handler_ok推出的附加假设。 *)
Fixpoint semaphore_irq_stack_ok (hs : list Z) : Prop :=
  match hs with
  | nil => True
  | h :: tail => semaphore_irq_handler_ok h /\
      (tail = nil \/ h = 1) /\ semaphore_irq_stack_ok tail
  end.

Module Crtos_C_STS <: critical_STS_def.
  Definition c_sts : critical_STS :=
    Build_critical_STS CrtosOSState CrtosOSTransition.
End Crtos_C_STS.
Definition CrtosProtocolState := @nested_critical_state Crtos_C_STS.c_sts.

(** nat token复用QCP nested协议的前缀规则，hs每一层恰有一枚线性token。 *)
Definition CrtosPrefixTokens (hs : list Z) : nat -> Prop :=
  fun n => (n < List.length hs)%nat.

(** 真实IRQ进入/恢复边界的协议步骤。当前actor必须持全部外层prefix，
    环境不能凭空token在已屏蔽区域再次进入。Enter保留受保护OS状态，
    Exit原样恢复handler栈并提交由真实C内存更新建立的新不变量。 *)
Inductive CrtosIRQStep :
  (CrtosProtocolState * (nat -> Prop)) ->
  (CrtosProtocolState * (nat -> Prop)) -> Prop :=
| CrtosIRQEnter : forall handler hs state before_tokens after_tokens,
    semaphore_irq_stack_ok (handler :: hs) ->
    before_tokens == CrtosPrefixTokens hs ->
    after_tokens == CrtosPrefixTokens (handler :: hs) ->
    CrtosIRQStep
      (Build_nested_critical_state Crtos_C_STS.c_sts hs state, before_tokens)
      (Build_nested_critical_state Crtos_C_STS.c_sts (handler :: hs) state, after_tokens)
| CrtosIRQExit : forall handler hs before after before_tokens after_tokens,
    semaphore_irq_stack_ok (handler :: hs) ->
    CrtosOSTransition before after ->
    before_tokens == CrtosPrefixTokens (handler :: hs) ->
    after_tokens == CrtosPrefixTokens hs ->
    CrtosIRQStep
      (Build_nested_critical_state Crtos_C_STS.c_sts (handler :: hs) before, before_tokens)
      (Build_nested_critical_state Crtos_C_STS.c_sts hs after, after_tokens).

Module Crtos_STS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS :=
    {| ConAssertion.token := nat;
       ConAssertion.STS_state := CrtosProtocolState;
       ConAssertion.Transition := CrtosIRQStep;
       ConAssertion.InvownedToken := fun state n =>
         (n >= List.length (handlers_of_NCS state))%nat |}.
End Crtos_STS.

Module Crtos_C_Rules.
  Include Crtos_STS.
  Include ConAssertion.CSL.
  Include DerivedPredSig Arch32 LittleEndian.
  Include StoreLibSig Arch32 LittleEndian.
  Include ArrayLibSig Arch32 LittleEndian.
  Include MapLibSig Arch32 LittleEndian.
  Include StringLibSig Arch32 LittleEndian.
End Crtos_C_Rules.

(** 共享heap的精确carrier迁移不生成或复制任何IRQ token。 *)
Definition OSHeap := crtos_heap_lift Crtos_STS.sts.

Definition CrtosEnvironmentTokens (held : nat -> Prop) (state : CrtosProtocolState)
    : nat -> Prop :=
  fun n => ~ (held n \/ ConAssertion.InvownedToken (STS:=Crtos_STS.sts) state n).
Definition CrtosEnvironmentStep (held : nat -> Prop)
    (before after : CrtosProtocolState) : Prop :=
  CrtosIRQStep (before, CrtosEnvironmentTokens held before)
    (after, CrtosEnvironmentTokens held after).

(** Rely通过真正环境步闭包绑定同一caller栈。物理nest在调用者两次观察之间
    保持：外层无持锁时为0，内层属于当前actor已有heap，环境不能写它。
    state投影只用于IRQ协议；完整CrtosOSValid和nest等式仍保留真实OS状态。 *)
Definition SemaphoreRely (hs : list Z) (before current : CrtosOSState) : Prop :=
  CrtosOSValid before /\ CrtosOSValid current /\
  before.(os_scheduler).(scheduler_lock_nest) =
    current.(os_scheduler).(scheduler_lock_nest) /\
  @Relation_Operators.clos_refl_trans CrtosProtocolState
    (CrtosEnvironmentStep (CrtosPrefixTokens hs))
    (Build_nested_critical_state Crtos_C_STS.c_sts hs (CrtosOSProtected before))
    (Build_nested_critical_state Crtos_C_STS.c_sts hs (CrtosOSProtected current)).

Import Crtos_C_Rules.
Local Open Scope sac.

(** 原子协议view把状态集合与token组合在单个low-state中；它只拥有空heap。 *)
Definition CrtosProtocolView (states : CrtosProtocolState -> Prop)
    (held : nat -> Prop) : Assertion :=
  fun low => low.(ConAssertion.s_mem) = Mem.empty_mem /\
    low.(ConAssertion.s_STS) == states /\ low.(ConAssertion.s_token) == held.

(** 持锁caller将精确hs token借给内层调用，再取得同一hs。 *)
Definition CrtosInsideProtocol (hs : list Z) (state : CrtosOSState) : Assertion :=
  CrtosProtocolView
    (Sets.singleton (Build_nested_critical_state Crtos_C_STS.c_sts hs (CrtosOSProtected state)))
    (CrtosPrefixTokens hs).

(** 空栈外层view显式以before作为环境闭包起点，不使用忽略before的旧nested接口。 *)
Definition CrtosOutsideProtocol (before : CrtosOSState) : Assertion :=
  CrtosProtocolView
    (fun current => @Relation_Operators.clos_refl_trans CrtosProtocolState
      (CrtosEnvironmentStep Sets.empty)
      (Build_nested_critical_state Crtos_C_STS.c_sts nil (CrtosOSProtected before)) current)
    Sets.empty.

Lemma CrtosIRQStep_requires_source_prefix : forall source target before_tokens after_tokens,
  CrtosIRQStep (source, before_tokens) (target, after_tokens) ->
  forall n, (n < List.length (handlers_of_NCS source))%nat -> before_tokens n.
Proof.
  intros source target before_tokens after_tokens Hstep n Hn.
  inversion Hstep; subst; cbn in Hn;
    match goal with H : before_tokens == _ |- _ => apply (proj2 (H n)); exact Hn end.
Qed.

(** 非空caller持全prefix时环境无可执行步，所以nested精确性不是额外trusted假设。 *)
Lemma CrtosInsideEnvironment_excluded : forall hs state next,
  hs <> nil ->
  ~ CrtosEnvironmentStep (CrtosPrefixTokens hs)
      (Build_nested_critical_state Crtos_C_STS.c_sts hs state) next.
Proof.
  intros hs state next Hnonempty Hstep.
  assert (Hdepth : (0 < List.length hs)%nat).
  { destruct hs; cbn in *; [contradiction|lia]. }
  pose proof (CrtosIRQStep_requires_source_prefix _ _ _ _ Hstep 0%nat Hdepth) as Htoken.
  unfold CrtosEnvironmentTokens in Htoken. apply Htoken. left. exact Hdepth.
Qed.

Lemma CrtosInsideEnvironment_reachable_identity : forall hs state current,
  hs <> nil ->
  Relation_Operators.clos_refl_trans CrtosProtocolState
    (CrtosEnvironmentStep (CrtosPrefixTokens hs))
    (Build_nested_critical_state Crtos_C_STS.c_sts hs state) current ->
  current = Build_nested_critical_state Crtos_C_STS.c_sts hs state.
Proof.
  intros hs state current Hnonempty Hreach.
  set (origin := Build_nested_critical_state Crtos_C_STS.c_sts hs state) in *.
  assert (Hblocked : forall next, ~ CrtosEnvironmentStep (CrtosPrefixTokens hs) origin next).
  { intros next; apply CrtosInsideEnvironment_excluded; exact Hnonempty. }
  assert (Hidentity : forall x y,
    Relation_Operators.clos_refl_trans CrtosProtocolState
      (CrtosEnvironmentStep (CrtosPrefixTokens hs)) x y -> x = origin -> y = origin).
  { intros x y Hsteps; induction Hsteps; intro Horigin.
    - subst x. exfalso. eapply Hblocked; exact H.
    - exact Horigin.
    - apply IHHsteps2. apply IHHsteps1. exact Horigin. }
  exact (Hidentity _ _ Hreach eq_refl).
Qed.

Lemma SemaphoreRely_nested_identity : forall hs before current,
  hs <> nil -> SemaphoreRely hs before current -> current = before.
Proof.
  intros hs before current Hnonempty [_ [_ [Hnest Hreach]]].
  pose proof (CrtosInsideEnvironment_reachable_identity _ _ _ Hnonempty Hreach) as Heq.
  apply CrtosOSProtected_and_nest_injective; [|symmetry; exact Hnest].
  exact (f_equal state_of_NCS Heq).
Qed.

Lemma SemaphoreRely_refl : forall hs state,
  CrtosOSValid state -> SemaphoreRely hs state state.
Proof.
  intros hs state Hvalid. unfold SemaphoreRely.
  split; [exact Hvalid|]. split; [exact Hvalid|]. split; [reflexivity|].
  apply Relation_Operators.rt_refl.
Qed.

(** caller prefix与invariant后缀精确分区全部nat tokens。 *)
Lemma CrtosPrefixTokens_partition : forall hs state,
  handlers_of_NCS state = hs ->
  @ConAssertion.TokenSet_join Crtos_STS.sts
    (CrtosPrefixTokens hs) (ConAssertion.InvownedToken (STS:=Crtos_STS.sts) state) Sets.full.
Proof.
  intros hs state Hstack.
  unfold ConAssertion.TokenSet_join, CrtosPrefixTokens; cbn.
  rewrite Hstack. split; sets_unfold; intros; lia.
Qed.

Lemma CrtosPrefixTokens_not_duplicable : forall hs all_tokens,
  hs <> nil ->
  ~ @ConAssertion.TokenSet_join Crtos_STS.sts
       (CrtosPrefixTokens hs) (CrtosPrefixTokens hs) all_tokens.
Proof.
  intros hs all_tokens Hnonempty [_ Hdisjoint].
  assert (Hdepth : (0 < List.length hs)%nat).
  { destruct hs; cbn in *; [contradiction|lia]. }
  specialize (Hdisjoint 0%nat). sets_unfold in Hdisjoint.
  unfold CrtosPrefixTokens in Hdisjoint. tauto.
Qed.

(** 真实Enter/Exit恢复完整原handler栈和全部caller tokens；不声称物理counter无界。 *)
Lemma CrtosIRQ_enter_exit_restores_stack : forall hs handler before after,
  semaphore_irq_stack_ok (handler :: hs) -> CrtosOSTransition before after ->
  CrtosIRQStep
    (Build_nested_critical_state Crtos_C_STS.c_sts hs before, CrtosPrefixTokens hs)
    (Build_nested_critical_state Crtos_C_STS.c_sts (handler :: hs) before,
      CrtosPrefixTokens (handler :: hs)) /\
  CrtosIRQStep
    (Build_nested_critical_state Crtos_C_STS.c_sts (handler :: hs) before,
      CrtosPrefixTokens (handler :: hs))
    (Build_nested_critical_state Crtos_C_STS.c_sts hs after, CrtosPrefixTokens hs).
Proof.
  intros hs handler before after Hhandlers Htransition; split.
  - constructor; [exact Hhandlers|reflexivity|reflexivity].
  - constructor; [exact Hhandlers|exact Htransition|reflexivity|reflexivity].
Qed.

(** 新批准的counter域随真实acquire的Rely保持；原IRQ合同无须增加cap。 *)
Lemma SemaphoreRely_preserves_create_domain : forall hs before current,
  SemaphoreRely hs before current ->
  before.(os_scheduler).(scheduler_lock_nest) < 65535 ->
  current.(os_scheduler).(scheduler_lock_nest) < 65535.
Proof. intros hs before current [_ [_ [Hnest _]]] Hbound; rewrite <- Hnest; exact Hbound. Qed.
