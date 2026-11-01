Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.DelayInv.
Import ListNotations DLL.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** KTaskUnSetDelay 的调用者局部视图，复用 Delay 的状态与内存表示。
    NULL、已有 inactive、在延时 DLL 中的 active 对应真实三个分支。
    此类型不是新的 Delay 状态；prefix/suffix 仅记录本次摘链的上下文。
    原 annotated_C 的具名规格及其 body 展开使用此接口，但原 libai 源文件
    在当前工程中不存在；这里按该展开与真实 C 恢复接口，接受独立设计审阅。 *)
Inductive vDelayView : Type :=
| vDelayNull
| vDelayInactive (delay : addr) (info : TaskDelayAbs)
| vDelayActive (delay : addr) (info : TaskDelayAbs)
    (prefix suffix : list (DL_Node TaskDelayAbs)).

(** 调用者借出的 task.delay 指针槽及被访问的 Delay 内存。
    inactive 分支只读 status，因此本局部接口不取得其自环 link；这些
    未触达 link 继续由 caller 持有。active 分支借出完整延时 DLL，
    包括目标的 payload 和 link；task 的其他字段均留在 caller frame。
    纯条件沿用原 body 的展开：目标属于 task、ACTIVE，删除后序列良构。
    不从这个局部视图声称拥有全局 delay_inv 或全系统临界区资源。 *)
Definition store_ktask_unset_delay_pre (task : addr) (view : vDelayView)
    : Assertion :=
  match view with
  | vDelayNull =>
      &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
        # Ptr |-> 0
  | vDelayInactive delay info =>
      “ delay <> 0 /\ info.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
      &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
        # Ptr |-> delay **
      store_delay_info (&(delay # "Delay" ->ₛ "link")) info
  | vDelayActive delay info prefix suffix =>
      “ delay <> 0 /\ info.(tdTaskPtr) = task /\
        info.(tdStatus) = TASK_DELAY_ACTIVE_VALUE /\
        delay_nodes_wf (prefix ++ suffix) ” &&
      &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
        # Ptr |-> delay **
      store_dll store_delay_info &("xiaoshan_delay_head")
        (prefix ++ Build_DL_Node info (&(delay # "Delay" ->ₛ "link")) :: suffix)
  end.

(** NULL 与 inactive 不改资源；active 摘除目标 link 并置 status=0，
    返回剩余 DLL 和目标的 payload、自环 link。task.delay、ticks、task
    字段及其他节点内容保持；目标没有被释放。此后 caller 可把目标重新
    纳入既有 delay_inv 的 inactive map，相关组合义务不作为已证明事实。 *)
Definition store_ktask_unset_delay_post (task : addr) (view : vDelayView)
    : Assertion :=
  match view with
  | vDelayActive delay info prefix suffix =>
      “ delay <> 0 /\ info.(tdTaskPtr) = task /\
        info.(tdStatus) = TASK_DELAY_ACTIVE_VALUE /\
        delay_nodes_wf (prefix ++ suffix) ” &&
      &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")
        # Ptr |-> delay **
      store_dll store_delay_info &("xiaoshan_delay_head") (prefix ++ suffix) **
      store_delay_info (&(delay # "Delay" ->ₛ "link"))
        (mkTaskDelayAbs info.(tdTaskPtr) info.(tdTicks) TASK_DELAY_INACTIVE_VALUE) **
      store_node_self_linked (&(delay # "Delay" ->ₛ "link"))
  | _ => store_ktask_unset_delay_pre task view
  end.
