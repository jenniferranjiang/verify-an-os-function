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
Require Export CRTOS_Verify.lib.KTaskStackSetup.
Require Import CRTOS_Verify.lib.KTaskStackSetupProofAux.
Require Import CRTOS_Verify.lib.CrtosRules.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(**
  [_KTaskBaseInfoParse] 当前验证切片使用的宏常量。

  这些常量对应 `annotated_C/src/xs_base.h` 与 `annotated_C/src/xsconfig.h`
  在非 SMP、非隔离配置下的取值。把它们放在 Rocq 侧，是因为 C
  预处理器不会展开 `/*@ ... */` 注解内部的宏名。
*)
Definition KOK : Z := 0.
Definition KERROR : Z := 1.

Definition NOMEMORY : Z := 5.
Definition INVALID : Z := 10.
Definition NAME_MAX_SIZE : Z := 32.
Definition PRIORITY_MAX : Z := 32.

(**
  或许也可直接用 [store_string_n p NAME_MAX_SIZE nil].
  由KTaskCreate的memset保证name的内存值；
*)

Definition has_permission_ktask_base_info (task : addr): Assertion :=
  CharArray.undef_full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name")) NAME_MAX_SIZE **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry")
      # Ptr |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param")
      # Ptr |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio")
      # UChar |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth")
      # UInt |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start")
      # Ptr |->_.

(**
  [ktask_init_input_arguments_ok] 汇总 `_KTaskBaseInfoParse` 的纯输入约束。

  参数:
  - [entry]、[parameter]、[quit] 分别对应任务入口、入口参数和
    `KTaskQuit` 的 32 位地址值；
  - [stack_depth] 是以字节为单位的栈长度；
  - [priority] 是 C 中的 `uint8` 优先级。

  栈深度下界额外保留 [RegLength - 1] 字节，用于在任意栈起始地址下
  吸收向下对齐造成的最大损失。任务名字的内存所有权和字符合法性由
  函数规格中 [store_string] 单独描述；该名称来自 [Task_C_Rules]，
  与本文件其他内存谓词使用同一个 [Assertion]。因此，本纯谓词只接收
  五个地址或数值参数，不再接收与其定义无关的源字符串参数。
*)

Definition ktask_init_input_arguments_ok
           (entry parameter quit stack_depth priority : Z) : Prop :=
  ktask_xubase_value entry /\
  ktask_xubase_value parameter /\
  ktask_xubase_value quit /\
  0 <= stack_depth <= Int.max_unsigned /\
  sizeof("StackRegisterContext") + REG_LENGTH - 1 <= stack_depth /\
  0 <= priority <= 255.

(**
  [has_permission_ktask_base_info_with_stack_start task stack_start]
  是 `TaskBaseInfo` 的混合初始化视图：名字数组和其余标量字段仍只保留
  可写权限，而 `stack_start` 单元已经保存确定值。

  该谓词用于分配失败路径。它不会同时保留
  [has_permission_ktask_base_info]，从而避免对 `stack_start` 单元产生重叠所有权。

  可以直接使用 store_string_n p NAME_MAX_SIZE nil.
  由KTaskCreate的memset保证name空间的值；
*)
Definition has_permission_ktask_base_info_start0
           (task : addr) : Assertion :=
  CharArray.undef_full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name")) NAME_MAX_SIZE **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry")
      # Ptr |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param")
      # Ptr |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio")
      # UChar |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth")
      # UInt |->_ **
    &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start")
      # Ptr |-> 0.

(**
  将完整的 [TaskBaseInfo] 可写权限按当前函数实际访问的六个字段展开。
  该桥接仅用于 C 注解中的局部 [which implies]，不会改变公开前置条件的
  抽象边界。
*)
Lemma has_permission_ktask_base_info_open : forall task,
  has_permission_ktask_base_info task |--
  CharArray.undef_full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name"))
    NAME_MAX_SIZE **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry")
    # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param")
    # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio")
    # UChar |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth")
    # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start")
    # Ptr |->_ .
Proof.
  intros task.
  unfold has_permission_ktask_base_info.
  entailer!.
Qed.

(** 分配失败后，把值为零的 [stack_start] 与其余可写字段重新封装。 *)
Lemma has_permission_ktask_base_info_start0_intro : forall task,
  CharArray.undef_full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name"))
    NAME_MAX_SIZE **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry")
    # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param")
    # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio")
    # UChar |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth")
    # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start")
    # Ptr |-> 0 |--
  has_permission_ktask_base_info_start0 task.
Proof.
  intros task.
  unfold has_permission_ktask_base_info_start0.
  entailer!.
Qed.

