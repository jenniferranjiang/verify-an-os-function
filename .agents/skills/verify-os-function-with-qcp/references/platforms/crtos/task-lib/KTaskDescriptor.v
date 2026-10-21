Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.lib.KTaskParseInfo.
Require Import CRTOS_Verify.lib.KTaskSchedMember.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

Import IDNode.

(**
  本文件汇总当前配置下 [struct TaskDescriptor] 初始化所需的字段权限。

  这些谓词面向 [KTaskCreate] 分配并清零任务描述符后的初始化流程。
  它们只描述结构体字段本身，不拥有任务栈、ID manager、任务全局链表
  哨兵或静态 [Done] 函数表所指向对象的内存。

  基础信息与动态调度成员分别复用已经存在的
  [has_permission_ktask_base_info] 和
  [has_permission_task_sched_member]，避免在这里复制字段布局。
*)

(**
  [has_permission_idnode idnode] 表示嵌入式 [struct IdNode] 可供
  [IdInsertObj] 初始化和插入：

  - [idnode->id] 是一个未初始化的 [uint16] 单元；
  - [idnode->link.node_prev] 和 [idnode->link.node_next] 是两个
    未初始化的指针单元。

  [lib/idnode.v] 已经提供完全相同的参数化谓词
  [store_idnode_insert_ready]。这里不复制其定义，而是在
  [Task_C_Rules] 实例 [TaskIDNode] 上提供符合 TaskDescriptor 命名
  习惯的薄包装。该谓词也继承 lib 定义中的 [idnode <> 0] 和
  嵌入式 link 地址非零条件。
*)
Definition has_permission_idnode (idnode : addr) : Assertion :=
  IDNode.store_idnode_insert_ready idnode.

