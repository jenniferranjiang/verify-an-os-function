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
  - [priority] 是 C 中的 `uint8` 优先级，验证调用域要求闭区间 [0, 31]。

  栈深度下界额外保留 [RegLength - 1] 字节，用于在任意栈起始地址下
  吸收向下对齐造成的最大损失。任务名字的内存所有权和字符合法性由
  函数规格中 [store_string] 单独描述；该名称来自 [Crtos_C_Rules]，
  与本文件其他内存谓词使用同一个 [Assertion]。因此，本纯谓词只接收
  五个地址或数值参数，不再接收与其定义无关的源字符串参数。
  优先级上界按 2026-09-23 审阅收紧，与 task_world_wf 及 32 个优先级
  配置一致；不更改 PRIORITY_MAX=32 或原 C 错误分支。该范围仍包含
  31，不能直接用来满足 bitmap helper 当前要求的有符号左移安全域。
*)

Definition ktask_init_input_arguments_ok
           (entry parameter quit stack_depth priority : Z) : Prop :=
  ktask_xubase_value entry /\
  ktask_xubase_value parameter /\
  ktask_xubase_value quit /\
  0 <= stack_depth <= Int.max_unsigned /\
  sizeof("StackRegisterContext") + REG_LENGTH - 1 <= stack_depth /\
  0 <= priority <= 31.

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
  展开纯输入谓词时保留原谓词；维持既有 uchar 范围结论供原调用点复用。
  更强的 [priority <= 31] 已包含在保留的输入谓词中。
*)
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
  - intuition lia.
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
  change KTaskPure.KTaskCNotation.sizeof_front_end_type
    with sizeof_front_end_type.
  repeat split; try lia.
Qed.

(**
  [memset(..., '#', n)] 的有符号字符数组视图转换为栈谓词使用的
  无符号字符数组视图。35 的 8 位转换保持数值不变。
*)
Lemma store_char_repeat_to_uchar_repeat :
  forall p n,
    CharArray.full p n (repeat_Z 35 n) |--
    UCharArray.full p n (repeat_Z CHAR_SHARP n).
Proof.
  intros p n.
  unfold CharArray.full, UCharArray.full, store_array,
         CHAR_SHARP, repeat_Z.
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
