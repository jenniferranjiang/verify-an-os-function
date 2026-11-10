Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Require Import Coq.Classes.Morphisms.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Export CRTOS_Verify.lib.id.idnode_abs.
Require Export CRTOS_Verify.lib.common.CrtosGlobState.

Import ListNotations.

Local Open Scope Z_scope.

Local Open Scope sets.
Local Open Scope string.

Import Monad MonadNotation.
Local Open Scope monad.

(** 纯命题分支复用 QCP 的 if_else；常量 test 与 assume!! 定义相同。
    状态类型保持多态，兼容锁内状态及 OC 的状态集合。守卫只过滤行为，
    不承担 assertS 的调用者义务；未选分支的正常行为和错误均不可达。 *)
Notation IF P c1 c2 := (if_else (fun _ => P) c1 c2) (only parsing).

(** 两个任意守卫允许重叠或缺口，不自动表示确定性条件分支。
    迁移普通 if 时须证明 Q <-> ~ P；否则可能增加或过滤原有行为。 *)
Definition if_pure_case {S A : Type} (P Q : Prop) (c1 c2 : program S A)
    : program S A :=
  choice (assume!! P ;; c1) (assume!! Q ;; c2).

(** 为原生程序等价补足投影与 WLP 的改写接口；safeExec 的相应
    Proper 实例已由 QCP 提供，始终保留其存在初态见证。 *)
#[export] Instance program_nrm_equiv {S A} :
  Proper (@ProgramPO.equiv S A ==> eq ==> eq ==> eq ==> iff) (@MonadErr.nrm S A).
Proof. intros c d H s ? <- r ? <- t ? <-. exact (@ProgramPO.nrmequiv S A c d H s r t). Qed.

#[export] Instance program_err_equiv {S A} :
  Proper (@ProgramPO.equiv S A ==> eq ==> iff) (@MonadErr.err S A).
Proof. intros c d H s ? <-. exact (@ProgramPO.errequiv S A c d H s). Qed.

#[export] Instance program_wp_equiv {S A} :
  Proper (@ProgramPO.equiv S A ==> eq ==> eq ==> iff) (@weakestpre S A).
Proof.
  intros c d H Q ? <- s ? <-. exact (iff_sym (wp_progequiv d c Q H s)).
Qed.

(** 保留用于 nrm、err、WLP 及组合程序内部的分支改写；
    顶层 safeExec 消费直接使用 QCP 的 choice/test 规则。 *)
Lemma if_pure_cond_true {S A} P (c1 c2 : program S A) :
  P -> ProgramPO.equiv (IF P c1 c2) c1.
Proof.
  intro HP. unfold if_else.
  etransitivity; [apply choice_l_equiv, (assume_false_equiv (~ P) c2); tauto |].
  exact (assume_equiv P c1 HP).
Qed.

Lemma if_pure_cond_false {S A} P (c1 c2 : program S A) :
  ~ P -> ProgramPO.equiv (IF P c1 c2) c2.
Proof.
  intro HP. unfold if_else.
  etransitivity; [apply choice_r_equiv, (assume_false_equiv P c1); exact HP |].
  exact (assume_equiv (~ P) c2 HP).
Qed.

(** 扩展后的全局状态统一实例化到 QCP CriticalSTS；纯上下文先于空间不变量。 *)

(**
  [Crtos_CS] 恢复原有的 CriticalSTS 模型：STS 只保存受临界区保护的
  [VarGlobalState]，使用 QCP 提供的唯一 [unit] 锁 token。

  rely 和 guarantee 对 OS 数据保持既有宽松关系，不记录硬件中断状态。
  中断保存、关闭和恢复不在当前模型的验证范围；协议只描述资源交接。
  稳定地址、固定配置和函数表由外围 [sg] 原样传递；共享内存仍由
  [os_inv] 在进入时交给调用者，并在退出时收回。
*)
Definition Crtos_CS : critical_STS := {|
  critical_STS_state := VarGlobalState;
  critical_STS_transition := fun _ _ => True
|}.

