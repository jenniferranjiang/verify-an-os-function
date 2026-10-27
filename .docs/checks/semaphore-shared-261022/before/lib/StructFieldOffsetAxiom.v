Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Import ListNotations.
Require Import Coq.micromega.Lia.
(* From SimpleC.SL Require Import Mem SeparationLogic. *)
From SimpleC.SL Require Import Mem IntLib CArch CNotation.
Module Import KTaskCNotation := CNotationSig Arch32.
Require Import Logic.LogicGenerator.demo932.Interface.

Local Open Scope Z_scope.
Local Open Scope string.

(**
  本文件集中保存 CRTOS 当前 32 位验证配置中，由目标 C ABI 决定、
  但 Rocq/QCP 内存模型本身不会推导的结构体布局事实。

  这些事实属于验证的显式可信基。所有 [*_ok] 都是纯命题，不拥有任何
  C 内存。字段偏移与结构体大小分层表达：[*_field_offset_ok] 只描述字段
  地址，独立的 [*_size_axiom] 只描述 [sizeof]，避免 Spec 和证明重复携带
  同一个大小事实。

  特别地，本文件中的 [TaskDescriptor] 布局对应 QCP 当前使用的
  [annotated_C/src/headers/m_ktask.h]：原 C 声明中的 29/3 位事件位域在
  该验证头中被规范化为两个普通 [uint32] 字段。因此这里的 120 字节
  布局是 QCP 验证模型的 ABI 假设，不宣称等同于仍保留共享位域存储单元
  的 [annotated_C/src/include/xs_ktask.h] 原始声明。
*)

(**
  [ALIGN_SIZE] 是当前验证目标的结构体和寄存器地址对齐粒度（字节）。
  该名称刻意不复用 C 宏 [MEM_SIZE_ALIGN]，避免 QCP 预处理常量与 Rocq
  标识符冲突。
*)
Definition ALIGN_SIZE : Z := 4.

(**
  [addr_aligned p alignment] 表示整数地址 [p] 是 [alignment] 的整数倍。

  该定义沿用现有 [aligned_reglen] 的“地址对模数取模为零”表示方式，
  但显式保留对齐粒度参数，以便布局公理统一写成
  [addr_aligned p ALIGN_SIZE]。调用者应为 [alignment] 提供正整数；本谓词
  本身不保证 [p] 非空、位于 C 地址范围内或指向已分配对象，也不拥有
  地址 [p] 指向的内存；这些有效性和所有权条件仍须由函数规格提供。
*)
Definition addr_aligned (p alignment : Z) : Prop :=
  p mod alignment = 0.

(** 当前 32 位 ABI 中各目标结构体占用的总字节数。 *)
Definition TASK_MEM_SIZE : Z := 120.
Definition STACK_REGISTER_CONTEXT_SIZE : Z := 128.
Definition DELAY_MEM_SIZE : Z := 20.
Definition OS_ASSIGN_READY_NODE_SIZE : Z := 8.
Definition OS_ASSIGN_READY_VECTOR_SIZE : Z := 264.
Definition ID_NODE_MEM_SIZE : Z := 12.
Definition MUTEX_MEM_SIZE : Z := 36.
Definition EVENT_MEM_SIZE : Z := 36.
Definition MSGQUEUE_MEM_SIZE : Z := 52.
Definition MSGQUEUE_DONE_SIZE : Z := 24.
Definition IRQ_DESC_SIZE : Z := 8.
Definition ISR_DONE_SIZE : Z := 48.
Definition ISR_MANAGER_SIZE : Z := 536.
Definition ASSIGN_MEM_SIZE : Z := 276.

