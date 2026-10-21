Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Export CRTOS_Verify.lib.semaphore.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 全局统一协议在本次闭包需要的内存投影。等待节点的 payload 关联
    全局唯一 task map；不拥有 task 字段。未访问模块的内存由 frame 保留。
    此文件不声称给出整个 Cortex-M3 OS 的不变量。 *)
Definition pure_suspend_sched_link (T : addr -> option TaskDescriptorAbs)
    (link task : addr) : Assertion :=
  EX desc : TaskDescriptorAbs,
  “ T task = Some desc /\
    link = &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") /\
    desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ” && emp.
Definition critical_projection (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  semaphore_inv (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    sg.(os_semaphore_stable) st.(os_semaphores).

(** 真实 uint16 临界区计数槽独立于协议 token；可达 65535，允许 ++回绕。
    不把它作为逻辑嵌套深度，也不要求进入前等于零。 *)
Definition critical_nest (n : Z) : Assertion :=
  &("KTaskOsAssignLockNest") # UShort |-> n.
Definition critical_nest_inc (n : Z) : Z := (n + 1) mod 65536.
Definition critical_nest_dec (n : Z) : Z := if Z.leb 1 n then n - 1 else n.

(** nested保留外层token anchor；outer acquire建立当前观察的anchor。 *)
Definition critical_anchor (owned : bool) (anchor acquired : VarGlobalState) : VarGlobalState :=
  if owned then anchor else acquired.
Definition critical_nest_roundtrip (n : Z) : Z :=
  critical_nest_dec (critical_nest_inc n).

(** 非SMP静态 KTaskOsAssignLockNest 的BSS初值为0。此owner在启动期
    属于初始化者，逻辑安装全局invariant时一并交出；不是普通运行时入口。 *)
Definition critical_initial_resources (sg : StableGlobalState) : Assertion :=
  semaphore_static_resources sg.(os_semaphore_stable) ** critical_nest 0.

(** 具体静态heap到投影的待证折叠接口；不会凭空创造IRQ观察或token。
    调用该接口需要先有真实启动上下文，并使共享纯状态的sem部分为空。 *)
Definition critical_projection_initialization_obligation : Prop :=
  forall sg st,
    st.(os_semaphores) = semaphore_initial_state ->
    critical_initial_resources sg |--
    critical_projection sg st ** critical_nest 0.

(** 逻辑安装前的boot package同时持有实际IRQ上下文和初始heap。
    安装动作须消费heap并登记至同一个全局协议invariant；它不是可由
    heap entailment证明的普通C操作，也不从BSS零值推断PRIMASK=0。
    本轮目标入口假定该系统级安装已完成，未声称本轮证明启动代码。 *)
Definition critical_bootstrap_package (initial_mask : Z)
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ st.(os_semaphores) = semaphore_initial_state ” &&
  OutsideCriticalIRQ initial_mask sg st ** critical_initial_resources sg.
