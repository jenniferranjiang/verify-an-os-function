Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.lib.KTaskParseInfo.
Require Import CRTOS_Verify.lib.KTaskSchedMember.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.

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
  [Crtos_C_Rules] 实例 [TaskIDNode] 上提供符合 TaskDescriptor 命名
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
  - [old_stat]：初始化前的 TaskStatus；底层字节由 store_task_status 保证可读。
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
    (old_stat : TaskStatus) : Assertion :=
  has_permission_ktask_base_info task **
  has_permission_task_sched_member task old_stat **
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
    # Ptr |->_ **
  has_permission_task_link task **
  has_permission_idnode (&(task # "TaskDescriptor" ->ₛ "id")) **
  has_permission_task_direct_member task.


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