(**
  [has_permission_task_link task] 拥有 C 字段 [task->link] 中
  [node_prev] 和 [node_next] 两个可写指针槽。

  该资源只表示新分配 TaskDescriptor 中尚未初始化的管理链表节点。
  当节点被插入 [xiaoshan_task_head] 后，这两个槽的所有权应转入
  全局 [store_task_head]，不能同时继续保留本谓词。
*)
Definition has_permission_task_link (task : addr) : Assertion :=
  &(task # "TaskDescriptor" ->ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "link" .ₛ "node_next") # Ptr |->_.

(**
  [has_permission_task_direct_member task] 汇总直接位于
  [struct TaskDescriptor] 下、且不属于基础信息、动态调度成员、管理
  链表或 ID node 的五组字段权限：

  - [stack_point]：任务当前栈指针，C 类型为 [void *]；
  - [event_id_trigger]：事件触发值，当前验证头文件中的类型为
    [uint32]；
  - [event_mode]：事件模式，当前验证头文件中的类型为 [uint32]；
  - [exstatus]：异常状态，[x_err_t] 在当前验证配置中等价于
    有符号 [int]；
  - [Done]：指向 [struct KTaskDone] 的指针。

  所有字段在初始化函数写入前都只需要未初始化可写权限。本谓词拥有
  [Done] 指针槽本身，但不拥有该指针以后指向的静态函数表；后者由
  锁外资源 [store_task_done] 单独描述。

  布局边界：本定义严格遵循当前验证切片使用的
  [annotated_C/src/headers/m_ktask.h]，其中两个 event 字段是两个独立
  [uint32]。参考 CRTOS 的 [xs_ktask.h] 则把它们声明为共享同一
  32 位存储单元的 29/3 位 bitfield。进入 Stage 2 前必须由人工确认
  这一验证头抽象是否可接受；本文件不声称两种 ABI 布局等价。
*)
Definition has_permission_task_direct_member (task : addr) : Assertion :=
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ "event_mode") # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ "exstatus") # Int |->_ **
  &(task # "TaskDescriptor" ->ₛ "Done") # Ptr |->_.

(**
  [has_permission_task_descriptor task old_stat] 是当前验证配置下完整
  TaskDescriptor 的初始化权限视图。

  参数：

  - [task]：新分配的 [struct TaskDescriptor] 地址；
  - [old_stat]：初始化前 [task_dync_sched_member.stat] 中保存的字节。
    [KTaskStatSetAsInit] 会读取该旧值并保留其高位，因此该字段不能用
    未初始化权限表示。对已经由 [memset] 清零的新任务，该参数应
    实例化为 [0]。

  该谓词组合以下互不重叠的内存区域：

  - [task_base_info] 的名字数组和五个标量字段；
  - [task_dync_sched_member] 的六个调度标量字段及 [sched_link]；
  - [task_dync_sched_member.delay] 指针槽；
  - [task->link] 管理链表节点；
  - [task->id] 的 ID 值与嵌入式链表节点；
  - 五组 TaskDescriptor 直接成员。

  注意：[has_permission_task_sched_member] 的定义末尾已经包含
  [has_permission_sched_link task]。因此这里不能再额外分离合取一次
  [has_permission_sched_link task]；重复拥有相同两个指针槽会使断言
  不可满足。
*)
Definition has_permission_task_descriptor
    (task : addr)
    (old_stat : Z) : Assertion :=
  has_permission_ktask_base_info task **
  has_permission_task_sched_member task old_stat **
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
    # Ptr |->_ **
  has_permission_task_link task **
  has_permission_idnode (&(task # "TaskDescriptor" ->ₛ "id")) **
  has_permission_task_direct_member task.

(**
  [TASK_MEM_SIZE] 是当前 32 位验证配置下
  [struct TaskDescriptor] 占用的总字节数。

  该数值来自对 [annotated_C/src/headers/m_ktask.h] 的 32 位 C 布局
  检查：指针宽度为 4 字节，结构体对齐为 4 字节，最后一个 [Done]
  指针位于偏移 116，因此结构体总大小为 120 字节。
*)
Definition TASK_MEM_SIZE : Z := 120.

(**
  [ktask_descriptor_field_offset_ok p] 描述当前 32 位验证配置下
  [struct TaskDescriptor] 的全部叶子字段地址与结构体首地址 [p] 之间的
  对应关系。按值嵌入的 [TaskDyncSchedMember]、[TaskBaseInfo]、
  [SysDoubleLinklistNode] 和 [IdNode] 会继续展开到基本整数或指针字段；
  指针指向的外部对象不属于 [TaskDescriptor] 内存，因此不继续展开。

  参数：
  - [p]：C 中 [struct TaskDescriptor *] 指向的结构体首地址。

  各等式严格按照 C 字段顺序排列，并使用 [(p + 数字)] 直接记录当前
  字段相对于结构体首地址的绝对字节偏移。C 对齐填充没有可取地址的
  字段，只通过下面三处数字偏移的跳跃表示：

  - [cur_prio] 后的 1 字节；
  - [origin_prio] 后的 3 字节；
  - [id.id] 后的 2 字节。

  [name] 是 32 个 [char] 的数组；本命题记录该数组字段的首地址，
  具体元素地址可在需要时由数组首地址和元素下标推导。

  最后的等式记录 QCP 抽象结构体大小。这样不需要用全局公理绕过布局
  条件。整个命题只描述纯地址关系，不拥有 [TaskDescriptor] 或其成员
  的任何内存资源。
*)

Definition ktask_descriptor_field_offset_ok (p : addr) : Prop :=
  &(p # "TaskDescriptor" ->ₛ "stack_point") = (p + 0) /\

  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member") = (p + 4) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "stat") = (p + 4) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "advance_cnt") = (p + 5) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") = (p + 6) /\
  (* padding *)
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "origin_timeslice") = (p + 8) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "rest_timeslice") = (p + 12) /\

  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") = (p + 16) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link" .ₛ "node_next") = (p + 16) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link" .ₛ "node_prev") = (p + 20) /\

  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "bitmap_column") = (p + 24) /\
  &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") = (p + 28) /\

  &(p # "TaskDescriptor" ->ₛ "task_base_info") = (p + 32) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name") = (p + 32) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_entry") = (p + 64) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "func_param") = (p + 68) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "origin_prio") = (p + 72) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_depth") = (p + 76) /\
  &(p # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "stack_start") = (p + 80) /\

  &(p # "TaskDescriptor" ->ₛ "event_id_trigger") = (p + 84) /\
  &(p # "TaskDescriptor" ->ₛ "event_mode") = (p + 88) /\
  &(p # "TaskDescriptor" ->ₛ "exstatus") = (p + 92) /\

  &(p # "TaskDescriptor" ->ₛ "link") = (p + 96) /\
  &(p # "TaskDescriptor" ->ₛ "link" .ₛ "node_next") = (p + 96) /\
  &(p # "TaskDescriptor" ->ₛ "link" .ₛ "node_prev") = (p + 100) /\

  &(p # "TaskDescriptor" ->ₛ "id") = (p + 104) /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "id") = (p + 104) /\

  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link") = (p + 108) /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link" .ₛ "node_next") = (p + 108) /\
  &(p # "TaskDescriptor" ->ₛ "id" .ₛ "link" .ₛ "node_prev") = (p + 112) /\

  &(p # "TaskDescriptor" ->ₛ "Done") = (p + 116) /\

  sizeof("TaskDescriptor") = TASK_MEM_SIZE.

(**
  [ktask_base_info_field_offset_ok base_info expected_addr] 折叠描述嵌入在
  [TaskDescriptor] 中的 [task_base_info] 及其字段地址。

  参数：
  - [base_info]：外层结构体中 [task_base_info] 字段的实际地址；
  - [expected_addr]：根据外层结构体首地址计算出的期望地址。

  第一个等式连接实际地址与期望地址，其余等式从 [base_info] 出发
  使用 [TaskBaseInfo] 的字段布局，并以 [expected_addr] 表示相对
  偏移。
*)

Definition ktask_base_info_field_offset_ok
    (base_info expected_addr : addr) : Prop :=
  base_info = expected_addr /\
  &(base_info # "TaskBaseInfo" ->ₛ "name") = (expected_addr + 0) /\
  &(base_info # "TaskBaseInfo" ->ₛ "func_entry") = (expected_addr + 32) /\
  &(base_info # "TaskBaseInfo" ->ₛ "func_param") = (expected_addr + 36) /\
  &(base_info # "TaskBaseInfo" ->ₛ "origin_prio") = (expected_addr + 40) /\
  &(base_info # "TaskBaseInfo" ->ₛ "stack_depth") = (expected_addr + 44) /\
  &(base_info # "TaskBaseInfo" ->ₛ "stack_start") = (expected_addr + 48).

(**
  [ktask_sched_link_field_offset_ok sched_link expected_addr] 折叠描述一个
  [SysDoubleLinklistNode] 嵌入字段及其两个指针叶子字段。

  [sched_link] 是嵌入字段的实际地址，[expected_addr] 是由其外层结构体
  计算出的期望地址。
*)
Definition ktask_sched_link_field_offset_ok
    (sched_link expected_addr : addr) : Prop :=
  sched_link = expected_addr /\
  &(sched_link # "SysDoubleLinklistNode" ->ₛ "node_next") = (expected_addr + 0) /\
  &(sched_link # "SysDoubleLinklistNode" ->ₛ "node_prev") = (expected_addr + 4).

(**
  [ktask_dync_sched_field_offset_ok dync_sched expected_addr] 折叠描述一个
  [TaskDyncSchedMember] 嵌入字段及其全部叶子字段。

  [dync_sched] 是嵌入字段的实际地址，[expected_addr] 是期望地址。
  内部 [sched_link] 的实际地址和期望地址继续传递给
  [ktask_sched_link_field_offset_ok]。
*)
Definition ktask_dync_sched_field_offset_ok
    (dync_sched expected_addr : addr) : Prop :=
  dync_sched = expected_addr /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "stat") = (expected_addr + 0) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "advance_cnt") = (expected_addr + 1) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "cur_prio") = (expected_addr + 2) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "origin_timeslice") = (expected_addr + 4) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "rest_timeslice") = (expected_addr + 8) /\
  ktask_sched_link_field_offset_ok
    (&(dync_sched # "TaskDyncSchedMember" ->ₛ "sched_link"))
    (expected_addr + 12) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "bitmap_column") = (expected_addr + 20) /\
  &(dync_sched # "TaskDyncSchedMember" ->ₛ "delay") = (expected_addr + 24).

(**
  [ktask_link_field_offset_ok link expected_addr] 折叠描述一个
  [SysDoubleLinklistNode] 嵌入字段及其两个指针叶子字段。
*)
Definition ktask_link_field_offset_ok
    (link expected_addr : addr) : Prop :=
  link = expected_addr /\
  &(link # "SysDoubleLinklistNode" ->ₛ "node_next") = (expected_addr + 0) /\
  &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") = (expected_addr + 4).

(**
  [ktask_id_node_offset_ok id_node expected_addr] 折叠描述一个 [IdNode]
  嵌入字段、其中的 [uint16 id] 和嵌入式 [link]。

  [id_node] 是实际地址，[expected_addr] 是期望地址。[id] 后的两字节
  C 对齐填充通过 [link] 的相对偏移 4 表示；[link] 的内部字段继续由
  [ktask_link_field_offset_ok] 描述。
*)
Definition ktask_id_node_offset_ok
    (id_node expected_addr : addr) : Prop :=
  id_node = expected_addr /\
  &(id_node # "IdNode" ->ₛ "id") = (expected_addr + 0) /\
  ktask_link_field_offset_ok
    (&(id_node # "IdNode" ->ₛ "link")) (expected_addr + 4).

(**
  [ktask_descriptor_field_offset_wf p] 是
  [ktask_descriptor_field_offset_ok p] 的结构化形式。

  它在顶层保留 [TaskDescriptor] 的直接叶子字段和总大小，并用上述
  五个局部命题折叠各个按值嵌入结构体的字段关系。该命题仍只描述纯
  地址关系，不拥有任何内存资源。
*)
Definition ktask_descriptor_field_offset_wf (p : addr) : Prop :=
  &(p # "TaskDescriptor" ->ₛ "stack_point") = (p + 0) /\

  ktask_dync_sched_field_offset_ok (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member")) (p + 4) /\

  ktask_base_info_field_offset_ok (&(p # "TaskDescriptor" ->ₛ "task_base_info")) (p + 32) /\

  &(p # "TaskDescriptor" ->ₛ "event_id_trigger") = (p + 84) /\
  &(p # "TaskDescriptor" ->ₛ "event_mode") = (p + 88) /\
  &(p # "TaskDescriptor" ->ₛ "exstatus") = (p + 92) /\

  ktask_link_field_offset_ok (&(p # "TaskDescriptor" ->ₛ "link")) (p + 96) /\

  ktask_id_node_offset_ok (&(p # "TaskDescriptor" ->ₛ "id")) (p + 104) /\

  &(p # "TaskDescriptor" ->ₛ "Done") = (p + 116) /\

  sizeof("TaskDescriptor") = TASK_MEM_SIZE.



































































  
(**
  该定理以 Rocq 证明结构化定义与原始平铺定义逻辑等价，防止两个定义
  在后续维护中无意产生不同的字段集合或偏移。
*)
Theorem ktask_descriptor_field_offset_wf_iff :
  forall p, ktask_descriptor_field_offset_wf p <->
    ktask_descriptor_field_offset_ok p.
Proof.
  intros p.
  unfold ktask_descriptor_field_offset_wf.
  unfold ktask_dync_sched_field_offset_ok.
  unfold ktask_sched_link_field_offset_ok.
  unfold ktask_base_info_field_offset_ok.
  unfold ktask_id_node_offset_ok.
  unfold ktask_link_field_offset_ok.
  unfold ktask_descriptor_field_offset_ok.
  csimpl.
  intuition lia.
Qed.