(**
  [assert_task_base_info_values] 连接成功路径中抽象 [TaskBaseInfo] 的名字、
  入口、参数、优先级和栈深度字段。[stack_start] 不再通过额外
  逻辑变量重复绑定，而是由 [info.(tbStackStart)] 直接表示。
*)
Definition assert_task_base_info_values
           (info : TaskBaseInfoAbs)
           (copied_name : list Z)
           (entry parameter stack_depth priority : Z) : Prop :=
  info.(tbName) = copied_name /\
  info.(tbFuncEntry) = entry /\
  info.(tbFuncParam) = parameter /\
  info.(tbOriginPrio) = priority /\
  info.(tbStackDepth) = stack_depth.

(**
  [store_task_descriptor_base_info_init_post] 描述成功返回的完整局部内存。
  它保持 [store_task_base_info] 的整体抽象边界，不展开该谓词；该谓词
  已经拥有完整 32 字节名字数组。本后置条件同时保留最终 `stack_point`
  以及 `KTaskStackSetup` 产生的三个栈区视图。

  [aligned_top] 和 [context_addr] 在本谓词内部存在量化，并由纯条件分别
  固定为对齐后的栈顶和寄存器上下文地址。调用者只需提供 [task]、[info]
  和退出地址 [quit]；两个内部地址共同确定 `stack_point` 和三个栈区的
  所有权边界，但不额外拥有内存。
*)

Definition store_task_descriptor_base_info_init_post
           (task : addr) (info : TaskBaseInfoAbs)
           (quit : addr) : Assertion :=
  EX aligned_top context_addr : addr,
  “ aligned_top =
      ktask_stack_aligned_top
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ context_addr =
      ktask_stack_context_addr
        info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ ktask_stack_setup_layout_ok
      info.(tbStackStart) info.(tbStackDepth) REG_LENGTH ” &&
  “ aligned_reglen(context_addr) ” &&
  “ aligned_reglen(aligned_top) ” &&
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr |-> context_addr **
  store_task_base_info task info **
  store_ktask_stack_memset
    info.(tbStackStart) (context_addr - info.(tbStackStart)) **
  store_stack_register_context_slots
    context_addr
    (ktask_stack_context_region
       info.(tbFuncEntry) info.(tbFuncParam) quit) **
  store_ktask_stack_memset
    aligned_top
    (info.(tbStackStart) + info.(tbStackDepth) - aligned_top).

(** 展开纯输入谓词时保留原谓词，便于三个返回分支共同复用。 *)
Lemma ktask_init_input_arguments_ok_expose :
  forall entry parameter quit stack_depth priority,
    ktask_init_input_arguments_ok
      entry parameter quit stack_depth priority ->
    ktask_init_input_arguments_ok
      entry parameter quit stack_depth priority /\
    ktask_xubase_value entry /\
    ktask_xubase_value parameter /\
    ktask_xubase_value quit /\
    0 <= stack_depth <= Int.max_unsigned /\
    sizeof("StackRegisterContext") + REG_LENGTH - 1 <= stack_depth /\
    0 <= priority <= 255.
Proof.
  intros entry parameter quit stack_depth priority Hinput.
  pose proof Hinput as Hkeep.
  unfold ktask_init_input_arguments_ok in Hinput.
  split.
  - exact Hkeep.
  - tauto.
Qed.

(**
  分配器的非零结果、32 位地址上界以及加固后的栈深度下界共同推出
  [KTaskStackSetup] 所需的完整布局条件。
*)
Lemma ktask_bip_malloc_success_layout :
  forall stack_start stack_depth,
    0 < stack_start ->
    stack_start + stack_depth <= Int.max_unsigned ->
    sizeof("StackRegisterContext") + REG_LENGTH - 1 <= stack_depth ->
    ktask_stack_setup_layout_ok
      stack_start stack_depth REG_LENGTH.
Proof.
  intros stack_start stack_depth Hstart Hbound Hdepth.
  assert (Hsize : sizeof("StackRegisterContext") = 128).
  {
    rewrite ContextRegsSizeAxiom.
    unfold REG_COUNT.
    rewrite ktask_sizeof_uint.
    reflexivity.
  }
  assert (Hreg : REG_LENGTH = 4) by reflexivity.
  assert (Hraw_nonneg : 0 <= stack_start + stack_depth) by lia.
  assert (Halign_lower :
    stack_start + stack_depth - (REG_LENGTH - 1) <=
    ktask_stack_aligned_top stack_start stack_depth REG_LENGTH).
  {
    unfold ktask_stack_aligned_top, ktask_align_down.
    pose proof
      (Z.quot_rem
         (stack_start + stack_depth) REG_LENGTH ltac:(lia)) as Hqr.
    pose proof
      (Z.rem_bound_pos
         (stack_start + stack_depth) REG_LENGTH
         ltac:(lia) ltac:(lia)) as Hrem.
    lia.
  }
  unfold ktask_stack_setup_layout_ok.
  repeat split; try lia.
