Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.micromega.Lia.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Export CRTOS_Verify.lib.KTaskPure.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

Module KTask.

(**
  [store_string_n x n l] 描述从地址 [x] 开始的固定 [n] 字节名字槽。

  参数:
  - [x]: C 字符数组首地址；
  - [n]: 数组总字节数；
  - [l]: 数组中保存的有效非零字符序列。

  当 [string_length l < n] 时，剩余字节全部为零，因此数组包含 C 字符串
  终止符；当两者相等时，该谓词仍完整拥有 [n] 字节，但不声称存在终止
  零。该表示与 `strncpy` 的定长写入结果一致。
*)

Definition store_string_n (x : addr) (n : Z) (l : list Z) : Assertion :=
  “ valid_string l ” &&
  “ string_length l <= n ” &&
  CharArray.full x n (l ++ repeat_Z 0 (n - string_length l)).

(**
  [store_task_base_info task b] 描述 [TaskDescriptor.task_base_info]
  这一整个嵌入结构的所有权和抽象内容。

  参数 [task] 是外层 [TaskDescriptor] 的地址，而不是把该地址
  重新解释为独立 [TaskBaseInfo] 对象。这样字段地址与 C 表达式
  [task->task_base_info.field] 使用同一条 QCP 结构体路径，
  后续验证调用者 [_KTaskBaseInfoParse] 时也可以直接复用。

  名字字段使用固定 32 字节视图，对应 `TaskBaseInfo.name[NAME_NUM_MAX]`；
  因此该谓词拥有整个名字数组，而不是只拥有第一个零之前的前缀。
*)

Definition store_task_base_info (task : addr) (b : TaskBaseInfoAbs) : Assertion :=
  store_string_n
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name"))
    32 b.(tbName) **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry")
    # Ptr |-> b.(tbFuncEntry) **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param")
    # Ptr |-> b.(tbFuncParam) **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio")
    # UChar |-> b.(tbOriginPrio) **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth")
    # UInt |-> b.(tbStackDepth) **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start")
    # Ptr |-> b.(tbStackStart).

(* ======================== For KTaskStackSetup ==================== *)

Definition ktask_stack_memset_bytes (n : Z) : list Z :=
  repeat_Z CHAR_SHARP n.


Lemma ktask_sizeof_uchar : sizeof(UCHAR) = 1.
Proof.
  rewrite sizeof_uchar.
  reflexivity.
Qed.

Lemma ktask_sizeof_uint : sizeof(UINT) = 4.
Proof.
  rewrite sizeof_uint.
  reflexivity.
Qed.

Lemma ktask_raw_top_uchar_scale : forall stack_start stack_depth,
  stack_start + stack_depth * sizeof(UCHAR) = stack_start + stack_depth.
Proof.
  intros.
  rewrite ktask_sizeof_uchar.
  lia.
Qed.

Axiom ContextRegsSizeAxiom: sizeof("StackRegisterContext") = REG_COUNT * sizeof(UINT).

(* [ktask_stack_setup_layout_ok] 已经包含
   [sizeof("StackRegisterContext") =
    REG_COUNT * sizeof(UINT)]。同时寄存器槽数量
   [REG_COUNT = 32] 是本文件中的静态定义，因此可从
   栈布局前置条件推出上下文大小/数量布局事实。 *)
Lemma ktask_stack_setup_layout_implies_context_layout :
  forall stack_start stack_depth reg_len,
    ktask_stack_setup_layout_ok stack_start stack_depth reg_len ->
    ktask_stack_context_layout_ok.
Proof.
  intros stack_start stack_depth reg_len Hlayout.
  unfold ktask_stack_setup_layout_ok in Hlayout.
  destruct Hlayout as (_ & _ & _ & _ & _ ).
  unfold ktask_stack_context_layout_ok,
         ktask_stack_context_size_ok,
         ktask_stack_context_count_ok.
  split.
  - exact ContextRegsSizeAxiom.
  - unfold REG_COUNT.
    lia.
Qed.

Lemma ktask_stack_setup_context_inside : forall stack_start stack_depth reg_len,
  ktask_stack_setup_layout_ok stack_start stack_depth reg_len ->
  stack_start <= ktask_stack_context_addr stack_start stack_depth reg_len.
Proof.
  intros stack_start stack_depth reg_len Hlayout.
  unfold ktask_stack_setup_layout_ok,
         ktask_stack_context_addr in *.
  lia.
Qed.

Lemma ktask_stack_setup_raw_top_xubase_bound : forall stack_start stack_depth reg_len,
  ktask_stack_setup_layout_ok stack_start stack_depth reg_len ->
  0 <= stack_start + stack_depth <= Int.max_unsigned.
