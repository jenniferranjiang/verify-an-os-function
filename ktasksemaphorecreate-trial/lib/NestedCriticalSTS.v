Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import String.
Require Import Permutation.

From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From compcert.lib Require Import Integers.

From SimpleC.SL Require Import Mem.
From SimpleC.SL Require Export IntLib ArrayLib.
From AUXLib Require Export ListLib.
From SimpleC.SL Require Export CommonAssertion.
From SimpleC.SL Require Assertion ConAssertion.
From SimpleC.SL Require Import CriticalSTS.

Require Import Logic.LogicGenerator.demo932.Interface.

Local Open Scope Z_scope.
Local Open Scope sets.

Record nested_critical_state {C: critical_STS}: Type :=
  {
    handlers_of_NCS: list Z;
    state_of_NCS: critical_STS_state
  }.

Inductive nested_critical_transition {C: critical_STS}:
  nested_critical_state -> (nat -> Prop) ->
  nested_critical_state -> (nat -> Prop) -> Prop :=
| NCT_enter_critical: forall h l s t,
    (forall n, n >= List.length l -> ~ n ∈ t)%nat ->
    nested_critical_transition
      (Build_nested_critical_state _ l s) t
      (Build_nested_critical_state _ (cons h l) s) (t ∪ [List.length l])
| NCT_exit_critical: forall h l s1 s2 t,
    (forall n, n >= List.length l -> ~ n ∈ t)%nat ->
    critical_STS_transition s1 s2 ->
    nested_critical_transition
      (Build_nested_critical_state _ (cons h l) s1) (t ∪ [List.length l])
      (Build_nested_critical_state _ l s2) t.

Definition nested_critical_STS_to_STS (C: critical_STS): ConAssertion.STS :=
    {|
        ConAssertion.token := nat;
        ConAssertion.STS_state := nested_critical_state;
        ConAssertion.Transition := fun s1 s2 =>
          nested_critical_transition (fst s1) (snd s1) (fst s2) (snd s2);
        ConAssertion.InvownedToken := fun s (n: nat) => (n >= List.length (handlers_of_NCS s))%nat;
    |}.

(**
  上游文件后半仅声明抽象模块类型模板；本 trial 直接使用上面的通用
  record/transition/STS 转换并在 [SemaphoreRules] 具体实例化，故不复制
  那些未实例化声明，保持 trust scan 不引入额外可信接口。
*)
