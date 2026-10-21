Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import SetsClass.SetsClass.
Import SetsNotation.

From SimpleC.SL Require Import Mem SeparationLogic ConAssertion.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.mutex.MutexPure.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope sets.

(**
  临界区协议携带固定 mutex 地址配置与可变模块状态；合法转换保持
  [MutexStable] 不变，并按 [MutexGTrans] 推进可变状态。
*)
Definition MutexWorld : Type := (MutexStable * MutexState)%type.

Definition mutex_world_transition (before after : MutexWorld) : Prop :=
  fst before = fst after /\
  MutexGTrans (fst before) (snd before) (snd after).

(** nested 状态把每次 PRIMASK 保存值组成的栈与 mutex world 配对。 *)
Record MutexNestedState : Type := Build_MutexNestedState {
  mutex_handlers : list Z;
  mutex_world : MutexWorld
}.

(**
  当前非 SMP [CriticalAreaLock/UnLock] 使用 [KTaskOsAssignLockNest]。
  QCP 安装的 [NestedCriticalSTS.vo] 与当前 [ArrayLib.vo] 摘要不一致，
  因此依其正式接口在本 assertion carrier 中实例化同型 transition。
*)
Inductive mutex_nested_transition :
    MutexNestedState -> (nat -> Prop) ->
    MutexNestedState -> (nat -> Prop) -> Prop :=
  | MutexNCTEnter : forall handler handlers world tokens,
      (forall n, n >= List.length handlers -> ~ tokens n)%nat ->
      mutex_nested_transition
        (Build_MutexNestedState handlers world) tokens
        (Build_MutexNestedState (handler :: handlers) world)
        (tokens ∪ [List.length handlers])
  | MutexNCTExit : forall handler handlers before after tokens,
      (forall n, n >= List.length handlers -> ~ tokens n)%nat ->
      mutex_world_transition before after ->
      mutex_nested_transition
        (Build_MutexNestedState (handler :: handlers) before)
        (tokens ∪ [List.length handlers])
        (Build_MutexNestedState handlers after) tokens.

Definition mutex_nested_sts : ConAssertion.STS :=
  {| ConAssertion.token := nat;
     ConAssertion.STS_state := MutexNestedState;
     ConAssertion.Transition := fun source target =>
       mutex_nested_transition
         (fst source) (snd source) (fst target) (snd target);
     ConAssertion.InvownedToken := fun state n =>
       (n >= List.length state.(mutex_handlers))%nat |}.

Module MutexNestedSTS <: ConAssertion.STS_def.
  Definition sts : ConAssertion.STS := mutex_nested_sts.
End MutexNestedSTS.

(** mutex formal sources 唯一使用的 separation-logic assertion carrier。 *)
Module Mutex_C_Rules.
  Include MutexNestedSTS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
  Include MapLibSig.
  Include StringLibSig.
End Mutex_C_Rules.

Export Mutex_C_Rules.
Local Open Scope sac.

(**
  [MutexCritical] 只拥有 nested STS state/token，不拥有 C heap。空 handler
  栈表示临界区外；非空栈表示当前执行持有对应深度的 nested tokens。
*)
Definition MutexCritical
    (handlers : list Z) (stable : MutexStable) (state : MutexState)
    : Assertion :=
  let world : MutexWorld := (stable, state) in
  “ handlers = nil ” &&
    at_states
      (fun cs => exists current,
        cs = Build_MutexNestedState nil current /\
        mutex_world_transition world current) **
    has_tokens Sets.empty
  ||
  “ handlers <> nil ” &&
    at_states (Sets.singleton (Build_MutexNestedState handlers world)) **
    has_tokens (fun n => n < List.length handlers)%nat.

(** 普通公开 mutex API 的入口/出口 view。 *)
Definition MutexOutsideCritical
    (stable : MutexStable) (state : MutexState) : Assertion :=
  MutexCritical nil stable state.

(** [CriticalAreaLock] 后，栈顶是本次保存并必须原样恢复的 IRQ handler。 *)
Definition MutexInsideCritical
    (handler : Z) (handlers : list Z)
    (stable : MutexStable) (state : MutexState) : Assertion :=
  MutexCritical (handler :: handlers) stable state.

Definition MutexRely
    (stable : MutexStable) (before current : MutexState) : Prop :=
  mutex_world_transition (stable, before) (stable, current).

Definition MutexGuarantee
    (stable : MutexStable) (before after : MutexState) : Prop :=
  mutex_world_transition (stable, before) (stable, after).

Lemma MutexRely_refl : forall stable state, MutexRely stable state state.
Proof.
  intros. split; [reflexivity | apply MutexGTrans_refl].
Qed.

Lemma MutexGuarantee_refl : forall stable state, MutexGuarantee stable state state.
Proof.
  intros. split; [reflexivity | apply MutexGTrans_refl].
Qed.
