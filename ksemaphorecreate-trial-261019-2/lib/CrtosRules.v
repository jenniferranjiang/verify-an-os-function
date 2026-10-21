Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Import CRTOS_Verify.lib.NonemptyCSL.
Require Export CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.CrtosGlobState.

Import ListNotations.

Local Open Scope Z_scope.

Local Open Scope sets.
Local Open Scope string.

(** 扩展后的全局状态统一实例化到 QCP CriticalSTS；纯上下文先于空间不变量。 *)

(** 全局纯OS状态与真实Cortex-M3 PRIMASK同处一个STS。
    unit token表示非SMP CPU排他权限：IRQ开启的outside交给invariant，
    IRQ关闭的outside和inside均由caller持有。outside/inside区分共享
    内存投影是否已转交，不等同于IRQ开/关，也不另建模块私有协议。 *)
Record CrtosIRQState : Type := {
  irq_shared : VarGlobalState;
  irq_mask : Z
}.
Definition Crtos_CS : critical_STS := {|
  critical_STS_state := CrtosIRQState;
  critical_STS_transition := fun _ _ => True
|}.

(** IRQ 保存/关闭及恢复操作与 token 交接是同一个全局协议步骤。
    已关 IRQ 的 outer acquire 也可取得 token；真正 nested 调用保持原 token。
    释放时 saved 来自 C 局部保存值，允许恢复 0 或 1。 *)
Inductive CrtosIRQTransition :
    (@critical_state Crtos_CS * (unit -> Prop)) ->
    (@critical_state Crtos_CS * (unit -> Prop)) -> Prop :=
| IRQEnter : forall st saved, saved = 0 \/ saved = 1 ->
    CrtosIRQTransition
      (@outside_state Crtos_CS {| irq_shared := st; irq_mask := saved |},
       if Z.eq_dec saved 0 then Sets.empty else Sets.full)
      (@inside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |}, Sets.full)
| IRQLeave : forall anchor after saved, saved = 0 \/ saved = 1 ->
    CrtosIRQTransition
      (@inside_state Crtos_CS {| irq_shared := anchor; irq_mask := 1 |}, Sets.full)
      (@outside_state Crtos_CS {| irq_shared := after; irq_mask := saved |},
       if Z.eq_dec saved 0 then Sets.empty else Sets.full).

Module Crtos_STS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS := {|
    ConAssertion.token := unit;
    ConAssertion.STS_state := @critical_state Crtos_CS;
    ConAssertion.Transition := CrtosIRQTransition;
    ConAssertion.InvownedToken := fun cs =>
      match cs with
      | inside_state _ => Sets.empty
      | outside_state state =>
          if Z.eq_dec state.(irq_mask) 0 then Sets.full else Sets.empty
      end
  |}.
End Crtos_STS.

(** 本项目的内存谓词统一实例化到这个 CriticalSTS 断言模型。 *)
Module Crtos_C_Rules.
  Include Crtos_STS.
  Include NonemptyCSL.NonemptyCSL.
  Include DerivedPredSig Arch32 LittleEndian.
  Include StoreLibSig Arch32 LittleEndian.
  Include ArrayLibSig Arch32 LittleEndian.
  Include Array2LibSig Arch32 LittleEndian.
  Include PtrArray2LibSig Arch32 LittleEndian.
  Include MapLibSig Arch32 LittleEndian.
  Include StringLibSig Arch32 LittleEndian.
End Crtos_C_Rules.

Export Crtos_C_Rules.

Local Open Scope sac.

(** 同一全局 CriticalSTS 的直接资源解释。QCP has_tokens 的 s_STS 为空，
    不能与 at_states 以 ** 组合，否则交集会丢掉真实 IRQ 观察。
    此处在同一 Lstate 同时持有非空 singleton 和唯一 unit token。
    inside_state 必须PRIMASK=1；outside_state保存真实0/1及相应权限。 *)
Definition InsideCritical
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  fun model => os_global_context sg /\
    ConAssertion.s_mem (raw model) = empty_mem /\
    Sets.equiv (ConAssertion.s_STS (raw model))
      (Sets.singleton (@inside_state Crtos_CS {| irq_shared := st; irq_mask := 1 |})) /\
    Sets.equiv (ConAssertion.s_token (raw model)) Sets.full.

(** IRQ 开启时，环境可按同一 Crtos_CS 关系推进共享状态；非空集合保存观察。
    mask=0没有排他token；mask=1持token且禁止环境推进。两种outside都不
    拥有模块共享投影，投影由同一全局协议invariant保存。 *)
Definition OutsideCriticalIRQ (mask : Z)
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  fun model => os_global_context sg /\ (mask = 0 \/ mask = 1) /\
    ConAssertion.s_mem (raw model) = empty_mem /\
    Sets.equiv (ConAssertion.s_STS (raw model))
      (fun cs => exists current, cs = @outside_state Crtos_CS {| irq_shared := current; irq_mask := mask |} /\
         (mask = 0 \/ current = st)) /\
    Sets.equiv (ConAssertion.s_token (raw model))
      (if Z.eq_dec mask 0 then Sets.empty else Sets.full).

