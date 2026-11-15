Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.common.CrtosRules.
Require Export InitDataqueueTrial.lib.CrtosGlobState.
From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
Require Import SetsClass.SetsClass.
Import MonadErr Monad MonadNotation SetsNotation.
Local Open Scope Z_scope.
Local Open Scope monad.
Local Open Scope sac.
Local Open Scope sets.
Module CoreRules := CRTOS_Verify.lib.common.CrtosRules.

(** 唯一Assertion carrier、旧STS与unit token全部直接来自根CrtosRules；
    本文件没有重新实例化模块。实际总状态沿用扩展的flat VarGlobalState，
    内外token通过project_core联系既有协议。新共享队列资源在CrtosInv中
    的完整os_inv被同一Lock交接，不会由该投影凭空产生内存权限。 *)
Definition InsideCritical (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  CoreRules.InsideCritical sg (project_core st).
Definition OutsideCritical (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  CoreRules.OutsideCritical sg (project_core st).
Definition Crtos_RTrans (before after : VarGlobalState) : Prop :=
  CoreRules.Crtos_RTrans (project_core before) (project_core after).
Definition Crtos_GTrans (before after : VarGlobalState) : Prop :=
  CoreRules.Crtos_GTrans (project_core before) (project_core after).
Definition LastSeen (st : VarGlobalState) : (VarGlobalState -> Prop) -> Prop :=
  fun states => states == Crtos_RTrans st.

(** 旧helper明确保留根状态域及旧协议语义，不能只将其With类型换成扩展
    record后声称原证明仍适用；queue invariant在调用时由普通frame保持。 *)
Definition core_OutsideCritical := CoreRules.OutsideCritical.
Definition core_LastSeen := CoreRules.LastSeen.

(** 纯core命令保守提升，正常结果/error沿用原定义，新增map逐字保持。
    具体C调用还须拆出根invariant、frame队列并恢复总invariant，不将这个
    Definition冒称为已有C实现证明自动提升。 *)
Definition lift_core {A : Type} (command : program CoreVarGlobalState A)
    : program VarGlobalState A :=
  {| nrm := fun before result after =>
       nrm command (project_core before) result (project_core after) /\
       after.(os_dataqueues) = before.(os_dataqueues);
     err := fun before => err command (project_core before) |}.

(** 完整flat总状态上的原子观察。rely仍为原True关系，允许queue在锁外变化；
    不添加更强稳定性或硬件IRQ断言。Inside token虽投影core，实际heap的
    queue witness由primitive的完整protected-invariant schema借出/收回。 *)
Definition os_atomic_cmd {A : Type} (command : program VarGlobalState A)
    : program (VarGlobalState -> Prop) A :=
  {| nrm := fun states result next_states =>
       exists before after,
         states before /\ nrm command before result after /\
         next_states == Crtos_RTrans after;
     err := fun states => exists before, states before /\ err command before |}.