(**
  以下五个局部谓词按嵌套 C 结构体边界组织 [TaskDescriptor] 的字段关系。
  参数 [actual_addr] 是 QCP 字段寻址表达式得到的地址，
  [expected_addr] 是从外层结构体首地址按 ABI 偏移算出的地址。
  它们均为纯命题，不拥有字段或填充字节。
*)
Definition ktask_base_info_field_offset_ok
    (actual_addr expected_addr : addr) : Prop :=
  actual_addr = expected_addr /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "name") = expected_addr + 0 /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "func_entry") = expected_addr + 32 /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "func_param") = expected_addr + 36 /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "origin_prio") = expected_addr + 40 /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "stack_depth") = expected_addr + 44 /\
  &(actual_addr # "TaskBaseInfo" ->ₛ "stack_start") = expected_addr + 48.

Definition ktask_sched_link_field_offset_ok
    (actual_addr expected_addr : addr) : Prop :=
  actual_addr = expected_addr /\
  &(actual_addr # "SysDoubleLinklistNode" ->ₛ "node_next") =
    expected_addr + 0 /\
  &(actual_addr # "SysDoubleLinklistNode" ->ₛ "node_prev") =
    expected_addr + 4.

Definition ktask_dync_sched_field_offset_ok
    (actual_addr expected_addr : addr) : Prop :=
  actual_addr = expected_addr /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "stat") = expected_addr + 0 /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "advance_cnt") =
    expected_addr + 1 /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "cur_prio") =
    expected_addr + 2 /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "origin_timeslice") =
    expected_addr + 4 /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "rest_timeslice") =
    expected_addr + 8 /\
  ktask_sched_link_field_offset_ok
    (&(actual_addr # "TaskDyncSchedMember" ->ₛ "sched_link"))
    (expected_addr + 12) /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "bitmap_column") =
    expected_addr + 20 /\
  &(actual_addr # "TaskDyncSchedMember" ->ₛ "delay") =
    expected_addr + 24.

Definition ktask_link_field_offset_ok
    (actual_addr expected_addr : addr) : Prop :=
  actual_addr = expected_addr /\
  &(actual_addr # "SysDoubleLinklistNode" ->ₛ "node_next") =
    expected_addr + 0 /\
  &(actual_addr # "SysDoubleLinklistNode" ->ₛ "node_prev") =
    expected_addr + 4.

Definition ktask_id_node_offset_ok
    (actual_addr expected_addr : addr) : Prop :=
  actual_addr = expected_addr /\
  &(actual_addr # "IdNode" ->ₛ "id") = expected_addr + 0 /\
  ktask_link_field_offset_ok
    (&(actual_addr # "IdNode" ->ₛ "link")) (expected_addr + 4).

(**
  [ktask_descriptor_field_offset_wf p] 以嵌套结构表示
  [TaskDescriptor] 的完整字段布局；[ktask_descriptor_field_offset_ok] 是
  同一布局的平铺表示，供现有证明按叶子字段直接析取。

  两种表示都只描述字段地址；[sizeof("TaskDescriptor")] 由独立的
  [task_descriptor_size_axiom] 提供，不作为字段布局谓词的重复合取。
*)
Definition ktask_descriptor_field_offset_wf (p : addr) : Prop :=
  &(p # "TaskDescriptor" ->ₛ "stack_point") = p + 0 /\
  ktask_dync_sched_field_offset_ok
    (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member")) (p + 4) /\
  ktask_base_info_field_offset_ok
    (&(p # "TaskDescriptor" ->ₛ "task_base_info")) (p + 32) /\
  &(p # "TaskDescriptor" ->ₛ "event_id_trigger") = p + 84 /\
  &(p # "TaskDescriptor" ->ₛ "event_mode") = p + 88 /\
  &(p # "TaskDescriptor" ->ₛ "exstatus") = p + 92 /\
  ktask_link_field_offset_ok
    (&(p # "TaskDescriptor" ->ₛ "link")) (p + 96) /\
  ktask_id_node_offset_ok
    (&(p # "TaskDescriptor" ->ₛ "id")) (p + 104) /\
  &(p # "TaskDescriptor" ->ₛ "Done") = p + 116.

Definition ktask_descriptor_field_offset_ok (p : addr) : Prop :=
  &(p # "TaskDescriptor" ->ₛ "stack_point") = p + 0 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member") = p + 4 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "stat") =
    p + 4 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "advance_cnt") =
    p + 5 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") =
    p + 6 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "origin_timeslice") =
    p + 8 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "rest_timeslice") =
    p + 12 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") =
    p + 16 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ
      "sched_link" .ₛ "node_next") = p + 16 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ
      "sched_link" .ₛ "node_prev") = p + 20 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "bitmap_column") =
    p + 24 /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") =
    p + 28 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info") = p + 32 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name") = p + 32 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry") = p + 64 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param") = p + 68 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio") = p + 72 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth") = p + 76 /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start") = p + 80 /\
  &(p # "TaskDescriptor" ->ₛ "event_id_trigger") = p + 84 /\
  &(p # "TaskDescriptor" ->ₛ "event_mode") = p + 88 /\
  &(p # "TaskDescriptor" ->ₛ "exstatus") = p + 92 /\
  &(p # "TaskDescriptor" ->ₛ "link") = p + 96 /\
  &(p # "TaskDescriptor" ->ₛ "link" .ₛ "node_next") = p + 96 /\
  &(p # "TaskDescriptor" ->ₛ "link" .ₛ "node_prev") = p + 100 /\
  &(p # "TaskDescriptor" ->ₛ "id") = p + 104 /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "id") = p + 104 /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link") = p + 108 /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link" .ₛ "node_next") = p + 108 /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link" .ₛ "node_prev") = p + 112 /\
  &(p # "TaskDescriptor" ->ₛ "Done") = p + 116.

(**
  [ktask_stack_context_field_offsets_ok p] 描述
  [StackRegisterContext] 的 32 个寄存器槽。每个偏移显式按
  [sizeof(UINT)] 计算，与现有定义保持一致，不把字段宽度错误地绑定到
  可能随目标 ABI 改变的地址对齐常量 [ALIGN_SIZE]。该谓词不拥有寄存器
  槽内存。
*)
Definition ktask_stack_context_field_offsets_ok (p : addr) : Prop :=
  &(p # "StackRegisterContext" ->ₛ "epc") = p + 0 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "ra") = p + 1 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "mstatus") = p + 2 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "gp") = p + 3 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "tp") = p + 4 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t0") = p + 5 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t1") = p + 6 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t2") = p + 7 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s0_fp") = p + 8 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s1") = p + 9 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a0") = p + 10 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a1") = p + 11 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a2") = p + 12 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a3") = p + 13 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a4") = p + 14 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a5") = p + 15 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a6") = p + 16 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "a7") = p + 17 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s2") = p + 18 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s3") = p + 19 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s4") = p + 20 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s5") = p + 21 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s6") = p + 22 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s7") = p + 23 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s8") = p + 24 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s9") = p + 25 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s10") = p + 26 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "s11") = p + 27 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t3") = p + 28 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t4") = p + 29 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t5") = p + 30 * sizeof(UINT) /\
  &(p # "StackRegisterContext" ->ₛ "t6") = p + 31 * sizeof(UINT).

(**
  [delay_field_offset_ok delay] 描述 [Delay] 的非链表字段与内嵌链表节点。
  [status] 后的 3 字节填充通过 [link] 从偏移 12 开始体现。
*)
Definition delay_field_offset_ok (delay : addr) : Prop :=
  &(delay # "Delay" ->ₛ "task") = delay + 0 /\
  &(delay # "Delay" ->ₛ "ticks") = delay + 4 /\
  &(delay # "Delay" ->ₛ "status") = delay + 8 /\
  &(delay # "Delay" ->ₛ "link") = delay + 12 /\
  &(delay # "Delay" ->ₛ "link" .ₛ "node_next") = delay + 12 /\
  &(delay # "Delay" ->ₛ "link" .ₛ "node_prev") = delay + 16.

(** 计算 C 内嵌数组 [priority_ready_vector] 的首地址。 *)
Definition priority_ready_vector_base (ready_vector : addr) : addr :=
  &(ready_vector # "OsAssignReadyVector" ->ₛ "priority_ready_vector").

(**
  [os_assign_ready_vector_field_offset_ok ready_vector] 描述 32 个双链表头
  构成的内嵌数组首地址及其后的两个标量字段偏移。
  数组元素及外层结构体大小由下方两个独立 size axioms 提供，不在本谓词
  中重复保存。
*)
Definition os_assign_ready_vector_field_offset_ok
    (ready_vector : addr) : Prop :=
  priority_ready_vector_base ready_vector = ready_vector + 0 /\
  &(ready_vector # "OsAssignReadyVector" ->ₛ "priority_ready_group") =
    ready_vector + 256 /\
  &(ready_vector # "OsAssignReadyVector" ->ₛ "highest_prio") =
    ready_vector + 260.

Definition mutex_field_offset_ok (p : addr) : Prop :=
  &(p # "Mutex" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "link") = p + 4 /\
  &(p # "Mutex" ->ₛ "val") = p + 12 /\
  &(p # "Mutex" ->ₛ "recursive_cnt") = p + 14 /\
  &(p # "Mutex" ->ₛ "origin_prio") = p + 15 /\
  &(p # "Mutex" ->ₛ "holder") = p + 16 /\
  &(p # "Mutex" ->ₛ "pend_list") = p + 20 /\
  &(p # "Mutex" ->ₛ "link") = p + 28 /\
  (forall node, In node [p + 4; p + 20; p + 28] ->
    &(node # "SysDoubleLinklistNode" ->ₛ "node_next") = node /\
    &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") = node + 4).

Definition event_field_offset_ok (p : addr) : Prop :=
  ktask_id_node_offset_ok (&(p # "Event" ->ₛ "id")) p /\
  &(p # "Event" ->ₛ "options") = p + 12 /\
  &(p # "Event" ->ₛ "events") = p + 16 /\
  ktask_link_field_offset_ok (&(p # "Event" ->ₛ "pend_list")) (p + 20) /\
  ktask_link_field_offset_ok (&(p # "Event" ->ₛ "link")) (p + 28).

Definition msgqueue_field_offset_ok (p : addr) : Prop :=
  ktask_id_node_offset_ok (&(p # "MsgQueue" ->ₛ "id")) p /\
  &(p # "MsgQueue" ->ₛ "msg_buf") = p + 12 /\
  &(p # "MsgQueue" ->ₛ "index") = p + 16 /\
  &(p # "MsgQueue" ->ₛ "num_msgs") = p + 18 /\
  &(p # "MsgQueue" ->ₛ "each_len") = p + 20 /\
  &(p # "MsgQueue" ->ₛ "max_msgs") = p + 22 /\
  ktask_link_field_offset_ok (&(p # "MsgQueue" ->ₛ "send_pend_list")) (p + 24) /\
  ktask_link_field_offset_ok (&(p # "MsgQueue" ->ₛ "recv_pend_list")) (p + 32) /\
  ktask_link_field_offset_ok (&(p # "MsgQueue" ->ₛ "link")) (p + 40) /\
  &(p # "MsgQueue" ->ₛ "Done") = p + 48.

Definition msgqueue_done_field_offset_ok (p : addr) : Prop :=
  &(p # "MsgQueueDone" ->ₛ "init") = p /\
  &(p # "MsgQueueDone" ->ₛ "urgensend") = p + 4 /\
  &(p # "MsgQueueDone" ->ₛ "send") = p + 8 /\
  &(p # "MsgQueueDone" ->ₛ "recv") = p + 12 /\
  &(p # "MsgQueueDone" ->ₛ "reinit") = p + 16 /\
  &(p # "MsgQueueDone" ->ₛ "Delete") = p + 20.

Definition irq_desc_field_offset_ok (p : addr) : Prop :=
  &(p # "IrqDesc" ->ₛ "handler") = p /\
  &(p # "IrqDesc" ->ₛ "param") = p + 4.

Definition isr_done_field_offset_ok (p : addr) : Prop :=
  &(p # "IsrDone" ->ₛ "isInIsr") = p /\
  &(p # "IsrDone" ->ₛ "registerIrq") = p + 4 /\
  &(p # "IsrDone" ->ₛ "freeIrq") = p + 8 /\
  &(p # "IsrDone" ->ₛ "enableIrq") = p + 12 /\
  &(p # "IsrDone" ->ₛ "disableIrq") = p + 16 /\
  &(p # "IsrDone" ->ₛ "handleIrq") = p + 20 /\
  &(p # "IsrDone" ->ₛ "getCounter") = p + 24 /\
  &(p # "IsrDone" ->ₛ "incCounter") = p + 28 /\
  &(p # "IsrDone" ->ₛ "decCounter") = p + 32 /\
  &(p # "IsrDone" ->ₛ "getSwitchTrigerFlag") = p + 36 /\
  &(p # "IsrDone" ->ₛ "setSwitchTrigerFlag") = p + 40 /\
  &(p # "IsrDone" ->ₛ "clearSwitchTrigerFlag") = p + 44.

Definition isr_manager_field_offset_ok (p : addr) : Prop :=
  &(p # "InterruptServiceRoutines" ->ₛ "isr_count") = p /\
  &(p # "InterruptServiceRoutines" ->ₛ "isr_switch_trigger_flag") = p + 2 /\
  &(p # "InterruptServiceRoutines" ->ₛ "irq_table") = p + 4 /\
  &(p # "InterruptServiceRoutines" ->ₛ "done") = p + 532.

Definition assign_field_offset_ok (p : addr) : Prop :=
  &(p # "Assign" ->ₛ "os_assign_ready_vector") = p /\
  &(p # "Assign" ->ₛ "os_running_task") = p + 264 /\
  &(p # "Assign" ->ₛ "ready_vector_done") = p + 268 /\
  &(p # "Assign" ->ₛ "current_priority") = p + 272.

(** 
  下列公理是本文件唯一的 ABI 信任入口。

  动态分配的 [TaskDescriptor] 与 [Delay] 分别由 [KERNEL_MALLOC] 和
  [x_malloc] 规格直接提供 [addr_aligned p ALIGN_SIZE]，再由相应字段布局
  公理恢复具体偏移。[StackRegisterContext] 位于动态任务栈内部，其地址
  对齐由栈顶向下对齐及 context 地址计算推出，而不是 allocator 直接返回。

  [OsAssignReadyVector] 则是项目全局变量 [Assign] 的内嵌对象。它的基址
  不是 allocator 返回值，不应让每个函数重复携带局部对齐假设；其布局
  由无条件全局公理统一提供。所有 [*_ok] 仍是纯命题，不拥有内存。
*)
Axiom task_descriptor_size_axiom :
  sizeof("TaskDescriptor") = TASK_MEM_SIZE.

Axiom task_descriptor_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    ktask_descriptor_field_offset_ok p.

Axiom stack_register_context_size_axiom :
  sizeof("StackRegisterContext") = STACK_REGISTER_CONTEXT_SIZE.

Axiom stack_register_context_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    ktask_stack_context_field_offsets_ok p.

Axiom delay_size_axiom :
  sizeof("Delay") = DELAY_MEM_SIZE.

Axiom delay_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    delay_field_offset_ok p.

(**
  [OsAssignReadyVector] 的数组地址推理还依赖数组元素
  [SysDoubleLinklistNode] 的大小，因此该辅助大小事实也在此统一声明。
*)
Axiom os_assign_ready_node_size_axiom :
  sizeof("SysDoubleLinklistNode") = OS_ASSIGN_READY_NODE_SIZE.

Axiom os_assign_ready_vector_size_axiom :
  sizeof("OsAssignReadyVector") = OS_ASSIGN_READY_VECTOR_SIZE.

(**
  项目实例是全局 [Assign.os_assign_ready_vector]。该公理把字段偏移视为
  当前 QCP 32 位数据模型中对基址平移不变的类型布局事实，因此按设计对
  任意 [p] 提供，而不要求调用者在 Spec 或全局不变量中重复保存对齐条件。
*)
Axiom os_assign_ready_vector_field_offset_axiom :
  forall p, os_assign_ready_vector_field_offset_ok p.

(** 其余 ABI 事实由 32 位验证头的 sizeof/offsetof 编译断言核对。
    动态 IPC 对象沿用 TaskDescriptor 的基址对齐前提；静态函数表、
    ISR 内嵌数组与 Assign 沿用全局 ready-vector 的无条件字段布局形式。
    这些公理只描述类型布局，不授予任何内存或对象存活权限。 *)
Axiom id_node_size_axiom : sizeof("IdNode") = ID_NODE_MEM_SIZE.

Axiom mutex_size_axiom : sizeof("Mutex") = MUTEX_MEM_SIZE.

Axiom mutex_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    mutex_field_offset_ok p.

Axiom event_size_axiom : sizeof("Event") = EVENT_MEM_SIZE.

Axiom event_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    event_field_offset_ok p.

Axiom msgqueue_size_axiom : sizeof("MsgQueue") = MSGQUEUE_MEM_SIZE.

Axiom msgqueue_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE ->
    msgqueue_field_offset_ok p.

Axiom msgqueue_done_size_axiom : sizeof("MsgQueueDone") = MSGQUEUE_DONE_SIZE.

Axiom msgqueue_done_field_offset_axiom :
  forall p, msgqueue_done_field_offset_ok p.

Axiom irq_desc_size_axiom : sizeof("IrqDesc") = IRQ_DESC_SIZE.

Axiom irq_desc_field_offset_axiom :
  forall p, irq_desc_field_offset_ok p.

Axiom isr_done_size_axiom : sizeof("IsrDone") = ISR_DONE_SIZE.

Axiom isr_done_field_offset_axiom :
  forall p, isr_done_field_offset_ok p.

Axiom isr_manager_size_axiom : sizeof("InterruptServiceRoutines") = ISR_MANAGER_SIZE.

Axiom isr_manager_field_offset_axiom :
  forall p, isr_manager_field_offset_ok p.

Axiom assign_size_axiom : sizeof("Assign") = ASSIGN_MEM_SIZE.

Axiom assign_field_offset_axiom :
  forall p, assign_field_offset_ok p.

Definition REG_COUNT : Z := 32.

(**
  以下三个纯命题记录当前 ABI 的上下文大小、槽数量和组合布局要求。
  本文件不声明这些命题成立的公理；具体布局证据仍留在验证该 C 结构体的
  模块中。
*)
Definition ktask_stack_context_size_ok : Prop :=
  sizeof("StackRegisterContext") = REG_COUNT * sizeof(UINT).

Definition ktask_stack_context_count_ok : Prop :=
  REG_COUNT = 32 /\ 0 <= REG_COUNT <= INT_MAX.

Definition ktask_stack_context_layout_ok : Prop :=
  ktask_stack_context_size_ok /\
  ktask_stack_context_count_ok.