(** 兼容共享接口的默认 IRQ 开启入口。Cortex-M3 的完整 caller 契约使用
    OutsideCriticalIRQ，显式覆盖已经关 IRQ 但尚未取得共享投影的情形。 *)
Definition OutsideCritical (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  OutsideCriticalIRQ 0 sg st.

(** 加锁和解锁分别使用同一 CriticalSTS 关系的 rely/guarantee 接口。 *)
Definition Crtos_RTrans (before after : VarGlobalState) : Prop :=
  @critical_STS_transition Crtos_CS {| irq_shared := before; irq_mask := 0 |}
    {| irq_shared := after; irq_mask := 0 |}.

Definition Crtos_GTrans (before after : VarGlobalState) : Prop :=
  @critical_STS_transition Crtos_CS {| irq_shared := before; irq_mask := 1 |}
    {| irq_shared := after; irq_mask := 1 |}.

Lemma Crtos_RTrans_refl : forall st, Crtos_RTrans st st.
Proof.
  intros st. exact I.
Qed.

(**
  [task_atomic_cmd cmd] 对应 LOS_Verify/Los_Rules_lib.v 的 [atomic_cmd]：
  把单个 [VarGlobalState] 上的原子关系提升为状态集合上的抽象程序。
  从前态集合选取实际加锁观察 [before]，执行 [cmd.(nrm)] 得到返回值和 [after]，
  解锁后的隐藏状态集合固定为 [Crtos_RTrans after]。

  唯一显式参数 [cmd] 描述临界区内的功能关系。环境 rely 由项目的临界区
  协议统一确定，不由调用者或返回值选择。这里只提升整个全局状态；若以后
  引入子状态提升，须像 LiteOS 的 [atomic_tsk_cmd] 一样保持其余全局分量。

  输入集合中任一可选观察发生 cmd.err，原子程序即可能出错；不能只保留正常关系。
  该定义只描述纯抽象程序，不拥有 C 内存；具体共享内存仍由
  [critical_projection] 在 CriticalArea Specs 中提供。多段临界区使用 bind 组合
  多个提升后的命令；无加锁的提前返回保留为 ret，不凭空增加原子观察。
*)
Definition task_atomic_cmd {A : Type}
    (cmd : program VarGlobalState A)
    : program (VarGlobalState -> Prop) A :=
  {| MonadErr.nrm := fun states_before result states_after =>
       exists before after,
         states_before before /\
         cmd.(MonadErr.nrm) before result after /\
         states_after == Crtos_RTrans after;
     MonadErr.err := fun states_before =>
       exists before, states_before before /\ cmd.(MonadErr.err) before |}.

(**
  用户指定的空临界区调度模型：观察允许的 rely 前态，原样归还共享状态，
  返回 tt，并留下新的 rely 闭包。它不读取或修改共享字段，也不需要额外
  调用者内存；锁协议资源仍由 OutsideCritical/InsideCritical 维护。
  此处不区分主动让出与普通抢占，不承诺调度公平性、下一任务或终止。
*)
Definition abs_ktask_assign : program (VarGlobalState -> Prop) unit :=
  task_atomic_cmd (MonadErr.ret tt).

(** 抽象continuation使用共享rely闭包；masked入口精确观察当前状态。 *)
Definition LastSeen (st : VarGlobalState) : (VarGlobalState -> Prop) -> Prop :=
  fun states => states == Crtos_RTrans st.
Definition ExactSeen (st : VarGlobalState) : VarGlobalState -> Prop :=
  fun current => current = st.

(** 当前闭包只跨IRQ边界保留普通heap frame；它不限制IRQ观察、也不持
    协议token。任意未稳定ghost observation不得套用跨IRQ的frame规则。 *)
Definition HeapFrame (F : Assertion) : Prop :=
  forall m, F m ->
    Sets.equiv (ConAssertion.s_STS (raw m)) Sets.full /\
    Sets.equiv (ConAssertion.s_token (raw m)) Sets.empty.

Lemma irq_transition_tokens_preserved :
  @ConAssertion.transition_token_preserved Crtos_STS.sts CrtosIRQTransition.
Proof.
  intros s1 s2 tokens1 tokens2 tf Hstep.
  inversion Hstep; subst; simpl; destruct (Z.eq_dec saved 0); simpl.
  all: unfold ConAssertion.TokenSet_join; sets_unfold; firstorder.
Qed.

Lemma irq_transition_tokens_disjoint :
  @ConAssertion.transtion_disjoint_preserved Crtos_STS.sts CrtosIRQTransition.
Proof.
  intros s1 s2 tokens1 tokens2 Hstep.
  inversion Hstep; subst; simpl; destruct (Z.eq_dec saved 0); simpl; sets_unfold; firstorder.
Qed.
