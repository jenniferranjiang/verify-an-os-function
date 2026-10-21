Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From compcert.lib Require Import Integers.
From SimpleC.SL Require Import Mem IntLib CArch CNotation.
Require Export CRTOS_Verify.libai.TaskStatus.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Module Import KTaskCNotation := CNotationSig Arch32.

Local Open Scope Z_scope.
Local Open Scope string.

(**
  本文件集中保存任务 Global State 与任务局部空间谓词共同使用的纯类型和
  纯计算。它不导入 [CrtosGlobState]、[CrtosRules] 或任何 separation
  logic assertion 模块，因此正式 Global State 可以安全导入本文件，而
  [KTaskStackSetup]、[KTaskSchedMember] 等空间谓词也可以反向复用这些类型，不会形成导入环。

  本文件中的定义均不拥有 C 内存。字段地址对应的读写权限仍由各自的
  [store_*] 谓词提供；这里仅固定抽象值、配置常量和栈地址计算。
*)


(**
  [TaskSchedMemberAbs] 是 C 嵌入结构 [TaskDyncSchedMember] 中六个调度
  标量字段的纯抽象。

  [tsmStat] 使用 TaskStatus，具体 stat 字节只在内存谓词中解码；其余五字段
  保存原有数值。

  [tsmStat]、[tsmAdvanceCnt]、[tsmCurPrio]、[tsmOriginTimeslice]、
  [tsmRestTimeslice] 和 [tsmBitmapColumn] 分别对应同名 C 字段。记录不含
  [sched_link]，因为链表节点有独立空间所有者；也不含当前初始化函数未
  访问的 [delay]。内存所有权由 [store_task_sched_member] 提供。
*)
Record TaskSchedMemberAbs : Type := mkTaskSchedMemberAbs {
  tsmStat : TaskStatus;
  tsmAdvanceCnt : Z;
  tsmCurPrio : Z;
  tsmOriginTimeslice : Z;
  tsmRestTimeslice : Z;
  tsmBitmapColumn : Z
}.

(**
  [TaskBaseInfoAbs] 是 C 嵌入结构 [TaskDescriptor.task_base_info] 的纯抽象。

  字段对应关系：
  - [tbName]：固定名字槽中的有效字符序列；
  - [tbFuncEntry]、[tbFuncParam]：任务入口及入口参数；
  - [tbOriginPrio]：初始优先级；
  - [tbStackDepth]、[tbStackStart]：外部分配任务栈的字节长度和基址。

  该记录不拥有嵌入结构或外部栈内存。前者由 [store_task_base_info] 拥有，
  后者由任务栈谓词拥有。
*)
Record TaskBaseInfoAbs : Type := mkTaskBaseInfoAbs {
  tbName : list Z;
  tbFuncEntry : addr;
  tbFuncParam : addr;
  tbOriginPrio : Z;
  tbStackDepth : Z;
  tbStackStart : addr
}.

(**
  [StackRegisterContextAbs] 是 C 结构体 [StackRegisterContext] 的纯寄存器
  快照。32 个字段按当前 RISC-V 非 FPU 布局逐一对应 C 字段；该记录既不
  声称地址布局成立，也不拥有任何寄存器槽内存。
*)
Record StackRegisterContextAbs : Type := mkStackRegisterContextAbs {
  Epc : Z;
  Ra : Z;
  Mstatus : Z;
  Gp : Z;
  Tp : Z;
  T0 : Z;
  T1 : Z;
  T2 : Z;
  S0Fp : Z;
  S1 : Z;
  A0 : Z;
  A1 : Z;
  A2 : Z;
  A3 : Z;
  A4 : Z;
  A5 : Z;
  A6 : Z;
  A7 : Z;
  S2 : Z;
  S3 : Z;
  S4 : Z;
  S5 : Z;
  S6 : Z;
  S7 : Z;
  S8 : Z;
  S9 : Z;
  S10 : Z;
  S11 : Z;
  T3 : Z;
  T4 : Z;
  T5 : Z;
  T6 : Z
}.


(** 当前 32 位配置下，可写入 [x_ubase] 或转换为地址的数学值范围。 *)
Definition ktask_xubase_value (x : Z) : Prop :=
  0 <= x <= Int.max_unsigned.

(** 当前 RISC-V 非 FPU 配置使用的任务栈初始化常量。 *)
Definition OxFADEFACE : Z := 4208917198.
Definition CHAR_SHARP : Z := 35.
Definition SAVED_MSTATUS : Z := 30848.
Definition REG_LENGTH : Z := 4.

(** [kss_raw_top] 是任务栈半开区间的数学上界，不执行模地址运算。 *)
Definition kss_raw_top (info : TaskBaseInfoAbs) : addr :=
  info.(tbStackStart) + info.(tbStackDepth).

(** [ktask_align_down] 对应 C 宏 [ALIGN_MEN_DOWN(size, align)]。 *)
Definition ktask_align_down (x align : Z) : Z :=
  (x ÷ align) * align.

(**
  [ktask_stack_aligned_top] 计算任务栈原始上界按寄存器宽度向下对齐后的
  地址。其调用者必须另行提供非零对齐量和无溢出条件。
*)
Definition ktask_stack_aligned_top
    (stack_start stack_depth reg_length : Z) : Z :=
  ktask_align_down (stack_start + stack_depth) reg_length.

(**
  [ktask_stack_context_addr] 对应 KTaskStackSetup 从对齐栈顶减去完整
  [StackRegisterContext] 大小后得到的上下文首地址。
*)
Definition ktask_stack_context_addr
    (stack_start stack_depth reg_len : Z) : Z :=
  ktask_stack_aligned_top stack_start stack_depth reg_len -
  sizeof("StackRegisterContext").

(** 使用当前 [REG_LENGTH] 配置计算一个基础信息记录的两个关键栈地址。 *)
Definition kss_aligned_top (info : TaskBaseInfoAbs) : addr :=
  ktask_stack_aligned_top
    info.(tbStackStart) info.(tbStackDepth) REG_LENGTH.

Definition kss_context_addr (info : TaskBaseInfoAbs) : addr :=
  ktask_stack_context_addr
    info.(tbStackStart) info.(tbStackDepth) REG_LENGTH.


(**
  [ktask_stack_setup_layout_ok] 是发布任务栈所保留的地址合法性条件：栈区
  非空、地址加法不超过 32 位上界，并且向下对齐后仍能容纳完整寄存器
  上下文。该命题不提供栈内存所有权。
*)
Definition ktask_stack_setup_layout_ok
    (stack_start stack_depth reg_len : Z) : Prop :=
  stack_start > 0 /\
  reg_len > 0 /\
  stack_depth > 0 /\
  stack_start + stack_depth <= Int.max_unsigned /\
  stack_start + sizeof("StackRegisterContext") <=
    ktask_stack_aligned_top stack_start stack_depth reg_len.

(**
  [ktask_context_regs_setup] 构造 KTaskStackSetup 完成后的寄存器上下文：
  [epc] 保存入口，[ra] 保存退出函数，[a0] 保存参数，[mstatus] 和 [tp]
  使用调用者给定值，其余寄存器保持 [OxFADEFACE] 填充值。
*)
Definition ktask_context_regs_setup
    (entry param quit mstatus tp : Z) : StackRegisterContextAbs :=
  mkStackRegisterContextAbs
    entry quit mstatus
    OxFADEFACE
    tp
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    param
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE
    OxFADEFACE.

(** 当前配置下寄存器槽地址按 [REG_LENGTH] 对齐。 *)
Definition aligned_reglen (x : Z) : Prop :=
  x mod REG_LENGTH = 0.
