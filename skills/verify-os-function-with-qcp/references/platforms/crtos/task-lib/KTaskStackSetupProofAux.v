Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
From compcert.lib Require Import Integers.
From AUXLib Require Import int_auto.
From SimpleC.SL Require Import IntLib Mem SeparationLogic ArrayLib.
Require Import CRTOS_Verify.lib.KTaskStackSetup.

Require Import CRTOS_Verify.lib.CrtosRules.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

Lemma ktask_xubase_value_unsigned_last_nbits : forall x,
  ktask_xubase_value x ->
  unsigned_last_nbits x 32 = x.
Proof.
  intros x Hrange.
  unfold ktask_xubase_value in Hrange.
  apply unsigned_last_nbits_eq.
  change Int.max_unsigned with 4294967295 in Hrange.
  change (2 ^ 32) with 4294967296.
  lia.
Qed.

(* [memset(..., '#', ...)] 使每个字节都是 0x23。按 QCP 的 4 字节
   [UInt] 内存表示，连续 4 个这样的字节对应数值
   [0x23232323]。该定义只用于证明循环写入前读取/覆盖一个
   [x_ubase] 槽位时的旧值存在，不改变核心谓词定义。 *)
Definition ktask_stack_memset_uint_value : Z := 589505315.

Lemma ktask_repeat_z_sublist : forall lo hi n (v : Z),
  0 <= lo <= hi ->
  hi <= n ->
  sublist lo hi (repeat_Z v n) = repeat_Z v (hi - lo).
Proof.
  intros lo hi n v Hlohi Hhin.
  unfold repeat_Z.
  apply (proj2 (list_eq_ext _ _ v)).
  split.
  - rewrite Zlength_sublist.
    + rewrite !Zlength_correct, !repeat_length.
      repeat rewrite Z2Nat.id by lia.
      lia.
    + split; [lia|].
      rewrite Zlength_correct, repeat_length.
      rewrite Z2Nat.id by lia.
      lia.
  - intros i Hi.
    assert (Hsub_len :
      Zlength (sublist lo hi (repeat v (Z.to_nat n))) = hi - lo).
    {
      rewrite Zlength_sublist.
      - reflexivity.
      - split; [lia|].
        rewrite Zlength_correct, repeat_length.
        rewrite Z2Nat.id by lia.
        lia.
    }
    rewrite Hsub_len in Hi.
    rewrite (Znth_sublist v lo i hi (repeat v (Z.to_nat n))) by lia.
    repeat rewrite Znth_repeat.
    reflexivity.
Qed.

(**
  将一整段由 [memset] 初始化的任务栈按两个字节偏移切成连续三段。

  该引理只在 [KTaskStackSetup] 实际写入寄存器上下文之前暴露低层数组
  分段；函数的公开前置条件仍保持单一的 [store_ktask_stack_memset]
  所有权块。
*)
Lemma store_ktask_stack_memset_split_three : forall p n first second,
  0 <= first /\ first <= second /\ second <= n ->
  store_ktask_stack_memset p n |--
  store_ktask_stack_memset p first **
  store_ktask_stack_memset (p + first) (second - first) **
  store_ktask_stack_memset (p + second) (n - second).
Proof.
  intros p n first second Hcuts.
  unfold store_ktask_stack_memset at 1.
  sep_apply_l_atomic
    (UCharArray.full_split_to_full
       p first n (repeat_Z CHAR_SHARP n)
       ltac:(lia)).
  rewrite (ktask_repeat_z_sublist 0 first n CHAR_SHARP)
    by lia.
  rewrite (ktask_repeat_z_sublist first n n CHAR_SHARP)
    by lia.
  rewrite ktask_sizeof_uchar.
  replace (p + first * 1) with (p + first) by lia.
  sep_apply_l_atomic
    (UCharArray.full_split_to_full
       (p + first) (second - first) (n - first)
       (repeat_Z CHAR_SHARP (n - first))
       ltac:(lia)).
  rewrite
    (ktask_repeat_z_sublist
       0 (second - first) (n - first) CHAR_SHARP)
    by lia.
  rewrite
    (ktask_repeat_z_sublist
       (second - first) (n - first) (n - first)
       CHAR_SHARP)
    by lia.
  rewrite ktask_sizeof_uchar.
  replace (first - 0) with first by lia.
  replace (second - first - 0) with (second - first) by lia.
  replace (n - first - (second - first)) with (n - second) by lia.
  replace (p + first + (second - first) * 1) with (p + second) by lia.
  fold (store_ktask_stack_memset p first).
  fold (store_ktask_stack_memset (p + first) (second - first)).
  fold (store_ktask_stack_memset (p + second) (n - second)).
  entailer!.