Qed.

(**
  [memset(..., '#', n)] 的有符号字符数组视图转换为栈谓词使用的
  无符号字符数组视图。35 的 8 位转换保持数值不变。
*)
Lemma store_char_array_memset_to_ktask_stack :
  forall p n,
    CharArray.full p n (repeat_Z 35 n) |--
    store_ktask_stack_memset p n.
Proof.
  intros p n.
  unfold CharArray.full, UCharArray.full, store_array,
         store_ktask_stack_memset, CHAR_SHARP, repeat_Z.
  remember (Z.to_nat n) as len.
  clear Heqlen.
  assert (Hconvert :
    forall lo,
      store_array_rec StoreCharAsElement.storeA p lo n (repeat 35 len) |--
      store_array_rec StoreUCharAsElement.storeA p lo n (repeat 35 len)).
  {
    induction len as [| len IH]; intros lo; simpl.
    - entailer!.
    - unfold StoreCharAsElement.storeA, StoreUCharAsElement.storeA.
      rewrite sizeof_char, sizeof_uchar.
      sep_apply store_char_cast.
      rewrite unsigned_last_nbits_eq by lia.
      sep_apply IH.
      entailer!.
  }
  apply Hconvert.
Qed.

(** 把完整栈字节数组按两个偏移切分为连续三段。 *)
Lemma store_ktask_stack_memset_split_three_for_parse :
  forall p n first second,
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

(** 按 [KTaskStackSetup] 的上下文地址和对齐栈顶切分整段栈资源。 *)
Lemma store_ktask_stack_memset_split_for_setup_for_parse :
  forall stack_start stack_depth,
    ktask_stack_setup_layout_ok
      stack_start stack_depth REG_LENGTH ->
    store_ktask_stack_memset stack_start stack_depth |--
    store_ktask_stack_memset
      stack_start
      (ktask_stack_context_addr
         stack_start stack_depth REG_LENGTH - stack_start) **
    store_ktask_stack_memset
      (ktask_stack_context_addr
         stack_start stack_depth REG_LENGTH)
      sizeof("StackRegisterContext") **
    store_ktask_stack_memset
      (ktask_stack_aligned_top
         stack_start stack_depth REG_LENGTH)
      (stack_start + stack_depth -
       ktask_stack_aligned_top
         stack_start stack_depth REG_LENGTH).
Proof.
  intros stack_start stack_depth Hlayout.
  pose proof Hlayout as Hparts.
  unfold ktask_stack_setup_layout_ok in Hparts.
  destruct Hparts as
    (Hstart & Hreg & Hdepth & Hbound & Hcontext_fits).
  pose proof
    (ktask_stack_aligned_top_le_raw_top
       stack_start stack_depth REG_LENGTH ltac:(lia) Hreg) as Htop.
  assert (Hsize : 0 <= sizeof("StackRegisterContext")).
  {
    rewrite ContextRegsSizeAxiom, ktask_sizeof_uint.
    unfold REG_COUNT.
    lia.
  }
  unfold ktask_stack_context_addr.
  sep_apply_l_atomic
    (store_ktask_stack_memset_split_three_for_parse
       stack_start stack_depth
       (ktask_stack_aligned_top
          stack_start stack_depth REG_LENGTH -
        sizeof("StackRegisterContext") - stack_start)
       (ktask_stack_aligned_top
          stack_start stack_depth REG_LENGTH - stack_start)
       ltac:(lia)).
  replace
    (stack_start +
       (ktask_stack_aligned_top
          stack_start stack_depth REG_LENGTH -
        sizeof("StackRegisterContext") - stack_start))
    with
    (ktask_stack_aligned_top
       stack_start stack_depth REG_LENGTH -
     sizeof("StackRegisterContext")) by lia.
  replace
    ((ktask_stack_aligned_top
        stack_start stack_depth REG_LENGTH - stack_start) -
     (ktask_stack_aligned_top
        stack_start stack_depth REG_LENGTH -
      sizeof("StackRegisterContext") - stack_start))
    with (sizeof("StackRegisterContext")) by lia.
  replace
    (stack_start +
     (ktask_stack_aligned_top
        stack_start stack_depth REG_LENGTH - stack_start))
    with
    (ktask_stack_aligned_top
       stack_start stack_depth REG_LENGTH) by lia.
  replace
    (stack_depth -
     (ktask_stack_aligned_top
        stack_start stack_depth REG_LENGTH - stack_start))
    with
    (stack_start + stack_depth -
     ktask_stack_aligned_top
       stack_start stack_depth REG_LENGTH) by lia.
  entailer!.
Qed.
