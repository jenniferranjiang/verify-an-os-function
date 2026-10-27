Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
From MonadLib.MonadErr Require Import MonadErrBasic.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Export CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.CrtosGlobState.

Import ListNotations.

Local Open Scope Z_scope.

Local Open Scope sets.
Local Open Scope string.

(** 扩展后的全局状态统一实例化到 QCP CriticalSTS；纯上下文先于空间不变量。 *)

(**
  [Crtos_CS] 恢复原有的 CriticalSTS 模型：STS 只保存受临界区保护的
  [VarGlobalState]，使用 QCP 提供的唯一 [unit] 锁 token。

  与 liteos-legacy 的抽象临界区模型一致，rely 和 guarantee 共用
  [True] 关系，不再携带任务创建 reservation 或 owner 权限。
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
  Include DerivedPredSig Arch32 BigEndian.
  Include StoreLibSig Arch32 BigEndian.
  Include ArrayLibSig Arch32 BigEndian.
  Include Array2LibSig Arch32 BigEndian.
  Include PtrArray2LibSig Arch32 BigEndian.
  Include MapLibSig Arch32 BigEndian.
  Include StringLibSig Arch32 BigEndian.
  Include CriticalCSL.
End Crtos_C_Rules.

Export Crtos_C_Rules.

Local Open Scope sac.

(**
  [InsideCritical sg st] 表示当前线程持有临界区锁 token，进入时观察
  到状态 [st]。这里只保留纯 os_global_context 与 QCP 锁状态；
  所有共享内存（包括 done 表）由 os_inv 中对应模块的不变量提供。
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
  [os_inv] 在 CriticalArea Specs 中提供。多段临界区使用 bind 组合
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

