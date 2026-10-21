Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Logic.PropExtensionality.
Require Import SetsClass.SetsClass.
Require Import SL.ConAssertion.
Require Import CRTOS_Verify.lib.CrtosRules.

Import SetsNotation.
Local Open Scope sets.

(** 将同一 C heap 放到没有协议权限的标准 low-state：状态集合为全集，
    token 为空。它不制造 Task token，也不将旧 Task 协议迁入新 OS 协议。 *)
Definition crtos_heap_state (S : ConAssertion.STS) (m : Mem.mem)
    : @ConAssertion.Lstate S :=
  @ConAssertion.mk_Lstate S m Sets.full Sets.empty.

(** 在新 carrier 上复用正式根库的 heap representation。旧断言只在无
    token、无状态限制的标准 heap 上解释；新断言也只占 heap。带协议权限
    的 TaskOutside/Inside 不能通过此桥被当作新的临界区 token。 *)
Definition crtos_heap_lift (S : ConAssertion.STS)
    (P : Task_C_Rules.expr) : @ConAssertion.Lstate S -> Prop :=
  fun s =>
    s.(ConAssertion.s_token) == Sets.empty /\
    s.(ConAssertion.s_STS) == Sets.full /\
    P (crtos_heap_state Task_C_Rules.sts s.(ConAssertion.s_mem)).

(** 纯 heap 的标准化不改变 low-state；仅使用框架允许的命题和函数外延性。 *)
Lemma crtos_heap_state_unique : forall S (s : @ConAssertion.Lstate S),
  s.(ConAssertion.s_token) == Sets.empty ->
  s.(ConAssertion.s_STS) == Sets.full ->
  s = crtos_heap_state S s.(ConAssertion.s_mem).
Proof.
  intros S [m states tokens] Htokens Hstates.
  unfold crtos_heap_state; simpl in *.
  assert (tokens = Sets.empty) as ->.
  { apply functional_extensionality; intro t.
    apply propositional_extensionality; apply Htokens. }
  assert (states = Sets.full) as ->.
  { apply functional_extensionality; intro t.
    apply propositional_extensionality; apply Hstates. }
  reflexivity.
Qed.

(** 标准 heap 的分离恰好是实际 C 内存的 disjoint join。 *)
Lemma crtos_heap_state_join : forall S m1 m2 m,
  @ConAssertion.state_join S
    (crtos_heap_state S m1) (crtos_heap_state S m2)
    (crtos_heap_state S m) <-> Mem.mem_join m1 m2 m.
Proof.
  intros; unfold ConAssertion.state_join, ConAssertion.TokenSet_join,
    ConAssertion.STS_state_join, crtos_heap_state; simpl.
  split; [tauto|]. intro H; split; [exact H|].
  split; [split|]; sets_unfold; tauto.
Qed.

(** 一个纯 heap 分解后，两份资源仍无 token、无协议状态限制。 *)
Lemma crtos_heap_join_parts : forall S (a b c : @ConAssertion.Lstate S),
  ConAssertion.state_join a b c ->
  c.(ConAssertion.s_token) == Sets.empty ->
  c.(ConAssertion.s_STS) == Sets.full ->
  a = crtos_heap_state S a.(ConAssertion.s_mem) /\
  b = crtos_heap_state S b.(ConAssertion.s_mem).
Proof.
  intros S a b c [_ [[Hu _] Hi]] Ht Hs.
  sets_unfold in Hu; sets_unfold in Hi;
  sets_unfold in Ht; sets_unfold in Hs.
  split; apply crtos_heap_state_unique; sets_unfold; firstorder.

Qed.

(** 根库两个 heap 断言的 separating conjunction 可以整体迁移，也可
    分别迁移后在统一 OS carrier 中组合；两种解释具有完全相同的 footprint。 *)
Lemma crtos_heap_lift_sep : forall S P Q s,
  crtos_heap_lift S (Task_C_Rules.sepcon P Q) s <->
  exists a b : @ConAssertion.Lstate S,
    ConAssertion.state_join a b s /\
    crtos_heap_lift S P a /\ crtos_heap_lift S Q b.
Proof.
  intros S P Q s; split.
  - intros [Ht [Hs [a [b [Hj [HP HQ]]]]]].
    pose proof (crtos_heap_join_parts Task_C_Rules.sts a b
      (crtos_heap_state Task_C_Rules.sts s.(ConAssertion.s_mem))
      Hj (fun _ => iff_refl _) (fun _ => iff_refl _)) as [Ha Hb].
    rewrite Ha in HP; rewrite Hb in HQ.
    exists (crtos_heap_state S a.(ConAssertion.s_mem)),
      (crtos_heap_state S b.(ConAssertion.s_mem)).
    split.
    + rewrite (crtos_heap_state_unique S s Ht Hs).
      apply crtos_heap_state_join. exact (proj1 Hj).
    + split; unfold crtos_heap_lift; simpl;
        (split; [sets_unfold; tauto|]);
        (split; [sets_unfold; tauto|assumption]).
  - intros [a [b [Hj [[Hat [Has HP]] [Hbt [Hbs HQ]]]]]].
    assert (Ht : s.(ConAssertion.s_token) == Sets.empty).
    { destruct Hj as [_ [[Hu _] _]]. intro x.
      specialize (Hu x); specialize (Hat x); specialize (Hbt x).
      sets_unfold in Hu; sets_unfold in Hat; sets_unfold in Hbt; sets_unfold; tauto. }
    assert (Hs : s.(ConAssertion.s_STS) == Sets.full).
    { destruct Hj as [_ [_ Hi]]. intro x.
      specialize (Hi x); specialize (Has x); specialize (Hbs x).
      sets_unfold in Hi; sets_unfold in Has; sets_unfold in Hbs; sets_unfold; tauto. }
    split; [exact Ht|]. split; [exact Hs|].
    exists (crtos_heap_state Task_C_Rules.sts a.(ConAssertion.s_mem)),
      (crtos_heap_state Task_C_Rules.sts b.(ConAssertion.s_mem)).
    split; [apply crtos_heap_state_join; exact (proj1 Hj)|tauto].
Qed.

(** 已证明的根库 heap entailment 在迁移后仍成立；不会新增用户公理。 *)
Lemma crtos_heap_lift_entails : forall S P Q,
  Task_C_Rules.derivable1 P Q ->
  forall s, crtos_heap_lift S P s -> crtos_heap_lift S Q s.
Proof.
  intros S P Q H s [Ht [Hs HP]].
  split; [exact Ht|]. split; [exact Hs|]. apply H; exact HP.
Qed.
