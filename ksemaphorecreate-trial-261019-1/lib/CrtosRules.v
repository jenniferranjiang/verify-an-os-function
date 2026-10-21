Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import SetsClass.SetsClass.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
From SimpleC.SL Require Import Mem SeparationLogic ConAssertion CriticalSTS.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosGlobState.
Import SetsNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.

(** 同一 CRTOS 全局协议的锁token和处理器PRIMASK权限；没有信号量专属STS。
    IRQ不是内存映射寄存器，故其权限在STS里表示，绝不伪造C全局地址。 *)
Inductive CrtosToken := GlobalCriticalToken | ProcessorIRQToken.
Definition critical_tokens : CrtosToken -> Prop := fun t => t = GlobalCriticalToken.
Definition irq_tokens : CrtosToken -> Prop := fun t => t = ProcessorIRQToken.
Definition both_tokens : CrtosToken -> Prop := fun _ => True.
Definition no_tokens : CrtosToken -> Prop := fun _ => False.
Definition irq_bit (q : Z) : Prop := q = 0 \/ q = 1.
Definition Crtos_CS : critical_STS := {|
 critical_STS_state := VarGlobalState;
 critical_STS_transition := fun _ _ => True |}.
Definition CrtosMachineState := (@critical_state Crtos_CS * Z)%type.

(** token流与实际cpsid/msr步骤同步。KTaskOsAssignLockNest只是C计数，
    可能溢出，不用它表示锁token的持有层数。环境只能在outside改变共享状态，
    并保持调用者持有的PRIMASK。进入/退出需要同时消费IRQ权限。 *)
Inductive CrtosTransition :
 (CrtosMachineState * (CrtosToken -> Prop)) ->
 (CrtosMachineState * (CrtosToken -> Prop)) -> Prop :=
| crtos_enter : forall st q, irq_bit q -> CrtosTransition
   ((outside_state st,q),irq_tokens) ((inside_state st,1),both_tokens)
| crtos_exit : forall before after q, irq_bit q -> CrtosTransition
   ((inside_state before,1),both_tokens) ((outside_state after,q),irq_tokens)
| crtos_nested : forall st, CrtosTransition
   ((inside_state st,1),both_tokens) ((inside_state st,1),both_tokens)
| crtos_locked_update : forall before after, CrtosTransition
   ((inside_state before,1),both_tokens) ((inside_state after,1),both_tokens)
| crtos_environment : forall before after, CrtosTransition
   ((outside_state before,0),no_tokens) ((outside_state after,0),no_tokens).

Module Crtos_STS <: STS_def.
 Definition sts : STS := {|
  token := CrtosToken; STS_state := CrtosMachineState;
  Transition := CrtosTransition;
  InvownedToken := fun s => match fst s with
      | inside_state _ => no_tokens | outside_state _ => critical_tokens end |}.
End Crtos_STS.
Module Crtos_C_Rules.
 Include Crtos_STS.
 Include ConAssertion.CSL.
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

(** QCP has_tokens 的s_STS是empty，与state_join的交集组合会抹掉观察。
    这里在同一载体上使用full作为token断言的中性观察，保留IRQ精确状态。 *)
Definition owns_tokens (T : CrtosToken -> Prop) : Assertion :=
 fun s => s.(s_mem) = empty_mem /\ s.(s_STS) == Sets.full /\ T == s.(s_token).

(** InsideCritical只持唯一全局锁权限，PRIMASK权限另由IRQMask持有。
    inside状态总是屏蔽IRQ；共享内存由slice_OS_inv在取得/归还时交接。 *)
Definition InsideCritical (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
 “ os_global_context sg ” &&
 at_states (fun s => fst s = @inside_state Crtos_CS st /\ snd s = 1) **
 owns_tokens critical_tokens.
(** 与原全局rely一致，outside观察允许环境推进，不声称入口快照不变。 *)
Definition OutsideCritical (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
 “ os_global_context sg ” &&
 at_states (fun s => exists current, fst s = @outside_state Crtos_CS current /\ irq_bit (snd s)).
(** q是实际Cortex-M3 PRIMASK位；唯一IRQ token防止复制或凭纯命题捏造硬件状态。 *)
Definition IRQMask (q : Z) : Assertion :=
 “ irq_bit q ” && at_states (fun s => snd s = q) ** owns_tokens irq_tokens.
Definition Crtos_RTrans (_ _ : VarGlobalState) : Prop := True.
Definition Crtos_GTrans (_ _ : VarGlobalState) : Prop := True.
Definition LastSeen (st : VarGlobalState) : (VarGlobalState -> Prop) -> Prop :=
 fun P => P == Crtos_RTrans st.
Definition ExactSeen (st : VarGlobalState) : VarGlobalState -> Prop := fun current => current = st.
(** 沿用全局atomic提升：先取环境可达观察，操作后回到同一rely闭包。 *)
Definition task_atomic_cmd {A : Type} (cmd : program VarGlobalState A)
 : program (VarGlobalState -> Prop) A :=
 {| MonadErr.nrm := fun P r Q => exists before after,
       P before /\ cmd.(MonadErr.nrm) before r after /\ Q == Crtos_RTrans after;
    MonadErr.err := fun P => exists before, P before /\ cmd.(MonadErr.err) before |}.
