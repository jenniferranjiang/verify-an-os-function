Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
From SimpleC.SL Require Import IntLib.

Local Open Scope Z_scope.

(** uint32 tick 的模数与源码比较阈值；后者是 UINT32_MAX / 2，
    比数学上的半周期少 1。与 C 宏使用不同名称，避免预处理冲突。 *)
Definition KTICK_MODULUS : Z := 2 ^ 32.
Definition KTICK_HALF_RANGE : Z := (KTICK_MODULUS - 1) / 2.

(** 复用 QCP 的无符号截断；不拥有 heartbeat 或 Delay 内存。
    deadline 是循环值，不能从本加法推出 deadline >= now。 *)
Definition tick_add (now duration : Z) : Z :=
  unsigned_last_nbits (now + duration) 32.

Definition tick_sub (later earlier : Z) : Z :=
  unsigned_last_nbits (later - earlier) 32.

(** 与插入循环的两个分支一致：相等时跳过，否则比较模差。
    此比较不能在整个 uint32 域上当作传递的严格序使用。 *)
Definition tick_beforeb (earlier later : Z) : bool :=
  let distance := tick_sub later earlier in
  if Z.eq_dec distance 0 then false
  else Z.ltb distance KTICK_HALF_RANGE.

(** 非严格循环次序包含相等项。列表使用 StronglySorted，明确要求
    每个前项相对所有后项有序，不依赖不存在的全域传递性。 *)
Definition tick_not_after (earlier later : Z) : Prop :=
  tick_sub later earlier < KTICK_HALF_RANGE.

(** CheckTaskDelay 的原始判定；真实过期时间必须小于比较阈值。
    在共同时间窗口内，未来 deadline 不会被误判为已到期。 *)
Definition tick_due (now deadline : Z) : Prop :=
  tick_sub now deadline < KTICK_HALF_RANGE.

(** 所有时间戳可放入从 origin 开始、跨度严格小于阈值的同一圆弧。
    origin 是纯见证，不是新增 C 时钟或 epoch 存储。将 now 与 deadline
    一并放入窗口，才可同时解释循环排序与到期检查。 *)
Definition tick_window (origin : Z) (timestamps : list Z) : Prop :=
  Forall (fun timestamp => tick_sub timestamp origin < KTICK_HALF_RANGE)
    timestamps.

(** 共同窗口内可用相对 origin 的距离证明比较性质；不声明全域传递性。 *)
Lemma tick_sub_range : forall later earlier,
  0 <= tick_sub later earlier < KTICK_MODULUS.
Proof.
  intros. unfold tick_sub, unsigned_last_nbits, KTICK_MODULUS.
  apply Z.mod_pos_bound. lia.
Qed.

(** 模加法后再减去起点，恢复一个周期内的时长；不要求 now + duration 不回绕。 *)
Lemma tick_sub_add : forall now duration,
  0 <= duration < KTICK_MODULUS ->
  tick_sub (tick_add now duration) now = duration.
Proof.
  intros now duration Hduration.
  unfold tick_sub, tick_add.
  rewrite unsigned_unsigned_sub_l by lia.
  replace (now + duration - now) with duration by lia.
  apply unsigned_last_nbits_eq. exact Hduration.
Qed.

Lemma tick_sub_origin : forall origin earlier later,
  tick_sub later earlier =
    (tick_sub later origin - tick_sub earlier origin) mod KTICK_MODULUS.
Proof.
  intros. unfold tick_sub, unsigned_last_nbits, KTICK_MODULUS.
  rewrite <- Zminus_mod.
  f_equal. ring.
Qed.

Lemma tick_sub_window : forall origin earlier later,
  tick_sub earlier origin < KTICK_HALF_RANGE ->
  tick_sub later origin < KTICK_HALF_RANGE ->
  tick_sub later earlier =
    if Z_le_dec (tick_sub earlier origin) (tick_sub later origin)
    then tick_sub later origin - tick_sub earlier origin
    else tick_sub later origin - tick_sub earlier origin + KTICK_MODULUS.
Proof.
  intros origin earlier later Hearlier Hlater.
  pose proof (tick_sub_range earlier origin) as Hrange1.
  pose proof (tick_sub_range later origin) as Hrange2.
  rewrite (tick_sub_origin origin).
  destruct (Z_le_dec (tick_sub earlier origin) (tick_sub later origin)).
  - apply Z.mod_small. change KTICK_HALF_RANGE with 2147483647 in *;
    change KTICK_MODULUS with 4294967296 in *; lia.
  - rewrite <- (Z.mod_add
      (tick_sub later origin - tick_sub earlier origin) 1 KTICK_MODULUS)
      by (unfold KTICK_MODULUS; lia).
    rewrite Z.mul_1_l. apply Z.mod_small.
    change KTICK_HALF_RANGE with 2147483647 in *;
    change KTICK_MODULUS with 4294967296 in *; lia.
Qed.

Lemma tick_not_after_window : forall origin earlier later,
  tick_sub earlier origin < KTICK_HALF_RANGE ->
  tick_sub later origin < KTICK_HALF_RANGE ->
  (tick_not_after earlier later <->
   tick_sub earlier origin <= tick_sub later origin).
Proof.
  intros origin earlier later Hearlier Hlater.
  pose proof (tick_sub_range earlier origin) as Hrange1.
  pose proof (tick_sub_range later origin) as Hrange2.
  unfold tick_not_after. rewrite (tick_sub_window origin _ _ Hearlier Hlater).
  destruct (Z_le_dec (tick_sub earlier origin) (tick_sub later origin));
    change KTICK_HALF_RANGE with 2147483647 in *;
    change KTICK_MODULUS with 4294967296 in *; lia.
Qed.

Lemma tick_beforeb_window : forall origin earlier later,
  tick_sub earlier origin < KTICK_HALF_RANGE ->
  tick_sub later origin < KTICK_HALF_RANGE ->
  (tick_beforeb earlier later = true <->
   tick_sub earlier origin < tick_sub later origin).
Proof.
  intros origin earlier later Hearlier Hlater.
  pose proof (tick_sub_range earlier origin) as Hrange1.
  pose proof (tick_sub_range later origin) as Hrange2.
  unfold tick_beforeb. rewrite (tick_sub_window origin _ _ Hearlier Hlater).
  destruct (Z_le_dec (tick_sub earlier origin) (tick_sub later origin));
    destruct (Z.eq_dec _ 0); try rewrite Z.ltb_lt;
    change KTICK_HALF_RANGE with 2147483647 in *;
    change KTICK_MODULUS with 4294967296 in *; intuition lia.
Qed.
