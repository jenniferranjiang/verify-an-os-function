Require Import CRTOS_Verify.lib.idnode_abs CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.lib.KTaskSchedMember.
Require Import CRTOS_Verify.lib.CrtosGlobState CRTOS_Verify.lib.dll.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import ListNotations DLL.
Local Open Scope Z_scope.
Local Open Scope string_scope.

Module CrtosBorrowedRep.
Import CRTOS_Verify.lib.CrtosRules.Task_C_Rules.
Local Open Scope sac.

(** semaphore 所需的 task 模块借用视图。exstatus 由 Obtain/ResumeAll 使用；
    调度标量复用共享 store_task_sched_member，供 pending 排序与跨模块迁移。
    本视图不拥有 task 的 ID、registry link、栈、base-info、delay；这些仍由
    各自模块 owner 保留在 slice 之外。sched_link 由 ready/pending/其他容器
    唯一拥有，所以这里明确不含其两个指针槽。 *)
Definition store_task_semaphore_view (task : addr) (desc : TaskDescriptorAbs)
    : Assertion :=
  store_task_sched_member
    (&(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))
    desc.(tdSchedMember) **
  &(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus).

(** 从同一个 task_desc_map 借用可被 semaphore 访问的字段；没有另建 task state。
    map 外任务不出借资源；外部 task owner 不能同时持有这些借出字段。 *)
Definition store_task_semaphore_views (tasks : VarGlobalState) : Assertion :=
  store_map store_task_semaphore_view tasks.(task_desc_map).

(** 一个 ready 队列只拥有其链表头和 TaskDescriptor 的 sched_link；
    不重复借用 task 字段，pending 队列也不拥有这些 ready 成员。 *)
Definition store_scheduler_queue (base index : addr) (tasks : list addr)
    : Assertion :=
  store_dll (fun _ _ => emp)
    (base + index * sizeof("SysDoubleLinklistNode"))
    (map semaphore_pending_node tasks).

(** 非 SMP 调度模块在当前 slice 借出的内存。Assign 的32个 ready heads、
    bitmap/highest-prio 缓存、running 指针、done 指针、priority 与尾padding
    都各自只有一个 owner；独立的 KTaskOsAssignLockNest 是唯一被 create 改写者。
    ready_vector_done 的指针槽归这里，其指向的只读表保持在调度模块外部 owner。
    当前Assign布局为276字节，current_priority偏移272，尾部3字节不假定值。 *)
Definition store_scheduler_view (s : SchedulerState) : Assertion :=
  let assign := &("Assign") in
  let ready := &(assign # "Assign" ->ₛ "os_assign_ready_vector") in
  let vectors := &(ready # "OsAssignReadyVector" ->ₛ "priority_ready_vector") in
  &("KTaskOsAssignLockNest") # UShort |-> s.(scheduler_lock_nest) **
  store_array store_scheduler_queue vectors 32 s.(scheduler_ready) **
  &(ready # "OsAssignReadyVector" ->ₛ "priority_ready_group") # UInt
    |-> s.(scheduler_ready_group) **
  &(ready # "OsAssignReadyVector" ->ₛ "highest_prio") # UInt
    |-> s.(scheduler_highest_priority) **
  &(assign # "Assign" ->ₛ "os_running_task") # Ptr |-> s.(scheduler_running) **
  (EX done : addr, &(assign # "Assign" ->ₛ "ready_vector_done") # Ptr |-> done) **
  &(assign # "Assign" ->ₛ "current_priority") # UChar
    |-> s.(scheduler_current_priority) **
  CharArray.undef_full (&("Assign") + 273) 3.
End CrtosBorrowedRep.

Import Crtos_C_Rules.
Local Open Scope sac.

(** 该 OS invariant 是 semaphore 验证切片的不变量：完整 semaphore 模块，
    及 task/scheduler 借出的确切资源，全部经过同一个 OS carrier。
    它不冒充包含 task 栈、timer/delay、zombie 或其他 IPC 模块的完整 OS heap。
    未借出的模块资源继续由外部模块 frame 拥有，create 不访问或转移它们。 *)
Definition SemaphoreOSInvariant (sg : CrtosOSStable) (s : CrtosOSState) : Assertion :=
  “ CrtosOSValid s ” &&
  OSHeap (CrtosBorrowedRep.store_task_semaphore_views s.(os_tasks)) **
  OSHeap (CrtosBorrowedRep.store_scheduler_view s.(os_scheduler)) **
  OSHeap (store_semaphore sg.(os_sem_stable) s.(os_semaphores)).

(** 借用接口可直接取得同一heap所解释的纯有效性，不生成第二份invariant。 *)
Lemma SemaphoreOSInvariant_valid : forall sg state,
  SemaphoreOSInvariant sg state |--
  “ CrtosOSValid state ” && SemaphoreOSInvariant sg state.
Proof. intros; unfold SemaphoreOSInvariant; entailer!. Qed.
