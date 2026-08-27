Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic.
From SimpleC.SL Require Import CriticalSTS.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.
Require Import CRTOS_Verify.lib.NestedCriticalSTS.
Require Export CRTOS_Verify.lib.SemaphorePure.

Import ListNotations SetsNotation.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list_scope.

(**
  只实例化项目 [NestedCriticalSTS]。本 STS 追踪 semaphore 模块状态；
  Task/ready/Delay/ISR 是 direct-callee 的外部资源接口，不被本模块重复拥有。
  handler/token machinery 完全复用项目实现，不在本模块另造一套 STS。
*)
Definition semaphore_crtos_critical_STS : critical_STS := {|
  critical_STS_state := SemaphoreState;
  critical_STS_transition :=
    SemaphoreTransition semaphore_fixed_stable
|}.

Module Semaphore_C_STS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS :=
    nested_critical_STS_to_STS semaphore_crtos_critical_STS.
End Semaphore_C_STS.

(**
  semaphore 的 DLL、ID manager、对象 predicate 与 critical token 全部使用
  同一 assertion carrier，避免把共享内存与协议权限放进不兼容的模型。
*)
Module Semaphore_C_Rules <: SeparationLogicSig.
  Include Semaphore_C_STS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
End Semaphore_C_Rules.

Export Semaphore_C_Rules.

Local Open Scope sac.

Definition SemaphoreRTrans : SemaphoreState -> SemaphoreState -> Prop :=
  SemaphoreTransition semaphore_fixed_stable.

Definition SemaphoreGTrans : SemaphoreState -> SemaphoreState -> Prop :=
  SemaphoreTransition semaphore_fixed_stable.

(** outermost lock 可观察 rely 推进；已经持锁时 nested acquire 不改变 state。 *)
Definition SemaphoreAcquireTrans
    (handlers : list Z) (before after : SemaphoreState) : Prop :=
  match handlers with
  | nil => SemaphoreRTrans before after
  | _ :: _ => after = before
  end.

(** uint16 nest counter 再 push 一层仍不回绕。 *)
Definition SemaphoreCanAcquire (handlers : list Z) : Prop :=
  (Z.of_nat (List.length handlers) < 65535)%Z.

Definition SemaphoreHandlerDepth (handlers : list Z) : Z :=
  Z.of_nat (List.length handlers).

(** 非 SMP [CriticalArea.c] 中唯一物理 nest counter 的精确 owner。 *)
Definition store_crtos_lock_nest (depth : Z) : Assertion :=
  &("KTaskOsAssignLockNest") # UShort
    |-> depth.

(**
  counter-free的nested-critical core只拥有STS current、tokens与状态有效性；
  它专供raw IRQ API与物理counter自增/自减之间的中间态使用。非空
  [handlers]仍是完整exact-top stack，tokens恰为0..length-1；真实counter
  由下方完整[SemaphoreCritical]唯一追加。
*)
Definition SemaphoreCriticalCore
    (handlers : list Z) (st : SemaphoreState) : Assertion :=
  “ semaphore_state_valid semaphore_fixed_stable st /\
    handlers = nil ” &&
    EX observed,
      “ SemaphoreRTrans st observed ” &&
      at_states
        (fun current => exists after,
           current = Build_nested_critical_state
             semaphore_crtos_critical_STS nil after /\
           SemaphoreRTrans observed after) **
      has_tokens Sets.empty ||
  “ semaphore_state_valid semaphore_fixed_stable st /\
    handlers <> nil ” &&
    “ (Z.of_nat (List.length handlers) <= 65535)%Z ” &&
    at_states
      (fun current =>
         current = Build_nested_critical_state
           semaphore_crtos_critical_STS handlers st) **
    has_tokens (fun n => (n < List.length handlers)%nat).

(** 完整critical view把唯一物理counter与counter-free core重新组合。 *)
Definition SemaphoreCritical
    (handlers : list Z) (st : SemaphoreState) : Assertion :=
  store_crtos_lock_nest (SemaphoreHandlerDepth handlers) **
  SemaphoreCriticalCore handlers st.

Definition SemaphoreInsideCritical
    (handlers : list Z) (st : SemaphoreState) : Assertion :=
  SemaphoreCritical handlers st.

Definition SemaphoreOutsideCritical (st : SemaphoreState) : Assertion :=
  SemaphoreCritical nil st.
