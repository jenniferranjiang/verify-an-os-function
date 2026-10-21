Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Sorted.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.

Require Import CRTOS_Verify.lib.dll_abs.
Require Export CRTOS_Verify.lib.TickOrder.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.

(**
  [TaskDelayAbs] 是 C 结构体 [struct Delay] 的纯抽象状态。

  字段对应关系：

  - [tdTaskPtr] 对应 [Delay.task]，保存被延时任务的描述符地址；
  - [tdTicks] 对应 [Delay.ticks]，保存 32 位无符号绝对到期 tick；
  - [tdStatus] 对应 [Delay.status]，当前有效状态为 inactive/active。

  该记录不拥有内存，也不包含侵入式双链表的前后指针；具体 payload
  所有权由 [store_delay_info] 提供，链表指针由相应的 DLL owner 提供。
  把这个公共抽象放在正式低层模块中，使 Global State、全局不变量和
  KTask delay 函数验证共享同一类型，而不会形成对高层函数证明的反向依赖。
*)
Record TaskDelayAbs : Type := mkTaskDelayAbs {
  tdTaskPtr : addr;
  tdTicks : Z;
  tdStatus : Z
}.

(** 与 C 宏分离命名，避免 QCP 预处理常量与 Rocq 标识符冲突。 *)
Definition TASK_DELAY_INACTIVE_VALUE : Z := 0.
Definition TASK_DELAY_ACTIVE_VALUE : Z := 1.

(**
  [heartbeat_ticks_addr] 是 [tick.c] 内部链接全局变量
  [heartbeat_ticks] 的逻辑地址。它不创建新的 C 存储对象；正式稳定
  Global State 的 [os_tick_ptr] 必须与这个地址相等。
*)
Definition heartbeat_ticks_addr : addr := &("heartbeat_ticks").

(**
  [delay_nodes_wf] 描述 active delay DLL 的公共纯不变量：任意前后两项
  满足回绕次序，且每个 payload 都是 active。StronglySorted 避免把
  半区间比较误当成全域传递序。字段范围由 typed store 保证。
  新节点能否与旧列表共同比较，由调用点的时间窗口条件另外约束。
  此为 Stage 1 修订；旧数值排序证明尚不能作为本定义的验证证据。
*)
Definition delay_nodes_wf (nodes : list (DL_Node TaskDelayAbs)) : Prop :=
  StronglySorted tick_not_after
    (map (fun node => (getData node).(tdTicks)) nodes) /\
  Forall
    (fun node => (getData node).(tdStatus) = TASK_DELAY_ACTIVE_VALUE)
    nodes.