Proof.
  intros stack_start stack_depth reg_len Hlayout.
  unfold ktask_stack_setup_layout_ok in Hlayout.
  lia.
Qed.

Lemma ktask_stack_aligned_top_aligned : forall stack_start stack_depth reg_len,
  reg_len > 0 ->
  (ktask_stack_aligned_top stack_start stack_depth reg_len) mod reg_len = 0.
Proof.
  intros.
  unfold ktask_stack_aligned_top, ktask_align_down.
  apply Z.mod_mul.
  lia.
Qed.

Lemma ktask_stack_aligned_top_le_raw_top : forall stack_start stack_depth reg_len,
  0 <= stack_start + stack_depth ->
  reg_len > 0 ->
  ktask_stack_aligned_top stack_start stack_depth reg_len <=
    stack_start + stack_depth.
Proof.
  intros.
  unfold ktask_stack_aligned_top, ktask_align_down.
  pose proof (Z.quot_rem (stack_start + stack_depth) reg_len ltac:(lia)).
  pose proof (Z.rem_bound_pos (stack_start + stack_depth) reg_len ltac:(lia) ltac:(lia)).
  replace ((stack_start + stack_depth) ÷ reg_len * reg_len)
    with (reg_len * ((stack_start + stack_depth) ÷ reg_len)) by lia.
  lia.
Qed.

Lemma ktask_stack_context_size_nonneg :
  ktask_stack_context_layout_ok ->
  0 <= sizeof("StackRegisterContext").
Proof.
  intros Hlayout.
  unfold ktask_stack_context_layout_ok,
         ktask_stack_context_size_ok,
         ktask_stack_context_count_ok in Hlayout.
  destruct Hlayout as (Hsize & Hcount & _).
  rewrite Hsize.
  rewrite ktask_sizeof_uint.
  lia.
Qed.

Lemma ktask_stack_aligned_top_xubase_bound : forall stack_start stack_depth reg_len,
  ktask_stack_setup_layout_ok stack_start stack_depth reg_len ->
  ktask_stack_context_layout_ok ->
  0 <= ktask_stack_aligned_top stack_start stack_depth reg_len <= Int.max_unsigned.
Proof.
  intros stack_start stack_depth reg_len Hlayout Hctx_layout.
  pose proof Hlayout as Hraw.
  apply ktask_stack_setup_raw_top_xubase_bound in Hraw.
  unfold ktask_stack_setup_layout_ok in Hlayout.
  destruct Hlayout as (Hstart & Hreg & _ & _ & Hctx).
  pose proof (ktask_stack_context_size_nonneg Hctx_layout).
  split.
  - lia.
  - eapply Z.le_trans.
    1: apply ktask_stack_aligned_top_le_raw_top; lia.
    lia.
Qed.

(* context寄存器状态 序列化*)
Definition stack_register_context_values
           (ctx : StackRegisterContextAbs) : list Z :=
  [
    ctx.(Epc); ctx.(Ra); ctx.(Mstatus); ctx.(Gp);
    ctx.(Tp); ctx.(T0); ctx.(T1); ctx.(T2);
    ctx.(S0Fp); ctx.(S1);
    ctx.(A0); ctx.(A1); ctx.(A2); ctx.(A3);
    ctx.(A4); ctx.(A5); ctx.(A6); ctx.(A7);
    ctx.(S2); ctx.(S3); ctx.(S4); ctx.(S5);
    ctx.(S6); ctx.(S7); ctx.(S8); ctx.(S9);
    ctx.(S10); ctx.(S11);
    ctx.(T3); ctx.(T4); ctx.(T5); ctx.(T6)
  ].

(* 32 == 32*)
Definition stack_register_context_values_ok
           (ctx : StackRegisterContextAbs) : Prop :=
  Zlength (stack_register_context_values ctx) =
  REG_COUNT.

(* [store_stack_register_context_slots p ctx] 用数组视角拥有从 [p] 开始的
  32 个 [x_ubase] 槽位。每个槽位是 32 位 [UInt]，用于匹配
  C 循环中经由 [x_ubase] 指针进行的下标写入视图。 *)
Definition store_stack_register_context_slots
           (p : addr) (ctx : StackRegisterContextAbs) : Assertion :=
  UIntArray.full p
                 REG_COUNT
                 (stack_register_context_values ctx).

(* memset 后再从 [x_ubase *] 视图写入 [0xfadeface] 时，数组元素宽度是
   4 字节；该谓词表示已经完成写入的 [UInt] 前缀/整段。 *)
