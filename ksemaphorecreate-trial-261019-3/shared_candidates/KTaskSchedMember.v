Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import TrialShared.CrtosRules.
Require Export CRTOS_Verify.lib.KTaskPure.
Require Export TrialShared.TaskStatusMemory.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(**
  [has_permission_sched_link task] 拥有嵌入式
  [DoubleLinklistType] 节点的 [node_prev] 和 [node_next] 两个可写指针槽。

  参数 [task] 是外围 [TaskDescriptor] 的地址。谓词用与 C 表达式
  [task->task_dync_sched_member.sched_link.node_prev/node_next] 相同的直接
  嵌套字段路径描述节点。该谓词只提供调用
  [InitDoubleLinkList] 所需的未初始化写权限，不拥有外围调度结构的任何
  标量字段，也不对旧指针值作出承诺。
*)
Definition has_permission_sched_link
           (task : addr) : Assertion :=
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link" .ₛ "node_prev") # Ptr |->_ **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link" .ₛ "node_next") # Ptr |->_.

(**
  [store_task_sched_member sched_link sched_info] 从嵌入式链表节点地址
  恢复外围
  [TaskDescriptor] 地址，再用与 C 相同的嵌套字段路径拥有动态调度成员。

  参数：
  - [sched_link]：外围结构中 [sched_link] 字段的地址；
  - [sched_info]：六个非链表、非 [delay] 调度字段的抽象值。

  该谓词拥有 [stat]、[advance_cnt]、[cur_prio]、
  [origin_timeslice]、[rest_timeslice] 和 [bitmap_column]。当前 32 位
  验证模型按照项目已有约定，用 [UInt] 描述两个 [x_ubase] 时间片字段。
  它不拥有 [sched_link.node_prev/node_next]，也完全不拥有 [delay]。
  方案2在所有任务状态下都由 [store_task_descriptor] 持有本谓词；
  调度 DLL 的稳定 payload 只保存纯地址关联。锁内可从 task_inv 局部
  取出本谓词读写，随后归还对应 descriptor，而不随节点迁移。
*)
Definition store_task_sched_member
           (sched_link : addr)
           (sched_info : TaskSchedMemberAbs) : Assertion :=
  EX task : addr,
    “ sched_link =
        &(task # "TaskDescriptor" ->ₛ
          "task_dync_sched_member" .ₛ "sched_link") ” &&
    store_task_status
      &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "stat")
      sched_info.(tsmStat) **
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "advance_cnt")
      # UChar |-> sched_info.(tsmAdvanceCnt) **
    &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")
      # UChar |-> sched_info.(tsmCurPrio) **
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "origin_timeslice")
      # UInt |-> sched_info.(tsmOriginTimeslice) **
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "rest_timeslice")
      # UInt |-> sched_info.(tsmRestTimeslice) **
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "bitmap_column")
      # UInt |-> sched_info.(tsmBitmapColumn).

(**
  [has_permission_task_sched_member task old_stat] 汇总
  [_KTaskDyncMemberInit] 对动态调度成员所需的输入所有权。

  [advance_cnt]、[cur_prio]、[origin_timeslice]、[rest_timeslice] 和
  [bitmap_column] 都会在读取前被覆盖，所以只需要未初始化可写权限；
  [sched_link] 的权限复用 [has_permission_sched_link]。

  参数 [task] 是外围 [TaskDescriptor] 的地址。谓词使用与 C 表达式完全
  相同的嵌套字段路径计算各字段地址，可直接向符号执行暴露局部资源。
  不能先计算中间 [TaskDyncSchedMember] 地址再二次取字段，因为 QCP 的
  不透明字段地址函数不会把该形式与直接嵌套路径视为定义相等。

  [stat] 是例外：[KTaskStatSetAsInit] 会读取旧状态并保留其高五位，因此
  这里通过 [store_task_status] 保留已初始化字节，不能降为未初始化权限。
  参数 [old_stat] 只表示语义状态；高五位保存在局部 raw 见证中，
  不进入全局抽象记录。具体 RMW 保留高位的事实由表示层引理给出。

  该谓词不拥有 [delay]，也不拥有 [TaskDescriptor] 中的基础信息或
  [exstatus]；这些资源由函数规格中的现有谓词或局部字段断言单独提供。
*)
Definition has_permission_task_sched_member
           (task : addr)
           (old_stat : TaskStatus) : Assertion :=
  store_task_status
    &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "stat") old_stat **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "advance_cnt")
    # UChar |->_ **
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")
    # UChar |->_ **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "origin_timeslice")
    # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "rest_timeslice")
    # UInt |->_ **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "bitmap_column")
    # UInt |->_ **
  has_permission_sched_link task.