Qed.

(**
  根据 [KTaskStackSetup] 的布局条件，把完整任务栈切成上下文之前、
  寄存器上下文本身、对齐栈顶之后三段。计算地址不作为公开前置条件
  的额外逻辑变量，而是直接使用 [kss_context_addr] 和
  [kss_aligned_top]。
*)
Lemma store_ktask_stack_memset_split_for_setup : forall info,
  ktask_stack_setup_layout_ok
    info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ->
  store_ktask_stack_memset info.(tbStackStart) info.(tbStackDepth) |--
  store_ktask_stack_memset
    info.(tbStackStart) (kss_context_addr info - info.(tbStackStart)) **
  store_ktask_stack_memset
    (kss_context_addr info) sizeof("StackRegisterContext") **
  store_ktask_stack_memset
    (kss_aligned_top info)
    (info.(tbStackStart) + info.(tbStackDepth) - kss_aligned_top info).
Proof.
  intros info Hlayout.
  pose proof Hlayout as Hparts.
  unfold ktask_stack_setup_layout_ok in Hparts.
  destruct Hparts as
    (Hstart & Hreg & Hdepth & Hbound & Hcontext_fits).
  pose proof
    (ktask_stack_aligned_top_le_raw_top
       info.(tbStackStart) info.(tbStackDepth) REG_LENGTH
       ltac:(lia) Hreg) as Htop.
  assert (Hsize : 0 <= sizeof("StackRegisterContext")) by
    (rewrite ContextRegsSizeAxiom, ktask_sizeof_uint;
     unfold REG_COUNT; lia).
  unfold kss_context_addr, kss_aligned_top, ktask_stack_context_addr.
  sep_apply_l_atomic
    (store_ktask_stack_memset_split_three
       info.(tbStackStart) info.(tbStackDepth)
       (ktask_stack_aligned_top
          info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
        sizeof("StackRegisterContext") - info.(tbStackStart))
       (ktask_stack_aligned_top
          info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
        info.(tbStackStart))
       ltac:(lia)).
  replace
    (info.(tbStackStart) +
       (ktask_stack_aligned_top
          info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
        sizeof("StackRegisterContext") - info.(tbStackStart)))
    with
    (ktask_stack_aligned_top
       info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
     sizeof("StackRegisterContext")) by lia.
  replace
    ((ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
      info.(tbStackStart)) -
     (ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
      sizeof("StackRegisterContext") - info.(tbStackStart)))
    with sizeof("StackRegisterContext") by lia.
  replace
    (info.(tbStackStart) +
     (ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
      info.(tbStackStart)))
    with
    (ktask_stack_aligned_top
       info.(tbStackStart) info.(tbStackDepth) REG_LENGTH) by lia.
  replace
    (info.(tbStackDepth) -
     (ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH -
      info.(tbStackStart)))
    with
    (info.(tbStackStart) + info.(tbStackDepth) -
     ktask_stack_aligned_top
       info.(tbStackStart) info.(tbStackDepth) REG_LENGTH) by lia.
  entailer!.
Qed.

Lemma aligned_reglen_aligned_4 : forall p,
  aligned_reglen p ->
  aligned_4 p.
Proof.
  intros p Haligned.
  unfold aligned_reglen, REG_LENGTH in Haligned.
  unfold aligned_4.
  apply Z.mod_divide in Haligned; [| lia].
  destruct Haligned as [k Hk].
  replace p with (4 * k) by lia.
  rewrite Z.mul_comm.
  apply Z.mod_mul.
  lia.