Module Crtos_STS <: critical_STS_def.
  Definition c_sts : critical_STS := Crtos_CS.
End Crtos_STS.

(** 本项目的内存谓词统一实例化到这个 CriticalSTS 断言模型。 *)
Module Crtos_C_Rules.
  Include Crtos_STS.
  Include critical_STS_to_STS_def.
  Include ConAssertion.CSL.
  Include DerivedPredSig Arch32 LittleEndian.
  Include StoreLibSig Arch32 LittleEndian.
  Include ArrayLibSig Arch32 LittleEndian.
  Include Array2LibSig Arch32 LittleEndian.
  Include PtrArray2LibSig Arch32 LittleEndian.
  Include MapLibSig Arch32 LittleEndian.
  Include StringLibSig Arch32 LittleEndian.
  Include CriticalCSL.
End Crtos_C_Rules.

Export Crtos_C_Rules.

Local Open Scope sac.

(**
  [InsideCritical sg st] 表示当前线程持有临界区锁 token，进入时观察
  到状态 [st]。这里只保留纯 os_global_context 与 QCP 锁状态；
  所有共享内存由 os_inv 中对应模块的不变量提供；共享库按
  Cortex-M3 LittleEndian 实例化全部store接口。
*)
Definition InsideCritical
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ os_global_context sg ” && Crtos_C_Rules.InsideCritical st.

(** 临界区外只保留环境可能推进的状态观察，不持有临界区锁 token。 *)
Definition OutsideCritical
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ os_global_context sg ” && Crtos_C_Rules.OutsideCritical st.

(** 加锁和解锁分别使用同一 CriticalSTS 关系的 rely/guarantee 接口。 *)
Definition Crtos_RTrans (before after : VarGlobalState) : Prop :=
  Crtos_C_Rules.RTrans before after.

Definition Crtos_GTrans (before after : VarGlobalState) : Prop :=
  Crtos_C_Rules.GTrans before after.

Lemma Crtos_RTrans_refl : forall st, Crtos_RTrans st st.
Proof.
  intros st. reflexivity.
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
  [os_inv] 在 CriticalArea Specs 中提供。多段临界区使用 bind 组合
  多个提升后的命令；无加锁的提前返回保留为 ret，不凭空增加原子观察。
*)
Definition os_atomic_cmd {A : Type}
    (cmd : program VarGlobalState A)
    : program (VarGlobalState -> Prop) A :=
  {| MonadErr.nrm := fun states_before result states_after =>
       exists before after,
         states_before before /\
         cmd.(MonadErr.nrm) before result after /\
         states_after == Crtos_RTrans after;
     MonadErr.err := fun states_before =>
       exists before, states_before before /\ cmd.(MonadErr.err) before |}.


(** Compatibility name used by restored task specifications. *)
Definition task_atomic_cmd {A : Type} := @os_atomic_cmd A.


(** 真实非SMP临界区计数单元；Disable交出0，Lock改1，Unlock归0再Enable归还。
    Outside/Inside 采用同一 QCP phase token，仅描述协议阶段及资源交接。
    Disable/Enable 的 trusted 接口在当前范围内抽象为取得/归还资源；
    不对硬件中断状态作断言。使用创建函数的普通入口时排除已持有临界区资源者；
    此计数谓词本身不限制其他接口的嵌套层数。 *)
Definition CriticalNest (n : Z) : Assertion :=
  &("KTaskOsAssignLockNest") # UShort |-> n.
(** 抽象调用入口所见状态集合允许共享 OS 状态按 rely 变化，不含硬件中断状态。 *)
Definition LastSeen (st : VarGlobalState) :
    (VarGlobalState -> Prop) -> Prop :=
  fun states => states == Crtos_RTrans st.