Definition store_fadeface_stack_register_context_slots (p : addr) : Assertion :=
  UIntArray.full p
                 REG_COUNT
                 (repeat_Z
                    OxFADEFACE
                    REG_COUNT).

(**
  [ktask_stack_context_field_offsets_ok p] 表示 32 位 RISC-V 非 FPU 配置下
  [struct StackRegisterContext] 的字段地址布局。

  参数:
  - [p]: C 中 [struct StackRegisterContext *] 指向的结构体首地址。

  含义:
  若 [p] 是寄存器宽度对齐地址，则结构体中的 32 个 [x_ubase]/[UINT]
  字段按 C 定义顺序连续排列，每个字段地址等于结构体基址加对应槽位偏移。
  该命题只描述纯地址等式，不拥有任何内存资源。
*)
Definition ktask_stack_context_field_offsets_ok (p : addr) : Prop :=
  &(p # "StackRegisterContext" ->ₛ "epc")     = p + 0  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "ra")      = p + 1  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "mstatus") = p + 2  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "gp")      = p + 3  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "tp")      = p + 4  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t0")      = p + 5  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t1")      = p + 6  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t2")      = p + 7  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s0_fp")   = p + 8  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s1")      = p + 9  * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a0")      = p + 10 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a1")      = p + 11 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a2")      = p + 12 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a3")      = p + 13 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a4")      = p + 14 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a5")      = p + 15 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a6")      = p + 16 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a7")      = p + 17 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s2")      = p + 18 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s3")      = p + 19 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s4")      = p + 20 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s5")      = p + 21 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s6")      = p + 22 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s7")      = p + 23 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s8")      = p + 24 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s9")      = p + 25 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s10")     = p + 26 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s11")     = p + 27 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t3")      = p + 28 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t4")      = p + 29 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t5")      = p + 30 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t6")      = p + 31 * sizeof(UINT).

Axiom StackRegisterContext_field_offsets_from_aligned :
  forall p, aligned_reglen p ->
    ktask_stack_context_field_offsets_ok p.

Definition store_ktask_stack_memset (p : addr) (n : Z): Assertion :=
  UCharArray.full p n (repeat_Z CHAR_SHARP n).


  (* 调用者已经执行 [memset(stack_start, '#', stack_depth)]，因此
     [context_addr, aligned_top) 这段即将被循环覆盖的区域在函数入口
     也应保留字节级 ['#'] 内容，而不是提前改写成循环尾部视图。 *)

Definition store_task_descriptor_init_1 (task: addr)
          (info : TaskBaseInfoAbs) : Assertion :=
  “ ktask_stack_setup_layout_ok
      info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr |->_ **
  store_task_base_info task info **
  store_ktask_stack_memset info.(tbStackStart) info.(tbStackDepth).

(* 从 [store_task_descriptor_init_1] 可以抽取出的纯布局信息仅来自其中
   嵌入的 [ktask_stack_setup_layout_ok]。因此在加入结构体大小等式之后，
   可机器检查地推出 [ktask_stack_context_layout_ok]。 *)
Lemma store_task_descriptor_init_1_entails_context_layout :
  forall task (info: TaskBaseInfoAbs),
    store_task_descriptor_init_1 task info
    |-- “ ktask_stack_context_layout_ok ”.
Proof.
  intros task info.
  unfold store_task_descriptor_init_1.
  entailer!.
  apply ktask_stack_setup_layout_implies_context_layout with
    (stack_start := info.(tbStackStart))
    (stack_depth := info.(tbStackDepth))
    (reg_len := REG_LENGTH). tauto.
Qed.

(* ↑↑↑ [UCharArray.full p n bytes] 拥有从地址 [p] 开始的 [n] 个字节 *)

Definition store_task_descriptor_init_1_post
           (task : addr)
           (info : TaskBaseInfoAbs) (ra: addr) : Assertion :=
  EX aligned_top context_addr: addr,
  “ aligned_top =
      ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ context_addr =
      ktask_stack_context_addr
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ ktask_stack_setup_layout_ok
      info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ aligned_reglen context_addr ” && “ aligned_reglen aligned_top ” &&
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr |-> context_addr **
  store_task_base_info task info **
  store_ktask_stack_memset
    info.(tbStackStart) (context_addr - info.(tbStackStart)) **
  store_stack_register_context_slots
    context_addr
    (ktask_stack_context_region info.(tbFuncEntry) info.(tbFuncParam) ra) **
  store_ktask_stack_memset
    aligned_top
    ((info.(tbStackStart) + info.(tbStackDepth)) - aligned_top).

End KTask.

Export KTask.