Qed.

Lemma kss_aligned_top_aligned_reglen : forall info,
  ktask_stack_setup_layout_ok
    (info.(tbStackStart)) (info.(tbStackDepth)) REG_LENGTH ->
  aligned_reglen (kss_aligned_top info).
Proof.
  intros info Hlayout.
  unfold aligned_reglen, kss_aligned_top.
  apply ktask_stack_aligned_top_aligned.
  unfold ktask_stack_setup_layout_ok in Hlayout.
  lia.
Qed.

Lemma kss_context_addr_aligned_reglen : forall info,
  ktask_stack_setup_layout_ok
    (info.(tbStackStart)) (info.(tbStackDepth)) REG_LENGTH ->
  ktask_stack_context_layout_ok ->
  aligned_reglen (kss_context_addr info).
Proof.
  intros info Hlayout Hctx.
  pose proof (kss_aligned_top_aligned_reglen info Hlayout) as Htop.
  unfold aligned_reglen in *.
  unfold kss_aligned_top in Htop.
  unfold kss_context_addr, ktask_stack_context_addr.
  rewrite Zminus_mod.
  rewrite Htop.
  unfold ktask_stack_context_layout_ok,
         ktask_stack_context_size_ok,
         ktask_stack_context_count_ok in Hctx.
  destruct Hctx as [Hsize [Hcount _]].
  rewrite Hsize, Hcount, sizeof_uint.
  unfold REG_LENGTH.
  reflexivity.
Qed.

Lemma aligned_reglen_uint_offset : forall p i,
  aligned_reglen p ->
  aligned_reglen (p + i * sizeof(UINT)).
Proof.
  intros p i Haligned.
  unfold aligned_reglen, REG_LENGTH in *.
  rewrite sizeof_uint.
  rewrite Z.add_mod by lia.
  rewrite Haligned.
  replace ((i * 4) mod 4) with 0.
  - reflexivity.
  - rewrite Z.mod_mul by lia.
    reflexivity.
Qed.

Lemma store_stack_memset_four_bytes_as_uint : forall p,
  aligned_reglen p ->
  CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset p 4
  |--
  EX old : Z, p # UInt |-> old.
Proof.
  intros p Haligned.
  unfold CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset, repeat_Z,
         CHAR_SHARP.
  simpl.
  rewrite UCharArray.full_unfold.
  repeat rewrite UCharArray.seg_unfold.
  rewrite UCharArray.seg_empty.
  rewrite ktask_sizeof_uchar.
  Exists ktask_stack_memset_uint_value.
  unfold store_uint, store_uchar, store_4byte.
  entailer!.
  Exists 35 35 35 35.
  entailer!.
  - repeat match goal with
    | |- context[p + 0 * 1] =>
        replace (p + 0 * 1) with p by lia
    | |- context[p + 1 * 1] =>
        replace (p + 1 * 1) with (p + 1) by lia
    | |- context[p + (1 + 1) * 1] =>
        replace (p + (1 + 1) * 1) with (p + 2) by lia
    | |- context[p + (1 + 1 + 1) * 1] =>
        replace (p + (1 + 1 + 1) * 1) with (p + 3) by lia
    end.
    entailer!.
  - unfold isvalidptr_int, isvalidptr_char in *.
    repeat match goal with H : _ /\ _ |- _ => destruct H end.
    repeat split; try lia.
    apply aligned_reglen_aligned_4.
    exact Haligned.
Qed.

(* 从剩余的 ['#'] 字节区中切出当前循环迭代要覆盖的一个 4 字节
   [x_ubase] 槽位。前半部分转为 [UInt] points-to，后半部分仍保持
   字节级 memset 谓词，以保存调用者 memset 提供的信息。 *)
Lemma store_ktask_stack_memset_split_uint : forall p n,
  aligned_reglen p ->
  4 <= n ->
  CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset p n
  |--
  EX old : Z,
    p # UInt |-> old **
    CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset (p + sizeof(UINT)) (n - sizeof(UINT)).
