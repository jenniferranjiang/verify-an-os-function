Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem StoreAux ArrayLib MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.
Require Export CRTOS_Verify.lib.SemaphorePure.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.

(**
  协议状态同时携带稳定地址和可变 semaphore state。合法转换保持稳定
  部分不变，并允许可变部分沿 [SemaphoreRTrans] 前进。
*)
Definition SemaphoreWorldState : Type :=
  (SemaphoreStable * SemaphoreState)%type.

Definition semaphore_world_transition
    (before after : SemaphoreWorldState) : Prop :=
  fst after = fst before /\
  SemaphoreRTrans (fst before) (snd before) (snd after) /\
  semaphore_world_wf (fst after) (snd after).

(** 一次外层 unlock 的本地提交：稳定部分不变，且只有一步。 *)
Definition semaphore_world_one_call
    (before after : SemaphoreWorldState) : Prop :=
  fst after = fst before /\
  SemaphoreOneCallGTrans (fst before) (snd before) (snd after) /\
  semaphore_world_wf (fst after) (snd after).

(**
  [SemaphoreNestedState] 是 CRTOS 非 SMP IRQ critical 的协议状态：handler
  栈保存每层 [DisableLocalInterrupt] 返回的 PRIMASK，world 保存同一稳定
  配置下的 semaphore state。

  QCP 8.20 当前分发的 [NestedCriticalSTS.vo] 与 [ArrayLib.vo] 有不一致
  编译假设，无法被 Rocq 装载；这里按其公开 source 定义保留最小同型协议，
  不引入额外 token record 或未经证明的公理。
*)
Record SemaphoreNestedState : Type := Build_SemaphoreNestedState {
  semaphore_saved_handlers : list Z;
  semaphore_nested_world : SemaphoreWorldState;
}.

(** Cortex-M3 PRIMASK 的保存值只可能是 0 或 1。 *)
Definition SemaphoreHandlersWf (handlers : list Z) : Prop :=
  Forall (fun handler => handler = 0 \/ handler = 1) handlers /\
  Z.of_nat (List.length handlers) <= 65535.

(** 再进入一层前 counter 必须尚未达到 uint16 上限。 *)
Definition SemaphoreCanEnter (handlers : list Z) : Prop :=
  Z.of_nat (List.length handlers) < 65535.

Inductive semaphore_nested_transition
    : SemaphoreNestedState -> (nat -> Prop) ->
      SemaphoreNestedState -> (nat -> Prop) -> Prop :=
| SemaphoreEnterCritical : forall handler handlers world held,
    (handler = 0 \/ handler = 1) ->
    SemaphoreCanEnter handlers ->
    (forall n, n >= List.length handlers -> ~ n ∈ held)%nat ->
    semaphore_nested_transition
      (Build_SemaphoreNestedState handlers world) held
      (Build_SemaphoreNestedState (handler :: handlers) world)
      (held ∪ [List.length handlers])
| SemaphoreExitCritical : forall handler handlers before after held,
    (forall n, n >= List.length handlers -> ~ n ∈ held)%nat ->
    semaphore_world_one_call before after ->
    semaphore_nested_transition
      (Build_SemaphoreNestedState (handler :: handlers) before)
      (held ∪ [List.length handlers])
      (Build_SemaphoreNestedState handlers after) held.

(** QCP [ConAssertion.STS] 上的具体 nested-critical 实例。 *)
Definition semaphore_nested_protocol : ConAssertion.STS :=
  {| ConAssertion.token := nat;
     ConAssertion.STS_state := SemaphoreNestedState;
     ConAssertion.Transition := fun before after =>
       semaphore_nested_transition
         (fst before) (snd before) (fst after) (snd after);
     ConAssertion.InvownedToken := fun state n =>
       (n >= List.length (semaphore_saved_handlers state))%nat |}.

Module SemaphoreNestedSTS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS := semaphore_nested_protocol.
End SemaphoreNestedSTS.

(**
  [Semaphore_C_Rules] 是本 trial 所有 spatial predicate 使用的唯一并发
  assertion carrier；DLL、ID manager 与 semaphore object 不得混入
  naive 或 Task 专用 carrier。
*)
Module Semaphore_C_Rules.
  Include SemaphoreNestedSTS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
  Include MapLibSig.
End Semaphore_C_Rules.

Export Semaphore_C_Rules.

Local Open Scope sac.

(**
  [SemaphoreCritical handlers sg st] 直接实例化 QCP
  [NestedCriticalCSL.Critical] 的定义。空 handler 栈表示临界区外；非空栈
  精确记录每层保存的 IRQ level，并持有相应嵌套 token。
*)
Definition SemaphoreCritical
    (handlers : list Z) (sg : SemaphoreStable) (st : SemaphoreState)
    : Assertion :=
  “ handlers = nil /\ SemaphoreHandlersWf handlers ” &&
    EX observed,
      “ semaphore_world_transition (sg, st) observed ” &&
      at_states (fun cs =>
        exists current,
          cs = Build_SemaphoreNestedState nil current /\
          semaphore_world_transition observed current) **
      has_tokens Sets.empty
  ||
  “ handlers <> nil /\ SemaphoreHandlersWf handlers ” &&
    at_states (fun cs =>
      exists prefix,
        cs = Build_SemaphoreNestedState (prefix ++ handlers) (sg, st)) **
    has_tokens (fun n => n < List.length handlers)%nat.

(** 临界区外是空 handler 栈的专名，供公开 API contract 直接读取。 *)
Definition SemaphoreOutsideCritical
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  SemaphoreCritical nil sg st.

(** 临界区内视图显式要求至少保存了一层 IRQ level。 *)
Definition SemaphoreInsideCritical
    (handlers : list Z) (sg : SemaphoreStable) (st : SemaphoreState)
    : Assertion :=
  “ handlers <> nil ” && SemaphoreCritical handlers sg st.

Definition SemaphoreCriticalRTrans := semaphore_world_transition.
Definition SemaphoreCriticalGTrans := semaphore_world_one_call.

(** C annotation 直接使用的三参数 guarantee 视图。 *)
Definition SemaphoreGuarantee
    (sg : SemaphoreStable) (before after : SemaphoreState) : Prop :=
  SemaphoreOneCallGTrans sg before after /\
  semaphore_world_wf sg after.

(**
  已在临界区内时环境不能在同一 CPU 上推进 semaphore state；临界区外
  则使用模块完整 rely closure。这一入口可见性供 public safeExec 使用。
*)
Definition SemaphoreVisible
    (sg : SemaphoreStable) (handlers : list Z) (before : SemaphoreState)
    : SemaphoreState -> Prop :=
  match handlers with
  | nil => SemaphoreLastSeen sg before
  | _ => fun current => current = before
  end.