Proof.
  intros p n Haligned Hn.
  unfold CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset at 1.
  sep_apply_l_atomic
    (UCharArray.full_split_to_full
       p 4 n (repeat_Z CHAR_SHARP n)
       ltac:(lia)).
  rewrite (ktask_repeat_z_sublist 0 4 n CHAR_SHARP) by lia.
  rewrite (ktask_repeat_z_sublist 4 n n CHAR_SHARP) by lia.
  fold (CRTOS_Verify.lib.KTaskStackSetup.KTask.store_ktask_stack_memset (p + 4 * sizeof(UCHAR)) (n - 4)).
  sep_apply_l_atomic (store_stack_memset_four_bytes_as_uint p Haligned).
  rewrite sizeof_uint, ktask_sizeof_uchar.
  replace (p + 4 * 1) with (p + 4) by lia.
  entailer!.
Qed.

(**
  [store_stack_register_context_fields p ctx] 用结构体字段视角拥有
  [StackRegisterContext] 的 32 个通用寄存器槽位。

  参数:
  - [p]: [struct StackRegisterContext *] 的结构体首地址；
  - [ctx]: 逻辑层记录，按 C 字段顺序保存各寄存器槽位的值。

  该谓词只作为证明辅助视图使用，用来连接 C 代码中的
  [stack_contex->field] 写入和规格中的 [UIntArray.full] 槽位视图。
*)
Definition store_stack_register_context_fields
           (p : addr) (ctx : StackRegisterContextAbs) : Assertion :=
  &(p # "StackRegisterContext" ->ₛ "epc") # UInt |-> ctx.(Epc) **
  &(p # "StackRegisterContext" ->ₛ "ra") # UInt |-> ctx.(Ra) **
  &(p # "StackRegisterContext" ->ₛ "mstatus") # UInt |-> ctx.(Mstatus) **
  &(p # "StackRegisterContext" ->ₛ "gp") # UInt |-> ctx.(Gp) **
  &(p # "StackRegisterContext" ->ₛ "tp") # UInt |-> ctx.(Tp) **
  &(p # "StackRegisterContext" ->ₛ "t0") # UInt |-> ctx.(T0) **
  &(p # "StackRegisterContext" ->ₛ "t1") # UInt |-> ctx.(T1) **
  &(p # "StackRegisterContext" ->ₛ "t2") # UInt |-> ctx.(T2) **
  &(p # "StackRegisterContext" ->ₛ "s0_fp") # UInt |-> ctx.(S0Fp) **
  &(p # "StackRegisterContext" ->ₛ "s1") # UInt |-> ctx.(S1) **
  &(p # "StackRegisterContext" ->ₛ "a0") # UInt |-> ctx.(A0) **
  &(p # "StackRegisterContext" ->ₛ "a1") # UInt |-> ctx.(A1) **
  &(p # "StackRegisterContext" ->ₛ "a2") # UInt |-> ctx.(A2) **
  &(p # "StackRegisterContext" ->ₛ "a3") # UInt |-> ctx.(A3) **
  &(p # "StackRegisterContext" ->ₛ "a4") # UInt |-> ctx.(A4) **
  &(p # "StackRegisterContext" ->ₛ "a5") # UInt |-> ctx.(A5) **
  &(p # "StackRegisterContext" ->ₛ "a6") # UInt |-> ctx.(A6) **
  &(p # "StackRegisterContext" ->ₛ "a7") # UInt |-> ctx.(A7) **
  &(p # "StackRegisterContext" ->ₛ "s2") # UInt |-> ctx.(S2) **
  &(p # "StackRegisterContext" ->ₛ "s3") # UInt |-> ctx.(S3) **
  &(p # "StackRegisterContext" ->ₛ "s4") # UInt |-> ctx.(S4) **
  &(p # "StackRegisterContext" ->ₛ "s5") # UInt |-> ctx.(S5) **
  &(p # "StackRegisterContext" ->ₛ "s6") # UInt |-> ctx.(S6) **
  &(p # "StackRegisterContext" ->ₛ "s7") # UInt |-> ctx.(S7) **
  &(p # "StackRegisterContext" ->ₛ "s8") # UInt |-> ctx.(S8) **
  &(p # "StackRegisterContext" ->ₛ "s9") # UInt |-> ctx.(S9) **
  &(p # "StackRegisterContext" ->ₛ "s10") # UInt |-> ctx.(S10) **
  &(p # "StackRegisterContext" ->ₛ "s11") # UInt |-> ctx.(S11) **
  &(p # "StackRegisterContext" ->ₛ "t3") # UInt |-> ctx.(T3) **
  &(p # "StackRegisterContext" ->ₛ "t4") # UInt |-> ctx.(T4) **
  &(p # "StackRegisterContext" ->ₛ "t5") # UInt |-> ctx.(T5) **
  &(p # "StackRegisterContext" ->ₛ "t6") # UInt |-> ctx.(T6).

Ltac ktask_rewrite_context_field_offsets p Haligned :=
  let Hoffsets := fresh "Hoffsets" in
  pose proof (StackRegisterContext_field_offsets_from_aligned p Haligned)
    as Hoffsets;
  unfold ktask_stack_context_field_offsets_ok in Hoffsets;
  repeat match type of Hoffsets with
  | _ /\ _ => destruct Hoffsets as [? Hoffsets]
  end;
  repeat match goal with
  | H : _ = _ |- _ => rewrite H in *
  end.

(**
  字段视图到槽位视图的转换。
  该引理使用 [StackRegisterContext_field_offsets_from_aligned] 将每个
  C 字段地址改写为 [p + i * sizeof(UINT)]，再按数组定义折叠为
  [CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots]。
*)
Lemma store_stack_register_context_fields_to_slots : forall p ctx,
  aligned_reglen p ->
  store_stack_register_context_fields p ctx
  |--
  CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots p ctx.
Proof.
  intros p ctx Haligned.
  unfold store_stack_register_context_fields,
         CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots,
         stack_register_context_values.
  simpl.
  change REG_COUNT with 32.
  ktask_rewrite_context_field_offsets p Haligned.
  unfold UIntArray.full, store_array.  
  simpl. entailer!. 
Qed.

Lemma stack_register_context_field_points_to_slots : forall p ctx,
  aligned_reglen p ->
  &(p # "StackRegisterContext" ->ₛ "epc") # UInt |-> ctx.(Epc) **
  &(p # "StackRegisterContext" ->ₛ "ra") # UInt |-> ctx.(Ra) **
  &(p # "StackRegisterContext" ->ₛ "mstatus") # UInt |-> ctx.(Mstatus) **
  &(p # "StackRegisterContext" ->ₛ "gp") # UInt |-> ctx.(Gp) **
  &(p # "StackRegisterContext" ->ₛ "tp") # UInt |-> ctx.(Tp) **
  &(p # "StackRegisterContext" ->ₛ "t0") # UInt |-> ctx.(T0) **
  &(p # "StackRegisterContext" ->ₛ "t1") # UInt |-> ctx.(T1) **
  &(p # "StackRegisterContext" ->ₛ "t2") # UInt |-> ctx.(T2) **
  &(p # "StackRegisterContext" ->ₛ "s0_fp") # UInt |-> ctx.(S0Fp) **
  &(p # "StackRegisterContext" ->ₛ "s1") # UInt |-> ctx.(S1) **
  &(p # "StackRegisterContext" ->ₛ "a0") # UInt |-> ctx.(A0) **
  &(p # "StackRegisterContext" ->ₛ "a1") # UInt |-> ctx.(A1) **
  &(p # "StackRegisterContext" ->ₛ "a2") # UInt |-> ctx.(A2) **
  &(p # "StackRegisterContext" ->ₛ "a3") # UInt |-> ctx.(A3) **
  &(p # "StackRegisterContext" ->ₛ "a4") # UInt |-> ctx.(A4) **
  &(p # "StackRegisterContext" ->ₛ "a5") # UInt |-> ctx.(A5) **
  &(p # "StackRegisterContext" ->ₛ "a6") # UInt |-> ctx.(A6) **
  &(p # "StackRegisterContext" ->ₛ "a7") # UInt |-> ctx.(A7) **
  &(p # "StackRegisterContext" ->ₛ "s2") # UInt |-> ctx.(S2) **
  &(p # "StackRegisterContext" ->ₛ "s3") # UInt |-> ctx.(S3) **
  &(p # "StackRegisterContext" ->ₛ "s4") # UInt |-> ctx.(S4) **
  &(p # "StackRegisterContext" ->ₛ "s5") # UInt |-> ctx.(S5) **
  &(p # "StackRegisterContext" ->ₛ "s6") # UInt |-> ctx.(S6) **
  &(p # "StackRegisterContext" ->ₛ "s7") # UInt |-> ctx.(S7) **
  &(p # "StackRegisterContext" ->ₛ "s8") # UInt |-> ctx.(S8) **
  &(p # "StackRegisterContext" ->ₛ "s9") # UInt |-> ctx.(S9) **
  &(p # "StackRegisterContext" ->ₛ "s10") # UInt |-> ctx.(S10) **
  &(p # "StackRegisterContext" ->ₛ "s11") # UInt |-> ctx.(S11) **
  &(p # "StackRegisterContext" ->ₛ "t3") # UInt |-> ctx.(T3) **
  &(p # "StackRegisterContext" ->ₛ "t4") # UInt |-> ctx.(T4) **
  &(p # "StackRegisterContext" ->ₛ "t5") # UInt |-> ctx.(T5) **
  &(p # "StackRegisterContext" ->ₛ "t6") # UInt |-> ctx.(T6)
  |--
  CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots p ctx.
Proof.
  intros p ctx Haligned.
  fold (store_stack_register_context_fields p ctx).
  apply store_stack_register_context_fields_to_slots.
  exact Haligned.
Qed.

(**
  槽位视图到字段视图的转换。
  该方向用于循环完成后把 [UIntArray.full] 暴露给后续
  [stack_contex->field] 赋值语句。
*)
Lemma store_stack_register_context_slots_to_fields : forall p ctx,
  aligned_reglen p ->
  CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots p ctx
  |--
  store_stack_register_context_fields p ctx.
Proof.
  intros p ctx Haligned.
  unfold store_stack_register_context_fields,
         CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots,
         stack_register_context_values.
  simpl.
  change REG_COUNT with 32.
  ktask_rewrite_context_field_offsets p Haligned.
  unfold UIntArray.full, store_array.
  simpl.
  entailer!.
Qed.

(**
  循环刚结束、写入具体寄存器字段前的上下文抽象值。
  此时 32 个 [UINT] 槽位都由循环写成 [OxFADEFACE]。
*)
Definition ktask_stack_context_all_fadeface : StackRegisterContextAbs :=
  ktask_stack_context_after_setup
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE.

Lemma ktask_stack_context_all_fadeface_values :
  stack_register_context_values ktask_stack_context_all_fadeface =
  repeat_Z OxFADEFACE REG_COUNT.
Proof.
  unfold ktask_stack_context_all_fadeface,
         ktask_stack_context_after_setup,
         stack_register_context_values,
         repeat_Z,
         REG_COUNT.
  reflexivity.
Qed.

Lemma store_fadeface_stack_register_context_slots_to_fields : forall p,
  aligned_reglen p ->
  store_fadeface_stack_register_context_slots p
  |--
  store_stack_register_context_fields p ktask_stack_context_all_fadeface.
Proof.
  intros p Haligned.
  unfold store_fadeface_stack_register_context_slots.
  rewrite <- ktask_stack_context_all_fadeface_values.
  fold (CRTOS_Verify.lib.KTaskStackSetup.KTask.store_stack_register_context_slots p ktask_stack_context_all_fadeface).
  apply store_stack_register_context_slots_to_fields.
  exact Haligned.
Qed.
